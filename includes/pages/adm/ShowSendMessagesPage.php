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

if (!allowedTo(str_replace([__DIR__, '\\', '/', '.php'], '', __FILE__))) throw new Exception("Permission error!");


function ShowSendMessagesPage(): void {
	global $USER, $LNG;
	
	$ACTION	= HTTP::_GP('action', '');
	if ($ACTION == 'send')
	{
		$class = match ($USER['authlevel']) {
      AUTH_MOD => 'mod',
      AUTH_OPS => 'ops',
      AUTH_ADM => 'admin',
      default => '',
  };

		$Subject	= HTTP::_GP('subject', '', true);
		$Message 	= HTTP::_GP('text', '', true);
		$Mode	 	= HTTP::_GP('mode', 0);
		$Lang		= HTTP::_GP('globalmessagelang', '');

		if (!empty($Message) && !empty($Subject))
		{
			require 'includes/classes/BBCode.class.php';
			if($Mode == 0 || $Mode == 2) {
				$From    	= '<span class="'.$class.'">'.$LNG['user_level_'.$USER['authlevel']].' '.$USER['username'].'</span>';
				$pmSubject 	= '<span class="'.$class.'">'.$Subject.'</span>';
				$pmMessage 	= '<span class="'.$class.'">'.BBCode::parse($Message).'</span>';
				$USERS		= $GLOBALS['DATABASE']->query("SELECT `id`, `username` FROM ".USERS." WHERE `universe` = '".Universe::getEmulated()."'".(!empty($Lang) ? " AND `lang` = '".$GLOBALS['DATABASE']->sql_escape($Lang)."'": "").";");
				while($UserData = $GLOBALS['DATABASE']->fetch_array($USERS))
				{
					$sendMessage = str_replace('{USERNAME}', $UserData['username'], $pmMessage);
					PlayerUtil::sendMessage($UserData['id'], $USER['id'], $From, 50, $pmSubject, $sendMessage, TIMESTAMP, NULL, 1, Universe::getEmulated());
				}
			}

			if($Mode == 1 || $Mode == 2) {
				require 'includes/classes/Mail.class.php';
				$userList	= [];
				
				$USERS		= $GLOBALS['DATABASE']->query("SELECT `email`, `username` FROM ".USERS." WHERE `universe` = '".Universe::getEmulated()."'".(!empty($Lang) ? " AND `lang` = '".$GLOBALS['DATABASE']->sql_escape($Lang)."'": "").";");
				while($UserData = $GLOBALS['DATABASE']->fetch_array($USERS))
				{				
					$userList[$UserData['email']]	= ['username'	=> $UserData['username'], 'body'		=> BBCode::parse(str_replace('{USERNAME}', $UserData['username'], $Message))];
				}
				
				Mail::multiSend($userList, strip_tags((string) $Subject));
			}
			exit($LNG['ma_message_sended']);
		} else {
			exit($LNG['ma_subject_needed']);
		}
	}
	
	$sendModes	= $LNG['ma_modes'];
	
	if(Config::get()->mail_active == 0)
	{
		unset($sendModes[1]);
		unset($sendModes[2]);
	}
	
	$template	= new template();
	$template->assign_vars(['langSelector' => array_merge(['' => $LNG['ma_all']], $LNG->getAllowedLangs(false)), 'modes' => $sendModes]);
	$template->show('SendMessagesPage.tpl');
}
