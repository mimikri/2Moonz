<?php
/*
 * @package AJAX_Chat
 * @author Sebastian Tschan
 * @copyright (c) Sebastian Tschan
 * @license Modified MIT License
 * @link https://blueimp.net/ajax/
 */

// Class to provide static encoding methods
class AJAXChatEncoding {

	// Helper function to store special chars as we cannot use static class members in PHP4:
	public static function getSpecialChars() {
		static $specialChars;
		if(!$specialChars) {
			// As &apos; is not supported by IE, we use &#39; as replacement for "'":
			$specialChars = ['&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;', "'"=>'&#39;', '"'=>'&quot;'];	
		}
		return $specialChars;
	}

	// Helper function to store Regular expression for NO-WS-CTL as we cannot use static class members in PHP4:
	public static function getRegExp_NO_WS_CTL() {
		static $regExp_NO_WS_CTL;
		if(!$regExp_NO_WS_CTL) {
			// Regular expression for NO-WS-CTL, non-whitespace control characters (RFC 2822), decimal 1–8, 11–12, 14–31, and 127:
			$regExp_NO_WS_CTL = '/[\x0\x1\x2\x3\x4\x5\x6\x7\x8\xB\xC\xE\xF\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x7F]/';
		}
		return $regExp_NO_WS_CTL;
	}

	public static function convertEncoding($str, $charsetFrom, $charsetTo) {
		if(function_exists('mb_convert_encoding')) {
			return mb_convert_encoding($str, $charsetTo, $charsetFrom);
		}
		if(function_exists('iconv')) {
			return iconv((string) $charsetFrom, (string) $charsetTo, (string) $str);
		}
		if(($charsetFrom == 'UTF-8') && ($charsetTo == 'ISO-8859-1')) {
			return mb_convert_encoding($str, 'ISO-8859-1');
		}
		if(($charsetFrom == 'ISO-8859-1') && ($charsetTo == 'UTF-8')) {
			return mb_convert_encoding($str, 'UTF-8', 'ISO-8859-1');
		}
		return $str;
	}

	public static function htmlEncode($str, $contentCharset='UTF-8') {
		return match ($contentCharset) {
      'UTF-8' => AJAXChatEncoding::encodeSpecialChars($str),
      'ISO-8859-1', 'ISO-8859-15' => AJAXChatEncoding::convertEncoding(AJAXChatEncoding::encodeEntities($str, 'UTF-8', [
          0x26,
          0x26,
          0,
          0xFFFF,
          // &
          0x3C,
          0x3C,
          0,
          0xFFFF,
          // <
          0x3E,
          0x3E,
          0,
          0xFFFF,
          // >
          0x27,
          0x27,
          0,
          0xFFFF,
          // '
          0x22,
          0x22,
          0,
          0xFFFF,
          // "
          0x100,
          0x2FFFF,
          0,
          0xFFFF,
      ]), 'UTF-8', $contentCharset),
      default => AJAXChatEncoding::convertEncoding(AJAXChatEncoding::encodeEntities($str, 'UTF-8', [
          0x26,
          0x26,
          0,
          0xFFFF,
          // &
          0x3C,
          0x3C,
          0,
          0xFFFF,
          // <
          0x3E,
          0x3E,
          0,
          0xFFFF,
          // >
          0x27,
          0x27,
          0,
          0xFFFF,
          // '
          0x22,
          0x22,
          0,
          0xFFFF,
          // "
          0x80,
          0x2FFFF,
          0,
          0xFFFF,
      ]), 'UTF-8', $contentCharset),
  };
	}

	public static function encodeSpecialChars($str): string {
		return strtr($str, AJAXChatEncoding::getSpecialChars());
	}

	public static function decodeSpecialChars($str): string {
		return strtr($str, array_flip(AJAXChatEncoding::getSpecialChars()));
	}

	public static function encodeEntities($str, $encoding='UTF-8', $convmap=null): string {
		if($convmap && function_exists('mb_encode_numericentity')) {
			return mb_encode_numericentity((string) $str, $convmap, $encoding);
		}
		return htmlentities((string) $str, ENT_QUOTES, $encoding);
	}

	public static function decodeEntities($str, $encoding='UTF-8', $htmlEntitiesMap=null): string {
		// Due to PHP bug #25670, html_entity_decode does not work with UTF-8 for PHP versions < 5:
		if(function_exists('html_entity_decode') && version_compare(phpversion(), 5, '>=')) {
			// Replace numeric and literal entities:
			$str = html_entity_decode((string) $str, ENT_QUOTES, $encoding);
			// Replace additional literal HTML entities if an HTML entities map is given:
			if($htmlEntitiesMap) {
				$str = strtr($str, $htmlEntitiesMap);
			}
		} else {
			// Replace numeric entities:
			$str = preg_replace_callback('~&#([0-9]+);~', fn($matches) => AJAXChatEncoding::unicodeChar("\x01"), (string) $str);
			$str = preg_replace_callback('~&#x([0-9a-f]+);~i', fn($matches) => AJAXChatEncoding::unicodeChar(hexdec("\x01")), $str);
			// Replace literal entities:
			$htmlEntitiesMap = $htmlEntitiesMap ?: array_flip(get_html_translation_table(HTML_ENTITIES, ENT_QUOTES));
			$str = strtr($str, $htmlEntitiesMap);
		}
		return $str;
	}

	public static function unicodeChar($c): ?string {
		if($c <= 0x7F) {
			return chr($c);
		} else if($c <= 0x7FF) {
			return chr(0xC0 | $c >> 6) . chr(0x80 | $c & 0x3F);
		} else if($c <= 0xFFFF) {
			return chr(0xE0 | $c >> 12) . chr(0x80 | $c >> 6 & 0x3F)
										. chr(0x80 | $c & 0x3F);
		} else if($c <= 0x10FFFF) {
			return chr(0xF0 | $c >> 18) . chr(0x80 | $c >> 12 & 0x3F)
										. chr(0x80 | $c >> 6 & 0x3F)
										. chr(0x80 | $c & 0x3F);
		} else {
			return null;
		}
	}

	public static function removeUnsafeCharacters($str): string|array|null {
		// Remove NO-WS-CTL, non-whitespace control characters (RFC 2822), decimal 1–8, 11–12, 14–31, and 127:
		return preg_replace(AJAXChatEncoding::getRegExp_NO_WS_CTL(), '', (string) $str);
	}

}
?>