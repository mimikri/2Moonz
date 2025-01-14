<?php
if (!allowedTo(str_replace(array(dirname(__FILE__), '\\', '/', '.php'), '', __FILE__))) throw new Exception("Permission error!");

function ShowEditBotsPage()
{
    echo '<div id="botedit_wrapper"><div class="botheader"><button onclick="location.href = \'admin.php?page=EditBots\'">show bots contingents</button>
    <button onclick="location.href = \'admin.php?page=EditBots&mode=show_all_bots\'">show bots</button> 
    <button onclick="location.href = \'admin.php?page=EditBots&mode= show_edit_bot_types\'">edit bot types</button>
    <button onclick="location.href = \'admin.php?page=EditBots&mode=show_edit_bot_users\'">edit bots</button>
    <button onclick="location.href = \'admin.php?page=EditBots&mode=show_edit_bot_planets\'">edit bot planets</button>
    <button onclick="location.href = \'admin.php?page=EditBots&mode=show_create_bot\'">create bots</button></div>
    <hr>
   <link rel="stylesheet" type="text/css" href="./styles/theme/admin.css?v={$REV}">';
    include_once('includes/classes/class.BotManager.php');
$botManager = new BotManager();
// $botManager->setBotTypes($_POST);
// $botManager->setOnAllPlanets($_POST['elementid'], $_POST['elemval']);
// $botManager->setShipFactor($_POST['bot_type'], $_POST['ship'], $_POST['factor']);
// $botManager->ressToAllPlanets($_POST['metal'], $_POST['crystal'], $_POST['deuterium']);
// $botManager->createBaseBotTypeConfig();
// $botManager->createBotFleetArrays();
// $botManager->createBotPlanets();
// $botManager->createShip($_POST['bot_type'], $_POST['ship'], $pricelist);
// $botManager->createBotType();
// $botManager->createBot();
// $botManager->deleteAllElementsFromBotPlanets();
// $botManager->deleteShip($_POST['bot_type'], $_POST['ship']);
// $botManager->deleteBotFleets();
// $botManager->deleteBot();
    if (isset($_GET['mode'])) {
        if ($_GET['mode'] == 'ress_to_all_planets') {
            //ress_to_all_planets();
            $botManager->ressToAllPlanets($_POST['metal'], $_POST['crystal'], $_POST['deuterium']);
        } elseif ($_GET['mode'] == 'set_on_all_planets') {
           //set_on_all_planets();
           $botManager->setOnAllPlanets($_POST['elementid'], $_POST['elemval']);
        } elseif ($_GET['mode'] == 'create_bot_planets') {
            //create_bot_planets();
            $botManager->createBotPlanets();
        } elseif ($_GET['mode'] == 'delete_all_elements_from_bot_planets') {
            //delete_all_elements_from_bot_planets();
            $botManager->deleteAllElementsFromBotPlanets();
        } elseif ($_GET['mode'] == ' show_edit_bot_types') {
            show_edit_bot_types();

        } elseif ($_GET['mode'] == 'show_all_bots') {
            show_all_bots();
        } elseif ($_GET['mode'] == 'set_bot_types') {
            //set_bot_types();
            $botManager->setBotTypes($_POST);
            show_edit_bot_types();
        } elseif ($_GET['mode'] == 'create_ship') {
            //create_ship();
            global $pricelist;
            $botManager->createShip($_POST['bot_type'], $_POST['ship'], $pricelist);
            show_edit_bot_types();
        } elseif ($_GET['mode'] == 'delete_ship') {
            //delete_ship();
            $botManager->deleteShip($_POST['bot_type'], $_POST['ship']);
            show_edit_bot_types();
        } elseif ($_GET['mode'] == 'set_ship_factor') {
            //set_ship_factor();
            $botManager->setShipFactor($_POST['bot_type'], $_POST['ship'], $_POST['factor']);
            show_edit_bot_types();
        } elseif ($_GET['mode'] == 'reset_contingents') {
            //reset_contingents();
            $botManager->reset_contingents();
            show_bots();
        } elseif ($_GET['mode'] == 'show_edit_bot_planets') {
            show_edit_bot_planets();
        } elseif ($_GET['mode'] == 'show_edit_bot_users') {
            show_edit_bot_users();
        }elseif ($_GET['mode'] == 'create_base_bot_type_config') {
            //create_base_bot_type_config();
            $botManager->createBaseBotTypeConfig();
        }elseif ($_GET['mode'] == 'show_create_bot') {
            show_create_bot();
            
        }elseif ($_GET['mode'] == 'create_bot') {
            //create_bot();
            $botManager->createBot($_POST['number_of_bots'], $_POST['number_of_planets']);
        }elseif ($_GET['mode'] == 'delete_bot') {
            //create_bot();
            $botManager->deleteBot($_GET['bot_id']);
            show_all_bots();
        }elseif ($_GET['mode'] == 'change_bot_type') {
            echo 'change_bot_type';
            $botManager->change_bot_type((int)$_POST['userid'], (int)$_POST['bot_type'] );
        }

    } else {
        
        show_bots();
    }
    echo '</div>';
}



#------------------------------------pages-----------------------------------------------------

function show_bots()
{
    $db = Database::get();
    $bot_setting_all =  [];
 try {
    $bot_setting_all = $db->select('select * from '. DB_PREFIX .'bot_setting');
 } catch (\Throwable $th) {
    show_create_bot();
        return;
 }
    
   
    $all_contingent = array('full(defined)' => array('contingent' => 0, 'contingent_used' => 0),'all ress(calc)' => array('contingent' => 0, 'contingent_used' => 0),'ship_ress' => array('contingent' => 0, 'contingent_used' => 0), 'ress' => array('contingent' => 0, 'contingent_used' => 0));
    echo '<button onclick="location.href = \'admin.php?page=EditBots&mode=reset_contingents\'">reset contingents</button><hr>';
    foreach ($bot_setting_all as $key => $bot_setting) {
        echo '<h3>bot type: ' . $bot_setting['id'] . ' - ' . $bot_setting['name'] . '</h3>';
        $ships_array = unserialize($bot_setting['ships_array']);
        $all_contingent['full(defined)']['contingent'] += $bot_setting['full_contingent'];
        $all_contingent['ress']['contingent'] += $bot_setting['ress_contingent'];
        $all_contingent['full(defined)']['contingent_used'] += $bot_setting['full_contingent_used'];
        $all_contingent['ress']['contingent_used'] += $bot_setting['ress_contingent_used'];
        $all_contingent['all ress(calc)']['contingent'] += $bot_setting['ress_contingent'];
        $all_contingent['all ress(calc)']['contingent_used'] += $bot_setting['ress_contingent_used'];
        
        echo '<table><tr><th colspan="3">bot settings income</th></tr><tr><th></th><th>per second</th><th>per day</th><th>per month</th></tr>';
        $tmp = '';
        foreach ($ships_array as $key => $value) {
            echo '<tr><th>' . $value['name'] . ' per bot</th><td>' . pretty_number($value['per_second']) . '</td><td>' . pretty_number($value['per_second'] * 86400) . '</td><td>' . pretty_number($value['per_second'] * 2592000) . '</td></tr>';
            $tmp .= '<tr><th>' . $value['name'] . ' all bots</th><td>' . pretty_number($value['per_second'] * $bot_setting['number_of_bots']) . '</td><td>' . pretty_number($value['per_second'] * 86400 * $bot_setting['number_of_bots']) . '</td><td>' . pretty_number($value['per_second'] * 2592000 * $bot_setting['number_of_bots']) . '</td></tr>';
        }

        echo $tmp .'
            <tr><th>metal_per_bot</th><td>' . pretty_number($bot_setting['metal_per_second']) . '</td><td>' . pretty_number($bot_setting['metal_per_second']  * 86400) . '</td><td>' . pretty_number($bot_setting['metal_per_second']  * 2592000) . '</td></tr>
            <tr><th>crystal_per_bot</th><td>' . pretty_number($bot_setting['crystal_per_second']) . '</td><td>' . pretty_number($bot_setting['crystal_per_second']  * 86400) . '</td><td>' . pretty_number($bot_setting['crystal_per_second']  * 2592000) . '</td></tr>
            <tr><th>deuterium_per_bot</th><td>' . pretty_number($bot_setting['deuterium_per_second']) . '</td><td>' . pretty_number($bot_setting['deuterium_per_second']  * 86400) . '</td><td>' . pretty_number($bot_setting['deuterium_per_second']  * 2592000) . '</td></tr>
            <tr><th>ress_per_bot</th><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second'])) . '</td><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second'])  * 86400) . '</td><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second'])  * 2592000) . '</td></tr>
            <tr><th>ress_all_bots</th><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second']) * $bot_setting['number_of_bots']) . '</td><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second']) * $bot_setting['number_of_bots'] * 86400) . '</td><td>' . pretty_number(($bot_setting['deuterium_per_second'] + $bot_setting['crystal_per_second'] + $bot_setting['metal_per_second']) * $bot_setting['number_of_bots'] * 2592000) . '</td></tr>
            </table>';
        echo '
            <table><tr><th colspan="3">monthly bots income</th></tr>
            <tr><th></th><th>contingent</th><th>used</th><th>percent</th></tr>
            <tr title="total of ress for this bot type per month and total given ress to bot types bots since start of month(month=30 days does not start at 1.1)"><th>total output</th><td>' . pretty_number($bot_setting['full_contingent']) . '</td><td>' . pretty_number($bot_setting['full_contingent_used']) . '</td><td>' . round($bot_setting['full_contingent_used'] > 0 ? $bot_setting['full_contingent_used'] / ($bot_setting['full_contingent'] * .01) : 0, 4) . '%</td></tr>
            <tr title="this is the ress value of the ships the bot type has been given"><th>ships ress</th><td>' . pretty_number($bot_setting['ress_ships_contingent'])  . '</td><td>' . pretty_number($bot_setting['ress_ships_contingent_used']) . '</td><td>' . round($bot_setting['ress_ships_contingent_used'] > 0 ? $bot_setting['ress_ships_contingent_used'] / ($bot_setting['ress_ships_contingent'] * .01) : 0, 4) . '%</td></tr>
            <tr title="all ress this bot types bots will get in one month and how much have been given since this month started"><th>ress</th><td>' . pretty_number($bot_setting['ress_contingent'])  . '</td><td>' . pretty_number($bot_setting['ress_contingent_used']) . '</td><td>' . round($bot_setting['ress_contingent_used'] > 0 ? $bot_setting['ress_contingent_used'] / ($bot_setting['ress_contingent'] * .01) : 0, 4) . '%</td></tr>';
        foreach ($ships_array as $key => $value) {
            echo '<tr title="amount of '.$value['name'].' this bot type gets per month and the ships given within this month"><th>' . $value['name'] . '</th><td>' . pretty_number($value['contingent'])  . '</td><td>' . pretty_number($value['contingent_used']) . '</td><td>' . round($value['contingent_used'] > 0 ? $value['contingent_used'] / ($value['contingent'] * .01) : 0, 4) . '%</td></tr>';
            if (!isset($all_contingent[$value['name']])){ $all_contingent[$value['name']] = array('contingent' => 0, 'contingent_used' => 0); }
            $all_contingent[$value['name']]['contingent'] += $value['contingent'];
            $all_contingent[$value['name']]['contingent_used'] += $value['contingent_used'];
            $all_contingent['ship_ress']['contingent_used'] += $value['contingent_used'] * $value['shipvalue'];
            $all_contingent['ship_ress']['contingent'] += $value['contingent'] * $value['shipvalue'];
            $all_contingent['all ress(calc)']['contingent_used'] += $value['contingent_used'] * $value['shipvalue'];
            $all_contingent['all ress(calc)']['contingent'] += $value['contingent'] * $value['shipvalue'];
        }



        echo ' <tr title="one period of has 30 days. this line shows how much time since the start of the period(month) has passed"><th>30 days</th><td>' . pretty_time(2592000) . '</td><td>' . pretty_time(time() - $bot_setting['last_set']) . '</td><td>' . round((time() - $bot_setting['last_set']) > 0 ? (time() - $bot_setting['last_set']) / 25920 : 0, 4) . '%</td></tr>
            <tr title="number of bots this bot type has"><th>number of bots</th><td>' . $bot_setting['number_of_bots'] . '</td></tr>
            </table><hr>';
    }
    echo '<h3>all bots</h3><table><tr><th colspan="3">all bots income</th></tr>
       <tr><th></th><th>contingent</th><th>used</th><th>percent</th></tr>';
    foreach ($all_contingent as $key => $value) {
        echo '<tr><td>' . $key . '</td><td>' . pretty_number($value['contingent']) . '</td><td>' . pretty_number($value['contingent_used']) . '</td><td>' . round($value['contingent_used'] > 0 ? $value['contingent_used'] / ($value['contingent'] * .01) : 0, 4) . '%</td></tr>';
    }
}



#bot types
function show_edit_bot_types()
{

    global $resource;


    $db = Database::get();
    $bot_types =  [];
    try {
        $bot_types = $db->select('SELECT * FROM '. DB_PREFIX .'bot_setting');
    } catch (\Throwable $th) {
       show_create_bot();
           return;
    }
    $bot_types = $db->select('SELECT * FROM '. DB_PREFIX .'bot_setting');
    foreach ($bot_types as $key => $bot_type) {
        echo '<div class="bot_type"><h1>' . $bot_type['id'] . '.' . $bot_type['name'] . '</h1><form method="post" action="admin.php?page=EditBots&mode=set_bot_types">';
        $ships_array = unserialize($bot_type['ships_array']);
        echo '<input type="text" name="name" value="' . $bot_type['name'] . '" title="the name of the bot type, just there for your information"><label>name</label><br>
            <input type="hidden" name="id" value="' . $bot_type['id'] . '" title="the id is how the bots are tied to the bot type, no change needed normaly, exept when want to switch settings">
            <input type="number" name="first_points_multiplicator" value="' . $bot_type['first_points_multiplicator'] . '" title="the ressource output in fleet and ress per month is the (points of the first player * first_points_multiplicator) it defines how much ressources the bots get per month. you may start with 500"><label>first_points_multiplicator</label><br>
            <input type="number" min="0" max="1" step="0.1" name="ress_factor" value="' . $bot_type['ress_factor'] . '" title="factor is used to determine how much of the monthly contingent is spend to ress , the rest is for fleet 0,1 = 10% ,sould not be more then 1"><label>ress factor</label><br>
            <input type="number" min="0" max="1" step="0.01" name="ress_value_metal" value="' . $bot_type['ress_value_metal'] . '" title="the metal factor tell how much of the resource contingent will be used for metal 0,1 = 10%"><label>metal factor</label><br>
            <input type="number" min="0" max="1" step="0.01" name="ress_value_crystal" value="' . $bot_type['ress_value_crystal'] . '" title="the crystal factor tell how much of the resource contingent will be used for crystal 0,1 = 10%"><label>crystal factor</label><br>
            <input type="number" min="0" max="1" step="0.01" name="ress_value_deuterium" value="' . $bot_type['ress_value_deuterium'] . '" title="the deuterium factor tell how much of the resource contingent will be used for deuterium 0,1 = 10%"><label>deuterium factor</label><br>
            <input type="number" min="0" step="120" name="min_fleet_seconds_in_space" value="' . $bot_type['min_fleet_seconds_in_space'] . '" title="minimum time in second wich the bots fleet be save in space before landing again"><label>min fleet time in space</label><br>
            <input type="number" min="0" step="120" name="max_fleet_seconds_in_space" value="' . $bot_type['max_fleet_seconds_in_space'] . '" title="maximum time in second wich the bots fleet be save in space before landing again"><label>max fleet time in space</label><br>
            <input type="number" min="0" step="120" name="min_fleet_seconds_on_planet" value="' . $bot_type['min_fleet_seconds_on_planet'] . '" title="minimum time in second wich the bots fleet will hold on a planet"><label>min fleet time on planet</label><br>
            <input type="number" min="0" step="120" name="max_fleet_seconds_on_planet" value="' . $bot_type['max_fleet_seconds_on_planet'] . '" title="maximum time in second wich the bots fleet will hold on a planet"><label>max fleettime on planet</label><br>';
        echo '<button value="set bot types" />set bot types</button></form><br><br>bot ships:<br><table><tr><th>ship</th><th>factor</th><th>leave on planet</th><th>delete</th></tr>';
        foreach ($ships_array as $key => $value) {
            echo '<tr><td>' . $value['name'] . '</td>
                <td><input type="number"  min="0" max="1" step="0.001" name="factor" onkeyup="sendtoserver(' . $bot_type['id'] . ',\'' . $value['name'] . '\',this.value)" onchange="sendtoserver(' . $bot_type['id'] . ',\'' . $value['name'] . '\',this.value)" value="' . round(isset($value['factor']) ? $value['factor'] : (1 / count($ships_array)), 3) . '"></td>
                <td><input type="number" min="0" max="1" step="0.001" name="leave_on_planet_factor" value="'. $value['leave_on_planet'] .'"></td>
                <td><form method="post" action="admin.php?page=EditBots&mode=delete_ship"><input type="hidden" name="bot_type" value="' . $bot_type['id'] . '"><input type="hidden" name="ship" value="' . $value['name'] . '">
                <button>delete</button></form></td></tr>';
        }
        echo '</table><script>
            function sendtoserver(bot_type,ship,factor){
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("POST", "admin.php?page=EditBots&mode=set_ship_factor", true);
                xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xmlhttp.send("bot_type="+bot_type+"&ship="+ship+"&factor="+factor);
            }
            </script><br><form method="post" action="admin.php?page=EditBots&mode=create_ship">
            <input type="hidden" name="bot_type" value="' . $bot_type['id'] . '"><select name="ship">';

        foreach ($resource as $key1 => $value1) {
            if ($key1 > 200 && $key1 < 300) {
                echo '<option value="' . $value1 . '">' . $value1 . '</option>';
            }
        }
        echo '</select><button>add new ship</button></form>';
        echo '</div>';
    }
}


function show_edit_bot_users()
{
    #get researchlevels, bot_type , planets and fleets
    echo '<button class="alert" onclick="location.href = \'admin.php?page=EditBots&mode=delete_all_elements_from_bot_planets\'">reset bots: delete all bot fleets, ress and contingents</button>
        <button class="alert" onclick="location.href = \'admin.php?page=EditBots&mode=delete_all_elements_from_bot_planets\'">reset ress on all bots</button>
        <button class="alert" onclick="location.href = \'admin.php?page=EditBots&mode=delete_all_elements_from_bot_planets\'">reset fleets on all bots</button>
        <button class="alert" onclick="location.href = \'admin.php?page=EditBots&mode=create_base_bot_type_config\'">reset bot types</button>';
}
function show_edit_bot_planets()
{
    global $resource, $LNG;
    echo '<button class="alert" onclick="location.href = \'admin.php?page=EditBots&mode=create_bot_planets\'">make botplanets +1 for each bot(max 15) also set is_bot flag on planets of bots</button><br>';
    echo '<hr><h3>set element on all botplanets:</h3><form method="post" action="admin.php?page=EditBots&mode=set_on_all_planets">
        <select name="elementid"  onchange="updateSelectedText()">';
    foreach ($resource as $key => $value) {
        if ($key < 600) {
            if ($key < 200 && $key > 100) {
                continue;
            }
            echo '<option value="' . $key . '">' . $LNG['tech'][$key] . '</option>';
        }
    }
    echo '</select>
        <input type="number" name="elemval" value="0" placeholder="value" />
        <button>set on all bot planets</button></form><hr>
        <h3>set resources on all botplanets:</h3><form method="post" action="admin.php?page=EditBots&mode=ress_to_all_planets">
        metal<input type="number" name="metal" value="100000" />
        crystal<input type="number" name="crystal" value="70000" />
        deut<input type="number" name="deuterium" value="0" />
        <button value="Ress to all bots" />put ress on all bot planets</button></form>';
}

#shows all bots and their fleet and ress and status with planets and fleets
function show_all_bots()
{
    
    $db = Database::get();
    $setting_ships_array = [];
    try {
        $setting_ships_array = unserialize($db->select('select ships_array from '. DB_PREFIX .'bot_setting')[0]['ships_array']);
    } catch (\Throwable $th) {
       show_create_bot();
           return;
    }
    $setting_ships_array = unserialize($db->select('select ships_array from '. DB_PREFIX .'bot_setting')[0]['ships_array']);
    $potplanets = $db->select('select * from '. DB_PREFIX .'planets where is_bot=1 and planet_type = 1;');
    $botfleetso = $db->select('select ships_array , owner_id,next_fleet_action,id,action_index,`bot_type` from '. DB_PREFIX .'bots');
    $botown = array();
    $bot_base_array = array('metal' => 0, 'crystal' => 0, 'deuterium' => 0, 'ress' => 0, 'planetcount' => 0,  'next_fleet_action' => time(), 'landed' => 0, 'bot_type' => 0);



    foreach ($botfleetso as $key => $value) {
        if (!isset($botown[$value['owner_id']])) {
            $botown[$value['owner_id']]  = $bot_base_array;
        }
        $ships_array = unserialize($value['ships_array']);
        foreach ($ships_array as $key => $value2) {
            $botown[$value['owner_id']][$value2['name']] = isset($botown[$value['owner_id']][$value2['name']]) ? $botown[$value['owner_id']][$value2['name']] + $value2['amount'] : $value2['amount'];
            $bot_base_array[$value2['name']] = 0;
           
        }
        $botown[$value['owner_id']]['bot_type'] = $value['bot_type'];
        $botown[$value['owner_id']]['landed'] += $value['action_index'];
        $botown[$value['owner_id']]['next_fleet_action'] = $value['next_fleet_action'];
    }
    foreach ($potplanets as $key => $value) {
        if (!isset($botown[$value['id_owner']])) {

            $botown[$value['id_owner']]  = $bot_base_array;
        }
        foreach ($setting_ships_array as $key => $value2) {
            $botown[$value['id_owner']][$value2['name']] = isset($botown[$value['id_owner']][$value2['name']]) ? $botown[$value['id_owner']][$value2['name']] + $value[$value2['name']] : $value[$value2['name']];
            $bot_base_array[$value2['name']] = 0;
        }
        $botown[$value['id_owner']]['planetcount'] += 1;
        $botown[$value['id_owner']]['metal'] += $value['metal'];
        $botown[$value['id_owner']]['crystal'] += $value['crystal'];
        $botown[$value['id_owner']]['deuterium'] += $value['deuterium'];
        $botown[$value['id_owner']]['ress'] += $value['metal'] + $value['crystal'] + $value['deuterium'];
    }
    ksort($botown);
    $output = "";
    $all_bots_own = $bot_base_array;



    foreach ($botown as $key => $value) {//key is user id not bot id

        $output .= '<tr><td><a style="color:red !important" href="admin.php?page=EditBots&mode=delete_bot&bot_id=' . $key . '">del</a> <a href="admin.php?page=qeditor&edit=player&id=' . $key . '" target="_blank">' . $key . '</a></td>';
        foreach ($value as $key2 => $value2) {
            $all_bots_own[$key2] +=  $value2;
            if ($key2 == 'next_fleet_action') {
                $output .= '<td>' . pretty_time(abs(time() - $value2)) . '</td>';
            } elseif($key2 == 'bot_type'){
                $output .= '<td><input type="number" style="width:50px" onchange="change_bot_type(' . $key . ',this.value)" name="bot_type" value="' . $value2 . '" /></td>';
            }else {
                $output .= '<td>' . pretty_number(round($value2)) . '</td>';
            }
        }
        $output .=  '</td></tr>';
    }

    $output1 = '';
    $output1 .= '<tr><td>all bots</td>';

    foreach ($all_bots_own as $key => $value) {

        $output1 .= '<td>' . pretty_number(round($value)) . '</td>';
    }
    $output1 .= '</tr>';
    $tablehead = '<thead id="botshead"><tr><th onclick="sortTable(0)">id</th>
        <th onclick="sortTable(1)">met</th><th   onclick="sortTable(2)">crys</th>
        <th onclick="sortTable(3)">deut</th><th onclick="sortTable(4)">ress</th><th onclick="sortTable(5)">planetcount</th>
        <th onclick="sortTable(6)">next_fleet_action</th><th onclick="sortTable(7)">1 = on planet</th><th onclick="sortTable(8)">bot_type</td>';
        $i = 8;
    foreach ($setting_ships_array as $key => $value) {
        $i++;
        $tablehead .= '<th onclick="sortTable(' . ($i) . ')">' . $value['name'] . '</th>';
    }

    $tablehead .= '</tr>';
    echo '<table id="bottable">' . $tablehead . '</thead>' . $output1 .  $output . '</table>';
    echo '<script>
    function change_bot_type(userid,botclass){
        //xhr to server
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "admin.php?page=EditBots&mode=change_bot_type", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("bot_type=" + botclass + "&userid=" + userid);
    }

        function sortTable(columnIndex) {
            var table = document.getElementById("bottable");
            var rows = Array.from(table.rows).slice(1); // Exclude header row
        rows = rows.slice(1);
            rows.sort(function(rowA, rowB) {
                var cellA = rowA.cells[columnIndex].textContent.trim();
                var cellB = rowB.cells[columnIndex].textContent.trim();

                // Attempt to convert to numbers
                var numA = cellA.replace(/\./g, ""); // Adjust for decimal separator
                var numB = cellB.replace(/\./g, "");
            
                // Check if both are numbers
                if (!isNaN(numA) && !isNaN(numB)) {
                    return numB - numA; // Sort numerically (descending)
                } else {
                    return cellA.localeCompare(cellB); // Sort alphabetically
                }
            });

            // Re-attach sorted rows
            rows.forEach(row => table.appendChild(row));
        }
        </script>';
}



function show_create_bot()
{
    ?>
    <form method="post" action="admin.php?page=EditBots&mode=create_bot">
        <input type="number" name="number_of_bots" value="1"> number of bots<br>
        <input type="number" name="number_of_planets" value="1"> number of planets<br>
        <input type="submit" value="create bots">
    </form>
    <?php
    
}




























