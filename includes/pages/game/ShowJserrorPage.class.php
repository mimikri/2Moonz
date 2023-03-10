<?php


class ShowJserrorPage extends AbstractGamePage
{
    public static $requireModule = MODULE_ERROR_JS;
	function __construct()
	{
		parent::__construct();
	}

	function show()
	{
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            $ip = $_SERVER['HTTP_CLIENT_IP'];
          } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
          } elseif (!empty($_SERVER['REMOTE_ADDR'])) {
            $ip = $_SERVER['REMOTE_ADDR'];
          } else {
            $ip = 'unknown';
          }
if(empty($_GET['message'])){ die(); }
    $errorText	= date("[d-M-Y H:i:s]", TIMESTAMP) . 'JsFehler: "' . $_GET['message'] . "\"\r\n";
    $errorText	.= 'ip: ###' . $ip ."###\r\n";
    $errorText .= isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : 'none';
    $errorText	.= 'get: '. print_r($_GET,true)."\r\n";
    $errorText	.= 'post: '.print_r($_POST,true)."\r\n";
  $errorText	.= '{main}' . "\r\n";
    if (is_writable('includes/error.log')) {
        global $USER;
        if(isset($USER['username'])){
        $User =   $USER['username'];
      }else{
        $User =   'unknown';
      }

         file_put_contents('includes/error.log', '[' . $User . ']' . $errorText, FILE_APPEND);
    }


	}
}
