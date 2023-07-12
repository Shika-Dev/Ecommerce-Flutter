import 'package:ecom_web_flutter/utils/size.dart';
import 'package:flutter/cupertino.dart';

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.safeBlockVertical * height,
    );
  }
}

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: SizeConfig.safeBlockHorizontal * width,
    );
  }
}
