//router file 
export 'notification_service_stub.dart'
  if (dart.library.html) 'notification_service_web.dart'
  if (dart.library.io) 'notification_service_android.dart';
//       notificationsPerPeriod: _notificationsPerPeriod,
//       notificationInterval: _notificationInterval,