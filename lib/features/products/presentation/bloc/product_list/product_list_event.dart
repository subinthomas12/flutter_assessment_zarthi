part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductListEvent {
  const FetchProductsEvent();
}

class FilterByCategoryEvent extends ProductListEvent {
  final String category;
  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProductsEvent extends ProductListEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshProductsEvent extends ProductListEvent {
  const RefreshProductsEvent();
}
