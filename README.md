# Lost Epoch — Proximity Communication System

**An experimental spatial communication project for Path of Titans**

## About Lost Epoch

**Lost Epoch** is an independently operated, cross-platform *Path of Titans* community server running on the **Riparia** map.

The server features a curated collection of prehistoric creature mods and emphasizes player-driven survival, exploration, cooperation, and competitive gameplay.

The **Lost Epoch Proximity Communication System** is an independent research project exploring how distance-based voice communication and environmental audio could create new gameplay opportunities.

## Interactive Demonstration

### [Launch the Lost Epoch Spatial Communication Laboratory](https://mattcisneros12.github.io/Lost-Epoch-Proximity-System/dashboard/)

Our publicly accessible browser simulation demonstrates:

- Independent movement of two dinosaurs.
- Real-time distance calculations.
- Comparison of dinosaur vocalization ranges and proposed human speaking ranges.
- Whispering, normal speech, and shouting mechanics.
- Directional source selection and modeled volume attenuation.

**This is an interactive simulation, not a functioning voice-chat application.** It uses synthetic coordinates and does not require access to the Lost Epoch game server.

## Project Objective

Our long-term goal is to investigate an optional proximity communication system where players can hear conversations based on their dinosaurs' positions.

Proposed features include:

- **Spatial communication:** Voices become quieter and perceptually more distant as players separate.
- **Whispering and shouting:** Different speaking ranges encourage stealth, coordination, deception, and strategic gameplay.
- **Environmental audio:** Explore underwater muffling, cave-specific sound profiles, and map-aware acoustic effects.
- **Cross-platform support:** Investigate officially supported integration options for PC and PlayStation 5.

## Verified Development Work

Initial experiments used two PlayStation 5 consoles connected to the Lost Epoch dedicated server.

### Live proximity detection

Successfully demonstrated:

- Authenticated requests to Alderon's dedicated server REST API.
- Retrieval of player identities, species, and three-dimensional positions.
- Repeated position sampling approximately twice per second.
- Real-time calculation of distance between two players.
- Correct proximity classification across configurable whisper, normal, and shout boundaries.

### Standalone simulation

Developed and tested a PowerShell simulation requiring no game server or authentication credentials.

All 16 recorded simulation samples produced the expected proximity classifications.

### Acoustic research

Conducted preliminary in-game listening experiments investigating dinosaur vocalization ranges, perceived distance, cave audio behavior, and underwater muffling.

These observations informed our design decisions but do not establish the game's underlying audio implementation.

### Interactive dashboard

Developed and published a browser-based demonstration that compares proposed speech behavior with preliminary dinosaur vocalization observations.

The dashboard supports independent movement of two simulated dinosaurs and dynamically scales the visualization according to the selected sound range.

## Project Files

| File | Purpose |
|---|---|
| `scripts/ProximityDetector.ps1` | Live server API proximity detector |
| `scripts/ProximitySimulation.ps1` | Standalone synthetic movement simulation |
| `dashboard/index.html` | Interactive browser-based acoustic simulator |
| `docs/Field-Test-Results.md` | Recorded PS5 proximity experiments |
| `docs/Simulation-Test-Results.md` | Standalone simulation test results |
| `docs/Acoustic-Research.md` | Preliminary dinosaur sound observations |

## Current Development Status

**Completed and tested:**
- Live PS5 player-position retrieval and proximity calculations.
- Configurable speaking-range classification.
- Standalone simulation.
- Interactive browser demonstration.
- Initial field-test and acoustic research documentation.

**Planned or under investigation:**
- Additional automated testing and audio experiments.
- Working microphone-to-microphone voice prototype.
- Environmental audio processing.
- Official Path of Titans DevKit capabilities.
- Native PS5 microphone access, voice networking, and in-game playback.

**Important limitation:** Native PS5 voice integration has not been demonstrated. Its feasibility depends on the interfaces and permissions available through the game's approved modding system.

## Development Principles

- Work within Alderon Games' official modding framework.
- Protect server credentials and player privacy.
- Separate experimental software from production server operations.
- Clearly distinguish verified results from design concepts.
- Document technical limitations and testing methods.

## Community and Project Links

- **Community server:** Lost Epoch
- **Game:** Path of Titans
- **Map:** Riparia
- **[Interactive simulator](https://mattcisneros12.github.io/Lost-Epoch-Proximity-System/dashboard/)**
- **[Source code repository](https://github.com/mattcisneros12/Lost-Epoch-Proximity-System)**
- **[Lost Epoch Discord](https://discord.gg/y3nas9bTS)**

## Next Milestone

Investigate official Path of Titans modding capabilities and develop a standalone, proximity-aware microphone audio prototype.

---

*Lost Epoch and this research project are independently operated and are not affiliated with or endorsed by Alderon Games.*

## Automated regression tests

Run from the repository root (Node.js 24 and Windows PowerShell 5.1 or PowerShell 7):

```powershell
powershell -NoProfile -File tests/ProximityDetector.Tests.ps1
pwsh -NoProfile -File tests/ProximityDetector.Tests.ps1
node tests/dashboard.test.cjs
```

The detector tests replace API requests with synthetic responses. They need no server,
real API key, player data, or extra PowerShell modules. They cover invalid coordinates,
valid zero and numeric-string coordinates, 3D distance, and inclusive speaking boundaries.
Missing, blank, nonnumeric, boolean, collection, NaN, or infinite axes produce
`Player location unavailable.` instead of a distance classification.

The dashboard tests execute the shipped inline script with a minimal DOM substitute.
They cover below/at/above all voice and vocalization ranges, both voice sources,
source marker placement, control visibility, volume display, and reset. These are
script/DOM regression checks, not browser rendering or live audio tests.
`WITHIN RANGE` includes the exact boundary; modeled volume is 0% there and may
round to 0% just inside it. This matches the detector's inclusive range rule.
GitHub Actions runs these checks on Windows for pushes and pull requests.
