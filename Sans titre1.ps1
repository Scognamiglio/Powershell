$adr=read-host "indiquer l'adresse ip"
$b=$true;
try{
$iadr=[int]$adr.Substring(0,1);
}catch{
$b=$false;
}


if ($b){
$test=Resolve-DnsName $adr;
echo $test.name;
}
else{
$test=Resolve-DnsName $adr;
echo $test.IPAddress;

}