import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paradox/models/brightness_options.dart';
import 'package:paradox/models/user.dart';
import 'package:paradox/providers/referral_provider.dart';
import 'package:paradox/providers/theme_provider.dart';
import 'package:paradox/providers/user_provider.dart';
import 'package:paradox/utilities/Toast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ReferralScreen extends StatefulWidget {
  static String routeName = "/referral-Screen";

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool loader = false;
  TextEditingController referralCodeController = new TextEditingController();

  @override
  void dispose() {
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: true).user;
    final availReferral =
        Provider.of<ReferralProvider>(context, listen: true).availReferral;
    print(user.referralAvailed);
    final brightness = Provider.of<ThemeProvider>(context, listen: true).brightnessOption;

    return Scaffold(
      appBar: AppBar(
        title: Text("Referral".toUpperCase(),
          style: TextStyle(
            fontWeight: brightness == BrightnessOption.light ? FontWeight.w400 : FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            if (user.referralAvailed == false)
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Avail Referral",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: brightness == BrightnessOption.light ? FontWeight.w500: FontWeight.w400,
                          letterSpacing: 3,
                          color: brightness == BrightnessOption.light ? Colors.blue:  Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        readOnly: loader,
                        controller: referralCodeController,
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Referral Code',
                          hintText: 'Enter Referral Code',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: new BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: new BorderSide(
                                width: 2, color: Colors.grey[200]),
                          ),
                          suffixIcon: Icon(
                            Icons.screen_share,
                            color: brightness == BrightnessOption.light ? Colors.grey[300] : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (user.referralAvailed == false)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  width: double.infinity,
                  child: MaterialButton(
                      height: 50,
                      color: Colors.blue,
                      onPressed: !loader
                          ? () async {
                        setState(() {
                          loader = true;
                        });
                        print(referralCodeController.text);
                        if (referralCodeController.text == null ||
                            // ignore: unrelated_type_equality_checks
                            referralCodeController.text == "") {
                          createToast("Enter Referral Code");
                        } else {
                          final res = await availReferral(
                              referralCodeController.text, user.uid);
                          if (res == true) {
                            await Provider.of<UserProvider>(context,
                                listen: true)
                                .fetchUserDetails();
                          }
                        }
                        setState(() {
                          loader = false;
                        });
                      }
                          : () {},
                      child: !loader
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Avail Referral Code',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                          : SpinKitCircle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ),
            if (user.referralAvailed == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Referral Code Already Availed.",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 15,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Divider()
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Share Your Referral Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: brightness == BrightnessOption.light ? FontWeight.w500: FontWeight.w400,
                letterSpacing: 2,
                color: brightness == BrightnessOption.light ? Colors.blue:  Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                FlatButton(
                  onPressed: () {},
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 2),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                        child: Text("Your Referral Code: " + user.referralCode,
                            style:
                            TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
                      )),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  child: FittedBox(
                    child: IconButton(
                        icon: Icon(
                          Icons.share,
                          size: 27,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Share.share(
                              'Download Paradox from https://play.google.com/store/apps/details?id=com.exe.paradoxplay and use my referral code: ${user.referralAvailed} and earn 50 coins.');
                        }),
                  ),
                ),
                Spacer(),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
