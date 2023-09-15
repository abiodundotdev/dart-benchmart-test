import 'package:sourcegengenerator/sourcegengenerator.dart';

part 'man.g.dart';

@Resolve()
class Man {
  const Man({required this.isAdult, required this.name});
  final String name;
  final bool isAdult;
}

@Resolve()
late Man man;
