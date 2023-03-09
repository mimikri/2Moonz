{include file="ins_header.tpl"}
<tr>
	<td class="left">
		<h2>{$LNG.step1_head}</h2>
		<p>{$LNG.step1_desc}</p>
		<form action="index.php?mode=install&step=4" method="post"> 
		<input type="hidden" name="post" value="1">
		<table class="req">
			<tr>
<td class="transparent left"><p>{$LNG.step1_mysql_server}</p></td>
				<td class="transparent"><input type="text" name="host" value="{if empty($smarty.get.host)}{$host}{else}{$smarty.get.host|escape:'htmlall'}{/if}" size="30"></td>
			</tr>
			<tr>
				<td class="transparent left"><p>{$LNG.step1_mysql_port}</p></td>
				<td class="transparent"><input type="text" name="port" value="{if empty($smarty.get.port)}3306{else}{$smarty.get.port|escape:'htmlall'}{/if}" size="30"></td>
			</tr>
			<tr>
				<td class="transparent left"><p>{$LNG.step1_mysql_dbuser}</p></td>
				<td class="transparent"><input type="text" name="user" value="{if empty($smarty.get.user)}{$user}{else}{$smarty.get.user|escape:'htmlall'}{/if}" size="30"></td>
			</tr>
			<tr>
				<td class="transparent left"><p>{$LNG.step1_mysql_dbpass}</p></td>
				<td class="transparent"><input type="password" name="passwort" value="{$user}" size="30"></td>
			</tr>
			<tr>
				<td class="transparent left"><p>{$LNG.step1_mysql_dbname}</p></td>
				<td class="transparent"><input type="text" name="dbname" value="{if empty($smarty.get.dbname)}{$dbname}{else}{$smarty.get.dbname|escape:'htmlall'}{/if}" size="30"></td>
			</tr>
			<tr>
				<td class="transparent left"><p>{$LNG.step1_mysql_prefix}</p></td>
				<td class="transparent"><input type="text" name="prefix" value="{if empty($smarty.get.prefix)}uni1_{else}{$smarty.get.prefix|escape:'htmlall'}{/if}" size="30"></td>
			</tr>
			<tr class="noborder">
				<td colspan="2" class="transparent"><input type="submit" name="next" value="{$LNG.continue}"></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
{include file="ins_footer.tpl"}