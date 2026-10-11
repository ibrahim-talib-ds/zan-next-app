// ZanNext — Cloud Functions shim (Firebase-free)
//
// This used to call Firebase Cloud Functions for Stripe payment init.
// After the Postgres migration, payment flows route through our FastAPI
// backend (see lib/backend/stripe/payment_manager.dart).
//
// The stub below keeps `makeCloudCall` alive so callers still compile
// while we migrate the Stripe flow to hit `/payments/*` endpoints.
// Current behavior: returns an empty map — no network call.

Future<Map<String, dynamic>> makeCloudCall(
  String callName,
  Map<String, dynamic> input,
) async {
  // TODO: route through backend (POST /payments/init) when Stripe is wired.
  // For now, dormant — this function is never executed because the
  // payment flow is disabled.
  return const <String, dynamic>{};
}
