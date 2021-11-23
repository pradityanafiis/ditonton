import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_recommendation_state.dart';

class MovieRecommendationCubit extends Cubit<MovieRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationCubit(this._getMovieRecommendations)
      : super(MovieRecommendationInitial());

  void fetch(int id) async {
    emit(MovieRecommendationLoading());

    final _result = await _getMovieRecommendations.execute(id);

    _result.fold(
      (failure) {
        emit(MovieRecommendationError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(MovieRecommendationLoaded(data));
        } else {
          emit(
              MovieRecommendationError("Sorry, we can't show recommendations"));
        }
      },
    );
  }
}
