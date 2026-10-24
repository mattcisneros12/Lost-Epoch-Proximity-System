# Runs the real detector with synthetic API responses; never contacts a server.
$ErrorActionPreference = 'Stop'
$script:checks = 0
$global:LostEpochSyntheticResponse = $null
function Invoke-RestMethod { param($Uri, $Headers, $Method, $TimeoutSec, $ErrorAction) $global:LostEpochSyntheticResponse }
$previousKey = $env:LOST_EPOCH_API_KEY
$env:LOST_EPOCH_API_KEY = 'synthetic-test-value'
function Check-Detector($first, $second, $expected) {
    $global:LostEpochSyntheticResponse = [pscustomobject]@{ players = @(
        [pscustomobject]@{ name = 'Synthetic A'; location = $first },
        [pscustomobject]@{ name = 'Synthetic B'; location = $second }
    ) }
    $output = (& "$PSScriptRoot/../scripts/ProximityDetector.ps1" -Player1 'Synthetic A' -Player2 'Synthetic B' -Samples 1 6>&1 3>&1 | Out-String)
    if ($output -notmatch [regex]::Escape($expected)) { throw "Detector assertion $script:checks failed: expected $expected; got $output" }
    if ($expected -eq 'Player location unavailable.' -and $output -match ' m \|') { throw 'Invalid location produced a distance' }
    $script:checks++
}
try {
    $origin = [pscustomobject]@{ x = 0; y = 0; z = 0 }
    foreach ($axis in @('x', 'y', 'z')) {
        foreach ($bad in @('missing', $null, '', ' ', 'invalid', $true, @(), @(1,2), [double]::NaN, [double]::PositiveInfinity, [double]::NegativeInfinity)) {
            $location = @{ x = 0; y = 0; z = 0 }
            if ($bad -eq 'missing') { $location.Remove($axis) } else { $location[$axis] = $bad }
            Check-Detector ([pscustomobject]$location) $origin 'Player location unavailable.'
            Check-Detector $origin ([pscustomobject]$location) 'Player location unavailable.'
        }
    }
    Check-Detector $null $origin 'Player location unavailable.'
    Check-Detector $origin $null 'Player location unavailable.'
    Check-Detector $origin $origin '0.00 m | WHISPER / NORMAL / SHOUT'
    Check-Detector ([pscustomobject]@{ x = '-300'; y = '400'; z = '1200' }) $origin '13.00 m | WHISPER / NORMAL / SHOUT'
    foreach ($case in @(
        @(14.99, 'WHISPER / NORMAL / SHOUT'), @(15, 'WHISPER / NORMAL / SHOUT'), @(15.01, 'NORMAL / SHOUT'),
        @(59.99, 'NORMAL / SHOUT'), @(60, 'NORMAL / SHOUT'), @(60.01, 'SHOUT ONLY'),
        @(124.99, 'SHOUT ONLY'), @(125, 'SHOUT ONLY'), @(125.01, 'OUT OF RANGE')
    )) {
        Check-Detector ([pscustomobject]@{ x = $case[0] * 100; y = 0; z = 0 }) $origin $case[1]
    }
    Write-Output "PASS: $script:checks detector checks"
} finally {
    $env:LOST_EPOCH_API_KEY = $previousKey
    Remove-Variable LostEpochSyntheticResponse -Scope Global -ErrorAction SilentlyContinue
}


