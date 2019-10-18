$Daysback = "-60"
$path = "C:\Logs"
$date = get-date -format "yyyy-MM-dd-HH-mm"
$file = ("Log_" + $date + ".log")
$logfile = $path + "\" + $file
$logtext = $error
$error.clear()

# Write log to logpath
function Write-Log([string]$logtext, [int]$level=0)
{
	$logdate = get-date -format "yyyy-MM-dd HH:mm:ss"
	if($level -eq 0)
	{
		$logtext = "[INFO] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text
	}
	if($level -eq 1)
	{
		$logtext = "[WARNING] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text -ForegroundColor Yellow
	}
	if($level -eq 2)
	{
		$logtext = "[ERROR] " + $logtext
		$text = "["+$logdate+"] - " + $logtext
		Write-Host $text -ForegroundColor Red
						  
	}
	$text >> $logfile
	Clear-Log $Daysback
}
# Clear log older than x-Days
function Clear-Log([int]$Daysback)
{
	$LogPath = "D:\Logs" 
	$CurrentDate = Get-Date
	$DatetoDelete = $CurrentDate.AddDays($Daysback)
	Get-ChildItem $LogPath | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
}
try{
    $folder = gci 'C:\[YOURPATH]\[YOURFILE_NEW]'
    $files = gci 'C:\[YOURPATH_OLD]' -Filter *.xml | sort LastWriteTime -Desc 
    if ($files -and $folder){
        $files | select -First 1 | copy-item -Destination $folder -Force
        Write-Log "Success copying Backup XML"
    }
    else {
        throw $error
    }
}
catch{
    Write-Log "Error while copying Backup File: $error" 2
}