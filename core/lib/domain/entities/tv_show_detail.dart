import 'package:equatable/equatable.dart';

class TvShowDetail extends Equatable {
  final DateTime firstAirDate;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;

  const TvShowDetail({
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [
        firstAirDate,
        id,
        name,
        overview,
        popularity,
        posterPath,
        voteAverage,
      ];
}
