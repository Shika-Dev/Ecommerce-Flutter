// import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
// import 'package:ecom_web_flutter/api_repository/models/models.dart';
// import 'package:ecom_web_flutter/injector/injector.dart';
// import 'package:ecom_web_flutter/provider/calculator_provider.dart';
// import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
// import 'package:ecom_web_flutter/style/currency_format.dart';
// import 'package:ecom_web_flutter/style/style.dart';
// import 'package:ecom_web_flutter/utils/separator.dart';
// import 'package:ecom_web_flutter/utils/size.dart';
// import 'package:ecom_web_flutter/widget/contact.dart';
// import 'package:ecom_web_flutter/widget/footer.dart';
// import 'package:ecom_web_flutter/widget/navBar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// class Calculator extends StatelessWidget {
//   const Calculator({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<CalculatorNotifier>(
//       create: (_) => CalculatorNotifier(),
//       child: CalculatorPage(),
//     );
//   }
// }
//
// class CalculatorPage extends StatefulWidget {
//   const CalculatorPage({Key? key}) : super(key: key);
//
//   @override
//   State<CalculatorPage> createState() => _CalculatorPageState();
// }
//
// class _CalculatorPageState extends State<CalculatorPage> {
//   String category = '';
//   late Future<CategoryModel> futureCategory;
//   List<DropdownMenuItem> listProductByCategory =
//       List<DropdownMenuItem>.empty(growable: true);
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     SharedPreferencesManager pref = locator<SharedPreferencesManager>();
//     futureCategory = fetchAllCategory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//         key: _scaffoldKey,
//         drawer: NavDrawer(
//           index: 3,
//         ),
//         body: LayoutBuilder(
//           builder: (context, constraint) {
//             if (constraint.maxWidth > 600)
//               return largeWidget();
//             else
//               return smallWidget();
//           },
//         ));
//   }
//
//   Widget largeWidget() {
//     return Consumer(builder: (context, CalculatorNotifier model, child) {
//       return ListView(
//         children: [
//           ContactBar(),
//           VerticalSeparator(height: 1),
//           NavBar(
//             scaffoldKey: _scaffoldKey,
//             index: 3,
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.safeBlockHorizontal * 10,
//                 vertical: SizeConfig.safeBlockVertical * 3),
//             width: double.infinity,
//             color: CusColor.bgShade,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Kalkulator',
//                   style: CusTextStyle.bodyText
//                       .copyWith(fontSize: 36, fontWeight: FontWeight.w700),
//                 ),
//                 VerticalSeparator(height: .5),
//                 RichText(
//                     text: TextSpan(
//                         text: 'Home • Pages ',
//                         style: CusTextStyle.bodyText
//                             .copyWith(fontWeight: FontWeight.w500),
//                         children: [
//                       TextSpan(
//                         text: '• Kalkulator',
//                         style: CusTextStyle.bodyText.copyWith(
//                             fontWeight: FontWeight.w500, color: CusColor.green),
//                       )
//                     ]))
//               ],
//             ),
//           ),
//           VerticalSeparator(height: 4),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.safeBlockHorizontal * 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Daftar Produk',
//                   style: CusTextStyle.bodyText
//                       .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
//                 ),
//                 GestureDetector(
//                     onTap: () {
//                       Provider.of<CalculatorNotifier>(context, listen: false)
//                           .addProduct(ProductCalculatorModel(
//                               harga: 0, index: model.getProduct.length));
//                     },
//                     child: Icon(Icons.add, color: CusColor.green))
//               ],
//             ),
//           ),
//           VerticalSeparator(height: 2),
//           FutureBuilder<ProductModel>(
//               future: fetchAllProduct(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   var list = snapshot.data!.data!;
//                   return ListView.separated(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: SizeConfig.safeBlockHorizontal * 10),
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Row(
//                           children: [
//                             // FutureBuilder<CategoryModel>(
//                             //     future: futureCategory,
//                             //     builder: (context, snapshot) {
//                             //       if (snapshot.hasData) {
//                             //         List<String> item = snapshot.data!.data!.categories
//                             //             .map((cat) => cat.category)
//                             //             .toList();
//                             //         return SizedBox(
//                             //             width: SizeConfig.safeBlockHorizontal * 10,
//                             //             child: DropdownButtonFormField(
//                             //                 hint: Text('Pilih Kategori'),
//                             //                 value: category==''?null:category,
//                             //                 items: item
//                             //                     .map((e) => DropdownMenuItem(
//                             //                   child: Text(e),
//                             //                   value: e,
//                             //                 ))
//                             //                     .toList(),
//                             //                 onChanged: (value) async {
//                             //                   ProductModel model = await fetchProductByCategory(value.toString());
//                             //                   setState(() {
//                             //                     listProductByCategory = model.data!.map((e) => DropdownMenuItem(child: Text(e.name), value: e.id,)).toList();
//                             //                   });
//                             //                 }));
//                             //       }
//                             //       return SizedBox();
//                             //     }),
//                             SizedBox(
//                               width: SizeConfig.safeBlockHorizontal * 30,
//                               child: DropdownButtonFormField(
//                                   items: list
//                                       .map((e) => DropdownMenuItem(
//                                             child: Text(e.name),
//                                             value: e.id,
//                                           ))
//                                       .toList(),
//                                   hint: Text('Select Product'),
//                                   onChanged: (value) {
//                                     Provider.of<CalculatorNotifier>(context,
//                                             listen: false)
//                                         .updateProduct(
//                                             index: index,
//                                             product: ProductCalculatorModel(
//                                                 harga: list[list.indexWhere((element) => element.id == value)]
//                                                             .priceSale ==
//                                                         0
//                                                     ? list[list.indexWhere(
//                                                             (element) =>
//                                                                 element.id ==
//                                                                 value)]
//                                                         .priceOriginal
//                                                     : list[list.indexWhere(
//                                                             (element) => element.id == value)]
//                                                         .priceSale,
//                                                 index: index));
//                                   }),
//                             ),
//                             HorizontalSeparator(width: 2),
//                             SizedBox(
//                               width: SizeConfig.safeBlockHorizontal * 5,
//                               child: TextFormField(
//                                 initialValue:
//                                     model.getProduct[index].qty.toString(),
//                                 keyboardType: TextInputType.number,
//                                 inputFormatters: <TextInputFormatter>[
//                                   FilteringTextInputFormatter.allow(
//                                       RegExp(r'[0-9]')),
//                                   TextInputFormatter.withFunction(
//                                     (oldValue, newValue) => newValue.copyWith(
//                                       text: newValue.text.replaceAll('.', ','),
//                                     ),
//                                   ),
//                                 ],
//                                 onChanged: (value) {
//                                   Provider.of<CalculatorNotifier>(context,
//                                           listen: false)
//                                       .updateProductQty(
//                                           index: index, qty: value);
//                                 },
//                               ),
//                             ),
//                             Spacer(),
//                             Text(
//                               '${CurrencyFormat.convertToIdr(model.getProduct[index].harga * model.getProduct[index].qty, 0)}',
//                               style:
//                                   CusTextStyle.bodyText.copyWith(fontSize: 16),
//                             )
//                           ],
//                         );
//                       },
//                       separatorBuilder: (context, index) =>
//                           VerticalSeparator(height: 2),
//                       itemCount: model.getProduct.length);
//                 } else
//                   return Center(child: const CircularProgressIndicator());
//               }),
//           VerticalSeparator(height: 4),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.safeBlockHorizontal * 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Total Harga: ${CurrencyFormat.convertToIdr(model.getTotalPrice(), 0)}',
//                   style: CusTextStyle.bodyText
//                       .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
//                 )
//               ],
//             ),
//           ),
//           VerticalSeparator(height: 4),
//           Container(alignment: Alignment.bottomCenter, child: Footer())
//         ],
//       );
//     });
//   }
//
//   Widget smallWidget() {
//     return Column(
//       children: [
//         ContactBar(),
//         VerticalSeparator(height: 1),
//         NavBar(
//           scaffoldKey: _scaffoldKey,
//           index: 3,
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.safeBlockHorizontal * 10,
//               vertical: SizeConfig.safeBlockVertical * 3),
//           width: double.infinity,
//           color: CusColor.bgShade,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'My Account',
//                 style: CusTextStyle.bodyText
//                     .copyWith(fontSize: 36, fontWeight: FontWeight.w700),
//               ),
//               VerticalSeparator(height: .5),
//               RichText(
//                   text: TextSpan(
//                       text: 'Home • Pages ',
//                       style: CusTextStyle.bodyText
//                           .copyWith(fontWeight: FontWeight.w500),
//                       children: [
//                     TextSpan(
//                       text: '• MyAccount',
//                       style: CusTextStyle.bodyText.copyWith(
//                           fontWeight: FontWeight.w500, color: CusColor.green),
//                     )
//                   ]))
//             ],
//           ),
//         ),
//         VerticalSeparator(height: 4),
//         Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.safeBlockHorizontal * 15),
//           child: Container(
//             padding: EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               boxShadow: [CusBoxShadow.shadow],
//               color: Colors.white,
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   'Login',
//                   style: CusTextStyle.bodyText
//                       .copyWith(fontWeight: FontWeight.w700, fontSize: 32),
//                 ),
//                 VerticalSeparator(height: .5),
//                 Text(
//                   'Please login using account detail bellow.',
//                   style: CusTextStyle.navText.copyWith(color: CusColor.bgShade),
//                 ),
//                 VerticalSeparator(height: 2),
//               ],
//             ),
//           ),
//         ),
//         VerticalSeparator(height: 2),
//         Spacer(),
//         Footer()
//       ],
//     );
//   }
// }
