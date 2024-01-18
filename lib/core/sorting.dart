enum NullSort {
  first,
  last
}

extension MultiSortedByExtension<T> on Iterable<T> {
  /// Sort a list by multiple selectors and return a new list.
  /// The selectors are applied in the order they are passed.
  /// If a selector returns null, the behavior is determined by [nullSort].
  /// If [nullSort] is [NullSort.first], null elements are sorted first.
  /// If [nullSort] is [NullSort.last], null elements are sorted last.
  /// null elements are considered equal to each other.
  ///
  /// Example:
  ///
  /// ```dart
  /// void main() {
  ///   final list = [
  ///     Person(name: 'John', age: 21),
  ///     Person(name: 'John', age: 20),
  ///     Person(name: 'John', age: null),
  ///     Person(name: 'Jane', age: 20),
  ///     Person(name: null, age: 20),
  ///   ];
  ///
  ///   list.sortedBy([
  ///     (p) => p.name,
  ///     (p) => p.age
  ///   ]).forEach(print);
  /// }
  /// ```
  ///
  /// This prints:
  ///
  /// ```
  /// John, null
  /// John, 20
  /// John, 21
  /// Jane, 20
  /// null, 20
  /// ```
  ///
  /// See also:
  ///
  /// * [sortedByDescending] for a descending sort.
  /// * [NullSort] for the behavior of null elements.
  Iterable<T> sortedBy(
      List<Comparable? Function(T)> selectors,
      {NullSort nullSort = NullSort.last}
  ) {
    var listToSort = List<T>.from(this);

    listToSort.sort((a, b) {
      for (var selector in selectors) {
        final valueA = selector(a);
        final valueB = selector(b);

        if (valueA == null && valueB == null) continue;

        if (valueA == null) return nullSort == NullSort.first ? 1 : -1;
        if (valueB == null) return nullSort == NullSort.first ? -1 : 1;

        final comparisonResult = valueA.compareTo(valueB);
        if (comparisonResult != 0) return comparisonResult;
      }
      return 0;
    });

    return listToSort;
  }

  /// Sort a list by multiple selectors in descending order and return a new list.
  ///
  /// See [sortedBy] for more details.
  Iterable<T> sortedByDescending(
      List<Comparable? Function(T)> selectors,
      {NullSort nullSort = NullSort.last}
  ) {
    return sortedBy(selectors, nullSort: nullSort).toList().reversed;
  }
}