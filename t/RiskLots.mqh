//+------------------------------------------------------------------+
//|    Filename: RiskLots.mqh                                        |
//|    Utility:   RiskLots Calculator                                |                               
//|    Usage:   RiskLots(Symbol(), 10, 2000)                         |                                  
//+------------------------------------------------------------------+
#ifndef RISKLOTS_MQH
#define RISKLOTS_MQH

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskLots(string symbol, double risk_money, int sl_points)
{
   double tick_value = MarketInfo(symbol, MODE_TICKVALUE);
   double tick_size = MarketInfo(symbol, MODE_TICKSIZE);
   double point = MarketInfo(symbol, MODE_POINT);

   if (tick_value <= 0 || tick_size <= 0)
      return (0);

   double value_per_point_per_lot = tick_value / tick_size * point;
   double sl_value_per_lot = value_per_point_per_lot * sl_points;

   if (sl_value_per_lot <= 0)
      return (0);

   double lots = risk_money / sl_value_per_lot;

   // --- normalize broker rules ---
   double minLot = MarketInfo(symbol, MODE_MINLOT);
   double maxLot = MarketInfo(symbol, MODE_MAXLOT);
   double step = MarketInfo(symbol, MODE_LOTSTEP);

   if (lots < minLot)
      lots = minLot;
   if (lots > maxLot)
      lots = maxLot;

   lots = MathFloor(lots / step) * step;

   return (NormalizeDouble(lots, 2));
}
#endif
//+------------------------------------------------------------------+
