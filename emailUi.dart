// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps, unused_local_variable, unnecessary_string_interpolations, duplicate_import
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_practise/EmailCountservice.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:new_practise/logOutService.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailCounter extends StatefulWidget {
  const EmailCounter({super.key, this.title});
  final String? title;
  @override
  State<EmailCounter> createState() => _EmailCounterState();
}

class _EmailCounterState extends State<EmailCounter> {
  EmailCountService emailCountService = EmailCountService();
  LogoutService logoutService = LogoutService();
  String count = '';
  String phone = '';
  String jwtToken = '';
  String code = '';
  String number = '';
  String emailUrl = '';
  @override
  void initState() {
    super.initState();
    getEmailCount();
  }

  getEmailCount() async {
    Uri currentUri = Uri.parse(html.window.location.href);
    Map<String, String> queryParams = currentUri.queryParameters;
    Map<String, dynamic> decoded;
    String? token = queryParams['phtoken'];
    jwtToken = token!;
    decoded = JwtDecoder.decode(token);
    int jwtResponse = 1;
    String jwtPhone = decoded['country_code'] + decoded['phone_no'];
    phone = jwtPhone;
    code = decoded['country_code'];
    number = decoded['phone_no'];

    emailCountService.getEmailCount(token).then((value) {
      setState(() {
        count = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0, left: 250),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    emailUrl = 'https://web.phone.email';
                    await launch(emailUrl);
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 27.7, bottom: 20.5),
                        child: Container(
                          height: 19.5,
                          width: 19.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 255, 52, 37),
                          ),
                          child: Center(
                            child: Text(
                              '${count}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 11.5),
                        child: Container(
                          child: SvgPicture.string(
                            '<svg data-v-db365ed2="" width="100" height="37" viewBox="0 0 70 23" fill="none" xmlns="http://www.w3.org/2000/svg"><path data-v-db365ed2="" d="M30.4594 0H1.60313C0.734767 0 0 0.734767 0 1.60313V20.7071C0 21.5754 0.734767 22.3102 1.60313 22.3102H30.3926C31.261 22.3102 31.9958 21.5754 31.9958 20.7071V1.60313C32.0626 0.734767 31.3278 0 30.4594 0ZM16.0313 14.7621L2.2711 1.33594H29.7915L16.0313 14.7621ZM10.4871 11.2219L1.33594 20.1059V2.2711L10.4871 11.2219ZM11.4223 12.1571L15.5637 16.1649C15.8309 16.4321 16.2317 16.4321 16.4989 16.1649L20.6403 12.0903L29.7247 20.9743H2.3379L11.4223 12.1571ZM21.5754 11.2219L30.7266 2.2711V20.1059L21.5754 11.2219Z" fill="#024430"></path></svg>',
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4.5,
            ),
            Container(
              height: 180,
              width: 300,
              color: Color.fromARGB(255, 255, 236, 181),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.5, left: 45.0, right: 21.0, bottom: 25.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your are now Logged In with",
                      style: TextStyle(
                          fontSize: 16.2, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15.2,
                    ),
                    Text("${phone}",
                        style: TextStyle(
                            fontSize: 12.2, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 15.5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //  logoutService.logOut(code: code,phone: number,redirect_url: 'http://localhost:8080',token: jwtToken,).then((value) => {
                        html.window.location.href = '/';
                        Navigator.pop(context);
                        setState(() {
                          // }),
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(
                              color: Color.fromARGB(
                                  255, 48, 48, 48)), // Set border color
                        ),
                        fixedSize: Size(130, 35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.2, bottom: 4.2),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 62, 62, 62)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
