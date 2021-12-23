import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App {
  App._private();
  static final instance = App._private();

  ///Application SnackBar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(BuildContext context,
          {String? text, Color? bgColor, TextStyle? textStyle}) =>
      Scaffold.of(context).showSnackBar( SnackBar(
        content: Text(
            text!,
            style: textStyle ?? Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        duration: const Duration(seconds: 2),

        backgroundColor:
            bgColor ?? Theme.of(context).snackBarTheme.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: Theme.of(context).snackBarTheme.shape,
      ));


///Application Button
  CupertinoButton button(BuildContext context,{
    required Widget child,
    required void Function()? onPressed,
    Color? color,
  })=>  CupertinoButton(child: child,padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10), onPressed: onPressed,color: color??Theme.of(context).buttonTheme.colorScheme!.background,);
}
