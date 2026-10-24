# Lost Epoch — Simulation Test Results

**Test date:** October 19, 2026  
**Test script:** `scripts/ProximitySimulation.ps1`  
**Environment:** Windows PowerShell  
**Result:** PASS — 16 of 16 expected classifications

## Objective

Verify that the Lost Epoch proximity simulation correctly calculates three-dimensional separation and classifies distances according to configurable communication ranges, without requiring a Path of Titans server, API credentials, or connected players.

## Simulation Configuration

| Communication mode | Maximum range |
|---|---:|
| Whisper | 15 meters |
| Normal speech | 60 meters |
| Shout | 125 meters |

One simulated player remained stationary while the second moved along the X-axis in increments of 10 meters.

The simulation used an assumed coordinate conversion of 100 world units per meter.

## Recorded Results

| Distance | Observed classification |
|---|---|
| 0 m | Whisper / Normal / Shout |
| 10 m | Whisper / Normal / Shout |
| 20 m | Normal / Shout |
| 30 m | Normal / Shout |
| 40 m | Normal / Shout |
| 50 m | Normal / Shout |
| 60 m | Normal / Shout |
| 70 m | Shout Only |
| 80 m | Shout Only |
| 90 m | Shout Only |
| 100 m | Shout Only |
| 110 m | Shout Only |
| 120 m | Shout Only |
| 130 m | Out of Range |
| 140 m | Out of Range |
| 150 m | Out of Range |

## Verification

The simulation completed without errors.

All 16 recorded outputs matched the expected classifications for the configured communication ranges.

The experiment confirmed that the standalone demonstration can run without accessing the live Lost Epoch server or its authentication credentials.

## Limitations

This test uses synthetic coordinates rather than actual player movements.

The simulation exercises distance calculations along the X-axis; additional tests involving changes in Y and Z would provide more complete coverage.

The 10-meter sampling increments do not directly test the exact 15-meter and 125-meter boundaries.

The script does not capture, transmit, filter, or reproduce microphone audio. It demonstrates only the distance-classification component of a proposed proximity voice system.

## Next Development Milestones

1. Add automated tests for exact distance boundaries and three-dimensional positioning.
2. **Completed:** Created the visual demonstration of player movement and communication ranges (`dashboard/index.html`).
3. Prototype microphone audio with distance-based volume attenuation.
4. Investigate officially supported Path of Titans modding interfaces for native console integration.

## Conclusion

The standalone proximity simulation completed successfully and produced the expected classification in all 16 recorded samples.

Together with the live PS5 field tests, this provides repeatable evidence supporting the spatial-detection component of the proposed Lost Epoch communication system.

**Project status:** Functional proximity-detection and simulation prototypes. Native voice integration remains unverified.
