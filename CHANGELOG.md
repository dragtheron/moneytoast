# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## 1.1.0 (2024-06-03)


### Features

* bump to interface 100105 ([94c1bd9](https://git.tsno.de/dragtheron/moneytoast/commit/94c1bd993d65a1752873d9330669f5f811218b37))
* **l18n:** integrate ruRU translation ([2defb53](https://git.tsno.de/dragtheron/moneytoast/commit/2defb53ef487040c8a7b735dced6de633be153b9))
* lower frame strata ([30057f4](https://git.tsno.de/dragtheron/moneytoast/commit/30057f4a711b9d369cd60dbfc40144eab2d7fb7e))
* make frame movable and optionally persistent ([731103f](https://git.tsno.de/dragtheron/moneytoast/commit/731103fa7ece1a6dd6939edc8da6033e08408e4b))
* merge master ([339aab7](https://git.tsno.de/dragtheron/moneytoast/commit/339aab770c19564079beebca05f0f3ade820ccd0))
* raise interface version ([a7ae219](https://git.tsno.de/dragtheron/moneytoast/commit/a7ae219b1a6de8662365a2f893651b9faef3fe2c))
* update to interface 100005 ([80e1803](https://git.tsno.de/dragtheron/moneytoast/commit/80e1803f1d69e23beea3acc1636bd78eb2c6632c))
* upgrade to 10.1 ([35c6f1a](https://git.tsno.de/dragtheron/moneytoast/commit/35c6f1a8274d5b4bf5d48f9cf9c9ca2a542d3149))
* use .pkgmeta ([6c312e9](https://git.tsno.de/dragtheron/moneytoast/commit/6c312e92823b19b86db148f23f946604e281ff99))
* use prefix-less toc for curse support ([c2ec31a](https://git.tsno.de/dragtheron/moneytoast/commit/c2ec31ae911c9469f189fbcf4d1505b63aae5407))


### Bug Fixes

* determine total while animation is active ([0932276](https://git.tsno.de/dragtheron/moneytoast/commit/0932276242ef788084e42b7ce9a8946cad9c997d))
* do not override blizzard's globals ([54a2efb](https://git.tsno.de/dragtheron/moneytoast/commit/54a2efbb057a58ee66ac1a6613848c119635c9d5))
* remove beta tag from version string ([dc2d529](https://git.tsno.de/dragtheron/moneytoast/commit/dc2d5294411834b08fd1632c0819327f2e5fdbec))
* reposition toast frame ([0089f7b](https://git.tsno.de/dragtheron/moneytoast/commit/0089f7b5320e53d26b342ed105ba20011857e732))

## 1.3.0 (June 2, 2024)

### Currency Support

In Remix: Mists of Pandaria, you collect Bronze rather than gold.
Now you can track this currency the same way as your money.
Stay tuned: In a future update, you will be able to track even more currencies via the Currencies tab!

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
