import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/theme_state_notifier.dart';

final isSigningUpProvider = StateProvider<bool>(
  (ref) => false,
);

class SettingsView extends ConsumerWidget {
  SettingsView({super.key});

  static const routeName = '/settings';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.settings,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .appearance,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge)),
                                Expanded(
                                  flex: 2,
                                  child: SegmentedButton<ThemeMode>(
                                    segments: <ButtonSegment<ThemeMode>>[
                                      ButtonSegment<ThemeMode>(
                                          value: ThemeMode.light,
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .light),
                                          icon: const Icon(
                                            Icons.light_mode,
                                          )),
                                      ButtonSegment<ThemeMode>(
                                          value: ThemeMode.dark,
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .dark),
                                          icon: const Icon(
                                            Icons.dark_mode,
                                          )),
                                      ButtonSegment<ThemeMode>(
                                          value: ThemeMode.system,
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .system),
                                          icon: const Icon(Icons.settings))
                                    ],
                                    selected: <ThemeMode>{
                                      themeSettings.themeMode
                                    },
                                    onSelectionChanged:
                                        (Set<ThemeMode> newSelection) {
                                      ref
                                          .read(themeNotifierProvider.notifier)
                                          .updateThemeMode(newSelection.first);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Removed as auto font scaling based on device settings
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 4),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //           flex: 1,
                          //           child: Text(
                          //               AppLocalizations.of(context)!.fontScale,
                          //               style: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyLarge)),
                          //       Expanded(
                          //         flex: 2,
                          //         child: Align(
                          //           alignment: Alignment.centerLeft,
                          //           child: DropdownButton<double>(
                          //             value: themeSettings.fontScale,
                          //             onChanged: ref
                          //                 .read(themeNotifierProvider.notifier)
                          //                 .updateFontScale,
                          //             items: [
                          //               DropdownMenuItem(
                          //                 value: 1.0,
                          //                 child: Text(
                          //                     AppLocalizations.of(context)!
                          //                         .font_100),
                          //               ),
                          //               DropdownMenuItem(
                          //                 value: 1.25,
                          //                 child: Text(
                          //                     AppLocalizations.of(context)!
                          //                         .font_125),
                          //               ),
                          //               DropdownMenuItem(
                          //                 value: 1.5,
                          //                 child: Text(
                          //                     AppLocalizations.of(context)!
                          //                         .font_150),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            child: Consumer(builder: (context, ref, _) {
                              return FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Text(
                                          AppLocalizations.of(context)!.ok)));
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
