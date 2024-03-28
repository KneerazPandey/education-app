part of 'on_boarding_bloc.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

class OnBoardingInitial extends OnBoardingState {}

class CachingFirstTimer extends OnBoardingState {}

class CheckingFirstTimer extends OnBoardingState {}

class UserCached extends OnBoardingState {}

class CheckedFirstTimerStatus extends OnBoardingState {
  final bool isFirstTimer;

  const CheckedFirstTimerStatus({
    required this.isFirstTimer,
  });

  @override
  List<Object> get props => [isFirstTimer];
}

class OnBoardingError extends OnBoardingState {
  final String message;

  const OnBoardingError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
