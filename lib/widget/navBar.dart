import 'package:ecom_web_flutter/gen/assets.gen.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int index;
  const NavBar({Key? key, required this.scaffoldKey, required this.index})
      : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  TextEditingController controller = TextEditingController();
  bool _showSearch = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > 800 && constraint.maxWidth < 1200) {
        return mediumWidget();
      } else if (constraint.maxWidth >= 1200)
        return largeWidget();
      else
        return smallWidget();
    });
  }

  Widget largeWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icons.sevvaLogoJpg.path,
                fit: BoxFit.fitWidth,
                width: 150,
              ),
              HorizontalSeparator(width: 8),
              GestureDetector(
                onTap: () => context.go('/'),
                child: Text('Home',
                    style: widget.index == 0
                        ? CusTextStyle.navText.copyWith(color: CusColor.green)
                        : CusTextStyle.navText),
              ),
              HorizontalSeparator(width: 2),
              GestureDetector(
                onTap: () => context.go('/shop'),
                child: Text('Shop',
                    style: widget.index == 1
                        ? CusTextStyle.navText.copyWith(color: CusColor.green)
                        : CusTextStyle.navText),
              ),
              HorizontalSeparator(width: 2),
              GestureDetector(
                onTap: () => context.go('/cart'),
                child: Text('Cart',
                    style: widget.index == 2
                        ? CusTextStyle.navText.copyWith(color: CusColor.green)
                        : CusTextStyle.navText),
              ),
              Spacer(),
              Visibility(
                visible: _showSearch,
                replacement: GestureDetector(
                    onTap: () => setState(() {
                          _showSearch = true;
                        }),
                    child: SizedBox(
                        height: 40,
                        child:
                            Icon(Icons.search_rounded, color: CusColor.green))),
                child: SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 20,
                    height: 40,
                    child: TextFormField(
                      onTapOutside: (event) => setState(() {
                        _showSearch = false;
                      }),
                      style: CusTextStyle.bodyText,
                      controller: controller,
                      onEditingComplete: () {
                        context
                            .go('/shop?category=&keyword=${controller.text}');
                      },
                      decoration: InputDecoration(
                          hintText: 'Mau sewa apa?',
                          hintStyle: CusTextStyle.bodyText
                              .copyWith(color: CusColor.disable),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Container(
                            color: CusColor.green,
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide:
                                  BorderSide(color: CusColor.border, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                  color: CusColor.border, width: 2))),
                    )),
              ),
              HorizontalSeparator(width: 2),
              GestureDetector(
                onTap: () => context.go('/account'),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: CusColor.border, shape: BoxShape.circle),
                  child: pref.getBool(SharedPreferencesManager.keyAuth) ?? false
                      ? Image.network(
                          pref.getString(
                                  SharedPreferencesManager.keyProfileImage) ??
                              '',
                          fit: BoxFit.fitWidth)
                      : Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
        Divider(color: Color(0xffbebbbb)),
      ],
    );
  }

  Widget mediumWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icons.sevvaLogoJpg.path,
                fit: BoxFit.fitWidth,
                width: 150,
              ),
              HorizontalSeparator(width: 8),
              Visibility(
                visible: !_showSearch,
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Text('Home',
                      style: widget.index == 0
                          ? CusTextStyle.navText.copyWith(color: CusColor.green)
                          : CusTextStyle.navText),
                ),
              ),
              Visibility(
                  visible: !_showSearch, child: HorizontalSeparator(width: 2)),
              Visibility(
                visible: !_showSearch,
                child: GestureDetector(
                  onTap: () => context.go('/shop'),
                  child: Text('Shop',
                      style: widget.index == 1
                          ? CusTextStyle.navText.copyWith(color: CusColor.green)
                          : CusTextStyle.navText),
                ),
              ),
              Visibility(
                  visible: !_showSearch, child: HorizontalSeparator(width: 2)),
              Visibility(
                visible: !_showSearch,
                child: GestureDetector(
                  onTap: () => context.go('/cart'),
                  child: Text('Cart',
                      style: widget.index == 2
                          ? CusTextStyle.navText.copyWith(color: CusColor.green)
                          : CusTextStyle.navText),
                ),
              ),
              Spacer(),
              _showSearch
                  ? Expanded(
                      child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            onTapOutside: (event) => setState(() {
                              _showSearch = false;
                            }),
                            onEditingComplete: () {
                              context.go(
                                  '/shop?category=&keyword=${controller.text}');
                            },
                            style: CusTextStyle.bodyText,
                            decoration: InputDecoration(
                                hintText: 'Mau sewa apa?',
                                hintStyle: CusTextStyle.bodyText
                                    .copyWith(color: CusColor.disable),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Container(
                                  color: CusColor.green,
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(
                                        color: CusColor.border, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(
                                        color: CusColor.border, width: 2))),
                          )),
                    )
                  : GestureDetector(
                      onTap: () => setState(() {
                            _showSearch = true;
                          }),
                      child: SizedBox(
                          height: 40,
                          child: Icon(Icons.search_rounded,
                              color: CusColor.green))),
              HorizontalSeparator(width: 2),
              GestureDetector(
                onTap: () => context.go('/account'),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: CusColor.border, shape: BoxShape.circle),
                  child: pref.getBool(SharedPreferencesManager.keyAuth) ?? false
                      ? Image.network(
                          pref.getString(
                                  SharedPreferencesManager.keyProfileImage) ??
                              '',
                          fit: BoxFit.fitWidth)
                      : Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
        Divider(color: Color(0xffbebbbb)),
      ],
    );
  }

  Widget smallWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !_showSearch,
                child: SizedBox(
                  height: 40,
                  child: GestureDetector(
                    onTap: () => widget.scaffoldKey.currentState!.openDrawer(),
                    child: Icon(
                      Icons.menu_rounded,
                      color: CusColor.green,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !_showSearch,
                child: Image.asset(
                  Assets.icons.sevvaLogoJpg.path,
                  fit: BoxFit.fitWidth,
                  width: 150,
                ),
              ),
              _showSearch
                  ? Expanded(
                      child: SizedBox(
                          width: SizeConfig.screenWidth,
                          height: 40,
                          child: TextFormField(
                            onTapOutside: (event) => setState(() {
                              _showSearch = false;
                            }),
                            onEditingComplete: () {
                              context.go(
                                  '/shop?category=&keyword=${controller.text}');
                            },
                            style: CusTextStyle.bodyText,
                            decoration: InputDecoration(
                                hintText: 'Mau sewa apa?',
                                hintStyle: CusTextStyle.bodyText
                                    .copyWith(color: CusColor.disable),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Container(
                                  color: CusColor.green,
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(
                                        color: CusColor.border, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide(
                                        color: CusColor.border, width: 2))),
                          )),
                    )
                  : GestureDetector(
                      onTap: () => setState(() {
                            _showSearch = true;
                          }),
                      child: SizedBox(
                          height: 40,
                          child: Icon(Icons.search_rounded,
                              color: CusColor.green))),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 10),
          child: Divider(color: Color(0xffbebbbb)),
        ),
      ],
    );
  }
}

class NavDrawer extends StatefulWidget {
  final int index;
  const NavDrawer({Key? key, required this.index}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.icons.sevvaLogoJpg.path,
              fit: BoxFit.fitWidth,
              width: 150,
            ),
            VerticalSeparator(height: 5),
            GestureDetector(
                onTap: () => context.go('/'),
                child: Text('Home',
                    style: widget.index == 0
                        ? CusTextStyle.navText.copyWith(color: CusColor.green)
                        : CusTextStyle.navText)),
            VerticalSeparator(height: 3),
            GestureDetector(
              onTap: () => context.go('/shop'),
              child: Text('Shop',
                  style: widget.index == 1
                      ? CusTextStyle.navText.copyWith(color: CusColor.green)
                      : CusTextStyle.navText),
            ),
            VerticalSeparator(height: 3),
            GestureDetector(
              onTap: () => context.go('/cart'),
              child: Text('Cart',
                  style: widget.index == 2
                      ? CusTextStyle.navText.copyWith(color: CusColor.green)
                      : CusTextStyle.navText),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => context.go('/account'),
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: CusColor.border, shape: BoxShape.circle),
                    child: pref.getBool(SharedPreferencesManager.keyAuth) ??
                            false
                        ? Image.network(
                            pref.getString(
                                    SharedPreferencesManager.keyProfileImage) ??
                                '',
                            fit: BoxFit.fitWidth)
                        : Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  HorizontalSeparator(width: 2),
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 25,
                    child: Text(
                        pref.getBool(SharedPreferencesManager.keyAuth) ?? false
                            ? pref.getString(
                                    SharedPreferencesManager.keyName) ??
                                ''
                            : 'Login',
                        style: CusTextStyle.navText),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
