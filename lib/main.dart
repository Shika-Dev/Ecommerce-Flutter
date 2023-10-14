import 'dart:async';

import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/firebase_options.dart';
import 'package:ecom_web_flutter/gen/assets.gen.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/pages/account_page.dart';
import 'package:ecom_web_flutter/pages/calculator_page.dart';
import 'package:ecom_web_flutter/pages/cart_page.dart';
import 'package:ecom_web_flutter/pages/shop_page.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/currency_format.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/auth.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'api_repository/models/models.dart';

void main() async {
  await setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metronome SoundSystem',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/account': (context) => const AccountPage(),
        '/calc': (context) => const Calculator(),
        '/shop': (context) => const ShopPage(
              category: '',
            ),
        '/cart': (context) => const CartPage()
      },
      theme: ThemeData(fontFamily: 'JosefinSans'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool mouseHover = false;
  int _currentPage = 0;
  int _currentCatPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  PageController _catController = PageController(initialPage: 0);
  ScrollController _mainListView = ScrollController();

  @override
  void initState() {
    silentSignIn();
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      return setState(() {
        if (_currentPage < 3) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
    Timer.periodic(Duration(seconds: 15), (Timer timer) {
      return setState(() {
        if (_currentCatPage < 3) {
          _currentCatPage++;
        } else {
          _currentCatPage = 0;
        }
        if (_catController.hasClients) {
          _catController.animateToPage(
            _currentCatPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _catController.dispose();
    _mainListView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: NavDrawer(
        index: 0,
      ),
      body: FutureBuilder(
          future: fetchFeaturedProduct(),
          builder: (context, model) {
            if (model.hasData) {
              var list = model.data!.data!;
              return LayoutBuilder(
                builder: (context, constraint) {
                  if (constraint.maxWidth > 600 && constraint.maxWidth < 1200)
                    return mediumLayout(list);
                  else if (constraint.maxWidth > 1200)
                    return largeLayout(list);
                  else
                    return smallLayout(list);
                },
              );
            }
            return SizedBox();
          }),
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
    );
  }

  Widget largeLayout(List<ProductData> list) {
    int page = (list.length / 4).floor();
    List<Widget> listWidget = List.empty(growable: true);
    for (int counter = 0, i = 0; i < page; i++) {
      listWidget.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OnHoverProduct(
            imageUrl: list[counter].imageUrl,
            code: list[counter].id.toString(),
            title: list[counter].name,
            price: CurrencyFormat.convertToIdr(list[counter].priceOriginal, 0),
          ),
          OnHoverProduct(
            imageUrl: list[counter].imageUrl,
            code: list[counter + 1].id.toString(),
            title: list[counter + 1].name,
            price:
                CurrencyFormat.convertToIdr(list[counter + 1].priceOriginal, 0),
          ),
          OnHoverProduct(
            imageUrl: list[counter].imageUrl,
            code: list[counter + 2].id.toString(),
            title: list[counter + 2].name,
            price:
                CurrencyFormat.convertToIdr(list[counter + 2].priceOriginal, 0),
          ),
          OnHoverProduct(
            imageUrl: list[counter].imageUrl,
            code: list[counter + 3].id.toString(),
            title: list[counter + 3].name,
            price:
                CurrencyFormat.convertToIdr(list[counter + 3].priceOriginal, 0),
          ),
        ],
      ));
      counter += 4;
    }
    return Column(
      children: <Widget>[
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          index: 0,
          scaffoldKey: _scaffoldKey,
        ),
        Expanded(
            child: Container(
          color: Colors.white,
          child: ListView(
            controller: _mainListView,
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 10,
                right: SizeConfig.safeBlockHorizontal * 10,
                top: 20),
            children: [
              list.isNotEmpty
                  ? Visibility(
                      visible: list.length <= 4,
                      replacement: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: list[0].priceSale != 0,
                            replacement: item(
                                list[0].name,
                                CurrencyFormat.convertToIdr(
                                    list[0].priceOriginal, 0),
                                null,
                                list[0].id,
                                url: list[0].imageUrl),
                            child: item(
                                list[0].name,
                                CurrencyFormat.convertToIdr(
                                    list[0].priceSale, 0),
                                CurrencyFormat.convertToIdr(
                                    list[0].priceOriginal, 0),
                                list[0].id,
                                url: list[0].imageUrl),
                          ),
                          Visibility(
                            visible: list[1].priceSale != 0,
                            replacement: item(
                                list[1].name,
                                CurrencyFormat.convertToIdr(
                                    list[1].priceOriginal, 0),
                                null,
                                list[1].id,
                                url: list[1].imageUrl),
                            child: item(
                                list[1].name,
                                CurrencyFormat.convertToIdr(
                                    list[1].priceSale, 0),
                                CurrencyFormat.convertToIdr(
                                    list[1].priceOriginal, 0),
                                list[1].id,
                                url: list[1].imageUrl),
                          ),
                          Visibility(
                            visible: list[2].priceSale != 0,
                            replacement: item(
                                list[2].name,
                                CurrencyFormat.convertToIdr(
                                    list[2].priceOriginal, 0),
                                null,
                                list[2].id,
                                url: list[2].imageUrl),
                            child: item(
                                list[2].name,
                                CurrencyFormat.convertToIdr(
                                    list[2].priceSale, 0),
                                CurrencyFormat.convertToIdr(
                                    list[2].priceOriginal, 0),
                                list[2].id,
                                url: list[2].imageUrl),
                          ),
                          Visibility(
                            visible: list[3].priceSale != 0,
                            replacement: item(
                                list[3].name,
                                CurrencyFormat.convertToIdr(
                                    list[3].priceOriginal, 0),
                                null,
                                list[3].id,
                                url: list[3].imageUrl),
                            child: item(
                                list[3].name,
                                CurrencyFormat.convertToIdr(
                                    list[3].priceSale, 0),
                                CurrencyFormat.convertToIdr(
                                    list[3].priceOriginal, 0),
                                list[3].id,
                                url: list[3].imageUrl),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...list.map((e) => e.priceSale == 0
                              ? item(
                                  e.name,
                                  CurrencyFormat.convertToIdr(
                                      e.priceOriginal, 0),
                                  null,
                                  e.id,
                                  url: e.imageUrl)
                              : item(
                                  e.name,
                                  CurrencyFormat.convertToIdr(e.priceSale, 0),
                                  CurrencyFormat.convertToIdr(
                                      e.priceOriginal, 0),
                                  e.id,
                                  url: e.imageUrl))
                        ],
                      ),
                    )
                  : SizedBox(),
              VerticalSeparator(height: 5),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 25,
                      padding: EdgeInsets.only(top: 34, left: 25),
                      decoration: BoxDecoration(
                          color: Color(0xffFFF6FB),
                          boxShadow: [CusBoxShadow.shadow]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          VerticalSeparator(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                Assets.images.imgClock.path,
                                width: SizeConfig.safeBlockHorizontal * 10,
                                fit: BoxFit.fitWidth,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 25,
                      padding: EdgeInsets.only(top: 34, left: 25),
                      decoration: BoxDecoration(
                          color: Color(0xffEEEFFB),
                          boxShadow: [CusBoxShadow.shadow]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '23% off in all products',
                            style: CusTextStyle.itemText
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          VerticalSeparator(height: 1),
                          Text(
                            'View Collection',
                            style: CusTextStyle.itemText.copyWith(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: CusColor.green,
                                decoration: TextDecoration.underline,
                                decorationColor: CusColor.green),
                          ),
                          VerticalSeparator(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                Assets.images.imgWardrobe.path,
                                width: SizeConfig.safeBlockHorizontal * 20,
                                fit: BoxFit.fitWidth,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              color: Color(0xffF5F6F8),
                              width: SizeConfig.safeBlockHorizontal * 7,
                              height: SizeConfig.safeBlockVertical * 9,
                            ),
                            HorizontalSeparator(width: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Executive Seat chair',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                VerticalSeparator(height: 1),
                                Text(
                                  '\$32.00',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: CusColor.blue),
                                )
                              ],
                            )
                          ],
                        ),
                        VerticalSeparator(height: 1),
                        Row(
                          children: [
                            Container(
                              color: Color(0xffF5F6F8),
                              width: SizeConfig.safeBlockHorizontal * 7,
                              height: SizeConfig.safeBlockVertical * 9,
                            ),
                            HorizontalSeparator(width: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Executive Seat chair',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                VerticalSeparator(height: 1),
                                Text(
                                  '\$32.00',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: CusColor.blue),
                                )
                              ],
                            )
                          ],
                        ),
                        VerticalSeparator(height: 1),
                        Row(
                          children: [
                            Container(
                              color: Color(0xffF5F6F8),
                              width: SizeConfig.safeBlockHorizontal * 7,
                              height: SizeConfig.safeBlockVertical * 9,
                            ),
                            HorizontalSeparator(width: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Executive Seat chair',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                VerticalSeparator(height: 1),
                                Text(
                                  '\$32.00',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: CusColor.blue),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'What We Offer!',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icDelivery.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pengiriman Termasuk',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Harga di situs web kami mencakup pengiriman di DKI Jakarta; biaya tambahan berlaku untuk pengiriman luar kota',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCashback.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Negosiasi Harga',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Hubungi Admin Metronom Sound System melalui WhatsApp atau E-mail untuk negosiasi harga pesanan Anda',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icPremium.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Jaminan Kerusakan',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Kami menjamin setiap barang kami berfungsi dengan baik, dan kami ganti jika rusak sebelum acara anda mulai',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCall24.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pembayaran Mudah',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Konfirmasi pembayaran tidak diperlukan karena sistem pembayaran terintegrasi otomatis dengan kami',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'Featured Products',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 40,
                child: PageView(
                  pageSnapping: false,
                  controller: _pageController,
                  children: [...listWidget],
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: SizedBox(
                  height: 4,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentPage = index;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? Color(0xffFB2E86)
                                  : Color(0xffFEBAD7),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: page,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'Kategori Terpopuler',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 37,
                child: PageView(
                  pageSnapping: false,
                  controller: _catController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        category_item('Kursi'),
                        category_item('Sofa'),
                        category_item('Meja'),
                        category_item('Sound System'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        category_item('Kursi'),
                        category_item('Sofa'),
                        category_item('Meja'),
                        category_item('Sound System'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        category_item('Kursi'),
                        category_item('Sofa'),
                        category_item('Meja'),
                        category_item('Sound System'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        category_item('Kursi'),
                        category_item('Sofa'),
                        category_item('Meja'),
                        category_item('Sound System'),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalSeparator(height: 3),
              Center(
                child: SizedBox(
                  height: 10,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentCatPage = index;
                        _catController.animateToPage(
                          _currentCatPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CusColor.green),
                            color: index == _currentCatPage
                                ? CusColor.green
                                : Colors.white,
                          )),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: 4,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 35,
                child: OverflowBox(
                  maxWidth: SizeConfig.safeBlockHorizontal * 100,
                  minWidth: SizeConfig.safeBlockHorizontal * 100,
                  child: Footer(),
                ),
              )
            ],
          ),
        )),
      ],
    );
  }

  Widget mediumLayout(List<ProductData> list) {
    int page = (list.length / 4).floor();
    List<Widget> listWidget = List.empty(growable: true);
    for (int counter = 0, i = 0; i < page; i++) {
      listWidget.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OnHoverProduct(
                imageUrl: list[counter].imageUrl,
                code: list[counter].id.toString(),
                title: list[counter].name,
                width: SizeConfig.safeBlockHorizontal * 35,
                price:
                    CurrencyFormat.convertToIdr(list[counter].priceOriginal, 0),
              ),
              OnHoverProduct(
                imageUrl: list[counter].imageUrl,
                code: list[counter + 1].id.toString(),
                title: list[counter + 1].name,
                width: SizeConfig.safeBlockHorizontal * 35,
                price: CurrencyFormat.convertToIdr(
                    list[counter + 1].priceOriginal, 0),
              ),
            ],
          ),
          VerticalSeparator(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OnHoverProduct(
                imageUrl: list[counter].imageUrl,
                code: list[counter + 2].id.toString(),
                title: list[counter + 2].name,
                width: SizeConfig.safeBlockHorizontal * 35,
                price: CurrencyFormat.convertToIdr(
                    list[counter + 2].priceOriginal, 0),
              ),
              OnHoverProduct(
                imageUrl: list[counter].imageUrl,
                code: list[counter + 3].id.toString(),
                title: list[counter + 3].name,
                width: SizeConfig.safeBlockHorizontal * 35,
                price: CurrencyFormat.convertToIdr(
                    list[counter + 3].priceOriginal, 0),
              ),
            ],
          ),
        ],
      ));
      counter += 4;
    }
    return Column(
      children: <Widget>[
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          index: 0,
          scaffoldKey: _scaffoldKey,
        ),
        Expanded(
            child: Container(
          color: Colors.white,
          child: ListView(
            controller: _mainListView,
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 10,
                right: SizeConfig.safeBlockHorizontal * 10,
                top: 20),
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: SizeConfig.safeBlockVertical * 5,
                    crossAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                    crossAxisCount: 2),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Visibility(
                  visible: list[index].priceSale != 0,
                  replacement: item(
                      list[index].name,
                      CurrencyFormat.convertToIdr(list[index].priceOriginal, 0),
                      null,
                      list[index].id,
                      url: list[index].imageUrl,
                      width: SizeConfig.safeBlockHorizontal * 25),
                  child: item(
                      list[index].name,
                      CurrencyFormat.convertToIdr(list[index].priceSale, 0),
                      CurrencyFormat.convertToIdr(list[index].priceOriginal, 0),
                      list[index].id,
                      url: list[index].imageUrl,
                      width: SizeConfig.safeBlockHorizontal * 25),
                ),
                itemCount: list.length > 4 ? 4 : list.length,
              ),
              VerticalSeparator(height: 5),
              Container(
                width: SizeConfig.safeBlockHorizontal * 30,
                padding: EdgeInsets.only(top: 34, left: 25),
                decoration: BoxDecoration(
                    color: Color(0xffFFF6FB), boxShadow: [CusBoxShadow.shadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    VerticalSeparator(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          Assets.images.imgClock.path,
                          width: SizeConfig.safeBlockHorizontal * 15,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    )
                  ],
                ),
              ),
              VerticalSeparator(height: 2),
              Container(
                width: SizeConfig.safeBlockHorizontal * 30,
                padding: EdgeInsets.only(top: 34, left: 25),
                decoration: BoxDecoration(
                    color: Color(0xffEEEFFB), boxShadow: [CusBoxShadow.shadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '23% off in all products',
                      style: CusTextStyle.itemText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    VerticalSeparator(height: 1),
                    Text(
                      'View Collection',
                      style: CusTextStyle.itemText.copyWith(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          color: CusColor.green,
                          decoration: TextDecoration.underline,
                          decorationColor: CusColor.green),
                    ),
                    VerticalSeparator(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          Assets.images.imgWardrobe.path,
                          width: SizeConfig.safeBlockHorizontal * 25,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    )
                  ],
                ),
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'What We Offer!',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icDelivery.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pengiriman Termasuk',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Harga di situs web kami mencakup pengiriman di DKI Jakarta; biaya tambahan berlaku untuk pengiriman luar kota',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCashback.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Negosiasi Harga',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Hubungi Admin Metronom Sound System melalui WhatsApp atau E-mail untuk negosiasi harga pesanan Anda',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icPremium.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Jaminan Kerusakan',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Kami menjamin setiap barang kami berfungsi dengan baik, dan kami ganti jika rusak sebelum acara anda mulai',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCall24.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pembayaran Mudah',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Konfirmasi pembayaran tidak diperlukan karena sistem pembayaran terintegrasi otomatis dengan kami',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'Featured Products',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 82,
                child: PageView(
                  pageSnapping: false,
                  controller: _pageController,
                  children: [...listWidget],
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: SizedBox(
                  height: 4,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentPage = index;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? Color(0xffFB2E86)
                                  : Color(0xffFEBAD7),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: page,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockHorizontal * 72,
                child: PageView(
                  pageSnapping: false,
                  controller: _catController,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Kursi',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sofa',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                        VerticalSeparator(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Meja',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sound System',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Kursi',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sofa',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                        VerticalSeparator(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Meja',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sound System',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Kursi',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sofa',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                        VerticalSeparator(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Meja',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sound System',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Kursi',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sofa',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                        VerticalSeparator(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            category_item('Meja',
                                width: SizeConfig.safeBlockHorizontal * 25),
                            HorizontalSeparator(width: 20),
                            category_item('Sound System',
                                width: SizeConfig.safeBlockHorizontal * 25),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  height: 10,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentCatPage = index;
                        _catController.animateToPage(
                          _currentCatPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CusColor.green),
                            color: index == _currentCatPage
                                ? CusColor.green
                                : Colors.white,
                          )),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: 4,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 35,
                child: OverflowBox(
                  maxWidth: SizeConfig.safeBlockHorizontal * 100,
                  minWidth: SizeConfig.safeBlockHorizontal * 100,
                  child: Footer(),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget smallLayout(List<ProductData> list) {
    int page = list.length > 4 ? 4 : list.length;
    List<Widget> listWidget = List.empty(growable: true);
    for (int i = 0; i < page; i++) {
      listWidget.add(OnHoverProduct(
        imageUrl: list[i].imageUrl,
        code: list[i].id.toString(),
        title: list[i].name,
        price: CurrencyFormat.convertToIdr(list[i].priceOriginal, 0),
        width: SizeConfig.safeBlockHorizontal * 70,
      ));
    }
    return Column(
      children: <Widget>[
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          index: 0,
          scaffoldKey: _scaffoldKey,
        ),
        Expanded(
            child: Container(
          color: Colors.white,
          child: ListView(
            controller: _mainListView,
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 10,
                right: SizeConfig.safeBlockHorizontal * 10,
                top: 20),
            children: [
              list.isNotEmpty
                  ? Visibility(
                      visible: list.length >= 1,
                      child: Visibility(
                        visible: list[0].priceSale != 0,
                        replacement: item(
                            list[0].name,
                            CurrencyFormat.convertToIdr(
                                list[0].priceOriginal, 0),
                            null,
                            list[0].id,
                            url: list[0].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                        child: item(
                            list[0].name,
                            CurrencyFormat.convertToIdr(list[0].priceSale, 0),
                            CurrencyFormat.convertToIdr(
                                list[0].priceOriginal, 0),
                            list[0].id,
                            url: list[0].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                      ),
                    )
                  : SizedBox(),
              VerticalSeparator(height: 2),
              list.isNotEmpty
                  ? Visibility(
                      visible: list.length >= 2,
                      child: Visibility(
                        visible: list[1].priceSale != 0,
                        replacement: item(
                            list[1].name,
                            CurrencyFormat.convertToIdr(
                                list[1].priceOriginal, 0),
                            null,
                            list[1].id,
                            url: list[1].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                        child: item(
                            list[1].name,
                            CurrencyFormat.convertToIdr(list[1].priceSale, 0),
                            CurrencyFormat.convertToIdr(
                                list[1].priceOriginal, 0),
                            list[1].id,
                            url: list[1].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                      ),
                    )
                  : SizedBox(),
              VerticalSeparator(height: 2),
              list.isNotEmpty
                  ? Visibility(
                      visible: list.length >= 3,
                      child: Visibility(
                        visible: list[2].priceSale != 0,
                        replacement: item(
                            list[2].name,
                            CurrencyFormat.convertToIdr(
                                list[2].priceOriginal, 0),
                            null,
                            list[2].id,
                            url: list[2].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                        child: item(
                            list[2].name,
                            CurrencyFormat.convertToIdr(list[2].priceSale, 0),
                            CurrencyFormat.convertToIdr(
                                list[2].priceOriginal, 0),
                            list[2].id,
                            url: list[2].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                      ),
                    )
                  : SizedBox(),
              VerticalSeparator(height: 2),
              list.isNotEmpty
                  ? Visibility(
                      visible: list.length >= 4,
                      child: Visibility(
                        visible: list[3].priceSale != 0,
                        replacement: item(
                            list[3].name,
                            CurrencyFormat.convertToIdr(
                                list[3].priceOriginal, 0),
                            null,
                            list[3].id,
                            url: list[3].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                        child: item(
                            list[3].name,
                            CurrencyFormat.convertToIdr(list[3].priceSale, 0),
                            CurrencyFormat.convertToIdr(
                                list[3].priceOriginal, 0),
                            list[3].id,
                            url: list[3].imageUrl,
                            width: SizeConfig.safeBlockHorizontal * 70),
                      ),
                    )
                  : SizedBox(),
              VerticalSeparator(height: 5),
              Container(
                width: SizeConfig.safeBlockHorizontal * 30,
                padding: EdgeInsets.only(top: 34, left: 25),
                decoration: BoxDecoration(
                    color: Color(0xffFFF6FB), boxShadow: [CusBoxShadow.shadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    VerticalSeparator(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          Assets.images.imgClock.path,
                          width: SizeConfig.safeBlockHorizontal * 15,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    )
                  ],
                ),
              ),
              VerticalSeparator(height: 2),
              Container(
                width: SizeConfig.safeBlockHorizontal * 30,
                padding: EdgeInsets.only(top: 34, left: 25),
                decoration: BoxDecoration(
                    color: Color(0xffEEEFFB), boxShadow: [CusBoxShadow.shadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '23% off in all products',
                      style: CusTextStyle.itemText
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    VerticalSeparator(height: 1),
                    Text(
                      'View Collection',
                      style: CusTextStyle.itemText.copyWith(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          color: CusColor.green,
                          decoration: TextDecoration.underline,
                          decorationColor: CusColor.green),
                    ),
                    VerticalSeparator(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          Assets.images.imgWardrobe.path,
                          width: SizeConfig.safeBlockHorizontal * 25,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    )
                  ],
                ),
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 20,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 20,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                children: [
                  Container(
                    color: Color(0xffF5F6F8),
                    width: SizeConfig.safeBlockHorizontal * 20,
                    height: SizeConfig.safeBlockVertical * 17,
                  ),
                  HorizontalSeparator(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Executive Seat chair',
                        style: CusTextStyle.itemText
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      VerticalSeparator(height: 1),
                      Text(
                        '\$32.00',
                        style: CusTextStyle.itemText.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: CusColor.blue),
                      )
                    ],
                  )
                ],
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'What We Offer!',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icDelivery.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pengiriman Termasuk',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Harga di situs web kami mencakup pengiriman di DKI Jakarta; biaya tambahan berlaku untuk pengiriman luar kota',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCashback.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Negosiasi Harga',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Hubungi Admin Metronom Sound System melalui WhatsApp atau E-mail untuk negosiasi harga pesanan Anda',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VerticalSeparator(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icPremium.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        HorizontalSeparator(width: 2),
                        Text(
                          'Jaminan Kerusakan',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Kami menjamin setiap barang kami berfungsi dengan baik, dan kami ganti jika rusak sebelum acara anda mulai',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  VerticalSeparator(height: 2),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 45),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: [CusBoxShadow.shadow]),
                    child: Column(
                      children: [
                        Image.asset(Assets.images.icCall24.path,
                            width: SizeConfig.safeBlockHorizontal * 5,
                            fit: BoxFit.fitWidth),
                        VerticalSeparator(height: 2),
                        Text(
                          'Pembayaran Mudah',
                          style: CusTextStyle.itemText.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        VerticalSeparator(height: 2),
                        Text(
                          'Konfirmasi pembayaran tidak diperlukan karena sistem pembayaran terintegrasi otomatis dengan kami',
                          textAlign: TextAlign.center,
                          style: CusTextStyle.itemText.copyWith(
                              color: CusColor.disable,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VerticalSeparator(height: 10),
              Center(
                child: Text(
                  'Featured Products',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockHorizontal * 70 +
                    SizeConfig.safeBlockVertical * 10,
                child: PageView(
                  pageSnapping: false,
                  controller: _pageController,
                  children: [...listWidget],
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: SizedBox(
                  height: 4,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentPage = index;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? Color(0xffFB2E86)
                                  : Color(0xffFEBAD7),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: page,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 40,
                child: PageView(
                  pageSnapping: false,
                  controller: _catController,
                  children: [
                    category_item('Kursi',
                        width: SizeConfig.safeBlockHorizontal * 50),
                    category_item('Sofa',
                        width: SizeConfig.safeBlockHorizontal * 50),
                    category_item('Meja',
                        width: SizeConfig.safeBlockHorizontal * 50),
                    category_item('Sound System',
                        width: SizeConfig.safeBlockHorizontal * 50),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  height: 10,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => setState(() {
                        _currentCatPage = index;
                        _catController.animateToPage(
                          _currentCatPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                      }),
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CusColor.green),
                            color: index == _currentCatPage
                                ? CusColor.green
                                : Colors.white,
                          )),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: 4,
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 70,
                child: OverflowBox(
                  maxHeight: SizeConfig.safeBlockVertical * 70,
                  maxWidth: SizeConfig.safeBlockHorizontal * 100,
                  minWidth: SizeConfig.safeBlockHorizontal * 100,
                  child: Footer(),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget item(String title, String price, String? oldPrice, int id,
      {double? width, required String url}) {
    return GestureDetector(
      onTap: () async {
        SharedPreferencesManager pref = locator<SharedPreferencesManager>();
        bool isLogin = pref.getBool(SharedPreferencesManager.keyAuth) ?? false;
        if (isLogin) {
          Map<String, dynamic> body = {
            'cartData': [
              {'productId': id, 'qty': 1, 'additionalNote': ''}
            ]
          };
          var model = await addToCart(body);
          if (model.errors != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Added to Cart')));
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
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 33),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [CusBoxShadow.shadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width ?? SizeConfig.safeBlockHorizontal * 15,
              height: width ?? SizeConfig.safeBlockHorizontal * 15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.cover)),
            ),
            VerticalSeparator(height: 1),
            Text(title,
                style: CusTextStyle.itemText
                    .copyWith(fontWeight: FontWeight.w700)),
            VerticalSeparator(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(price,
                    style: CusTextStyle.itemText.copyWith(fontSize: 14)),
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
      ),
    );
  }

  Widget category_item(String title, {double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width ?? SizeConfig.safeBlockHorizontal * 15,
          height: width ?? SizeConfig.safeBlockHorizontal * 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF5F6F8),
            boxShadow: [CusBoxShadow.shadow],
          ),
        ),
        VerticalSeparator(height: 2),
        Text(title, style: CusTextStyle.itemText.copyWith(fontSize: 20)),
      ],
    );
  }
}

class OnHoverProduct extends StatefulWidget {
  final String title;
  final String price;
  final String code;
  final double? width;
  final String imageUrl;
  const OnHoverProduct(
      {Key? key,
      required this.code,
      required this.title,
      required this.price,
      required this.imageUrl,
      this.width})
      : super(key: key);

  @override
  State<OnHoverProduct> createState() => _OnHoverProductState();
}

class _OnHoverProductState extends State<OnHoverProduct> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        onHover = true;
      }),
      onExit: (event) => setState(() {
        onHover = false;
      }),
      child: Container(
        padding: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: onHover ? Color(0xff2F1AC4) : Colors.white,
          boxShadow: [CusBoxShadow.shadow],
        ),
        child: Column(
          children: [
            Container(
              width: widget.width ?? SizeConfig.safeBlockHorizontal * 15,
              height: widget.width ?? SizeConfig.safeBlockHorizontal * 15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.imageUrl), fit: BoxFit.cover)),
              padding: EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: onHover,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffEEEFFB),
                                boxShadow: [CusBoxShadow.shadow]),
                            child: Center(
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xff2F1AC4),
                                size: 16,
                              ),
                            ),
                          ),
                          HorizontalSeparator(width: 1),
                          Icon(
                            Icons.favorite_border_rounded,
                            color: Color(0xff1DB4E7),
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    replacement: SizedBox(height: 30),
                  )
                ],
              ),
            ),
            VerticalSeparator(height: 1),
            Text(widget.title,
                style: CusTextStyle.itemText.copyWith(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    color: onHover ? Colors.white : CusColor.black,
                    fontSize: 18)),
            // VerticalSeparator(height: 2),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       height: 4,
            //       width: 14,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: CusColor.green,
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     Container(
            //       height: 4,
            //       width: 14,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: CusColor.red,
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     Container(
            //       height: 4,
            //       width: 14,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: onHover ? Color(0xffFFEAC1) : CusColor.blue,
            //       ),
            //     ),
            //   ],
            // ),
            // VerticalSeparator(height: 2),
            // Text('Code - ${widget.code}',
            //     style: CusTextStyle.itemText.copyWith(
            //       fontSize: 14,
            //       color: onHover ? Colors.white : CusColor.blue,
            //     )),
            VerticalSeparator(height: 1),
            Text(widget.price,
                style: CusTextStyle.itemText.copyWith(
                  fontSize: 14,
                  color: onHover ? Colors.white : CusColor.blue,
                )),
          ],
        ),
      ),
    );
  }
}
