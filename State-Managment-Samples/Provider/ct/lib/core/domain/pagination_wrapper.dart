///Just need next for now
class PaginationWrapper<T> {
  final T data;
  final String? next;
  PaginationWrapper({required this.data, this.next});

  @override
  String toString() {
    return 'PaginationWrapper(data: $data, next: $next)';
  }
}
