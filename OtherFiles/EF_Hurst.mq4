#property copyright "Traders Now"
#property link      "http://www.tradersnow.com"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Green

#define NEGATIVE_VALUE -1
#define THRESHOLD 0

#include <Q_Methods.mqh>

extern   int      Lookback       =  50;
extern   int      SdevSample     =  50;
extern   double   Deviations     =  1;

double Hurst[];
   double T[];
   double R[]; 
double zeroLine[];
double upper[];
double lower[];

int init()
  {
   
   IndicatorDigits(6);   
   IndicatorShortName("Levy");
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Hurst);
   SetIndexLabel(0,"Hurst");
   SetIndexDrawBegin(0,Lookback*2);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,zeroLine);   
   SetIndexLabel(1,"Zero Line");
   SetIndexDrawBegin(1,Lookback*2);

   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,upper);   
   SetIndexLabel(2,"Upper Sdev");
   SetIndexDrawBegin(2,Lookback*2+SdevSample);
   
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,lower);   
   SetIndexLabel(3,"Lower Sdev");
   SetIndexDrawBegin(3,Lookback*2+SdevSample);         
      
   return(0);
  }

int deinit() {
   return(0);
  }

int start()   {

   int    counted_bars=IndicatorCounted()-1;
   
   // initialize R & T   
   ArrayResize(T,Lookback);
   ArrayResize(R,Lookback);
   
   // set up the T array
   for(int t = 1; t <= Lookback; t++)
      T[t-1] = MathLog(t);       
   
   show = "";
   
   double sDev;
   
   for(int i = 1000/*counted_bars*/; i >= 0; i--) {        

      // Set up the autocorrelation array for R    
      BuildRArray(Lookback, i);
      
      Hurst[i] = -GetHurstExponent(Lookback, T, R);     
      zeroLine[i] = THRESHOLD;
      
      sDev  =  GetSDev(i);
      
      upper[i] = zeroLine[i] + (sDev * Deviations);
      lower[i] = zeroLine[i] - (sDev * Deviations);
   }
      
   return(0);
}

double GetSDev(int index) {
   
   //string show;
   double sum = 0;
   
   for(int i = index; i < index + SdevSample; i++ ) {   
      sum += Hurst[i];
   }
   
   double xBar = sum / SdevSample;
   
   //show = StringConcatenate("Xbar for the series: ", DoubleToStr(xBar,11), "\n");
   
   sum = 0;
   double thisVariance;
   
   for(i = index; i < index + SdevSample; i++ ) {   
      thisVariance = MathPow( ( Hurst[i] - xBar ), 2);
      sum += thisVariance;
      //show = StringConcatenate(show,i," variance is ", DoubleToStr(thisVariance, 11),"\n" );
   }   
   
   double variance = sum * 1 / (SdevSample-1);
   //show = StringConcatenate(show,"Total variance is ", DoubleToStr(variance, 11),"\n" );
   
   //Comment(show);
   
   return( MathSqrt(variance) );
}

void BuildRArray(int Lookback, int startIndex) {
   
   for(int t = startIndex; t <= Lookback + startIndex; t++)
      R[t-startIndex] = (MathLog(Close[t]));
}