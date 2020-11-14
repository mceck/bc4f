import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagFormBody extends StatefulWidget {
  const TagFormBody({
    Key key,
    this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  _TagFormBodyState createState() => _TagFormBodyState();
}

class _TagFormBodyState extends State<TagFormBody> {
  TextEditingController name;
  Color color;

  Tag _tag;

  @override
  void initState() {
    _tag = widget.tag ?? Tag();
    name = TextEditingController(text: _tag.name);
    color = _tag.color ?? Colors.amber;
    super.initState();
  }

  @override
  void dispose() {
    if (name != null) name.dispose();
    super.dispose();
  }

  void updateForm() {
    _tag.name = name.text;
    _tag.color = color;
  }

  void updateCtrls() {
    name.text = _tag.name ?? '';
    color = _tag.color;
  }

  bool validate() {
    updateForm();
    return _tag.name.isNotEmpty;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveTag(_tag).then((_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: name,
          decoration: InputDecoration(labelText: 'tag'),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
              width: 80,
              height: 20,
            ),
            SizedBox(width: 30),
            SizedBox(
              height: 30,
              child: FloatingActionButton(
                  mini: true,
                  child: Icon(
                    Icons.color_lens,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: color,
                            onColorChanged: (c) {
                              setState(() {
                                color = c;
                              });
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
        SizedBox(height: 20),
        RaisedButton(
          onPressed: save,
          child: Text('Save'),
        )
      ],
    );
  }
}
