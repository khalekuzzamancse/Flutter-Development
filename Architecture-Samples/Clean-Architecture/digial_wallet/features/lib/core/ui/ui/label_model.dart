class LabelModel {
  final String name;
  final String hexCode;
  final String? description;

  LabelModel({
    required this.name,
    required this.hexCode,
    this.description,
  });

  // Manually implement the copy method with all arguments optional
  LabelModel copy({
    String? name,
    String? hexCode,
    String? description,
  }) {
    return LabelModel(
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      description: description ?? this.description,
    );
  }

  // Manually implement the toString method
  @override
  String toString() {
    return 'LabelModel(name: $name, hexCode: $hexCode, description: $description)';
  }

  // Manually implement the equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LabelModel &&
        other.name == name &&
        other.hexCode == hexCode &&
        other.description == description;
  }

  // Manually implement the hashCode
  @override
  int get hashCode => name.hashCode ^ hexCode.hashCode ^ description.hashCode;

  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      name: json['name'],
      hexCode: json['color'],  // Assuming `color` in JSON is hexCode in model
      description: json['description'],
    );
  }

}
