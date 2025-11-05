// Entity for handling the document response from the API

class DocumentEntity {
  final String url;
  final int docType;
  final int id;
  final int ownerId;

  DocumentEntity({
    required this.url,
    required this.docType,
    required this.id,
    required this.ownerId,
  });

  /// Avoid explicit type casting such ['x'] as y to avoid unwanted exception or bug as the backend may return a JSON
  /// with missing or null fields. Typecasting null values or using expressions can throw exceptions and cause unwanted bugs
  static DocumentEntity fromJsonOrThrow(Map<String, dynamic> json) {
    return DocumentEntity(
      url: json['doc_url'],
      docType: json['doc_type'],
      id: json['id'],
      ownerId: json['owner'],
    );
  }
  @override
  String toString() {
    return 'DocumentEntity(url: $url, docType: $docType, id: $id, ownerId: $ownerId)';
  }
}
