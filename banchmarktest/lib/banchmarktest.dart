import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:get_it/get_it.dart';

class GetItHarness extends BenchmarkBase {
  GetItHarness(super.name);
  @override
  void run() {
    var getIt = GetIt.instance;
    getIt.registerFactory<int>(() => 1);
    getIt.registerFactory<String>(() => "null");
    getIt.registerFactory<double>(() => 2.3);
  }
}
