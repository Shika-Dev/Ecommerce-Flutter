import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:ecom_web_flutter/widget/contact.dart';
import 'package:ecom_web_flutter/widget/footer.dart';
import 'package:ecom_web_flutter/widget/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeline_tile/timeline_tile.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          index: 3,
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
    return ListView(
        children: [
          ContactBar(),
          VerticalSeparator(height: 1),
          NavBar(
            scaffoldKey: _scaffoldKey,
            index: 2,
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
                  'About Us',
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
                        text: '• About Us',
                        style: CusTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.w500, color: CusColor.green),
                      )
                    ]))
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'Cara Order',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
          VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TimelineTile(
                  isFirst: true,
                  lineXY: .1,
                  alignment: TimelineAlign.manual,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('1', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  endChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: CusTextStyle.bodyText,)
                      ],
                    ),
                  ),
                ),
                TimelineDivider(
                        begin: 0.1,
                        end: 0.9,
                        thickness: 4,
                        color: Colors.black,
                      ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: .9,
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  beforeLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('2', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  startChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: CusTextStyle.bodyText, textAlign: TextAlign.end,)
                      ],
                    ),
                  ),
                ),
                TimelineDivider(
                        begin: 0.1,
                        end: 0.9,
                        thickness: 4,
                        color: Colors.black,
                      ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: .1,
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  beforeLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('3', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  isLast: true,
                  endChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: CusTextStyle.bodyText,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'FAQ',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
          VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: Accordion(
                    headerBorderColor: CusColor.black,
                    headerBorderColorOpened: CusColor.black,
                    // headerBorderWidth: 1,
                    headerBackgroundColorOpened: CusColor.black,
                    headerBackgroundColor: CusColor.black,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: CusColor.black,
                    contentBorderWidth: 3,
                    contentHorizontalPadding: 20,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    paddingBetweenClosedSections: 40,
                    paddingBetweenOpenSections: 40,
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                    ]),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'Tentang Kami',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal*50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Metronom DJ School'),
                      VerticalSeparator(height: 1),
                      Text('Jl. Pakubuwono VI No.26d, RT.8/RW.5, Gunung, Kec. Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12120'),
                      VerticalSeparator(height: 1),
                      Text('metronomsound@gmail.com'),
                      VerticalSeparator(height: 1),
                      Text('0819 1888 7333')
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(-6.233620342687938, 106.79321234282578),
                      initialZoom: 15
                    ), 
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(-6.233620342687938, 106.79321234282578),
                            child: Icon(Icons.location_on, color: Colors.red, size: 30,)
                          )
                        ]
                      )
                    ]),
                )
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Container(alignment: Alignment.bottomCenter, child: Footer())
        ],
      );
  }

  Widget smallWidget() {
    return ListView(
      children: [
        ContactBar(),
          VerticalSeparator(height: 1),
          NavBar(
            scaffoldKey: _scaffoldKey,
            index: 2,
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
                  'About Us',
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
                        text: '• About Us',
                        style: CusTextStyle.bodyText.copyWith(
                            fontWeight: FontWeight.w500, color: CusColor.green),
                      )
                    ]))
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'Cara Order',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
          VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TimelineTile(
                  isFirst: true,
                  lineXY: .1,
                  alignment: TimelineAlign.manual,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('1', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  endChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: CusTextStyle.bodyText,)
                      ],
                    ),
                  ),
                ),
                TimelineDivider(
                        begin: 0.1,
                        end: 0.9,
                        thickness: 4,
                        color: Colors.black,
                      ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: .9,
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  beforeLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('2', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  startChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: CusTextStyle.bodyText, textAlign: TextAlign.end,)
                      ],
                    ),
                  ),
                ),
                TimelineDivider(
                        begin: 0.1,
                        end: 0.9,
                        thickness: 4,
                        color: Colors.black,
                      ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: .1,
                  afterLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  beforeLineStyle: LineStyle(color: Colors.black, thickness: 4),
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                      height: 30,
                    indicator: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                      ),
                      child: Center(child: Text('3', style: CusTextStyle.bodyText.copyWith(color: Colors.white))),
                    ),
                    color: Colors.black
                  ),
                  isLast: true,
                  endChild: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Lorem Ipsum', style: CusTextStyle.bodyText.copyWith(fontSize: 20, fontWeight: FontWeight.w700),),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: CusTextStyle.bodyText,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'FAQ',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
          VerticalSeparator(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: Accordion(
                    headerBorderColor: CusColor.black,
                    headerBorderColorOpened: CusColor.black,
                    // headerBorderWidth: 1,
                    headerBackgroundColorOpened: CusColor.black,
                    headerBackgroundColor: CusColor.black,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: CusColor.black,
                    contentBorderWidth: 3,
                    contentHorizontalPadding: 20,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    paddingBetweenClosedSections: 40,
                    paddingBetweenOpenSections: 40,
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                      AccordionSection(
                        contentVerticalPadding: 20,
                        leftIcon: const Icon(Icons.question_mark_rounded,
                            color: Colors.white),
                        header: Text('Lorem ipsum sir dolot amet',
                            style: CusTextStyle.bodyText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        content: Text('loremIpsum', style: CusTextStyle.bodyText),
                      ),
                    ]),
          ),
          VerticalSeparator(height: 4),
          Center(
                child: Text(
                  'Tentang Kami',
                  style: CusTextStyle.bodyText
                      .copyWith(fontSize: 42, fontWeight: FontWeight.w700),
                ),
              ),
              VerticalSeparator(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Metronom DJ School'),
                      VerticalSeparator(height: 1),
                      Text('Jl. Pakubuwono VI No.26d, RT.8/RW.5, Gunung, Kec. Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12120'),
                      VerticalSeparator(height: 1),
                      Text('metronomsound@gmail.com'),
                      VerticalSeparator(height: 1),
                      Text('0819 1888 7333')
                    ],
                  ),
                ),
          VerticalSeparator(height: 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal*10),
            child: SizedBox(
              width:  SizeConfig.screenWidth,
              height: SizeConfig.safeBlockHorizontal*80,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(-6.233620342687938, 106.79321234282578),
                  initialZoom: 15
                ), 
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(-6.233620342687938, 106.79321234282578),
                        child: Icon(Icons.location_on, color: Colors.red, size: 30,)
                      )
                    ]
                  )
                ]),
            ),
          ),
          VerticalSeparator(height: 4),
          Container(alignment: Alignment.bottomCenter, child: Footer())
      ],
    );
  }
}
