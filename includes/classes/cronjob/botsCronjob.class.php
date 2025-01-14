<?php

#fleetarray, for flexible fleet chooser
#number of bots, for flexible bot number
#flexible time period(monthly intended)
#factor for shps?
#
/** @package 2Moonsbots
 *  @author mimikri <pocco_13@yahoo.de>
 *  @licence MIT
 *  @version 0.1 */
require_once 'includes/classes/cronjob/CronjobTask.interface.php';
class botsCronjob implements CronjobTask
{
    public function run(): void
    {
        $db = Database::get();
        $first_player_points = $db->select('select total_points from '. DB_PREFIX .'statpoints where stat_type = 1 and total_rank = 1')[0]['total_points'];
        $bot_setting = $db->select('select * from '. DB_PREFIX .'bot_setting');
        foreach ($bot_setting as $key => $value) {
            $bot_setting[$key]['ships_array'] = unserialize($value['ships_array']);
        }
        #---------------------------once(every 2592000 seconds)-----------------------------------------
        #making it monthly gives some time to react if errors in the universe happend, like first player point very high, also it makes it easyer to determine how much ress comes into the uni, it's mainly for measurement reasons
        if ($bot_setting[0]['last_set'] + 2592000 < time()) { //since they shall start synced, [0] is representative
            foreach ($bot_setting as $key => $bot_setting1) {

                $number_of_bots = count($db->select('select id as number_of_bots from '. DB_PREFIX .'bots where bot_type = :id_botsetting', [':id_botsetting' => $bot_setting1['id']]));
                $number_of_bots_factor = $number_of_bots == 0 ? 0 : (1 / $number_of_bots);
                $month_in_seconds = 2592000;
                $monthly_resspoints = $first_player_points * $bot_setting1['first_points_multiplicator'];
                $monthly_resspoints_for_ships = $monthly_resspoints * (1 - $bot_setting1['ress_factor']); #1-ressfactor is the factor for the ships
                #$ress_for_each_ship_type = ($monthly_resspoints_for_ships / count($bot_setting1['ships_array']));
                $montly_resspoints_for_ress = $monthly_resspoints * $bot_setting1['ress_factor'];
                $real_resspoints_for_ships = 0;
                foreach ($bot_setting1['ships_array'] as $key => $ship) {
                    $ship_contingent_temp = ((($monthly_resspoints_for_ships * $ship['factor'] * $number_of_bots_factor) / $ship['shipvalue'])); #monthly available ships for each botfleet, factor reduces the ress dedicated to each shiptype
                    $montly_resspoints_for_ress += floor(($monthly_resspoints_for_ships * $ship['factor'] * $number_of_bots_factor) - ($ship_contingent_temp * $ship['shipvalue']));
                    $bot_setting1['ships_array'][$key]['per_second'] = $ship_contingent_temp <= 0 ? 0 : ($ship_contingent_temp / $month_in_seconds);
                    $bot_setting1['ships_array'][$key]['contingent'] = $ship_contingent_temp * $number_of_bots;
                    $bot_setting1['ships_array'][$key]['contingent_used'] = 0;
                    $real_resspoints_for_ships += $bot_setting1['ships_array'][$key]['contingent'] * $ship['shipvalue'];
                }
                $montly_resspoints_for_ress += ($monthly_resspoints_for_ships - $real_resspoints_for_ships);#the monthly resspoits differ a liitle bit from the original, cause of rounding errors?
                $db->update(
                    'update '. DB_PREFIX .'bot_setting set 
                    metal_per_second = :metal_per_second, 
                    crystal_per_second = :crystal_per_second, 
                    deuterium_per_second = :deuterium_per_second , 
                    last_set = :last_set , 
                    `ress_contingent` = :ress_contingenta ,
                    `ress_ships_contingent` = :ress_ships_contingent ,
                    `full_contingent` = :full_contingenta , 
                    `ships_array` = :ships_array , 
                    `ress_contingent_used` = 0 ,
                    `ress_ships_contingent_used` = 0 , 
                    `full_contingent_used` = 0 ,
                    `number_of_bots` = :number_of_bots
                    where id = :bot_type',
                    [
                        ':metal_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_metal']) / $month_in_seconds) * $number_of_bots_factor,
                        //per second per bot
                        ':crystal_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_crystal']) / $month_in_seconds) * $number_of_bots_factor,
                        ':deuterium_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_deuterium']) / $month_in_seconds) * $number_of_bots_factor,
                        ':ress_contingenta' => $montly_resspoints_for_ress,
                        ':ress_ships_contingent' => $real_resspoints_for_ships,
                        ':full_contingenta' => $monthly_resspoints,
                        ':ships_array' => serialize($bot_setting1['ships_array']),
                        ':bot_type' => $bot_setting1['id'],
                        ':number_of_bots' => $number_of_bots,
                        ':last_set' => time(),
                    ]
                );
            }
        } else {

            #--------------------------------handling fleet activity--------------------------------------------------
            $active_fleets = $db->select('select * from '. DB_PREFIX .'bots where next_fleet_action < :next_fleet_action', [':next_fleet_action' => time()]);

            foreach ($active_fleets as $key => $value) {
                #give fleet to bot, since last time
                $bots_ships_array = unserialize($value['ships_array']);
                if ($value['action_index'] == 0) { #landing, give fleet to planet
                    #get planet ids
                    $planet_ids     = $db->select('select id, metal, crystal, deuterium from '. DB_PREFIX .'planets where id_owner = :id_owner and planet_type = 1', [':id_owner' => $value['owner_id']]);
                    $planetindex    = floor(random_int(0, count($planet_ids) - 1));
                    $new_planet_id  = $planet_ids[$planetindex]['id']; #random new planet of userplanets to land on next
                    $planet_ress    = ['metal' => $planet_ids[$planetindex]['metal'], 'crystal' => $planet_ids[$planetindex]['crystal'], 'deuterium' => $planet_ids[$planetindex]['deuterium']];
                    $nextaction     = random_int($bot_setting[$value['bot_type']]['min_fleet_seconds_on_planet'], $bot_setting[$value['bot_type']]['max_fleet_seconds_on_planet']); #time till lift of
                    $timebonus_till_next_action = (time() - ((time() - $value['next_fleet_action']) < 600 ? $value['next_fleet_action'] : time())) + $nextaction;#seconds since next_fleet_action timestamp + time to stay till lift off
                    $address = ['metal' => ($value['ress_bonus_time'] * $bot_setting[$value['bot_type']]['metal_per_second']), 'crystal' => ($value['ress_bonus_time'] * $bot_setting[$value['bot_type']]['crystal_per_second']), 'deuterium' => ($value['ress_bonus_time'] * $bot_setting[$value['bot_type']]['deuterium_per_second'])];
                    
                    $ress_contingent_used = $address['metal'] + $address['crystal'] + $address['deuterium'];
                    $bot_setting[$value['bot_type']]['full_contingent_used'] += $ress_contingent_used;
                    $sql_planet = '';
                    #add ships
                    foreach ($bot_setting[$value['bot_type']]['ships_array'] as $key => $ship) {
                        if (!isset($bots_ships_array[$ship['name']])) {
                            $bots_ships_array[$ship['name']] = ['bonus_time' => 0, 'name' => $ship['name'], 'amount' => 0];
                        }
                        $build_amount = floor($ship['per_second'] * $bots_ships_array[$ship['name']]['bonus_time']);
                        $rest_time = $bots_ships_array[$ship['name']]['bonus_time'] - ($build_amount / $ship['per_second']);
                        $sql_planet .= '`'. $ship['name'] . '` = ' .'(`'. $ship['name'] . '` + ' . $build_amount + $bots_ships_array[$ship['name']]['amount'] . ') , ';
                        $bots_ships_array[$ship['name']]['amount'] = 0;#cause all fleet will be on planet and not in bot array
                        $bots_ships_array[$ship['name']]['bonus_time'] = $rest_time + $timebonus_till_next_action;
                        $bot_setting[$value['bot_type']]['ships_array'][$ship['name']]['contingent_used'] = $bot_setting[$value['bot_type']]['ships_array'][$ship['name']]['contingent_used'] + $build_amount;
                        $bot_setting[$value['bot_type']]['full_contingent_used'] += $build_amount * $ship['shipvalue'];
                        $bot_setting[$value['bot_type']]['ress_ships_contingent_used'] += $build_amount * $ship['shipvalue'];
                    }

                    #update bot
                    $db->update('update '. DB_PREFIX .'bots set next_fleet_action = :next_fleet_action , stationed_planet_id = :stationed_planet_id, action_index = 1 , ships_array = :ships_array, `ress_bonus_time` = :ress_bonus_time where id = :id', [
                        ':next_fleet_action' => time() + $nextaction,
                        ':ships_array' => serialize($bots_ships_array),
                        ':ress_bonus_time' => $timebonus_till_next_action,
                        #
                        ':stationed_planet_id' => $new_planet_id,
                        ':id' => $value['id'],
                    ]);
                    #update planet
                    $db->update('update '. DB_PREFIX .'planets set ' . $sql_planet . ' `metal` = :metal , `crystal` = :crystal , `deuterium` = :deuterium where id = :id', [':metal' => $address['metal'] + $planet_ress['metal'], ':crystal' => $address['crystal'] + $planet_ress['crystal'], ':deuterium' => $address['deuterium'] + $planet_ress['deuterium'], ':id' => $new_planet_id]);
                    #report to the contingentcounter
                    $db->update('update '. DB_PREFIX .'bot_setting set ships_array = :ships_array , full_contingent_used = :full_contingent_used, ress_ships_contingent_used = :ress_ships_contingent_used, ress_contingent_used = ress_contingent_used + :ress_contingent_used where id = :bot_type', [':ships_array' => serialize($bot_setting[$value['bot_type']]['ships_array']), ':ress_contingent_used' => $ress_contingent_used, ':full_contingent_used' => $bot_setting[$value['bot_type']]['full_contingent_used'], ':ress_ships_contingent_used' => $bot_setting[$value['bot_type']]['ress_ships_contingent_used'], ':bot_type' => $value['bot_type']]);
                } else { #lifting, take fleet from planet , exept c22
                    $fleet_select_sql = '';
                    $fleet_delete_sql = '';
                    #prepate sql to get fleet from planet
                    foreach ($bot_setting[$value['bot_type']]['ships_array'] as $key => $ship) {
                        if ($ship['leave_on_planet'] == 0) {
                            $fleet_select_sql .= $ship['name'] . ' , ';
                            $fleet_delete_sql .= $ship['name'] . ' = 0 , ';                         
                        }else{//leave % of the ships on the planet, not good cause users can determine the size of the fleet like that, best set to 1
                            $fleet_select_sql .= '('. $ship['name'] . ' * '. (1 - $ship['leave_on_planet']) . ') as ' . $ship['name'] . ' , ';
                            $fleet_delete_sql .= $ship['name'] . ' = (' . $ship['name'] . ' * '. $ship['leave_on_planet'] . ') , ';
                        }

                    }

                    #get fleetamounts on planet
                    $fleet = $db->select('select ' . $fleet_select_sql . ' id from '. DB_PREFIX .'planets where id = :planetid', [':planetid' => $value['stationed_planet_id']]);
                    #take fleet from planet
                    $db->update('update '. DB_PREFIX .'planets set ' . $fleet_delete_sql . ' id = id  where id = :id', [':id' => $value['stationed_planet_id']]);
                    $nextaction = random_int($bot_setting[$value['bot_type']]['min_fleet_seconds_in_space'], $bot_setting[$value['bot_type']]['max_fleet_seconds_in_space']); #seconds/time of fly time before next land
                    $timebonus_till_next_action = (time() - ((time() - $value['next_fleet_action']) < 600 ? $value['next_fleet_action'] : time())) + $nextaction;#prevent big payout by limiting overhang time to max x seconds
                    #get ships to put back to fleet and bonus time  
                    foreach ($bot_setting[$value['bot_type']]['ships_array'] as $key => $ship) {
                        if (!isset($bots_ships_array[$ship['name']])) {
                            $bots_ships_array[$ship['name']] = ['bonus_time' => 0, 'name' => $ship['name'], 'amount' => 0];
                        }
                        $bots_ships_array[$ship['name']]['amount'] = $fleet[0][$ship['name']] ?? 0;
                        $bots_ships_array[$ship['name']]['bonus_time'] += $timebonus_till_next_action;
                    }
                    #put ships 
                    $db->update('update '. DB_PREFIX .'bots set next_fleet_action = :next_fleet_action , ships_array = :ships_array,action_index = 0 ,  `ress_bonus_time` = :ress_bonus_time where id = :id', [':next_fleet_action' => $nextaction + time(), ':ships_array' => serialize($bots_ships_array), ':ress_bonus_time' => $timebonus_till_next_action + $value['ress_bonus_time'], ':id' => $value['id']]);
                }
            }
        }
    }
}
