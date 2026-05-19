import 'package:bc4f/model/group.dart';
import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class GroupFormBody extends StatefulWidget {
  final BarcodeGroup? group;

  const GroupFormBody({super.key, this.group});

  @override
  State<GroupFormBody> createState() => _GroupFormBodyState();
}

class _GroupFormBodyState extends State<GroupFormBody> {
  late BarcodeGroup _group;
  late TextEditingController name;
  late TextEditingController description;
  late TextEditingController imgUrl;
  String? error;

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
    name.dispose();
    description.dispose();
    imgUrl.dispose();
    super.dispose();
  }

  void updateForm() {
    _group.name = name.text;
    _group.description = description.text;
    _group.imgUrl = imgUrl.text.isEmpty ? null : imgUrl.text;
  }

  bool validate() {
    updateForm();
    setState(() => error = null);
    if (_group.name == null || _group.name!.isEmpty) {
      setState(() => error = 'name required');
      return false;
    }
    return true;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveGroup(_group)
          .then((_) => Navigator.of(context).pop());
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
          decoration: const InputDecoration(labelText: 'name'),
        ),
        TextField(
          controller: description,
          decoration: const InputDecoration(labelText: 'description'),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: imgUrl,
                decoration: const InputDecoration(labelText: 'imgUrl'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.gif),
              onPressed: () async {
                final gif = await GiphyPicker.pickGif(
                  context: context,
                  apiKey: GIPHY_APIKEY,
                );
                if (gif != null) {
                  setState(() {
                    imgUrl.text = gif.images.original?.url ?? '';
                  });
                }
              },
            ),
          ],
        ),
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
