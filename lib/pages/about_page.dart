import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/currency_format.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          index: 3,
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            if (constraint.maxWidth > 600)
              return largeWidget();
            else
              return smallWidget();
          },
        ));
  }

  Widget largeWidget() {
    return ListView(
        children: [
          ContactBar(),
          VerticalSeparator(height: 1),
          NavBar(
            scaffoldKey: _scaffoldKey,
            index: 3,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 10,
                vertical: SizeConfig.safeBlockVertical * 3),
            width: double.infinity,
            color: CusColor.bgShade,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Us',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 36, fontWeight: FontWeight.w700),
                ),
                VerticalSeparator(height: .5),
                RichText(
                    text: TextSpan(
                        text: 'Home • Pages ',
                        style: CusTextStyle.bodyText
                            .copyWith(fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(
                        text: '• About Us',
                        style: CusTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.w500, color: CusColor.green),
                      )
                    ]))
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          TimelineTile(
            isFirst: true,
            lineXY: .1,
            alignment: TimelineAlign.manual,
            endChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lorem Ipsum'),
                Text('hahidhaishdiahdoasoifanodasnff')
              ],
            ),
          ),
          TimelineDivider(
                  begin: 0.1,
                  end: 0.9,
                  thickness: 6,
                  color: Colors.purple,
                ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: .9,
            startChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lorem Ipsum'),
                Text('hahidhaishdiahdoasoifanodasnff')
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Container(alignment: Alignment.bottomCenter, child: Footer())
        ],
      );
  }

  Widget smallWidget() {
    return Column(
      children: [
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 3,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 10,
              vertical: SizeConfig.safeBlockVertical * 3),
          width: double.infinity,
          color: CusColor.bgShade,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Account',
                style: CusTextStyle.bodyText
                    .copyWith(fontSize: 36, fontWeight: FontWeight.w700),
              ),
              VerticalSeparator(height: .5),
              RichText(
                  text: TextSpan(
                      text: 'Home • Pages ',
                      style: CusTextStyle.bodyText
                          .copyWith(fontWeight: FontWeight.w500),
                      children: [
                    TextSpan(
                      text: '• MyAccount',
                      style: CusTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.w500, color: CusColor.green),
                    )
                  ]))
            ],
          ),
        ),
        VerticalSeparator(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 15),
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              boxShadow: [CusBoxShadow.shadow],
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  'Login',
                  style: CusTextStyle.bodyText
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 32),
                ),
                VerticalSeparator(height: .5),
                Text(
                  'Please login using account detail bellow.',
                  style: CusTextStyle.navText.copyWith(color: CusColor.bgShade),
                ),
                VerticalSeparator(height: 2),
              ],
            ),
          ),
        ),
        VerticalSeparator(height: 2),
        Spacer(),
        Footer()
      ],
    );
  }
}
