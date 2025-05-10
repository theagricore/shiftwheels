
class FuelsModel {
  final String? id;
  final String? fuels;

  FuelsModel({this.id, this.fuels});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelsModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
