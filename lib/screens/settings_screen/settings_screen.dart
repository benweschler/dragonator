import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/settings_screen/change_theme_button.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//TODO: using divider
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Consumer<AppModel>(
          builder: (_, model, themeButtonRow) {
            final user = model.user;

            return ListView(
              children: [
                Row(
                  children: [
                    const Text('Profile', style: TextStyles.h2),
                    const Spacer(),
                    CustomIconButton(onTap: () {}, icon: Icons.edit_rounded),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                ProfileInfo(user),
                const SizedBox(height: Insets.xl),
                const Text('Theme', style: TextStyles.h2),
                const SizedBox(height: Insets.sm),
                themeButtonRow!,
                const SizedBox(height: Insets.lg),
                Row(
                  children: [
                    const Text('Teams', style: TextStyles.h2),
                    const Spacer(),
                    CustomIconButton(onTap: () {}, icon: Icons.add_rounded),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                const _TeamCard(),
                const SizedBox(height: Insets.xl),
                const Divider(height: 0.5, thickness: 0.5),
                const SizedBox(height: Insets.xl),
                ResponsiveStrokeButton(
                  onTap: () => showLicensePage(
                    context: context,
                    useRootNavigator: true,
                  ),
                  child: const Text(
                    'About Dragonator',
                    style: TextStyles.body1,
                  ),
                ),
                const SizedBox(height: Insets.med),
                ResponsiveStrokeButton(
                  onTap: FirebaseAuth.instance.signOut,
                  child: const Text('Log Out', style: TextStyles.body1),
                ),
                const SizedBox(height: Insets.lg),
                Text(
                  'v1.0.0 — Made with ❤️ and zero calculus',
                  style: TextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Insets.lg),
              ],
            );
          },
          child: Row(
            children: <Widget>[
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.light),
              ),
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.dark),
              ),
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.system),
              ),
            ].separate(const SizedBox(width: Insets.sm)).toList(),
          ),
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final AppUser user;

  const ProfileInfo(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyles.caption.copyWith(
                  color: AppColors.of(context).neutralContent,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${user.firstName} ${user.lastName}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: Insets.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: TextStyles.caption.copyWith(
                    color: AppColors.of(context).neutralContent,
                  ),
                ),
                Text(user.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (_, rosterModel, __) {
        final List<Widget> content;
        if (rosterModel.teams.isEmpty) {
          content = const [Text('You don\'t have any teams yet')];
        } else {
          content = <Widget>[
            for (Team team in rosterModel.teams) _TeamTile(team)
          ]
              .separate(const Divider(height: Insets.med * 2, thickness: 0.5))
              .toList();
        }

        return Container(
          padding: const EdgeInsets.all(Insets.med),
          decoration: BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: AppColors.of(context).largeSurface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        );
      },
    );
  }
}

class _TeamTile extends StatelessWidget {
  final Team team;

  const _TeamTile(this.team);

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: () => context.showModal(ContextMenu([
        ContextMenuAction(
          icon: Icons.edit_rounded,
          onTap: () => context.push(RoutePaths.nameTeam(team.id)),
          label: 'Rename',
        ),
        ContextMenuAction(
          icon: Icons.groups_rounded,
          onTap: () {},
          label: 'View Roster',
        ),
        //TODO: must implement screen if user has no teams and if current team is deleted.
        ContextMenuAction(
          icon: Icons.delete_rounded,
          onTap: () {},
          label: 'Delete',
        ),
      ])),
      child: Row(
        children: [
          Expanded(
            child: Text(
              team.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.body1.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: Insets.med),
          Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
