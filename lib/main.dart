import 'dart:async';

import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/bloc/product_bloc/product_bloc.dart';
import 'package:ecom_web_flutter/firebase_options.dart';
import 'package:ecom_web_flutter/gen/assets.gen.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/currency_format.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/auth.dart';
import 'package:ecom_web_flutter/utils/router.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_repository/models/models.dart';

void main() async {
  await setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: MaterialApp.router(
        title: 'Metronome Soundsystem',
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        theme: ThemeData(fontFamily: 'JosefinSans'),
      ),
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
  // int _currentCatPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  // PageController _catController = PageController(initialPage: 0);
  ScrollController _mainListView = ScrollController();
  ScrollController _categoryListView = ScrollController();

  late Timer timer;

  List<LinearGradient> listGradientColor = const [
    LinearGradient(colors: [
      Color(0xff0a23c7),
      Color(0xff6b85ee),
    ], begin: Alignment.topRight, end: Alignment.bottomLeft),
    LinearGradient(colors: [
      Color(0xffc70a0a),
      Color(0xffee6b6b),
    ], begin: Alignment.topRight, end: Alignment.bottomLeft),
    LinearGradient(colors: [
      Color(0xffc73c0a),
      Color(0xffee8a6b),
    ], begin: Alignment.topRight, end: Alignment.bottomLeft),
    LinearGradient(colors: [
      Color(0xff0ac762),
      Color(0xff6bee94),
    ], begin: Alignment.topRight, end: Alignment.bottomLeft),
  ];

  @override
  void initState() {
    silentSignIn();
    context.read<ProductBloc>().add(GetHomepageData());
    timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
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
    // Timer.periodic(Duration(seconds: 15), (Timer timer) {
    //   return setState(() {
    //     if (_currentCatPage < 3) {
    //       _currentCatPage++;
    //     } else {
    //       _currentCatPage = 0;
    //     }
    //     if (_catController.hasClients) {
    //       _catController.animateToPage(
    //         _currentCatPage,
    //         duration: Duration(milliseconds: 350),
    //         curve: Curves.easeIn,
    //       );
    //     }
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    // _catController.dispose();
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
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if (state.status == ProductStatus.categorySuccess) {
          var list = state.productList!;
          return LayoutBuilder(
            builder: (context, constraint) {
              if (constraint.maxWidth > 600 && constraint.maxWidth < 1200)
                return mediumLayout(list, state.categoryList!);
              else if (constraint.maxWidth > 1200)
                return largeLayout(list, state.categoryList!);
              else
                return smallLayout(list, state.categoryList!);
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

  Widget categoryCard(String category, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go('/shop?category=${Uri.encodeComponent(category)}');
        },
        child: Container(
          height: 70,
          width: 210,
          decoration: BoxDecoration(
              gradient: listGradientColor[index + 1 > 4 ? index % 4 : index],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10)
              ]),
          child: Center(
            child: Text(
              category,
              style: CusTextStyle.bodyText.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget largeLayout(List<ProductData> list, List<String> categoryList) {
    List<ProductData> listFeaturedProduct = List.empty(growable: true);
    if (list.length < 4) {
      listFeaturedProduct = List.from(list);
    } else {
      for (int x = 0; x < 4; x++) {
        listFeaturedProduct.add(list[x]);
      }
    }
    int page = (list.length / 4).floor();
    List<Widget> listWidget = List.empty(growable: true);
    for (int counter = 0, i = 0; i < page; i++) {
      listWidget.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          productItem(list[counter], false),
          productItem(list[counter + 1], false),
          productItem(list[counter + 2], false),
          productItem(list[counter + 3], false)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...listFeaturedProduct.map((e) => productItem(e, false))
                ],
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                height: 80,
                child: Scrollbar(
                  controller: _categoryListView,
                  child: ListView.separated(
                      controller: _categoryListView,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return categoryCard(categoryList[index], index);
                      },
                      separatorBuilder: (context, index) =>
                          HorizontalSeparator(width: 3),
                      itemCount: categoryList.length),
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: Text(
                  'Kenapa Metronom Soundsystem?',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          color: Colors.black.withOpacity(.1))
                    ]),
                child: Row(
                  children: [
                    SizedBox(
                      width: ((SizeConfig.safeBlockHorizontal * 80) - 48) / 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.images.icDelivery.path,
                              width: SizeConfig.safeBlockHorizontal * 3,
                              fit: BoxFit.fitWidth),
                          HorizontalSeparator(width: 2),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                        5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Solusi Satu Pintu',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Kemudahan Pembuatan Acara',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: ((SizeConfig.safeBlockHorizontal * 80) - 48) / 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.images.icCall24.path,
                              width: SizeConfig.safeBlockHorizontal * 3,
                              fit: BoxFit.fitWidth),
                          HorizontalSeparator(width: 2),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                        5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Layanan 24 Jam',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Dukungan teknis setiap saat',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: ((SizeConfig.safeBlockHorizontal * 80) - 48) / 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.images.icPremium.path,
                              width: SizeConfig.safeBlockHorizontal * 3,
                              fit: BoxFit.fitWidth),
                          HorizontalSeparator(width: 2),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                        5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jaminan Pelayanan Terbaik',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Penggunaan barang dan SDM terbaik',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: ((SizeConfig.safeBlockHorizontal * 80) - 48) / 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.images.icCashback.path,
                              width: SizeConfig.safeBlockHorizontal * 3,
                              fit: BoxFit.fitWidth),
                          HorizontalSeparator(width: 2),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                        5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kemudahan Pembayaran',
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Sistem pembayaran terintegrasi otomatis',
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: Text(
                  'Paling Sering Dipesan',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 40,
                child: PageView(
                  pageSnapping: true,
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
                                  ? CusColor.black
                                  : CusColor.black.withOpacity(.6),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: page,
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.safeBlockVertical * 50,
                child: OverflowBox(
                  minWidth: SizeConfig.screenWidth,
                  maxWidth: SizeConfig.screenWidth,
                  maxHeight: SizeConfig.safeBlockVertical * 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.black87, Colors.black26])),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Serahkan keperluan acara anda kepada kami, saatnya anda fokus pada pertumbuhan bisnis',
                                style: CusTextStyle.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Colors.white),
                              ),
                              VerticalSeparator(height: 1),
                              Text(
                                  'Jadikan momen acara dengan memberikan pengalaman luar biasa untuk tim internal dan tamu undangan bersama Metronom Sound. Solusi pembuatan acara satu pintu, memberikan efisiensi dan harga yang terjangkau',
                                  style: CusTextStyle.bodyText
                                      .copyWith(color: Colors.white))
                            ],
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/recommendation_section.png',
                          width: SizeConfig.safeBlockHorizontal * 30,
                          fit: BoxFit.fitWidth,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
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

  Widget mediumLayout(List<ProductData> list, List<String> categoryList) {
    List<ProductData> listFeaturedProduct = List.empty(growable: true);
    if (list.length < 4) {
      listFeaturedProduct = List.from(list);
    } else {
      for (int x = 0; x < 4; x++) {
        listFeaturedProduct.add(list[x]);
      }
    }
    int page = (list.length / 4).floor();
    List<Widget> listWidget = List.empty(growable: true);
    for (int counter = 0, i = 0; i < page; i++) {
      listWidget.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              productItem(list[counter], false),
              productItem(list[counter + 1], false),
            ],
          ),
          VerticalSeparator(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              productItem(list[counter + 2], false),
              productItem(list[counter + 3], false)
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
                    // childAspectRatio: .9,
                    mainAxisSpacing: SizeConfig.safeBlockVertical * 5,
                    crossAxisSpacing: SizeConfig.safeBlockHorizontal * 5,
                    crossAxisCount: 2),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => SizedBox(
                    child: Center(
                        child: productItem(listFeaturedProduct[index], false))),
                itemCount: listFeaturedProduct.length,
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                height: 80,
                child: Scrollbar(
                  controller: _categoryListView,
                  child: ListView.separated(
                      controller: _categoryListView,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return categoryCard(categoryList[index], index);
                      },
                      separatorBuilder: (context, index) =>
                          HorizontalSeparator(width: 3),
                      itemCount: categoryList.length),
                ),
              ),
              VerticalSeparator(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          color: Colors.black.withOpacity(.1))
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: ((SizeConfig.safeBlockHorizontal * 80) - 48) /
                              2.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Assets.images.icDelivery.path,
                                  width: SizeConfig.safeBlockHorizontal * 3,
                                  fit: BoxFit.fitWidth),
                              HorizontalSeparator(width: 2),
                              SizedBox(
                                width: (((SizeConfig.safeBlockHorizontal * 80) -
                                            48) /
                                        2.5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Solusi Satu Pintu',
                                      style: CusTextStyle.itemText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    VerticalSeparator(height: .5),
                                    Text(
                                      'Kemudahan Pembuatan Acara',
                                      style: CusTextStyle.itemText
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: ((SizeConfig.safeBlockHorizontal * 80) - 48) /
                              2.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Assets.images.icCall24.path,
                                  width: SizeConfig.safeBlockHorizontal * 3,
                                  fit: BoxFit.fitWidth),
                              HorizontalSeparator(width: 2),
                              SizedBox(
                                width: (((SizeConfig.safeBlockHorizontal * 80) -
                                            48) /
                                        2.5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Layanan 24 Jam',
                                      style: CusTextStyle.itemText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    VerticalSeparator(height: .5),
                                    Text(
                                      'Dukungan teknis setiap saat',
                                      style: CusTextStyle.itemText
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    VerticalSeparator(height: 3),
                    Row(
                      children: [
                        SizedBox(
                          width: ((SizeConfig.safeBlockHorizontal * 80) - 48) /
                              2.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Assets.images.icPremium.path,
                                  width: SizeConfig.safeBlockHorizontal * 3,
                                  fit: BoxFit.fitWidth),
                              HorizontalSeparator(width: 2),
                              SizedBox(
                                width: (((SizeConfig.safeBlockHorizontal * 80) -
                                            48) /
                                        2.5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jaminan Pelayanan Terbaik',
                                      style: CusTextStyle.itemText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    VerticalSeparator(height: .5),
                                    Text(
                                      'Penggunaan barang dan SDM terbaik',
                                      style: CusTextStyle.itemText
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: ((SizeConfig.safeBlockHorizontal * 80) - 48) /
                              2.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Assets.images.icCashback.path,
                                  width: SizeConfig.safeBlockHorizontal * 3,
                                  fit: BoxFit.fitWidth),
                              HorizontalSeparator(width: 2),
                              SizedBox(
                                width: (((SizeConfig.safeBlockHorizontal * 80) -
                                            48) /
                                        2.5) -
                                    SizeConfig.safeBlockHorizontal * 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kemudahan Pembayaran',
                                      style: CusTextStyle.itemText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    VerticalSeparator(height: .5),
                                    Text(
                                      'Sistem pembayaran terintegrasi otomatis',
                                      style: CusTextStyle.itemText
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalSeparator(height: 5),
              Center(
                child: Text(
                  'Paling Sering Dipesan',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 60,
                child: PageView(
                  pageSnapping: true,
                  controller: _pageController,
                  children: [...listWidget],
                ),
              ),
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
                                  ? CusColor.black
                                  : CusColor.black.withOpacity(.6),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    separatorBuilder: (context, index) =>
                        HorizontalSeparator(width: 1),
                    itemCount: page,
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.safeBlockVertical * 35,
                child: OverflowBox(
                  minWidth: SizeConfig.screenWidth,
                  maxWidth: SizeConfig.screenWidth,
                  maxHeight: SizeConfig.safeBlockVertical * 35,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.black87, Colors.black26])),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal * 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Serahkan keperluan acara anda kepada kami, saatnya anda fokus pada pertumbuhan bisnis',
                                style: CusTextStyle.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              VerticalSeparator(height: 1),
                              Text(
                                  'Jadikan momen acara dengan memberikan pengalaman luar biasa untuk tim internal dan tamu undangan bersama Metronom Sound. Solusi pembuatan acara satu pintu, memberikan efisiensi dan harga yang terjangkau',
                                  style: CusTextStyle.bodyText
                                      .copyWith(color: Colors.white))
                            ],
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/recommendation_section.png',
                          width: SizeConfig.safeBlockHorizontal * 40,
                          fit: BoxFit.fitWidth,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
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

  Widget smallLayout(List<ProductData> list, List<String> categoryList) {
    List<ProductData> listFeaturedProduct = List.empty(growable: true);
    if (list.length < 4) {
      listFeaturedProduct = List.from(list);
    } else {
      for (int x = 0; x < 4; x++) {
        listFeaturedProduct.add(list[x]);
      }
    }
    int page = list.length > 4 ? 4 : list.length;
    List<Widget> listWidget = List.empty(growable: true);
    for (int i = 0; i < page; i++) {
      listWidget.add(Center(child: productItem(list[page], true)));
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
            // padding: EdgeInsets.only(
            //     left: SizeConfig.safeBlockHorizontal * 10,
            //     right: SizeConfig.safeBlockHorizontal * 10,
            //     top: 20),
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Wrap(
                  spacing: SizeConfig.safeBlockHorizontal * 3,
                  runSpacing: 50,
                  children: listFeaturedProduct
                      .map((e) => productItem(e, true))
                      .toList(),
                ),
              ),
              VerticalSeparator(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: SizedBox(
                  height: 80,
                  child: Scrollbar(
                    controller: _categoryListView,
                    child: ListView.separated(
                        controller: _categoryListView,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return categoryCard(categoryList[index], index);
                        },
                        separatorBuilder: (context, index) =>
                            HorizontalSeparator(width: 3),
                        itemCount: categoryList.length),
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: Center(
                  child: Text(
                    'Kenapa Metronom Soundsystem?',
                    style: CusTextStyle.bodyText
                        .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Colors.black.withOpacity(.1))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                    2.5),
                            child: Column(
                              children: [
                                Image.asset(Assets.images.icDelivery.path,
                                    width: SizeConfig.safeBlockHorizontal * 10,
                                    fit: BoxFit.fitWidth),
                                VerticalSeparator(height: 1),
                                Text(
                                  'Solusi Satu Pintu',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Kemudahan Pembuatan Acara',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                    2.5),
                            child: Column(
                              children: [
                                Image.asset(Assets.images.icCall24.path,
                                    width: SizeConfig.safeBlockHorizontal * 10,
                                    fit: BoxFit.fitWidth),
                                VerticalSeparator(height: 1),
                                Text(
                                  'Layanan 24 Jam',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Dukungan teknis setiap saat',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      VerticalSeparator(height: 3),
                      Row(
                        children: [
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                    2.5),
                            child: Column(
                              children: [
                                Image.asset(Assets.images.icPremium.path,
                                    width: SizeConfig.safeBlockHorizontal * 10,
                                    fit: BoxFit.fitWidth),
                                VerticalSeparator(height: 1),
                                Text(
                                  'Jaminan Pelayanan Terbaik',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Penggunaan barang dan SDM terbaik',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width:
                                (((SizeConfig.safeBlockHorizontal * 80) - 48) /
                                    2.5),
                            child: Column(
                              children: [
                                Image.asset(Assets.images.icCashback.path,
                                    width: SizeConfig.safeBlockHorizontal * 10,
                                    fit: BoxFit.fitWidth),
                                VerticalSeparator(height: 1),
                                Text(
                                  'Kemudahan Pembayaran',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                VerticalSeparator(height: .5),
                                Text(
                                  'Sistem pembayaran terintegrasi otomatis',
                                  textAlign: TextAlign.center,
                                  style: CusTextStyle.itemText
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: Center(
                  child: Text(
                    'Paling Sering Dipesan',
                    style: CusTextStyle.bodyText
                        .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: SizedBox(
                  height: SizeConfig.safeBlockHorizontal * 70 +
                      SizeConfig.safeBlockVertical * 10,
                  child: PageView(
                    pageSnapping: true,
                    controller: _pageController,
                    children: [...listWidget],
                  ),
                ),
              ),
              VerticalSeparator(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                child: Center(
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
                                    ? CusColor.black
                                    : CusColor.black.withOpacity(.6),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      separatorBuilder: (context, index) =>
                          HorizontalSeparator(width: 1),
                      itemCount: page,
                    ),
                  ),
                ),
              ),
              VerticalSeparator(height: 10),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.safeBlockVertical * 50,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.black87, Colors.black26])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(
                      'assets/images/recommendation_section.png',
                      width: SizeConfig.safeBlockHorizontal * 60,
                      fit: BoxFit.fitWidth,
                    ),
                    Spacer(),
                    Text(
                      'Serahkan keperluan acara anda kepada kami, saatnya anda fokus pada pertumbuhan bisnis',
                      textAlign: TextAlign.center,
                      style: CusTextStyle.bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    VerticalSeparator(height: 1),
                    Text(
                        'Jadikan momen acara dengan memberikan pengalaman luar biasa untuk tim internal dan tamu undangan bersama Metronom Sound. Solusi pembuatan acara satu pintu, memberikan efisiensi dan harga yang terjangkau',
                        textAlign: TextAlign.center,
                        style: CusTextStyle.bodyText
                            .copyWith(color: Colors.white, fontSize: 14)),
                    Spacer()
                  ],
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
                        context.go('/account');
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

  Widget productItem(ProductData product, bool isSmall) {
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
            SizedBox(
              width: widget.width ?? SizeConfig.safeBlockHorizontal * 15,
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: CusTextStyle.itemText.copyWith(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      color: onHover ? Colors.white : CusColor.black,
                      fontSize: 18)),
            ),
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
