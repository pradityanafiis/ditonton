// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  int? id;
  String? name;
  String? overview;
  String? posterPath;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  TvShow.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [id, name, overview, posterPath];
}
