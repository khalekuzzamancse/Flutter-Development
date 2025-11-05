part of remote_data_source;
class ApiConst {
  static String get keyOrderTypeDelivery => "DELIVERY";
  static String get keyOrderTypeCollection => "COLLECTION.";
  static String get keyOrderTypeTakeAway => "TAKE_AWAY.";
  static String get keyOrderTypeEatIn => "EAT_IN.";
  static String get valuePaid => "PAID.";
  static String get valueUnPaid => "UNPAID";
  static String get valueOrderStatusCancel => "CANCELED.";
  static String get valueOrderStatusClosed => "CLOSED.";
  static String get valueOrderStatusComplete => "COMPLETED.";
  static String get keyOrderStatus => "status";
  static String get keyPaymentStatus => "payment_status";
  static String get keyPaymentMethodCash => "Cash";
  static String get keyPaymentMethodCard=> "Card";
 static String get paymentMethodUnknown=>'Unknown';
  static String get keyDeliveryStatus => "delivery_status";
  static String get keyOrderSource => "order_source";
  static String get keyOrderType => "order_type";
  static String get valueOrderPending=>'OPEN.';
  static List<String> get paymentOptions => ['PAID.', 'UNPAID'];

  static List<Pair<int,String>> get countryPkAndNames=>[const Pair(19, "Bangladesh"),const Pair(229, 'United Kingdom')];
  static List<String> get orderSourceOptions =>
      ['WEBSITE', 'APP.', 'SOCIAL_MEDIA.'];

  static List<String> get orderStatus =>
      ["OPEN.", "IN_PROGRESS.", "READY.", "CLOSED.", "PACKED.", "COMPLETED.", "CANCELED."];

  static List<String> get deliveryStatusOptions =>
      ['PENDING', 'WAITING', 'PICKED_UP', 'DELIVERED', 'RETURNED', 'CANCELED'];

  static List<String> get orderTypeOptions =>
      const ['DELIVERY', 'COLLECTION.', 'TAKE_AWAY.', 'EAT_IN.'];

  static List<String> get deliveryTypeOptions =>
      const ['INTERNAL_DELIVERY', 'EXTERNAL_DELIVERY', 'SELF_PICKUP'];

  static bool isTerminalState(String status) {
    final normalizedStatus =
        status.cleanAndCapitalizeOrOriginal().toLowerCase();
    const terminalStates = {'closed', 'canceled', 'cancelled', 'completed'};
    return terminalStates.contains(normalizedStatus);
  }
  static int getCountryCodeOrThrow(String name) {
    try {
      final match = countryPkAndNames.firstWhere(
            (pair) => pair.second.toLowerCase() == name.toLowerCase(),
      );
      return match.first;
    } catch (_) {
      throw CustomException(message:'Invalid country',debugMessage: 'DevsStreamApiConst::getCountryCode');
    }
  }
}