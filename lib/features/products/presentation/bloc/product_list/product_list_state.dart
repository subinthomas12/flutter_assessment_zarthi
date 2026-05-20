part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListLoaded extends ProductListState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;

  const ProductListLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.categories,
    required this.selectedCategory,
    required this.searchQuery,
  });

  ProductListLoaded copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductListLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        categories,
        selectedCategory,
        searchQuery,
      ];
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}
