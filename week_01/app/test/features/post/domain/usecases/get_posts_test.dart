import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/core/usecases/usecase.dart';
import 'package:clean_architecture_demo/features/post/domain/entities/post.dart';
import 'package:clean_architecture_demo/features/post/domain/repositories/post_repository.dart';
import 'package:clean_architecture_demo/features/post/domain/usecases/get_posts.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    useCase = GetPostsUseCase(mockPostRepository);
  });

  const tPosts = [
    Post(
      id: 1,
      userId: 1,
      title: 'Bài viết số 1',
      body: 'Nội dung bài viết số 1',
    ),
    Post(
      id: 2,
      userId: 1,
      title: 'Bài viết số 2',
      body: 'Nội dung bài viết số 2',
    ),
  ];

  test(
    'khi gọi GetPostsUseCase thành công, nên trả về Right(List<Post>) từ repository',
    () async {
      // Arrange
      when(() => mockPostRepository.getPosts())
          .thenAnswer((_) async => const Right(tPosts));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(tPosts));
      verify(() => mockPostRepository.getPosts()).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    },
  );

  test(
    'khi repository gặp sự cố máy chủ, nên trả về Left(ServerFailure)',
    () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Lỗi kết nối máy chủ');
      when(() => mockPostRepository.getPosts())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockPostRepository.getPosts()).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
