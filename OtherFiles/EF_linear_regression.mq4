//+------------------------------------------------------------------+
//|                                            Linear Regression.mq4 |
//|                Copyright © 2006, tageiger, aka fxid10t@yahoo.com |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, tageiger, aka fxid10t@yahoo.com"
#property link      "http://www.metaquotes.net"
#property indicator_chart_window
//----
extern int period=0;

/*default 0 means the channel will use the open time from "x" bars back on which ever time period 
the indicator is attached to.  one can change to 1,5,15,30,60...etc to "lock" the start time to a specific 
period, and then view the "locked" channels on a different time period...*/

extern int window_size=400;   // bars back regression begins


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
{
   return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  { 
  ObjectDelete("Regression Line");
 return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int start()
  {//refresh chart
  
   ObjectDelete("Regression Line");

   //linear regression calculation
   int start.bar = window_size;
   int end.bar   = 0;
   int n = start.bar - end.bar + 1;
   
   //---- calculate price values
   double value = iClose(Symbol(),period,end.bar);
   double a,b,c;
   double sumy  = value;
   double sumx  = 0.0;
   double sumxy = 0.0;
   double sumx2 = 0.0;
   
   for(int i=1; i<n; i++)
     {
      value  = iClose(Symbol(),period,end.bar+i);
      sumy  += value;
      sumxy += value*i;
      sumx  += i;
      sumx2 += i*i;
     }
     
   c = sumx2*n - sumx*sumx;
   
   if (c==0.0) 
      return;
   
   b = (sumxy*n-sumx*sumy)/c;
   a = (sumy-sumx*b)/n;
   
   double end_regression_value = a;
   double start_regression_value = a + b*n;
   
   
   //Linear regression trendline
   //ObjectCreate("Regression Line", OBJ_TREND, 0, iTime(Symbol(), period, start.bar), start_regression_value, Time[end.bar], end_regression_value);
   ObjectCreate("Regression Line", OBJ_TREND, 0, Time[start.bar], start_regression_value, Time[end.bar], end_regression_value);   
   
   ObjectSet("Regression Line", OBJPROP_COLOR, Blue);
   ObjectSet("Regression Line", OBJPROP_WIDTH, 2);
   
   
  
     
 
  return(0);
  }
//+------------------------------------------------------------------+