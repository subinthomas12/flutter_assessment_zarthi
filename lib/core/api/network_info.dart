import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection internetConnection;

  NetworkInfoImpl(this.internetConnection);

  @override
  Future<bool> get isConnected => internetConnection.hasInternetAccess;
}