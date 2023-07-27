import 'dart:async';

class CountdownTimer {
  CountdownTimer({required int seconds}) : _secondsRemaining = seconds;
  int _secondsRemaining = 300;
  Timer? _timer;

  Stream<int> countdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (_secondsRemaining == 0) {
        _timer!.cancel();
      }
    });
    return Stream.periodic(
        const Duration(seconds: 1), (int count) => _secondsRemaining);
  }
}
