import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snowchat_ios/core/ui/loading_overlay.dart';
import 'package:snowchat_ios/feature/misc/presentation/ui/core.dart';

import '../../../../core/ui/app_color.dart';
import '../../../../core/ui/buttons.dart';
import '../../../navigation/routes.dart';
import '../presentationLogic/register_controller.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return LoadingOverlay(
          isLoading: isLoading,
          content: GenericScreen(content:  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColor.primary,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Verify Code",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.headingText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please enter your 6-digit code sent to your phone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6, // Updated for 6 input fields
                            (index) => SizedBox(
                          width: 50,
                          height: 60,
                          child: TextField(
                            controller: _controllers[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                BorderSide(color: Colors.grey[400]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                const BorderSide(color: AppColor.primary),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't receive code? ",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.sendVerificationCode();
                          },
                          child: const Text(
                            "Send again",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RoundedButton(
                      label: "Verify",
                      height: 48,
                      onPressed: () async {
                        final code = _controllers.map((c) => c.text).join();
                        if (await controller.confirmVerification(code)) {
                          Navigation.gotoLogin(context); // Navigate after verifying
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ))
      );
    });
  }
}
