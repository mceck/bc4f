import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/group.dart';

class GroupForm extends StatefulWidget {
  static const route = '/groups/form';

  final BarcodeGroup group;

  const GroupForm({Key key, this.group}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  BarcodeGroup _group = BarcodeGroup();
  TextEditingController name;
  TextEditingController description;
  TextEditingController imgUrl;

  @override
  void initState() {
    _group = widget.group ?? BarcodeGroup();
    name = TextEditingController(text: _group.name);
    description = TextEditingController(text: _group.description);
    imgUrl = TextEditingController(text: _group.imgUrl);
    super.initState();
  }

  @override
  void dispose() {
    if (name != null) name.dispose();
    if (description != null) description.dispose();
    if (imgUrl != null) imgUrl.dispose();
    super.dispose();
  }

  void updateForm() {
    _group.name = name.text;
    _group.description = description.text;
    if (imgUrl.text.isEmpty)
      _group.imgUrl = null;
    else
      _group.imgUrl = imgUrl.text;
  }

  void updateCtrls() {
    name.text = _group.name ?? '';
    description.text = _group.description ?? '';
    imgUrl.text = _group.imgUrl ?? '';
  }

  bool validate() {
    updateForm();
    return _group.name.isNotEmpty;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveGroup(_group).then((_) => Navigator.of(context).pop());
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
                if (imgUrl.text.isNotEmpty)
                  Image.network(
                    imgUrl.text,
                    width: 80,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: imgUrl,
                      decoration: InputDecoration(labelText: 'imgUrl'),
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: save,
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
