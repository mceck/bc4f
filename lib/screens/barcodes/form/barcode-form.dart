import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/model/tag.dart';
import 'package:bc4f/provider/tag-provider.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/firebase-stream-builder.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/barcode.dart';
import 'package:provider/provider.dart';

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

  Stream tagStream;

  @override
  void initState() {
    _barcode = widget.barcode;
    log.info('form for ${_barcode.tags.runtimeType}');

    code = TextEditingController(text: _barcode?.code);
    name = TextEditingController(text: _barcode?.name);
    description = TextEditingController(text: _barcode?.description);

    tagStream = BarcodeService.streamTags();
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
    final tags = Provider.of<TagProvider>(context).tags;
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
                      // TODO
                      // BarcodeScanner.scan().then(
                      //   (value) {
                      //     if (value.type != ResultType.Barcode) return;
                      //     setState(
                      //       () {
                      //         code.text = value.rawContent;
                      //         _barcode.type = BCTypes.formatToType(value.format);
                      //       },
                      //     );
                      //   },
                      // );
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
            if (tags.length > 0)
              FlatButton(
                onPressed: () {
                  setState(() {
                    _barcode.tags.add(tags[0].uid);
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text('Aggiungi tag'),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
                children: _barcode.tags
                    .map(
                      (tagId) => Row(
                        children: [
                          SelectList(
                            key: ValueKey(tagId),
                            list: tags.map((t) => t.uid).toList(),
                            onChanged: (val) {
                              final idx = _barcode.tags.indexOf(tagId);
                              if (idx >= 0)
                                setState(() {
                                  _barcode.tags[idx] = val;
                                });
                            },
                            value: tagId,
                            display: (id) => TagElem(
                                tag: tags.firstWhere((t) => t.uid == id)),
                            showUnderline: false,
                            showIcon: false,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _barcode.tags.remove(tagId);
                                });
                              }),
                        ],
                      ),
                    )
                    .toList(),
              ),
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
