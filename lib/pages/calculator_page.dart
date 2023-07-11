import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/provider/calculator_provider.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculatorNotifier>(
      create: (_) => CalculatorNotifier(),
      child: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  List<Product> lists = Product.getListProduct();
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

  Widget largeWidget() {
    return Consumer(builder: (context, CalculatorNotifier model, child) {
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
                  'Kalkulator',
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
                        text: '• Kalkulator',
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
                horizontal: SizeConfig.safeBlockHorizontal * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daftar Produk'),
                GestureDetector(
                    onTap: () {
                      Provider.of<CalculatorNotifier>(context, listen: false)
                          .addProduct(ProductModel(
                              nama: lists[0].nama,
                              harga: lists[0].harga,
                              index: model.getProduct.length));
                    },
                    child: Icon(Icons.add, color: CusColor.green))
              ],
            ),
          ),
          VerticalSeparator(height: 2),
          ListView.separated(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 40,
                      child: DropdownButtonFormField(
                          value: 0,
                          items: lists
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.nama),
                                    value: lists.indexOf(e),
                                  ))
                              .toList(),
                          onChanged: (item_index) {
                            Provider.of<CalculatorNotifier>(context,
                                    listen: false)
                                .updateProduct(
                                    index: index,
                                    product: ProductModel(
                                        nama: lists[item_index!].nama,
                                        harga: lists[item_index].harga,
                                        index: index));
                          }),
                    ),
                    HorizontalSeparator(width: 2),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 5,
                      child: TextFormField(
                        initialValue: model.getProduct[index].qty.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                              text: newValue.text.replaceAll('.', ','),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          Provider.of<CalculatorNotifier>(context,
                                  listen: false)
                              .updateProductQty(index: index, qty: value);
                        },
                      ),
                    ),
                    Spacer(),
                    Text(
                        'Rp ${model.getProduct[index].harga * model.getProduct[index].qty}')
                  ],
                );
              },
              separatorBuilder: (context, index) =>
                  VerticalSeparator(height: 2),
              itemCount: model.getProduct.length),
          VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('Total Harga: Rp ${model.getTotalPrice()}')],
            ),
          ),
          VerticalSeparator(height: 4),
          Container(alignment: Alignment.bottomCenter, child: Footer())
        ],
      );
    });
  }

  Widget smallWidget() {
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

class Product {
  String nama;
  int harga;

  Product({required this.nama, required this.harga});

  static List<Product> getListProduct() {
    List<Product> lists = [
      Product(nama: 'Speaker', harga: 200000),
      Product(nama: 'TV', harga: 400000),
      Product(nama: 'Kursi', harga: 50000),
      Product(nama: 'Meja', harga: 100000),
      Product(nama: 'Gitar', harga: 100000),
      Product(nama: 'Drum', harga: 500000),
      Product(nama: 'Microphone', harga: 20000),
      Product(nama: 'Sofa', harga: 350000),
    ];
    return lists;
  }
}
