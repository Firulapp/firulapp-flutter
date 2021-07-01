import 'package:firulapp/components/dialogs.dart';
import 'package:firulapp/components/dropdown/item_selection_screen.dart';
import 'package:firulapp/components/dropdown/listtile_item.dart';
import 'package:firulapp/provider/species.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterSelector extends StatefulWidget {
  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  Future _initialSpecies;
  SpeciesItem _speciesItem;

  @override
  void initState() {
    _initialSpecies = _getListSpecies();
    super.initState();
  }

  Future<void> _getListSpecies() async {
    try {
      Provider.of<Species>(context, listen: false).getSpecies();
    } catch (e) {
      Dialogs.info(
        context,
        title: 'ERROR',
        content: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: FutureBuilder(
        future: _initialSpecies,
        builder: (_, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading..."),
            );
          } else {
            return Consumer<Species>(
              builder: (ctx, listSpecies, _) {
                final list = listSpecies.toGenericFormItem();
                return buildSpecies(list);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildSpecies(List<ListTileItem> allSpecies) {
    final onTap = () async {
      final item = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemSelectionScreen(
            allItems: allSpecies,
            subject: 'Especies',
          ),
        ),
      ) as ListTileItem;

      if (item == null) return;

      setState(() {
        this._speciesItem = SpeciesItem(id: item.id, name: item.value);
      });
    };

    return buildPicker(
      title: 'Selecciona una Especie',
      child: _speciesItem == null
          ? buildListTile(title: 'Filtrar servicios por especie', onTap: onTap)
          : buildListTile(
              title: _speciesItem.name,
              onTap: onTap,
            ),
    );
  }

  Widget buildPicker({
    @required String title,
    @required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(margin: EdgeInsets.zero, child: child),
        ],
      );

  Widget buildListTile({
    @required String title,
    @required VoidCallback onTap,
    Widget leading,
  }) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }
}
