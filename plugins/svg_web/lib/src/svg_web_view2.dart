// import 'dart:async';
// import 'package:svg_web/src/shim/fake_html.dart'
//     if (dart.library.html) 'dart:html' as html;

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

// /// The unique identifier for the view type to be used for svgWeb platform views.
// const String svgWebViewType = '__svg_web::svgWebLite';

// const _kUndraggableCss =
//     'user-drag: none;user-select: none;-moz-user-select: none;-webkit-user-drag: none;-webkit-user-select: none;-ms-user-select: none;';

// /// Signature for a function that takes a unique [id] and creates an HTML element.
// typedef HtmlViewFactory = html.Element Function(int viewId);

// HtmlViewFactory get svgWebViewFactory => SvgWebViewController._viewFactory;

// /// Controls svgWeb views.
// class SvgWebViewController extends PlatformViewController {
//   /// Creates a [SvgWebViewController] instance with the unique [viewId].
//   SvgWebViewController(this.viewId, this.context) {
//     _instances[viewId] = this;
//   }

//   /// Creates and initializes a [SvgWebViewController] instance with the given
//   /// platform view [params].
//   factory SvgWebViewController.fromParams(
//     PlatformViewCreationParams params,
//     BuildContext context,
//   ) {
//     final int viewId = params.id;
//     final SvgWebViewController controller =
//         SvgWebViewController(viewId, context);
//     controller._initialize().then((_) {
//       params.onPlatformViewCreated(viewId);
//     });
//     return controller;
//   }

//   static Map<int, SvgWebViewController> _instances =
//       <int, SvgWebViewController>{};

//   static html.Element _viewFactory(int viewId) {
//     return _instances[viewId]?._element;
//   }

//   @override
//   final int viewId;

//   /// The context of the [Svg] widget that created this controller.
//   final BuildContext context;

//   html.Element _element;
//   bool get _isInitialized => _element != null;

//   Future<void> _initialize() async {
//     _element = _createImage();

//     final Map<String, dynamic> args = <String, dynamic>{
//       'id': viewId,
//       'viewType': svgWebViewType,
//     };
//     await SystemChannels.platform_views.invokeMethod<void>('create', args);
//   }

//   html.Element _createImage() {
//     final html.Element element = html.Element.span()
//       ..setAttribute('style', _kUndraggableCss);
//     return element;
//   }

//   void setProps({String svgString, int width, int height, BoxFit fit}) {
//     final validator = html.NodeValidatorBuilder();
//     validator.allowSvg();
//     _element.setInnerHtml(
//       svgString,
//       validator: validator,
//     );
//   }

//   @override
//   Future<void> clearFocus() async {
//     // Currently this does nothing on Flutter Web.
//     // TODO(het): Implement this. See https://github.com/flutter/flutter/issues/39496
//   }

//   @override
//   Future<void> dispatchPointerEvent(PointerEvent event) async {
//     // We do not dispatch pointer events to HTML views
//   }

//   @override
//   Future<void> dispose() async {
//     if (_isInitialized) {
//       assert(_instances[viewId] == this);
//       _instances.remove(viewId);
//       await SystemChannels.platform_views.invokeMethod<void>('dispose', viewId);
//     }
//   }
// }
