import 'package:flutter/material.dart';

class SmallTile extends StatelessWidget {
   SmallTile(
      {this.scale = 1.8,
      required this.value,
      this.icon,
      this.image = "0",
      required this.title,
      this.width = 65,
        this.isBlackTheme=true,
      this.height = 60,
      Key? key})
      : super(key: key);
  final double? scale;
  bool? isBlackTheme;
  final IconData? icon;
  final String? image;
  final String? title;
  final String? value;
  final double width;
  final double height;
  TextTheme? _textTheme;
  @override
  Widget build(BuildContext context) {
_textTheme=    Theme.of(context).textTheme;
    if (image != "0" && icon != null) {
      throw "You can provide only one value at a time image OR icon";
    }
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        children: [
          image != "0" && icon == null
              ? Image.asset(image!, scale: 10 * scale! + 1.5)
              : Container(),
          image == "0" && icon != null
              ? Icon(
                  icon,
                  color: isBlackTheme!?Colors.black87:Colors.white,
                  size: 10 * scale! + 1.5,
                )
              : Container(),
          Text(
            title!,
            style:isBlackTheme!?blackTheme():whiteTheme(),
            textScaleFactor: scale! * 0.4,
          ),
          Text(value!,
              style: isBlackTheme!?blackTheme(isHeading: false):whiteTheme(isHeading: false),
              textScaleFactor: scale! * 0.4)
        ],
      ),
    );
  }
  TextStyle? blackTheme({bool isHeading = true}){
    return isHeading ?_textTheme!.labelLarge:_textTheme!.bodySmall;
  }

   TextStyle? whiteTheme({bool isHeading = true}){
     return TextStyle(color: Colors.white,
         fontSize:isHeading? _textTheme!.labelLarge!.fontSize:_textTheme!.bodySmall!.fontSize,
       fontWeight:isHeading?_textTheme!.labelLarge!.fontWeight : _textTheme!.bodySmall!.fontWeight,
       fontFamily:isHeading? _textTheme!.labelLarge!.fontFamily :_textTheme!.bodySmall!.fontFamily,

     );
   }

}
