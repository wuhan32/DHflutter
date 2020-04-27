import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtil {
  //本地资源播放器
  static AudioCache audioCache = new AudioCache();
  //网络资源播放器
  static AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //播放本地资源
  static void localPlay(String audioPath) async {
    await audioCache.play(audioPath, mode: PlayerMode.LOW_LATENCY);
  }

  //播放网络资源
  static void networkPlay(String audioPath) async {
    await audioPlayer.play(audioPath).then((result) {
      if (result == 1) {
        print('play success');
      } else {
        print('play failed');
      }
      audioPlayer.dispose();
    });
  }
}
