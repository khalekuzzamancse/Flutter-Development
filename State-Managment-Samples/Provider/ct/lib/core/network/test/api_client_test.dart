import 'package:test/test.dart';
import '../network.dart';

void main() {
  group('API client test', () {

    test('read', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://api.github.com/users/khalekuzzamancse';

      try {
        final result = await client.readOrThrow(url);
        print(result);
        expect(result, isNotNull);
        expect(result, contains('login'));
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });

    test('post', () async {
      final client = NetworkFactory.createApiClient();
      const url = 'https://backend.snowtex.org/api/v1/auth/login/';
      final body = {
        "mobile": "+8801571378537",
        "password": "12345678"
      };

      try {
        final result = await client.postOrThrow(url, body);
        print(result);
        expect(result, isNotNull); // Ensure the result is not null
        expect(result, contains('id')); // Validate that the response contains an 'id'
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });



    test(' read and convert to actions.dart', () async {
    final client = NetworkFactory.createApiClient<_User>();
      const url = 'https://api.github.com/users/khalekuzzamancse';

      try {
        final result = await client.readOrThrow(url);
        final parser = JsonParser.create<_User>();
        final user = parser.parseOrThrow(result, _User.fromJson);

        print('$user');

        expect(result, isNotNull);
        expect(result, contains('login'));
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });


    test('read and parse using ApiClient', () async {
     final client = NetworkFactory.createApiClient<_User>();
      const url = 'https://api.github.com/users/khalekuzzamancse';

      try {
        final user = await client.readParseOrThrow<_User>(url, _User.fromJson);
        print('$user');

        expect(user, isNotNull);
        expect(user.login, contains('khalekuzzamancse'));
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });


    test('read and parse as List', () async {
        final client = NetworkFactory.createApiClient<_GitHubIssue>();
      const url =
          'https://api.github.com/repos/flutter/flutter/issues?per_page=10';

      try {
        final issueList = await client.readParseListOrThrow<_GitHubIssue>(
            url, _GitHubIssue.fromJson);

        issueList.forEach((issue) {
          print('$issue\n');
        });
        expect(issueList, isNotNull);
        expect(true, issueList.isNotEmpty);
        
      } catch (e) {
        fail('Exception thrown: $e');
      }
    });
  });
}

class _GitHubIssue {
  final String title;
  final int number;
  final String userHandle;

  _GitHubIssue({
    required this.title,
    required this.number,
    required this.userHandle,
  });

  // Factory constructor to create a GitHubIssue object from JSON
  factory _GitHubIssue.fromJson(Map<String, dynamic> json) {
    return _GitHubIssue(
      title: json['title'],
      number: json['number'],
      userHandle: json['user']['login'],
    );
  }

  // Overriding the toString method to provide a string representation of the object
  @override
  String toString() {
    return 'GitHubIssue{title: $title, number: $number, userHandle: $userHandle}';
  }
}

class _User {
  final String login;
  final int id;
  final String? name;

  _User({required this.login, required this.id, this.name});

  factory _User.fromJson(Map<String, dynamic> json) {
    return _User(login: json['login'], id: json['id'], name: json['name']);
  }

  @override
  String toString() {
    return 'User(login: $login, id: $id, name: ${name ?? "N/A"})';
  }
}
