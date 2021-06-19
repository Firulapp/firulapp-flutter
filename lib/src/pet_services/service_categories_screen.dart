import 'package:flutter/material.dart';

import '../../size_config.dart';
import './components/category_item.dart';
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
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (sizeConfig.dp(3) / sizeConfig.hp(4.5)),
        padding: const EdgeInsets.all(15),
        children: DUMMY_SERVICES
            .map((cat) => CategoryItem(cat.id, cat.title, cat.icon))
            .toList(),
      ),
    );
  }
}
