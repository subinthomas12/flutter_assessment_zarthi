// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:product_management_app/features/auth/presentation/widgets/custom_auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVisible.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginBloc>().add(
          LoginSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${state.user.name}'),
              backgroundColor: Colors.green,
            ),
          );

          context.go('/products');
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),

                  const _HeaderSection(
                    title: 'Welcome back',
                    subtitle: 'Sign in to continue to your account',
                  ),

                  SizedBox(height: 48.h),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email address',
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: Validators.email,
                  ),

                  SizedBox(height: 16.h),

                  // Password Field
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordVisible,
                    builder: (_, visible, __) {
                      return CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        obscureText: !visible,
                        prefixIcon: Icons.lock_outline_rounded,

                        // Only check if password is empty
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },

                        suffixIcon: IconButton(
                          onPressed: () {
                            _passwordVisible.value = !visible;
                          },
                          icon: Icon(
                            visible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: AppTextSizes.iconMedium,
                            color: AppColors.iconGrey,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: AppTextSizes.bodySmall,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Sign In Button
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      final isLoading = state is LoginLoading;

                      return PrimaryButton(
                        label: isLoading
                            ? 'Signing in...'
                            : 'Sign in',
                        onPressed:
                            isLoading ? () {} : _submitLogin,
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  const _OrDivider(),

                  SizedBox(height: 32.h),

                  // Sign Up Redirect
                  _AuthRedirectRow(
                    question: "Don't have an account?",
                    actionLabel: 'Sign up',
                    onTap: () => context.go('/signup'),
                  ),

                  SizedBox(height: 40.h),

                  // Demo Credentials
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(16.w),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.white,
                  //     borderRadius: BorderRadius.circular(12.r),
                  //     border: Border.all(
                  //       color: AppColors.border,
                  //     ),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment:
                  //         CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Demo Credentials',
                  //         style: TextStyle(
                  //           fontSize:
                  //               AppTextSizes.bodyMedium,
                  //           fontWeight: FontWeight.w600,
                  //           color:
                  //               AppColors.headingText,
                  //         ),
                  //       ),
                  //       SizedBox(height: 8.h),
                  //       Text(
                  //         'Email: admin@example.com',
                  //         style: TextStyle(
                  //           fontSize:
                  //               AppTextSizes.bodySmall,
                  //           color: AppColors.bodyText,
                  //         ),
                  //       ),
                  //       Text(
                  //         'Password: 123456',
                  //         style: TextStyle(
                  //           fontSize:
                  //               AppTextSizes.bodySmall,
                  //           color: AppColors.bodyText,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.shopping_cart,
            color: AppColors.white,
            size: AppTextSizes.iconLarge,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          title,
          style: TextStyle(
            fontSize: AppTextSizes.headingLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.headingText,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: AppTextSizes.bodyLarge,
            color: AppColors.bodyText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.border,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: AppTextSizes.bodySmall,
              color: AppColors.hintText,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.border,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _AuthRedirectRow extends StatelessWidget {
  const _AuthRedirectRow({
    required this.question,
    required this.actionLabel,
    required this.onTap,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: AppTextSizes.bodyMedium,
            color: AppColors.bodyText,
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: AppTextSizes.bodyMedium,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}