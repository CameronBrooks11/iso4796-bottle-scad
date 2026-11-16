# Changelog

All notable changes to this project are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.1.0] - 2026-11-15

### Added

- `scadman.toml` and `scadman.lock`, pinning din168-thread-scad at v0.1.0 for the thread.
- `just test`: the tables against `docs/references.md`, the capacities against its Findings, the
  bottles and examples rendered, and the refusals.
- A docs site, at <https://cameronbrooks11.github.io/iso4796-bottle-scad/>.
- Every size in ISO 4796-1:2016, 25 mL to 20 L, looked up by capacity with `iso4796_by_capacity`.
- The finish per size (GL25, GL32, GL45) and its bore, from DURAN, KIMAX and a glassblower's table.
- `iso4796_bottle`: the bottle drawn from its section, with a cut-away `angle` and the DIN 168 thread
  optional through din168-thread-scad.
- `iso4796_volume_below` and `iso4796_report`: what a bottle holds, and how that sits against the
  standard's capacities.
- `examples/all_sizes.scad` and `examples/500ml_section.scad`.
- `duran.scad`: DURAN Original bottles, 25 mL to 20 L, by catalogue number, with DWK's brim
  capacities; `duran_by_capacity`.
- `kimax.scad`: KIMBLE KIMAX GL45 media bottles, 100 mL to 10 L; `kimax_by_capacity`.
- `iso4796_brim_capacity`, and a brim comparison in `iso4796_report` for a row that carries one.

[Unreleased]: https://github.com/CameronBrooks11/iso4796-bottle-scad/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/CameronBrooks11/iso4796-bottle-scad/releases/tag/v0.1.0
