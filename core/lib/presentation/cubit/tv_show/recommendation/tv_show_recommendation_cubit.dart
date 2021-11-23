import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_tv_show_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_show_recommendation_state.dart';

class TvShowRecommendationCubit extends Cubit<TvShowRecommendationState> {
  final GetTvShowRecommendations _getTvShowRecommendations;

  TvShowRecommendationCubit(this._getTvShowRecommendations)
      : super(TvShowRecommendationInitial());

  void fetchRecommendation(int id) async {
    emit(TvShowRecommendationLoading());

    final _result = await _getTvShowRecommendations.execute(id);

    _result.fold(
      (failure) {
        emit(TvShowRecommendationError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(TvShowRecommendationLoaded(data));
        } else {
          emit(TvShowRecommendationError(
              "Sorry, we can't show recommendations"));
        }
      },
    );
  }
}
