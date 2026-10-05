# Changelog

All notable changes to this package are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/) (while below 1.0.0, a minor bump may
contain breaking changes — they are called out under **Changed**/**Removed**).

Consumers (`citexa_web`, `citexa-frontend-app`) should depend on a **tag**
(`ref: v0.1.0`), not on `main`. See "Pinning a version" in the README.

## [Unreleased]

## [0.1.0] - 2026-10-05

First versioned release. Everything below already existed on `main`; this
version freezes it so the apps can pin to it.

### Added

- **Theme:** `CitexaColors` (light/dark `ThemeExtension`, `context.colors`),
  `BrandPalette` (the only file allowed to hold hex literals),
  `CitexaTypography` (Space Grotesk / Geist / JetBrains Mono, bundled locally),
  `AppSpacing` / `AppRadius`, `AppMotion`, and `CitexaTheme.light()` / `.dark()`.
- **Components:** `AppButton` (primary / secondary / danger / ghost, loading and
  disabled states), `AppTextField`, `AppSwitch`, `AppCheckbox`, `AppCard`,
  `AppDivider`, `AppAvatar`, `AppBadge`, `AppLoader` / `AppLoadingOverlay`,
  `AppSkeletonBox` / `AppSkeletonListTile`, `showAppSnackBar` (error / success /
  info / warning toasts), `showAppDialog`, `CitexaLogo`.
- **Layout:** `AppBreakpoints`, `AppResponsiveBuilder`, `AppPageScaffold`.
- **Animations:** `AppFadeIn`, `AppScaleIn`, `AppTapScale`, `appPageRoute`
  (all respect the OS "reduce motion" setting).
- **Tests:** widget tests for every exported component (render, callbacks,
  disabled/loading states, reduced motion) next to the existing color-token
  audit.
- **CI:** GitHub Actions workflow running `flutter pub get`, `flutter analyze`
  and `flutter test` on every push and pull request (actions pinned to SHAs).

### Fixed

- `AppSkeletonBox` threw "Looking up a deactivated widget's ancestor is unsafe"
  on dispose when the platform requested reduced motion (the animation
  controller was lazily created inside `dispose()`).

### Notes

- The SVG artwork in `lib/src/assets/img/` (about 1.6 MB) is **not** declared as
  a Flutter asset: nothing in the package uses it (the logo widgets use the PNGs
  in `lib/src/assets/logo/`), and declaring it would bundle it into every app.
  Declare it only together with a consumer (for example `flutter_svg`).

[Unreleased]: https://github.com/microwesttechnologies/citexa-design-system/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/microwesttechnologies/citexa-design-system/releases/tag/v0.1.0
