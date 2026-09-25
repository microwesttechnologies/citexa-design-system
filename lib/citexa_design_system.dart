/// Citexa Design System — shared theme, components, animations and layout
/// primitives for every Citexa app (Flutter web and mobile).
///
/// See the package README for the color/typography rules every component
/// must follow.
library;

// Theme
export 'src/theme/app_color_tokens.dart' show BrandPalette;
export 'src/theme/citexa_colors.dart';
export 'src/theme/app_typography.dart';
export 'src/theme/app_spacing.dart';
export 'src/theme/app_motion.dart';
export 'src/theme/app_theme.dart';

// Animations
export 'src/animations/app_fade_in.dart';
export 'src/animations/app_page_route.dart';
export 'src/animations/app_scale_in.dart';
export 'src/animations/app_tap_scale.dart';

// Components — buttons
export 'src/components/buttons/app_button.dart';

// Components — inputs
export 'src/components/inputs/app_text_field.dart';

// Components — selection
export 'src/components/selection/app_switch.dart';
export 'src/components/selection/app_checkbox.dart';

// Components — surfaces
export 'src/components/surfaces/app_card.dart';
export 'src/components/surfaces/app_divider.dart';
export 'src/components/surfaces/app_avatar.dart';

// Components — feedback
export 'src/components/feedback/app_loader.dart';
export 'src/components/feedback/app_badge.dart';
export 'src/components/feedback/app_skeleton.dart';
export 'src/components/feedback/app_snackbar.dart';
export 'src/components/feedback/app_dialog.dart';

// Layout
export 'src/components/layout/app_breakpoints.dart';
export 'src/components/layout/app_page_scaffold.dart';
