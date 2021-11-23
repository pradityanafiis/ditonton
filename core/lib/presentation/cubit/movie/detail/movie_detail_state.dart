part of 'movie_detail_cubit.dart';

@immutable
abstract class MovieDetailState extends Equatable {}

class MovieDetailInitial extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoading extends MovieDetailState {
  @override
  List<Object?> get props => [];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail data;

  MovieDetailLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
