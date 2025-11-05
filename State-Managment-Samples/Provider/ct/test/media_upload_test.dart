import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowchat_ios/core/domain/media_type.dart';
import 'package:snowchat_ios/core/misc/logger.dart';
import 'package:snowchat_ios/core/network/src/network_factory.dart';
import 'package:snowchat_ios/core/data/document_entity.dart';

import 'core.dart';

main() {
//@formatter:off
  test('uploadImage', () async {
    const tag='MediaUploadTest';

    final client = NetworkFactory.createApiClient();
    const url = 'https://backend.snowtex.org/api/v1/auth/documents/upload/';
    const token = 'Token 0a76cebb825c7c727aa8b5d76c173c42ec5b9708';
    final imageBytes = [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 1, 104, 0, 0, 1, 104, 4, 3, 0, 0, 0, 136, 203, 124, 230, 0, 0, 0, 32, 99, 72, 82, 77, 0, 0, 122, 38, 0, 0, 128, 132, 0, 0, 250, 0, 0, 0, 128, 232, 0, 0, 117, 48, 0, 0, 234, 96, 0, 0, 58, 152, 0, 0, 23, 112, 156, 186, 81, 60, 0, 0, 0, 45, 80, 76, 84, 69, 71, 112, 76, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 4, 7, 7, 255, 255, 255, 30, 39, 122, 94, 0, 0, 0, 13, 116, 82, 78, 83, 0, 6, 24, 71, 100, 157, 177, 199, 217, 49, 246, 127, 237, 94, 228, 137, 29, 0, 0, 0, 1, 98, 75, 71, 68, 14, 111, 189, 48, 79, 0, 0, 0, 7, 116, 73, 77, 69, 7, 232, 12, 2, 6, 19, 39, 153, 82, 158, 142, 0, 0, 14, 85, 73, 68, 65, 84, 120, 218, 237, 157, 207, 143, 28, 197, 21, 199, 187, 215, 235, 195, 138, 203, 172, 127, 33, 203, 151, 49, 94, 27, 144, 115, 216, 36, 56, 2, 43, 135, 89, 12, 33, 34, 172, 180, 193, 6, 108, 146, 149, 226, 56, 70, 4, 177, 7, 12, 114, 192, 100, 47, 128, 147, 216, 214, 74, 107, 59, 36, 36, 230, 102, 192, 73, 156, 145, 6, 18, 72, 72, 178, 167, 152, 128, 109, 124, 243, 143, 213, 120, 250, 127, 201, 204, 78, 85, 117, 85, 247, 171, 238, 234, 122, 245, 163, 71, 170, 175, 44, 239, 78, 239, 76, 245, 167, 106, 94, 119, 215, 123, 245, 170, 42, 138, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 80, 138, 55, 220, 103, 89, 147, 166, 145, 199, 30, 122, 246, 245, 223, 88, 214, 241, 3, 231, 140, 50, 239, 56, 216, 78, 28, 232, 210, 254, 166, 57, 230, 11, 39, 92, 32, 247, 213, 125, 211, 24, 245, 238, 37, 71, 204, 125, 234, 51, 134, 168, 55, 45, 58, 99, 238, 83, 191, 218, 48, 193, 60, 246, 188, 67, 230, 36, 233, 125, 98, 2, 250, 247, 78, 153, 147, 228, 246, 50, 158, 121, 221, 146, 99, 232, 228, 13, 60, 244, 195, 174, 153, 147, 85, 116, 83, 187, 111, 104, 3, 77, 237, 218, 162, 7, 186, 211, 196, 49, 143, 45, 120, 128, 78, 126, 136, 131, 190, 199, 7, 115, 242, 1, 138, 57, 126, 223, 11, 52, 238, 82, 140, 23, 210, 146, 186, 95, 219, 213, 53, 83, 246, 177, 177, 205, 202, 57, 185, 239, 15, 118, 117, 254, 241, 37, 118, 178, 255, 2, 87, 215, 249, 31, 60, 243, 163, 191, 63, 210, 40, 135, 222, 194, 138, 121, 173, 137, 178, 51, 165, 175, 117, 138, 81, 223, 202, 177, 77, 61, 119, 15];  


    const docType = 0;
    // try {
    //   final response = await client.postImageWithTokenOrThrow2(url, token, imageBytes, docType);
    //   Logger.debug(tag, 'response=$response');
    // } catch (e) {
    //   fail('$tag: Exception thrown: $e');
    // }


  });
//@formatter:off
  test('uploadImageByPath', () async {
  const tag='MediaUploadTest';

  final client = NetworkFactory.createApiClient();
  const url = 'https://backend.snowtex.org/api/v1/auth/documents/upload/';
  var token = await TestFactory.createTokenOrThrow();

  const path = "C:\\Users\\Khalekuzzaman\\Downloads\\test_optimized_1.png";

  try {
  final response = await client.postImageWithTokenOrThrow(url, 'Token $token',path);
  Logger.debug(tag, 'response=$response');
  } catch (e) {
  fail('$tag: Exception thrown: $e');
  }


  });
  //@formatter:off
  test('videoUpload NetworkClientTest', () async {
    const tag='MediaUploadTest::videoUpload';

    final client = NetworkFactory.createApiClient();
    const url = 'https://backend.snowtex.org/api/v1/auth/documents/upload/';
    var token = await TestFactory.createTokenOrThrow();

    const path = "C:\\Users\\Khalekuzzaman\\Downloads\\demo_video.mp4";

    try {
      final response = await client.postFileWithTokenOrThrow(url: url,token: 'Token $token',path: path,type: MediaType.video);
      Logger.debug(tag, 'response=$response');
    } catch (e) {
      fail('$tag: Exception thrown: $e');
    }


  });
  //@formatter:off
  group('DocumentEntityTests', ()  {
    const tag = 'DocumentEntityTests:';


    test('DocumentEntity Parsing', () {
      const jsonResponse = '''
  {"id":637,"doc_url":"https://backend.snowtex.org/media/documents/2024/12/02/test_optimized_1_qVHhV7g.png","created_at":"2024-12-02T14:33:57.907581+06:00","updated_at":"2024-12-02T14:33:57.907607+06:00","document":"http://backend.snowtex.org/media/documents/2024/12/02/test_optimized_1_qVHhV7g.png","doc_type":0,"owner":683}
  ''';

      final decoded = jsonDecode(jsonResponse);
      Logger.debug(tag, 'decoded:$decoded');

      final entity = DocumentEntity.fromJsonOrThrow(decoded);
      Logger.debug(tag, 'entity:$entity');
      expect(entity.id, 637);
      expect(entity.url, "https://backend.snowtex.org/media/documents/2024/12/02/test_optimized_1_qVHhV7g.png");
      expect(entity.docType, 0);
      expect(entity.ownerId, 683);
    });
  });


}
