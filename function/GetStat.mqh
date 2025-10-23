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

// เพิ่มตัวแปร global สำหรับ TP/SL
double BuyTP = 0;
double BuySL = 0;
double SellTP = 0;
double SellSL = 0;
double Selllots = 0;
double Buylots = 0;

//-----------------------------
void GetStat()
  {
   BuyOpen = 0;
   SellOpen = 0;
   distant_buy = 0;
   distant_sell = 0;
   BuyTP = 0;
   BuySL = 0;
   SellTP = 0;
   SellSL = 0;
   Selllots = 0;
   Buylots = 0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC_NUMBER)
           {
            if(OrderType() == OP_BUY)
              {
               BuyOpen++;
               distant_buy = OrderOpenPrice() - distant * Point;
               BuyTP = OrderTakeProfit();
               BuySL = OrderStopLoss();
               Buylots = OrderLots();
              }
            else if(OrderType() == OP_SELL)
              {
               SellOpen++;
               distant_sell = OrderOpenPrice() + distant * Point;
               SellTP = OrderTakeProfit();
               SellSL = OrderStopLoss();
               Selllots = OrderLots();
              }
           }
        }
     }
  }
//-----------------------------

#endif
