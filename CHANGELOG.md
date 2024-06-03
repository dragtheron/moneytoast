# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [2.0.0-beta.0](https://git.tsno.de/dragtheron/moneytoast/compare/v1.2.6...v2.0.0-beta.0) (2024-06-03)


### ⚠ BREAKING CHANGES

* Modularized code: This addon does not expose any functions globally anymore.
* Streamlined animation system.

### Features

* Add entry in Addon Compartment menu ([6ef0f77](https://git.tsno.de/dragtheron/moneytoast/commit/6ef0f774c345c2ab003dcbe0f25a74819c75809a))
* Support currencies and multiple toast widgets; Activate Bronze currency ([3afd0ec](https://git.tsno.de/dragtheron/moneytoast/commit/3afd0ec2b86a0f258acd102835e75ec78355063a))
* Support WoW 10.2.7 ([24a907e](https://git.tsno.de/dragtheron/moneytoast/commit/24a907e2a5365f9073d72c4b19c1e1faf18afa79))

## 1.2.6 (September 6, 2023)

- Bumped to interface version 10.1.7
- Added support for WoW Classic version 1.14.1

---

## 1.2.5 (July 13, 2023)

- Updated for WoW 10.1.5

## 1.2.4 (May 3, 2023)

- Updated for WoW 10.1.0

## 1.2.3 (February 01, 2023)

- Updated to interface version 10.0.5.

---

## 1.2.1 (December 06, 2022)

### [FIXED] Tainting Errors

Fixed an issue where Money Toast may causes a taining error, resulting in a
"Gather Panel has been blocked..." and thus removing access to further actions.

---

## 1.2.0 (November 19, 2022)

### [ADDED] Movable Frame

The notification frame is now movable.
You may use the new the new commands to ease the procedure of positioning.

### [ADDED] Slash Commands: Persistence and Position Reset

You may use these new slash commands:

    /moneytoast stay on|off

Use this command to set the notification "always on" or "hide automatically". The latter is the previous behaviour.

    /moneytoast reset

Use this command if you mess up positioning and/or want to reset the notification frame back to its original place.

---

## 1.1.4 (November 17, 2022)

### [Changed] Dragonflight Release Version

- Raised interface version for new Retail WoW Release (10.0.2).
- Added .pkgmeta for proper Curse builds.
