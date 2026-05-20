import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/product_usecases.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  ProductListBloc({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(const ProductListInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<SearchProductsEvent>(_onSearchProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(const ProductListLoading());

    final productsResult = await getProductsUseCase();
    final categoriesResult = await getCategoriesUseCase();

    productsResult.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) {
        final categories = categoriesResult.fold(
          (_) => <String>[],
          (cats) => cats,
        );

        emit(ProductListLoaded(
          allProducts: products,
          filteredProducts: products,
          categories: ['all', ...categories],
          selectedCategory: 'all',
          searchQuery: '',
        ));
      },
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    add(const FetchProductsEvent());
  }

  void _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<ProductListState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductListLoaded) {
      final filtered = _applyFilters(
        currentState.allProducts,
        event.category,
        currentState.searchQuery,
      );
      emit(currentState.copyWith(
        filteredProducts: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductListState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductListLoaded) {
      final filtered = _applyFilters(
        currentState.allProducts,
        currentState.selectedCategory,
        event.query,
      );
      emit(currentState.copyWith(
        filteredProducts: filtered,
        searchQuery: event.query,
      ));
    }
  }

  List<ProductEntity> _applyFilters(
    List<ProductEntity> products,
    String category,
    String query,
  ) {
    return products.where((p) {
      final matchesCategory =
          category == 'all' || p.category == category;
      final matchesSearch =
          query.isEmpty || p.title.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
