class NewAsset {
  String path;
  String type;
  String? thumbnail; // image or video
  NewAsset({required this.path, required this.type, this.thumbnail});

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'type': type,
      'thumbnail': thumbnail
    };
  }
}