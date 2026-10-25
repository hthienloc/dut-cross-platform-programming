import 'dart:async';
import 'package:flutter/material.dart';
import 'stream_service.dart';

void main() {
  runApp(const AsyncStreamApp());
}

class AsyncStreamApp extends StatelessWidget {
  const AsyncStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Async & Stream Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const StreamDemoScreen(),
    );
  }
}

class StreamDemoScreen extends StatefulWidget {
  const StreamDemoScreen({super.key});

  @override
  State<StreamDemoScreen> createState() => _StreamDemoScreenState();
}

class _StreamDemoScreenState extends State<StreamDemoScreen> {
  late final StreamCounterService _service;

  @override
  void initState() {
    super.initState();
    _service = StreamCounterService();
    // Tự động kích hoạt start sau 300ms để chụp được trạng thái RUNNING
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _service.start();
        });
      }
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Chủ đề 02: Future & Stream trong Flutter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _service.state == StreamState.running
                                ? Icons.sensors_rounded
                                : Icons.sensors_off_rounded,
                            color: _service.state == StreamState.running
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF64748B),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Real-time Stream Engine',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _getStatusTextColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF3B82F6),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'TICK COUNTER',
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        StreamBuilder<int>(
                          stream: _service.stream,
                          initialData: _service.currentCount,
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 68,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            );
                          },
                        ),
                        const Text(
                          'giây liên tục',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      key: const Key('btn_start'),
                      onPressed: _service.state == StreamState.running
                          ? null
                          : () {
                              setState(() {
                                _service.start();
                              });
                            },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Bắt đầu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      key: const Key('btn_pause'),
                      onPressed: _service.state != StreamState.running
                          ? null
                          : () {
                              setState(() {
                                _service.pause();
                              });
                            },
                      icon: const Icon(Icons.pause_rounded),
                      label: const Text('Tạm dừng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('btn_reset'),
                      onPressed: () {
                        setState(() {
                          _service.reset();
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Đặt lại'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (_service.state) {
      case StreamState.initial:
        return 'TRẠNG THÁI: CHỜ KHỞI ĐỘNG (INITIAL)';
      case StreamState.running:
        return 'TRẠNG THÁI: ĐANG PHÁT LUỒNG DỮ LIỆU (RUNNING)';
      case StreamState.paused:
        return 'TRẠNG THÁI: TẠM DỪNG (PAUSED)';
      case StreamState.stopped:
        return 'TRẠNG THÁI: ĐÃ HỦY / GIẢI PHÓNG (DISPOSED)';
    }
  }

  Color _getStatusBgColor() {
    switch (_service.state) {
      case StreamState.initial:
        return const Color(0xFFF1F5F9);
      case StreamState.running:
        return const Color(0xFFDCFCE7);
      case StreamState.paused:
        return const Color(0xFFFEF3C7);
      case StreamState.stopped:
        return const Color(0xFFFEE2E2);
    }
  }

  Color _getStatusTextColor() {
    switch (_service.state) {
      case StreamState.initial:
        return const Color(0xFF475569);
      case StreamState.running:
        return const Color(0xFF15803D);
      case StreamState.paused:
        return const Color(0xFFB45309);
      case StreamState.stopped:
        return const Color(0xFFB91C1C);
    }
  }
}
