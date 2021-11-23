import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_tv_show_recommendations.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late final GetTvShowRecommendations usecase;
  late final MockTvShowRepository mockTvShowRepository;

  setUpAll(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowRecommendations(mockTvShowRepository);
  });

  const tId = 1;
  final tTvShow = <TvShow>[];

  test('should get list of movie recommendations from the repository',
      () async {
    // arrange
    when(mockTvShowRepository.getRecommendations(tId))
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvShow));
  });
}
