import 'package:ecom_web_flutter/gen/assets.gen.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > 600 && constraint.maxWidth < 1200) {
        return mediumWidget();
      } else if (constraint.maxWidth >= 1200)
        return largeWidget();
      else
        return smallWidget();
    });
  }

  Widget largeWidget() {
    return Container(
      color: CusColor.bgShade,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10,
          vertical: SizeConfig.safeBlockVertical * 5),
      child: Row(
        children: [
          Image.asset(
            Assets.icons.sevvaLogo.path,
            fit: BoxFit.fitWidth,
            width: 250,
          ),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halaman',
                style: CusTextStyle.bodyText
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              VerticalSeparator(height: 5),
              Text(
                'Home',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'Shop',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'Calculator',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'My Account',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mediumWidget() {
    return Container(
      color: CusColor.bgShade,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10,
          vertical: SizeConfig.safeBlockVertical * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            Assets.icons.sevvaLogo.path,
            fit: BoxFit.fitWidth,
            width: 250,
          ),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halaman',
                style: CusTextStyle.bodyText
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              VerticalSeparator(height: 5),
              Text(
                'Home',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'Shop',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'Calculator',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'My Account',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget smallWidget() {
    return Container(
      color: CusColor.bgShade,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10,
          vertical: SizeConfig.safeBlockVertical * 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Assets.icons.sevvaLogo.path,
                fit: BoxFit.fitWidth,
                width: 250,
              ),
              VerticalSeparator(height: 5),
              Text(
                'Halaman',
                style: CusTextStyle.bodyText
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              VerticalSeparator(height: 5),
              Text(
                'Home',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'Shop',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
              VerticalSeparator(height: 2),
              Text(
                'My Account',
                style:
                    CusTextStyle.navText.copyWith(color: CusColor.footerText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
