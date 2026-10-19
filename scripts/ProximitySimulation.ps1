
<#
.SYNOPSIS
    Lost Epoch - Proximity Communication Simulation

.DESCRIPTION
    Demonstrates experimental speaking ranges using
    synthetic 3D coordinates and simulated player movement.

    Does not require Path of Titans, an API key,
    a network connection, or live players.

    Compatible with Windows PowerShell 5.1 and later.
#>

param(
    [ValidateRange(1, 10000)]
    [double]$WhisperRange = 15,

    [ValidateRange(1, 10000)]
    [double]$NormalRange = 60,

    [ValidateRange(1, 10000)]
    [double]$ShoutRange = 125,

    [ValidateRange(1, 1000)]
    [double]$StepMeters = 10,

    [ValidateRange(1, 60000)]
    [int]$IntervalMs = 500,

    [ValidateRange(1, 100000)]
    [double]$UnitsPerMeter = 100
)

if (-not ($WhisperRange -le $NormalRange -and
          $NormalRange -le $ShoutRange)) {
    Write-Error "Speaking ranges must be ordered: Whisper <= Normal <= Shout."
    exit 1
}

# Player A remains at the origin.
$playerA = @{
    x = 0.0
    y = 0.0
    z = 0.0
}

# Player B starts beside Player A.
$playerB = @{
    x = 0.0
    y = 0.0
    z = 0.0
}

# Simulate travel beyond the maximum voice radius.
$maxDistance = $ShoutRange + 30

Write-Host ""
Write-Host "====================================="
Write-Host " LOST EPOCH - PROXIMITY SIMULATION"
Write-Host "====================================="
Write-Host ""
Write-Host "Mode: Synthetic 3D player movement"
Write-Host "Whisper: $WhisperRange m"
Write-Host "Normal:  $NormalRange m"
Write-Host "Shout:   $ShoutRange m"
Write-Host ""
Write-Host "Press Ctrl+C to stop."
Write-Host ""

for ($meters = 0; $meters -le $maxDistance;
     $meters += $StepMeters) {

    # Move Player B along the X axis.
    # The coordinate unit scale matches the detector.
    $playerB.x = $meters * $UnitsPerMeter

    $dx = $playerA.x - $playerB.x
    $dy = $playerA.y - $playerB.y
    $dz = $playerA.z - $playerB.z

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

    "{0,7:N2} m | {1}" -f $distance, $status

    Start-Sleep -Milliseconds $IntervalMs
}

Write-Host ""
Write-Host "Simulation complete."
