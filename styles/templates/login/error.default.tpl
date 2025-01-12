{block name="title" prepend}{$LNG.fcm_info}{/block}
{block name="content"}
	{nocache}<table class="table519">
	<tr>
		<td><p>{$message}</p>{if !empty($redirectButtons)}<p>{foreach $redirectButtons as $button}<a href="{$button.url}"><button>{$button.label}</button></a>{/foreach}</p>{/if}</td>
	</tr>
</table>{/nocache}
{/block}