import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/auth/presentation/widgets/custom_auth_widgets.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,

      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _IconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                  ),

                  Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: AppTextSizes.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headingText,
                    ),
                  ),

                  SizedBox(width: 42.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ── Product Image Preview ──────────────────
                      Container(
                        width: double.infinity,
                        height: 220.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBackground,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                size: 34.sp,
                                color: AppColors.iconGrey,
                              ),
                            ),

                            SizedBox(height: 16.h),

                            Text(
                              'Upload Product Image',
                              style: TextStyle(
                                fontSize: AppTextSizes.bodyMedium,
                                fontWeight: FontWeight.w600,
                                color: AppColors.headingText,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              'JPG, PNG up to 5MB',
                              style: TextStyle(
                                fontSize: AppTextSizes.bodySmall,
                                color: AppColors.bodyText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ── Product Name ───────────────────────────
                      CustomTextField(
                        controller: _titleController,
                        label: 'Product Name',
                        hint: 'Enter product name',
                        prefixIcon: Icons.shopping_bag_outlined,
                      ),

                      SizedBox(height: 16.h),

                      // ── Price ──────────────────────────────────
                      CustomTextField(
                        controller: _priceController,
                        label: 'Price',
                        hint: 'Enter price',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.attach_money_rounded,
                      ),

                      SizedBox(height: 16.h),

                      // ── Category ───────────────────────────────
                      CustomTextField(
                        controller: _categoryController,
                        label: 'Category',
                        hint: 'Enter category',
                        prefixIcon: Icons.category_outlined,
                      ),

                      SizedBox(height: 16.h),

                      // ── Image URL ──────────────────────────────
                      CustomTextField(
                        controller: _imageController,
                        label: 'Image URL',
                        hint: 'Paste image URL',
                        prefixIcon: Icons.link_rounded,
                      ),

                      SizedBox(height: 16.h),

                      // ── Description ────────────────────────────
                      CustomTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Write product description...',
                        maxLines: 5,
                        prefixIcon: Icons.description_outlined,
                      ),

                      SizedBox(height: 32.h),

                      // ── Submit Button ──────────────────────────
                      PrimaryButton(
                        label: 'Add Product',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product Added Successfully'),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Icon Button
// ─────────────────────────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          icon,
          size: AppTextSizes.iconMedium,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}
