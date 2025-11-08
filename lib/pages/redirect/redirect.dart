import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();
    validateToken();
  }

  validateToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString('userToken');

    if (userToken != null && userToken.toString() != 'null') {
      if (mounted) {
        context.go('/home');
      }
    } else {
      if (mounted) {
        context.go('/signin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(Strings.logoImageName),
    );
  }
}
