Table data;

// Summary stats for all columns
HashMap sepalLenStats;
HashMap sepalWidStats;
HashMap petalLenStats;
HashMap petalWidStats;

// Points for the bar-graph plot
float plotX1;
float plotX2;
float plotY1;
float plotY2;

// Points for the scatter-plot 
float plotX3;
float plotX4;
float plotY3;
float plotY4;

float width = 740;
float height = 640;
float barWidth = 15;
float barGap;
float multiplier = 20;

PFont font;
ArrayList colors;

void setup()
{
  size(810, 700);
  font = loadFont("Courier10PitchBT-Roman-12.vlw");
  textFont(font, 12);
  
  data = new Table("irisData/iris.data");
  
  plotX1 = 50;
  plotX2 = width - plotX1;
  plotY1 = 60;
  plotY2 = height / 2;
  
  plotX3 = 50;
  plotX4 = width - plotX3;
  plotY3 = plotY2 + 40;
  plotY4 = height;
  
  sepalLenStats = data.calculateSummaryStats(0, 4);
  sepalWidStats = data.calculateSummaryStats(1, 4);
  petalLenStats = data.calculateSummaryStats(2, 4);
  petalWidStats = data.calculateSummaryStats(3, 4);
  
  colors = new ArrayList();
  Iterator iter = sepalLenStats.entrySet().iterator();
     
  while(iter.hasNext())
  { 
    Map.Entry e = (Map.Entry)iter.next();
    colors.add(color(random(255), random(255), random(255)));
  }
  
  barGap = colors.size() * barWidth + (2.5 * barWidth);
  smooth();
}

void draw()
{
	background(224);

	fill(255);
	rectMode(CORNERS);
	noStroke();
	rect(plotX1, plotY1, plotX2, plotY2);

        drawBars();
        drawLengthLabels(plotX1, plotY1, plotX2, plotY2);
        drawAttributeLabels(plotX1 + 30);
        drawLengthLabels(plotX1 + (4 * barGap), plotY1, plotX1 + (4 * barGap), plotY2);
        drawAttributeLabels(plotX1 + 30 + (4 * barGap));
        drawKey(plotX2 + 5, plotY2 / 2);
        
        fill(255);
        noStroke();
        rect(plotX3, plotY3, plotX4, plotY4);
        
        drawPoints();
        drawLengthLabels(plotX3, plotY3, plotX4, plotY4);
        drawUnderLengthLabels();
        drawKey(plotX4 + 5, plotY4 * 3 / 4);
}

void drawBars()
{
  float lastPos = plotX1 + 5;
  
  fill(0);
  text("Mean", lastPos + barGap, plotY1);
  text("Max", lastPos + (5 * barGap), plotY1);
  
  Iterator sepalLenIter = sepalLenStats.entrySet().iterator();
  Iterator sepalWidIter = sepalWidStats.entrySet().iterator();
  Iterator petalLenIter = petalLenStats.entrySet().iterator();
  Iterator petalWidIter = petalWidStats.entrySet().iterator();
  int i = 0;
   
  while(sepalLenIter.hasNext())
  {
    fill((Integer)colors.get(i));
    
    Map.Entry sepalLenEntry = (Map.Entry)sepalLenIter.next();
    ArrayList sepalLenArray = (ArrayList)sepalLenEntry.getValue();
    
    Map.Entry sepalWidEntry = (Map.Entry)sepalWidIter.next();
    ArrayList sepalWidArray = (ArrayList)sepalWidEntry.getValue();
          
    Map.Entry petalLenEntry = (Map.Entry)petalLenIter.next();
    ArrayList petalLenArray = (ArrayList)petalLenEntry.getValue();
          
    Map.Entry petalWidEntry = (Map.Entry)petalWidIter.next();
    ArrayList petalWidArray = (ArrayList)petalWidEntry.getValue();
    
    float y = map((Float)sepalLenArray.get(1), 0 , 10, plotY2, plotY1);    
    rect(lastPos, y, lastPos + barWidth, plotY2);
    
    y = map((Float)sepalWidArray.get(1), 0 , 10, plotY2, plotY1); 
    rect(lastPos + barGap, y, lastPos + barWidth + barGap, plotY2);
    
    y = map((Float)petalLenArray.get(1), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (2 * barGap), y, lastPos + barWidth + (2 * barGap), plotY2);
    
    y = map((Float)petalWidArray.get(1), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (3 * barGap), y, lastPos + barWidth + (3 * barGap), plotY2);
    
    y = map((Float)sepalLenArray.get(5), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (4 * barGap), y, lastPos + barWidth + (4 * barGap), plotY2);
    
    y = map((Float)sepalWidArray.get(5), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (5 * barGap), y, lastPos + barWidth + (5 * barGap), plotY2);
    
    y = map((Float)petalLenArray.get(5), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (6 * barGap), y, lastPos + barWidth + (6 * barGap), plotY2);
    
    y = map((Float)petalWidArray.get(5), 0 , 10, plotY2, plotY1); 
    rect(lastPos + (7 * barGap), y, lastPos + barWidth + (7 * barGap), plotY2);
          
    lastPos += barWidth;
    i++;
  }
}

void drawPoints()
{
  fill(0);
  text("Sepal Length", plotX4 + 10, plotY4);
  text("Sepal Width", plotX3 - 40, plotY3 - 10);
  
  strokeWeight(5);
  Iterator sepalLenIter;
  int i;
  
  for (int row = 0; row < data.getRowCount(); row++)
  {
     sepalLenIter = sepalLenStats.entrySet().iterator();
     i = 0;
   
     while(sepalLenIter.hasNext())
     {
       Map.Entry sepalLenEntry = (Map.Entry)sepalLenIter.next();
       if (sepalLenEntry.getKey().equals((data.getString(row, 4))))
       {
         stroke((Integer)colors.get(i));
         break;
       }
       i++;
     }
     
     float x = map(data.getFloat(row, 0), 0, 10, plotX3, plotX4);
     float y = map(data.getFloat(row, 1), 0, 10, plotY4, plotY3);
     point(x, y);
  }
}

void drawLengthLabels(float x1, float y1, float x2, float y2)
{
  fill(0);
  textSize(10);
  
  stroke(128);
  strokeWeight(1);
  line(x1, y1, x1, y1);
  
  for (float i = 0; i <= 10; i += 1) 
  {
      for (int j = 0; j < 2 ; ++j)
      {
        if (i == 10 && j == 1)
        {
          break;
        }
        float y = map(i+(.5*j), 0, 10, y2, y1);
        
        if (j == 0)
        {
          if (i == 0) 
          {
            textAlign(RIGHT); // Align by the bottom
          } 
          else if (i == 10) 
          {
            textAlign(RIGHT, TOP); // Align by the top
          } 
          else 
          {
            textAlign(RIGHT, CENTER); // Center vertically
          }
          text(floor(i), x1 - 10, y);
          line(x1 - 4, y, x1, y); 
        }
        else
        {
          line(x1 - 2, y, x1, y);
        }
        
      }
  }
}

void drawAttributeLabels(float startPos)
{
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  
  text("Sepal Length", startPos, plotY2 + 10);
  text("Sepal Width", startPos + barGap, plotY2 + 10);
  text("Petal Length", startPos + (2 * barGap), plotY2 + 10);
  text("Petal Width", startPos + (3 * barGap), plotY2 + 10);
}

void drawKey(float x, float y)
{
  textAlign(LEFT, TOP);
  Iterator iter = sepalLenStats.entrySet().iterator();
  int i = 0;
  
  while(iter.hasNext())
  {
    fill((Integer)colors.get(i));
    
    Map.Entry e = (Map.Entry)iter.next();
    
    rect(x, y, x + 10, y + 10);
    fill(0);
    text((String)e.getKey(), x + 15, y + 3);
    y += 15;
    i++;
  }
  
  text("Measurements in cm", x, y);
}

void drawUnderLengthLabels()
{
  for (int i = 0; i <= 10; i++)
  {
    for (int j = 0; j < 2; ++j)
    {
      if (i == 10 && j == 1)
      {
        break;
      }
      
      float x = map(i+(.5*j), 0, 10, plotX3, plotX4);
      
      if (j == 0)
        {
          textAlign(CENTER);
          text(floor(i), x, plotY4 + 15);
          line(x, plotY4 + 4, x, plotY4); 
        }
        else
        {
          line(x, plotY4 + 2, x, plotY4);
        }
    }
  }
}

	
