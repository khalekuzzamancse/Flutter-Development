import 'package:test/test.dart';
import '../network.dart';


void main() {
  group('JsonParser and MyModel Tests', () {
    test('should correctly parse JSON into MyModel', () {
      final parser = NetworkFactory.createJsonParser<_Model>();
      const jsonString = '{"name": "John", "age": 30}';

      _Model myModel = parser.parseOrThrow(jsonString, _Model.fromJson);

      expect(myModel.name, 'John');
      expect(myModel.age, 30);
    });

    test('should correctly serialize MyModel to JSON', () {
      final parser = NetworkFactory.createJsonParser<_Model>();
      final myModel = _Model(name: 'John', age: 30);

      String jsonOutput =
          parser.toJsonOrThrow(myModel, (model) => model.toJson());

      expect(jsonOutput, '{"name":"John","age":30}');
    });

    
    test('should check if JSON is of type _Model', () {
      final parser = NetworkFactory.createJsonParser<_Model>();

      // Valid _Model JSON
      const validJsonString = '{"name": "John", "age": 30}';
      bool isModel = parser.isJsonOfType(validJsonString, _Model.fromJson);
      print('Is valid JSON of type _Model: $isModel');
      expect(isModel, isTrue);

      // Invalid _Model JSON, but valid for ServerFeedback
      const invalidJsonString = '{"message": "Message from server"}';
      bool isInvalidModel =
          parser.isJsonOfType(invalidJsonString, _Model.fromJson);
      print('Is invalid JSON of type _Model: $isInvalidModel');
      expect(isInvalidModel, isFalse);

      // Test with ServerFeedback parser
      final parserFeedback = NetworkFactory.createJsonParser<ServerFeedback>();
      bool isServerFeedback = parserFeedback.isJsonOfType(
          invalidJsonString, ServerFeedback.fromJson);
      print('Is invalid JSON of type ServerFeedback: $isServerFeedback');
      expect(isServerFeedback, isTrue);
    });
  });
}

class _Model {
  final String name;
  final int age;

  _Model({required this.name, required this.age});
  factory _Model.fromJson(Map<String, dynamic> json) {
    return _Model(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}
