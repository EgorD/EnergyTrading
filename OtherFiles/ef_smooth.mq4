//+------------------------------------------------------------------+
//|                                                    ef_smooth.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

//-----------------------------------------------------------------------------------------------
// Adapted from:
// Copyright © 2006, ch33z3
// http://4xjournal.blogspot.com/

double calc_smoothed (int p, int i)
{
   double SumY  = 0;
   double Sum1  = 0;
   double Slope = 0;
   double c;
   
   for (int x=0; x <= (p-1); x++) 
   {
      c = Close[x+i];
      SumY += c;
      Sum1 += x * c; 
   }
      
   double SumBars    = p * (p-1) * 0.5;
   double SumSqrBars = (p-1) * p * (2 * p-1) / 6;
   
	double Sum2 = SumBars * SumY;
	double Num1 = p * Sum1-Sum2;
	double Num2 = SumBars * SumBars - p * SumSqrBars;
	
	if (Num2 != 0) 
	  Slope = Num1 / Num2;
	else 
	  Slope = 0;
	  
	double Intercept        = (SumY - Slope * SumBars) / p;
	double regression_value = Intercept + Slope * (p-1);  
	
	return (regression_value);
}