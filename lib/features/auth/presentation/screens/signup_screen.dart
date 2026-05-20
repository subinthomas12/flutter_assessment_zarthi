import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/auth/presentation/widgets/custom_auth_widgets.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordVisible = ValueNotifier<bool>(false);
  final _confirmPasswordVisible = ValueNotifier<bool>(false);

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
                SizedBox(height: 48.h),

                // ── Back button ──────────────────────────────────────
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: AppTextSizes.iconMedium,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // ── Header ──────────────────────────────────────────
                _SignupHeader(),

                SizedBox(height: 36.h),

                // ── Full Name ────────────────────────────────────────
                CustomTextField(
                  controller: _fullNameController,
                  label: 'Full name',
                  hint: 'John Appleseed',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.fullName,
                ),

                SizedBox(height: 16.h),

                // ── Email ────────────────────────────────────────────
                CustomTextField(
                  controller: _emailController,
                  label: 'Email address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                ),

                SizedBox(height: 16.h),

                // ── Phone ────────────────────────────────────────────
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  hint: '+91 98765 43210',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: Validators.phone,
                ),

                SizedBox(height: 16.h),

                // ── Password ─────────────────────────────────────────
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordVisible,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      obscureText: !visible,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                      suffixIcon: _VisibilityToggle(
                        visible: visible,
                        onToggle: () => _passwordVisible.value = !visible,
                      ),
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // ── Confirm Password ─────────────────────────────────
                ValueListenableBuilder<bool>(
                  valueListenable: _confirmPasswordVisible,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm password',
                      hint: 'Re-enter password',
                      obscureText: !visible,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      suffixIcon: _VisibilityToggle(
                        visible: visible,
                        onToggle: () =>
                            _confirmPasswordVisible.value = !visible,
                      ),
                    );
                  },
                ),

                SizedBox(height: 12.h),

                // ── Password strength hint ───────────────────────────
                _PasswordHint(),

                SizedBox(height: 32.h),

                // ── Submit button ────────────────────────────────────
                PrimaryButton(label: 'Create account', onPressed: () {}),

                SizedBox(height: 24.h),

                // ── Terms note ───────────────────────────────────────
                _TermsNote(),

                SizedBox(height: 24.h),

                // ── Login redirect ───────────────────────────────────
                _AuthRedirectRow(
                  question: 'Already have an account?',
                  actionLabel: 'Sign in',
                  onTap: () => context.go('/login'),
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

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SignupHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create account',
          style: TextStyle(
            fontSize: AppTextSizes.headingLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.headingText,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Fill in your details to get started',
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

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({required this.visible, required this.onToggle});

  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: AppTextSizes.iconMedium,
        color: AppColors.iconGrey,
      ),
    );
  }
}

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: AppTextSizes.iconSmall,
          color: AppColors.hintText,
        ),
        SizedBox(width: 6.w),
        Text(
          'Use 8+ characters with letters, numbers & symbols',
          style: TextStyle(
            fontSize: AppTextSizes.caption,
            color: AppColors.hintText,
          ),
        ),
      ],
    );
  }
}

class _TermsNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: AppTextSizes.caption,
            color: AppColors.hintText,
            height: 1.6,
          ),
          children: const [
            TextSpan(text: 'By creating an account, you agree to our\n'),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
