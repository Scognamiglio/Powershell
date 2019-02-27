param ([string]$path,[int]$int,[string]$taskName)
$varCheminDuScript = $MyInvocation.MyCommand.Definition
$info=$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
$tache="$varCheminDuScript $info $int $taskname"
if($path -eq ""){
    write-host "il n'y a aucun paramètre en argument."
    exit
}
$tab=$path.Split("\")
if(Test-Path $path -PathType Leaf){
    write-host "Fichier passé en argument"
    $Filefrom=$tab[-1]
    $Pathfrom=$path.Replace($tab[-1],"")

}elseif(Test-Path $path -PathType Container){
    write-host "Dossier passé en argument"
    if($tab[-1] -eq ""){
        $Filefrom=$tab[-2]+"\"
        $Pathfrom=$path.Replace($tab[-2]+"\","")
    }else{
        $Filefrom=$tab[-1]+"\"
        $Pathfrom=$path.Replace($tab[-1],"")
    }

}else{
    write-host "l'argument n'amène à aucun fichier ou dossier."
    exit
}

if($int -eq ""){
    write-host "il manque l'intervale ! Pauvre intervale.... oublié de tous..."
    exit
}
if($int -lt 60){
    write-host "intervale trop petit !"
    exit
}else{
    write-host "L'intervale est de $int seconde !"
}

if($taskName -eq ""){
    Write-Host "La tâche est attendu au gichet 3"
}
$res=Get-ScheduledTask $taskName -ErrorAction Ignore
if($res){
    Write-Host "tâche existe"
}else{
    $min=[Math]::Floor($int/60)
    $seconde=$int-($min*60)
    $time="0 ab $min ab $seconde"
    $time=$time.Replace(" ab ",":")
$action=New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass $tache"
$trigger = New-JobTrigger -Once -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $time

Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Descriptif du script"     
}


$pathTo=$env:HOMEPATH+"\sauvegarde_auto"
if(Test-Path $pathTo -PathType Container){
    write-host "le repertoire existe !"
}else{
    $res = New-Item -Path $pathTo -ItemType directory
}
$t=get-date -format "yyyyMMdd_HHmmss"

if(!$Filefrom.EndsWith("\")){
    cp $path $pathTo\$t$Filefrom
}else{
    $use=$filefrom.Split("\")[0]
    Compress-Archive -Path $path -DestinationPath $pathTo\$t$use.zip
}