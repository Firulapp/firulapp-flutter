import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import '../own_services/own_services_screen.dart';
import '../selected_category_screen.dart';
import '../../../constants/constants.dart';
import '../../../provider/pet_service.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String title;
  final String icon;

  CategoryItem(this.id, this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () {
            Provider.of<PetService>(
              context,
              listen: false,
            ).setServiceType(id);
            if (id != 0) {
              Navigator.of(context)
                  .pushNamed(SelectedCategoryScreen.routeName, arguments: id);
            } else {
              Navigator.of(context)
                  .pushNamed(OwnServicesScreen.routeName, arguments: id);
            }
          },
          fillColor:
              id != 0 ? Constants.kPrimaryLightColor : Constants.kPrimaryColor,
          child: SvgPicture.asset(
            icon,
            color: id != 0
                ? Constants.kPrimaryColor
                : Constants.kPrimaryLightColor,
            width: 50,
            fit: BoxFit.cover,
          ),
          elevation: 0.5,
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: sizeConfig.dp(1.7),
          ),
        )
      ],
    );
  }
}
