import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/presentation/cubit/tv_show/detail/tv_show_detail_cubit.dart';
import 'package:core/presentation/cubit/tv_show/recommendation/tv_show_recommendation_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist/tv_show_watchlist_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist_status/tv_show_watchlist_status_cubit.dart';
import 'package:core/presentation/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvShowDetailCubit extends MockCubit<TvShowDetailState>
    implements TvShowDetailCubit {}

class MockTvShowRecommendationCubit extends MockCubit<TvShowRecommendationState>
    implements TvShowRecommendationCubit {}

class MockTvShowWatchlistStatusCubit
    extends MockCubit<TvShowWatchlistStatusState>
    implements TvShowWatchlistStatusCubit {}

class MockTvShowWatchlistCubit extends MockCubit<TvShowWatchlistState>
    implements TvShowWatchlistCubit {}

void main() {
  late MockTvShowDetailCubit mockTvShowDetailCubit;
  late MockTvShowRecommendationCubit mockTvShowRecommendationCubit;
  late MockTvShowWatchlistStatusCubit mockTvShowWatchlistStatusCubit;
  late MockTvShowWatchlistCubit mockTvShowWatchlistCubit;

  setUpAll(() {
    mockTvShowDetailCubit = MockTvShowDetailCubit();
    mockTvShowRecommendationCubit = MockTvShowRecommendationCubit();
    mockTvShowWatchlistStatusCubit = MockTvShowWatchlistStatusCubit();
    mockTvShowWatchlistCubit = MockTvShowWatchlistCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvShowDetailCubit>.value(
          value: mockTvShowDetailCubit,
        ),
        BlocProvider<TvShowRecommendationCubit>.value(
          value: mockTvShowRecommendationCubit,
        ),
        BlocProvider<TvShowWatchlistStatusCubit>.value(
          value: mockTvShowWatchlistStatusCubit,
        ),
        BlocProvider<TvShowWatchlistCubit>.value(
          value: mockTvShowWatchlistCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailCubit.state)
        .thenReturn(TvShowDetailLoaded(testTvShowDetail));
    when(() => mockTvShowRecommendationCubit.state)
        .thenReturn(TvShowRecommendationLoaded(const <TvShow>[]));
    when(() => mockTvShowWatchlistStatusCubit.state)
        .thenReturn(TvShowWatchlistStatusNotAdded());

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailCubit.state)
        .thenReturn(TvShowDetailLoaded(testTvShowDetail));
    when(() => mockTvShowRecommendationCubit.state)
        .thenReturn(TvShowRecommendationLoaded(const <TvShow>[]));
    when(() => mockTvShowWatchlistStatusCubit.state)
        .thenReturn(TvShowWatchlistStatusAdded());

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const TvShowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailCubit.state)
        .thenReturn(TvShowDetailLoaded(testTvShowDetail));
    when(() => mockTvShowRecommendationCubit.state)
        .thenReturn(TvShowRecommendationLoaded(const <TvShow>[]));
    when(() => mockTvShowWatchlistStatusCubit.state)
        .thenReturn(TvShowWatchlistStatusNotAdded());
    when(() => mockTvShowWatchlistStatusCubit.stream).thenAnswer((_) =>
        Stream.value(
            TvShowWatchlistStatusAdded(message: 'Added to Watchlist')));
    when(() => mockTvShowWatchlistCubit.state)
        .thenReturn(TvShowWatchlistLoaded(const <TvShow>[]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvShowDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
