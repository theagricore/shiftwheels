class BrandModel {
  final String? id;
  final String? brandName;
  final String? image;
  final List<String>? models; 

  BrandModel({
    this.id,
    this.brandName,
    this.image,
    this.models,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}