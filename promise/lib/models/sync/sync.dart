abstract class SyncItem<T> {

}

class SyncUpdate<T> extends SyncItem<T>
{
  final String id;
  final T value;

  SyncUpdate({required this.id, required this.value});
}

class SyncDelete<T> extends SyncItem<T>
{
   final String id;

  SyncDelete({required this.id});
}

class SyncInsert<T> extends SyncItem<T>
{
  final T value;

  SyncInsert({required this.value});
}