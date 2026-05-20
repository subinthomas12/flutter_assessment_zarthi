// lib/features/products/presentation/screens/product_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/products/domain/entities/product_entity.dart';
import 'package:product_management_app/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(
          FetchProductDetailEvent(widget.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailInitial ||
                state is ProductDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductDetailError) {
              return _ErrorState(
                message: state.message,
                onRetry: () {
                  context.read<ProductDetailBloc>().add(
                        FetchProductDetailEvent(widget.id),
                      );
                },
              );
            }

            if (state is ProductDetailLoaded) {
              return _ProductDetailContent(
                product: state.product,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                      ),
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
                    product.category.toUpperCase(),
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
                  product.title,
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
                      product.rating.rate.toString(),
                      style: TextStyle(
                        fontSize: AppTextSizes.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '(${product.rating.count} Reviews)',
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
                  product.description,
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
                          borderRadius:
                              BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize:
                                    AppTextSizes.bodySmall,
                                color: AppColors.bodyText,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
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
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primary,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16.r,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize:
                                  AppTextSizes.bodyLarge,
                              fontWeight:
                                  FontWeight.w600,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Error State
// ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 56.sp,
              color: Colors.redAccent,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    AppTextSizes.bodyMedium,
                color: AppColors.bodyText,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reusable Icon Button
// ─────────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
  });

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
          borderRadius:
              BorderRadius.circular(14.r),
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