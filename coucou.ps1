$res=Get-ScheduledTask "CCleanerSkipUAC"
if($res){
    Write-host oui
} else{

    Write-host non
}