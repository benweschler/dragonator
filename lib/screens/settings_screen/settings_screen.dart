import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/settings_screen/change_theme_button.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                const TeamCard(),
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

class TeamCard extends StatelessWidget {
  const TeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (_, rosterModel, __) {
        final List<Widget> content;
        if (rosterModel.teams.isEmpty) {
          content = const [Text('You don\'t have any teams yet')];
        } else {
          content = <Widget>[
            for (Team team in rosterModel.teams)
              TeamTile(
                teamName: team.name,
                //TODO: need to make names available. or just delete them
                paddlerNames: ['TEST'],
                /*
                paddlerNames: team.paddlerIDs
                    .map((id) => rosterModel.getPaddler(id)!)
                    .map(
                      (paddler) => '${paddler.firstName} ${paddler.lastName}',
                    )
                    .toList()
                  ..sort(),

                 */
              ),
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
          child: Column(children: content),
        );
      },
    );
  }
}

class TeamTile extends StatelessWidget {
  final String teamName;
  final Iterable<String> paddlerNames;

  const TeamTile({super.key, required this.teamName, required this.paddlerNames});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teamName, style: TextStyles.body1),
            Text(
              paddlerNames.isNotEmpty ? paddlerNames.join(', ') : 'No paddlers',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyles.caption.copyWith(
                color: AppColors.of(context).neutralContent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
