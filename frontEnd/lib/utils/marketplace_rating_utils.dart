class MarketplaceRatingState {
  const MarketplaceRatingState({
    required this.totalRatingsCount,
    required this.averageRating,
    required this.userRating,
  });

  final int totalRatingsCount;
  final double averageRating;
  final int userRating;
}

MarketplaceRatingState applyMarketplaceRating({
  required MarketplaceRatingState current,
  required int newRating,
}) {
  final int normalizedRating = newRating.clamp(1, 5);
  final int normalizedCount = current.totalRatingsCount < 0
      ? 0
      : current.totalRatingsCount;

  double nextAverage;
  int nextCount = normalizedCount;

  if (current.userRating == 0 || normalizedCount == 0) {
    nextAverage =
        ((current.averageRating * normalizedCount) + normalizedRating) /
        (normalizedCount + 1);
    nextCount = normalizedCount + 1;
  } else {
    nextAverage =
        ((current.averageRating * normalizedCount) -
            current.userRating +
            normalizedRating) /
        normalizedCount;
  }

  return MarketplaceRatingState(
    totalRatingsCount: nextCount,
    averageRating: nextAverage.clamp(1.0, 5.0),
    userRating: normalizedRating,
  );
}
