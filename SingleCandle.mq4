//+------------------------------------------------------------------+
//|                                                  SingleTread.mq4 |
//|                            Copyright 2025, somchart ruengsanthia |
//|                                                 https://mql5.com |
//| 25.09.2025 - Initial release                                     |
//+------------------------------------------------------------------+

#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#define MAGIC_NUMBER 19102568

#include "SingleCandle/GetSL.mqh"
#include "function/GetStat.mqh"
#include "function/Action.mqh"
#include "function/CheckSpread.mqh"
#include "function/ClearPeakEquity.mqh"
// #include "function/CloseAll.mqh"
//#include "function/CloseBuy.mqh"
//#include "function/CloseSell.mqh"
#include "function/CountBuy.mqh"
#include "function/CountSell.mqh"
#include "function/NewBar.mqh"
#include "function/ProfitLock.mqh"
#include "function/RiskLots.mqh"
#include "function/RiskMoney.mqh"
#include "function/SetCandle.mqh"
// #include "function/SetTPAverage.mqh"
#include "function/SetTPSL.mqh"
//#include "function/TrailingStop.mqh"
#include "function/TimeFilterLocal.mqh"
input double percent = 2.0;
input double rewards = 2.0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   SetCandle();
//---
   return (INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ClearPeakEquity(reason);
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int buy_step = 0;
int sell_step = 0;
int monitor_stat = 0;
int SL = 0;
void OnTick()
  {
   double HIGH_1 = iHigh(Symbol(),PERIOD_M5,1);
   double LOW_1 = iLow(Symbol(),PERIOD_M5,1);
   double OPEN_1 = iOpen(Symbol(),PERIOD_M5,1);
   double OPEN_2 = iOpen(Symbol(),PERIOD_M5,2);
   double CLOSE_1 = iClose(Symbol(),PERIOD_M5,1);
   double CLOSE_2 = iClose(Symbol(),PERIOD_M5,2);
   double SAR_0 = iSAR(Symbol(),PERIOD_M5,0.02,0.2,0);
   double SAR_1 = iSAR(Symbol(),PERIOD_M5,0.02,0.2,1);
   double SMA_1 = iMA(Symbol(), PERIOD_M5, 60, 0, MODE_SMA, PRICE_CLOSE, 1);

//--------set step 1--------------------------------
   if(LOW_1 < SMA_1)
     {
      if(CLOSE_1 > SMA_1)
        {
         if(buy_step != 1)
           {
            buy_step = 1;
            sell_step = 0;
           }
        }
     }
//--------------------------------------------------
   if(HIGH_1 > SMA_1)
     {
      if(CLOSE_1 < SMA_1)
        {
         if(sell_step != 1)
           {
            sell_step = 1;
            buy_step = 0;
           }
        }
     }
   if(TimeFilterLocal(6,50,22,30))
     {
      //---------------------------------------------------
      if(CLOSE_1 > SMA_1)
        {
         if(CLOSE_1 > SAR_1)
           {
            if(OPEN_2 > CLOSE_2)
              {
               if(CLOSE_1 > OPEN_1)
                 {
                  if(CLOSE_1 > OPEN_2)
                    {
                     if(buy_step == 1)
                       {
                        if(CountBuy() == 0)
                          {
                           if(CheckSpread(200))
                             {
                              if(NewBar())
                                {
                                 if(SL > 800)
                                   {
                                    SL = GetSL(OP_BUY);
                                    double RiskMoney = RiskMoney(percent);
                                    double Lots      = RiskLots(Symbol(), RiskMoney, SL);
                                    Action(OP_BUY, Lots);
                                    double TP = NormalizeDouble(SL * rewards, 2);
                                    SetTPSL(SL, TP);
                                    monitor_stat = 1;
                                   }
                                 else
                                   {
                                    Print("SL smal");
                                   }
                                }
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
      //--------------------------------------------------------------------------------

      if(CLOSE_1 < SMA_1)
        {
         if(CLOSE_1 < SAR_1)
           {
            if(OPEN_2 < CLOSE_2)
              {
               if(CLOSE_1 < OPEN_1)
                 {
                  if(CLOSE_1 < OPEN_2)
                    {
                     if(sell_step == 1)
                       {
                        if(CountSell() == 0)
                          {
                           if(CheckSpread(200))
                             {
                              if(NewBar())
                                {
                                 SL = GetSL(OP_SELL);
                                 if(SL > 800)
                                   {
                                    double RiskMoney = RiskMoney(percent);
                                    double Lots      = RiskLots(Symbol(), RiskMoney, SL);
                                    Action(OP_SELL, Lots);
                                    double TP = NormalizeDouble(SL * rewards, 2);
                                    SetTPSL(SL, TP);
                                    monitor_stat = 1;
                                   }
                                 else
                                   {
                                    Print("SL smaly");
                                   }
                                }
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
     }//--endtime
//-----------------------------------------------------------------------------------------
   GetStat();
   if(monitor_stat == 1)
     {
      if(BuyOpen == 0 && SellOpen == 0)
        {
         bool res;
         double profit=0;
         for(int i = 0; i < OrdersHistoryTotal(); i++)
           {
            res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
            if(OrderSymbol()==Symbol())
              {
               if(OrderMagicNumber()==MAGIC_NUMBER)
                 {
                  profit=OrderProfit();
                 }
              }
           } //--end for
         if(profit > 0)
           {
            buy_step = 0;
            sell_step = 0;
           }
         NewBar();
         monitor_stat = 0;
        }//end buy sell 0 0
      //-------------------
      NewBar();
     }
 ProfitLock(SL,10);
   Comment("buy_step = " + IntegerToString(buy_step) + "\n"
           + "sell_step   = " + IntegerToString(sell_step) + "\n"
           + "BuyOpen   = " + IntegerToString(BuyOpen) + "\n"
           + "SellOpen   = " + IntegerToString(SellOpen) + "\n"
           + "monitor_stat = " + IntegerToString(monitor_stat) + "\n"
           + "SL= " + IntegerToString(SL) + "\n"
           + "PeakEquity= " + DoubleToString(GlobalVariableGet("PeakEquity"), 2) + "\n"
          );
  }
//+----------------------------------------------------------------------------------------------+
