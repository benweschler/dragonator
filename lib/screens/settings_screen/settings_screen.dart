import 'package:dragonator/data/user/app_user.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/settings_screen/boats_popup.dart';
import 'package:dragonator/screens/settings_screen/change_theme_button.dart';
import 'package:dragonator/screens/settings_screen/delete_team_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/utils/dependence_mixins/team_dependent_modal_state_mixin.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
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
        child: ListView(
          children: [
            _ProfileInfo(
              context.select<AppModel, AppUser>((model) => model.user),
            ),
            const SizedBox(height: Insets.xl),
            const Text('Theme', style: TextStyles.h2),
            const SizedBox(height: Insets.sm),
            Row(
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
            const SizedBox(height: Insets.xl),
            Row(
              children: [
                const Text('Teams', style: TextStyles.h2),
                const Spacer(),
                // Create team
                CustomIconButton(
                  // Creates a team when no ID is passed
                  onTap: () => context.push(RoutePaths.nameTeam()),
                  icon: Icons.add_rounded,
                ),
              ],
            ),
            const SizedBox(height: Insets.sm),
            const _TeamCard(),
            const Divider(height: Insets.xl * 2),
            ResponsiveStrokeButton(
              onTap: () => showLicensePage(
                context: context,
                useRootNavigator: true,
              ),
              child: Text('About Dragonator', style: TextStyles.body1),
            ),
            const SizedBox(height: Insets.med),
            ResponsiveStrokeButton(
              //TODO: logout logic currently in router but happens after auth logout. should be put into a top-level command.
              onTap: () => context.read<AppModel>().logOut(context),
              child: Text('Log Out', style: TextStyles.body1),
            ),
            const SizedBox(height: Insets.lg),
            Text(
              'v0.2.0 — Made with ❤️ and zero calculus',
              style: TextStyles.caption,
            ),
            const SizedBox(height: Insets.lg),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final AppUser user;

  const _ProfileInfo(this.user);

  @override
  Widget build(BuildContext context) {
    context.read<AppModel>().user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${user.firstName} ${user.lastName}',
              //TODO: may want to actually define this
              style: TextStyles.h2.copyWith(fontSize: 26),
            ),
            CustomIconButton(icon: Icons.edit_rounded, onTap: () {}),
          ],
        ),
        Text(
          user.email,
          style: TextStyles.body1.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.of(context).neutralContent,
          ),
        ),
      ],
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
          content = const [
            Center(child: Text('You haven\'t created any teams yet')),
          ];
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
      onTap: () {
        context.showModal(_TeamContextMenu(
          teamID: team.id,
          rootContext: context,
        ));
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              team.name,
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

class _TeamContextMenu extends StatefulWidget {
  final String teamID;
  final BuildContext rootContext;

  const _TeamContextMenu({required this.teamID, required this.rootContext});

  @override
  State<_TeamContextMenu> createState() => _TeamContextMenuState();
}

class _TeamContextMenuState extends State<_TeamContextMenu>
    with TeamDependentModalStateMixin {
  @override
  Widget build(BuildContext context) {
    return ContextMenu([
      ContextMenuAction(
        icon: Icons.edit_rounded,
        label: 'Rename',
        onTap: () => context.push(RoutePaths.nameTeam(widget.teamID)),
      ),
      ContextMenuAction(
        icon: Icons.groups_rounded,
        label: 'Roster',
        onTap: () {
          context.read<RosterModel>().setCurrentTeam(widget.teamID);
          context.go(RoutePaths.roster);
        },
      ),
      ContextMenuAction(
        icon: Icons.rowing_rounded,
        label: 'Boats',
        autoPop: false,
        onTap: () async {
          context.pop();
          await Future.delayed(Timings.long);

          if (!widget.rootContext.mounted) return;
          widget.rootContext.showPopup(BoatsPopup(widget.teamID));
        },
      ),
      ContextMenuAction(
        icon: Icons.delete_rounded,
        label: 'Delete',
        isDestructiveAction: true,
        autoPop: false,
        onTap: () async {
          //TODO: remove auto pop
          context.pop();
          //TODO: add a parameter to wait until close to execute on tap.
          await Future.delayed(Timings.long);
          if (!widget.rootContext.mounted) return;
          widget.rootContext.showPopup(DeleteTeamPopup(widget.teamID));
        },
      ),
    ]);
  }

  @override
  String get teamID => widget.teamID;
}
