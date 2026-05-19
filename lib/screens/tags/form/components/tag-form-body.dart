import 'package:bc4f/model/tag.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagFormBody extends StatefulWidget {
  const TagFormBody({super.key, this.tag});

  final Tag? tag;

  @override
  State<TagFormBody> createState() => _TagFormBodyState();
}

class _TagFormBodyState extends State<TagFormBody> {
  late TextEditingController name;
  late Color color;
  String? error;
  late Tag _tag;

  @override
  void initState() {
    _tag = widget.tag ?? Tag();
    name = TextEditingController(text: _tag.name);
    color = _tag.color ?? Colors.amber;
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void updateForm() {
    _tag.name = name.text;
    _tag.color = color;
  }

  bool validate() {
    setState(() => error = null);
    updateForm();
    if (_tag.name == null || _tag.name!.isEmpty) {
      setState(() => error = 'name required');
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
    final errorStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Colors.red);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'tag'),
        ),
        const SizedBox(height: 20),
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
            const SizedBox(width: 30),
            SizedBox(
              height: 30,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: color,
                          onColorChanged: (c) {
                            setState(() => color = c);
                          },
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.color_lens, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            ElevatedButton(
              onPressed: save,
              child: const Text('Save'),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPadding),
                child: Text(error!, style: errorStyle),
              ),
          ],
        ),
      ],
    );
  }
}
