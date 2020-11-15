import 'package:barcode/barcode.dart' as bcLib;
import 'package:bc4f/model/barcode.dart';
import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/components/barcode-scanner.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:bc4f/widget/components/tags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:provider/provider.dart';

class BarcodeFormBody extends StatefulWidget {
  const BarcodeFormBody({
    Key key,
    this.barcode,
  }) : super(key: key);

  final Barcode barcode;

  @override
  _BarcodeFormBodyState createState() => _BarcodeFormBodyState();
}

class _BarcodeFormBodyState extends State<BarcodeFormBody> {
  TextEditingController code;
  TextEditingController name;
  TextEditingController description;
  TextEditingController imgUrl;

  String error;

  Barcode _barcode;

  @override
  void initState() {
    _barcode = widget.barcode ?? Barcode();
    log.info('form for ${_barcode.tags.runtimeType}');

    code = TextEditingController(text: _barcode?.code);
    name = TextEditingController(text: _barcode?.name);
    description = TextEditingController(text: _barcode?.description);
    imgUrl = TextEditingController(text: _barcode?.imgUrl);

    super.initState();
  }

  @override
  void dispose() {
    if (code != null) code.dispose();
    if (name != null) name.dispose();
    if (description != null) description.dispose();
    if (imgUrl != null) imgUrl.dispose();
    super.dispose();
  }

  void updateForm() {
    _barcode.code = code.text;
    _barcode.name = name.text;
    _barcode.description = description.text;
    _barcode.imgUrl = imgUrl.text;
  }

  void updateCtrls() {
    code.text = _barcode.code ?? '';
    name.text = _barcode.name ?? '';
    description.text = _barcode.description ?? '';
    imgUrl.text = _barcode.imgUrl ?? '';
  }

  bool validate() {
    bool ret = true;
    updateForm();
    setState(() {
      error = '';
      if (_barcode.group == null || _barcode.group.isEmpty) {
        ret = false;
        error += 'group required';
      }
      if (_barcode.code == null || _barcode.code.isEmpty) {
        ret = false;
        error += '${error.isEmpty ? '' : ', '}code required';
      }
    });
    return ret;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveBarcode(_barcode)
          .then((value) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red);
    final allgroups = Provider.of<GroupProvider>(context, listen: false).groups;
    return Column(
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
          hint: Text('type'),
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
        Row(
          children: [
            Text('Group:'),
            Padding(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              child: SelectList(
                list: allgroups.map((g) => g.uid).toList(),
                display: (id) =>
                    Text(allgroups.firstWhere((g) => g.uid == id).name),
                onChanged: (val) {
                  setState(() {
                    _barcode.group = val;
                  });
                },
                value: _barcode.group,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: imgUrl,
                decoration: InputDecoration(labelText: 'imgUrl'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.gif),
              onPressed: () {
                GiphyPicker.pickGif(
                  context: context,
                  apiKey: GIPHY_APIKEY,
                  lang: GiphyLanguage.italian,
                  showPreviewPage: false,
                ).then((gif) {
                  setState(() {
                    imgUrl.text = gif.images.original.url;
                  });
                });
              },
            ),
          ],
        ),
        EditableTagList(
          onTagFilterChange: (filter) {
            setState(() {
              _barcode.tags = filter;
            });
          },
          tags: _barcode.tags,
        ),
        SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            RaisedButton(
              onPressed: save,
              child: Text('Save'),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPadding),
                child: Text(
                  error,
                  style: errorStyle,
                ),
              )
          ],
        ),
      ],
    );
  }
}
