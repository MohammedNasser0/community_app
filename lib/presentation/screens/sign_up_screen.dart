import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../widgets/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isFirstLetterUppercase(String value) {
    if (value.isEmpty) {
      return false;
    }

    return value[0] == value[0].toUpperCase() &&
        value[0] != value[0].toLowerCase();
  }

  void _signUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || !_isFirstLetterUppercase(name)) {
      _showMessage('Full Name must start with a capital letter.');
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Please enter a valid email.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    context.read<AuthCubit>().signUp(
      fullName: name,
      email: email,
      password: password,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              _showMessage(state.message);
            }

            if (state is AuthAuthenticated) {
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.person_add_alt_1, size: 70),
                const SizedBox(height: 30),
                AuthTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock_reset_outlined,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: loading ? null : _signUp,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text('Create Account'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
