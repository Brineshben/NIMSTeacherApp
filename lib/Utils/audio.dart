import 'package:audio_waveforms/audio_waveforms.dart';

class SingleAudio {
  static PlayerController? previousPlayerController;
  static Future<void> playSingleAudio(
      PlayerController playerController, bool _isPlaying, String path) async {
    print("playerController hashCode: ${playerController.hashCode}");
    print(
        "previousPlayerController hashCode: ${previousPlayerController?.hashCode}");

    if (previousPlayerController != null &&
        previousPlayerController != playerController) {
      await previousPlayerController!.pausePlayer();
    }

    if (!_isPlaying) {
      try {
        await playerController.startPlayer(finishMode: FinishMode.pause);
      } catch (e) {
        print("playerControllererror -------------------------- $e");
      }
    } else {
      await playerController.pausePlayer();
    }

    previousPlayerController = playerController;
  }
}
