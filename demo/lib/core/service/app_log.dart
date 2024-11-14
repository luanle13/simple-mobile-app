import 'package:logger/logger.dart';

abstract final class AppLog {
  static final _logger = Logger();

  static void print(Object? data) => _logger.d(data);

  static void error(Object? data) => _logger.e(data);

  static void warning(Object? data) => _logger.f(data);
}
