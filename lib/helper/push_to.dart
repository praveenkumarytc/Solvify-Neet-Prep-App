import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

pushTo(BuildContext context, route) => Navigator.push(context, MaterialPageRoute(builder: (context) => route));
pushToCuper(BuildContext context, route) => Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
popPage(BuildContext context) => Navigator.pop(context);
