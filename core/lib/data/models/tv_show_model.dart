import 'package:core/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

class TvShowModel extends Equatable {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;

  const TvShowModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TvShowModel.fromJson(Map<String, dynamic> json) => TvShowModel(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
      };

  TvShow toEntity() =>
      TvShow(id: id, name: name, overview: overview, posterPath: posterPath);

  static List<TvShowModel> createList(List<dynamic> data) =>
      data.map((e) => TvShowModel.fromJson(e)).toList();

  @override
  List<Object?> get props => [id, name, overview, posterPath];
}
