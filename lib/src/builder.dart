import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'generator.dart';

Builder imagePathBuilder(BuilderOptions options) => LibraryBuilder(ImagePathGenerator(), generatedExtension: '.image.dart');
