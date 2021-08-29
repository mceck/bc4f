import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
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
  String error;

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
    setState(() {
      error = null;
    });
    updateForm();
    if (_tag.name.isEmpty) {
      setState(() {
        error = 'name required';
      });
      return false;
    }
    return true;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveTag(_tag).then((_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red);
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
                      builder: (context) => AlertDialog(
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
                          TextButton(
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
        SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            TextButton(
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
