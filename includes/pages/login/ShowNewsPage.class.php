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

class ShowNewsPage extends AbstractLoginPage
{
	public static $requireModule = 0;

	function __construct() 
	{
		parent::__construct();
	}
	
	function show(): void 
	{
		global $LNG;

		$sql = "SELECT date, title, text, user FROM %%NEWS%% ORDER BY id DESC;";
		$newsResult = Database::get()->select($sql);

		$newsList	= [];
		
		foreach ($newsResult as $newsRow)
		{
			$newsList[]	= ['title' => $newsRow['title'], 'from' 	=> sprintf($LNG['news_from'], _date($LNG['php_tdformat'], $newsRow['date']), $newsRow['user']), 'text' 	=> makebr($newsRow['text'])];
		}
		
		$this->assign(['newsList'	=> $newsList]);
		
		$this->display('page.news.default.tpl');
	}
}