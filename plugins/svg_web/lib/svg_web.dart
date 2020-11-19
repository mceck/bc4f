import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:svg_web/src/shim/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;

// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:svg_web/src/svg_web_view.dart';

class SvgWebPlugin {
  static void registerWith(registrar) {
    ui.platformViewRegistry
        .registerViewFactory(svgWebViewType, svgWebViewFactory);
  }
}

class SvgWeb extends StatefulWidget {
  final String svgString;
  final double width, height;
  final BoxFit fit;

  const SvgWeb({Key key, this.width, this.height, this.fit, this.svgString})
      : super(key: key);

  @override
  _SvgWebState createState() => _SvgWebState();
}

class _SvgWebState extends State<SvgWeb> {
  SvgWebViewController _controller;

  // @override
  // void didChangeDependencies() {
  //   _controller?.setProps(widget.svgString, width, height);

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        double width = widget.width ?? constraints.maxWidth;
        if (width == double.infinity) width = MediaQuery.of(context).size.width;
        double height = widget.height ?? constraints.maxHeight;
        if (height == double.infinity)
          height = MediaQuery.of(context).size.height;
        debugPrint('SVG WEB - build layout w$width h$height');
        return AbsorbPointer(
          child: PlatformViewLink(
            viewType: svgWebViewType,
            onCreatePlatformView: (PlatformViewCreationParams params) {
              debugPrint('SVG WEB - platform created, setting params...');
              _controller = SvgWebViewController.fromParams(params, context);
              _controller.setProps(
                svgString: widget.svgString,
                width: width.toInt(),
                height: height.toInt(),
                fit: widget.fit,
              );
              return _controller;
            },
            surfaceFactory:
                (BuildContext context, PlatformViewController controller) {
              return PlatformViewSurface(
                controller: controller,
                gestureRecognizers:
                    Set<Factory<OneSequenceGestureRecognizer>>(),
                hitTestBehavior: PlatformViewHitTestBehavior.transparent,
              );
            },
          ),
        );
      },
    );
  }
}
