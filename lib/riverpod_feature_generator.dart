library riverpod_feature_generator;

import 'package:build/build.dart';
import 'package:riverpod_feature_generator/src/widget_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateWidgetGenClass(BuilderOptions options) => SharedPartBuilder(
      [WidgetGenerator()],
      'widget_generator',
    );
