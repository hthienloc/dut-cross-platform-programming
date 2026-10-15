import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/injection_container.dart' as di;
import 'features/post/presentation/bloc/post_bloc.dart';
import 'features/post/presentation/bloc/post_event.dart';
import 'features/post/presentation/pages/post_page.dart';

void main() async {
  // 1. Đảm bảo Flutter Engine hoàn tất liên kết với native platform
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Service Locator (get_it DI Container)
  await di.initDependencies();

  // 3. Khởi chạy ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Inject instance PostBloc từ Service Locator và kích hoạt sự kiện đầu tiên
        BlocProvider<PostBloc>(
          create: (_) => di.sl<PostBloc>()..add(FetchPostsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Clean Architecture Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A365D),
            brightness: Brightness.light,
          ),
          cardTheme: const CardThemeData(
            elevation: 1.5,
          ),
        ),
        home: const PostPage(),
      ),
    );
  }
}
