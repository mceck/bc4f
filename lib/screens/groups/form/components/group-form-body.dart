import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class GroupFormBody extends StatefulWidget {
  final BarcodeGroup group;

  const GroupFormBody({Key key, this.group}) : super(key: key);

  @override
  _GroupFormBodyState createState() => _GroupFormBodyState();
}

class _GroupFormBodyState extends State<GroupFormBody> {
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
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: SingleChildScrollView(
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
