//+------------------------------------------------------------------+
//|                                                   TripleTred.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
#define MAGIC_NUMBER 3102568
#include "s2/GetSignal.mqh"
#include "s2/GetStat.mqh"
#include "s2/FixTPSL.mqh"
#include "t/Action.mqh"
#include "t/CheckSpread.mqh"
#include "t/ClearPeakEquity.mqh"
// #include "t/CloseAll.mqh"
#include "t/CloseBuy.mqh"
#include "t/CloseSell.mqh"
// #include "t/CountBuy.mqh"
// #include "t/CountSell.mqh"
#include "t/ModifyTPAverage.mqh"
#include "t/NewBar.mqh"
#include "t/ProfitLock.mqh"
#include "t/RiskLots.mqh"
#include "t/RiskMoney.mqh"
#include "t/SetCandle.mqh"
#include "t/SetTPSL.mqh"
// #include "t/TrailingStop.mqh"
input double percent = 1.0;
input double rewards = 1.5;
//
enum TrailingStopOption {
   TrailingStop_OFF = 0,
   TrailingStop_ON  = 1
};
enum ProfitLockOption {
   ProfitLock_OFF = 0,
   ProfitLock_ON  = 1
};
// สร้าง input
input ProfitLockOption   UseProfitLock   = ProfitLock_OFF;
input TrailingStopOption UseTrailingStop = TrailingStop_OFF;

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
   Comment("");
   ClearPeakEquity(reason);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

int  GetSL = 0;
void OnTick() {
   GetStat();
   //---  ถ้ายังไม่มีไม้ buy
   if(BuyOpen == 0) {
      if(GetSignal(OP_BUY)) {
         if(SellOpen > 0) {
            CloseSell();
         }
         if(NewBar()) {
            if(CheckSpread(200)) {
               GetSL            = GetSL(OP_BUY);
               distant          = GetSL;
               int    SL        = GetSL * 3;
               double RiskMoney = RiskMoney(percent);
               Comment(RiskMoney);
               double Lots = RiskLots(Symbol(), RiskMoney, SL);
               Action(OP_BUY, Lots);
               double TP = NormalizeDouble(distant  * rewards, 2);
               SetTPSL(SL, TP);
            } else {
               Print("Spread not allowed");
            }
         }
      }
   }
   //--  ถ้ายังไม่มีไม้ sell
   if(SellOpen == 0) {
      if(GetSignal(OP_SELL)) {
         if(BuyOpen > 0) {
            CloseBuy();
         }
         if(NewBar()) {
            if(CheckSpread(200)) {
               GetSL            = GetSL(OP_SELL);
               distant          = GetSL;
               int    SL        = GetSL * 3;
               double RiskMoney = RiskMoney(percent);
               Comment(RiskMoney);
               double Lots = RiskLots(Symbol(), RiskMoney, SL);
               Action(OP_SELL, Lots);
               double TP = NormalizeDouble(distant  * rewards, 2);
               SetTPSL(SL, TP);
            } else {
            }
         }
      }
   }
   //------------------------------------------------------------------
   if(BuyOpen > 0 && BuyOpen < 3) {
      if(Ask < distant_buy) {
         if(CheckSpread(200)) {
            if(NewBar()) {
               Action(OP_BUY, Buylots);
               FixTPSL();
            }
         } else {
            Print("Spread not allowed");
         }
      }
   }
   //------------------------------------------------------------------
   if(SellOpen > 0 && SellOpen < 3) {
      if(Bid > distant_sell) {
         if(CheckSpread(200)) {
            if(NewBar()) {
               Action(OP_SELL, Selllots);
               FixTPSL();
            }
         } else {
            Print("Spread not allowed");
         }
      }
   }
   //------------------------------------------------------------------
   Comment("TripleTred = " + DoubleToString(BuyOpen, 2) + "\n"
    + "SellOpen   = " + DoubleToString(SellOpen, 2) + "\n" 
    + "DistantBuy = " + DoubleToString(distant_buy, 2) + "\n"
    + "DistantSell= " + DoubleToString(distant_sell, 2) + "\n"
    + "Distant    = " + DoubleToString(distant, 2) + "\n"
    + "BuyTP      = " + DoubleToString(BuyTP, 2) + "\n"
    + "BuySL      = " + DoubleToString(BuySL, 2) + "\n"
    + "SellTP     = " + DoubleToString(SellTP, 2) + "\n"
    + "SellSL     = " + DoubleToString(SellSL, 2) + "\n"
    + "Buylots    = " + DoubleToString(Buylots, 2) + "\n"
    + "Selllots   = " + DoubleToString(Selllots, 2) + "\n"

   );
}
//+------------------------------------------------------------------+
