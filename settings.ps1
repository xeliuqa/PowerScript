
function main {
$currentDate = Get-Date -Format "yyyyMMdd_HHmmss"                              	#Get current Date

	#-------------------Start Editing-------------------

    $title = "NodeTest"	                                                    	#Name to show in window
    $walletAddress = "sm1qqqqqqpnfhpru2ecacpa7jv7l3kt6ltk73pj2ggkfdq3f"  	#Your Wallet Address
    $provider = "0"								#Your GPU Number
    $numunits = "4" 								# 1 unit = 64GB
    $postFileLocation = "E:\node5"						#PoST Location
    $filelock = "afairtest"							#Afair name (anything)
    $maxFileSize = "2147483648"							#Bin File Zize Default 4294967296
    #-------------------Stop Editing-------------------
    #-----------------Advance Settings-----------------
    $config = ".\config.mainnet.json"						#config.mainnet.json Location
    $smdataLocation = ".\sm_data"						#Node DataBase Location
    $tcpPort = "7513" 								# If port 7513 gives problems, change to something else eg. 7514
    $logOutputPath = "output_$currentDate.txt"					#Log name use _$currentDate for diferent logs
    $goSpacemeshLocation = ".\go-spacemesh.exe"					#go-sm location
    $localDateTime = "Yes" 							# Yes/No.  This will change the log Date into a localized Time/Date.

	#-------------------Stop Editing-------------------

    $dateColor = "Green"
    $otherColor = "DarkGray"
    $errorLevelColor = @{
        INFO = "Cyan"
        WARN = "Yellow"
        DEBUG = "DarkYellow"
        ERROR = "Red" 
	FATAL = "Magenta"
    }

    $searchKeyword = "ALL" # This filters on the second loglevel column (INFO, WARN, DEBUG, etc.)  Use "ALL" to see everything.
    
    if (!(Test-Path "$($logOutputPath)")) {
        New-Item -path "$($logOutputPath)" -type File
    }
	if (!(Test-Path $postFileLocation -PathType Container)) {
		New-Item -ItemType Directory -Force -Path $postFileLocation
	}
	else {
		Write-Host -ForegroundColor green "
		----------------------------------------
		        Power Script is Starting
		----------------------------------------"
	}

	$host.UI.RawUI.WindowTitle = $title
    # Test to see if this go-spacemesh is already running.  If it is, ignore.  Do not relaunch.
    $processFilePath = (Get-Item $goSpacemeshLocation).FullName
    $processName = (Get-Item $goSpacemeshLocation).BaseName
    $runningProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue
    $processIsRunning = $false
    foreach ($proc in $runningProcesses) {
        if ($proc.Path -eq $processFilePath) {
            $processIsRunning = $true
            break
        }
    }
    if (-not $processIsRunning) {
        $process = Start-Process -NoNewWindow -FilePath $goSpacemeshLocation -ArgumentList "--listen /ip4/0.0.0.0/tcp/$tcpPort", "--config", $config, "-d", $smdataLocation, "--smeshing-coinbase", $walletAddress, "--smeshing-start", "--filelock", $filelock, "--smeshing-opts-datadir", $postFileLocation, "--smeshing-opts-provider", $provider, "--smeshing-opts-numunits", $numunits, "--smeshing-opts-maxfilesize", $maxFileSize -RedirectStandardOutput $logOutputPath
    }
    colorizeLogs -logs $logOutputPath -searchKeyword $searchKeyword
}
function colorizeLogs {
    Param(
        [string]$logs,
        [string]$searchKeyword
    )

    Get-Content -Path $logs -Wait | ForEach-Object {
        $parts = $_ -split '\t'
        
        $dateConversionSuccessful = $true
        try { # Test to see if each line is in the correct format, and ignore if not.
            $logDate = Get-Date $parts[0]
        } catch {
            $dateConversionSuccessful = $false
        }

        if ($dateConversionSuccessful) {         
            if ($searchKeyword -match "ALL") {$searchKeyword = $null}
            if ($parts.Count -gt 2 -and $parts[1] -match $searchKeyword) {
                $eLColor = $errorLevelColor[$parts[1]]
                if ($localDateTime -match "Yes") {$logDate = $logDate.ToString("yyyy/MM/dd - HH:mm:ss.fff, dddd")} else {$logDate = $parts[0]}
                Write-Host -NoNewline -ForegroundColor $dateColor $logDate
                Write-Host -NoNewline -ForegroundColor $otherColor "`t"
                Write-Host -NoNewline -ForegroundColor $eLColor $parts[1]
                Write-Host -NoNewline -ForegroundColor $otherColor "`t"

                for ($i = 2; $i -lt $parts.Count; $i++) {
                    Write-Host -NoNewline -ForegroundColor $otherColor $parts[$i]
                    if ($i -ne $parts.Count - 1) {
                        Write-Host -NoNewline -ForegroundColor $otherColor "`t"
                    }
                }        
                Write-Host ""
            }
        }    
    }
}
main
