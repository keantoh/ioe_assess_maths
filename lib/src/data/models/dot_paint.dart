class DotPaint {
  final double x;
  final double y;
  final double radius;

  DotPaint({required this.x, required this.y, required this.radius});

  factory DotPaint.fromJson(Map<String, dynamic> json) {
    return DotPaint(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      radius: json['radius'].toDouble(),
    );
  }
}
