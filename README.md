# citexa_design_system

Shared theme, components, animations and layout primitives for every Citexa
app — Flutter web and mobile alike. This is the single source of truth for
how the product looks; no app or screen should ever define its own colors,
fonts or spacing.

Source of truth: the Citexa color palette (Primary `#8E05F7` / Secondary
`#7604CC` / Tertiary `#460275` / Neutral `#0F172A`, updated 2026-09-24) and
the Citexa type scale (Space Grotesk / Geist / JetBrains Mono).

## The rule

> No component may be painted with a color that isn't defined in
> `CitexaColors`.

Enforcement:

- `lib/src/theme/app_color_tokens.dart` is the **only** file allowed to
  contain a literal `Color(0x...)`. It holds the four brand hexes plus pure
  white/black (structural, not brand colors), nothing else.
- Every other file reads color through `context.colors` (a `CitexaColors`
  `ThemeExtension`), never through a hex literal.
- `test/citexa_design_system_test.dart` asserts, for both the light and dark
  theme, that every semantic color role resolves back to one of the
  approved hexes (allowing only an opacity change). Run `flutter test`
  before adding any new color role — if you add a color the palette doesn't
  define, this test will fail on purpose.

## About the light theme

Only a dark UI was specified. The light theme was derived using **only the
same approved hexes**, remapped:

| Role | Dark | Light |
|---|---|---|
| `primary` / `secondary` / `tertiary` | `#8E05F7` / `#7604CC` / `#460275` | same (brand accents don't change with theme) |
| `background` | Neutral `#0F172A` | White |
| `surface` | White @ 6% over `background` | Neutral @ 4% over `background` |
| `textPrimary` | White | Neutral |
| `outline` / `textSecondary` / `disabled` / `overlay` | White/Neutral at reduced opacity | same, opposite anchor color |

`surface` is never a second literal hex: it's the structural white/black
color painted at low opacity over the page background, which is exactly how
Flutter composites translucent colors — the result reads as a subtly
lighter (dark theme) or darker (light theme) panel with zero invented hues.

**Status colors:** success / warning / error / info live in `CitexaColors`
(error is `BrandPalette.error`, a clear red). Every error message — the
`AppTextField` error state (red border + red text), toasts
(`showAppSnackBar(type: AppSnackBarType.error)`), inline messages — must use
`colors.error`, never the brand purple: purple is the focus/accent color, so an
error in purple reads as "nothing is wrong".

## What's included

- **Theme** (`lib/src/theme`): `CitexaColors` (light/dark), `CitexaTypography`
  (Título Principal → Etiqueta/Nota, across three families), `AppSpacing` /
  `AppRadius` (4px grid), `AppMotion` (durations/curves), `CitexaTheme.light()`
  / `.dark()`.
- **Animations** (`lib/src/animations`): `AppFadeIn`, `AppScaleIn`,
  `AppTapScale`.
- **Components** (`lib/src/components`): `AppButton` (primary / secondary /
  outline / ghost, with loading + disabled states), `AppTextField`,
  `AppSwitch`, `AppCheckbox`, `AppCard`, `AppDivider`, `AppAvatar`,
  `AppLoader` / `AppLoadingOverlay`, `AppBadge`, `showAppSnackBar`,
  `showAppDialog`.
- **Layout** (`lib/src/components/layout`): `AppBreakpoints` /
  `AppResponsiveBuilder`, `AppPageScaffold` (brand background + content
  clamped to a max width on web/desktop).

Fonts (variable, bundled locally — no network fetch at runtime):
- **Space Grotesk** (`headlineFontFamily`) — `titlePrincipal`, `subtitle`, `sectionTitle`
- **Geist** (`bodyFontFamily`) — `bodyPrimary`, `bodySecondary`
- **JetBrains Mono** (`labelFontFamily`) — `label`

## Using it in an app

```yaml
# pubspec.yaml
dependencies:
  citexa_design_system:
    path: ../../citexa_design_system # adjust to the app's location
```

```dart
MaterialApp(
  theme: CitexaTheme.light(),
  darkTheme: CitexaTheme.dark(),
  themeMode: ThemeMode.system, // or drive it from user settings
  home: const MyHomePage(),
);
```

Already wired into `citexa-frontend-web/citexa_web` and `citexa-frontend-app`.

### Pinning a version

Apps consume the package as a git dependency. Pin it to a **release tag**, never
to `main` (a change to the design system must not break the web or the app at
the next `flutter pub get`):

```yaml
dependencies:
  citexa_design_system:
    git:
      url: https://github.com/microwesttechnologies/citexa-design-system.git
      ref: v0.1.0
```

Release checklist (in this repo): move the `[Unreleased]` entries of
`CHANGELOG.md` under a new version, bump `version:` in `pubspec.yaml`, merge
to `main` once CI is green, then tag it (`git tag v0.1.1` and
`git push origin v0.1.1`). After bumping `ref:` in an app, run `flutter pub get`
and commit the `pubspec.lock` only if `citexa_design_system` is `source: git`
(not `source: path`).

### Assets

The logo PNGs in `lib/src/assets/logo/` are bundled and used by `CitexaLogo`
(asset paths from an app are `packages/citexa_design_system/lib/src/assets/logo/...`).
The SVG artwork in `lib/src/assets/img/` is source material only and is not
declared as an asset (nothing uses it; it weighs about 1.6 MB).

## Showcase

`example/` is a runnable app with every component in both themes:

```bash
cd example
flutter run -d chrome   # or: flutter run -d web-server --web-port 5501
```

## Adding a new component

1. Read colors only via `context.colors.<role>`, spacing via `AppSpacing`,
   radius via `AppRadius`, text via `CitexaTypography`.
2. If you need a color role that doesn't exist yet, add it to
   `CitexaColors` (both `light` and `dark`) built from the approved
   hexes — never a new literal.
3. Export it from `lib/citexa_design_system.dart`.
4. Add it to `example/lib/main.dart`'s showcase and, if it's a
   theme/color-bearing widget, add it to the color-audit test.
