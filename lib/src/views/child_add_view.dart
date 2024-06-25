import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../settings/settings_view.dart';

class ChildAddView extends StatelessWidget {
  ChildAddView({super.key});

  static const routeName = '/childadd';
  final _formKey = GlobalKey<FormState>();
  final fieldMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
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
                    child: Column(
                      children: [],
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
