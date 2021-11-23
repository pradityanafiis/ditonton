part of 'tv_show_detail_cubit.dart';

@immutable
abstract class TvShowDetailState extends Equatable {}

class TvShowDetailInitial extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailLoading extends TvShowDetailState {
  @override
  List<Object?> get props => [];
}

class TvShowDetailError extends TvShowDetailState {
  final String message;

  TvShowDetailError(this.message);

  @override
  List<Object?> get props => [];
}

class TvShowDetailLoaded extends TvShowDetailState {
  final TvShowDetail data;

  TvShowDetailLoaded(this.data);

  @override
  List<Object?> get props => [];
}
