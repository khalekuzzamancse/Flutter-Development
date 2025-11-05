class GroupCreationModel {
  final String name;
  final int imageId;
  final List<int> membersId;
  final int adminId;
  GroupCreationModel({
    required this.name,
    required this.imageId,
    required this.membersId,
    required this.adminId,
  });

  @override
  String toString() {
    return 'GroupCreationModel(name: $name, imageId: $imageId, membersId: $membersId, adminId: $adminId)';
  }
}
