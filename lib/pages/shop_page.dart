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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
  bool isAsc = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String capitalize(String s) =>
      s[0].toUpperCase() + s.substring(1).toLowerCase();

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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go('/detail-product/${product.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          width: isSmall ? 182 : 232,
          height: isSmall ? 350 : 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                width: isSmall ? 150 : 200,
                height: isSmall ? 150 : 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover)),
              ),
              VerticalSeparator(height: 2),
              SizedBox(
                width: isSmall ? 150 : 200,
                child: Text(product.category,
                    style: CusTextStyle.itemText
                        .copyWith(color: Color(0xff979797), fontSize: 16)),
              ),
              SizedBox(
                width: isSmall ? 150 : 200,
                child: Text(product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: CusTextStyle.itemText
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              const VerticalSeparator(height: 1),
              Visibility(
                visible: product.priceSale != product.priceOriginal,
                replacement: Text(
                  CurrencyFormat.convertToIdr(product.priceOriginal, 0),
                  style: CusTextStyle.itemText,
                ),
                child: RichText(
                    text: TextSpan(
                        text: CurrencyFormat.convertToIdr(
                            product.priceSale == 0
                                ? product.priceOriginal
                                : product.priceSale,
                            0),
                        style: CusTextStyle.itemText,
                        children: [
                      TextSpan(text: '   '),
                      TextSpan(
                        text:
                            '${product.priceSale == 0 ? '' : CurrencyFormat.convertToIdr(product.priceOriginal, 0)}',
                        style: CusTextStyle.itemText.copyWith(
                            color: CusColor.disable,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.disable),
                      )
                    ])),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: () async {
              //         SharedPreferencesManager pref =
              //             locator<SharedPreferencesManager>();
              //         bool isLogin =
              //             pref.getBool(SharedPreferencesManager.keyAuth) ??
              //                 false;
              //         if (isLogin) {
              //           Map<String, dynamic> body = {
              //             'cartData': [
              //               {
              //                 'productId': product.id,
              //                 'qty': 1,
              //                 'additionalNote': ''
              //               }
              //             ]
              //           };
              //           var model = await addToCart(body);
              //           if (model.errors != null) {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //                 const SnackBar(content: Text('Added to Cart')));
              //           } else {
              //             print(model.errors.toString());
              //           }
              //         } else {
              //           showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return AlertDialog(
              //                   title: const Text(
              //                       "Silahkan login untuk memasukkan produk ke keranjang anda"),
              //                   actions: [
              //                     TextButton(
              //                       child: const Text("Login"),
              //                       onPressed: () {
              //                         Navigator.pushNamed(context, '/account');
              //                       },
              //                     ),
              //                     TextButton(
              //                       child: const Text("Close"),
              //                       onPressed: () {
              //                         Navigator.of(context).pop();
              //                       },
              //                     )
              //                   ],
              //                 );
              //               });
              //         }
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle, color: CusColor.bgShade),
              //         child: Center(
              //           child: Icon(
              //             Icons.shopping_cart_outlined,
              //             color: CusColor.green,
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
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
                  child: SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 15,
                          child: FutureBuilder<CategoryModel>(
                              future: fetchAllCategory(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<String> item = snapshot
                                      .data!.data!.categories
                                      .map((e) => e.category)
                                      .toList();
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    width: SizeConfig.safeBlockHorizontal * 15,
                                    decoration: BoxDecoration(
                                        color: Color(0xffF5F5F5),
                                        border: Border.all(
                                            color: Color(0xffC0C0C0)),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Kategori',
                                            style: CusTextStyle.itemText
                                                .copyWith(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                        VerticalSeparator(height: 2),
                                        ...item.map((e) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(Uri.encodeComponent(
                                                          e));
                                                      context.go(
                                                          '/shop?category=${Uri.encodeComponent(e)}');
                                                    },
                                                    child: Text(capitalize(e),
                                                        style: CusTextStyle
                                                            .itemText
                                                            .copyWith(
                                                                fontSize: 16)),
                                                  ),
                                                ),
                                                VerticalSeparator(height: 2)
                                              ],
                                            ))
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError)
                                  return Text(snapshot.error.toString());
                                else
                                  return SizedBox(
                                      width: 50,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                              }),
                        ),
                        HorizontalSeparator(width: 3),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 62,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Daftar Produk',
                                        style: CusTextStyle.itemText.copyWith(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const VerticalSeparator(height: 1),
                                      Text(
                                        '${list.length} produk',
                                        style: CusTextStyle.navText.copyWith(
                                            color: const Color(0xff8A8FB9)),
                                      ),
                                    ],
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAsc = !isAsc;
                                          });
                                        },
                                        child: FaIcon(
                                            isAsc
                                                ? FontAwesomeIcons
                                                    .arrowDownShortWide
                                                : FontAwesomeIcons
                                                    .arrowDownWideShort,
                                            color: CusColor.darkBlue)),
                                  )
                                ],
                              ),
                            ),
                            const VerticalSeparator(height: 3),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 62,
                              child: Wrap(
                                spacing: SizeConfig.safeBlockHorizontal * 3,
                                runSpacing: 50,
                                children: isAsc
                                    ? list.map((e) => item(e, false)).toList()
                                    : list.reversed
                                        .map((e) => item(e, false))
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAsc = !isAsc;
                              });
                            },
                            child: FaIcon(
                                isAsc
                                    ? FontAwesomeIcons.arrowDownShortWide
                                    : FontAwesomeIcons.arrowDownWideShort,
                                color: CusColor.darkBlue)),
                      )
                    ],
                  ),
                ),
                const VerticalSeparator(height: 2),
                FutureBuilder<CategoryModel>(
                    future: fetchAllCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> item = snapshot.data!.data!.categories
                            .map((e) => e.category)
                            .toList();
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              hint: Text('Select Category'),
                              value: widget.category == ''
                                  ? null
                                  : Uri.decodeComponent(widget.category),
                              items: item
                                  .map((e) => DropdownMenuItem(
                                        child: Text(capitalize(e)),
                                        value: e,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(.6))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(.6))),
                              ),
                              onChanged: (dynamic val) async {
                                context.go(
                                    '/shop?category=${Uri.encodeComponent(val)}');
                              },
                            ),
                          ),
                        );
                      } else if (snapshot.hasError)
                        return Text(snapshot.error.toString());
                      else
                        return SizedBox(
                            width: 50,
                            child: Center(child: CircularProgressIndicator()));
                    }),
                const VerticalSeparator(height: 3),
                Wrap(
                  spacing: SizeConfig.safeBlockHorizontal * 3,
                  runSpacing: 50,
                  children: isAsc
                      ? list.map((e) => item(e, true)).toList()
                      : list.reversed.map((e) => item(e, true)).toList(),
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
