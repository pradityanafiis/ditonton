import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_top_rated_tv_show.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top_rated_tv_show_state.dart';

class TopRatedTvShowCubit extends Cubit<TopRatedTvShowState> {
  final GetTopRatedTvShow _getTopRatedTvShow;

  TopRatedTvShowCubit(this._getTopRatedTvShow) : super(TopRatedTvShowInitial());

  void resetState() {
    emit(TopRatedTvShowInitial());
  }

  void getAll() async {
    emit(TopRatedTvShowLoading());

    final _result = await _getTopRatedTvShow.execute();

    _result.fold(
      (failure) {
        emit(TopRatedTvShowError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(TopRatedTvShowHasData(data));
        } else {
          emit(const TopRatedTvShowError('TV Show not found.'));
        }
      },
    );
  }
}
