import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/presentation/cubit/tv_show/top_rated/top_rated_tv_show_cubit.dart';
import 'package:core/presentation/pages/top_rated_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTvShowCubit extends MockCubit<TopRatedTvShowState>
    implements TopRatedTvShowCubit {}

void main() {
  late MockTopRatedTvShowCubit _mockTopRatedTvShowCubit;

  setUpAll(() {
    _mockTopRatedTvShowCubit = MockTopRatedTvShowCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvShowCubit>.value(
      value: _mockTopRatedTvShowCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => _mockTopRatedTvShowCubit.state)
        .thenReturn(TopRatedTvShowLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvShowPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => _mockTopRatedTvShowCubit.state)
        .thenReturn(const TopRatedTvShowHasData(<TvShow>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvShowPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => _mockTopRatedTvShowCubit.state)
        .thenReturn(const TopRatedTvShowError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvShowPage()));

    expect(textFinder, findsOneWidget);
  });
}
