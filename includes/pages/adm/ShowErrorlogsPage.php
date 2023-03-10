<?php


if (!allowedTo(str_replace(array(dirname(__FILE__), '\\', '/', '.php'), '', __FILE__))) throw new Exception("Permission error!");

function ShowErrorlogsPage()
{
  echo '
	<style>
td{
   border:.2vw solid #666;
   color: #f90;
font-family: Verdana;
background:black;
font-size:80%;
}
body{
  background:rgb(33, 37, 43);
}
div{
  color:#f90;
cursor:pointer;
max-width: 97vw;
}
  </style><button><a href="admin.php?page=Errorlogs" target="Hauptframe">gamelogs</a></button>
  <button onclick="$(\'.jsfehler\').toggle();$(\'.einau\').toggle();">clientlogs(<span class="einau"  style="color:var(--color-text-negativ);">ausgeblendet</span><span class="einau" style="color:var(--color-text-positiv); display:none;">eingeblendet</span>)</button>
 ';

  if(!isset($_GET['pah'])){
  echo '<table style="word-wrap: break-word;"><tr><td>game-errorlogs</td></tr><tr><td>';
  $file = file('./includes/error.log');
$output = array('');
$count = 0;
$count1 = 0;
$count2 = 0;
foreach($file as $f){

  if(strpos($f,'{main}') !== false){

    $output[$count] =  $output[$count] .'<code>' . htmlspecialchars($f) .  "</code></div></td></tr><tr><td>";
    $count++;

    $output[$count] = '<div onclick="document.getElementById(\'f' . $count. '\').style.display = \'block\';">';
  }else{
    if($output[$count] === '<div onclick="document.getElementById(\'f' . $count. '\').style.display = \'block\';">'){

      if(strpos($f, 'JsFehler') !== false){
        $output[$count] = '<div class="jsfehler" style="display:none;" onclick="document.getElementById(\'f' . $count. '\').style.display = \'block\';">';
      }else{
        $count1++;
      }
    $output[$count] .= $count1 . ".<code>".htmlspecialchars($f)."</code></div><div id='f" . $count . "' style='display:none; color:#fff'; onclick=\"this.style.display = 'none';\"><hr>";
    }else{


    $output[$count] .= htmlspecialchars($f)."<br />";
    }

}

}
$output = array_reverse($output);
echo implode($output);
echo '</td></tr></table>';
}elseif(isset($_GET['erlog'])){
  $dir = "/var/log/nginx";
  $output = array();
  chdir($dir);
$logs = file('error.log');
$logs = array_reverse($logs);
echo '<table>';
foreach($logs as $f => $f1){
echo '<tr><td><code>'. str_replace(' -','</code></td><td><code>',htmlspecialchars($f1)) .'</code></td></tr>';

}
echo '</table>';

}

}
