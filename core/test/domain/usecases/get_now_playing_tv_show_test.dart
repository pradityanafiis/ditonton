import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_now_playing_tv_show.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late final GetNowPlayingTvShow usecase;
  late final MockTvShowRepository mockTvShowRepository;

  setUpAll(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetNowPlayingTvShow(mockTvShowRepository);
  });

  final tTvShow = <TvShow>[];

  test('should get list of tv show from the repository', () async {
    // arrange
    when(mockTvShowRepository.getNowPlaying())
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShow));
  });
}
