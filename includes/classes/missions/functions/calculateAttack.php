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


function calculateAttack(array &$attackers, array &$defenders, $FleetTF, $DefTF): array
{
	global $pricelist, $CombatCaps, $resource;

	$TRES 	= ['attacker' => 0, 'defender' => 0];
	$ARES 	= $DRES = ['metal' => 0, 'crystal' => 0];
	$ROUND	= [];
	$RF		= [];

	$attackAmount = [];
	$defenseAmount = [];
	$STARTDEF = [];

	foreach ($attackers as $fleetID => $attacker) 
	{
		foreach ($attacker['unit'] as $element => $amount) 
		{
			$ARES['metal'] 		+= $pricelist[$element]['cost'][901] * $amount;
			$ARES['crystal'] 	+= $pricelist[$element]['cost'][902] * $amount;
		}
	}

	foreach($CombatCaps as $e => $arr) {
		if(!isset($arr['sd'])) continue;
		
		foreach($arr['sd'] as $t => $sd) {
			if($sd == 0) continue;
			$RF[$t][$e] = $sd;
		}
	}
	
	$TRES['attacker']	= $ARES['metal'] + $ARES['crystal'];

	foreach ($defenders as $fleetID => $defender) 
	{
		foreach ($defender['unit'] as $element => $amount)
		{
			if ($element < 300) {
				$DRES['metal'] 		+= $pricelist[$element]['cost'][901] * $amount;
				$DRES['crystal'] 	+= $pricelist[$element]['cost'][902] * $amount ;

				$TRES['defender'] 	+= $pricelist[$element]['cost'][901] * $amount;
				$TRES['defender'] 	+= $pricelist[$element]['cost'][902] * $amount;
			} else {
				if (!isset($STARTDEF[$element])) 
					$STARTDEF[$element] = 0;
				
				$STARTDEF[$element] += $amount;

				$TRES['defender']	+= $pricelist[$element]['cost'][901] * $amount;
				$TRES['defender']	+= $pricelist[$element]['cost'][902] * $amount;
			}
		}
	}
	
	for ($ROUNDC = 0; $ROUNDC <= MAX_ATTACK_ROUNDS; $ROUNDC++) 
	{
		$attackDamage  = ['total' => 0];
		$attackShield  = ['total' => 0];
		$attackAmount  = ['total' => 0];
		$defenseDamage = ['total' => 0];
		$defenseShield = ['total' => 0];
		$defenseAmount = ['total' => 0];
		$attArray = [];
		$defArray = [];

		foreach ($attackers as $fleetID => $attacker) {
			$attackDamage[$fleetID] = 0;
			$attackShield[$fleetID] = 0;
			$attackAmount[$fleetID] = 0;

			$attTech	= (1 + (0.1 * $attacker['player']['military_tech']) + $attacker['player']['factor']['Attack']); //attaque
			$defTech	= (1 + (0.1 * $attacker['player']['defence_tech']) + $attacker['player']['factor']['Defensive']); //bouclier
			$shieldTech = (1 + (0.1 * $attacker['player']['shield_tech']) + $attacker['player']['factor']['Shield']); //coque
			$attackers[$fleetID]['techs'] = [$attTech, $defTech, $shieldTech];
				
			foreach ($attacker['unit'] as $element => $amount) {
				$thisAtt	= $amount * ($CombatCaps[$element]['attack']) * $attTech * (random_int(80, 120) / 100); //attaque
				$thisDef	= $amount * ($CombatCaps[$element]['shield']) * $defTech ; //bouclier
				$thisShield	= $amount * ($pricelist[$element]['cost'][901] + $pricelist[$element]['cost'][902]) / 10 * $shieldTech; //coque

				$attArray[$fleetID][$element] = ['def' => $thisDef, 'shield' => $thisShield, 'att' => $thisAtt];

				$attackDamage[$fleetID] += $thisAtt;
				$attackDamage['total'] += $thisAtt;
				$attackShield[$fleetID] += $thisDef;
				$attackShield['total'] += $thisDef;
				$attackAmount[$fleetID] += $amount;
				$attackAmount['total'] += $amount;
			}
		}

		foreach ($defenders as $fleetID => $defender) {
			$defenseDamage[$fleetID] = 0;
			$defenseShield[$fleetID] = 0;
			$defenseAmount[$fleetID] = 0;

			$attTech	= (1 + (0.1 * $defender['player']['military_tech']) + $defender['player']['factor']['Attack']); //attaquue
			$defTech	= (1 + (0.1 * $defender['player']['defence_tech']) + $defender['player']['factor']['Defensive']); //bouclier
			$shieldTech = (1 + (0.1 * $defender['player']['shield_tech']) + $defender['player']['factor']['Shield']); //coque
			$defenders[$fleetID]['techs'] = [$attTech, $defTech, $shieldTech];

			foreach ($defender['unit'] as $element => $amount) {
				$thisAtt	= $amount * ($CombatCaps[$element]['attack']) * $attTech * (random_int(80, 120) / 100); //attaque
				$thisDef	= $amount * ($CombatCaps[$element]['shield']) * $defTech ; //bouclier
				$thisShield	= $amount * ($pricelist[$element]['cost'][901] + $pricelist[$element]['cost'][902]) / 10 * $shieldTech; //coque

				if ($element == 407 || $element == 408 || $element == 409) $thisAtt = 0;

				$defArray[$fleetID][$element] = ['def' => $thisDef, 'shield' => $thisShield, 'att' => $thisAtt];

				$defenseDamage[$fleetID] += $thisAtt;
				$defenseDamage['total'] += $thisAtt;
				$defenseShield[$fleetID] += $thisDef;
				$defenseShield['total'] += $thisDef;
				$defenseAmount[$fleetID] += $amount;
				$defenseAmount['total'] += $amount;
			}
		}

		$ROUND[$ROUNDC] = ['attackers' => $attackers, 'defenders' => $defenders, 'attackA' => $attackAmount, 'defenseA' => $defenseAmount, 'infoA' => $attArray, 'infoD' => $defArray];

		if ($ROUNDC >= MAX_ATTACK_ROUNDS || $defenseAmount['total'] <= 0 || $attackAmount['total'] <= 0) {
			break;
		}

		// Calculate hit percentages (ACS only but ok)
		$attackPct = [];
		foreach ($attackAmount as $fleetID => $amount) {
			if (!is_numeric($fleetID)) continue;
				$attackPct[$fleetID] = $amount / $attackAmount['total'];
		}

		$defensePct = [];
		foreach ($defenseAmount as $fleetID => $amount) {
			if (!is_numeric($fleetID)) continue;
				$defensePct[$fleetID] = $amount / $defenseAmount['total'];
		}

		// CALCUL DES PERTES !!!
		$attacker_n = [];
		$attacker_shield = 0;
		$defenderAttack	= 0;
		foreach ($attackers as $fleetID => $attacker) {
			$attacker_n[$fleetID] = [];

			foreach($attacker['unit'] as $element => $amount) {
				if ($amount <= 0) {
					$attacker_n[$fleetID][$element] = 0;
					continue;
				}

				$defender_moc = $amount * ($defenseDamage['total'] * $attackPct[$fleetID]) / $attackAmount[$fleetID];
			
				if(isset($RF[$element])) {
					foreach($RF[$element] as $shooter => $shots) {
						foreach($defArray as $fID => $rfdef) {
							if(empty($rfdef[$shooter]['att']) || $attackAmount[$fleetID] <= 0) continue;

							$defender_moc += $rfdef[$shooter]['att'] * $shots / ($amount / $attackAmount[$fleetID] * $attackPct[$fleetID]);
							$defenseAmount['total'] += $defenders[$fID]['unit'][$shooter] * $shots;
						}
					}
				}
				
				$defenderAttack	+= $defender_moc;
				
				if (($attArray[$fleetID][$element]['def'] / $amount) >= $defender_moc) {
					$attacker_n[$fleetID][$element] = round($amount);
					$attacker_shield += $defender_moc;
					continue;
				}

				$max_removePoints = floor($amount * $defenseAmount['total'] / $attackAmount[$fleetID] * $attackPct[$fleetID]);

				$attacker_shield += min($attArray[$fleetID][$element]['def'], $defender_moc);
				$defender_moc 	 -= min($attArray[$fleetID][$element]['def'], $defender_moc);

				$ile_removePoints = max(min($max_removePoints, $amount * min($defender_moc / $attArray[$fleetID][$element]['shield'] * (random_int(0, 200) / 100), 1)), 0);

				$attacker_n[$fleetID][$element] = max(ceil($amount - $ile_removePoints), 0);
			}
		}

		$defender_n = [];
		$defender_shield = 0;
		$attackerAttack	= 0;
		foreach ($defenders as $fleetID => $defender) {
			$defender_n[$fleetID] = [];

			foreach($defender['unit'] as $element => $amount) {
				if ($amount <= 0) {
					$defender_n[$fleetID][$element] = 0;
					continue;
				}

				$attacker_moc = $amount * ($attackDamage['total'] * $defensePct[$fleetID]) / $defenseAmount[$fleetID];
				if (isset($RF[$element])) {
					foreach($RF[$element] as $shooter => $shots) {
						foreach($attArray as $fID => $rfatt) {
							if (empty($rfatt[$shooter]['att']) || $defenseAmount[$fleetID] <= 0 ) continue;

							$attacker_moc += $rfatt[$shooter]['att'] * $shots / ($amount / $defenseAmount[$fleetID] * $defensePct[$fleetID]);
							$attackAmount['total'] += $attackers[$fID]['unit'][$shooter] * $shots;
						}
					}
				}
				
				$attackerAttack	+= $attacker_moc;
				
				if (($defArray[$fleetID][$element]['def'] / $amount) >= $attacker_moc) {
					$defender_n[$fleetID][$element] = round($amount);
					$defender_shield += $attacker_moc;
					continue;
				}
	
				$max_removePoints = floor($amount * $attackAmount['total'] / $defenseAmount[$fleetID] * $defensePct[$fleetID]);
				$defender_shield += min($defArray[$fleetID][$element]['def'], $attacker_moc);
				$attacker_moc 	 -= min($defArray[$fleetID][$element]['def'], $attacker_moc);
				
				$ile_removePoints = max(min($max_removePoints, $amount * min($attacker_moc / $defArray[$fleetID][$element]['shield'] * (random_int(0, 200) / 100), 1)), 0);

				$defender_n[$fleetID][$element] = max(ceil($amount - $ile_removePoints), 0);
			}
		}
		
		$ROUND[$ROUNDC]['attack'] 		= $attackerAttack;
		$ROUND[$ROUNDC]['defense'] 		= $defenderAttack;
		$ROUND[$ROUNDC]['attackShield'] = $attacker_shield;
		$ROUND[$ROUNDC]['defShield'] 	= $defender_shield;
		foreach ($attackers as $fleetID => $attacker) {
			$attackers[$fleetID]['unit'] = array_map('round', $attacker_n[$fleetID]);
		}

		foreach ($defenders as $fleetID => $defender) {
			$defenders[$fleetID]['unit'] = array_map('round', $defender_n[$fleetID]);
		}
	}
	
	if ($attackAmount['total'] <= 0 && $defenseAmount['total'] > 0) {
		$won = "r"; // defender
	} elseif ($attackAmount['total'] > 0 && $defenseAmount['total'] <= 0) {
		$won = "a"; // attacker
	} else {
		$won = "w"; // draw
	}

	// CDR
	foreach ($attackers as $fleetID => $attacker) {					   // flotte attaquant en CDR
		foreach ($attacker['unit'] as $element => $amount) {
			$TRES['attacker'] -= $pricelist[$element]['cost'][901] * $amount ;
			$TRES['attacker'] -= $pricelist[$element]['cost'][902] * $amount ;

			$ARES['metal'] -= $pricelist[$element]['cost'][901] * $amount ;
			$ARES['crystal'] -= $pricelist[$element]['cost'][902] * $amount ;
		}
	}

	$DRESDefs = ['metal' => 0, 'crystal' => 0];

	foreach ($defenders as $fleetID => $defender) {
		foreach ($defender['unit'] as $element => $amount) {
			if ($element < 300) {							// flotte defenseur en CDR
				$DRES['metal'] 	 -= $pricelist[$element]['cost'][901] * $amount ;
				$DRES['crystal'] -= $pricelist[$element]['cost'][902] * $amount ;

				$TRES['defender'] -= $pricelist[$element]['cost'][901] * $amount ;
				$TRES['defender'] -= $pricelist[$element]['cost'][902] * $amount ;
			} else {									// defs defenseur en CDR + reconstruction
				$TRES['defender'] -= $pricelist[$element]['cost'][901] * $amount ;
				$TRES['defender'] -= $pricelist[$element]['cost'][902] * $amount ;

				$lost = $STARTDEF[$element] - $amount;
				$giveback = round($lost * (random_int(56, 84) / 100));
				$defenders[$fleetID]['unit'][$element] += $giveback;
				$DRESDefs['metal'] 	 += $pricelist[$element]['cost'][901] * ($lost - $giveback) ;
				$DRESDefs['crystal'] += $pricelist[$element]['cost'][902] * ($lost - $giveback) ;
			}
		}
	}
	
	$ARES['metal']		= max($ARES['metal'], 0);
	$ARES['crystal']	= max($ARES['crystal'], 0);
	$DRES['metal']		= max($DRES['metal'], 0);
	$DRES['crystal']	= max($DRES['crystal'], 0);
	$TRES['attacker']	= max($TRES['attacker'], 0);
	$TRES['defender']	= max($TRES['defender'], 0);
	
	$totalLost = ['attacker' => $TRES['attacker'], 'defender' => $TRES['defender']];
	$debAttMet = ($ARES['metal'] * ($FleetTF / 100));
	$debAttCry = ($ARES['crystal'] * ($FleetTF / 100));
	$debDefMet = ($DRES['metal'] * ($FleetTF / 100)) + ($DRESDefs['metal'] * ($DefTF / 100));
	$debDefCry = ($DRES['crystal'] * ($FleetTF / 100)) + ($DRESDefs['crystal'] * ($DefTF / 100));

	return ['won' => $won, 'debris' => ['attacker' => [901 => $debAttMet, 902 => $debAttCry], 'defender' => [901 => $debDefMet, 902 => $debDefCry]], 'rw' => $ROUND, 'unitLost' => $totalLost];
}