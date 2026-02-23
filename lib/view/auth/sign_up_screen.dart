import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = false;

  Future<void> _handleSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    // 🔹 Required fields
    if (email.isEmpty || password.isEmpty || phone.isEmpty) {
      _showMessage("All fields are required");
      return;
    }

    // 🔹 Email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showMessage("Enter a valid email");
      return;
    }

    // 🔹 Phone validation
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showMessage("Enter valid 10-digit phone number");
      return;
    }

    // 🔹 Password validation
    if (password.length < 6) {
      _showMessage("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1️⃣ Create email/password user
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2️⃣ Send OTP
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$phone",

        verificationCompleted: (PhoneAuthCredential credential) async {
          await userCredential.user?.linkWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) async {
          setState(() => isLoading = false);

          _showMessage(e.message ?? "Verification failed");

          await userCredential.user?.delete();
        },

        codeSent: (verificationId, resendToken) {
          setState(() => isLoading = false);

          context.push(
            '/otp',
            extra: {"verificationId": verificationId},
          );
        },

        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      _showMessage(e.message ?? "Sign up failed");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
                      child: const Text(
                        "Sign in",
                        style: TextStyle(color: Colors.blue),
                      ),
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
                          if (success && mounted) context.go('/home');
                          if (authVM.errorMessage != null && mounted) {
                            SnackbarHelper.showSnackBar(
                              context,
                              authVM.errorMessage!,
                            );
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
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
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () =>
                            setState(() => obscurePassword = !obscurePassword),
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
                  text: isLoading ? "Please wait..." : "Sign Up",
                  onTap: _handleSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Align(alignment: Alignment.centerLeft, child: Text(text));

  Widget socialButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap:
          Provider.of<AuthViewModel>(context, listen: false).isLoading
              ? null
              : onTap,
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
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
