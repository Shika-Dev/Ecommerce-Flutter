import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/gen/assets.gen.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/auth.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late bool _isAuthorized;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SharedPreferencesManager pref = locator<SharedPreferencesManager>();
    setState(() {
      _isAuthorized = pref.getBool(SharedPreferencesManager.keyAuth) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          index: 5,
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

  Widget item() {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          color: Colors.grey,
        ),
        VerticalSeparator(height: 2),
        Text('Title',
            style: CusTextStyle.itemText
                .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
        VerticalSeparator(height: 1),
        Text(
          'Rp 200.000',
          style: CusTextStyle.itemText,
        )
      ],
    );
  }

  Widget largeWidget() {
    return Column(
      children: [
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 5,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        'Shop',
                        style: CusTextStyle.bodyText.copyWith(
                            fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                      VerticalSeparator(height: .5),
                      RichText(
                          text: TextSpan(
                              text: 'Home • Pages ',
                              style: CusTextStyle.bodyText
                                  .copyWith(fontWeight: FontWeight.w500),
                              children: [
                            TextSpan(
                              text: '• Shop',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CusColor.green),
                            )
                          ]))
                    ],
                  ),
                ),
                VerticalSeparator(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Daftar Produk',
                            style: CusTextStyle.itemText.copyWith(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          VerticalSeparator(height: 1),
                          Text(
                            '920 produk',
                            style: CusTextStyle.navText
                                .copyWith(color: Color(0xff8A8FB9)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                VerticalSeparator(height: 3),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ketegori',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            VerticalSeparator(height: 2),
                            Text(
                              'Furnitur',
                              style:
                                  CusTextStyle.bodyText.copyWith(fontSize: 18),
                            ),
                            VerticalSeparator(height: 2),
                            Text(
                              'Musik',
                              style:
                                  CusTextStyle.bodyText.copyWith(fontSize: 18),
                            ),
                            VerticalSeparator(height: 2),
                            Text(
                              'TV',
                              style:
                                  CusTextStyle.bodyText.copyWith(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      HorizontalSeparator(width: 3),
                      FutureBuilder(
                          future: fetchAllProduct(),
                          builder: (context, model) {
                            if (model.hasData)
                              return Expanded(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisExtent: 370,
                                          mainAxisSpacing:
                                              SizeConfig.safeBlockHorizontal *
                                                  5,
                                          crossAxisSpacing:
                                              SizeConfig.safeBlockHorizontal *
                                                  5,
                                          maxCrossAxisExtent: 300),
                                  itemBuilder: (context, index) => item(),
                                  itemCount: 12,
                                ),
                              );
                            if (model.hasError) {
                              print(model.error);
                              return Text('${model.error}');
                            }
                            return SizedBox();
                          })
                    ],
                  ),
                ),
                Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget smallWidget() {
    return ListView(
      children: [
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 5,
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
                GestureDetector(
                  onTap: () async {
                    if (_isAuthorized) {
                      await handleSignOut();
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      await handleSignIn();
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [CusBoxShadow.shadow],
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.images.icGoogle.path,
                            width: 32, fit: BoxFit.fitWidth),
                        HorizontalSeparator(width: 1),
                        Text(
                          _isAuthorized
                              ? 'Logout from your account'
                              : 'Login with your Google',
                          style: CusTextStyle.bodyText,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        VerticalSeparator(height: 4),
        Align(alignment: Alignment.bottomCenter, child: Footer())
      ],
    );
  }
}
