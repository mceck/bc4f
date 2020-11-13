import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/barcode-scanner.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';

class BarcodeForm extends StatefulWidget {
  static const route = '/barcodes/form';

  final Barcode barcode;

  const BarcodeForm({Key key, this.barcode}) : super(key: key);

  @override
  _BarcodeFormState createState() => _BarcodeFormState();
}

class _BarcodeFormState extends State<BarcodeForm> {
  TextEditingController code;
  TextEditingController name;
  TextEditingController description;

  Barcode _barcode;

  @override
  void initState() {
    _barcode = widget.barcode;
    log.info('form for ${_barcode.tags.runtimeType}');

    code = TextEditingController(text: _barcode?.code);
    name = TextEditingController(text: _barcode?.name);
    description = TextEditingController(text: _barcode?.description);

    super.initState();
  }

  @override
  void dispose() {
    if (code != null) code.dispose();
    if (name != null) name.dispose();
    if (description != null) description.dispose();
    super.dispose();
  }

  void updateForm() {
    _barcode.code = code.text;
    _barcode.name = name.text;
    _barcode.description = description.text;
  }

  void updateCtrls() {
    code.text = _barcode.code ?? '';
    name.text = _barcode.name ?? '';
    description.text = _barcode.description ?? '';
  }

  bool validate() {
    updateForm();
    return _barcode.code.isNotEmpty;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveBarcode(_barcode)
          .then((value) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: code,
                    decoration: InputDecoration(labelText: 'code'),
                  ),
                ),
                if (!kIsWeb)
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      log.info('open scanner');
                      scanBarcode(context).then((value) {
                        log.info('got value $value from scanner');
                        setState(() {
                          code.text = value.code;
                          _barcode.type = value.type;
                        });
                      });
                    },
                  ),
              ],
            ),
            SelectList(
              list: bcLib.BarcodeType.values
                  .map((t) => t.toString().split('.')[1])
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _barcode.type = bcLib.BarcodeType.values
                      .firstWhere((t) => t.toString().split('.')[1] == val);
                });
              },
              value: _barcode.type.toString().split('.')[1],
            ),
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: 'name'),
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(labelText: 'description'),
            ),
            EditableTagList(
              onTagFilterChange: (filter) {
                setState(() {
                  _barcode.tags = filter;
                });
              },
              tags: _barcode.tags,
            ),
            RaisedButton(
              onPressed: save,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
