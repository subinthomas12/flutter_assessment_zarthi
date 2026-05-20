// lib/features/products/presentation/screens/add_product_screen.dart
// AddProductionscreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_management_app/core/constants/app_colors.dart';
import 'package:product_management_app/core/constants/app_text_sizes.dart';
import 'package:product_management_app/features/auth/presentation/widgets/custom_auth_widgets.dart';
import 'package:product_management_app/features/products/domain/entities/product_entity.dart';
import 'package:product_management_app/features/products/presentation/bloc/add_product/add_product_bloc.dart';
import 'package:product_management_app/features/products/presentation/bloc/product_list/product_list_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    // Load categories if not already loaded
    final productListBloc = context.read<ProductListBloc>();
    if (productListBloc.state is! ProductListLoaded) {
      productListBloc.add(const FetchProductsEvent());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitProduct() {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      category: _selectedCategory ?? '',
      image: _imageController.text.trim().isEmpty
          ? 'https://via.placeholder.com/300'
          : _imageController.text.trim(),
      rating: const RatingEntity(
        rate: 5.0,
        count: 1,
      ),
    );

    context.read<AddProductBloc>().add(
          SubmitProductEvent(product),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductBloc, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          // Refresh product list after adding
          context.read<ProductListBloc>().add(
                const RefreshProductsEvent(),
              );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          context.go('/products');
        }

        if (state is AddProductError) {
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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _IconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.go('/products'),
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
                        SizedBox(height: 24.h),

                        // Product Name
                        CustomTextField(
                          controller: _titleController,
                          label: 'Product Name',
                          hint: 'Enter product name',
                          prefixIcon: Icons.shopping_bag_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),

                        // Price
                        CustomTextField(
                          controller: _priceController,
                          label: 'Price',
                          hint: 'Enter price',
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefixIcon: Icons.attach_money_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter price';
                            }

                            final price =
                                double.tryParse(value.trim());

                            if (price == null || price <= 0) {
                              return 'Enter valid price';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 16.h),

                        // Category Dropdown
                        BlocBuilder<ProductListBloc, ProductListState>(
                          builder: (context, state) {
                            List<String> categories = [];

                            if (state is ProductListLoaded) {
                              categories = state.categories
                                  .where(
                                    (category) =>
                                        category.toLowerCase() !=
                                        'all',
                                  )
                                  .toList();
                            }

                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize:
                                        AppTextSizes.bodyMedium,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppColors.headingText,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select category',
                                    prefixIcon: const Icon(
                                      Icons.category_outlined,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding:
                                        EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 18.h,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16.r,
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            AppColors.border,
                                      ),
                                    ),
                                    enabledBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16.r,
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            AppColors.border,
                                      ),
                                    ),
                                    focusedBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16.r,
                                      ),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColor,
                                      ),
                                    ),
                                  ),
                                  items: categories.map((category) {
                                    return DropdownMenuItem<
                                        String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory =
                                          value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please select category';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 16.h),

                        // Image URL
                        CustomTextField(
                          controller: _imageController,
                          label: 'Image URL',
                          hint: 'Paste image URL',
                          prefixIcon: Icons.link_rounded,
                        ),

                        SizedBox(height: 16.h),

                        // Description
                        CustomTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint:
                              'Write product description...',
                          maxLines: 5,
                          prefixIcon:
                              Icons.description_outlined,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 32.h),

                        // Submit Button
                        BlocBuilder<AddProductBloc,
                            AddProductState>(
                          builder: (context, state) {
                            final isLoading =
                                state is AddProductLoading;

                            return PrimaryButton(
                              label: isLoading
                                  ? 'Adding...'
                                  : 'Add Product',
                              onPressed: isLoading
                                  ? () {}
                                  : _submitProduct,
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
      ),
    );
  }
}

// Reusable Back Icon Button
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