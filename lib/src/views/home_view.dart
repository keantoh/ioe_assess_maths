import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';
import 'package:math_assessment/src/views/login_view.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Sample Items'),
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text("HomeView"),
            ElevatedButton(
                onPressed: () {
                  ref.read(userStateProvider.notifier).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginView()),
                    ModalRoute.withName('/'),
                  );
                },
                child: Text('Logout'))
          ],
        ),
      ),

      // ListView.builder(
      //   // Providing a restorationId allows the ListView to restore the
      //   // scroll position when a user leaves and returns to the app after it
      //   // has been killed while running in the background.
      //   restorationId: 'HomeView',
      //   itemBuilder: (BuildContext context, int index) {
      //     final item = items[index];

      //     return ListTile(
      //         title: Text('SampleItem ${item.id}'),
      //         leading: const CircleAvatar(
      //           // Display the Flutter Logo image asset.
      //           foregroundImage: AssetImage('assets/images/flutter_logo.png'),
      //         ),
      //         onTap: () {
      //           // Navigate to the details page. If the user leaves and returns to
      //           // the app after it has been killed while running in the
      //           // background, the navigation stack is restored.
      //           Navigator.restorablePushNamed(
      //             context,
      //             SampleItemDetailsView.routeName,
      //           );
      //         });
      //   },
      // ),
    );
  }
}
