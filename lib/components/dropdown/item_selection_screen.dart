import 'package:firulapp/constants/constants.dart';
import 'package:flutter/material.dart';

import './listtile_item.dart';
import './../search_widget.dart';
import './utils.dart';
import './item_listtile_form_field.dart';

class ItemSelectionScreen extends StatefulWidget {
  final bool isMultiSelection;
  final List<ListTileItem> allItems;
  final List<ListTileItem> items;
  final String subject;

  const ItemSelectionScreen({
    Key key,
    this.isMultiSelection = false,
    this.allItems = const [],
    this.items = const [],
    this.subject = '',
  }) : super(key: key);

  @override
  _ItemSelectionScreenState createState() => _ItemSelectionScreenState();
}

class _ItemSelectionScreenState extends State<ItemSelectionScreen> {
  String _text = '';
  List<ListTileItem> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = widget.items;
  }

  bool containsSearchText(ListTileItem item) {
    final name = item.value;
    final textLower = _text.toLowerCase();
    final itemLower = name.toLowerCase();

    return itemLower.contains(textLower);
  }

  List<ListTileItem> getPrioritizedItems(List<ListTileItem> items) {
    final notSelectedCountries = List.of(items)
      ..removeWhere((item) => selectedItems.contains(item));

    return [
      ...List.of(selectedItems)..sort(Utils.ascendingSort),
      ...notSelectedCountries,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final allItems = getPrioritizedItems(widget.allItems);
    final filteredItems = allItems.where(containsSearchText).toList();

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: filteredItems.map((item) {
                final isSelected = selectedItems.contains(item);

                return ItemListTileFormField(
                  item: item,
                  isSelected: isSelected,
                  onSelectedItem: selectItem,
                );
              }).toList(),
            ),
          ),
          buildSelectButton(context),
        ],
      ),
    );
  }

  Widget buildSelectButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      color: Constants.kPrimaryColor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          minimumSize: Size.fromHeight(40),
          primary: Colors.white,
        ),
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        onPressed: submit,
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text('Seleccionar ${widget.subject}'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SearchWidget(
          text: _text,
          onChanged: (text) => setState(() => this._text = text),
          hintText: 'Buscar ${widget.subject}',
        ),
      ),
    );
  }

  void selectItem(ListTileItem item) {
    if (widget.isMultiSelection) {
      final isSelected = selectedItems.contains(item);
      setState(() =>
          isSelected ? selectedItems.remove(item) : selectedItems.add(item));
    } else {
      Navigator.pop(context, item);
    }
  }

  void submit() => Navigator.pop(context, selectedItems);
}
