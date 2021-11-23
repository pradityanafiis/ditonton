part of 'tv_show_recommendation_cubit.dart';

@immutable
abstract class TvShowRecommendationState extends Equatable {}

class TvShowRecommendationInitial extends TvShowRecommendationState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationLoading extends TvShowRecommendationState {
  @override
  List<Object?> get props => [];
}

class TvShowRecommendationError extends TvShowRecommendationState {
  final String message;

  TvShowRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowRecommendationLoaded extends TvShowRecommendationState {
  final List<TvShow> data;

  TvShowRecommendationLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
