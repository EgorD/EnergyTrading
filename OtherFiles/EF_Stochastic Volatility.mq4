//+------------------------------------------------------------------+
//|                                         StochasticVolatility.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

double vols[];

extern   int   Lookback       =  50;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   SetIndexBuffer(0,vols);
   SetIndexDrawBegin(0,Lookback);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,Red); 
   
   IndicatorDigits(10);
   
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
   int    counted_bars= Bars-IndicatorCounted()-1;

   for(int i = counted_bars; i >= 0; i--)
   {
      double sumHat1 = 0;
      double sumHat2 = 0;
      
      if( i >= Bars - Lookback )
      {
         vols[i] = 0;
         continue;
      }
      
      for(int j = i + Lookback - 2; j >= i; j--)
      {
         sumHat1 += MathPow( MathAbs( MathLog( Close[j] / Close[j+1] ) ), 2);
         sumHat2 += MathLog(Close[j]/Close[j+1]);
      }
      
      sumHat1 = MathSqrt(sumHat1);
      sumHat2 = sumHat2 / MathSqrt(Lookback-1);
            
      vols[i] = sumHat1- sumHat2;
   }

   return(0);
  }
//+------------------------------------------------------------------+