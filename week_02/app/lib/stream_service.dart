import 'dart:async';

enum StreamState { initial, running, paused, stopped }

class StreamCounterService {
  final _controller = StreamController<int>.broadcast();
  Timer? _timer;
  int _counter = 0;
  StreamState _state = StreamState.initial;

  Stream<int> get stream => _controller.stream;
  int get currentCount => _counter;
  StreamState get state => _state;
  bool get isClosed => _controller.isClosed;

  void start() {
    if (_state == StreamState.running || _controller.isClosed) return;
    _state = StreamState.running;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      if (!_controller.isClosed) {
        _controller.sink.add(_counter);
      }
    });
  }

  void pause() {
    if (_state != StreamState.running) return;
    _timer?.cancel();
    _timer = null;
    _state = StreamState.paused;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _counter = 0;
    _state = StreamState.initial;
    if (!_controller.isClosed) {
      _controller.sink.add(_counter);
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _state = StreamState.stopped;
    _controller.close();
  }
}
