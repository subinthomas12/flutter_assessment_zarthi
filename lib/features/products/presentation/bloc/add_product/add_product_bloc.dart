import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_usecase.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

@injectable
class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;

  AddProductBloc({required this.addProductUseCase})
      : super(const AddProductInitial()) {
    on<SubmitProductEvent>(_onSubmitProduct);
  }

  Future<void> _onSubmitProduct(
    SubmitProductEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(const AddProductLoading());

    final result = await addProductUseCase(event.product);

    result.fold(
      (failure) => emit(AddProductError(failure.message)),
      (_) => emit(const AddProductSuccess()),
    );
  }
}