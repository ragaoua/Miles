class Exercise {
  final int id;
  final int sessionId;
  final int order;
  final int supersetOrder;
  final int movementId;
  final RatingType ratingType;

  Exercise({
    this.id = 0,
    this.sessionId = 0,
    this.order = 0,
    this.supersetOrder = 0,
    this.movementId = 0,
    this.ratingType = RatingType.rpe,
  });
}

enum RatingType {
  rpe, rir
}