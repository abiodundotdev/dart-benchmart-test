// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class AnnoGen extends GeneratorForAnnotation<Resolve> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    {
      // //final visitor = ModelVisitor();
      // element.visitChildren(visitor);
      // final buffer = StringBuffer();
      // buffer.writeln("${visitor.className}  ${visitor.fields}");
      //return "buffer.toString()";
      return 'var ${element.displayName.toLowerCase()} = "${element.name} is the name This is a resolver class children ${element.children} ";';
    }
  }
}

Builder generateClass(BuilderOptions options) => SharedPartBuilder(
      [AnnoGen()],
      'resolve',
    );

class Resolve<T> {
  const Resolve();
}

// class ModelVisitor extends SimpleElementVisitor<void> {
//   String className = '';
//   Map<String, dynamic> fields = {};

//   @override
//   void visitConstructorElement(ConstructorElement element) {
//     final returnType = element.returnType.toString();
//     className = returnType.replaceFirst('*', '');
//   }

//   @override
//   void visitFieldElement(FieldElement element) {
//     fields[element.name] = element.type.toString().replaceFirst('*', '');
//   }
// }
