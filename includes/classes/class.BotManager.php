<?php

class BotManager {
    private $db;
    private $resource;

    public function __construct() {
        $this->db = Database::get();
        global $resource;
        $this->resource = $resource;
    }

    // Set bot parameters for a specific type
    public function setBotTypes($postData) {
        $this->db->update(
            'update uni1_bot_setting set 
        name = :name , 
        ress_value_metal = :ress_value_metal,
        ress_value_crystal = :ress_value_crystal,
        ress_value_deuterium = :ress_value_deuterium,
        first_points_multiplicator = :first_points_multiplicator,
        min_fleet_seconds_in_space = :min_fleet_seconds_in_space,
        max_fleet_seconds_in_space = :max_fleet_seconds_in_space,
        min_fleet_seconds_on_planet = :min_fleet_seconds_on_planet,
        max_fleet_seconds_on_planet = :max_fleet_seconds_on_planet
        where id = :id',
            array(
                ':name' => $_POST['name'],
                ':id' => $_POST['id'],
                ':ress_value_metal' => $_POST['ress_value_metal'],
                ':ress_value_crystal' => $_POST['ress_value_crystal'],
                ':ress_value_deuterium' => $_POST['ress_value_deuterium'],
                ':first_points_multiplicator' => $_POST['first_points_multiplicator'],
                ':min_fleet_seconds_in_space' => $_POST['min_fleet_seconds_in_space'],
                ':max_fleet_seconds_in_space' => $_POST['max_fleet_seconds_in_space'],
                ':min_fleet_seconds_on_planet' => $_POST['min_fleet_seconds_on_planet'],
                ':max_fleet_seconds_on_planet' => $_POST['max_fleet_seconds_on_planet']
            )
        );
        echo 'Edited bot type: ' . $postData['name'];
    }

    // Set a specific resource value on all bot planets
    public function setOnAllPlanets($elementId, $elemVal) {
        $columnName = $this->resource[$elementId];
        $query = 'UPDATE '. DB_PREFIX .'planets SET {$columnName} = :value WHERE is_bot = 1';
        $this->db->update($query, [':value' => $elemVal]);
        echo "Done: {$columnName} is {$elemVal} on all bot planets now.";
    }

    // Set a ship factor for a specific bot type
    public function setShipFactor($botType, $shipName, $factor) {
        $bot = $this->db->select('SELECT ships_array FROM '. DB_PREFIX .'bot_setting WHERE id = :id', [':id' => $botType]);
        if (empty($bot)) {
            echo "Bot type not found.";
            return;
        }

        $shipsArray = unserialize($bot[0]['ships_array']);
        if (!isset($shipsArray[$shipName])) {
            echo "Ship not found in bot setting.";
            return;
        }
        
        $shipsArray[$shipName]['factor'] = $factor;
        $this->db->update('UPDATE '. DB_PREFIX .'bot_setting SET ships_array = :ships_array WHERE id = :id', [':ships_array' => serialize($shipsArray), ':id' => $botType]);
        echo "Edited ship: {$shipName}";
    }

    // Add resources to all bot planets
    public function ressToAllPlanets($metal, $crystal, $deuterium) {
        $query = "
            UPDATE %%PLANETS%% 
            SET bankm = bankm + :metal, 
                bankc = bankc + :crystal, 
                bankd = bankd + :deuterium 
            WHERE id_owner IN (SELECT id FROM %%USERS%% WHERE is_bot = 1) AND planet_type = 1;
        ";
        $this->db->update($query, [':metal' => $metal, ':crystal' => $crystal, ':deuterium' => $deuterium]);
        echo "All bots got {$metal} metal, {$crystal} crystal, and {$deuterium} deuterium.";
    }

    // Create default bot type configuration
    public function createBaseBotTypeConfig() {
        $shipsArray = [
            'heavy_hunter' => ['per_second' => 0, 'contingent' => 0, 'name' => 'heavy_hunter', 'contingent_used' => 0, 'shipvalue' => 10000, 'factor' => .33, 'leave_on_planet' => 0],
            'battle_ship' => ['per_second' => 0, 'contingent' => 0, 'name' => 'battle_ship', 'contingent_used' => 0, 'shipvalue' => 70000, 'factor' => .33, 'leave_on_planet' => 0],
            'destructor' => ['per_second' => 0, 'contingent' => 0, 'name' => 'destructor', 'contingent_used' => 0, 'shipvalue' => 125000, 'factor' => .33, 'leave_on_planet' => 0]
        ];
        
        $this->db->update('UPDATE '. DB_PREFIX .'bot_setting SET ships_array = :ships_array', [':ships_array' => serialize($shipsArray)]);
        $this->createBotFleetArrays();
        echo "Resetted bots to default settings.";
    }

    // Create bot fleet arrays
    public function createBotFleetArrays() {
        $bots = $this->db->select('SELECT * FROM '. DB_PREFIX .'bot_setting');
        
        foreach ($bots as $bot) {
            $shipsArray = unserialize($bot['ships_array']);
            foreach ($shipsArray as &$ship) {
                $ship['bonus_time'] = 0;
                $ship['amount'] = 0;
            }
            
            $this->db->update('UPDATE '. DB_PREFIX .'bots SET ships_array = :ships_array, ress_bonus_time = 0, next_fleet_action = :time, action_index = 1 WHERE bot_type = :botType', [':ships_array' => serialize($shipsArray), ':time' => time(), ':botType' => $bot['id']]);
        }
        
        echo "Done setting bots ships arrays.";
    }

    // Create bot planets
    public function createBotPlanets() {
        global $config;
        $bots = $this->db->select('SELECT * FROM %%USERS%% WHERE is_bot = 1');
        
        foreach ($bots as $bot) {
            $planets = $this->db->select('SELECT id, is_bot FROM '. DB_PREFIX .'planets WHERE id_owner = :userId AND planet_type = 1;', [':userId' => $bot['id']]);
            
            foreach ($planets as &$planet) {
                if ($planet['is_bot'] == 0) {
                    $this->db->update('UPDATE '. DB_PREFIX .'planets SET is_bot = 1 WHERE id = :id', [':id' => $planet['id']]);
                }
            }

            if (count($planets) >= 15) {
                continue;
            }

            do {
                $galaxy = mt_rand(1, $config->max_galaxy);
                $system = mt_rand(1, $config->max_system);
                $position = mt_rand(round($config->max_planets * 0.2), round($config->max_planets * 0.8));

                if ($galaxy > $config->max_galaxy) {
                    $galaxy = mt_rand(1, $config->max_galaxy);
                }
                
                if ($system > $config->max_system) {
                    $system = mt_rand(1, $config->max_system);
                }
            } while (!PlayerUtil::isPositionFree(Universe::current(), $galaxy, $system, $position));

            PlayerUtil::createPlanet($galaxy, $system, $position, Universe::current(), $bot['id']);
        }

        echo "Making bot planets...";
    }

    // Create a new ship for a bot type
    public function createShip($botType, $shipName, $pricelist) {
        global $resource;
        $flipResource = array_flip($resource);

        if (!isset($pricelist[$flipResource[$shipName]])) {
            echo "Invalid ship name.";
            return;
        }

        $bot = $this->db->select('SELECT ships_array FROM '. DB_PREFIX .'bot_setting WHERE id = :id', [':id' => $botType]);
        
        if (empty($bot)) {
            echo "Bot type not found.";
            return;
        }

        $shipsArray = unserialize($bot[0]['ships_array']);
        $shipCost = array_sum($pricelist[$flipResource[$shipName]]['cost']);

        $shipsArray[$shipName] = [
            'name' => $shipName, 
            'factor' => 1 / count($shipsArray), 
            'per_second' => 0, 
            'contingent' => 0, 
            'contingent_used' => 0, 
            'shipvalue' => $shipCost, 
            'leave_on_planet' => 0
        ];

        $this->db->update('UPDATE '. DB_PREFIX .'bot_setting SET ships_array = :ships_array WHERE id = :id', [':ships_array' => serialize($shipsArray), ':id' => $botType]);
        echo "Added ship: {$shipName}";
    }

    // Create a new bot type
    public function createBotType() {
        $this->db->insert('INSERT INTO '. DB_PREFIX .'bot_setting (ships_array) VALUES (:ships_array)', [':ships_array' => serialize([])]);
    }
//change bot type
public function change_bot_type($userid, $bot_type) {
    $this->db->update('UPDATE '. DB_PREFIX .'bots SET bot_type = :bot_type WHERE owner_id = :id', [':bot_type' => $bot_type, ':id' => $userid]);
    echo "bot type changed.";
    
}
    // Make a user a bot and add bot capabilities
    public function createBot($number_of_bots = 1, $number_of_planets = 0) {
        global $config;
            // Add the 'is_bot' column if it doesn't exist and create an index on it for the 'users' table
            $this->db->query('ALTER TABLE `' . DB_PREFIX . 'users` ADD COLUMN IF NOT EXISTS `is_bot` INT DEFAULT 0;');
            $this->db->query('CREATE INDEX IF NOT EXISTS idx_users_is_bot ON `' . DB_PREFIX . 'users` (`is_bot`);');

            // Add the 'is_bot' column if it doesn't exist and create an index on it for the 'planets' table
            $this->db->query('ALTER TABLE `' . DB_PREFIX . 'planets` ADD COLUMN IF NOT EXISTS `is_bot` INT DEFAULT 0;');
            $this->db->query('CREATE INDEX IF NOT EXISTS idx_planets_is_bot ON `' . DB_PREFIX . 'planets` (`is_bot`);');
        //set the bots tables if not set
        $this->db->query('
            CREATE TABLE IF NOT EXISTS `'. DB_PREFIX .'bots` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `owner_id` int(11) DEFAULT 0 COMMENT  \'user id of bot \',
            `ress_bonus_time` int(11) DEFAULT 0,
            `stationed_planet_id` int(11) DEFAULT 0 COMMENT  \'if the fleet is stationed on a planet, this is the id of the planet \',
            `next_fleet_action` int(11) DEFAULT 0 COMMENT  \'when landing or lifting the fleet, the time of next activity is put here. \',
            `action_index` int(11) DEFAULT 0 COMMENT  \'0 = fleet is in space, 1 = fleet is on planet \',
            `ships_array` text DEFAULT NULL,
            `bot_type` int(11) DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `id` (`id`),
            KEY `next_action` (`next_fleet_action`) USING BTREE
            ) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

            CREATE TABLE IF NOT EXISTS `'. DB_PREFIX . 'bot_setting` (
            `id` float NOT NULL DEFAULT 0,
            `name` varchar(50) DEFAULT  \'honk \' COMMENT  \'this is the name of the bot_type for better orientation in administration \',
            `metal_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT  \'metal per planet per sec (gets set automaticly at the start of a period) \',
            `crystal_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT  \'crystem per planet per sec \',
            `deuterium_per_second` decimal(65,10) DEFAULT 0.0000000000 COMMENT  \'deuterium per planet per sec \',
            `last_set` int(11) DEFAULT 0 COMMENT  \'timestamp from the start of the running period(30 days) \',
            `last_bot` int(11) DEFAULT 0 COMMENT  \'id of the last bot wich have got his ress production \',
            `ress_contingent` bigint(50) DEFAULT 0 COMMENT  \'max res output for planets for the period \',
            `ress_ships_contingent` bigint(50) DEFAULT 0,
            `full_contingent` bigint(50) DEFAULT 0 COMMENT  \'max ress+ships(in ress) output for this period (30 days) \',
            `full_contingent_used` decimal(65,10) DEFAULT 0.0000000000 COMMENT  \'saves how many ress in fleet and resshave been outputted, since the start of the 30 day period \',
            `ress_ships_contingent_used` decimal(65,10) DEFAULT 0.0000000000,
            `ress_contingent_used` decimal(65,10) DEFAULT 0.0000000000 COMMENT  \'saves how much ress are put to plannets of all bots, since the start of the 30 day period \',
            `first_points_multiplicator` int(11) DEFAULT 1 COMMENT  \'multiplicate with first playerpoints * 1000 to set the ress value wich will be put into the universe \',
            `bot_status` int(11) DEFAULT 1 COMMENT  \'0 = bots turned off, for protection of uni income \',
            `ress_value_metal` float DEFAULT 0.5 COMMENT  \'defines how much of the ress on the planets will be metal (0.3 = 30%) \',
            `ress_value_crystal` float DEFAULT 0.3 COMMENT  \'defines how much of the ress on the planets will be crystal (0.3 = 30%) \',
            `ress_value_deuterium` float DEFAULT 0.2 COMMENT  \'defines how much of the ress on the planets will be deuterium (0.3 = 30%) \',
            `max_fleet_seconds_in_space` int(11) DEFAULT 10800 COMMENT  \'fleet stays in spae for min 1h , this defines the max. time is chosen random between min and max. in seconds \',
            `min_fleet_seconds_in_space` int(11) DEFAULT 3600,
            `max_fleet_seconds_on_planet` int(11) DEFAULT 7200 COMMENT  \'fleet stays on planet for min 10min , this defines the max. time is chosen random between min and max. in seconds \',
            `min_fleet_seconds_on_planet` int(11) DEFAULT 720,
            `ships_array` text DEFAULT NULL COMMENT  \'serialized ships array, like this: array(array(shipvalue, name, leave_on_planet,cintingent_used,per_second,contingent) , ...) \',
            `number_of_bots` int(11) DEFAULT 100 COMMENT  \'is used to devide the monthly income under the bots \',
            `ress_factor` float DEFAULT 0.1 COMMENT  \'factor is used to determine how much of the monthly contingent is spend to ress , the rest is for fleet \',
            `is_bot` int(11) DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `id` (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci; '
        ); 
        $Names = file('./botnames.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        //make bot users
        for ($i = 0; $i < $number_of_bots; $i++) {
            $Name	= 'Lord ' . $Names[array_rand($Names)];
            $newBot = PlayerUtil::createPlayer(Universe::current(), $Name,bin2hex(random_bytes(16)) , 'bot@bot.bot','en');
            $this->db->update('UPDATE %%USERS%% SET is_bot = 1 WHERE id = :id', [':id' => $newBot[0]]);
            $this->db->insert('INSERT INTO '. DB_PREFIX .'bots (owner_id) VALUES (:id)', [':id' => $newBot[0]]);
            //make additional bot planets
            for($i1 = 1; $i1 < $number_of_planets; $i1++) {
                do {
                    $galaxy = mt_rand(1, $config->max_galaxy);
                    $system = mt_rand(1, $config->max_system);
                    $position = mt_rand(round($config->max_planets * 0.2), round($config->max_planets * 0.8));

                    if ($galaxy > $config->max_galaxy) {
                        $galaxy = mt_rand(1, $config->max_galaxy);
                    }
                    
                    if ($system > $config->max_system) {
                        $system = mt_rand(1, $config->max_system);
                    }
                } while (!PlayerUtil::isPositionFree(Universe::current(), $galaxy, $system, $position));
                $Name	= $Names[array_rand($Names)];
                $newPlanet = PlayerUtil::createPlanet($galaxy, $system, $position, Universe::current(), $newBot[0],$Name);
                
            }
            $this->db->update('UPDATE %%PLANETS%% SET is_bot = 1 WHERE id_owner = :id', [':id' => $newBot[0]]);
            
    }
                //create botsettings
                $this->db->insert('INSERT IGNORE INTO `'. DB_PREFIX .'bot_setting` (`id`, `name`, `metal_per_second`, `crystal_per_second`, `deuterium_per_second`, `last_set`, `last_bot`, `ress_contingent`, `ress_ships_contingent`, `full_contingent`, `full_contingent_used`, `ress_ships_contingent_used`, `ress_contingent_used`, `first_points_multiplicator`, `bot_status`, `ress_value_metal`, `ress_value_crystal`, `ress_value_deuterium`, `max_fleet_seconds_in_space`, `min_fleet_seconds_in_space`, `max_fleet_seconds_on_planet`, `min_fleet_seconds_on_planet`, `ships_array`, `number_of_bots`, `ress_factor`, `is_bot`) VALUES
                (0, \'strong\', 0.0000000000, 0.0000000000, 0.0000000000, 1732960860, 0, 0, 0, 0, 0.0000000000, 0.0000000000, 0.0000000000, 20, 1, 0.5, 0.3, 0.2, 18000, 1200, 3600, 120, \'\', 0, 0.1, 0),
                (1, \'medium\', 0.0000000000, 0.0000000000, 0.0000000000, 1732960860, 0, 0, 0, 0, 0.0000000000, 0.0000000000, 0.0000000000, 30, 1, 0.5, 0.3, 0.2, 18000, 1200, 3600, 120, \'\', 0, 0.1, 0),
                (2, \'hard\', 0.0000000000, 0.0000000000, 0.0000000000, 1732960860, 0, 0, 0, 0, 0.0000000000, 0.0000000000, 0.0000000000, 50, 1, 0.5, 0.3, 0.2, 18000, 1200, 3600, 120, \'\', 0, 0.1, 0);
            ');
            //create botfleet
            $this->createBaseBotTypeConfig();
            $this->reset_contingents();

            //create cronjob if not exists
            $cronexists = $this->db->select('SELECT * FROM %%CRONJOBS%% WHERE class = \'botsCronjob\'');
            if (empty($cronexists)){
            $this->db->insert('INSERT into %%CRONJOBS%% (`name`,isActive ,min,hours,dom,month,dow,class,nextTime) VALUES (\'Bots\', 1,\'*\',\'*\',\'*\',\'*\',\'*\',\'botsCronjob\',0)');
            }
        echo "Created bots";
    }

    // Delete all elements from bot planets
    public function deleteAllElementsFromBotPlanets() {
        global $resource;
        $planetsDeleteSql = '';

        foreach ($resource as $key => $value) {
            if ($key < 600 && !($key > 100 && $key < 200)) {
                $planetsDeleteSql .= "`{$value}` = 0, ";
            }
        }

        $this->db->update('UPDATE '. DB_PREFIX .'planets SET '. $planetsDeleteSql .' metal = 0, crystal = 0, deuterium = 0 WHERE is_bot = 1');
        $this->createBotFleetArrays();
        echo "Reseted bots";
    }

    // Delete a specific ship from a bot type
    public function deleteShip($botType, $shipName) {
        $bot = $this->db->select('SELECT ships_array FROM '. DB_PREFIX .'bot_setting WHERE id = :id', [':id' => $botType]);
        
        if (empty($bot)) {
            echo "Bot type not found.";
            return;
        }

        $shipsArray = unserialize($bot[0]['ships_array']);
        unset($shipsArray[$shipName]);

        $this->db->update('UPDATE '. DB_PREFIX .'bot_setting SET ships_array = :ships_array WHERE id = :id', [':ships_array' => serialize($shipsArray), ':id' => $botType]);
        echo "Deleted ship: {$shipName}";
    }

    // Delete all bot fleets
    public function deleteBotFleets() {
        $bots = $this->db->select('SELECT * FROM '. DB_PREFIX .'bots');
        
        foreach ($bots as $bot) {
            $shipsArray = unserialize($bot['ships_array']);
            
            foreach ($shipsArray as &$ship) {
                $ship['amount'] = 0;
            }
            
            $this->db->update('UPDATE '. DB_PREFIX .'bots SET ships_array = :ships_array WHERE id = :id', [':ships_array' => serialize($shipsArray), ':id' => $bot['id']]);
        }
    }

    // Delete a bot (not implemented)
    public function deleteBot($user_id) {
        //delete player
        PlayerUtil::deletePlayer($user_id);
        //delete botentry
        $this->db->delete('DELETE FROM '. DB_PREFIX .'bots WHERE owner_id = :user_id', [':user_id' => $user_id]);

        echo "bot deleted.";
    }

    public function reset_contingents() {
        $db = Database::get();
        $first_player_points = $db->select('select total_points from '. DB_PREFIX .'statpoints where stat_type = 1 and total_rank = 1')[0]['total_points'];
        $bot_setting = $db->select('select * from '. DB_PREFIX .'bot_setting');
        foreach ($bot_setting as $key => $value) {
            $bot_setting[$key]['ships_array'] = unserialize($value['ships_array']);
        }
        foreach ($bot_setting as $key => $bot_setting1) {
    
            $number_of_bots = count($db->select('select id as number_of_bots from '. DB_PREFIX .'bots where bot_type = :id_botsetting', array(':id_botsetting' => $bot_setting1['id'])));
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
                array(
                    ':metal_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_metal']) / $month_in_seconds) * $number_of_bots_factor, //per second per bot
                    ':crystal_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_crystal']) / $month_in_seconds) * $number_of_bots_factor,
                    ':deuterium_per_second' => $montly_resspoints_for_ress <= 0 ? 0 : (($montly_resspoints_for_ress * $bot_setting1['ress_value_deuterium']) / $month_in_seconds) * $number_of_bots_factor,
                    ':ress_contingenta' => $montly_resspoints_for_ress,
                    ':ress_ships_contingent' => $real_resspoints_for_ships,
                    ':full_contingenta' => $monthly_resspoints,
                    ':ships_array' => serialize($bot_setting1['ships_array']),
                    ':bot_type' => $bot_setting1['id'],
                    ':number_of_bots' => $number_of_bots,
                    ':last_set' => time()
                )
            );
        }
    }
}



?>