import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/user_database.dart';
import 'package:shop_ez/model/user_model.dart';

class LoginAndSignUpButtons extends StatelessWidget {
  LoginAndSignUpButtons.logIn({
    Key? key,
    required this.type,
    required this.username,
    required this.password,
    required this.formKey,
  }) : super(key: key);
  LoginAndSignUpButtons.signUp({
    Key? key,
    required this.type,
    required this.mobileNumber,
    required this.password,
    required this.email,
    required this.shopName,
    required this.countryName,
    required this.shopCategory,
    required this.formKey,
  }) : super(key: key);

  int type;
  late final String username,
      password,
      mobileNumber,
      email,
      shopName,
      countryName,
      shopCategory;

  GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          minWidth: 150,
          color: mainColor,
          onPressed: () async {
            if (type == 0) {
              await onSignUp(context);
            } else {
              await onLogin(context);
            }
          },
          child: Text(
            type == 1 ? 'Login' : 'Sign Up',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
            kWidth10,
            Text('or'),
            kWidth10,
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        MaterialButton(
          minWidth: 150,
          color: Colors.grey[300],
          onPressed: () {
            if (type == 1) {
              Navigator.pushReplacementNamed(context, routeSignUp);
            } else {
              Navigator.pushReplacementNamed(context, routeLogin);
            }
          },
          child: Text(type == 1 ? 'Sign Up' : 'Login'),
        ),
      ],
    );
  }

//========== Login and Verification ==========
  Future<void> onLogin(BuildContext context) async {
    log('username == $username');
    log('password == $password');

    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      try {
        final result =
            await UserDatabase.instance.loginUser(username, password);
        log('User found! = $result');
        Navigator.pushReplacementNamed(context, routeHome);
      } catch (e) {
        log(e.toString());
        showSnackBar(
            context: context, content: 'Incorrect username or password!');
        return;
      }
    }
  }

//========== SignUp and Verification ==========
  Future<void> onSignUp(BuildContext context) async {
    final String _shopName = shopName,
        _countryName = countryName,
        _shopCategory = shopCategory,
        _mobileNumber = mobileNumber,
        _password = password;
    final String? _email = email;

    log(
      'shopName = $_shopName, countryName = $_countryName, shopCategory = $_shopCategory, phoneNumber = $_mobileNumber, email = $_email, password = $_password',
    );

    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      isFormValid.save();

      final _user = UserModel(
        shopName: _shopName,
        countryName: _countryName,
        shopCategory: _shopCategory,
        mobileNumber: _mobileNumber,
        email: _email,
        password: _password,
      );
      try {
        await UserDatabase.instance.createUser(_user, _mobileNumber);
        showSnackBar(context: context, content: "User Registered Successfuly!");
        Navigator.pushReplacementNamed(context, routeHome);
        return;
      } catch (e) {
        showSnackBar(context: context, content: "Username Already Exist!");
        return;
      }
    } else {
      // if (_username.isEmpty || _email!.isEmpty || _password.isEmpty) {
      //   log('Feilds cannot be empty!');
      //   showSnackBar(context: context, content: "Feilds Can't Be Empty!");
      //   return;
      // }
    }
  }

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        // backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
