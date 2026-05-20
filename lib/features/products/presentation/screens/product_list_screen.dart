// lib/features/products/presentation/screens/product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/products/domain/entities/product_entity.dart';
import 'package:product_management_app/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:product_management_app/features/products/presentation/screens/product_card.dart';
import 'package:product_management_app/features/products/presentation/widgets/product_widgets.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(const FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),

            ProductSearchBar(
              onChanged: (value) {
                context.read<ProductListBloc>().add(
                      SearchProductsEvent(value),
                    );
              },
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListLoading ||
                      state is ProductListInitial) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ProductListError) {
                    return _ErrorState(
                      message: state.message,
                      onRetry: () {
                        context.read<ProductListBloc>().add(
                              const FetchProductsEvent(),
                            );
                      },
                    );
                  }

                  if (state is ProductListLoaded) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 42.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: state.categories.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(width: 8.w),
                            itemBuilder: (_, index) {
                              final category =
                                  state.categories[index];

                              return CategoryChip(
                                label: _formatCategory(category),
                                isSelected:
                                    state.selectedCategory ==
                                        category,
                                onTap: () {
                                  context
                                      .read<ProductListBloc>()
                                      .add(
                                        FilterByCategoryEvent(
                                          category,
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 16.h),

                        Expanded(
                          child: state.filteredProducts.isEmpty
                              ? const _EmptyState()
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    context
                                        .read<ProductListBloc>()
                                        .add(
                                          const RefreshProductsEvent(),
                                        );
                                  },
                                  child: GridView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                      16.w,
                                      0,
                                      16.w,
                                      24.h,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.w,
                                      mainAxisSpacing: 10.h,
                                      childAspectRatio: 0.72,
                                    ),
                                    itemCount:
                                        state.filteredProducts.length,
                                    itemBuilder: (_, index) {
                                      final product = state
                                          .filteredProducts[index];

                                      return ProductCard(
                                        product:
                                            _mapProductToJson(
                                          product,
                                        ),
                                        onTap: () {
                                          context.push(
                                            '/products/${product.id}',
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _mapProductToJson(
    ProductEntity product,
  ) {
    return {
      'id': product.id,
      'title': product.title,
      'category': product.category,
      'price': product.price,
      'rating': product.rating.rate,
      'image': product.image,
      'description': product.description,
    };
  }

  String _formatCategory(String category) {
    if (category.toLowerCase() == 'all') {
      return 'All';
    }

    return category
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

// ─────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.headingText,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Find what you\'re looking for',
                style: TextStyle(
                  fontSize:
                      AppTextSizes.bodySmall,
                  color: AppColors.bodyText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _IconBtn(
                icon: Icons.add,
                onTap: () {
                  context.go('/add-product');
                },
              ),
              SizedBox(width: 8.w),
              _IconBtn(
                icon: Icons.shopping_cart_outlined,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
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
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(12.r),
          border:
              Border.all(color: AppColors.border),
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

// ─────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius:
                  BorderRadius.circular(24.r),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 40.sp,
              color: AppColors.hintText,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Try a different search or category',
            style: TextStyle(
              fontSize:
                  AppTextSizes.bodySmall,
              color: AppColors.iconGrey,
            ),
          ),
        ],
      ),
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
        padding:
            EdgeInsets.symmetric(horizontal: 32.w),
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