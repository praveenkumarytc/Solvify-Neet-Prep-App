import 'package:flutter/cupertino.dart';

pushTo(BuildContext context, route) => Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
pushToCuper(BuildContext context, route) => Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
popPage(BuildContext context) => Navigator.pop(context);
