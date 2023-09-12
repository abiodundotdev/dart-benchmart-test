import 'package:sourcegengenerator/sourcegengenerator.dart';

part 'person.g.dart';

var name = "Qazeem abiodun";
var house = "Adelani adejare";
var department = "Adelani chemical engineering";

@Resolve()
class Person {
  String name;
  bool isAdult;
}
