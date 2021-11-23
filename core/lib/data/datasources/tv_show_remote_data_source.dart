import 'dart:convert';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/data/models/tv_show_model.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getNowPlaying();
  Future<List<TvShowModel>> getPopular();
  Future<List<TvShowModel>> getTopRated();
  Future<List<TvShowModel>> search(String query);
  Future<TvShowDetailModel> getDetail(int id);
  Future<List<TvShowModel>> getRecommendations(int id);
}

class TvShowRemoteDataSourceImpl extends TvShowRemoteDataSource {
  final http.Client client;

  TvShowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvShowModel>> getNowPlaying() async {
    final _response =
        await client.get(Uri.parse('$TV_SHOW_BASE_URL/on_the_air?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvShowModel.createList(jsonDecode(_response.body)['results']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getPopular() async {
    final _response =
        await client.get(Uri.parse('$TV_SHOW_BASE_URL/popular?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvShowModel.createList(jsonDecode(_response.body)['results']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRated() async {
    final _response =
        await client.get(Uri.parse('$TV_SHOW_BASE_URL/top_rated?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvShowModel.createList(jsonDecode(_response.body)['results']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getRecommendations(int id) async {
    final _response = await client
        .get(Uri.parse('$TV_SHOW_BASE_URL/$id/recommendations?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvShowModel.createList(jsonDecode(_response.body)['results']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> search(String query) async {
    final _response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (_response.statusCode == 200) {
      return TvShowModel.createList(jsonDecode(_response.body)['results']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailModel> getDetail(int id) async {
    final _response =
        await client.get(Uri.parse('$TV_SHOW_BASE_URL/$id?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvShowDetailModel.fromJson(jsonDecode(_response.body));
    } else {
      throw ServerException();
    }
  }
}
