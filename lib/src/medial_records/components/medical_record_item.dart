import 'package:flutter/material.dart';

class MedicalRecordItem extends StatelessWidget {
  const MedicalRecordItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "10/12/1997",
            style: Theme.of(context).textTheme.headline6,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            "Doctor: Richard",
            style: const TextStyle(fontSize: 20.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            'Descripción: dolor intestinal dasdfrasf gfda gfd gfd g fdg fdg fdgfdgfdg gfd gfd g',
            style: const TextStyle(fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
