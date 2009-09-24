class Table 
{
  int rowCount;
  String[][] data;
  
  Table(String filename) 
  {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) 
    {
      if (trim(rows[i]).length() == 0) 
      {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) 
      {
        continue;  // skip comment lines
      }
      
      // split the row on the commas
      data[rowCount++] = split(rows[i], ",");
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }
  
  
  int getRowCount() 
  {
    return rowCount;
  }
  
  
  // find a row by its name, returns -1 if no row found
  int getRowIndex(String name) 
  {
    for (int i = 0; i < rowCount; i++) 
    {
      if (data[i][0].equals(name)) 
      {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  String getRowName(int row) 
  {
    return getString(row, 0);
  }


  String getString(int rowIndex, int column) 
  {
    return data[rowIndex][column];
  }

  
  String getString(String rowName, int column) 
  {
    return getString(getRowIndex(rowName), column);
  }

  
  int getInt(String rowName, int column) 
  {
    return parseInt(getString(rowName, column));
  }

  
  int getInt(int rowIndex, int column) 
  {
    return parseInt(getString(rowIndex, column));
  }

  
  float getFloat(String rowName, int column) 
  {
    return parseFloat(getString(rowName, column));
  }

  
  float getFloat(int rowIndex, int column) 
  {
    return parseFloat(getString(rowIndex, column));
  }
  
  
  void setRowName(int row, String what) 
  {
    data[row][0] = what;
  }


  void setString(int rowIndex, int column, String what) 
  {
    data[rowIndex][column] = what;
  }

  
  void setString(String rowName, int column, String what) 
  {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }

  
  void setInt(int rowIndex, int column, int what) 
  {
    data[rowIndex][column] = str(what);
  }

  
  void setInt(String rowName, int column, int what) 
  {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }

  
  void setFloat(int rowIndex, int column, float what) 
  {
    data[rowIndex][column] = str(what);
  }


  void setFloat(String rowName, int column, float what) 
  {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }  
  
  
  HashMap calculateSummaryStats(int column, int filterColumn)
  {
    HashMap summaryStats = new HashMap();
    
    // Use a column to filter the results
    if (filterColumn >= 0)
    {
      for (int i = 0; i < rowCount; i++)
      {
        // Add a new set of stats for a new filter value
        if (!summaryStats.containsKey(getString(i, filterColumn)))
        {
          //Rows for mean, median, mode, min, max, variance
          summaryStats.put(getString(i, filterColumn), new ArrayList(7));
          ArrayList array = (ArrayList)summaryStats.get(getString(i, filterColumn));
          Float f = 1.f;
          
          array.add(0, f);
          array.add(1, getFloat(i, column));
        }
        else
        {
          ArrayList array = (ArrayList)summaryStats.get(getString(i, filterColumn));
          array.set(0, (Float)array.get(0) + 1);
          array.set(1, (Float)array.get(1) + getFloat(i, column));
        }
      }
    }
    
    // Used for sorting the data for each filter type
    float sortedArray[][] = new float[summaryStats.size()][];
    
    
    Iterator iter = summaryStats.entrySet().iterator();
    int i = 0;
    
    // Iterate over the filter types
    while(iter.hasNext())
    {
      Map.Entry e = (Map.Entry)iter.next();
      ArrayList array = (ArrayList)e.getValue();
      
      // For calculate the mean by taking the previous value and dividing by the total of that type
      array.set(1, (Float)array.get(1) / (Float)array.get(0));
      
      // Create arrays of data for each filter type, then sort them
      sortedArray[i] = new float[int((Float)(array.get(0)))];
      int k = 0;
      for (int j = 0; j < rowCount; j++)
      {
        if (getString(j, filterColumn).equals(e.getKey()))
        {
          sortedArray[i][k] = getFloat(j, column);
          k++;
        }
      }
      sortedArray[i] = sort(sortedArray[i]);
      
      // Calculate the median
      if (int((Float)array.get(0)) % 2 == 0)
      {
        array.add(2, (sortedArray[i][int((Float)array.get(0)) / 2 - 1] + sortedArray[i][int((Float)array.get(0)) / 2]) / 2);   
      }
      else
      {
        array.add(2, sortedArray[i][int((Float)array.get(0)) / 2 + 1]);
      }
      
      
      // Calculate the mode, min, max, and the variance
      int maxMode = 0;
      int tempMode = 0;
      float modeVal = sortedArray[i][0];
      float tempModeVal = sortedArray[i][0];
      
      array.add(3, modeVal);
      
      //Get the minimum
      array.add(4, sortedArray[i][0]);

      //Get the maximum
      array.add(5, sortedArray[i][sortedArray[i].length - 1]);
      
      array.add(6, ((Float)0.f));
      
      for (int j = 0; j < int((Float)array.get(0)); j++)
      {
        if (sortedArray[i][j] == tempModeVal)
        {
          tempMode++;
        }
        else
        {
          if (tempMode > maxMode)
          {
            maxMode = tempMode;
            modeVal = tempModeVal;
          }
          
          tempModeVal = sortedArray[i][j];
          tempMode = 1;
        }
         
        array.set(6, ((Float)array.get(6)) + (sortedArray[i][j] - ((Float)array.get(1))) * (sortedArray[i][j] - ((Float)array.get(1))));
      }    
      
      array.set(3, modeVal);
      array.set(6, (Float)array.get(6) / (Float)array.get(0)); 
      
      //println(e.getKey() + ": " + array.get(0) + " " + array.get(1) + " " + array.get(2) + " " + array.get(3) + " " + array.get(4) + " " + array.get(5) + " " + array.get(6));
      i++;
    }
    return summaryStats;    
  }
}
