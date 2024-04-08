import 'package:ecom_web_flutter/style/style.dart';
import 'package:ecom_web_flutter/utils/separator.dart';
import 'package:ecom_web_flutter/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactBar extends StatefulWidget {
  const ContactBar({Key? key}) : super(key: key);

  @override
  State<ContactBar> createState() => _ContactBarState();
}

class _ContactBarState extends State<ContactBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 10, vertical: 8),
      color: CusColor.black,
      child: Row(
        children: [
          Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          InkWell(
            onTap: () {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'metronomsound@gmail.com',
                queryParameters: {'subject': '', 'body': ''},
              );
              launchUrl(emailLaunchUri);
            },
            child: Text('metronomsound@gmail.com',
                style: CusTextStyle.bodyText.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
          Spacer(),
          Icon(
            Icons.phone_in_talk_rounded,
            color: Colors.white,
            size: 16,
          ),
          HorizontalSeparator(width: 1),
          InkWell(
            onTap: () {
              final Uri telLaunchUri = Uri(
                scheme: 'tel',
                path: '+6281918887333',
              );
              launchUrl(telLaunchUri);
            },
            child: Text('0819 1888 7333',
                style: CusTextStyle.bodyText.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
