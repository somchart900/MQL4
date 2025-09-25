//+------------------------------------------------------------------+
//|                                                  SingleTread_v2.mq4 |
//|                            Copyright 2025, somchart ruengsanthia |
//|                                                 https://mql5.com |
//| 25.09.2025 - Initial release                                     |
//+------------------------------------------------------------------+

#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#define MAGIC_NUMBER 2092568
#include "s1/GetSL_S1.mqh"
#include "s1/Signal_S1.mqh"
#include "t/Action.mqh"
#include "t/CheckSpread.mqh"
#include "t/ClearPeakEquity.mqh"
// #include "t/CloseAll.mqh"
#include "t/CloseBuy.mqh"
#include "t/CloseSell.mqh"
#include "t/CountBuy.mqh"
#include "t/CountSell.mqh"
#include "t/NewBar.mqh"
#include "t/ProfitLock.mqh"
#include "t/RiskLots.mqh"
#include "t/RiskMoney.mqh"
#include "t/SetCandle.mqh"
// #include "t/SetTPAverage.mqh"
#include "t/SetTPSL.mqh"
#include "t/TrailingStop.mqh"
input double percent = 2.0;
input double rewards = 1.2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   //---
   SetCandle();
   //---
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //---
   ClearPeakEquity(reason);
   //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int  GetSL = 0;
void OnTick() {
   //-- ถ้ายังไม่มีไม้ buy

   if(CountBuy() == 0) {
      if(Signal_S1(OP_BUY))   // ถ้ามี signal
      {
         if(NewBar())   // ถ้าเป็นบาร์ใหม่
         {
            if(CheckSpread(200))   // ถ้ามี spread
            {
               if(CountSell() > 0) {   // ถ้ามีไม้ sell อยู่ ให้ close
                  CloseSell();
               }
               GetSL            = GetSL_S1(OP_BUY);
               int    SL        = GetSL * 2;
               double RiskMoney = RiskMoney(percent);
               double Lots      = RiskLots(Symbol(), RiskMoney, SL);
               Action(OP_BUY, Lots);
               double TP = NormalizeDouble(SL * rewards, 2);
               ;
               SetTPSL(SL, TP);
            } else {
               Print("Spread not found");
            }
         }
      }
   }
   //---ถ้ายังไม่มีไม้ sell
   if(CountSell() == 0) {
      if(Signal_S1(OP_SELL)) {
         if(NewBar()) {
            if(CheckSpread(200)) {
               if(CountBuy() > 0) {
                  CloseBuy();
               }
               GetSL            = GetSL_S1(OP_SELL);
               int    SL        = GetSL * 2;
               double RiskMoney = RiskMoney(percent);
               double Lots      = RiskLots(Symbol(), RiskMoney, SL);
               Action(OP_SELL, Lots);
               double TP = NormalizeDouble(SL * rewards, 2);
               SetTPSL(SL, TP);
            } else {
               Print("Spread not found");
            }
         }
      }
   }
   //------------------------------------------------------------------
   ProfitLock((GetSL - 200), 100);
   TrailingStop((GetSL + 200), (GetSL - 100));
}
//+------------------------------------------------------------------+
