import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/pet_service.dart';
import 'package:firulapp/provider/service_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class SelectedCategoryScreen extends StatelessWidget {
  static const routeName = "/selected-category";

  @override
  Widget build(BuildContext context) {
    final serviceTypeId = ModalRoute.of(context).settings.arguments as int;
    final serviceType = ServiceType.DUMMY_CATEGORIES
        .firstWhere((element) => element.id == serviceTypeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceType.title),
      ),
      body: Body(serviceType),
    );
  }
}

class Body extends StatefulWidget {
  final ServiceType _serviceType;
  Body(this._serviceType);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future _servicesFuture;

  Future _obtainServicesFuture() {
    return Provider.of<PetService>(context).fetchServicesByType();
  }

  @override
  void initState() {
    super.initState();
    _servicesFuture = _obtainServicesFuture();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<PetService>(context);
    final SizeConfig sizeConfig = SizeConfig();
    return FutureBuilder(
      future: _servicesFuture,
      builder: (_, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: Text('Algo salio mal'),
            );
          } else {
            return Consumer<PetService>(builder: (ctx, services, child) {
              if (services.itemCount != 0) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _availableService(
                      services.items[index],
                    );
                  },
                  itemCount: services.itemCount,
                );
              } else {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/empty.png",
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Text(
                        'Sin Servicios Disponibles :(',
                        style: TextStyle(
                          fontSize: sizeConfig.hp(4),
                          color: Constants.kPrimaryColor,
                        ),
                      )
                    ],
                  ),
                );
              }
            });
          }
        }
      },
    );
  }

  Widget _availableService(PetServiceItem item) {
    return Container(
      height: 100,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        elevation: 6,
        child: Center(
          child: ListTile(
              title: Text(
                "ASS",
              ),
              subtitle: Text("Baño para gatos"),
              onTap: () {
                print("ds");
              },
              trailing: Icon(Icons.arrow_forward_ios)),
        ),
      ),
    );
  }
}
