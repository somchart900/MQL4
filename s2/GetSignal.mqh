//+------------------------------------------------------------------+
//|                                                    GetSignal.mqh |
//|                                         Copyright 2025, somchart |
//|                                                 https://mql5.com |
//| 04.10.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#include "GetStat.mqh"
#ifndef GETSIGNAL_MQH
#define GETSIGNAL_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool GetSignal(int OP_VALUE) {
   static int step_sell = 0;
   static int step_buy  = 0;
   double     CLOSE_1   = iClose(Symbol(), PERIOD_M5, 1);
   double     OPEN_1    = iOpen(Symbol(), PERIOD_M5, 1);
   double     OPEN_0    = iOpen(Symbol(), PERIOD_M5, 0);
   double     HIGH_1    = iHigh(Symbol(), PERIOD_M5, 1);
   double     LOW_1     = iLow(Symbol(), PERIOD_M5, 1);
   double     MA_1      = iMA(Symbol(), PERIOD_M5, 60, 0, MODE_SMA, PRICE_CLOSE, 1);
   double     SAR_1     = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 1);
   double     SAR_0     = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 0);
   // --------------------------------------------------------------
   if(OP_VALUE == OP_SELL) {
      if(HIGH_1 > MA_1) {   // ถ้ามีการปิดแท่งตัดเส้น MA_1และสเต็ปยังเป็น 0 ปรับสเต็ปเป็น 1
         if(CLOSE_1 < MA_1) {
            if(step_sell == 0) {
               step_sell = 1;
            }
         }
      }
      //--------------------------------------------------------------
      if(step_sell == 1) {
         if(CLOSE_1 > MA_1) {
            step_sell = 0;   // reset step หากมีการย้อนกลับก่อนเข้าสเต็ป 2
         }
         if(SAR_1 < MA_1) {
            if(SAR_1 > OPEN_1) {
               if(SAR_0 < OPEN_0) {
                  step_sell = 0;   // reset step เมื่อถึงสเต็ป 2 แล้ว
                  return (true);
               }
            }
         }
      }
   }

   // --------------------------------------------------------------
   if(OP_VALUE == OP_BUY) {
      if(LOW_1 < MA_1) {   // ถ้ามีการปิดแท่งตัดเส้น MA_1และสเต็ปยังเป็น 0 ปรับสเต็ปเป็น 1
         if(CLOSE_1 > MA_1) {
            if(step_buy == 0) {
               step_buy = 1;
            }
         }
      }
      //---
      if(step_buy == 1) {
         if(CLOSE_1 < MA_1) {
            step_buy = 0;   // reset step หากมีการย้อนกลับก่อนเข้าสเต็ป 2
         }
         if(SAR_1 > MA_1) {
            if(SAR_1 < OPEN_1) {
               if(SAR_0 > OPEN_0) {
                  step_buy = 0;   // reset step เมื่อถึงสเต็ป 2 แล้ว
                  return (true);
               }
            }
         }
      }
   }
   // Comment("step_sell = " + IntegerToString(step_sell) + ", step_buy = " + IntegerToString(step_buy));
   // --------------------------------------------------------------
   return (false);
}
int GetSL(int OP_VALUE) {
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
