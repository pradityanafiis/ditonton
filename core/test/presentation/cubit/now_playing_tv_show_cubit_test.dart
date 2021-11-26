import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_now_playing_tv_show.dart';
import 'package:core/presentation/cubit/tv_show/now_playing/now_playing_tv_show_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetNowPlayingTvShow extends Mock implements GetNowPlayingTvShow {}

void main() {
  late NowPlayingTvShowCubit _cubit;
  late MockGetNowPlayingTvShow _mockUseCase;

  setUp(() {
    _mockUseCase = MockGetNowPlayingTvShow();
    _cubit = NowPlayingTvShowCubit(_mockUseCase);
  });

  test('initial state should be empty', () {
    expect(_cubit.state, NowPlayingTvShowInitial());
  });

  blocTest<NowPlayingTvShowCubit, NowPlayingTvShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      NowPlayingTvShowLoading(),
      NowPlayingTvShowHasData(testTvShowList),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );

  blocTest<NowPlayingTvShowCubit, NowPlayingTvShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      NowPlayingTvShowLoading(),
      const NowPlayingTvShowError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );
}
