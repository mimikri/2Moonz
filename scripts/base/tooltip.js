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

function tiptool() {

	$(".tooltip").off('mouseenter').on('mouseenter', function (e) {
			var tip = $('#tooltip');
			tip.html($(this).attr('data-tooltip-content'));
			tip.show();
		});
	$(".tooltip").off('mouseleave').on('mouseleave', function () {
			var tip = $('#tooltip');
			tip.hide();
		});
		$(".tooltip").off('mousemove').on('mousemove', function (e) {
			var tip = $('#tooltip');
			var mousex = e.pageX + 30;
			var mousey = e.pageY + 30;
			var tipWidth = tip.width();
			var tipHeight = tip.height();
			var tipVisX = $(window).width() - (mousex + tipWidth);
			var tipVisY = $(window).height() - (mousey + tipHeight);
			if (tipVisX < 30) {
				mousex = e.pageX - tipWidth - 30;
			};
			if (tipVisY < 30) {
				mousey = e.pageY - tipHeight - 30;
			};
			tip.css({
				top : mousey,
				left : mousex
			});
		});

	$(".tooltip_sticky").off('mouseenter').on('mouseenter', function (e) {
		var tip = $('#tooltip');
		tip.html($(this).attr('data-tooltip-content'));
		tip.addClass('tooltip_sticky_div');
		tip.css({
			top : e.pageY - tip.outerHeight() / 2,
			left : e.pageX - tip.outerWidth() / 2
		});
		tip.show();
		nuscript('tooltip');
	});
	$(".tooltip_sticky_div").off('mouseleave').on('mouseleave', function () {
		var tip = $('#tooltip');
		tip.removeClass('tooltip_sticky_div');
		tip.hide();
	});
}
