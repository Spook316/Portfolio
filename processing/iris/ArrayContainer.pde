class ArrayContainer
{
  ArrayList array;
  
  ArrayContainer(int size)
  {
    array = new ArrayList(size);
  }
  
  void set(int pos, Object value)
  {
    array.set(pos, value);
  }
  
  Object get(int pos)
  {
    return array.get(pos);
  }
}
