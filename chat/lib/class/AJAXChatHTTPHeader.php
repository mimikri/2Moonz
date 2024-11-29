<?php
/*
 * @package AJAX_Chat
 * @author Sebastian Tschan
 * @copyright (c) Sebastian Tschan
 * @license Modified MIT License
 * @link https://blueimp.net/ajax/
 */

// Class to manage HTTP header
class AJAXChatHTTPHeader {

	/**
  * @var string
  */
 public $_contentType;
	public $_constant;

	function __construct(string $encoding='UTF-8', $contentType=null, public $_noCache=true) {
		if($contentType) {
			$this->_contentType = $contentType.'; charset='.$encoding;
			$this->_constant = true;
		} else {
			if(isset($_SERVER['HTTP_ACCEPT']) && (str_contains((string) $_SERVER['HTTP_ACCEPT'],'application/xhtml+xml'))) {
				$this->_contentType = 'application/xhtml+xml; charset='.$encoding;
			} else {
	 			$this->_contentType = 'text/html; charset='.$encoding;
			}
			$this->_constant = false;
		}
	}

	// Method to send the HTTP header:
	function send(): void {
		// Prevent caching:
		if($this->_noCache) {
			header('Cache-Control: no-cache, must-revalidate');
			header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
		}
		
		// Send the content-type-header:
		header('Content-Type: '.$this->_contentType);
		
		// Send vary header if content-type varies (important for proxy-caches):
		if(!$this->_constant) {
			header('Vary: Accept');
		}
	}
    
	// Method to return the content-type string:
	function getContentType() {
		// Return the content-type string:
		return $this->_contentType;
	}

}
?>