import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';

// product_search_bar
class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key, required this.onChanged});

  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),

      child: TextFormField(
        onChanged: onChanged,

        style: TextStyle(
          fontSize: AppTextSizes.bodyMedium,
          color: AppColors.headingText,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          hintText: 'Search products...',

          hintStyle: TextStyle(
            fontSize: AppTextSizes.bodyMedium,
            color: AppColors.hintText,
          ),

          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),

            child: Icon(
              Icons.search_rounded,
              size: AppTextSizes.iconMedium,
              color: AppColors.iconGrey,
            ),
          ),

          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 12.w),

            child: Container(
              width: 34.w,
              height: 34.w,

              margin: EdgeInsets.symmetric(vertical: 6.h),

              decoration: BoxDecoration(
                color: AppColors.primary,

                borderRadius: BorderRadius.circular(10.r),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Icon(
                Icons.tune_rounded,
                size: AppTextSizes.iconSmall,
                color: AppColors.white,
              ),
            ),
          ),

          filled: true,
          fillColor: AppColors.white,

          contentPadding: EdgeInsets.symmetric(vertical: 14.h),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),

            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),

            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),

            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// category_chip
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        alignment: Alignment.center,

        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),

        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,

          borderRadius: BorderRadius.circular(24.r),

          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,

            width: isSelected ? 1.5 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Text(
          label,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppTextSizes.caption,
            fontWeight: FontWeight.w600,

            color: isSelected ? AppColors.white : AppColors.bodyText,

            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
