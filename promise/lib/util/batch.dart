List<List<T>>batch<T>(List<T> list, int itemPerBatch){
  List<List<T>> result = List.empty(growable: true);
  int count = -1;
  for(int i = 0; i < list.length; i ++) {
    if(i % itemPerBatch == 0){
      result.add(List<T>.empty(growable: true));
      count++;
    }
    
    result[count].add(list[i]);
  }

  return result;
}