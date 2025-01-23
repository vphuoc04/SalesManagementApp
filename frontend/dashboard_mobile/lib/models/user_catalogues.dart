class UserCatalogues {
  final int id;
  final String name;
  final int publish;

  UserCatalogues({
    required this.id,
    required this.name,
    required this.publish
  });

  factory UserCatalogues.fromJson(Map<String, dynamic> json) {
    return UserCatalogues(
      id: json['id'] ?? 0, 
      name: json['name'] ?? 0,
      publish: json['publish'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'publish': publish 
    };
  }
}