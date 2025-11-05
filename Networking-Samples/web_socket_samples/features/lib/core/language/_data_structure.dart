part of core_language;
//TODO:Data structure

class Pair<U,V>{
  final U first;
  final V second;
  const Pair(this.first,this.second);
  @override
  String toString() {
    return 'Pair(first: $first, second: $second)';
  }
  Pair<U,V> changeFirst(U value)=>Pair(value, second);
  Pair<U,V> changeSecond(V value)=>Pair(first, value);
}
///Just need next for now
class PaginationWrapper<T> {
  final T data;
  final int totalPage;
  final int count;
  final String? nextUrl;
  PaginationWrapper({required this.data,   this.totalPage=0,  this.count=0,this.nextUrl});

  @override
  String toString() {
    return 'PaginationWrapper(data: ${data.runtimeType}, totalPage: $totalPage,count:$count,next:$nextUrl)';
  }
}
