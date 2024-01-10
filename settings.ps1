
function main {
    $currentDate = Get-Date -Format "yyyyMMdd_HHmmss"                       #Get current Date

	#-------------------Start Editing-------------------

	$title = "NodeName"	
    $walletAddress = "stest1qqqqqqqpcpmljkxcscyj83uz6hl4dfhjgqjhzxqygkzwa"  # Your Wallet Address
    $provider = "1"															# Your GPU Number
    $numunits = "100" 														# 1 unit = 64GB
    $postFileLocation = ".\Post"											# PoST Location
    $filelock = "afair1"													# Afair name (anything)
    $maxFileSize = "1073741824"												# Bin File Zize Default 4294967296
    #-----------------Port Settings-----------------
    $grpcPublicListener = "0.0.0.0:9092"                                    # GRPC Ports, default 9092
    $grpcPrivateListener = "0.0.0.0:9093"                                   # GRPC Ports, default 9093
    $grpcJsonListener = "0.0.0.0:9094"                                      # GRPC Ports, default 9094
    #-----------------Proofing Settings-----------------
    $smeshingNonces = "288"                                                 # Number of nonces used for proofing. (use https://plan.smesh.online/ to calculate)
    $smeshingThreads = "0"                                                  # Number of Threads used for proofing.
    #-------------------Stop Editing-------------------
    #-----------------Advance Settings-----------------
    $config = ".\config.mainnet.json"
    $smdataLocation = ".\sm_data"											# Node DataBase Location
    $tcpPort = "7513" 														# If port 7513 gives problems, change to something else eg. 7514
    $logOutputPath = "output_$currentDate.txt"								# Log name
    $goSpacemeshLocation = ".\go-spacemesh.exe"								# go-sm location
    $localDateTime = "Yes" 													# Yes/No.  This will change the log Date into a localized Time/Date.

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
    if (!(Test-Path "$($config)")) {
        New-Item -path "$($config)" -type File -Value ('{"p2p": {"disable-reuseport": false, "p2p-disable-legacy-discovery": true, "autoscale-peers": true, "min-peers": 10, "low-peers": 15, "high-peers": 20, "inbound-fraction": 1, "outbound-fraction": 0.5},"logging": {
            "p2p": "error"
        }}')
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
        $process = Start-Process -NoNewWindow -FilePath $goSpacemeshLocation -ArgumentList "--listen /ip4/0.0.0.0/tcp/$tcpPort", "--config", $config, "-d", $smdataLocation, "--smeshing-coinbase", $walletAddress, "--filelock",  $filelock,  "--smeshing-opts-datadir", $postFileLocation, "--smeshing-opts-provider", $provider, "--smeshing-opts-numunits", $numunits, "--smeshing-opts-maxfilesize", $maxFileSize,   "--grpc-public-listener", $grpcPublicListener, "--grpc-private-listener", $grpcPrivateListener,  "--grpc-json-listener", $grpcJsonListener,  "--smeshing-opts-proving-nonces", $smeshingNonces,  "--smeshing-opts-proving-threads", $smeshingThreads, "--smeshing-start" -RedirectStandardOutput $logOutputPath
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