import 'package:flutter/material.dart';

class NavigatorTool {
  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == routeName) {
        return true;
      }
      return false;
    });
  }

  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  static push(
    BuildContext context, {
    required Widget page,
    String routeName = '',
    bool isModal = false,
    Function(dynamic)? then,
    bool withAnimation = false,
  }) {
    if (withAnimation) {
      Navigator.of(context).push(_createRoute(page));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(
              fullscreenDialog: isModal,
              settings: RouteSettings(
                name: routeName.isEmpty ? page.toString().toLowerCase() : routeName,
              ),
              builder: (context) {
                return page;
              }))
          .then((value) {
        if (then != null) {
          then(value);
        }
      });
    }
  }

  static pushAndRemove(
    BuildContext context, {
    required Widget page,
    String routeName = '',
    String until = '',
  }) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          settings: RouteSettings(name: routeName.isEmpty ? page.toString().toLowerCase() : routeName),
          builder: (context) {
            return page;
          },
        ), (route) {
      if (until.isEmpty) {
        return false;
      } else {
        if (until == route.settings.name) {
          return true;
        } else {
          return false;
        }
      }
    });
  }
}
