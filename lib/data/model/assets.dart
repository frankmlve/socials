class Assets {
  String path;
  String? thumbnail;
  String type;

  Assets({required this.path, this.thumbnail, required this.type});

  static fromMap(Map<String, dynamic> asset) {
    return Assets(
      path: asset['path'],
      thumbnail: asset['thumbnail'],
      type: asset['type'],
    );
  }
}