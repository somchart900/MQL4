//+------------------------------------------------------------------+
//|  Finame: GetSL.mqh                                             |
//|  Utility: calculate stop loss price                               |
//|  Usage:int SL = GetSL(OP_BUY);OR  int SL = GetSL(OP_SELL);  |                                    |
//+------------------------------------------------------------------+
#ifndef GetSL_MQH
#define GetSL_MQH

int GetSL(int OP_VALUE) {
   double     G_CLOSE_1   = iClose(Symbol(), PERIOD_M5, 1);
   double     G_HIGH_1    = iHigh(Symbol(), PERIOD_M5, 1);
   double     G_LOW_1     = iLow(Symbol(), PERIOD_M5, 1);

   double diff;

   if(OP_VALUE == OP_BUY)
      diff = G_CLOSE_1 - G_LOW_1;
   else if(OP_VALUE == OP_SELL)
      diff = G_HIGH_1 - G_CLOSE_1;
   else {
      Print("GetSL_S1: Invalid OP_VALUE = ", OP_VALUE);
      return 0;
   }

   double pointDiff = diff / Point;
   return (int)MathRound(pointDiff);   // round to nearest integer
}

#endif