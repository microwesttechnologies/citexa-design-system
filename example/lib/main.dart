import 'package:flutter/material.dart';
import 'package:citexa_design_system/citexa_design_system.dart';

void main() => runApp(const ShowcaseApp());

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  ThemeMode _mode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citexa Design System',
      debugShowCheckedModeBanner: false,
      theme: CitexaTheme.light(),
      darkTheme: CitexaTheme.dark(),
      themeMode: _mode,
      home: ShowcasePage(onToggleTheme: _toggleTheme, mode: _mode),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({
    super.key,
    required this.onToggleTheme,
    required this.mode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode mode;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  bool _switchValue = true;
  bool _checkboxValue = false;
  bool _loading = false;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppPageScaffold(
      title: 'Citexa Design System',
      actions: [
        IconButton(
          icon: Icon(
            widget.mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: widget.onToggleTheme,
        ),
      ],
      body: ListView(
        children: [
          AppFadeIn(
            child: _Section(
              title: 'Tipografía',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título Principal',
                    style: CitexaTypography.titlePrincipal.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Subtítulo',
                    style: CitexaTypography.subtitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Título de sección',
                    style: CitexaTypography.sectionTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Texto principal',
                    style: CitexaTypography.bodyPrimary.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Texto secundario',
                    style: CitexaTypography.bodySecondary.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    'Etiqueta / nota',
                    style: CitexaTypography.label.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFadeIn(
            delay: const Duration(milliseconds: 80),
            child: _Section(
              title: 'Botones',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton(label: 'Primario', onPressed: () {}),
                  AppButton(
                    label: 'Secundario',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  AppButton(
                    label: 'Outline',
                    variant: AppButtonVariant.outline,
                    onPressed: () {},
                  ),
                  AppButton(
                    label: 'Ghost',
                    variant: AppButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  AppButton(label: 'Deshabilitado', onPressed: null),
                  AppButton(
                    label: _loading ? 'Cargando…' : 'Con loading',
                    isLoading: _loading,
                    onPressed: () async {
                      setState(() => _loading = true);
                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) setState(() => _loading = false);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFadeIn(
            delay: const Duration(milliseconds: 160),
            child: _Section(
              title: 'Inputs',
              child: Column(
                children: [
                  AppTextField(
                    controller: _controller,
                    label: 'Correo electrónico',
                    hintText: 'nombre@correo.com',
                    leadingIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const AppTextField(
                    label: 'Con error',
                    hintText: 'nombre@correo.com',
                    errorText: 'Correo inválido',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFadeIn(
            delay: const Duration(milliseconds: 240),
            child: _Section(
              title: 'Selección',
              child: Row(
                children: [
                  AppSwitch(
                    value: _switchValue,
                    onChanged: (v) => setState(() => _switchValue = v),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  AppCheckbox(
                    value: _checkboxValue,
                    onChanged: (v) =>
                        setState(() => _checkboxValue = v ?? false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFadeIn(
            delay: const Duration(milliseconds: 320),
            child: _Section(
              title: 'Feedback',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const AppBadge(
                    label: 'Activo',
                    variant: AppBadgeVariant.primary,
                  ),
                  const AppBadge(
                    label: 'Pendiente',
                    variant: AppBadgeVariant.secondary,
                  ),
                  const AppBadge(label: 'Neutral'),
                  const AppLoader(),
                  AppButton(
                    label: 'Mostrar snackbar',
                    variant: AppButtonVariant.outline,
                    onPressed: () => showAppSnackBar(
                      context,
                      message: 'Guardado correctamente',
                    ),
                  ),
                  AppButton(
                    label: 'Mostrar diálogo',
                    variant: AppButtonVariant.outline,
                    onPressed: () => showAppDialog(
                      context,
                      title: '¿Eliminar elemento?',
                      message: 'Esta acción no se puede deshacer.',
                      confirmLabel: 'Eliminar',
                      cancelLabel: 'Cancelar',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppFadeIn(
            delay: const Duration(milliseconds: 400),
            child: _Section(
              title: 'Superficies',
              child: Column(
                children: [
                  AppCard(
                    onTap: () {},
                    child: Row(
                      children: [
                        const AppAvatar(initials: 'ZX'),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tarjeta interactiva',
                                style: CitexaTypography.bodyPrimary.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                              Text(
                                'Con AppAvatar y AppDivider',
                                style: CitexaTypography.bodySecondary.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const AppDivider(),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CitexaTypography.sectionTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
