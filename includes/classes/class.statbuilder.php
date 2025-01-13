<?php

/**
 *  2Moons
 *   by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package 2Moons
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @licence MIT
 * @version 1.8.0
 * @link https://github.com/jkroepke/2Moons
 */

class statbuilder
{
	private $starttime;
	private $memory;
	private $time;
	private $ressgewichte;
	private $recordData;
	private $Unis;
	private $loopcout;
	private $noobboostsql;

	function __construct()
	{
		$this->starttime   	= microtime(true);
		$this->memory		= array(round(memory_get_usage() / 1024, 1), round(memory_get_usage(1) / 1024, 1));
		$this->time   		= TIMESTAMP;
		$this->ressgewichte = ['901' => .2,'902' => .3,'903' => .5];
		$this->recordData  	= array();
		$this->Unis			= array();
		$this->loopcout = array("punkte" => 0, "allianzen" => 0, "noob" => 0);
		$this->noobboostsql = '';

		$uniResult	= Database::get()->select("SELECT uni FROM %%CONFIG%% ORDER BY uni ASC;");
		foreach ($uniResult as $uni) {
			$this->Unis[]	= $uni['uni'];
		}
	}

	private function SomeStatsInfos()
	{
		return array(
			'stats_time'		=> $this->time,
			'totaltime'    		=> round(microtime(true) - $this->starttime, 7),
			'memory_peak'		=> array(round(memory_get_peak_usage() / 1024, 1), round(memory_get_peak_usage(1) / 1024, 1)),
			'initial_memory'	=> $this->memory,
			'end_memory'		=> array(round(memory_get_usage() / 1024, 1), round(memory_get_usage(1) / 1024, 1)),
			'sql_count'			=> Database::get()->getQueryCounter(),
			'loop_count'		=> $this->loopcout
		);
	}

	private function CheckUniverseAccounts($UniData)
	{
		$UniData	= $UniData + array_combine($this->Unis, array_fill(1, count($this->Unis), 0));
		foreach ($UniData as $Uni => $Amount) {
			$config	= Config::get($Uni);
			$config->users_amount = $Amount;
			$config->save();
		}
	}

	private function GetUsersInfosFromDB()
	{
		global $resource, $reslist;
		$select_defenses	=	'';
		$select_buildings	=	'';
		$selected_tech		=	'';
		$select_fleets		=	'';

		foreach ($reslist['build'] as $Building) {
			$select_buildings	.= " p." . $resource[$Building] . ",";
		}

		foreach ($reslist['tech'] as $Techno) {
			$selected_tech		.= " u." . $resource[$Techno] . ",";
		}

		foreach ($reslist['fleet'] as $Fleet) {
			$select_fleets		.= " SUM(p." . $resource[$Fleet] . " ) as " . $resource[$Fleet] . ",";
		}

		foreach ($reslist['defense'] as $Defense) {
			$select_defenses	.= " SUM(p." . $resource[$Defense] . ") as " . $resource[$Defense] . ",";
		}

		foreach ($reslist['missile'] as $Defense) {
			$select_defenses	.= " SUM(p." . $resource[$Defense] . ") as " . $resource[$Defense] . ",";
		}

		$database		= Database::get();
		$FlyingFleets	= array();
		$fleetress	= array();

		$SQLFleets		= $database->select('SELECT fleet_array, fleet_owner, fleet_resource_metal , fleet_resource_crystal , fleet_resource_deuterium FROM %%FLEETS%%;');
		foreach ($SQLFleets as $CurFleets) {

			$FleetRec   	= explode(";", $CurFleets['fleet_array']);

			if (!is_array($FleetRec)) continue;

			if (!isset($fleetress[$CurFleets['fleet_owner']])) {
				$fleetress[$CurFleets['fleet_owner']]		= array(901 => 0, 902 => 0, 903 => 0);
			}
			$fleetress[$CurFleets['fleet_owner']][901] += $CurFleets['fleet_resource_metal'];
			$fleetress[$CurFleets['fleet_owner']][902] += $CurFleets['fleet_resource_crystal'];
			$fleetress[$CurFleets['fleet_owner']][903] += $CurFleets['fleet_resource_deuterium'];

			foreach ($FleetRec as $Group) {
				if (empty($Group)) continue;

				$Ship    	   = explode(",", $Group);
				if (!isset($FlyingFleets[$CurFleets['fleet_owner']][$Ship[0]]))
					$FlyingFleets[$CurFleets['fleet_owner']][$Ship[0]]	= $Ship[1];
				else
					$FlyingFleets[$CurFleets['fleet_owner']][$Ship[0]]	+= $Ship[1];
			}
		}
		$Return['fleetress'] 	= $fleetress;
		$Return['Fleets'] 	= $FlyingFleets;
		//fertigungstechnik, buildqueues hinzugefügt um in resspunkte mit einzurechnen
		$Return['Planets']	= $database->select('SELECT ' . $select_buildings . 'p.b_building_id, p.b_hangar_id, p.metal,p.destruyed, p.crystal, p.deuterium,  p.id, p.universe, p.id_owner, u.authlevel, u.bana, u.username, u.is_bot FROM %%PLANETS%% as p LEFT JOIN %%USERS%% as u ON u.id = p.id_owner;');
		$Return['Users']	= $database->select('SELECT ' . $selected_tech . $select_fleets . $select_defenses . 'u.b_tech_queue,p.is_bot,  u.id, u.ally_id, u.authlevel, u.bana, u.universe, u.username, s.tech_rank AS tech_rank, s.build_rank AS build_rank, s.defs_rank AS defs_rank, s.fleet_rank AS fleet_rank,  s.ress_rank AS ress_rank, s.total_rank AS total_rank, s.tech_old_rank AS old_tech_rank, s.build_old_rank AS old_build_rank, s.defs_old_rank AS old_defs_rank, s.fleet_old_rank AS old_fleet_rank, s.total_old_rank AS old_total_rank, s.tech_old AS old_tech, s.build_old AS old_build, s.defs_old AS old_defs, s.fleet_old AS old_fleet, s.ress_old AS old_ress, s.total_old AS old_total  FROM %%USERS%% as u LEFT JOIN %%STATPOINTS%% as s ON s.stat_type = 1 AND s.id_owner = u.id LEFT JOIN %%PLANETS%% as p ON u.id = p.id_owner GROUP BY s.id_owner, u.id, u.authlevel;');
		$Return['Alliance']	= $database->select('SELECT  a.id, a.ally_universe, s.tech_rank AS old_tech_rank, s.build_rank AS old_build_rank, s.defs_rank AS old_defs_rank, s.fleet_rank AS old_fleet_rank, s.ress_rank AS old_ress_rank, s.total_rank AS old_total_rank FROM %%ALLIANCE%% as a LEFT JOIN %%STATPOINTS%% as s ON s.stat_type = 2 AND s.id_owner = a.id;');
		return $Return;
	}

	private function setRecords($userID, $elementID, $amount)
	{
		$this->recordData[$elementID][$amount][]	= $userID;
	}

	private function writeRecordData()
	{
		$QueryData	= array();
		foreach ($this->recordData as $elementID => $elementArray) {
			krsort($elementArray, SORT_NUMERIC);
			$userWinner		= reset($elementArray);
			$maxAmount		= key($elementArray);
			$userWinner		= array_unique($userWinner);

			if (count($userWinner) > 3) {
				$keys			= array_rand($userWinner, 3);

				foreach ($keys as $key) {
					$QueryData[]	= "(" . $userWinner[$key] . "," . $elementID . "," . $maxAmount . ")";
				}
			} else {
				foreach ($userWinner as $userID) {
					$QueryData[]	= "(" . $userID . "," . $elementID . "," . $maxAmount . ")";
				}
			}
		}

		if (!empty($QueryData)) {
			$SQL	= "TRUNCATE TABLE %%RECORDS%%;";
			$SQL	.= "insert ignore INTO %%RECORDS%% (userID, elementID, level) VALUES " . implode(', ', $QueryData);
			$this->SaveDataIntoDB($SQL);
		}
	}

	private function SaveDataIntoDB($Data)
	{
		Database::get()->nativeQuery($Data);
		/*$queries	= explode(';', $Data);
		$queries	= array_filter($queries);

		foreach($queries as $query)
		{

			Database::get()->nativeQuery($query .';');
		}*/
	}

	private function GetTechnoPoints($USER)
	{
		global $resource, $reslist, $pricelist;
		$TechCounts = 0;
		$TechPoints = 0;

		foreach ($reslist['tech'] as $Techno) {
			if ($USER[$resource[$Techno]] == 0) continue;

			// Points = (All resources / PointsPerCost) * Factor * ( 2 * ( Factor ^ Level ) - Factor) + 1)
			// PointsPerCot == Config::get()->stat_settings
			$TechCounts		+= $USER[$resource[$Techno]];
			$TechPoints     +=
				($pricelist[$Techno]['cost'][901] + $pricelist[$Techno]['cost'][902] + $pricelist[$Techno]['cost'][903])
				* $pricelist[$Techno]['factor']
				* (
					2 * (
						pow($pricelist[$Techno]['factor'], $USER[$resource[$Techno]]) - $pricelist[$Techno]['factor']
					) + 1
				);


			$this->setRecords($USER['id'], $Techno, $USER[$resource[$Techno]]);
		}

		return array('count' => $TechCounts, 'points' => ($TechPoints / Config::get()->stat_settings));
	}

	private function GetBuildPoints($PLANET)
	{
		global $resource, $reslist, $pricelist;
		$BuildCounts = 0;
		$BuildPoints = 0;

		foreach ($reslist['build'] as $Build) {
			if ($PLANET[$resource[$Build]] == 0) continue;

			// Points = (All resources / PointsPerCost) * Factor * ( 2 * ( Factor ^ Level ) - Factor) + 1)
			// PointsPerCot == Config::get()->stat_settings
			$BuildPoints     +=
				($pricelist[$Build]['cost'][901] + $pricelist[$Build]['cost'][902] + $pricelist[$Build]['cost'][903])
				* $pricelist[$Build]['factor']
				* (
					2 * (
						pow($pricelist[$Build]['factor'], $PLANET[$resource[$Build]]) - $pricelist[$Build]['factor']
					) + 1
				);

			$BuildCounts	+= $PLANET[$resource[$Build]];

			$this->setRecords($PLANET['id_owner'], $Build, $PLANET[$resource[$Build]]);
		}
		return array('count' => $BuildCounts, 'points' => ($BuildPoints / Config::get()->stat_settings));
	}

	private function GetDefensePoints($USER)
	{
		global $resource, $reslist, $pricelist;
		$DefenseCounts = 0;
		$DefensePoints = 0;

		foreach (array_merge($reslist['defense'], $reslist['missile']) as $Defense) {
			if ($USER[$resource[$Defense]] == 0) continue;

			$Units			= $pricelist[$Defense]['cost'][901] + $pricelist[$Defense]['cost'][902] + $pricelist[$Defense]['cost'][903];
			$DefensePoints += $Units * $USER[$resource[$Defense]];
			$DefenseCounts += $USER[$resource[$Defense]];

			$this->setRecords($USER['id'], $Defense, $USER[$resource[$Defense]]);
		}

		return array('count' => $DefenseCounts, 'points' => ($DefensePoints / Config::get()->stat_settings));
	}
	private function GetRessPoints($PLANET)
	{
		$ressarray = array(
			901 => $PLANET['metal'],
			902 => $PLANET['crystal'],
			903 => $PLANET['deuterium']
		);
		$planetress = 0;
		//---------------resspoints for buildque for noobboostcalc-----------------
		$bau = !empty($PLANET['b_building_id']) ? unserialize_B($PLANET['b_building_id']) : 0; //hier nur erstes 0 id 1 level
		$flotte =  !empty($PLANET['b_hangar_id']) ? unserialize_B($PLANET['b_hangar_id']) : 0; //hier ganzes queue weil alles bezahlt  0 id 1 anzahl
		if ($bau != 0) {
			$baukosten = BuildFunctions::getElementPrice($PLANET, $PLANET, $bau[0][0], false, $bau[0][1]); //get buildprice - with all bonuses

			foreach ($baukosten as $key => $value) {
				if (isset($ressarray[$key])) {
					$ressarray[$key] += $value;
				}
			}
		}
		if ($flotte != 0) {
			foreach ($flotte as $queue_flotte) {
				$flotten_baukosten = BuildFunctions::getElementPrice($PLANET, $PLANET, $queue_flotte[0], false, $queue_flotte[1]); //get buildprice - with all bonuses - for all in list
				foreach ($flotten_baukosten as $key => $value) {
					if (!isset($ressarray[$key])) {
						$ressarray[$key] = 0;
					}
					$ressarray[$key] += $value;
				}
			}
		}
		foreach ($this->ressgewichte as $key => $value) {
			$planetress += $value * $ressarray[$key];
		}
		//-----------------------------------------------------------------------------
		return array('count' => $planetress, 'points' => ($planetress / Config::get()->stat_settings));
	}
	private function GetFleetPoints($USER)
	{
		global $resource, $reslist, $pricelist;
		$FleetCounts = 0;
		$FleetPoints = 0;

		foreach ($reslist['fleet'] as $Fleet) {
			if ($USER[$resource[$Fleet]] == 0) continue;

			$Units			= $pricelist[$Fleet]['cost'][901] + $pricelist[$Fleet]['cost'][902] + $pricelist[$Fleet]['cost'][903];
			$FleetPoints   += $Units * $USER[$resource[$Fleet]];
			$FleetCounts   += $USER[$resource[$Fleet]];

			$this->setRecords($USER['id'], $Fleet, $USER[$resource[$Fleet]]);
		}

		return array('count' => $FleetCounts, 'points' => ($FleetPoints / Config::get()->stat_settings));
	}

	private function setNewRanks()
	{
		$types = ['tech', 'build', 'defs', 'fleet', 'total', 'ress'];

		foreach ($this->Unis as $uni) {
			foreach ($types as $type) {
				Database::get()->nativeQuery('SELECT @i := 0;');

				$sql = 'UPDATE %%STATPOINTS%% SET ' . $type . '_rank = (SELECT @i := @i + 1)
                WHERE universe = :uni AND stat_type = :type
                ORDER BY ' . $type . '_points DESC, id_owner ASC;';

				Database::get()->update($sql, [
					':uni' => $uni,
					':type' => 1,
				]);

				Database::get()->nativeQuery('SELECT @i := 0;');

				Database::get()->update($sql, [
					':uni' => $uni,
					':type' => 2,
				]);
			}
		}
	}

	final public function MakeStats()
	{
		global $resource;
		$AllyPoints	= array();
		$UserPoints	= array();
		$maxpoints = Database::get()->select('SELECT MAX(total_points + ress_points) as maxpoints FROM %%STATPOINTS%% where stat_type = 1'); //aktuelle maxpunkte mit ress
		if (Config::get()->first_player_points == 0 || (($maxpoints[0]['maxpoints'] / Config::get()->first_player_points) < 1.2 && ($maxpoints[0]['maxpoints'] / Config::get()->first_player_points) > .8)) {
			Database::get()->update('update '. DB_PREFIX .'config set first_player_points = ' . $maxpoints[0]['maxpoints']);
		} else {
			$maxpoints[0]['maxpoints'] = Config::get()->first_player_points;
		}
		$TotalData	= $this->GetUsersInfosFromDB();
		$FinalSQL	= 'TRUNCATE TABLE %%STATPOINTS%%;';
		$FinalSQL_start = "insert ignore INTO %%STATPOINTS%% (id_owner, id_ally, stat_type, universe, tech_old_rank, tech_points, tech_count, build_old_rank, build_points, build_count, defs_old_rank, defs_points, defs_count, fleet_old_rank, fleet_points, fleet_count,ress_old_rank, ress_points, total_old_rank, total_points, total_count, tech_old, build_old, defs_old, fleet_old,ress_old, total_old,tech_rank, build_rank, defs_rank, fleet_rank, ress_rank, total_rank) VALUES ";
		$FinalSQL_start_jo = "insert ignore INTO %%STATPOINTS%% (id_owner, id_ally, stat_type, universe, tech_old_rank, tech_points, tech_count, build_old_rank, build_points, build_count, defs_old_rank, defs_points, defs_count, fleet_old_rank, fleet_points, fleet_count,ress_old_rank, ress_points, total_old_rank, total_points, total_count, tech_old, build_old, defs_old, fleet_old,ress_old, total_old,tech_rank, build_rank, defs_rank, fleet_rank, ress_rank, total_rank) VALUES ";
		$FinalSQL_onduplicate_update_array = 'ON DUPLICATE KEY UPDATE id_owner = values(id_owner), id_ally = values(id_ally), stat_type = values(stat_type), universe = values(universe), tech_old_rank = values(tech_old_rank), tech_points = values(tech_points), tech_count = values(tech_count), build_old_rank = values(build_old_rank), build_points = values(build_points), build_count = values(build_count), defs_old_rank = values(defs_old_rank), defs_points = values(defs_points), defs_count = values(defs_count), fleet_old_rank = values(fleet_old_rank), fleet_points = values(fleet_points), fleet_count = values(fleet_count), ress_old_rank = values(ress_old_rank), ress_points = values(ress_points), total_old_rank = values(total_old_rank), total_points = values(total_points), total_count = values(total_count), tech_old = values(tech_old), build_old = values(build_old), defs_old = values(defs_old), fleet_old = values(fleet_old), ress_old = values(ress_old), total_old = values(total_old), tech_rank = values(tech_rank), build_rank = values(build_rank), defs_rank = values(defs_rank), fleet_rank = values(fleet_rank), ress_rank = values(ress_rank), build_rank = values(build_rank), defs_rank = values(defs_rank), fleet_rank = values(fleet_rank), ress_rank = values(ress_rank), total_rank = values(total_rank)';

		$FinalSQL_onduplicate_update = 'ON DUPLICATE KEY UPDATE id_owner = values(id_owner), id_ally = values(id_ally), stat_type = values(stat_type), universe = values(universe), tech_old_rank = values(tech_old_rank), tech_points = values(tech_points), tech_count = values(tech_count), build_old_rank = values(build_old_rank), build_points = values(build_points), build_count = values(build_count), defs_old_rank = values(defs_old_rank), defs_points = values(defs_points), defs_count = values(defs_count), fleet_old_rank = values(fleet_old_rank), fleet_points = values(fleet_points), fleet_count = values(fleet_count), ress_old_rank = values(ress_old_rank), ress_points = values(ress_points), total_old_rank = values(total_old_rank), total_points = values(total_points), total_count = values(total_count), tech_old = values(tech_old), build_old = values(build_old), defs_old = values(defs_old), fleet_old = values(fleet_old), ress_old = values(ress_old), total_old = values(total_old)';
		$FinalSQLArray = array();
		$tableHeader = "insert ignore INTO %%STATPOINTS%% (id_owner, id_ally, stat_type, universe, tech_old_rank, tech_points, tech_count, build_old_rank, build_points, build_count, defs_old_rank, defs_points, defs_count, fleet_old_rank, fleet_points, fleet_count,ress_old_rank, ress_points, total_old_rank, total_points, total_count, tech_old, build_old, defs_old, fleet_old,ress_old, total_old) VALUES ";

		$FinalSQL	.= $tableHeader;

		foreach ($TotalData['Planets'] as $PlanetData) {
			if ($PlanetData['destruyed'] != 0 || $PlanetData['is_bot'] != 0) {
				continue;
			}
			if ((in_array(Config::get()->stat, array(1, 2)) && $PlanetData['authlevel'] >= Config::get()->stat_level) || !empty($PlanetData['bana'])) continue;

			if (!isset($UserPoints[$PlanetData['id_owner']])) {
				$UserPoints[$PlanetData['id_owner']]['build']['count'] = $UserPoints[$PlanetData['id_owner']]['build']['points'] = 0;
				$UserPoints[$PlanetData['id_owner']]['ress']['points'] =  isset($TotalData['fleetress'][$PlanetData['id_owner']]) ?
					((int)(($TotalData['fleetress'][$PlanetData['id_owner']][901] * $this->ressgewichte[901]) +
						($TotalData['fleetress'][$PlanetData['id_owner']][902] * $this->ressgewichte[902]) +
						($TotalData['fleetress'][$PlanetData['id_owner']][903] * $this->ressgewichte[903])) / Config::get()->stat_settings) : 0;
			}

			$BuildPoints												= $this->GetBuildPoints($PlanetData);
			$RessPoints													= $this->GetRessPoints($PlanetData);
			$UserPoints[$PlanetData['id_owner']]['build']['count'] 		+= $BuildPoints['count'];
			$UserPoints[$PlanetData['id_owner']]['build']['points'] 	+= $BuildPoints['points'];
			$UserPoints[$PlanetData['id_owner']]['ress']['points'] 		+= $RessPoints['points'];
		}

		$UniData	= array();

		$i = 0;
		$neuezeit = 0;
		if ((Config::get()->last_weekstat) <= time()) {
			$neuezeit = strtotime('next monday') + 7200;
			Database::get()->update('update '. DB_PREFIX .'config set last_weekstat = ' . $neuezeit);
			//first_player_points
			//	echo date('d-m-Y| H:i:s', $neuezeit);
		}
		foreach ($TotalData['Users'] as $UserData) {
			if ($UserData['is_bot'] != 0) {
				continue;
			}
			$i++;
			if (!isset($UniData[$UserData['universe']]))
				$UniData[$UserData['universe']] = 0;

			$UniData[$UserData['universe']]++;

			if ((in_array(Config::get()->stat, array(1, 2)) && $UserData['authlevel'] >= Config::get()->stat_level) || !empty($UserData['bana'])) {
				$FinalSQL  .= "(" . $UserData['id'] . "," . $UserData['ally_id'] . ",1," . $UserData['universe'] . ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), ";
				continue;
			}
			//------------------------------altuelle forschung den resspunkten zuschreiben
			$forschung = !empty($UserData['b_tech_queue']) ? unserialize_B($UserData['b_tech_queue']) : 0;  //hier nur erstes
			if ($forschung != 0) {
				$forschung_kosten = BuildFunctions::getElementPrice($UserData, $UserData, $forschung[0][0], false, $forschung[0][1]); //get researchprice - with all bonuses - only first one
				foreach ($forschung_kosten as $value) {
					$UserPoints[$UserData['id']]['ress']['points'] += $value / Config::get()->stat_settings;
				} //resspoints mit den ress in der forschungs addieren
			}
			//--------------------------------------------------------------------
			if (isset($TotalData['Fleets'][$UserData['id']])) {
				foreach ($TotalData['Fleets'][$UserData['id']] as $ID => $Amount)
					$UserData[$resource[$ID]]	+= $Amount;
			}

			$TechnoPoints		= $this->GetTechnoPoints($UserData);
			$FleetPoints		= $this->GetFleetPoints($UserData);
			$DefensePoints	= $this->GetDefensePoints($UserData);

			$UserPoints[$UserData['id']]['fleet']['count'] 		= $FleetPoints['count'];
			$UserPoints[$UserData['id']]['fleet']['points'] 	= $FleetPoints['points'];
			$UserPoints[$UserData['id']]['defense']['count'] 	= $DefensePoints['count'];
			$UserPoints[$UserData['id']]['defense']['points']	= $DefensePoints['points'];
			$UserPoints[$UserData['id']]['techno']['count'] 	= $TechnoPoints['count'];
			$UserPoints[$UserData['id']]['techno']['points'] 	= $TechnoPoints['points'];
			//------------------------START add ress in bank on planet in ships, and add fleet in bank START-------------------------------------

			//------------------------END add ress in bank on lanet in ships, and add fleet in bank END-------------------------------------
			$UserPoints[$UserData['id']]['total']['count'] 		= $UserPoints[$UserData['id']]['techno']['count']
				+ $UserPoints[$UserData['id']]['build']['count']
				+ $UserPoints[$UserData['id']]['defense']['count']
				+ $UserPoints[$UserData['id']]['fleet']['count'];

			$UserPoints[$UserData['id']]['total']['points'] 	= $UserPoints[$UserData['id']]['techno']['points']
				+ $UserPoints[$UserData['id']]['build']['points']
				+ $UserPoints[$UserData['id']]['defense']['points']
				+ $UserPoints[$UserData['id']]['fleet']['points'];

			$boostfaktor = number_format(max((0.7 - (($UserPoints[$UserData['id']]['total']['points'] + $UserPoints[$UserData['id']]['ress']['points']) / max(1, $maxpoints[0]['maxpoints']))) * 100, 0), 1);
			$boostfaktor = $boostfaktor * 1.4;
		
			#Database::get()->update('update '. DB_PREFIX .'users set noobboost = '.$boostfaktor . ' where id = '. $UserData['id']);
			if ($UserData['ally_id'] != 0) {
				if (!isset($AllyPoints[$UserData['ally_id']])) {
					$AllyPoints[$UserData['ally_id']]['build']['count']		= 0;
					$AllyPoints[$UserData['ally_id']]['build']['points']	= 0;
					$AllyPoints[$UserData['ally_id']]['fleet']['count']		= 0;
					$AllyPoints[$UserData['ally_id']]['fleet']['points']	= 0;
					$AllyPoints[$UserData['ally_id']]['defense']['count']	= 0;
					$AllyPoints[$UserData['ally_id']]['defense']['points']	= 0;
					$AllyPoints[$UserData['ally_id']]['techno']['count']	= 0;
					$AllyPoints[$UserData['ally_id']]['techno']['points']	= 0;
					$AllyPoints[$UserData['ally_id']]['total']['count']		= 0;
					$AllyPoints[$UserData['ally_id']]['total']['points']	= 0;
				}

				$AllyPoints[$UserData['ally_id']]['build']['count']		+= $UserPoints[$UserData['id']]['build']['count'];
				$AllyPoints[$UserData['ally_id']]['build']['points']	+= $UserPoints[$UserData['id']]['build']['points'];
				$AllyPoints[$UserData['ally_id']]['fleet']['count']		+= $UserPoints[$UserData['id']]['fleet']['count'];
				$AllyPoints[$UserData['ally_id']]['fleet']['points']	+= $UserPoints[$UserData['id']]['fleet']['points'];
				$AllyPoints[$UserData['ally_id']]['defense']['count']	+= $UserPoints[$UserData['id']]['defense']['count'];
				$AllyPoints[$UserData['ally_id']]['defense']['points']	+= $UserPoints[$UserData['id']]['defense']['points'];
				$AllyPoints[$UserData['ally_id']]['techno']['count']	+= $UserPoints[$UserData['id']]['techno']['count'];
				$AllyPoints[$UserData['ally_id']]['techno']['points']	+= $UserPoints[$UserData['id']]['techno']['points'];
				$AllyPoints[$UserData['ally_id']]['techno']['points']	+= $UserPoints[$UserData['id']]['ress']['points'];
				$AllyPoints[$UserData['ally_id']]['total']['count']		+= $UserPoints[$UserData['id']]['total']['count'];
				$AllyPoints[$UserData['ally_id']]['total']['points']	+= $UserPoints[$UserData['id']]['total']['points'];
			}

			if ($neuezeit != 0) {
				$UserData['old_tech'] = 	(isset($UserPoints[$UserData['id']]['techno']['points']) ? min($UserPoints[$UserData['id']]['techno']['points'], 1E50) : 0);
				$UserData['old_build'] =	(isset($UserPoints[$UserData['id']]['build']['points']) ? min($UserPoints[$UserData['id']]['build']['points'], 1E50) : 0);
				$UserData['old_defs'] =		(isset($UserPoints[$UserData['id']]['defense']['points']) ? min($UserPoints[$UserData['id']]['defense']['points'], 1E50) : 0);
				$UserData['old_fleet'] =	(isset($UserPoints[$UserData['id']]['fleet']['points']) ? min($UserPoints[$UserData['id']]['fleet']['points'], 1E50) : 0);
				$UserData['old_ress'] =	(isset($UserPoints[$UserData['id']]['ress']['points']) ? min($UserPoints[$UserData['id']]['ress']['points'], 1E50) : 0);
				$UserData['old_total'] =  (isset($UserPoints[$UserData['id']]['total']['points']) ? min($UserPoints[$UserData['id']]['total']['points'], 1E50) : 0);
				$UserData['old_tech_rank']  = $UserData['tech_rank'] ?? 0;
				$UserData['old_build_rank'] = $UserData['build_rank'] ?? 0;
				$UserData['old_defs_rank']  = $UserData['defs_rank'] ?? 0;
				$UserData['old_fleet_rank'] = $UserData['fleet_rank'] ?? 0;
				$UserData['old_ress_rank'] = $UserData['ress_rank'] ?? 0;
				$UserData['old_total_rank'] = $UserData['total_rank'] ?? 0;
			}



			$FinalSQLArray[] = [
				$UserData['id'],
				$UserData['ally_id'],
				1,
				$UserData['universe'],
				$UserData['old_tech_rank'] ?? 0,
				$UserPoints[$UserData['id']]['techno']['points'] ?? 0,
				$UserPoints[$UserData['id']]['techno']['count'] ?? 0,
				$UserData['old_build_rank'] ?? 0,
				$UserPoints[$UserData['id']]['build']['points'] ?? 0,
				$UserPoints[$UserData['id']]['build']['count'] ?? 0,
				$UserData['old_defs_rank'] ?? 0,
				$UserPoints[$UserData['id']]['defense']['points'] ?? 0,
				$UserPoints[$UserData['id']]['defense']['count'] ?? 0,
				$UserData['old_fleet_rank'] ?? 0,
				$UserPoints[$UserData['id']]['fleet']['points'] ?? 0,
				$UserPoints[$UserData['id']]['fleet']['count'] ?? 0,
				$UserData['old_ress_rank'] ?? 0,
				$UserPoints[$UserData['id']]['ress']['points'] ?? 0,
				$UserData['old_total_rank'] ?? 0,
				$UserPoints[$UserData['id']]['total']['points'] ?? 0,
				$UserPoints[$UserData['id']]['total']['count'] ?? 0,
				$UserData['old_tech'] ?? 0,
				$UserData['old_build'] ?? 0,
				$UserData['old_defs'] ?? 0,
				$UserData['old_fleet'] ?? 0,
				$UserData['old_ress'] ?? 0,
				$UserData['old_total'] ?? 0
			];
			$FinalSQL_start .= "
			(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?), ";
			/*	if ($i >= 200) {
                $FinalSQL = substr($FinalSQL, 0, -2).' '. $FinalSQL_onduplicate_update;
                $this->SaveDataIntoDB($FinalSQL);
                $FinalSQL = $tableHeader;
			}*/
		}
		function addRankingFields($array)
		{
			$result = [];
			$pointpositions = array(
				5, //techpoints
				8, //buildpoints
				11, //defpoints
				14, //fleetpoints
				17, //resspoints
				19, //totalpoints
			);
			$tobeaddedpositions = array(
				28, //techrank
				29, //buildrank
				30, //defrank
				31, //fleetrank
				32, //ressrank
				33, //totalrank
			);

			$pointpositions = [5, 8, 11, 14, 17, 19];

			foreach ($pointpositions as $pointposition) {
				usort($array, function ($a, $b) use ($pointposition) {
					return $b[$pointposition] - $a[$pointposition];
				});
				foreach ($array as $key => $value) {
					$array[$key][] = $key + 1;
				}
			}




			return $array;
		}
		$ranks = [
			'id_owner', 'id_ally', 'stat_type', 'universe', 'tech_old_rank', 'tech_points', 'tech_count', 'build_old_rank', 'build_points', 'build_count', 'defs_old_rank', 'defs_points',
			'defs_count', 'fleet_old_rank', 'fleet_points', 'fleet_count', 'ress_old_rank', 'ress_points', 'total_old_rank', 'total_points', 'total_count', 'tech_old', 'build_old', 'defs_old',
			'fleet_old', 'ress_old', 'total_old', 'build_rank', 'tech_rank', 'fleet_rank', 'defense_rank', 'ress_rank', 'total_rank'
		];

		$FinalSQLArray = addRankingFields($FinalSQLArray);
		$FinalarraySQL = substr($FinalSQL_start, 0, -2) . ' ' . $FinalSQL_onduplicate_update_array;
		#$this->SaveDataIntoDB($FinalarraySQL);
		echo 'arrayrowlength: ' . count($FinalSQLArray[0]);
		$newarray = [];
		$sqlstring = '';
		foreach ($FinalSQLArray as $UserPoints) {
			
			$sqlstring .= "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?), ";
			foreach ($UserPoints as $key => $value) {
				$newarray[] = $value;
			}
			if (count($newarray) >= 100) {//uses steps of 100, to prevent db issues
				#sleep(.1);
				$this->loopcout['punkte']++;
				Database::get()->insert($FinalSQL_start_jo . substr($sqlstring, 0, -2) . ' ' . $FinalSQL_onduplicate_update_array, $newarray);
				$newarray = [];
				$sqlstring = '';
			}
		}
		if($sqlstring != ''){//if there is a rest of the data, insert ignore the rest here
		Database::get()->insert($FinalSQL_start_jo . substr($sqlstring, 0, -2) . ' ' . $FinalSQL_onduplicate_update_array, $newarray);
		}
		//	Database::get()->insert($FinalarraySQL,$newarray);
		
	
		/*if (!empty($FinalSQL) && $FinalSQL != $tableHeader) {
		    $FinalSQL = substr($FinalSQL, 0, -2).' '. $FinalSQL_onduplicate_update;
            $this->DataIntoDB($FinalSQL);
            unset($UserPoints);
		}*/

		if (count($AllyPoints) != 0) {
			$AllySQL = "replace INTO ". DB_PREFIX ."statpoints_alliance (id_owner, id_ally, stat_type, universe, tech_old_rank, tech_points, tech_count, build_old_rank, build_points, build_count, defs_old_rank, defs_points, defs_count, fleet_old_rank, fleet_points, fleet_count, ress_points, total_old_rank, total_points, total_count) VALUES ";
			foreach ($TotalData['Alliance'] as $AllianceData) {
				$AllySQL  .= "(" .
					$AllianceData['id'] . ", 0, 2, " .
					$AllianceData['ally_universe'] . ", " .
					(isset($AllyPoints['old_tech_rank']) ? $AllyPoints['old_tech_rank'] : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['techno']['points']) ? min($AllyPoints[$AllianceData['id']]['techno']['points'], 1E50) : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['techno']['count']) ? $AllyPoints[$AllianceData['id']]['techno']['count'] : 0) . ", " .
					(isset($AllianceData['old_build_rank']) ? $AllianceData['old_build_rank'] : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['build']['points']) ? min($AllyPoints[$AllianceData['id']]['build']['points'], 1E50) : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['build']['count']) ? $AllyPoints[$AllianceData['id']]['build']['count'] : 0) . ", " .
					(isset($AllianceData['old_defs_rank']) ? $AllianceData['old_defs_rank'] : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['defense']['points']) ? min($AllyPoints[$AllianceData['id']]['defense']['points'], 1E50) : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['defense']['count']) ? $AllyPoints[$AllianceData['id']]['defense']['count'] : 0) . ", " .
					(isset($AllianceData['old_fleet_rank']) ? $AllianceData['old_fleet_rank'] : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['fleet']['points']) ? min($AllyPoints[$AllianceData['id']]['fleet']['points'], 1E50) : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['fleet']['count']) ? $AllyPoints[$AllianceData['id']]['fleet']['count'] : 0) . ", " .

					(isset($AllyPoints[$AllianceData['id']]['ress']['count']) ? $AllyPoints[$AllianceData['id']]['ress']['count'] : 0) . ", " .
					(isset($AllianceData['old_total_rank']) ? $AllianceData['old_total_rank'] : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['total']['points']) ? min($AllyPoints[$AllianceData['id']]['total']['points'], 1E50) : 0) . ", " .
					(isset($AllyPoints[$AllianceData['id']]['total']['count']) ? $AllyPoints[$AllianceData['id']]['total']['count'] : 0) . "), ";
			}
			unset($AllyPoints);
			$AllySQL	= substr($AllySQL, 0, -2) . ';';
			$this->SaveDataIntoDB($AllySQL);
		}




		#$this->SetNewRanks();

		$this->CheckUniverseAccounts($UniData);
		$this->writeRecordData();
		return $this->SomeStatsInfos();
	}
}
