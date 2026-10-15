import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../features/post/data/datasources/post_remote_data_source.dart';
import '../features/post/data/repositories/post_repository_impl.dart';
import '../features/post/domain/repositories/post_repository.dart';
import '../features/post/domain/usecases/get_posts.dart';
import '../features/post/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //! 1. Presentation Layer (Factory: tạo instance mới theo vòng đời widget)
  sl.registerFactory(
    () => PostBloc(getPostsUseCase: sl()),
  );

  //! 2. Domain Layer (Lazy Singleton: chỉ tạo khi được gọi lần đầu)
  sl.registerLazySingleton(
    () => GetPostsUseCase(sl()),
  );

  //! 3. Data Layer - Repository (Đăng ký implementation cho abstract interface)
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  //! 4. Data Layer - DataSources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl()),
  );

  //! 5. External - Client mạng
  sl.registerLazySingleton(() => http.Client());
}
