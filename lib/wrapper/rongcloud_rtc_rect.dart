class RCRTCRect {
  RCRTCRect.create(
      this.x, 
      this.y, 
      this.width,
      );

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'width': width,
  };

  double x, y, width;
}