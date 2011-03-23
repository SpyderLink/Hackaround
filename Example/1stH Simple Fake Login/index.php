<?php
$uname = $HTTP_GET_VARS["name"];
$upass = $HTTP_GET_VARS["pass"];
$file = fopen("users.txt", "a");
fwrite($file, $uname . ":" . $upass . "\n");
fclose($file);
?>