//+------------------------------------------------------------------+
//|  Finame: GetSL_S1.mqh                                             |
//|  Utility: calculate stop loss price                               |
//|  Usage:int SL = GetSL_S1(OP_BUY);OR  int SL = GetSL_S1(OP_SELL);  |                                    |
//+------------------------------------------------------------------+
#ifndef GetSL_S1_MQH
#define GetSL_S1_MQH

int GetSL_S1(int OP_VALUE) {
   double SAR_1 = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 1);
   double SAR_0 = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 0);

   double diff;

   if(OP_VALUE == OP_BUY)
      diff = SAR_0 - SAR_1;
   else if(OP_VALUE == OP_SELL)
      diff = SAR_1 - SAR_0;
   else {
      Print("GetSL_S1: Invalid OP_VALUE = ", OP_VALUE);
      return 0;
   }

   double pointDiff = diff / Point;
   return (int)MathRound(pointDiff);   // round to nearest integer
}

#endif