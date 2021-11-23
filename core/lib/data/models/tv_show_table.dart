import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowTable extends Equatable {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;

  const TvShowTable({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TvShowTable.fromEntity(TvShowDetail data) => TvShowTable(
        id: data.id,
        name: data.name,
        overview: data.overview,
        posterPath: data.posterPath,
      );

  factory TvShowTable.fromMap(Map<String, dynamic> map) => TvShowTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> get toJson => {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  TvShow get toEntity => TvShow(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
      ];
}
