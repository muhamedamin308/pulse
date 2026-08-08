import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/config/router/app_router.dart';
import 'package:pulse/core/constants/pulse_colors.dart';
import 'package:pulse/core/constants/pulse_text_styles.dart';
import 'package:pulse/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:pulse/features/auth/presentation/widget/google_sign_in_button.dart';
import 'package:pulse/shared/widget/pulse_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;

    context
        .read<AuthCubit>()
        .signIn(_emailController.text.trim(), _passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(AppRoutes.homeName);
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: PulseColors.error,
          ));
        }
      }, builder: (context, state) {
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
                  const Text('Welcome back', style: PulseTextStyles.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: PulseTextStyles.bodyMedium.copyWith(
                      color: PulseColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                    validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _signIn,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
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
                      const Text("Don't have an account?",
                          style: PulseTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () =>
                            context.goNamed(AppRoutes.registerName),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
