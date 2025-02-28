import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/controllers/login_controller.dart';
import 'package:hris_rs_hamori/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController loginController = Get.put(LoginController());
  final RxBool rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF39CCCC), // Teal
                      Color(0xFF001F3F), // Navy
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Content on top of background
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'HRIS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      // Email Input
                      TextField(
                        controller: loginController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 100),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Password Input
                      TextField(
                        controller: loginController.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black87),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 100),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Remember Me Checkbox
                      Obx(() => CheckboxListTile(
                            title: Text("Remember Me",
                                style: TextStyle(color: Colors.white)),
                            value: rememberMe.value,
                            onChanged: (newValue) {
                              rememberMe.value = newValue!;
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          )),
                      SizedBox(height: 20),
                      // Login Button
                      Obx(() => loginController.isLoading.value
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  hamoriLightTiel.withAlpha(150)),
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF001F3F), // Navy
                                    Color(0xFF39CCCC), // Teal
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (rememberMe.value) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('email',
                                        loginController.emailController.text);
                                    await prefs.setString(
                                        'password',
                                        loginController
                                            .passwordController.text);
                                    await prefs.setBool(
                                        'rememberMe', rememberMe.value);
                                  }
                                  loginController.login();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // Make button transparent
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
