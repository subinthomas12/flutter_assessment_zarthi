import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/auth/presentation/widgets/custom_auth_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                _HeaderSection(
                  title: 'Welcome back',
                  subtitle: 'Sign in to continue to your account',
                ),

                SizedBox(height: 48.h),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),

                SizedBox(height: 16.h),

                ValueListenableBuilder<bool>(
                  valueListenable: _passwordVisible,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      obscureText: !visible,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        onPressed: () => _passwordVisible.value = !visible,
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

                PrimaryButton(
                  label: 'Sign in',
                  onPressed: () {
                    context.go('/products');
                  },
                ),

                SizedBox(height: 32.h),

                const _OrDivider(),

                SizedBox(height: 32.h),

                _AuthRedirectRow(
                  question: "Don't have an account?",
                  actionLabel: 'Sign up',
                  onTap: () => context.go('/signup'),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.title, required this.subtitle});

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
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
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
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
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
