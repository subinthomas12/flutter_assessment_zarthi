import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    // Dummy product data
    final Map<String, dynamic> product = {
      "id": id,
      "title": "iPhone 15 Pro Max",
      "category": "Electronics",
      "price": 1299.99,
      "rating": 4.8,
      "description":
          "The iPhone 15 Pro Max features a titanium design, A17 Pro chip, advanced camera system, and all-day battery life.",
      "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
    };

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
                    'Product Details',
                    style: TextStyle(
                      fontSize: AppTextSizes.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headingText,
                    ),
                  ),

                  _IconButton(
                    icon: Icons.favorite_border_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Product Image ─────────────────────────────
                    Container(
                      width: double.infinity,
                      height: 300.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: CachedNetworkImage(
                          imageUrl: product['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Category ─────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        product['category'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: AppTextSizes.caption,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Title ────────────────────────────────────
                    Text(
                      product['title'],
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headingText,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // ── Rating Row ───────────────────────────────
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 20.sp,
                        ),

                        SizedBox(width: 4.w),

                        Text(
                          product['rating'].toString(),
                          style: TextStyle(
                            fontSize: AppTextSizes.bodyMedium,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Text(
                          '(120 Reviews)',
                          style: TextStyle(
                            fontSize: AppTextSizes.bodySmall,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ── Description ──────────────────────────────
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: AppTextSizes.bodyLarge,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headingText,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      product['description'],
                      style: TextStyle(
                        fontSize: AppTextSizes.bodyMedium,
                        color: AppColors.bodyText,
                        height: 1.7,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ── Price + Button ──────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: AppTextSizes.bodySmall,
                                    color: AppColors.bodyText,
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  '\$${product['price']}',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 14.w),

                        Expanded(
                          child: SizedBox(
                            height: 68.h,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: AppTextSizes.bodyLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),
                  ],
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
