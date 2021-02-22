clear
Get-Content ".\settings.ini" | foreach-object -begin {$config=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $config.Add($k[0], $k[1]) } }

function log {
    param(
    [parameter(Mandatory=$true)][String]$msg
        )

        $errorlogfolder = $config.errorlogfolder
        
        if ( !( Test-Path -Path $errorlogfolder -PathType "Container" ) ) {
            
           # Write-Verbose "Create error log folder in: $errorlogfolder"
            New-Item -Path $errorlogfolder -ItemType "Container" -ErrorAction SilentlyContinue
        }

        $filename ="\Error_Log"
        $filedate =get-date -format "dd-MM-yyyy"
        $file = $errorlogfolder+$filename+$filedate+".txt"
        #$file
    Add-Content -Path $file $msg
}

Function Kill-Process {
    [CmdletBinding()]        
   
    # Parameters used in this function
    param
    (
        [Parameter(Position=0, Mandatory = $false, HelpMessage="Provide server name", ValueFromPipeline = $true)] 
        $Server 
    ) 
		$hostname = $Server
		$Timestamp = get-date
        $Processes = Get-Process -ComputerName $Server -Name  $config.AppToKill -ErrorAction Stop 
        
        Write-Host "The following process "$config.AppToKill" has been selected to be killed on : $Server" -ForegroundColor DarkYellow


        $ErrorActionPreference = "Stop"
        ForEach($Process in $Processes){
                    
            Try{
                TASKKILL /s $Server /f /IM $Process.id                
                }
            Catch{
                $errormsg = $_.ToString()
                $exception = $_.Exception
                $stacktrace = $_.ScriptStackTrace
                $failingline = $_.InvocationInfo.Line
                $positionmsg = $_.InvocationInfo.PositionMessage
                $pscommandpath = $_.InvocationInfo.PSCommandPath
                $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
                $scriptname = $_.InvocationInfo.ScriptName

                log " " 
                log "************************************************************************************************************"
                log "Error happend at time: $timestamp on computer: $hostname"
                log "Error message: $errormsg"
                log "Error exception: $exception" 
                log "Failing script: $scriptname"
                log "Failing at line number: $failinglinenumber"
                log "Failing at line: $failingline"
                log "Powershell command path: $pscommandpath"
                log "Position message: $positionmsg" 
                log "Stack trace: $stacktrace"
                log "------------------------------------------------------------------------------------------------------------"
                Continue
                }
        }
		sleep 3
    if(!(Get-Process -ComputerName $hostname -Name $config.AppToKill -ErrorAction SilentlyContinue)){
        Write-Host "The  process "$config.AppToKill" has been killed on : $Server" -ForegroundColor Green
        $config.Result = 'True'
        }else{
        Kill-Process $hostname
        }

}

Function delete-files {
    Param
        (
        [Parameter(position = 0)] $server,
        [Parameter] $ToCsv
        )
		$hostname = $Server
		$Timestamp = get-date        
        try{
        $filepath1 = "\\"+$server+$config.Tmp
        remove-item -Path $filepath1 -Force 
        }
        catch{
                $errormsg = $_.ToString()
                $exception = $_.Exception
                $stacktrace = $_.ScriptStackTrace
                $failingline = $_.InvocationInfo.Line
                $positionmsg = $_.InvocationInfo.PositionMessage
                $pscommandpath = $_.InvocationInfo.PSCommandPath
                $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
                $scriptname = $_.InvocationInfo.ScriptName

                log " " 
                log "************************************************************************************************************"
                log "Error happend at time: $timestamp on computer: $hostname"
                log "Error message: $errormsg"
                log "Error exception: $exception" 
                log "Failing script: $scriptname"
                log "Failing at line number: $failinglinenumber"
                log "Failing at line: $failingline"
                log "Powershell command path: $pscommandpath"
                log "Position message: $positionmsg" 
                log "Stack trace: $stacktrace"
                log "------------------------------------------------------------------------------------------------------------"
          Continue
        }
        if ( !( Test-Path -Path $filepath1 -PathType "Container" ) ) {
        write-host "the directory $filepath1 has been deleted" -ForegroundColor Green
        }else{
        write-host "the directory $filepath1 has not been deleted" -ForegroundColor Red
        delete-files $hostname
        }

        try{
        $filepath2 = "\\"+$server+$config.Data
        remove-item -Path $filepath2  -Force 
        }
        catch{
                $errormsg = $_.ToString()
                $exception = $_.Exception
                $stacktrace = $_.ScriptStackTrace
                $failingline = $_.InvocationInfo.Line
                $positionmsg = $_.InvocationInfo.PositionMessage
                $pscommandpath = $_.InvocationInfo.PSCommandPath
                $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
                $scriptname = $_.InvocationInfo.ScriptName

                log " " 
                log "************************************************************************************************************"
                log "Error happend at time: $timestamp on computer: $hostname"
                log "Error message: $errormsg"
                log "Error exception: $exception" 
                log "Failing script: $scriptname"
                log "Failing at line number: $failinglinenumber"
                log "Failing at line: $failingline"
                log "Powershell command path: $pscommandpath"
                log "Position message: $positionmsg" 
                log "Stack trace: $stacktrace"
                log "------------------------------------------------------------------------------------------------------------"
          Continue
        }
        if ( !( Test-Path -Path $filepath1 -PathType "Container" ) ) {
        write-host "the directory $filepath2 has been deleted" -ForegroundColor Green
        }else{
        write-host "the directory $filepath2 has not been deleted" -ForegroundColor Red
        delete-files $hostname
        }
}

Function service-start {
    Param
        (
        [Parameter(position = 0)] $server,
        [Parameter] $ToCsv
        )
		$hostname = $Server
		$Timestamp = get-date
        try{
        Get-service -Name $config.Service -ComputerName $server | set-service -Status Running
        }
        catch{
                $errormsg = $_.ToString()
                $exception = $_.Exception
                $stacktrace = $_.ScriptStackTrace
                $failingline = $_.InvocationInfo.Line
                $positionmsg = $_.InvocationInfo.PositionMessage
                $pscommandpath = $_.InvocationInfo.PSCommandPath
                $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
                $scriptname = $_.InvocationInfo.ScriptName

                log " " 
                log "************************************************************************************************************"
                log "Error happend at time: $timestamp on computer: $hostname"
                log "Error message: $errormsg"
                log "Error exception: $exception" 
                log "Failing script: $scriptname"
                log "Failing at line number: $failinglinenumber"
                log "Failing at line: $failingline"
                log "Powershell command path: $pscommandpath"
                log "Position message: $positionmsg" 
                log "Stack trace: $stacktrace"
                log "------------------------------------------------------------------------------------------------------------"
          Continue
        }
        if((Get-service -Name $config.Service -ComputerName $server).Status -eq 'Running'){
        write-host "the service Jboss has been started on server: $server" -ForegroundColor Green
        }else{
        service-start $server 
        }
}

#$config
$servers = $config.Servers -split "," |ForEach{ $_}

Foreach($server in $servers){
    #$server
    kill-process $server

    if($config.Result -eq 'True'){
	sleep 3
        delete-files $server

        service-start $server

    }

}

