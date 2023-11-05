// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'dart:developer';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:riverpod_feature_generator/src/model_visitor.dart';
import 'package:riverpod_widget_annotation/riverpod_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

class WidgetGenerator extends GeneratorForAnnotation<RiverpodWidgetAnnotation> {
  bool _checkAsync(Element element, ConstantReader annotation) {
    try {
      return annotation.read('isAsync').boolValue;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  bool _checkAddLoading(Element element, ConstantReader annotation) {
    try {
      return annotation.read('addLoading').boolValue;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  bool _checkShowError(Element element, ConstantReader annotation) {
    try {
      return annotation.read('showError').boolValue;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    bool isAsync = _checkAsync(element, annotation);
    bool isAddLoading = _checkAddLoading(element, annotation);
    bool showError = _checkShowError(element, annotation);

    final buffer = StringBuffer();
    String className = visitor.className;
    String classNameNormal = className.replaceAll('View', '');
    String controller = "${classNameNormal}Controller";
    String state = "${classNameNormal}State";

    String provider =
        "${controller[0].toLowerCase()}${controller.substring(1)}Provider";

    if (isAsync) {
      state = "AsyncValue<$state?>";
    }

    buffer.writeln('abstract class ${className}Base extends ConsumerWidget{');
    buffer.writeln(' const ${className}Base({Key? key}) : super(key: key);');

    buffer.writeln(
        'Widget builder(BuildContext context,$controller controller,$state state,WidgetRef ref);');

    buffer.writeln('get provider => $provider;');

    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context, WidgetRef ref) {');
    buffer.writeln('final state = ref.watch($provider);');
    buffer.writeln('final controller = ref.read($provider.notifier);');
    if (showError && isAsync) {
      buffer.writeln(
          '    state.showScaffoldErrorMessage(context, state.error.toString());');
    }

    if (isAddLoading && isAsync) {
      buffer.writeln('  return Stack(children: [');
      buffer.writeln('     builder(context, controller, state,ref),');
      buffer.writeln(
          '     if (state.isLoading) const Positioned.fill(child: Align(  alignment: Alignment.center,child: Scaffold(backgroundColor: Colors.transparent,body: Center(child: CircularProgressIndicator()))),) ],);');
    } else {
      buffer.writeln('     return builder(context, controller, state,ref);');
    }
    buffer.writeln('  }');
    buffer.writeln('}');

    ///Generate SubClass For Sub Widgets
    if (isAsync && (isAddLoading || showError)) {
      buffer.writeln(
          'abstract class ${className}SubBase extends ConsumerWidget{');
      buffer
          .writeln(' const ${className}SubBase({Key? key}) : super(key: key);');

      buffer.writeln(
          'Widget builder(BuildContext context,$controller controller,$state state,WidgetRef ref);');
      buffer.writeln('get provider => $provider;');

      buffer.writeln('  @override');
      buffer.writeln('  Widget build(BuildContext context, WidgetRef ref) {');
      buffer.writeln('final state = ref.watch($provider);');
      buffer.writeln('final controller = ref.read($provider.notifier);');
      buffer.writeln('     return builder(context, controller, state,ref);');
      buffer.writeln('  }');
      buffer.writeln('}');
    }

    if (isAsync && showError) {
      buffer.writeln('''extension AsyncValueUI on AsyncValue {
  void showScaffoldErrorMessage(BuildContext context, String text) {
    if (hasError) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    }
  }
}''');
    }
    return buffer.toString();
  }
}
