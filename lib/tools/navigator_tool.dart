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

  static push(
    BuildContext context, {
    required Widget page,
    String routeName = '',
    bool isModal = false,
    Function(dynamic)? then,
  }) {
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
