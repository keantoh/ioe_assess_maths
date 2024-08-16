class DotPaintOption {
  final double x;
  final double y;
  final double radius;

  DotPaintOption({required this.x, required this.y, required this.radius});

  factory DotPaintOption.fromJson(Map<String, dynamic> json) {
    return DotPaintOption(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      radius: json['radius'].toDouble(),
    );
  }
}
