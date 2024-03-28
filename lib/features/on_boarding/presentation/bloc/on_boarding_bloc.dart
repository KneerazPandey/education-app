import 'package:bloc/bloc.dart';
import 'package:education_app/features/on_boarding/domian/usecases/cache_first_timer.dart';
import 'package:education_app/features/on_boarding/domian/usecases/check_first_timer.dart';
import 'package:equatable/equatable.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final CacheFirstTimer cacheFirstTimer;
  final CheckFirstTimer checkFirstTimer;

  OnBoardingBloc({
    required this.cacheFirstTimer,
    required this.checkFirstTimer,
  }) : super(OnBoardingInitial()) {
    on<CacheFirstTimerEvent>((event, emit) async {
      emit(CachingFirstTimer());
      final resultEither = await cacheFirstTimer();
      resultEither.fold(
        (failure) => emit(OnBoardingError(message: failure.message)),
        (value) => emit(UserCached()),
      );
    });

    on<CheckFirstTimerEvent>((event, emit) async {
      emit(CheckingFirstTimer());
      final resultEither = await checkFirstTimer();
      resultEither.fold(
        (failure) => emit(const CheckedFirstTimerStatus(isFirstTimer: true)),
        (value) => emit(CheckedFirstTimerStatus(isFirstTimer: value)),
      );
    });
  }
}
