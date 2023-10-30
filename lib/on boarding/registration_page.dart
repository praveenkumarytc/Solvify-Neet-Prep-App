import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/Utils/textstyle.dart';
import 'package:shield_neet/components/animated_button.dart';
import 'package:shield_neet/home/dashboard.dart';
import 'package:shield_neet/models/user_model.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:velocity_x/velocity_x.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    required this.emailId,
    required this.fullName,
    required this.loginMethod,
    this.password,
    this.uid,
  });
  final String emailId, fullName, loginMethod;
  final String? uid, password;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String batch = '2023-2024'; // Default batch value
  final TextEditingController stateController = TextEditingController();
  String state = "Select";
  String avatar = ''; // Store the selected avatar image URL here

  List<UserAvtarModel> genderList = userAvtarModel;

  int? selectedAvtarID;

  Gender _gender = Gender.unkown;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.COLOR_PRIMARY_blue,
        elevation: 0,
        title: const Text('Registration Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(Images.APP_LOGO_TRANS_BG),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Name",
              style: blackButtonText,
            ),
            LoginTextField(
              hintText: 'Full Name',
              controller: nameController,
            ),
            const SizedBox(height: 10),
            const Text(
              "Phone Number",
              style: blackButtonText,
            ),
            LoginTextField(
              hintText: 'Phone',
              controller: phoneController,
            ),
            15.heightBox,
            const Text(
              "Gender",
              style: blackButtonText,
            ),
            Row(
              children: [
                RadioMenuButton(
                    toggleable: true,
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                        print(value);
                        genderList = userAvtarModel.where((element) => element.gender == _gender).toList();
                      });
                      if (selectedAvtarID != null) {
                        selectedAvtarID = null;
                      }
                    },
                    child: Text(Gender.male.name.toUpperCase())),
                10.widthBox,
                RadioMenuButton(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                      print(value);
                      genderList = userAvtarModel.where((element) => element.gender == _gender).toList();
                      if (selectedAvtarID != null) {
                        selectedAvtarID = null;
                      }
                    },
                    child: Text(Gender.female.name.toUpperCase()))
              ],
            ),
            SizedBox(
              height: 100, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genderList.length,
                itemBuilder: (context, index) {
                  bool isSelected = genderList[index].id == selectedAvtarID; // Check if the avatar is selected
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvtarID = genderList[index].id;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey[300]!, // Set border color based on selection
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(genderList[index].image), // Load the avatar image
                          backgroundColor: Colors.transparent, // Transparent background for CircleAvatar
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            15.heightBox,
            Text(
              "Batch",
              style: blackButtonText,
            ),
            10.heightBox,
            DropdownButtonFormField<String>(
              value: batch,
              onChanged: (String? newValue) {
                setState(() {
                  batch = newValue!;
                });
              },
              decoration: loginTextFieldDecoration(''),
              items: <String>[
                '2023-2024',
                '2023-2025',
                // Add more batch options if needed
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            15.heightBox,
            Text(
              "State",
              style: blackButtonText,
            ),
            10.heightBox,
            DropdownButtonFormField<String>(
              value: state,
              decoration: loginTextFieldDecoration(''),
              onChanged: (String? newValue) {
                setState(() {
                  state = newValue!;
                });
              },
              items: indianStates.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            AnimatedButton(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .createNewUser(
                  context,
                  selectedAvtarID!,
                  nameController.text.trim(),
                  widget.emailId,
                  widget.fullName,
                  phoneController.text,
                  widget.uid,
                  batch,
                  widget.loginMethod,
                  state,
                )
                    .then((value) {
                  if (value!) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashBoard(),
                        ),
                        (route) => false);
                  }
                });
                // Create a User object with the entered data
                // User newUser = User(
                //   name: nameController.text,
                //   phone: phoneController.text,
                //   batch: batch,
                //   state: stateController.text,
                //   avatar: avatar,
                // );

                // Print or use the newUser object as needed
                // print(newUser);

                // You can navigate to the next screen or perform other actions here
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                height: 55,
                decoration: const BoxDecoration(color: ColorResources.PRIMARY_MATERIAL, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.focusNode,
    this.requestFocusNode,
    this.controller,
    this.isEnabled = true,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String hintText;
  final FocusNode? focusNode, requestFocusNode;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(color: Colors.black),
        decoration: loginTextFieldDecoration(hintText),
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        focusNode: focusNode,
        onFieldSubmitted: (term) {
          if (focusNode != null) {
            focusNode!.unfocus();
          }

          if (requestFocusNode != null) {
            requestFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}

List<String> indianStates = [
  "Select",
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chhattisgarh",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal",
];
