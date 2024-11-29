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

class HTTP {
	
	static public function redirectTo(string $URL, $external = false): void
	{
		if($external)
		{
			self::sendHeader('Location', $URL);
		}
		else
		{
			self::sendHeader('Location', HTTP_PATH.$URL);
		}
		exit;
	}

	static public function sendHeader(string $name, $value = NULL): void
	{
		header($name.(!is_null($value) ? ': '.$value : ''));
	}

	static public function redirectToUniverse(string $universe): void
	{
		HTTP::redirectTo(PROTOCOL.HTTP_HOST.HTTP_BASE."uni".$universe."/".HTTP_FILE, true);
	}

	static public function sendCookie($name, $value = "", $toTime = NULL): void
	{
		setcookie($name, (string) $value, $toTime);
	}
	
	static public function _GP($name, $default, $multibyte = false, $highnum = false)
	{
		if(!isset($_REQUEST[$name]))
		{
			return $default;
		}

		if(is_float($default) || $highnum)
		{
			return (float) $_REQUEST[$name];
		}
		
		if(is_int($default))
		{
			return (int) $_REQUEST[$name];			
		}

		if(is_string($default))
		{
			return self::_quote($_REQUEST[$name], $multibyte);
		}
		
		if(is_array($default) && is_array($_REQUEST[$name]))
		{
			return self::_quoteArray($_REQUEST[$name], $multibyte, !empty($default) && $default[0] === 0);
		}
		
		return $default;
	}

	/**
  * @return mixed[]
  */
 private static function _quoteArray(array $var, $multibyte, bool $onlyNumbers = false): array
	{
		$data	= [];
		foreach($var as $key => $value)
		{
			if(is_array($value))
			{
				$data[$key]	= self::_quoteArray($value, $multibyte);
			}
			elseif($onlyNumbers)
			{
				$data[$key]	= (int) $value;
			}
			else
			{
				$data[$key]	= self::_quote($value, $multibyte);
			}
		}

		return $data;
	}

	private static function _quote($var, $multibyte): string|array|null
	{
		$var	= str_replace(["\r\n", "\r", "\0"], ["\n", "\n", ''], $var);
		$var	= htmlspecialchars($var, ENT_QUOTES, 'UTF-8');
		$var	= trim($var);

		if ($multibyte) {
			if (!preg_match('/^./u', $var))
			{
				$var = '';
			}
		}
		else
		{
			$var = preg_replace('/[\x80-\xFF]/', '?', $var); // no multibyte, allow only ASCII (0-127)
		}

		return $var;
	}
}