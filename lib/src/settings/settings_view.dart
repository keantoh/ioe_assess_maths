import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/theme_notifier.dart';
import 'package:math_assessment/src/data/models/avatar_color.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<ThemeMode>(
                    value: themeSettings.themeMode,
                    onChanged: ref
                        .read(themeNotifierProvider.notifier)
                        .updateThemeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System Theme'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light Theme'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark Theme'),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton<double>(
                    value: themeSettings.fontScale,
                    onChanged: ref
                        .read(themeNotifierProvider.notifier)
                        .updateFontScale,
                    items: const [
                      DropdownMenuItem(
                        value: 1.0,
                        child: Text('1.0'),
                      ),
                      DropdownMenuItem(
                        value: 1.25,
                        child: Text('1.25'),
                      ),
                      DropdownMenuItem(
                        value: 1.5,
                        child: Text('1.5'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MenuAnchor(
                builder: (BuildContext context, MenuController controller,
                    Widget? widget) {
                  return IconButton(
                    icon: Icon(Icons.circle, color: themeSettings.themeColor),
                    onPressed: () {
                      if (!controller.isOpen) {
                        controller.open();
                      }
                    },
                  );
                },
                menuChildren:
                    List<Widget>.generate(ColorSeed.values.length, (int index) {
                  final Color itemColor = ColorSeed.values[index].color;
                  return MenuItemButton(
                    leadingIcon: themeSettings.themeColor ==
                            ColorSeed.values[index].color
                        ? Icon(Icons.circle, color: itemColor)
                        : Icon(Icons.circle_outlined, color: itemColor),
                    onPressed: () {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .updateThemeColor(itemColor);
                    },
                    child: Text(ColorSeed.values[index].getColorName(context)),
                  );
                }),
              ),
              ColorSchemeView(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: themeSettings.themeColor,
                      brightness: themeSettings.themeMode == ThemeMode.dark
                          ? Brightness.dark
                          : Brightness.light,
                      dynamicSchemeVariant: DynamicSchemeVariant.fidelity)),
              ElevatedButton(onPressed: () {}, child: Text("Test")),
              FilledButton(onPressed: () {}, child: Text("Test"))
            ],
          ),
        ));
  }
}

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ColorGroup(children: <ColorChip>[
        ColorChip('primary', colorScheme.primary, colorScheme.onPrimary),
        ColorChip('onPrimary', colorScheme.onPrimary, colorScheme.primary),
        ColorChip('primaryContainer', colorScheme.primaryContainer,
            colorScheme.onPrimaryContainer),
        ColorChip(
          'onPrimaryContainer',
          colorScheme.onPrimaryContainer,
          colorScheme.primaryContainer,
        ),
      ])
    ]);
  }
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child:
          Card(clipBehavior: Clip.antiAlias, child: Column(children: children)),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip(this.label, this.color, this.onColor, {super.key});

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Expanded>[
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}
