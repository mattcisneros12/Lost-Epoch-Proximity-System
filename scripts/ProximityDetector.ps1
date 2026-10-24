
<#
.SYNOPSIS
    Lost Epoch - Proximity Detector

.DESCRIPTION
    Reads live Path of Titans player positions from the
    local dedicated server API and calculates 3D distance.

    Experimental speaking ranges:
      Whisper: 15 meters
      Normal:  60 meters
      Shout:  125 meters

    This is a proximity detector, not an audio transmitter.

.NOTES
    Requires Windows PowerShell 5.1 or later.
    Store your API key in the LOST_EPOCH_API_KEY
    environment variable. Never put it in this file.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Player1,

    [Parameter(Mandatory = $true)]
    [string]$Player2,

    [string]$ApiUrl = "http://127.0.0.1:8765/v1/api/players",

    [ValidateRange(1, 100000)]
    [double]$WhisperRange = 15,

    [ValidateRange(1, 100000)]
    [double]$NormalRange = 60,

    [ValidateRange(1, 100000)]
    [double]$ShoutRange = 125,

    [ValidateRange(100, 60000)]
    [int]$IntervalMs = 500,

    [ValidateRange(1, 100000)]
    [int]$Samples = 20,

    [ValidateRange(1, 100000)]
    [double]$UnitsPerMeter = 100
)

# Reject missing or malformed axes before PowerShell can coerce them to zero.
function Test-PlayerLocation($location) {
    if ($null -eq $location) { return $false }
    foreach ($axis in @('x', 'y', 'z')) {
        $value = $location.$axis
        if ($null -eq $value -or $value -is [bool] -or
            $value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
            return $false
        }
        if ($value -is [string] -and [string]::IsNullOrWhiteSpace($value)) {
            return $false
        }
        try { $coordinate = [double]$value } catch { return $false }
        if ([double]::IsNaN($coordinate) -or [double]::IsInfinity($coordinate)) {
            return $false
        }
    }
    return $true
}

if ([string]::IsNullOrWhiteSpace($env:LOST_EPOCH_API_KEY)) {
    Write-Error "Missing LOST_EPOCH_API_KEY environment variable."
    exit 1
}

if (-not ($WhisperRange -le $NormalRange -and
          $NormalRange -le $ShoutRange)) {
    Write-Error "Speaking ranges must be ordered: Whisper <= Normal <= Shout."
    exit 1
}

$headers = @{
    Authorization = "Bearer $env:LOST_EPOCH_API_KEY"
}

Write-Host "Lost Epoch - Proximity Detector"
Write-Host "Tracking: $Player1 and $Player2"
Write-Host "Press Ctrl+C to stop."
Write-Host ""

for ($i = 1; $i -le $Samples; $i++) {
    try {
        $response = Invoke-RestMethod `
            -Uri $ApiUrl `
            -Headers $headers `
            -Method Get `
            -TimeoutSec 5 `
            -ErrorAction Stop

        $first = $response.players |
            Where-Object { $_.name -eq $Player1 } |
            Select-Object -First 1

        $second = $response.players |
            Where-Object { $_.name -eq $Player2 } |
            Select-Object -First 1

        if ($null -eq $first -or $null -eq $second) {
            Write-Host "Waiting for both players..."
        }
        elseif (-not (Test-PlayerLocation $first.location) -or
                -not (Test-PlayerLocation $second.location)) {
            Write-Host "Player location unavailable."
        }
        else {
            $dx = [double]$first.location.x -
                  [double]$second.location.x
            $dy = [double]$first.location.y -
                  [double]$second.location.y
            $dz = [double]$first.location.z -
                  [double]$second.location.z

            $distance = [Math]::Sqrt(
                $dx * $dx + $dy * $dy + $dz * $dz
            ) / $UnitsPerMeter

            $status = if ($distance -le $WhisperRange) {
                "WHISPER / NORMAL / SHOUT"
            }
            elseif ($distance -le $NormalRange) {
                "NORMAL / SHOUT"
            }
            elseif ($distance -le $ShoutRange) {
                "SHOUT ONLY"
            }
            else {
                "OUT OF RANGE"
            }

            "{0:HH:mm:ss.fff} | {1:N2} m | {2}" -f `
                (Get-Date), $distance, $status
        }
    }
    catch {
        Write-Warning "API request failed. Check server and API settings."
    }

    if ($i -lt $Samples) {
        Start-Sleep -Milliseconds $IntervalMs
    }
}
