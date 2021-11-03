/// @author Pan ming da
/// @time 2021/6/8 16:01
/// @version 1.0

enum _RCRTCStreamType {
  not_normal,
  normal,
  file,
  screen,
}

class RCRTCCustomLayout {
  RCRTCCustomLayout.create({
    required this.userId,
    this.x = 0,
    this.y = 0,
    this.width = 480,
    this.height = 640,
  })  : this._type = _RCRTCStreamType.normal,
        this.tag = null;

  RCRTCCustomLayout.createCustomStreamLayout({
    required this.userId,
    required this.tag,
    this.x = 0,
    this.y = 0,
    this.width = 480,
    this.height = 640,
  }) : this._type = _RCRTCStreamType.file;

  Map<String, dynamic> toJson() => {
        'type': _type.index,
        'id': userId,
        'tag': tag,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  final _RCRTCStreamType _type;
  final String userId;
  final String? tag;
  int x, y, width, height;
}
