import 'package:core/domain/entities/tv_show.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv_show.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvShow usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = SearchTvShow(mockTvShowRepository);
  });

  final tTvShow = <TvShow>[];
  const tQuery = '9-1-1';

  test('should get list of tv show from the repository', () async {
    // arrange
    when(mockTvShowRepository.search(tQuery))
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvShow));
  });
}
