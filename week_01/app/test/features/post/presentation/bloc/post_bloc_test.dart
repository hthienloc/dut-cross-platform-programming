import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/core/usecases/usecase.dart';
import 'package:clean_architecture_demo/features/post/domain/entities/post.dart';
import 'package:clean_architecture_demo/features/post/domain/usecases/get_posts.dart';
import 'package:clean_architecture_demo/features/post/presentation/bloc/post_bloc.dart';
import 'package:clean_architecture_demo/features/post/presentation/bloc/post_event.dart';
import 'package:clean_architecture_demo/features/post/presentation/bloc/post_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  late PostBloc bloc;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    bloc = PostBloc(getPostsUseCase: mockGetPostsUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tPosts = [
    Post(
      id: 1,
      userId: 1,
      title: 'Tiêu đề kiểm thử',
      body: 'Nội dung kiểm thử',
    ),
  ];

  test('trạng thái ban đầu của PostBloc phải là PostInitial', () {
    expect(bloc.state, equals(PostInitial()));
  });

  blocTest<PostBloc, PostState>(
    'phát ra [PostLoading, PostLoaded] khi FetchPostsEvent thành công',
    build: () {
      when(() => mockGetPostsUseCase(NoParams()))
          .thenAnswer((_) async => const Right(tPosts));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPostsEvent()),
    expect: () => [
      PostLoading(),
      const PostLoaded(posts: tPosts),
    ],
    verify: (_) {
      verify(() => mockGetPostsUseCase(NoParams())).called(1);
    },
  );

  blocTest<PostBloc, PostState>(
    'phát ra [PostLoading, PostError] khi GetPostsUseCase trả về lỗi',
    build: () {
      when(() => mockGetPostsUseCase(NoParams()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Lỗi server')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPostsEvent()),
    expect: () => [
      PostLoading(),
      const PostError(message: 'Lỗi server'),
    ],
    verify: (_) {
      verify(() => mockGetPostsUseCase(NoParams())).called(1);
    },
  );
}
