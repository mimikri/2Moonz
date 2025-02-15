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

function ShowMenuPage(): void
{
	global $USER;
	$template	= new template();
	
	$template->assign_vars(['supportticks'	=> $GLOBALS['DATABASE']->getFirstCell("SELECT COUNT(*) FROM ".TICKETS." WHERE universe = ".Universe::getEmulated()." AND status = 0;")]);
	
	$template->show('ShowMenuPage.tpl');
}
