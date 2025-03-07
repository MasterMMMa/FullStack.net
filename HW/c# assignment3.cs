// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");
//Practice working with Generics
//1. Create a custom Stack class MyStack<T> that can be used with any data type which
//has following methods
//1. int Count()
//2. T Pop()
//3. Void Push()

public class Mystack<T>
{
    private List<T> myList = new List<T>();
    public int Count()
    {
        return myList.Count;
    }

    public T Pop()
    {
        T item = myList[myList.Count - 1];
        myList.RemoveAt(myList.Count - 1);
        return item;
    }

    public void Push(T item)
    {
        myList.Add(item);
    }
}



//2. Create a Generic List data structure MyList<T> that can store any data type.
//Implement the following methods.
//1. void Add (T element)
//2. T Remove (int index)
//3. bool Contains (T element)
//4. void Clear ()
//5. void InsertAt (T element, int index)
//6. void DeleteAt (int index)
//7. T Find (int index)

public class MyList<T>
{
    private T[] myList;
    private int size = 0;
    private int capacity = 10;
    MyList() //constructor
    {
        myList = new T[capacity];
    }

    public void Add(T item)
    {
        if (size == myList.Length)
        {
            IncreaseCapacity();
        }
        myList[size] = item;
        size++;
    }

    public T Remove(int index)
    {
        T item = myList[index];
        for (int i = index; i < size;i++)
        {
            myList[i] = myList[i + 1];
        }
        size--;
        myList[size - 1] = default(T);
        return item;
    }

    public bool Contains(T item)
    {
        for (int i = 0; i < size; i++)
        {
            if (EqualityComparer<T>.Default.Equals(myList[i], item))
            {
                return true;
            }
        }
        return false;
    }

    public void Clear()
    {
        myList = new T[capacity];
        size = 0;
    }

    public void InserAt(T element, int index)
    {
        if (size == myList.Length)
        {
            IncreaseCapacity();
        }
        for (int  i = index + 1;  i < size;  i++)
        {
            myList[i] = myList[i - 1];
        }
        myList[index] = element;
        size++;
    }

    public void DeleteAt(int index)
    {
        for (int i = index; i < size; i++)
        {
            myList[i] = myList[i + 1];
        }
        size--;
        myList[size - 1] = default(T);
    }

    public T Find(int index)
    {
        return myList[index];
    }


    private void IncreaseCapacity()
    {
        capacity = capacity * 2;
        T[] temp = new T[capacity];
        for (int i = 0; i < size; i++)
        {
            temp[i] = myList[i];
        }
        myList = temp;
    }
}




//3. Implement a GenericRepository<T> class that implements IRepository<T> interface
//that will have common /CRUD/ operations so that it can work with any data source
//such as SQL Server, Oracle, In-Memory Data etc. Make sure you have a type constraint
//on T were it should be of reference type and can be of type Entity which has one
//property called Id. IRepository<T> should have following methods
//1. void Add(T item)
//2. void Remove(T item)
//3. Void Save()
//4. IEnumerable<T> GetAll()
//5. T GetById(int id)

public class database
{
    public int Id { get; set; }
}
public interface IRepository<T> where T : class
{
    void Add(T item);
    void Remove(T item);
    void Save();
    IEnumerable<T> GetAll();
    T GetById(int id);
}

public class GenericRepository<T> : IRepository<T> where T : database
{
    private List<T> myList = new List<T>();
    public void Add(T item)
    {
        myList.Add(item);
    }

    public void Remove(T item)
    {
        myList.Remove(item);
    }

    public void Save()
    {
        //Save to database
    }

    public IEnumerable<T> GetAll()
    {
        return myList;
    }

    public T GetById(int id)
    {
        return myList.FirstOrDefault(x => x.Id == id);
    }
}