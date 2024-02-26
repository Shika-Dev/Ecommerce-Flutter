import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/api_repository/models/product_by_id_model.dart';
import 'package:ecom_web_flutter/bloc/product_bloc/product_bloc.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProductPage extends StatelessWidget {
  final String? id;
  const DetailProductPage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()..add(GetProductById(id: id ?? '')),
      child: DetailShopPage(),
    );
  }
}

class DetailShopPage extends StatefulWidget {
  const DetailShopPage({Key? key}) : super(key: key);

  @override
  State<DetailShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<DetailShopPage> {
  late bool _isAuthorized;
  int index = 1;
  bool showDesc = false;
  TextEditingController additionalCont = TextEditingController();

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
        body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state.status == ProductStatus.byIdSuccess) {
            return LayoutBuilder(
              builder: (context, constraint) {
                if (constraint.maxWidth > 900) {
                  return largeWidget(state.product!);
                } else {
                  return smallWidget(state.product!);
                }
              },
            );
          } else {
            return SizedBox();
          }
        }));
  }

  Widget largeWidget(ProductDataById productData) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Detail Produk',
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
                        Container(
                          width: SizeConfig.safeBlockHorizontal * 15,
                          height: SizeConfig.safeBlockHorizontal * 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 4)
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(productData.imageUrl),
                                  fit: BoxFit.cover)),
                        ),
                        HorizontalSeparator(width: 3),
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productData.name,
                                style: CusTextStyle.itemText.copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 22),
                              ),
                              VerticalSeparator(height: .5),
                              Text(
                                productData.category,
                                style: CusTextStyle.itemText.copyWith(
                                    color: Color(0xff979797),
                                    fontWeight: FontWeight.w700),
                              ),
                              VerticalSeparator(height: 2),
                              Visibility(
                                visible: productData.priceSale !=
                                    productData.priceOriginal,
                                replacement: Text(
                                  CurrencyFormat.convertToIdr(
                                      productData.priceOriginal, 0),
                                  style: CusTextStyle.itemText,
                                ),
                                child: RichText(
                                    text: TextSpan(
                                        text: CurrencyFormat.convertToIdr(
                                            productData.priceSale == 0
                                                ? productData.priceOriginal
                                                : productData.priceSale,
                                            0),
                                        style: CusTextStyle.itemText,
                                        children: [
                                      TextSpan(text: '   '),
                                      TextSpan(
                                        text:
                                            '${productData.priceSale == 0 ? '' : CurrencyFormat.convertToIdr(productData.priceOriginal, 0)}',
                                        style: CusTextStyle.itemText.copyWith(
                                            color: CusColor.disable,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: CusColor.disable),
                                      )
                                    ])),
                              ),
                              VerticalSeparator(height: 4),
                              Row(
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (index > 1) {
                                              index--;
                                            }
                                          });
                                        },
                                        child: Icon(Icons.remove)),
                                  ),
                                  HorizontalSeparator(width: 1),
                                  Text(index.toString()),
                                  HorizontalSeparator(width: 1),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            index++;
                                          });
                                        },
                                        child: Icon(Icons.add)),
                                  ),
                                  HorizontalSeparator(width: 3),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferencesManager pref =
                                            locator<SharedPreferencesManager>();
                                        bool isLogin = pref.getBool(
                                                SharedPreferencesManager
                                                    .keyAuth) ??
                                            false;
                                        if (isLogin) {
                                          Map<String, dynamic> body = {
                                            'cartData': [
                                              {
                                                'productId': productData.id,
                                                'qty': index,
                                                'additionalNote':
                                                    additionalCont.text
                                              }
                                            ]
                                          };
                                          var model = await addToCart(body);
                                          if (model.errors != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('Added to Cart')));
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
                                                      child:
                                                          const Text("Login"),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/account');
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              VerticalSeparator(height: 2),
                              Text(
                                'Catatan Tambahan',
                                style: CusTextStyle.itemText
                                    .copyWith(fontSize: 16),
                              ),
                              VerticalSeparator(height: 1),
                              TextFormField(
                                controller: additionalCont,
                                decoration: InputDecoration(
                                    hintText: 'Tambahkan catatan tambahan',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Color(0xffE1E1E1))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Color(0xffE1E1E1)))),
                                maxLines: 3,
                                minLines: 3,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                VerticalSeparator(height: 3),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Text(
                    'Produk Detail dan Deskripsi Produk',
                    style: CusTextStyle.itemText
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                VerticalSeparator(height: 1),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Text(
                    '${productData.productDetail}\n\n${productData.description}',
                    style: CusTextStyle.bodyText.copyWith(fontSize: 14),
                  ),
                ),
                VerticalSeparator(height: 3),
                const Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget smallWidget(ProductDataById productData) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: SizeConfig.safeBlockHorizontal * 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 4)
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(productData.imageUrl),
                                  fit: BoxFit.cover)),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          productData.name,
                          style: CusTextStyle.itemText.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 22),
                        ),
                        VerticalSeparator(height: .5),
                        Text(
                          productData.category,
                          style: CusTextStyle.itemText.copyWith(
                              color: Color(0xff979797),
                              fontWeight: FontWeight.w700),
                        ),
                        VerticalSeparator(height: 2),
                        Visibility(
                          visible: productData.priceSale !=
                              productData.priceOriginal,
                          replacement: Text(
                            CurrencyFormat.convertToIdr(
                                productData.priceOriginal, 0),
                            style: CusTextStyle.itemText,
                          ),
                          child: RichText(
                              text: TextSpan(
                                  text: CurrencyFormat.convertToIdr(
                                      productData.priceSale == 0
                                          ? productData.priceOriginal
                                          : productData.priceSale,
                                      0),
                                  style: CusTextStyle.itemText,
                                  children: [
                                TextSpan(text: '   '),
                                TextSpan(
                                  text:
                                      '${productData.priceSale == 0 ? '' : CurrencyFormat.convertToIdr(productData.priceOriginal, 0)}',
                                  style: CusTextStyle.itemText.copyWith(
                                      color: CusColor.disable,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: CusColor.disable),
                                )
                              ])),
                        ),
                        VerticalSeparator(height: 2),
                        Row(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (index > 1) {
                                        index--;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.remove)),
                            ),
                            HorizontalSeparator(width: 1),
                            Text(index.toString()),
                            HorizontalSeparator(width: 1),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      index++;
                                    });
                                  },
                                  child: Icon(Icons.add)),
                            ),
                            HorizontalSeparator(width: 3),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  SharedPreferencesManager pref =
                                      locator<SharedPreferencesManager>();
                                  bool isLogin = pref.getBool(
                                          SharedPreferencesManager.keyAuth) ??
                                      false;
                                  if (isLogin) {
                                    Map<String, dynamic> body = {
                                      'cartData': [
                                        {
                                          'productId': productData.id,
                                          'qty': index,
                                          'additionalNote': additionalCont.text
                                        }
                                      ]
                                    };
                                    var model = await addToCart(body);
                                    if (model.errors != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Added to Cart')));
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
                                                  Navigator.pushNamed(
                                                      context, '/account');
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
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                ),
                              ),
                            )
                          ],
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Catatan Tambahan',
                          style: CusTextStyle.itemText.copyWith(fontSize: 16),
                        ),
                        VerticalSeparator(height: 1),
                        TextFormField(
                          controller: additionalCont,
                          decoration: InputDecoration(
                              hintText: 'Tambahkan catatan tambahan',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Color(0xffE1E1E1))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Color(0xffE1E1E1)))),
                          maxLines: 3,
                          minLines: 3,
                        ),
                        VerticalSeparator(height: 3),
                        Text(
                          'Produk Detail dan Deskripsi Produk',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        VerticalSeparator(height: 1),
                        Text(
                            '${productData.productDetail}\n\n${productData.description}',
                            style:
                                CusTextStyle.bodyText.copyWith(fontSize: 14)),
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       showDesc = true;
                        //     });
                        //   },
                        //   child: Visibility(
                        //     visible: showDesc,
                        //     replacement: Text(
                        //       '${productData.productDetail}\n\n${productData.description}',
                        //       style:
                        //           CusTextStyle.bodyText.copyWith(fontSize: 14),
                        //       maxLines: 5,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //     child: Text(
                        //       '${productData.productDetail}\n\n${productData.description}',
                        //       style:
                        //           CusTextStyle.bodyText.copyWith(fontSize: 14),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )),
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
