import 'package:flutter/material.dart';
import 'package:new_practise/Emailcount.dart';
import 'package:new_practise/emailUi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:js' as js;
import 'package:universal_html/html.dart' as html;
import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  EmailCountService emailCountService = EmailCountService();
  String jwtPhone = '';
  String? phtoken = '';
  String count = '';
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> decoded;
    Uri currentUri = Uri.parse(html.window.location.href);
    Map<String, String> queryParams = currentUri.queryParameters;
    phtoken = queryParams['phtoken'];
    log('token${phtoken}');
    try {
      decoded = JwtDecoder.decode(phtoken!);
      int jwtResponse = 1;
      jwtPhone = decoded['country_code'] + decoded['phone_no'];
    } catch (e) {
      int jwtResponse = 0;
      String jwtPhone = '';
      print('Invalid JWT or decoding error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (phtoken == null) {
              return Center(
                child: SignInButton(count: count, phtoken: phtoken),
              );
            } else if (phtoken != '') {
              return const Center(child: EmailCounter());
            } else {
              return const Center(child: Text('Not logged in'));
            }
          },
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  SignInButton({this.count, this.phtoken});
  final String api_key = '****************************';   //Replace with your  API key
  String? countryCode;
  String? phoneNumber;
  String? redirectUrl = html.window.location.href;
  String? count;
  String? phtoken;
  @override
  Widget build(BuildContext context) {
    void openPopupWindow(String url) {
      js.context.callMethod('open', [
        url,
        'peLoginWindow',
        'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=500,height=560,top=' +
            ((js.context['screen']['height'] - 600) / 2).toString() +
            ',left=' +
            ((js.context['screen']['width'] - 500) / 2).toString()
      ]);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(alignment: Alignment.topRight, children: [
            Padding(
              padding: const EdgeInsets.only(right: 200),
              child: phtoken == null
                  ? SizedBox()
                  : Container(
                      child: SvgPicture.string(
                        '<svg data-v-db365ed2="" width="32" height="30" viewBox="0 0 32 23" fill="none" xmlns="http://www.w3.org/2000/svg"><path data-v-db365ed2="" d="M30.4594 0H1.60313C0.734767 0 0 0.734767 0 1.60313V20.7071C0 21.5754 0.734767 22.3102 1.60313 22.3102H30.3926C31.261 22.3102 31.9958 21.5754 31.9958 20.7071V1.60313C32.0626 0.734767 31.3278 0 30.4594 0ZM16.0313 14.7621L2.2711 1.33594H29.7915L16.0313 14.7621ZM10.4871 11.2219L1.33594 20.1059V2.2711L10.4871 11.2219ZM11.4223 12.1571L15.5637 16.1649C15.8309 16.4321 16.2317 16.4321 16.4989 16.1649L20.6403 12.0903L29.7247 20.9743H2.3379L11.4223 12.1571ZM21.5754 11.2219L30.7266 2.2711V20.1059L21.5754 11.2219Z" fill="#024430"></path></svg>',
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
            ),
          ]),
          SizedBox(
            height: 8.2,
          ),
          ElevatedButton(
            onPressed: () {
              countryCode = '';
              phoneNumber = '';
              String url =
                  'https://www.phone.email/auth/sign-in?countrycode=${countryCode}&phone_no=${phoneNumber}&redirect_url=${redirectUrl}';
              openPopupWindow(url);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 3.2),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8.5,
                  ),
                  Text(
                    "Sign in with Phone Number",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.2,
                    ),
                  ),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 4, 201, 135),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              fixedSize: Size(270, 45),
            ),
          )
        ],
      ),
    );
  }
}
