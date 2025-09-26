//+------------------------------------------------------------------+
//|  Finame: Signal_S1.mqh                                           |
//|  Utility:                      |
//|  Usage:    if(Signal_S1(OP_BUY)) { ... }                                     |
//+------------------------------------------------------------------+
#ifndef SIGNALS1_MQH
#define SIGNALS1_MQH

bool Signal_S1(int OP_VALUE) {
   static int step    = 0;
   static int step2   = 0;
   double     CLOSE_1 = iClose(Symbol(), PERIOD_M5, 1);
   double     OPEN_1  = iOpen(Symbol(), PERIOD_M5, 1);
   double     OPEN_0  = iOpen(Symbol(), PERIOD_M5, 0);
   double     HIGH_1  = iHigh(Symbol(), PERIOD_M5, 1);
   double     LOW_1   = iLow(Symbol(), PERIOD_M5, 1);
   double     MA_1    = iMA(Symbol(), PERIOD_M5, 60, 0, MODE_SMA, PRICE_CLOSE, 1);
   double     SAR_1   = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 1);
   double     SAR_0   = iSAR(Symbol(), PERIOD_M5, 0.02, 0.2, 0);
   // --------------------------------------------------------------
   if(OP_VALUE == OP_SELL) {
      if(HIGH_1 > MA_1) {   // ถ้ามีการปิดแท่งตัดเส้น MA_1และสเต็ปยังเป็น 0 ปรับสเต็ปเป็น 1
         if(CLOSE_1 < MA_1) {
            if(step == 0) {
               step = 1;
            }
         }
      }
      //--------------------------------------------------------------
      if(step == 1) {
         if(CLOSE_1 > MA_1) {
            step = 0;   // reset step หากมีการย้อนกลับก่อนเข้าสเต็ป 2
         }
         if(SAR_1 < MA_1) {
            if(SAR_1 > OPEN_1) {
               if(SAR_0 < OPEN_0) {
                  step = 0;   // reset step เมื่อถึงสเต็ป 2 แล้ว
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
            if(step2 == 0) {
               step2 = 1;
            }
         }
      }
      //---
      if(step2 == 1) {
         if(CLOSE_1 < MA_1) {
            step2 = 0;   // reset step หากมีการย้อนกลับก่อนเข้าสเต็ป 2
         }
         if(SAR_1 > MA_1) {
            if(SAR_1 < OPEN_1) {
               if(SAR_0 > OPEN_0) {
                  step2 = 0;   // reset step เมื่อถึงสเต็ป 2 แล้ว
                  return (true);
               }
            }
         }
      }
   }
   // --------------------------------------------------------------
   return (false);
}

#endif