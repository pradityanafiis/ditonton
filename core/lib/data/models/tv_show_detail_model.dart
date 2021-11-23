import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowDetailModel extends Equatable {
  final DateTime firstAirDate;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;

  const TvShowDetailModel({
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvShowDetailModel.fromJson(Map<String, dynamic> json) =>
      TvShowDetailModel(
        firstAirDate: DateTime.parse(json["first_air_date"]),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
      );

  static List<TvShowDetailModel> createList(List<dynamic> json) =>
      json.map((e) => TvShowDetailModel.fromJson(e)).toList();

  TvShowDetail toEntity() => TvShowDetail(
        firstAirDate: firstAirDate,
        id: id,
        name: name,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );

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
