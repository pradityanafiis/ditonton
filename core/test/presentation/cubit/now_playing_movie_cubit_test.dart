import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/presentation/cubit/movie/now_playing/now_playing_movie_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetNowPlayingMovie extends Mock implements GetNowPlayingMovies {}

void main() {
  late NowPlayingMovieCubit _nowPlayingMovieCubit;
  late MockGetNowPlayingMovie _mockGetNowPlayingMovie;

  setUp(() {
    _mockGetNowPlayingMovie = MockGetNowPlayingMovie();
    _nowPlayingMovieCubit = NowPlayingMovieCubit(_mockGetNowPlayingMovie);
  });

  test('initial state should be empty', () {
    expect(_nowPlayingMovieCubit.state, NowPlayingMovieInitial());
  });

  blocTest<NowPlayingMovieCubit, NowPlayingMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => _mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return _nowPlayingMovieCubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(() => _mockGetNowPlayingMovie.execute());
    },
  );

  blocTest<NowPlayingMovieCubit, NowPlayingMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockGetNowPlayingMovie.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _nowPlayingMovieCubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockGetNowPlayingMovie.execute());
    },
  );
}
