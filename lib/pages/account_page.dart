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
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
        backgroundColor: Colors.white,
        drawer: NavDrawer(
          index: 5,
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            var whatsappUrl = "whatsapp://send?phone=+6281918887333";
            try {
              launch(whatsappUrl);
            } catch (e) {
              //To handle error and display error message
              print('unable to open WhatsApp');
            }
          },
          child: Image.asset(Assets.icons.waIcon.path,
              isAntiAlias: true,
              filterQuality: FilterQuality.medium,
              width: 62,
              fit: BoxFit.fitWidth),
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
    return Column(
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
                      context.go('/');
                    } else {
                      await handleSignIn();
                      context.go('/');
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
        VerticalSeparator(height: 2),
        Spacer(),
        Footer()
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
                      context.go('/');
                    } else {
                      await handleSignIn();
                      context.go('/');
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
