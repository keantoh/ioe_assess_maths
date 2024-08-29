import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/notifiers/user_search_notifier.dart';
import 'package:assess_math/src/notifiers/user_state_notifier.dart';
import 'package:assess_math/src/utils/helper_functions.dart';

final isDeletingProvider = StateProvider<bool>(
  (ref) => false,
);

class UserSearchView extends HookConsumerWidget {
  const UserSearchView({super.key});

  static const routeName = '/usersearch';

  Future<void> handleSearch(BuildContext context, WidgetRef ref) async {
    ref.read(userSearchProvider.notifier).searchUsers();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchState = ref.watch(userSearchProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.userSearch,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                ref.watch(isDeletingProvider)
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 36),
                        child: const LinearProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.back)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                onChanged: (value) {
                                  ref
                                      .read(userSearchProvider.notifier)
                                      .setSearchQuery(value);
                                },
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .userSearchBy,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                    suffixIcon: IconButton(
                                        onPressed: userSearchState
                                                .searchQuery.isEmpty
                                            ? null
                                            : () => handleSearch(context, ref),
                                        icon: const Icon(Icons.search))),
                              ),
                            ),
                          )
                        ],
                      ),
                userSearchState.isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()))
                    : userSearchState.responseCode != 200
                        ? Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                                child: Text(
                              _getResponseMessage(
                                  userSearchState.responseCode, context),
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            )))
                        : const UserTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _getResponseMessage(int? responseCode, BuildContext context) {
  switch (responseCode) {
    case 400:
      return AppLocalizations.of(context)!.error400;
    case 401:
      return AppLocalizations.of(context)!.error401;
    case 404:
      return AppLocalizations.of(context)!.error404;
    case 408:
      return AppLocalizations.of(context)!.error408;
    case 500:
      return AppLocalizations.of(context)!.error500;
    case 503:
      return AppLocalizations.of(context)!.error503;
    default:
      return AppLocalizations.of(context)!.userSearchBy;
  }
}

class UserTable extends HookConsumerWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeName = AppLocalizations.of(context)?.localeName ?? 'en';
    final users = ref.watch(userSearchProvider).users;

    return LayoutBuilder(builder: (context, constraints) {
      const colSpacing = 8.0;
      const numOfCols = 5;
      final availableWidth = constraints.maxWidth - colSpacing * numOfCols * 2;
      final largeWidth = availableWidth * 0.25;
      final smallWidth = availableWidth * 0.15;
      final tinyWidth = availableWidth * 0.05;

      return SingleChildScrollView(
        child: DataTable(
          columnSpacing: colSpacing,
          columns: [
            DataColumn(
                label: SizedBox(
                    width: largeWidth,
                    child: Text(
                      AppLocalizations.of(context)!.email,
                      softWrap: true,
                    ))),
            DataColumn(
                label: SizedBox(
                    width: largeWidth,
                    child: Text(
                      AppLocalizations.of(context)!.firstName,
                      softWrap: true,
                    ))),
            DataColumn(
                label: SizedBox(
                    width: largeWidth,
                    child: Text(
                      AppLocalizations.of(context)!.lastName,
                      softWrap: true,
                    ))),
            DataColumn(
                label: SizedBox(
                    width: smallWidth,
                    child: Text(
                      AppLocalizations.of(context)!.dateJoined,
                      softWrap: true,
                    ))),
            DataColumn(
                label: SizedBox(width: tinyWidth, child: const Text(''))),
          ],
          rows: users.map((user) {
            return DataRow(cells: [
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: largeWidth),
                  child: Text(
                    user.email,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: largeWidth),
                  child: Text(
                    user.firstName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: largeWidth),
                  child: Text(
                    user.lastName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: smallWidth),
                  child: Text(
                    DateFormat.yMd(localeName).format(user.createdAt),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: tinyWidth),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (String value) {
                      if (value == 'Delete') {
                        if (ref.read(userStateProvider)?.userId ==
                            user.userId) {
                          HelperFunctions.showSnackBar(context, 2000,
                              AppLocalizations.of(context)!.deleteOwnAccount);
                        } else {
                          _showDeleteUserDialog(context, ref, user);
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(AppLocalizations.of(context)!.deleteUser),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      );
    });
  }

  void _showDeleteUserDialog(
      BuildContext context, WidgetRef ref, UserSearch user) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteAccount),
          content:
              Text(AppLocalizations.of(context)!.deleteUserMessage(user.email)),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  submitDelete(ref, context, user.userId);
                },
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitDelete(
      WidgetRef ref, BuildContext context, String userId) async {
    ref.read(isDeletingProvider.notifier).state = true;

    await ref.read(userSearchProvider.notifier).deleteUser(userId);
    final responseCode = ref.read(userSearchProvider).responseCode;

    ref.read(isDeletingProvider.notifier).state = false;
    if (context.mounted) {
      switch (responseCode) {
        case 200:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.deleteUserSuccess);
          break;
        case 400:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error400);
          break;
        case 401:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error401);
          break;
        case 404:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error404);
          break;
        case 408:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error408);
          break;
        case 503:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error503);
          break;
        default:
          HelperFunctions.showSnackBar(
              context, 2000, AppLocalizations.of(context)!.error500);
          break;
      }
    }
  }
}
