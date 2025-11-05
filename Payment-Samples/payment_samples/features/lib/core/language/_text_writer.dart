part of core_language;
abstract class TextWriter {
  Future<void> write(String text);
  Future<void> append(String text);
  Future<void> clear();

  static TextWriter create(File file){
    return FileTextWriter(file);
  }
}


class FileTextWriter implements TextWriter {
  final File file;
  FileTextWriter(this.file);

  @override
  Future<void> write(String text) async {
    try {
      await file.writeAsString(text);
    } catch (_) {}
  }

  @override
  Future<void> append(String text,{ bool newLine=true}) async {
    try {
      final content=newLine?'$text\n':text;
      await file.writeAsString(content, mode: FileMode.append);
    } catch (_) {}
  }

  @override
  Future<void> clear() async {
    try {
      await file.writeAsString('');
    } catch (_) {}
  }
}
