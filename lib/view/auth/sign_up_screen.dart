import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/snackbar_helper.dart';
import '../../core/helpers/widgets/textfield.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/helpers/widgets/common_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account? "),
                    GestureDetector(
                      onTap: () => context.go('/signin'),
                      child: const Text("Sign in", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: socialButton(
                        icon: FontAwesomeIcons.google,
                        text: "Use Google",
                        onTap: () async {
                          bool success = await authVM.signInWithGoogle();
                          if (success && mounted) context.go('/otp');
                          if (authVM.errorMessage != null && mounted) {
                            SnackbarHelper.showSnackBar(context, authVM.errorMessage!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR")),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                _label("Email"),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: emailController,
                  hint: "email@email.com",
                ),
                const SizedBox(height: 16),
                _label("Password"),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: passwordController,
                  hint: "Enter Password",
                  obscureText: obscurePassword,
                  suffix: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
                const SizedBox(height: 16),
                _label("Mobile Number"),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: phoneController,
                  hint: "Mobile Number",
                ),
                const SizedBox(height: 24),
                CommonButton(
                  text: authVM.isLoading ? "Please wait..." : "Sign Up",
                  onTap: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final phone = phoneController.text.trim();

                    // Validation
                    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
                      SnackbarHelper.showSnackBar(context, "All fields are required");
                      return;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                      SnackbarHelper.showSnackBar(context, "Enter a valid email");
                      return;
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                      SnackbarHelper.showSnackBar(context, "Enter valid 10-digit phone number");
                      return;
                    }
                    if (password.length < 6) {
                      SnackbarHelper.showSnackBar(context, "Password must be at least 6 characters");
                      return;
                    }

                    bool emailCreated = await authVM.signUpWithEmail(email, password);
                    if (!emailCreated) {
                      if (authVM.errorMessage != null) {
                        SnackbarHelper.showSnackBar(context, authVM.errorMessage!);
                      }
                      return;
                    }

                    String? verificationId = await authVM.sendOtp(phone);
                    if (verificationId != null && mounted) {
                      context.push('/otp', extra: {"verificationId": verificationId});
                    } else if (authVM.errorMessage != null) {
                      SnackbarHelper.showSnackBar(context, authVM.errorMessage!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Align(alignment: Alignment.centerLeft, child: Text(text));

  Widget socialButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: Provider.of<AuthViewModel>(context, listen: false).isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}