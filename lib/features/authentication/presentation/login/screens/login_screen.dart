import 'package:clean_architecture_getx/res/strings/string_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/dev_functions/dev_auto_fill_button.dart';
import '../../../../../res/resources.dart';
import '../../../../trades/presentation/screens/trades_screen.dart';
import '../login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenController _controller = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DevAutoFillButton(onPressed: _controller.devAutoFill),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const _Icon(),
              const SizedBox(height: 16),
              const _Text(),
              const SizedBox(height: 16),
              _UserNameInput(),
              const SizedBox(height: 16),
              _PasswordInput(),
              const SizedBox(height: 16),
              _SubmitButton(),
            ],
          ),
        ),
      )),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: SvgPicture.asset(Resources.drawable.splashImage),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          TextEnum.loginUpperText.tr,
          style: const TextStyle(
            color: Color(0xFF445164),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          TextEnum.loginDescription.tr,
          style: const TextStyle(
            color: Color(0xFF171930),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _UserNameInput extends StatelessWidget {
  _UserNameInput();

  final LoginScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller.usernameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Username',
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  _PasswordInput();

  final LoginScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller.passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  _SubmitButton();

  final LoginScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(48, 48),
      ),
      onPressed: () async {
        bool success = await _controller.login();
        if (success) {
          Get.offAll(() => TradesScreen());
        }
      },
      child: const Text('Login'),
    );
  }
}
