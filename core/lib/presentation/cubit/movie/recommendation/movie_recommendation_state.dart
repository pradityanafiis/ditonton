part of 'movie_recommendation_cubit.dart';

@immutable
abstract class MovieRecommendationState extends Equatable {}

class MovieRecommendationInitial extends MovieRecommendationState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationLoading extends MovieRecommendationState {
  @override
  List<Object?> get props => [];
}

class MovieRecommendationError extends MovieRecommendationState {
  final String message;

  MovieRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationLoaded extends MovieRecommendationState {
  final List<Movie> data;

  MovieRecommendationLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
