import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/validators.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../widgets/auth_text_field.dart';
import 'sign_up_screen.dart';
import '../widgets/brand_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    final emailError = Validators.email(email.text);
    final passwordError = Validators.password(password.text);
    if (emailError != null || passwordError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(emailError ?? passwordError!)));
      return;
    }
    context.read<AuthCubit>().login(
      email: email.text.trim(),
      password: password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width > 700 ? width * .25 : 24,
              vertical: 32,
            ),
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandHeader(),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: email,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: password,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: obscure,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state is AuthLoading ? null : submit,
                        child: state is AuthLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Log In'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      ),
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
