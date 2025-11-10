//@formatter:off
class CardModel {
  final String cardName,cardNo,dueDate,amount, type;
  CardModel( {required this.type, required this.cardName, required this.cardNo, required this.dueDate, required this.amount});
}
//@formatter:off
class LoanModel {
  final String name, imageLink,price,date;
 final LoanStatus status;
  const LoanModel({required this.name, required this.imageLink, required this.price,
    required this.date,required this.status});
}
enum LoanStatus {
  pending, due, approved,none;
  String get label {
    switch (this) {
      case LoanStatus.pending:
        return 'Pending';
      case LoanStatus.due:
        return 'Due';
      case LoanStatus.approved:
        return 'Approved';
      default:
        return 'N/A';
    }
  }
}
