import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_event/app/modules/dashboard/views/dashboard_view.dart';
import 'package:getx_event/app/utils/api.dart';

class RegisterController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final authToken = GetStorage();

  void registerNow() async {
    final response = await _getConnect.post(
      BaseUrl.register,
      {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text,
      },
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      print('Registration successful: ${response.body}');
      authToken.write('token', response.body['token']);
      Get.snackbar('Success', 'Registration successful');
      Get.offAll(() => const DashboardView());
    } else {
      print('Registration error: ${response.statusCode}');
      print('Response body: ${response.body}');
      Get.snackbar(
        'Error',
        response.body['message'] ?? 'Registration failed',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        // forwardAnimationCurve: Curves.bounceIn,
        // margin: const EdgeInsets.only(
        //   top: 10,
        //   left: 5,
        //   right: 5,
        // ),
      );
    } Catch(e) { 
      print('Exception during resgistration: $e');
      Get.snackbar( 
        'Error', 
        'An error occurred during registration.',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        );
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }
}
