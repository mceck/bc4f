import 'package:bc4f/service/barcode-service.dart';
import 'package:bc4f/utils/constants.dart';
import 'package:bc4f/utils/logger.dart';
import 'package:bc4f/widget/layout/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/model/tag.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'components/tag-form-body.dart';

class TagForm extends StatelessWidget {
  static const route = '/tags/form';

  final Tag tag;

  const TagForm({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bc4fScaffold(
      body: TagFormBody(tag: tag),
    );
  }
}
