import 'package:sourcegengenerator/sourcegengenerator.dart';

part 'person.g.dart';

@Resolve()
class Person {
  const Person({required this.isAdult, required this.name});
  final String name;
  final bool isAdult;
}

void main() {
}
