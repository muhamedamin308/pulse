import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/widget/pulse_text_field.dart';
import 'package:pulse/features/auth/presentation/widget/google_sign_in_button.dart';
import '../../../../core/constants/pulse_colors.dart';
import '../../../../core/constants/pulse_text_styles.dart';
import '../bloc/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(AppRoutes.homeName);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: PulseColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text('Create account',
                        style: PulseTextStyles.displayMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Join Pulse today',
                      style: PulseTextStyles.bodyMedium.copyWith(
                        color: PulseColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    PulseTextField(
                      hint: 'Full name',
                      controller: _nameController,
                      validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 14),
                    PulseTextField(
                      hint: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(height: 14),
                    PulseTextField(
                      hint: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (v) =>
                          v!.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _signUp,
                        child: isLoading
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
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: PulseColors.divider)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or', style: PulseTextStyles.bodySmall),
                        ),
                        Expanded(child: Divider(color: PulseColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GoogleSignInButton(
                      isLoading: isLoading,
                      onTap: () => context.read<AuthCubit>().signInWithGoogle(),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?',
                            style: PulseTextStyles.bodyMedium),
                        TextButton(
                          onPressed: () => context.goNamed(AppRoutes.loginName),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
