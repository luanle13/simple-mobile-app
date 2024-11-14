import 'package:demo/core/service/local_service.dart';
import 'package:demo/core/service/network/network_service.dart';
import 'package:demo/data/datasource/api/auth_api_datasource.dart';
import 'package:demo/data/datasource/local/auth_local_datasource.dart';
import 'package:demo/data/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton(ApiService(null));


  locator.registerSingletonAsync<LocalService>(() async {
    final service = LocalService();
    await service.init();
    return service;
  });

  await locator.isReady<LocalService>();

  locator.registerSingleton<AuthRepository>(AuthRepository(
      cacheDatasource: AuthLocalDatasource(locator<LocalService>()),
      remoteDatasource: AuthApiDatasource(ApiService(null))));

  return locator.allReady();
}
