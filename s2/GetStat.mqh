//+------------------------------------------------------------------+
//|                                                      GetStat.mqh |
//|                                       Copyright 2025, MetaQuotes |
//|                                                 https://mql5.com |
//| 03.10.2025 - Initial release                                     |
//+------------------------------------------------------------------+
#ifndef GETSTAT_MQH
#define GETSTAT_MQH
#ifndef MAGIC_NUMBER
#define MAGIC_NUMBER 0   // default ถ้าไม่ได้กำหนดจาก EA หลัก
#endif

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int BuyOpen;
int SellOpen;
double distant_buy;
double distant_sell;
double distant = 8000;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   distant_buy=0;
   distant_sell=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MAGIC_NUMBER)
           {
            if(OrderType()==OP_BUY)
              {
               BuyOpen++;
               distant_buy=OrderOpenPrice()-distant*Point;
              }
            if(OrderType()==OP_SELL)
              {
               SellOpen++;
               distant_sell=OrderOpenPrice()+distant*Point;
              }
           }//-------

        }//--symbol

     }//+end for
  }
//-----------------------------

#endif