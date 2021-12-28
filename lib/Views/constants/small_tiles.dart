import 'package:flutter/material.dart';

class SmallTile extends StatelessWidget {
   SmallTile(
      {this.scale = 1.8,
      required this.value,
      this.icon,
      this.image = "0",
      required this.title,
      this.width = 65,
      this.height = 60,
      Key? key})
      : super(key: key);
  final double? scale;
  final IconData? icon;
  final String? image;
  final String? title;
  final String? value;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
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
                  size: 10 * scale! + 1.5,
                )
              : Container(),
          Text(
            title!,
            style: Theme.of(context).textTheme.labelLarge,
            textScaleFactor: scale! * 0.4,
          ),
          Text(value!,
              style: Theme.of(context).textTheme.bodySmall,
              textScaleFactor: scale! * 0.4)
        ],
      ),
    );
  }
}
