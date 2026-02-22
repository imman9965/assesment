import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/snackbar_helper.dart';
import '../../core/helpers/widgets/textfield.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/helpers/widgets/common_button.dart';  // your existing widget

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool obscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 8.2),
                    const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Need an account? "),
                        GestureDetector(
                          onTap: () => context.push('/signup'),
                          child: const Text("Sign up", style: TextStyle(color: Colors.blue)),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: _socialButton(
                            icon: FontAwesomeIcons.google,
                            text: "Use Google",
                            onTap: () async {
                              bool success = await authVM.signInWithGoogle();
                              if (success && mounted) context.go('/home');
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Password"),
                        GestureDetector(
                          onTap: () async {
                            bool success = await authVM.resetPassword(emailController.text);
                            if (success && mounted) {
                              SnackbarHelper.showSnackBar(context, "Password reset email sent");
                            } else if (authVM.errorMessage != null && mounted) {
                              SnackbarHelper.showSnackBar(context, authVM.errorMessage!);
                            }
                          },
                          child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      controller: passwordController,
                      hint: "Enter Password",
                      obscureText: obscure,
                      suffix: IconButton(
                        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CommonButton(
                      text: "Sign In",
                      onTap: () async {
                        bool success = await authVM.signInWithEmail(
                          emailController.text,
                          passwordController.text,
                        );
                        if (success && mounted) context.go('/home');
                        if (authVM.errorMessage != null && mounted) {
                          SnackbarHelper.showSnackBar(context, authVM.errorMessage!);
                        }
                      },
                      isLoading: authVM.isLoading,
                    ),
                  ],
                ),
              ),
            ),
            if (authVM.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(alignment: Alignment.centerLeft, child: Text(text));

  Widget _socialButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: Provider.of<AuthViewModel>(context, listen: false).isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
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