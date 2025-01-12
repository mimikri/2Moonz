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

class ShowChatPage extends AbstractGamePage
{
	public static $requireModule = MODULE_CHAT;

	function __construct() 
	{
		parent::__construct();
	}
	function getmessages(): void 
	{
			$db = Database::get();
			$channel = 0;
			if((int)$_GET['chat_mode'] > 0){
				global $USER;
				$channel = $USER['ally_id'];
			} 
			
			$lastMessageId = $_GET['lastMessageId'] ?? null;
			if ($lastMessageId === null) {
				// Fetch the last 100 messages
				$messages = $db->select('SELECT * FROM uni1_chat where channel_id=:channel ORDER BY id DESC LIMIT 100',[':channel' => $channel]);
			} else {
				// Fetch new messages since the given ID
				$messages = $db->select('SELECT * FROM uni1_chat WHERE id > :lastMessageId and channel_id=:channel ORDER BY id DESC', [
					':lastMessageId' => $lastMessageId,
					':channel' => $channel,
				]);
			}
			
			header('Content-Type: application/json');
		echo json_encode(array_reverse($messages)); // Reverse to show oldest first		
	
	}
	function show(): void 
	{

global $USER;
	/*	$action	= HTTP::_GP('action', '');
		if($action == 'alliance') {
			$this->setWindow('popup');
			$this->initTemplate();
		}
		
		$this->display('page.chat.default.tpl');*/
		
	
		if(isset($_POST['message'])){
			$channel = 0;
			if((int)$_GET['chat_mode'] > 0){
				$channel = $USER['ally_id'];
			} 
			$db = Database::get();
			$db->insert('insert into uni1_chat (sender_id,channel_id,message,username) values (:sender_id,:channel_id,:message,:username)',[
			':sender_id' => $USER['id'],
			':channel_id' => $channel,
			':message' => htmlspecialchars($_POST['message']),
			':username' => $USER['username'],

			]);
			#keep each channel under at max 100 messages
			$db->delete('delete from uni1_chat where id < :lastid and channel_id = :channel',[':lastid' => $db->lastInsertId() - 100,':channel' => $channel]);
			die();
		}
		$this->assign(['ownid'	=> $USER['id'], 'chat_mode' => $_GET['chat_mode'] ?? 0]);
		$this->display('page.chat.default.tpl');
		
	
	}
}
