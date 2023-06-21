import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'JosefinSans'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          contact(),
          VerticalSeparator(height: 1),
          navBar(),
          Expanded(
              child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10,
                  vertical: 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    item('Cantilever chair', '\$26.00', '\$42.00'),
                    item('Cantilever chair', '\$26.00', '\$42.00'),
                    item('Cantilever chair', '\$26.00', '\$42.00'),
                    item('Cantilever chair', '\$26.00', '\$42.00'),
                  ],
                ),
                VerticalSeparator(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 34, left: 25),
                      decoration: BoxDecoration(
                          color: Color(0xffFFF6FB),
                          boxShadow: [CusBoxShadow.shadow]),
                      child: Column(
                        children: [
                          Text(
                            '23% off in all products',
                            style: CusTextStyle.itemText
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          VerticalSeparator(height: 1),
                          Text(
                            'Shop Now',
                            style: CusTextStyle.itemText.copyWith(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: CusColor.green,
                                decoration: TextDecoration.underline,
                                decorationColor: CusColor.green),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget contact() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
      color: CusColor.green,
      child: Row(
        children: [
          Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          Text('lorem@gmail.com',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          HorizontalSeparator(width: 5),
          Icon(
            Icons.phone_in_talk_rounded,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          Text('(12345)67890',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          Spacer(),
          Text('English',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          HorizontalSeparator(width: 1),
          Text('USD',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          HorizontalSeparator(width: 1),
          Text('Login',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          Text('Wishlist',
              style: CusTextStyle.bodyText
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          Icon(
            Icons.favorite_border_rounded,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget navBar() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Hekto',
              style: CusTextStyle.bodyText
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 34)),
          HorizontalSeparator(width: 5),
          Icon(
            Icons.phone_in_talk_rounded,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 3),
          Text('Home',
              style: CusTextStyle.navText.copyWith(color: CusColor.green)),
          HorizontalSeparator(width: 2),
          Text('Categories Product', style: CusTextStyle.navText),
          HorizontalSeparator(width: 2),
          Text('Blog', style: CusTextStyle.navText),
          HorizontalSeparator(width: 2),
          Text('Shop', style: CusTextStyle.navText),
          HorizontalSeparator(width: 2),
          Text('Contact', style: CusTextStyle.navText),
          HorizontalSeparator(width: 2),
          Spacer(),
          SizedBox(
              width: SizeConfig.safeBlockHorizontal * 20,
              height: 40,
              child: TextFormField(
                style: CusTextStyle.bodyText,
                decoration: InputDecoration(
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
                        borderSide:
                            BorderSide(color: CusColor.border, width: 2))),
              ))
        ],
      ),
    );
  }

  Widget item(String title, String price, String? oldPrice) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 33),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [CusBoxShadow.shadow],
      ),
      child: Column(
        children: [
          Container(
            width: SizeConfig.safeBlockHorizontal * 15,
            height: SizeConfig.safeBlockVertical * 20,
            color: Color(0xffF5F6F8),
          ),
          VerticalSeparator(height: 1),
          Text(title,
              style:
                  CusTextStyle.itemText.copyWith(fontWeight: FontWeight.w700)),
          VerticalSeparator(height: 1),
          Row(
            children: [
              Text(price, style: CusTextStyle.itemText.copyWith(fontSize: 14)),
              oldPrice != null ? HorizontalSeparator(width: 1) : SizedBox(),
              oldPrice != null
                  ? Text(oldPrice,
                      style: CusTextStyle.itemText.copyWith(
                          color: CusColor.disable,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: CusColor.disable))
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
