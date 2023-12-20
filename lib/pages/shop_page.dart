import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/gen/assets.gen.dart';
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
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatefulWidget {
  final String category;
  final String? keyword;
  const ShopPage({Key? key, required this.category, this.keyword})
      : super(key: key);

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
        backgroundColor: Colors.white,
        drawer: const NavDrawer(
          index: 1,
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
        body: FutureBuilder(
            future: widget.category == ''
                ? fetchAllProduct(widget.keyword != null, widget.keyword)
                : fetchProductByCategory(widget.category),
            builder: (context, model) {
              if (model.hasData) {
                var list = model.data!.data!;
                return LayoutBuilder(
                  builder: (context, constraint) {
                    if (constraint.maxWidth > 900) {
                      return largeWidget(list);
                    } else {
                      return smallWidget(list);
                    }
                  },
                );
              }
              return SizedBox();
            }));
  }

  Widget item(ProductData product, bool isSmall) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15, right: 15),
          width: isSmall ? 200 : 300,
          height: isSmall ? 200 : 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(product.imageUrl), fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      SharedPreferencesManager pref =
                          locator<SharedPreferencesManager>();
                      bool isLogin =
                          pref.getBool(SharedPreferencesManager.keyAuth) ??
                              false;
                      if (isLogin) {
                        Map<String, dynamic> body = {
                          'cartData': [
                            {
                              'productId': product.id,
                              'qty': 1,
                              'additionalNote': ''
                            }
                          ]
                        };
                        var model = await addToCart(body);
                        if (model.errors != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to Cart')));
                        } else {
                          print(model.errors.toString());
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Silahkan login untuk memasukkan produk ke keranjang anda"),
                                actions: [
                                  TextButton(
                                    child: const Text("Login"),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/account');
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: CusColor.bgShade),
                      child: Center(
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: CusColor.green,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const VerticalSeparator(height: 2),
        Text(product.name,
            textAlign: TextAlign.center,
            style: CusTextStyle.itemText
                .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
        const VerticalSeparator(height: 1),
        Visibility(
          visible: product.priceSale == 0,
          child: Text(
            '${CurrencyFormat.convertToIdr(product.priceOriginal, 0)}',
            style: CusTextStyle.itemText,
          ),
          replacement: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${CurrencyFormat.convertToIdr(product.priceSale, 0)}',
                  style: CusTextStyle.itemText),
              const HorizontalSeparator(width: 1),
              Text('${CurrencyFormat.convertToIdr(product.priceOriginal, 0)}',
                  style: CusTextStyle.itemText.copyWith(
                      color: CusColor.disable,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: CusColor.disable)),
            ],
          ),
        ),
      ],
    );
  }

  Widget largeWidget(List<ProductData> list) {
    return Column(
      children: [
        const ContactBar(),
        const VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 1,
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
                      const VerticalSeparator(height: .5),
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
                const VerticalSeparator(height: 4),
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
                          const VerticalSeparator(height: 1),
                          Text(
                            '${list.length} produk',
                            style: CusTextStyle.navText
                                .copyWith(color: const Color(0xff8A8FB9)),
                          )
                        ],
                      ),
                      HorizontalSeparator(width: 3),
                      FutureBuilder<CategoryModel>(
                          future: fetchAllCategory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<String> item = snapshot
                                  .data!.data!.categories
                                  .map((e) => e.category)
                                  .toList();
                              return DropdownButton(
                                hint: Text('Select Category'),
                                value: widget.category == ''
                                    ? null
                                    : widget.category,
                                items: item
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (dynamic val) async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ShopPage(
                                                category: val,
                                              )));
                                },
                              );
                            } else if (snapshot.hasError)
                              return Text(snapshot.error.toString());
                            else
                              return SizedBox(
                                  width: 50,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                          })
                    ],
                  ),
                ),
                const VerticalSeparator(height: 3),
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 370,
                      mainAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                      crossAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                      maxCrossAxisExtent: 300),
                  itemBuilder: (context, index) => item(list[index], false),
                  itemCount: list.length,
                ),
                VerticalSeparator(height: 2),
                const Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget smallWidget(List<ProductData> list) {
    return Column(
      children: [
        const ContactBar(),
        const VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 1,
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
                      const VerticalSeparator(height: .5),
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
                const VerticalSeparator(height: 4),
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
                          const VerticalSeparator(height: 1),
                          Text(
                            '${list.length} produk',
                            style: CusTextStyle.navText
                                .copyWith(color: const Color(0xff8A8FB9)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const VerticalSeparator(height: 3),
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 370,
                      mainAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                      crossAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                      maxCrossAxisExtent: 300),
                  itemBuilder: (context, index) => item(list[index], true),
                  itemCount: list.length,
                ),
                VerticalSeparator(height: 2),
                const Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
