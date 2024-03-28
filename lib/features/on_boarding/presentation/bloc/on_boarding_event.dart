part of 'on_boarding_bloc.dart';

sealed class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class CacheFirstTimerEvent extends OnBoardingEvent {}

class CheckFirstTimerEvent extends OnBoardingEvent {}
