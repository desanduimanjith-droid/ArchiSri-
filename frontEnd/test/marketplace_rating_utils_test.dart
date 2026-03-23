import 'package:archisri_1/utils/marketplace_rating_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('applyMarketplaceRating', () {
    test('first-time rating increments count and recalculates average', () {
      const current = MarketplaceRatingState(
        totalRatingsCount: 24,
        averageRating: 4.5,
        userRating: 0,
      );

      final next = applyMarketplaceRating(current: current, newRating: 5);

      expect(next.totalRatingsCount, 25);
      expect(next.userRating, 5);
      expect(next.averageRating, closeTo(4.52, 0.01));
    });

    test('updating rating keeps count and adjusts average correctly', () {
      const current = MarketplaceRatingState(
        totalRatingsCount: 25,
        averageRating: 4.52,
        userRating: 5,
      );

      final next = applyMarketplaceRating(current: current, newRating: 3);

      expect(next.totalRatingsCount, 25);
      expect(next.userRating, 3);
      expect(next.averageRating, closeTo(4.44, 0.01));
    });

    test('normalizes out-of-range new ratings to 1..5', () {
      const current = MarketplaceRatingState(
        totalRatingsCount: 10,
        averageRating: 4.0,
        userRating: 0,
      );

      final high = applyMarketplaceRating(current: current, newRating: 99);
      final low = applyMarketplaceRating(current: current, newRating: -4);

      expect(high.userRating, 5);
      expect(low.userRating, 1);
    });

    test('handles zero count gracefully even with existing user rating', () {
      const current = MarketplaceRatingState(
        totalRatingsCount: 0,
        averageRating: 4.5,
        userRating: 4,
      );

      final next = applyMarketplaceRating(current: current, newRating: 2);

      expect(next.totalRatingsCount, 1);
      expect(next.userRating, 2);
      expect(next.averageRating, 2.0);
    });
  });
}
