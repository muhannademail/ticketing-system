class Setting {
  final int id;
  final String serverLink;

  Setting({
    required this.id,
    required this.serverLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverLink': serverLink,
    };
  }

  @override
  String toString() {
    return 'Setting{id: $id, serverLink: $serverLink}';
  }
}
