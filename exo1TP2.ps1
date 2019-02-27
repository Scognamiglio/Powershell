$b = import-csv -Delimiter ';' test.csv
$nom=@();
$groupe=@();
$taille=$b.count


for($i=0;$taille -gt $i;$i++){

Get-LocalUser $b.Nom[$i];
}

