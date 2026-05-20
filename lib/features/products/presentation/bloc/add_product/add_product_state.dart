part of 'add_product_bloc.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {
  const AddProductInitial();
}

class AddProductLoading extends AddProductState {
  const AddProductLoading();
}

class AddProductSuccess extends AddProductState {
  const AddProductSuccess();
}

class AddProductError extends AddProductState {
  final String message;

  const AddProductError(this.message);

  @override
  List<Object?> get props => [message];
}