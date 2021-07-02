import 'package:flutter/material.dart';

import './listtile_item.dart';

class ItemListTileFormField extends StatelessWidget {
  final ListTileItem item;
  final bool isSelected;
  final ValueChanged<ListTileItem> onSelectedItem;

  const ItemListTileFormField({
    Key key,
    @required this.item,
    @required this.isSelected,
    @required this.onSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final style = isSelected
        ? TextStyle(
            fontSize: 18,
            color: selectedColor,
            fontWeight: FontWeight.bold,
          )
        : TextStyle(fontSize: 18);
    return ListTile(
      onTap: () => onSelectedItem(item),
      title: Text(
        item.value,
        style: style,
      ),
      trailing:
          isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null,
    );
  }
}
