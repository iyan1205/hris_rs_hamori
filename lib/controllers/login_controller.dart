import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/views/home_screen.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      Get.snackbar('Error', 'Login gagal. Cek email dan password!');
    }
  }
}
