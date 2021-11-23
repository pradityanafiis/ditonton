import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv_show.dart';
import 'package:search/presentation/bloc/search_tv_show_bloc.dart';

import 'search_tv_show_bloc_test.mocks.dart';

@GenerateMocks([SearchTvShow])
void main() {
  late SearchTvShowBloc _searchTvShowBloc;
  late MockSearchTvShow _mockSearchTvShow;

  setUp(() {
    _mockSearchTvShow = MockSearchTvShow();
    _searchTvShowBloc = SearchTvShowBloc(_mockSearchTvShow);
  });

  final testTvShow = TvShow(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
  );
  final testTvShowList = [testTvShow];
  const tQuery = '9-1-1';

  test('initial state should be empty', () {
    expect(_searchTvShowBloc.state, SearchEmpty());
  });

  blocTest<SearchTvShowBloc, SearchTvShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(_mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => Right(testTvShowList));
      return _searchTvShowBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(testTvShowList),
    ],
    verify: (bloc) {
      verify(_mockSearchTvShow.execute(tQuery));
    },
  );

  blocTest<SearchTvShowBloc, SearchTvShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(_mockSearchTvShow.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _searchTvShowBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(_mockSearchTvShow.execute(tQuery));
    },
  );
}
