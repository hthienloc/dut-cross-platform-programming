import 'package:flutter_test/flutter_test.dart';
import 'package:async_stream_demo/stream_service.dart';

void main() {
  group('StreamCounterService Lifecycle and Async Tests', () {
    late StreamCounterService service;

    setUp(() {
      service = StreamCounterService();
    });

    tearDown(() {
      service.dispose();
    });

    test('Initial state is StreamState.initial and count is 0', () {
      expect(service.state, StreamState.initial);
      expect(service.currentCount, 0);
    });

    test('Start emits sequential counter ticks over Stream', () async {
      service.start();

      expect(service.state, StreamState.running);

      await expectLater(
        service.stream.take(3),
        emitsInOrder([1, 2, 3]),
      );
    });

    test('Pause halts tick emission and preserves counter value', () async {
      service.start();
      await Future.delayed(const Duration(milliseconds: 2100));
      service.pause();

      expect(service.state, StreamState.paused);
      final countAtPause = service.currentCount;
      expect(countAtPause, greaterThanOrEqualTo(2));

      // Wait another 1.5s to ensure no additional events are fired
      await Future.delayed(const Duration(milliseconds: 1500));
      expect(service.currentCount, countAtPause);
    });

    test('Reset resets counter back to 0 and emits 0', () async {
      service.start();
      await Future.delayed(const Duration(milliseconds: 1100));
      service.reset();

      expect(service.state, StreamState.initial);
      expect(service.currentCount, 0);
    });

    test('Dispose cancels timer and safely closes StreamController', () {
      service.start();
      service.dispose();

      expect(service.state, StreamState.stopped);
      expect(service.isClosed, isTrue);
    });
  });
}
