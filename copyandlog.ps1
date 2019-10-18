# Clear log older than x-Days
$Daysback = "-60"
try{
    $folder = 'C:\YOUR_PATH[\NEW_FILE]'
    $files = gci 'C:\YOUR_PATH\OLD' -Filter *.xml | sort LastWriteTime -Desc 
    if ($files){
        $files | select -First 1 | copy-item -Destination $folder -Force
        Write-Log "Success copying Backup XML"
    }
    elseif (!$files){
        throw "File is NULL"
    }
    else {
        throw $error
    }
}
catch{
    Write-Log "Error while copying Backup File: $error" 2
}
finally{
    $path = "C:\Temp"
    $date = get-date -format "yyyy-MM-dd-HH-mm-ss"
    $file = ("Log_" + $date + ".log")
    $logfile = $path + "\" + $file
    $logtext = $error
    $error.clear()

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
    
    function Clear-Log([int]$Daysback)
    {
        $LogPath = "C:\temp" 
        $CurrentDate = Get-Date
        $DatetoDelete = $CurrentDate.AddDays($Daysback)
        Get-ChildItem $LogPath | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
    }
}
