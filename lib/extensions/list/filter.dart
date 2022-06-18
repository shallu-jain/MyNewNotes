// we have a stream containing a list of things, now we want a stream of the list of the same thing
// as long as those individual thing passes a specific test which is specified using the WHERE clause
extension Filter<T> on Stream<List<T>>{
Stream<List<T>> filter(bool Function(T) where)=>
    map((items) => items.where(where).toList());
}
