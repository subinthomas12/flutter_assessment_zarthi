// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/products/presentation/screens/product_card.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Map<String, dynamic> product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.border,
            width: 0.5,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(imageUrl: product['image']),

            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  10.w,
                  8.h,
                  10.w,
                  10.h,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius:
                            BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        product['category']
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      product['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize:
                            AppTextSizes.caption,
                        fontWeight: FontWeight.w500,
                        color: AppColors.headingText,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            fontSize:
                                AppTextSizes.bodyMedium,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),

                        _RatingBadge(
                          rating: product['rating'],
                        ),
                      ],
                    ),
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

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(16.r)),
      child: SizedBox(
        height: 130.h,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,

          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: AppColors.border,
            highlightColor:
                AppColors.scaffoldBackground,
            child: Container(
              color: AppColors.white,
            ),
          ),

          errorWidget: (_, __, ___) => Container(
            color: AppColors.scaffoldBackground,
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 40.sp,
              color: AppColors.hintText,
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          size: 13.sp,
          color: Colors.amber,
        ),

        SizedBox(width: 2.w),

        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}