import 'package:flutter/material.dart';

import '../../size_config.dart';
import './components/category_item.dart' as widget;
import '../../provider/pet-service.dart';

class ServiceCategoriesScreen extends StatelessWidget {
  static const routeName = "/services-screen1";

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Servicios"),
        ),
        body: Column(
          children: [
            Text(
              "Seleccione una categoría",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: (sizeConfig.dp(3) / sizeConfig.hp(4.5)),
              padding: const EdgeInsets.all(15),
              children: CategoryItem.DUMMY_CATEGORIES
                  .map(
                      (cat) => widget.CategoryItem(cat.id, cat.title, cat.icon))
                  .toList(),
            ),
          ],
        ));
  }
}
