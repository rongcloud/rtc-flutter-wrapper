typedef void Callback(info);

typedef void StateCallback(code, info);

const List<String> CameraCaptureOrientationStrings = [
  '↑',
  '↓',
  '→',
  '←',
];

const List<String> FPSStrings = [
  '10',
  '15',
  '25',
  '30',
];

const List<String> ResolutionStrings = [
  '144x176',
  '180x180',
  '144x256',
  '180x240',
  '180x320',
  '240x240',
  '240x320',
  '360x360',
  '360x480',
  '360x640',
  '480x480',
  '480x640',
  '480x720',
  '480x848',
  '720x960',
  '720x1280',
  '1080x1920',
];

const List<int> AudioKbps = [
  16,
  32,
  48,
];

const List<int> TinyMinVideoKbps = [
  50,
  100,
  200,
  300,
];

const List<int> TinyMaxVideoKbps = [
  300,
  500,
  800,
  1000,
  1200,
];

const List<int> MinVideoKbps = [300, 500, 700, 900, 1200, 1500];

const List<int> MaxVideoKbps = [2000, 2200, 3500, 4400, 6000, 8000];

enum Role {
  Local,
  Remote,
  Audience,
}

const List<String> NetworkTypes = [
  'Unknown',
  'Wifi',
  'Mobile',
];

const List<String> EffectNames = [
  '反派大笑',
  '狗子叫声',
  '胜利号角',
];

const List<String> MusicNames = [
  '我和我的祖国',
];
