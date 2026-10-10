import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/brand_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void submit() {
    final errors = [
      Validators.name(name.text),
      Validators.email(email.text),
      Validators.password(password.text),
      Validators.confirmPassword(confirm.text, password.text),
    ].whereType<String>().toList();
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errors.first)));
      return;
    }
    context.read<AuthCubit>().signUp(
      fullName: name.text.trim(),
      email: email.text.trim(),
      password: password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is AuthAuthenticated) Navigator.pop(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandHeader(title: 'JOIN US', compact: true),
                    const SizedBox(height: 24),
                    const Text(
                      'Join ConnectMe',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your community profile in a few seconds.',
                      style: TextStyle(color: AppTheme.muted),
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                      controller: name,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 14),
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: confirm,
                      label: 'Confirm Password',
                      icon: Icons.lock_reset_outlined,
                      obscureText: true,
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
                              : const Text('Create Account'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
