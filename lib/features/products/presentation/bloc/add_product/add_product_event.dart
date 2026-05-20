part of 'add_product_bloc.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class SubmitProductEvent extends AddProductEvent {
  final ProductEntity product;

  const SubmitProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}