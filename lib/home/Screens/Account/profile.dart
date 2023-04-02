import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Admin%20App/admin_page.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/helper/log_out_dialog.dart';
import 'package:shield_neet/home/Screens/Account/feedback.dart';
import 'package:shield_neet/home/Screens/Account/privacy_policy.dart';
import 'package:shield_neet/home/Screens/Account/support_page.dart';
import 'package:shield_neet/main.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:shield_neet/splash_page.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // @override
  // void initState() {
  //   @override
  //   void initState() {
  //     // Determine the background color
  //     Color backgroundColor = Colors.white; // Replace with your background color

  //     // Set the status bar text color to light if the background color is dark, and to dark if the background color is light
  //     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //       statusBarColor: Color(0xff608BF7),
  //       statusBarIconBrightness: ThemeData.estimateBrightnessForColor(backgroundColor),
  //     ));
  //     super.initState();
  //   }

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ProfileWidget(name: userData.fullName ?? " ", email: userData.email ?? " "),
            Dimensions.PADDING_SIZE_EXTRA_LARGE.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                tileColor: const Color(0xff608BF7).withOpacity(.08),
                leading: Icon(
                  isDark ? Icons.nightlight : Icons.lightbulb,
                  color: const Color(0xff608BF7).withOpacity(.7),
                ),
                title: const Text(
                  'Theme',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: SizedBox(
                  width: 80,
                  child: FlutterSwitch(
                      activeText: '' /* '🌙'*/,
                      inactiveText: '' /*"🌕" */,
                      activeTextColor: Colors.white,
                      activeTextFontWeight: FontWeight.normal,
                      inactiveToggleColor: Colors.white,
                      inactiveColor: ColorResources.PRIMARY_MATERIAL.withOpacity(.55),
                      activeColor: ColorResources.COLOR_BLUE.withOpacity(.55),
                      inactiveSwitchBorder: Border.all(color: ColorResources.PRIMARY_MATERIAL.withOpacity(.35)),
                      width: 60,
                      height: 35.0,
                      showOnOff: true,
                      activeIcon: const Icon(
                        Icons.dark_mode,
                        color: ColorResources.PRIMARY_MATERIAL,
                      ),
                      inactiveIcon: const Icon(
                        Icons.lightbulb,
                        color: ColorResources.COLOR_BLUE,
                      ),
                      value: isDark,
                      onToggle: (value) {
                        isDark = value;
                        setState(() {});
                      }),
                ),
              ),
            ),
            AccountCards(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ));
              },
              title: 'Feedback',
              isIcon: true,
              icon: Icons.feedback,
            ),
            AccountCards(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SupportPage(),
                    ));
              },
              title: 'Support',
              isIcon: true,
              icon: Icons.contact_support,
            ),
            AccountCards(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ));
              },
              title: 'Privacy Policy',
              isIcon: true,
              icon: Icons.settings,
            ),
            AccountCards(
              onTap: () async {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) => AppInfoDialog(onLogOut: () async {
                    await Provider.of<AuthProvider>(context, listen: false).logOut().then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashPage()), (route) => false);
                    });
                  }),
                );
              },
              title: 'Sign Out',
              isIcon: false,
              icon: Icons.logout,
            )
          ],
        ),
      ),
    );
  }
}

class AccountCards extends StatelessWidget {
  const AccountCards({
    Key? key,
    required this.title,
    required this.isIcon,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final bool isIcon;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: const Color(0xff608BF7).withOpacity(.08),
        leading: Icon(
          icon,
          color: const Color(0xff608BF7).withOpacity(.7),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: isIcon
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              )
            : null,
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.name, required this.email});
  final String name, email;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xff608BF7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            20,
          ),
          bottomRight: Radius.circular(
            20,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPage(),
                      )),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white30,

                      // foregroundColor: ColorResources.WHITE,
                      elevation: 0),
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
            30.heightBox,
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(Images.doctor_profile),
                  ),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
