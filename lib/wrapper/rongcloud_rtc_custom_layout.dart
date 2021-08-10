/// @author Pan ming da
/// @time 2021/6/8 16:01
/// @version 1.0

class RCRTCCustomLayout {
  RCRTCCustomLayout.create({
    required this.userId,
    this.x = 0,
    this.y = 0,
    this.width = 480,
    this.height = 640,
  });

  Map<String, dynamic> toJson() => {
        'id': userId,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  String userId;
  int x, y, width, height;
}
