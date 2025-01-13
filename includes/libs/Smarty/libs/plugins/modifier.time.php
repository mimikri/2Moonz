<?php
/**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsFilter
 */
/**
 * Smarty time modifier
 *
 * @param string                    $source input string
 * @param \Smarty_Internal_Template $template
 *
 * @return string filtered output
 */
function smarty_modifier_time($timeInSeconds)
{
    global $LNG;

    $day    = floor($timeInSeconds / 86400);
    $hour   = floor((int)($timeInSeconds / 3600) % 24);
    $minute = floor((int)($timeInSeconds / 60) % 60);
    $second = floor((int) $timeInSeconds % 60);

    $time  = '';

    if($day > 0) {
        $time .= sprintf('%d%s ', $day, $LNG['short_day']);
    }

    if($hour > 0) {
        $time .= sprintf('%02d%s ', $hour, $LNG['short_hour']);
    }

    if($minute > 0) {
        $time .= sprintf('%02d%s ', $minute, $LNG['short_minute']);
    }

    return $time.sprintf('%02d%s',
        $second, $LNG['short_second']
    );
}
