//@formatter:off
class CardModel {
  final String cardName,cardNo,dueDate,amount, type;
  CardModel( {required this.type, required this.cardName, required this.cardNo, required this.dueDate, required this.amount});
}
//@formatter:off
class LoanModel {
  final String model, imageLink,price,date;
  final int rating,ratingMax;

  const LoanModel({required this.model, required this.imageLink, required this.price,
    required this.date, required this.rating, required this.ratingMax});
}