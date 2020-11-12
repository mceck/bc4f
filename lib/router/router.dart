import 'package:bc4f/screens/barcodes/form/barcode-form.dart';
import 'package:bc4f/screens/barcodes/view/barcode-view.dart';
import 'package:bc4f/screens/groups/detail/group-detail.dart';
import 'package:bc4f/screens/groups/view/group-view.dart';
import 'package:bc4f/screens/homepage/homepage.dart';
import 'package:bc4f/screens/search/search.dart';
import 'package:bc4f/screens/tags/form/tag-form.dart';
import 'package:bc4f/screens/tags/view/tag-view.dart';
import 'package:flutter/material.dart';
import 'package:bc4f/screens/groups/form/group-form.dart';
import 'package:bc4f/screens/not-found/not-found.dart';

class Routing {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic> args = settings.arguments ?? {};
    Route<dynamic> route;

    switch (settings.name) {
      case GroupForm.route:
        /**
         * @route:  
         *      /groups/form
         * @args: 
         *      group: BarcodeGroup, if null is new rec
         */
        route = _getPageRoute(GroupForm(group: args['group']), settings);
        break;
      case GroupView.route:
        /**
         * @route:  
         *      /groups/view
         * @args: 
         *      groups: List<BarcodeGroup> if null or empty invite to add some group
         */
        route = _getPageRoute(GroupView(groups: args['groups']), settings);
        break;
      case GroupDetail.route:
        /**
         * @route:  
         *      /groups/detail
         * @args: 
         *      group: BarcodeGroup required
         */
        route = _getPageRoute(GroupDetail(group: args['group']), settings);
        break;
      case TagForm.route:
        /**
         * @route:  
         *      /tags/form
         * @args: 
         *      tag: Tag if null is new rec
         */
        route = _getPageRoute(TagForm(tag: args['tag']), settings);
        break;
      case TagView.route:
        /**
         * @route:  
         *      /tags/view
         * @args: 
         *      tags: List<Tags> if null or empty invite to add some tag
         */
        route = _getPageRoute(TagView(tags: args['tags']), settings);
        break;
      case BarcodeForm.route:
        /**
         * @route:
         *      /barcodes/form
         * @args: 
         *      barcode: Barcode if null is new rec
         */
        route = _getPageRoute(BarcodeForm(barcode: args['barcode']), settings);
        break;
      case BarcodeView.route:
        /**
         * @route:
         *        /barcodes/view
         * @args: 
         *        barcodes: List<Barcode> required not empty
         *        startIdx: default 0
         */
        route = _getPageRoute(
          BarcodeView(
            barcodes: args['barcodes'],
            startIdx: args['startIdx'],
          ),
          settings,
        );
        break;
      case HomepageScreen.route:
        /**
         * @route:
         *        /
         */
        route = _getPageRoute(HomepageScreen(), settings);
        break;
      case SearchScreen.route:
        /**
         * @route:
         *        /barcodes/view
         * @args: 
         *        search: String default string to search
         *        tagFilters: List<Tag> default tags to filter
         *        groupFilters: List<BarcodeGroup> default groups to filter
         */
        route = _getPageRoute(
          SearchScreen(
            search: args['search'],
            tagFilters: args['tagFilters'],
            groupFilters: args['groupFilters'],
          ),
          settings,
        );
        break;
      default:
        route = _getPageRoute(NotFoundScreen(), settings);
    }
    return route;
  }

  static PageRoute _getPageRoute(Widget screen, RouteSettings settings) =>
      FadeRoute(screen, settings);
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute(this.page, RouteSettings settings)
      : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
