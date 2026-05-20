import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/products/presentation/screens/product_card.dart';
import 'package:product_management_app/features/products/presentation/widgets/product_widgets.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "title": "iPhone 15 Pro Max",
      "category": "Electronics",
      "price": 1299.99,
      "rating": 4.8,
      "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
    },
    {
      "id": 2,
      "title": "Nike Air Max",
      "category": "Clothing",
      "price": 149.99,
      "rating": 4.5,
      "image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    },
    {
      "id": 3,
      "title": "Apple Watch Ultra",
      "category": "Electronics",
      "price": 899.99,
      "rating": 4.7,
      "image": "https://images.unsplash.com/photo-1434494878577-86c23bcb06b9",
    },
    {
      "id": 4,
      "title": "Gold Necklace",
      "category": "Jewelery",
      "price": 499.99,
      "rating": 4.3,
      "image": "https://images.unsplash.com/photo-1617038220319-276d3cfab638",
    },
      {
      "id": 5,
      "title": "Apple Watch Ultra",
      "category": "Electronics",
      "price": 899.99,
      "rating": 4.7,
      "image": "https://images.unsplash.com/photo-1434494878577-86c23bcb06b9",
    },
    {
      "id": 6,
      "title": "Gold Necklace",
      "category": "Jewelery",
      "price": 499.99,
      "rating": 4.3,
      "image": "https://images.unsplash.com/photo-1617038220319-276d3cfab638",
    },
  ];

  List<String> categories = ['All', 'Electronics', 'Clothing', 'Jewelery'];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product['category'] == selectedCategory;

      final matchesSearch = product['title'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),

            ProductSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            SizedBox(
              height: 42.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (_, index) {
                  final category = categories[index];

                  return CategoryChip(
                    label: category,
                    isSelected: selectedCategory == category,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: filteredProducts.isEmpty
                  ? const _EmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (_, index) {
                        final product = filteredProducts[index];

                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.push('/products/${product['id']}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: AppTextSizes.bodySmall,
                  color: AppColors.bodyText,
                ),
              ),
            ],
          ),

          Row(
            children: [
              _IconBtn(icon: Icons.add, onTap: () {
                 context.go('/add-product');
              }),

              SizedBox(width: 8.w),

              _IconBtn(icon: Icons.shopping_cart_outlined, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

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
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
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

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24.r),
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
              fontSize: AppTextSizes.bodySmall,
              color: AppColors.iconGrey,
            ),
          ),
        ],
      ),
    );
  }
}
