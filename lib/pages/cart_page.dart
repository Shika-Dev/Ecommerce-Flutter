import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'dart:js_interop';

import 'package:ecom_web_flutter/api_repository/data_sources/order_datasources.dart';
import 'package:ecom_web_flutter/api_repository/data_sources/product_datasource.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:ecom_web_flutter/style/currency_format.dart';
import 'package:ecom_web_flutter/style/image_base64.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late bool _isAuthorized;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SharedPreferencesManager pref = locator<SharedPreferencesManager>();
    setState(() {
      _isAuthorized = pref.getBool(SharedPreferencesManager.keyAuth) ?? false;
    });
  }

  Future<void> _createPDF(
      List<CartData> list, String name, String alamat, String mobile) async {
    PdfDocument document = PdfDocument();

    //Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 50;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;
    //add Logo
    PdfImage image = PdfBitmap.fromBase64String(logo_base64);
    page.graphics.drawImage(
        image, Rect.fromLTWH(graphics.clientSize.width - 102, 0, 102, 30));

    //Add company info
    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    Rect company_bounds = Rect.fromLTWH(0, 0, graphics.clientSize.width, 30);

    PdfTextElement element = PdfTextElement(
        text: 'Sevva',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 24,
            style: PdfFontStyle.bold));

    PdfLayoutResult company_result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, company_bounds.top + 8, 0, 0))!;
    element.brush = PdfBrushes.black;

    element = PdfTextElement(
        text: 'Jalan Pakubuwono VI No. 26D RT.8/RW.5, Gunung, Kec. Kby. Baru,',
        font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: 'Kota Jakarta Selatan 12120.', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: 'Phone: 0819 1888 7333', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: 'Email: sevva.co.id@gmail.com', font: timesRoman);
    element.brush = PdfBrushes.black;
    company_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, company_result.bounds.bottom + 5, 0, 0))!;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));

    Rect bounds = Rect.fromLTWH(0, 160, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);

//Creates a text element to add the invoice number
    element = PdfTextElement(text: 'INVOICE', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;
//Use 'intl' package for date format.
    String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    Offset textPosition = Offset(
        graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: 'CUSTOMER',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(text: name, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: mobile, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: alamat, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 5, 0, 0))!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 5),
        Offset(graphics.clientSize.width, result.bounds.bottom + 5));

    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 5);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Product Name';
    header.cells[1].value = 'Price';
    header.cells[2].value = 'Quantity';
    header.cells[3].value = 'Unit';
    header.cells[4].value = 'Total';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
        style: PdfFontStyle.regular);

//Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

    for (int i = 0; i < list.length; i++) {
      int price =
          list[i].priceSale == 0 ? list[i].priceOriginal : list[i].priceSale;
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = list[i].productName;
      row.cells[1].value = CurrencyFormat.convertToIdr(price, 0);
      row.cells[2].value = list[i].productQty.toString();
      row.cells[3].value = list[i].productUnit;
      row.cells[4].value =
          CurrencyFormat.convertToIdr(price * list[i].productQty, 0);
    }

    PdfGridRow subtotal_row = grid.rows.add();
    subtotal_row.cells[3].value = 'Subtotal';
    subtotal_row.cells[4].value =
        CurrencyFormat.convertToIdr(list[0].totalPrice, 0);

    PdfGridRow total_row = grid.rows.add();
    total_row.cells[3].value = 'Total';
    total_row.cells[4].value =
        CurrencyFormat.convertToIdr(list[0].totalPrice, 0);

    //Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

    //Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
    //Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

    //Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    Rect bank_bounds = Rect.fromLTWH(
        0, gridResult.bounds.bottom + 20, graphics.clientSize.width, 30);

    PdfFont bankFontStyle = PdfStandardFont(PdfFontFamily.timesRoman, 12);

    element = PdfTextElement(text: 'BCA', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    PdfLayoutResult bank_result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bank_bounds.top + 8, 0, 0))!;

    element =
        PdfTextElement(text: 'a.n. Yusa Nanda Hardito', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    bank_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, bank_result.bounds.bottom + 5, 0, 0))!;

    element = PdfTextElement(text: '5005141751', font: bankFontStyle);
    element.brush = PdfBrushes.black;
    bank_result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, bank_result.bounds.bottom + 5, 0, 0))!;

    //Save the document
    List<int> bytes = await document.save();

    js.context['pdfData'] = base64.encode(bytes);
    js.context['filename'] = 'Invoice.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });

    //Dispose the document
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: NavDrawer(
          index: 2,
        ),
        body: FutureBuilder(
            future: fetchUserCart(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CartData> list = snapshot.data!.data ?? [];
                List<TextEditingController> listQtyController = list.isNotEmpty
                    ? List.generate(
                        list.length,
                        (index) => TextEditingController(
                            text: list[index].productQty.toString()))
                    : [];
                List<TextEditingController> listNoteController = list.isNotEmpty
                    ? List.generate(
                        list.length,
                        (index) => TextEditingController(
                            text: list[index].additionalNote))
                    : [];
                return LayoutBuilder(
                  builder: (context, constraint) {
                    if (constraint.maxWidth > 900)
                      return largeWidget(
                          list, listQtyController, listNoteController);
                    else
                      return smallWidget(
                          list, listQtyController, listNoteController);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  Widget item(CartData cartItem, TextEditingController qtyController,
      TextEditingController noteController) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(cartItem.imageUrl),
                      fit: BoxFit.cover)),
              width: 100,
              height: 100,
            ),
            HorizontalSeparator(width: 3),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.productName),
                VerticalSeparator(height: 1),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 10,
                  child: TextFormField(
                    controller: noteController,
                    onEditingComplete: () async {
                      SharedPreferencesManager pref =
                          locator<SharedPreferencesManager>();
                      bool isLogin =
                          pref.getBool(SharedPreferencesManager.keyAuth) ??
                              false;
                      if (isLogin) {
                        Map<String, dynamic> body = {
                          'cartData': [
                            {
                              'productId': cartItem.productId,
                              'qty': qtyController.text,
                              'additionalNote': noteController.text
                            }
                          ]
                        };
                        var model = await addToCart(body);
                        if (!model.errors.isNull) {
                          Navigator.pushReplacementNamed(context, '/cart');
                        } else {
                          print(model.errors.toString());
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Akses anda telah habis silahkan login ulang untuk memperbaharui akses"),
                                actions: [
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
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal * 5,
              child: TextFormField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll('.', ','),
                    ),
                  ),
                ],
                onEditingComplete: () async {
                  SharedPreferencesManager pref =
                      locator<SharedPreferencesManager>();
                  bool isLogin =
                      pref.getBool(SharedPreferencesManager.keyAuth) ?? false;
                  if (isLogin) {
                    Map<String, dynamic> body = {
                      'cartData': [
                        {
                          'productId': cartItem.productId,
                          'qty': qtyController.text,
                          'additionalNote': noteController.text
                        }
                      ]
                    };
                    var model = await addToCart(body);
                    if (!model.errors.isNull) {
                      Navigator.pushReplacementNamed(context, '/cart');
                    } else {
                      print(model.errors.toString());
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                "Akses anda telah habis silahkan login ulang untuk memperbaharui akses"),
                            actions: [
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
              ),
            ),
            Spacer(),
            Text(cartItem.priceSale == 0
                ? CurrencyFormat.convertToIdr(
                    cartItem.priceOriginal * int.parse(qtyController.text), 0)
                : CurrencyFormat.convertToIdr(
                    cartItem.priceSale * int.parse(qtyController.text), 0)),
          ],
        ),
        VerticalSeparator(height: 1),
        Divider(color: CusColor.border)
      ],
    );
  }

  Widget largeWidget(
      List<CartData> list,
      List<TextEditingController> listQtyController,
      List<TextEditingController> listNoteController) {
    return Column(
      children: [
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 2,
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
                        'Keranjang Belanja',
                        style: CusTextStyle.bodyText.copyWith(
                            fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                      VerticalSeparator(height: .5),
                      RichText(
                          text: TextSpan(
                              text: 'Home • Pages ',
                              style: CusTextStyle.bodyText
                                  .copyWith(fontWeight: FontWeight.w500),
                              children: [
                            TextSpan(
                              text: '• Cart',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CusColor.green),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...list.map((e) => item(
                              e,
                              listQtyController[list.indexOf(e)],
                              listNoteController[list.indexOf(e)])),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Color(0xff19D16F)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/shop');
                                },
                                child: Text(
                                  'Kembali Belanja',
                                  style: CusTextStyle.bodyText.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                )),
                          )
                        ],
                      )),
                      HorizontalSeparator(width: 3),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: SizeConfig.safeBlockHorizontal * 20,
                        color: CusColor.bgShade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Masukkan Nama:'),
                            TextFormField(
                              controller: nameController,
                              onChanged: (value) {},
                            ),
                            VerticalSeparator(height: 2),
                            Text('Masukkan No Hp:'),
                            TextFormField(
                              controller: mobileController,
                              onChanged: (value) {},
                            ),
                            VerticalSeparator(height: 2),
                            Text('Masukkan Alamat:'),
                            TextFormField(
                              controller: alamatController,
                              maxLines: 3,
                              onChanged: (value) {},
                            ),
                            VerticalSeparator(height: 3),
                            Row(
                              children: [
                                Text('Subtotal:'),
                                Spacer(),
                                Text(CurrencyFormat.convertToIdr(
                                    list.length > 0 ? list[0].totalPrice : 0,
                                    0)),
                              ],
                            ),
                            VerticalSeparator(height: 1),
                            Divider(color: CusColor.border),
                            VerticalSeparator(height: 3),
                            Row(
                              children: [
                                Text('Total:'),
                                Spacer(),
                                Text(CurrencyFormat.convertToIdr(
                                    list.length > 0 ? list[0].totalPrice : 0,
                                    0)),
                              ],
                            ),
                            VerticalSeparator(height: 1),
                            Divider(color: CusColor.border),
                            VerticalSeparator(height: 5),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Color(0xff19D16F)),
                                  onPressed: () async {
                                    if (nameController.text.isEmpty ||
                                        alamatController.text.isEmpty ||
                                        mobileController.text.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Harap Lengkapi Data Anda"),
                                              content: Text(
                                                  "Silahkan lengkapi nama, nomor ponsel, serta alamat anda sebelum membuat order"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    } else if (list.length == 0) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Harap Tambahkan Produk ke Keranjang"),
                                              content: Text(
                                                  "Silahkan tambahkan produk ke dalam keranjang anda sebelum membuat order"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      List<Map<String, dynamic>> productList =
                                          List.empty(growable: true);
                                      list.forEach((element) {
                                        productList.add({
                                          'productId': element.productId,
                                          'qty': element.productQty
                                        });
                                      });
                                      Map<String, dynamic> body = {
                                        'productList': productList,
                                        'address': alamatController.text,
                                        'phoneNo': mobileController.text
                                      };
                                      PostResponseModel response =
                                          await addOrder(body);
                                      if (response.errors.isNull ||
                                          response.errors!.errorCode.isNull) {
                                        _createPDF(
                                            list,
                                            nameController.text,
                                            alamatController.text,
                                            mobileController.text);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Order Anda telah diteruskan ke Admin"),
                                                content: Text(
                                                    "Selanjutnya admin akan menghubungi anda terkait order anda"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("Close"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sewa Sekarang!',
                                    style: CusTextStyle.bodyText.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalSeparator(height: 2),
                Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget smallWidget(
      List<CartData> list,
      List<TextEditingController> listQtyController,
      List<TextEditingController> listNoteController) {
    return Column(
      children: [
        ContactBar(),
        VerticalSeparator(height: 1),
        NavBar(
          scaffoldKey: _scaffoldKey,
          index: 2,
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
                        'Keranjang Belanja',
                        style: CusTextStyle.bodyText.copyWith(
                            fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                      VerticalSeparator(height: .5),
                      RichText(
                          text: TextSpan(
                              text: 'Home • Pages ',
                              style: CusTextStyle.bodyText
                                  .copyWith(fontWeight: FontWeight.w500),
                              children: [
                            TextSpan(
                              text: '• Cart',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: CusColor.green),
                            )
                          ]))
                    ],
                  ),
                ),
                VerticalSeparator(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...list.map((e) => item(
                          e,
                          listQtyController[list.indexOf(e)],
                          listNoteController[list.indexOf(e)])),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff19D16F)),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/shop');
                            },
                            child: Text(
                              'Kembali Belanja',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )),
                      )
                    ],
                  )),
                ),
                VerticalSeparator(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10,
                      vertical: 16),
                  color: CusColor.bgShade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masukkan Nama:'),
                      TextFormField(
                        controller: nameController,
                        onChanged: (value) {},
                      ),
                      VerticalSeparator(height: 2),
                      Text('Masukkan No Hp:'),
                      TextFormField(
                        controller: mobileController,
                        onChanged: (value) {},
                      ),
                      VerticalSeparator(height: 2),
                      Text('Masukkan Alamat:'),
                      TextFormField(
                        controller: alamatController,
                        maxLines: 3,
                        onChanged: (value) {},
                      ),
                      VerticalSeparator(height: 3),
                      Row(
                        children: [
                          Text('Subtotal:'),
                          Spacer(),
                          Text(CurrencyFormat.convertToIdr(
                              list.length > 0 ? list[0].totalPrice : 0, 0)),
                        ],
                      ),
                      VerticalSeparator(height: 1),
                      Divider(color: CusColor.border),
                      VerticalSeparator(height: 3),
                      Row(
                        children: [
                          Text('Total:'),
                          Spacer(),
                          Text(CurrencyFormat.convertToIdr(
                              list.length > 0 ? list[0].totalPrice : 0, 0)),
                        ],
                      ),
                      VerticalSeparator(height: 1),
                      Divider(color: CusColor.border),
                      VerticalSeparator(height: 5),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Color(0xff19D16F)),
                            onPressed: () async {
                              if (nameController.text.isEmpty ||
                                  alamatController.text.isEmpty ||
                                  mobileController.text.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Harap Lengkapi Data Anda"),
                                        content: Text(
                                            "Silahkan lengkapi nama, nomor ponsel, serta alamat anda sebelum membuat order"),
                                        actions: [
                                          TextButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              } else if (list.length == 0) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Harap Tambahkan Produk ke Keranjang"),
                                        content: Text(
                                            "Silahkan tambahkan produk ke dalam keranjang anda sebelum membuat order"),
                                        actions: [
                                          TextButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                List<Map<String, dynamic>> productList =
                                    List.empty(growable: true);
                                list.forEach((element) {
                                  productList.add({
                                    'productId': element.productId,
                                    'qty': element.productQty
                                  });
                                });
                                Map<String, dynamic> body = {
                                  'productList': productList,
                                  'address': alamatController.text,
                                  'phoneNo': mobileController.text
                                };
                                PostResponseModel response =
                                    await addOrder(body);
                                if (response.errors.isNull ||
                                    response.errors!.errorCode.isNull) {
                                  _createPDF(
                                      list,
                                      nameController.text,
                                      alamatController.text,
                                      mobileController.text);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Order Anda telah diteruskan ke Admin"),
                                          content: Text(
                                              "Selanjutnya admin akan menghubungi anda terkait order anda"),
                                          actions: [
                                            TextButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                            child: Text(
                              'Sewa Sekarang!',
                              style: CusTextStyle.bodyText.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
                VerticalSeparator(height: 2),
                Footer()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
