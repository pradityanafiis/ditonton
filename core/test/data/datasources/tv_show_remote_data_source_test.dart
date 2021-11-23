import 'dart:convert';
import 'dart:io';

import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/data/models/tv_show_model.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvShowRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvShowRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get now playing tv show', () {
    final _tTvShowList = TvShowModel.createList(
        jsonDecode(readJson('dummy_data/tv_show_now_playing.json'))['results']);

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$TV_SHOW_BASE_URL/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show_now_playing.json'), 200));
      // act
      final result = await dataSource.getNowPlaying();
      // assert
      expect(result, equals(_tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$TV_SHOW_BASE_URL/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlaying();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tv show', () {
    final _tTvShowList = TvShowModel.createList(
        jsonDecode(readJson('dummy_data/tv_show_popular.json'))['results']);

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$TV_SHOW_BASE_URL/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_show_popular.json'), 200));
      // act
      final result = await dataSource.getPopular();
      // assert
      expect(result, equals(_tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$TV_SHOW_BASE_URL/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopular();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated tv show', () {
    final _tTvShowList = TvShowModel.createList(
        jsonDecode(readJson('dummy_data/tv_show_top_rated.json'))['results']);

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$TV_SHOW_BASE_URL/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_show_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRated();
      // assert
      expect(result, equals(_tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$TV_SHOW_BASE_URL/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRated();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show detail', () {
    const tId = 1;
    final tTvShowDetail = TvShowDetailModel.fromJson(
        jsonDecode(readJson('dummy_data/tv_show_detail.json')));

    test('should return tv show detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$TV_SHOW_BASE_URL/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv_show_detail.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              ));
      // act
      final result = await dataSource.getDetail(tId);
      // assert
      expect(result, equals(tTvShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$TV_SHOW_BASE_URL/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show recommendations', () {
    final tMovieList = TvShowModel.createList(json.decode(
        readJson('dummy_data/tv_show_recommendations.json'))['results']);
    const tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$TV_SHOW_BASE_URL/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv_show_recommendations.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              ));
      // act
      final result = await dataSource.getRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$TV_SHOW_BASE_URL/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv show', () {
    final tSearchResult = TvShowModel.createList(
        jsonDecode(readJson('dummy_data/search_tv_show.json'))['results']);
    const tQuery = '911';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_tv_show.json'), 200));
      // act
      final result = await dataSource.search(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.search(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
