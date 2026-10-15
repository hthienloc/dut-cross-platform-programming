import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;

  PostBloc({required this.getPostsUseCase}) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    final result = await getPostsUseCase(NoParams());
    result.fold(
      (failure) => emit(PostError(message: failure.message)),
      (posts) => emit(PostLoaded(posts: posts)),
    );
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    final result = await getPostsUseCase(NoParams());
    result.fold(
      (failure) => emit(PostError(message: failure.message)),
      (posts) => emit(PostLoaded(posts: posts)),
    );
  }
}
