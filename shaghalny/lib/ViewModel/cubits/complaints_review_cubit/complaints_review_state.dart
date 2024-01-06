part of 'complaint_review_cubit.dart';


abstract class ComplaintReviewState {}

class ComplaintReviewInitial extends ComplaintReviewState {}

class SubmitReviewLoading extends ComplaintReviewState {}
class SubmitReviewSuccess extends ComplaintReviewState {}

class ComplaintAboutPlaceLoading extends ComplaintReviewState {}
class ComplaintAboutPlaceSuccess extends ComplaintReviewState {}

class ComplaintAboutJobLoading extends ComplaintReviewState {}
class ComplaintAboutJobSuccess extends ComplaintReviewState {}

class AppComplaintLoading extends ComplaintReviewState {}
class AppComplaintSuccess extends ComplaintReviewState {}