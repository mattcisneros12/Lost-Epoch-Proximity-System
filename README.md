# Lost Epoch — Proximity Communication System

### Experimental development project for Path of Titans

Lost Epoch is a cross-platform Path of Titans community server. This project explores proximity-based player communication, environmental audio, and how spatial information from Alderon's dedicated server API could support new gameplay mechanics.

## Project Objective

Develop an optional proximity communication system in which players can hear nearby conversations based on their dinosaurs' positions.

The proposed system includes:

- **Spatial communication:** Voices become quieter and sound more distant as players move apart.
- **Whispering and shouting:** Different speaking modes create opportunities for stealth, coordination, and deception.
- **Environmental audio:** Explore underwater muffling, cave acoustics, and map-aware sound effects.
- **Cross-platform compatibility:** Investigate supported integration options for PC and PlayStation 5.

## Verified Experiments

Initial tests were conducted using two PlayStation 5 clients connected to the Lost Epoch dedicated server.

The following functionality was successfully demonstrated:

- Authenticated communication with Alderon's dedicated server REST API.
- Retrieval of player names, species, and three-dimensional world coordinates.
- Repeated position sampling at approximately two requests per second.
- Calculation of live distance between two connected players.
- Detection of whether two players fall within a configurable proximity radius.

Additional in-game listening experiments explored dinosaur vocalization attenuation, environmental sound behavior, and differences between vocalizations.

These observations inform the proposed audio design but do not establish how the game's underlying audio systems are implemented.

## Current Development Status

**Completed:** Proof-of-concept player tracking and proximity calculations using PowerShell.

**In development:** Reusable proximity detector, configurable speaking ranges, and technical documentation.

**Planned:** Standalone voice prototype, environmental audio profiles, and further investigation of official Path of Titans modding capabilities.

Native PS5 microphone capture, voice transmission, and in-game playback have not yet been demonstrated. Their feasibility depends on supported gameand platform interfaces.

## Development Principles

- Work within Alderon Games' official modding framework.
- Protect player privacy and server authentication credentials.
- Keep experiments separate from production server operations.
- Distinguish verified functionality from proposed features.
- Document implementation details and limitations transparently.

## Project Scope

This repository documents independent technical experiments involving a community server. It is not an official Alderon Games project or a completed Path of Titans mod.

## Next Milestone

Publish a sanitized, reusable proximity-detection script with setup instructions and sample output.
