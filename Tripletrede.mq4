//+------------------------------------------------------------------+
//|                                                   TripleTred.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#define MAGIC_NUMBER 3102568
#include "s2/GetStat.mqh"
#include "s1/Signal_S1.mqh"
#include "t/Action.mqh"
#include "t/CheckSpread.mqh"
#include "t/ClearPeakEquity.mqh"
// #include "t/CloseAll.mqh"
#include "t/CloseBuy.mqh"
#include "t/CloseSell.mqh"
// #include "t/CountBuy.mqh"
// #include "t/CountSell.mqh"
#include "t/NewBar.mqh"
#include "t/ProfitLock.mqh"
#include "t/RiskLots.mqh"
#include "t/RiskMoney.mqh"
#include "t/SetCandle.mqh"
#include "t/ModifyTPAverage.mqh"
//#include "t/SetTPSL.mqh"
//#include "t/TrailingStop.mqh"
input double percent = 1.0;
input double rewards = 1.5;
// 
enum TrailingStopOption
{
   TrailingStop_OFF = 0,   
   TrailingStop_ON  = 1      
};
enum ProfitLockOption
{
   ProfitLock_OFF = 0,   
   ProfitLock_ON  = 1      
};
// สร้าง input 
input ProfitLockOption UseProfitLock = ProfitLock_OFF;
input TrailingStopOption UseTrailingStop = TrailingStop_OFF;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
    Comment("");
    ClearPeakEquity(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Comment("TripleTred distant = " + DoubleToString(distant, 2));
  }
//+------------------------------------------------------------------+
