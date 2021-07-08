import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile_detail/profile_details.dart';
import '../../profile_detail/profile_details_organization.dart';
import '../../../components/dialogs.dart';
import './profile_menu.dart';
import '../../profile_detail/components/profile_photo.dart';
import '../../../provider/user.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Consumer<User>(
            builder: (ctx, user, child) {
              return ProfilePhoto(null, user.userData.profilePicture, true);
            },
          ),
          SizedBox(height: 20),
          Consumer<User>(
            builder: (ctx, user, child) {
              return ProfileMenu(
                text: "Mi Cuenta",
                icon: "assets/icons/User Icon.svg",
                press: () => {
                  user.userData.userType == "ORGANIZACION"
                      ? Navigator.pushNamed(
                          context, ProfilePageOrganization.routeName)
                      : Navigator.pushNamed(context, ProfilePage.routeName),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
