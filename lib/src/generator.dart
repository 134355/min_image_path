import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'dart:io';
import 'type.dart';
import 'explanation.dart';

class ImagePathGenerator extends GeneratorForAnnotation<MinImagePath> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {

    String _codeContent = '';
    String pathName= annotation.read('pathName').stringValue;
    String className = element.displayName;

    if (!pathName.endsWith('/')) {
      pathName = '$pathName/';
    }

    void _handleFile(String path) {
      var directory = Directory(path);
      if (directory == null) {
        throw '$path 不是目录';
      }

      for (var file in directory.listSync()) {
        var type = file.statSync().type;

        if (type == FileSystemEntityType.directory) {
          _handleFile('${file.path}/');
        } else if (type == FileSystemEntityType.file) {
          var filePath = file.path;
          var keyName = filePath.trim().toUpperCase();

          if (!keyName.endsWith('.PNG') &&
              !keyName.endsWith('.JPEG') &&
              !keyName.endsWith('.SVG') &&
              !keyName.endsWith('.JPG')) continue;
          var key = keyName
              .replaceAll(RegExp(path.toUpperCase()), '')
              .replaceAll(RegExp('.PNG'), '')
              .replaceAll(RegExp('.JPEG'), '')
              .replaceAll(RegExp('.SVG'), '')
              .replaceAll(RegExp('.JPG'), '');

          _codeContent = '''
            $_codeContent
            static const String $key = '$filePath';''';
        }
      }
    }

    _handleFile(pathName);
    
    return '''
      $explanationContent
      class $className{
        $className._();
        $_codeContent
      }''';
  }
}