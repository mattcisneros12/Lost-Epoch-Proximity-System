# Lost Epoch — Acoustic Research

**Research date:** October 19, 2026  
**Game:** Path of Titans  
**Map:** Riparia  
**Test environment:** Lost Epoch dedicated community server  
**Clients:** Two PlayStation 5 consoles  
**Research status:** Preliminary field observations

## Research Objective

Investigate how Path of Titans handles dinosaur vocalizations across different distances and environments, and determine which characteristics could inform a proposed proximity-based voice communication system.

## Test Method

Two players connected to Lost Epoch using PlayStation 5 consoles.

One player generated dinosaur vocalizations while the other listened at varying distances.

Player separation was measured using three-dimensional coordinates retrieved through Alderon's dedicated server REST API.

Distances were calculated using an assumed conversion of 100 world units per meter.

Observations of loudness, perceived distance, and environmental effects were reported by the listening player. These were subjective listening tests, not instrumented audio measurements.

## Experiment 1 — Achillobator Vocalization

The initial experiment used an Achillobator vocalization.

| Approximate separation | Observation |
|---|---|
| 5 m | Loud, close |
| 25 m | Loud, close |
| 50 m | Loud, noticeably distant |
| 100 m | Faint |
| 125 m | Very quiet, clearly distant, but audible |
| Just beyond 125 m | Inaudible |
| 150–200 m | Inaudible |

### Interpretation

The tested vocalization demonstrated perceived distance changes as separation increased.

The listening observations suggest an abrupt audible boundary near 125 meters, alongside distance-dependent changes in perceived loudness.

The exact boundary and attenuation behavior require repeated controlled testing.

## Experiment 2 — Utahraptor Vocalization

The test was repeated using a deeper Utahraptor call.

The observer reported an audible range reaching approximately 710 meters based on API-derived separation.

This was substantially farther than the Achillobator vocalization tested previously.

### Interpretation

These observations suggest that different vocalizations may have different audible ranges.

However, the experiment does not establish whether attenuation varies by species, individual vocalization, audio configuration, or other factors.

The observed difference motivated the decision to design human speech with an independent communication range rather than copy a single dinosaur vocalization profile.

## Experiment 3 — Cave Acoustics

The observer reported that dinosaur calls sounded louder or carried differently inside caves while retaining a sense of distance.

No obvious echo was perceived.

The observer did not notice clear changes attributable to proximity to cave walls or ceiling geometry.

### Interpretation

This behavior is consistent with the possibility of environmental audio presets, but does not demonstrate how the game's cave audio is implemented.

A proposed voice system could begin with a cave-specific audio profile without requiring detailed geometric acoustic simulation.

## Experiment 4 — Underwater Acoustics

The observer reported noticeably muffled audio when submerged underwater.

### Interpretation

Underwater muffling could potentially be approximated using audio filtering, such as a low-pass filter.

Further testing is needed to determine how the effect depends on the positions and environmental states of the listener and sound source.

## Design Conclusions

These observations informed the following experimental design principles:

- Human speech should have its own communication profile, separate from species-specific dinosaur vocalizations.
- Voices should become quieter and perceptually more distant as players separate.
- Whispering, normal conversation, and shouting could have different maximum ranges.
- Cave audio should not automatically include exaggerated echoes.
- Underwater audio may benefit from muffling or frequency filtering.
- Environmental audio behavior should be validated through gameplay testing before being treated as an accurate reproduction of the game's sound engine.

## Limitations

This research is exploratory.

No original Path of Titans attenuation assets or underlying audio processing code were examined.

No calibrated recording equipment was used.

Results may depend on the specific call, game settings, listening equipment, environment, and coordinate conversion assumptions.

These experiments do not establish native microphone access, streamed voice playback, or mod compatibility on PlayStation 5.

## Next Research Steps

1. Repeat selected vocalization tests to validate the reported audible boundaries.
2. Compare multiple calls from the same species.
3. Test audio at equal distances inside and outside caves.
4. Compare underwater audio from the perspectives of both listener and sound source.
5. Use verified observations to refine a standalone proximity voice prototype.

**Conclusion:** Path of Titans' existing vocalization behavior provides useful design references, but a dedicated human voice profile is more appropriate for the proposed Lost Epoch proximity communication system.
