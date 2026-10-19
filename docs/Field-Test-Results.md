# Lost Epoch — Field Test Results

**Test date:** October 19, 2026  
**Test environment:** Path of Titans dedicated community server, Riparia map  
**Clients:** Two PlayStation 5 consoles  
**Test subjects:** Utahraptor and Achillobator  
**Implementation:** `scripts/ProximityDetector.ps1`

## Objective

Validate that the Lost Epoch Proximity Detector can retrieve live player positions through Alderon's dedicated server REST API, calculate three-dimensional player separation, and classify proximity using configurable speaking ranges.

## Configuration

| Speaking mode | Configured maximum distance |
|---|---:|
| Whisper | 15 m |
| Normal conversation | 60 m |
| Shout | 125 m |

These distances are experimental design choices, not verified Path of Titans voice-chat settings.

Distance calculations assume 100 Unreal world units per meter. This conversion has not been independently validated for Riparia.

## Test 1 — Whisper Boundary

**20 samples; approximately 0.5 seconds apart.**

The players started 4.04 meters apart and moved farther away.

- At 11.83 m, the detector displayed `WHISPER / NORMAL / SHOUT`.
- At 15.76 m, the detector displayed `NORMAL / SHOUT`.
- The final measured separation was 53.76 m.

**Result:** The detector correctly classified samples on both sides of the configured 15-meter whisper threshold.

## Test 2 — Out-of-Range Detection

**20 samples; approximately 0.5 seconds apart.**

Measured player separation ranged from 323.75 to 333.68 meters.

Every sample displayed `OUT OF RANGE`.

**Result:** The detector consistently classified distant players beyond the maximum configured speaking radius.

## Test 3 — Normal and Shout Boundaries

**20 samples; approximately 0.5 seconds apart.**

Players moved from 28.05 meters to 131.37 meters apart.

At the normal speaking boundary:

- 55.81 m: `NORMAL / SHOUT`
- 61.30 m: `SHOUT ONLY`

At the maximum shouting boundary:

- 120.49 m: `SHOUT ONLY`
- 126.08 m: `OUT OF RANGE`

**Result:** The detector correctly classified samples on both sides of the configured 60-meter and 125-meter thresholds.

## Overall Results

Across the three documented tests:

- 60 usable proximity measurements were recorded.
- Both PS5 players were detected through the server API.
- Distance calculations updated during player movement.
- All three configured speaking-range boundaries were exercised.
- No API request failures were visible in the supplied test outputs.

## Limitations

This testing establishes the operation of the proximity-detection script under the tested conditions.

It does not demonstrate microphone capture, voice transmission, actual audio attenuation, or native PS5 voice integration.

The experiment used two players only. Performance with larger populations has not yet been measured.

The API sampling interval was approximately half a second; end-to-end positional latency was not measured.

## Next Steps

1. Add repeatable simulation tests that do not require a live server.
2. Validate coordinate scaling and test additional player combinations.
3. Develop a standalone audio prototype.
4. Investigate supported Path of Titans modding interfaces and console compatibility.

**Project status:** Working server-side proximity-detection prototype. Not a completed voice-chat mod.
