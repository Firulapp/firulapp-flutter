import 'package:flutter/material.dart';

class SelectedCategoryScreen extends StatelessWidget {
  static const routeName = "/selected-category";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baño"),
      ),
      body: Column(
        children: [
          _getListings("jheisecke"),
          _getListings("malvarez"),
          _getListings("kgomez"),
        ],
      ),
    );
  }

  Widget _getListings(String username) {
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
                username,
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
