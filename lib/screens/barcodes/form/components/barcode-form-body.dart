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
  const BarcodeFormBody({super.key, this.barcode});

  final Barcode? barcode;

  @override
  State<BarcodeFormBody> createState() => _BarcodeFormBodyState();
}

class _BarcodeFormBodyState extends State<BarcodeFormBody> {
  late TextEditingController code;
  late TextEditingController name;
  late TextEditingController description;
  late TextEditingController imgUrl;

  String? error;
  late Barcode _barcode;

  @override
  void initState() {
    _barcode = widget.barcode ?? Barcode();
    log.info('form for ${_barcode.tags.runtimeType}');
    code = TextEditingController(text: _barcode.code);
    name = TextEditingController(text: _barcode.name);
    description = TextEditingController(text: _barcode.description);
    imgUrl = TextEditingController(text: _barcode.imgUrl);
    super.initState();
  }

  @override
  void dispose() {
    code.dispose();
    name.dispose();
    description.dispose();
    imgUrl.dispose();
    super.dispose();
  }

  void updateForm() {
    _barcode.code = code.text;
    _barcode.name = name.text;
    _barcode.description = description.text;
    _barcode.imgUrl = imgUrl.text;
  }

  bool validate() {
    bool ret = true;
    updateForm();
    setState(() {
      error = '';
      if (_barcode.group == null || _barcode.group!.isEmpty) {
        ret = false;
        error = 'group required';
      }
      if (_barcode.code == null || _barcode.code!.isEmpty) {
        ret = false;
        error = '${error!.isEmpty ? '' : ', '}code required';
      }
    });
    return ret;
  }

  void save() {
    if (validate()) {
      BarcodeService.saveBarcode(_barcode)
          .then((_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Colors.red);
    final allgroups =
        Provider.of<GroupProvider>(context, listen: false).groups;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: code,
                decoration: const InputDecoration(labelText: 'code'),
              ),
            ),
            if (!kIsWeb)
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () async {
                  log.info('open scanner');
                  final value = await scanBarcode(context);
                  if (value != null) {
                    log.info('got value ${value.code} from scanner');
                    setState(() {
                      code.text = value.code ?? '';
                      _barcode.type =
                          value.type ?? bcLib.BarcodeType.CodeEAN13;
                    });
                  }
                },
              ),
          ],
        ),
        SelectList(
          hint: const Text('type'),
          list: bcLib.BarcodeType.values
              .map((t) => t.toString().split('.').last)
              .toList(),
          onChanged: (val) {
            setState(() {
              _barcode.type = bcLib.BarcodeType.values.firstWhere(
                (t) => t.toString().split('.').last == val,
                orElse: () => bcLib.BarcodeType.CodeEAN13,
              );
            });
          },
          value: _barcode.type.toString().split('.').last,
        ),
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
            const Text('Group:'),
            Padding(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              child: SelectList(
                list: allgroups.map((g) => g.uid ?? '').toList(),
                display: (id) {
                  final grp =
                      allgroups.where((g) => g.uid == id).firstOrNull;
                  return Text(grp?.name ?? id);
                },
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
        EditableTagList(
          onTagFilterChange: (filter) {
            setState(() {
              _barcode.tags = filter;
            });
          },
          tags: _barcode.tags,
        ),
        const SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            ElevatedButton(
              onPressed: save,
              child: const Text('Save'),
            ),
            if (error != null && error!.isNotEmpty)
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
