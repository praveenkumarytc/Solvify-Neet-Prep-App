import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/dimensions.dart';
import 'package:shield_neet/Utils/textstyle.dart';
import 'package:shield_neet/components/animated_button.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var _formKey = GlobalKey<FormState>();

  String? errorMessage;

  bool isRegister = false;
  String? name;
  String? phone;
  String email = '';
  String password = '';

  // bool _loading = false;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _userMobileFocus = FocusNode();
  final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const HelloDoctorsHeading(),

              // SlideFadeSwitcher(child: isRegister ? signupForm(context) : signInWidget(context)),
              isRegister ? signupForm(context) : signInWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Column signupForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 55,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Full Name',
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (String val) {
              setState(() {
                name = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userNameFocus,
            onFieldSubmitted: (term) {
              _userNameFocus.unfocus();
              _userMobileFocus.requestFocus();
            },
          ),
        ),
        Dimensions.PADDING_SIZE_SMALL.heightBox,
        Container(
          height: 55,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            decoration: InputDecoration(
              hintText: 'Mobile No.',
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (String val) {
              setState(() {
                phone = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userMobileFocus,
            onFieldSubmitted: (term) {
              _userMobileFocus.unfocus();
              _userEmailFocus.requestFocus();
            },
          ),
        ),
        Dimensions.PADDING_SIZE_SMALL.heightBox,
        Container(
          height: 55,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (String val) {
              setState(() {
                email = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userEmailFocus,
            onFieldSubmitted: (term) {
              _userEmailFocus.unfocus();
              _userPasswordFocus.requestFocus();
            },
          ),
        ),
        Dimensions.PADDING_SIZE_SMALL.heightBox,
        Container(
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            obscureText: !_passwordVisible,
            onChanged: (String val) {
              setState(() {
                password = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userPasswordFocus,
            onFieldSubmitted: (term) => _userPasswordFocus.unfocus(),
          ),
        ),
        Dimensions.PADDING_SIZE_DEFAULT.heightBox,
        AnimatedButton(
          onTap: () async {
            // print('$name $phone $password $email');
            await Provider.of<AuthProvider>(context, listen: false).signUp(context, name, email, password, phone).then((value) {});
          },
          child: Provider.of<AuthProvider>(context, listen: false).isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  height: 55,
                  decoration: const BoxDecoration(color: ColorResources.PRIMARY_MATERIAL, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Center(
                    child: Text('Register', style: whiteButtonText),
                  ),
                ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedButton(
                  onTap: () {
                    setState(() {
                      isRegister = false;
                    });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(color: isRegister ? Colors.white30 : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                      child: Text('Sign In', style: blackButtonText),
                    ),
                  ),
                ),
                AnimatedButton(
                  onTap: () {
                    setState(() {
                      isRegister = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 45,
                    decoration: BoxDecoration(
                        color: isRegister ? Colors.white : Colors.white30,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: blackButtonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column signInWidget(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 55,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (String val) {
              setState(() {
                email = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userEmailFocus,
            onFieldSubmitted: (term) {
              _userEmailFocus.unfocus();
              _userPasswordFocus.requestFocus();
            },
          ),
        ),
        Dimensions.PADDING_SIZE_SMALL.heightBox,
        Container(
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 14),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            obscureText: !_passwordVisible,
            onChanged: (String val) {
              setState(() {
                password = val;
              });
            },
            textInputAction: TextInputAction.next,
            focusNode: _userPasswordFocus,
            onFieldSubmitted: (term) => _userPasswordFocus.unfocus(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {},
                child: Text(
                  'Recovery Password',
                  style: TextStyle(color: Colors.grey.shade700),
                )),
          ],
        ),
        Dimensions.PADDING_SIZE_DEFAULT.heightBox,
        AnimatedButton(
          onTap: () async {
            if (email.isEmpty) {
              showToast(message: "Enter email", isError: true);
            } else if (password.isEmpty) {
              showToast(message: "Enter password", isError: true);
            } else {
              await Provider.of<AuthProvider>(context, listen: false).signIn(context, email, password);
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            height: 55,
            decoration: const BoxDecoration(color: ColorResources.PRIMARY_MATERIAL, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Center(
              child: Text('Sign In', style: whiteButtonText),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedButton(
                  onTap: () {
                    setState(() {
                      isRegister = false;
                    });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(color: isRegister ? Colors.white30 : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                      child: Text('Sign In', style: blackButtonText),
                    ),
                  ),
                ),
                AnimatedButton(
                  onTap: () {
                    setState(() {
                      isRegister = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 45,
                    decoration: BoxDecoration(
                        color: isRegister ? Colors.white : Colors.white30,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: blackButtonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: const Divider(
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'OR',
                        style: blackButtonText,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: const Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                Dimensions.PADDING_SIZE_DEFAULT.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {}, icon: Image.asset(Images.googleLogo)),
                    const SizedBox(width: 5),
                  ],
                ),
                const Text(
                  'login with',
                  style: TextStyle(color: Color.fromRGBO(117, 117, 117, 1), fontSize: 13, fontWeight: FontWeight.w400),
                ),*/
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomFormField extends StatefulWidget {
  CustomFormField({super.key, required this.currentFocusNode, required this.nextFocusNode, required this.inputText, this.isPassword = false});
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;
  bool isPassword;

  String inputText;
  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  String? email;
  String? password;
  // final FocusNode _userEmailFocus = FocusNode();
  final FocusNode _userPasswordFocus = FocusNode();
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: 'password',
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
          hintStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: ColorResources.COLOR_PRIMARY_blue, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        obscureText: !widget.isPassword,
        onChanged: (String val) {
          setState(() {
            widget.inputText = val;
          });
        },
        textInputAction: TextInputAction.next,
        focusNode: _userPasswordFocus,
        onFieldSubmitted: (term) {
          widget.currentFocusNode.unfocus();
          widget.nextFocusNode.requestFocus();
        },
      ),
    );
  }
}

class HelloDoctorsHeading extends StatelessWidget {
  const HelloDoctorsHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 40,
        ),
        Center(
          child: Text(
            'Hello Future Doctor!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Practice and make your \ndream come true',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ],
    );
  }
}
