import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRememberedLogin();
  }

  void login() async {
    isLoading(true);
    bool isSuccess = await ApiService.login(
      emailController.text,
      passwordController.text,
    );
    isLoading(false);

    if (isSuccess) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar(
        'Error',
        'Login gagal. Cek email dan password!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void loadRememberedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
    }
  }
}
