import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/product_usecases.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

@injectable
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailBloc({required this.getProductByIdUseCase})
      : super(const ProductDetailInitial()) {
    on<FetchProductDetailEvent>(_onFetchProductDetail);
  }

  Future<void> _onFetchProductDetail(
    FetchProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());

    final result = await getProductByIdUseCase(event.id);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
