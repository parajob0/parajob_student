part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class GetNotificationsSuccess extends NotificationsState {}
class GetNotificationsError extends NotificationsState {}

class ChangesNotificationStatus extends NotificationsState {}

class GetUnseenNotifications extends NotificationsState {}