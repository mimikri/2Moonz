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

abstract class AbstractGamePage
{
	/**
	 * reference of the template object
	 * @var template
	 */
	protected $tplObj;

	/**
	 * reference of the template object
	 * @var ResourceUpdate
	 */
	protected $ecoObj;
	protected $window;
	protected $disableEcoSystem = false;

	protected function __construct() {

		if(!AJAX_REQUEST)
		{
			$this->setWindow('full');
			if(!$this->disableEcoSystem)
			{
				$this->ecoObj	= new ResourceUpdate();
				$this->ecoObj->CalcResource();
			}
			$this->initTemplate();
		} else {
			$this->setWindow('ajax');
			if(AJAX_REQUEST == 2){
			$this->initTemplate();
			}
		}
	}

	protected function initTemplate() {
		if(isset($this->tplObj))
			return true;

		$this->tplObj	= new template;
		[$tplDir]	= $this->tplObj->getTemplateDir();
		$this->tplObj->setTemplateDir($tplDir.'game/');
		return true;
	}

	protected function setWindow($window) {
		$this->window	= $window;
	}

	protected function getWindow() {
		return $this->window;
	}

	protected function getQueryString() {
		$queryString	= [];
		$page			= HTTP::_GP('page', '');

		if(!empty($page)) {
			$queryString['page']	= $page;
		}

		$mode			= HTTP::_GP('mode', '');
		if(!empty($mode)) {
			$queryString['mode']	= $mode;
		}

		return http_build_query($queryString);
	}

	protected function getCronjobsTodo()
	{
		require_once 'includes/classes/Cronjob.class.php';

		$this->assign(['cronjobs'		=> Cronjob::getNeedTodoExecutedJobs()]);
	}

	protected function getNavigationData()
	{
		global $PLANET, $LNG, $USER, $THEME, $resource, $reslist;

		$config			= Config::get();

		$PlanetSelect	= [];

		if(isset($USER['PLANETS'])) {
			$USER['PLANETS']	= getPlanets($USER);
		}

		foreach($USER['PLANETS'] as $PlanetQuery)
		{
			$PlanetSelect[$PlanetQuery['id']]	= $PlanetQuery['name'].(($PlanetQuery['planet_type'] == 3) ? " (" . $LNG['fcm_moon'] . ")":"")." [".$PlanetQuery['galaxy'].":".$PlanetQuery['system'].":".$PlanetQuery['planet']."]";
		}

		$resourceTable	= [];
		$resourceSpeed	= $config->resource_multiplier;
		foreach($reslist['resstype'][1] as $resourceID)
		{
			$resourceTable[$resourceID]['name']			= $resource[$resourceID];
			$resourceTable[$resourceID]['current']		= $PLANET[$resource[$resourceID]];
			$resourceTable[$resourceID]['max']			= $PLANET[$resource[$resourceID].'_max'];
			if($USER['urlaubs_modus'] == 1 || $PLANET['planet_type'] != 1)
			{
				$resourceTable[$resourceID]['production']	= $PLANET[$resource[$resourceID].'_perhour'];
			}
			else
			{
				$resourceTable[$resourceID]['production']	= $PLANET[$resource[$resourceID].'_perhour'] + $config->{$resource[$resourceID].'_basic_income'} * $resourceSpeed;
			}
		}

		foreach($reslist['resstype'][2] as $resourceID)
		{
			$resourceTable[$resourceID]['name']			= $resource[$resourceID];
			$resourceTable[$resourceID]['used']			= $PLANET[$resource[$resourceID].'_used'];
			$resourceTable[$resourceID]['max']			= $PLANET[$resource[$resourceID]];
		}

		foreach($reslist['resstype'][3] as $resourceID)
		{
			$resourceTable[$resourceID]['name']			= $resource[$resourceID];
			$resourceTable[$resourceID]['current']		= $USER[$resource[$resourceID]];
		}

		$themeSettings	= $THEME->getStyleSettings();

		$this->assign(['PlanetSelect'		=> $PlanetSelect, 'new_message' 		=> $USER['messages'], 'vacation'			=> $USER['urlaubs_modus'] ? _date($LNG['php_tdformat'], $USER['urlaubs_until'], $USER['timezone']) : false, 'delete'			=> $USER['db_deaktjava'] ? sprintf($LNG['tn_delete_mode'], _date($LNG['php_tdformat'], $USER['db_deaktjava'] + ($config->del_user_manually * 86400)), $USER['timezone']) : false, 'darkmatter'		=> $USER['darkmatter'], 'current_pid'		=> $PLANET['id'], 'image'				=> $PLANET['image'], 'resourceTable'		=> $resourceTable, 'shortlyNumber'		=> $themeSettings['TOPNAV_SHORTLY_NUMBER'], 'closed'			=> !$config->game_disable, 'hasBoard'			=> filter_var($config->forum_url, FILTER_VALIDATE_URL), 'hasAdminAccess'	=> !empty(Session::load()->adminAccess), 'hasGate'			=> $PLANET[$resource[43]] > 0]);
	}

	protected function getPageData()
	{
		global $USER, $THEME;

		if($this->getWindow() === 'full') {
			$this->getNavigationData();
			$this->getCronjobsTodo();
		}

		$dateTimeServer		= new DateTime("now");
		if(isset($USER['timezone'])) {
			try {
				$dateTimeUser	= new DateTime("now", new DateTimeZone($USER['timezone']));
			} catch (Exception) {
				$dateTimeUser	= $dateTimeServer;
			}
		} else {
			$dateTimeUser	= $dateTimeServer;
		}

		$config	= Config::get();

		$this->assign(['vmode'				=> $USER['urlaubs_modus'], 'authlevel'			=> $USER['authlevel'], 'userID'			=> $USER['id'], 'bodyclass'			=> $this->getWindow(), 'game_name'			=> $config->game_name, 'uni_name'			=> $config->uni_name, 'ga_active'			=> $config->ga_active, 'ga_key'			=> $config->ga_key, 'debug'				=> $config->debug, 'VERSION'			=> $config->VERSION, 'date'				=> explode("|", date('Y\|n\|j\|G\|i\|s\|Z', TIMESTAMP)), 'isPlayerCardActive' => isModuleAvailable(MODULE_PLAYERCARD), 'REV'				=> substr($config->VERSION, -4), 'Offset'			=> $dateTimeUser->getOffset() - $dateTimeServer->getOffset(), 'queryString'		=> $this->getQueryString(), 'themeSettings'		=> $THEME->getStyleSettings()]);
	}
	protected function printMessage($message, $redirectButtons = array('url' => '', 'label' => ''), $redirect = NULL, $fullSide = true)
	{
		$this->assign(['message'			=> $message, 'redirectButtons'	=> $redirectButtons]);

		if(isset($redirect)) {
			$this->tplObj->gotoside($redirect[0], $redirect[1]);
		}

		if(!$fullSide) {
			$this->setWindow('popup');
		}

		$this->display('error.default.tpl');
	}

	protected function save() {
		if(isset($this->ecoObj)) {
			$this->ecoObj->SavePlanetToDB();
		}
	}

	protected function assign($array, $nocache = true) {
		$this->tplObj->assign_vars($array, $nocache);
	}

	protected function display(string $file) {
		global $THEME, $LNG;

		$this->save();

		if($this->getWindow() !== 'ajax') {
			$this->getPageData();
		}

		$this->assign(['lang'    		=> $LNG->getLanguage(), 'dpath'			=> $THEME->getTheme(), 'scripts'		=> $this->tplObj->jsscript, 'execscript'	=> implode("\n", $this->tplObj->script), 'basepath'		=> PROTOCOL.HTTP_HOST.HTTP_BASE]);

		$this->assign(['LNG'			=> $LNG], false);

		$this->tplObj->display('extends:layout.'.$this->getWindow().'.tpl|'.$file);
		exit;
	}

	protected function sendJSON($data) {
		$this->save();
		echo json_encode($data);
		exit;
	}

	protected function redirectTo(string $url) {
		$this->save();
		HTTP::redirectTo($url);
		exit;
	}
}