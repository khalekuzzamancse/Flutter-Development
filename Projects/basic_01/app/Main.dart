import '../feature/calculator/Adder.dart';      
void main(){
  Adder myAdder = Adder();
  int sum = myAdder.add(5, 3);
  print('Sum: $sum');
 
}