//+------------------------------------------------------------------+
//|  Filename:  RiskMoney.mqh                                        |
//|  Utility: RiskMoney Calculator                                   |                                 
//|  Usage:   RiskMoney(1.0);                                        |                     
//+------------------------------------------------------------------+
#ifndef RISMONEY_MQH
#define RISKMONEY_MQH
double RiskMoney(double risk_percent)
{
   // global variable
   string gv_name = "PeakEquity";

   double balance = AccountBalance();

   // check global variable and set
   if (!GlobalVariableCheck(gv_name))
      GlobalVariableSet(gv_name, balance);

   // peak equity
   double peak = GlobalVariableGet(gv_name);

   // compare use high Ternary operator
   double base = (balance > peak) ? balance : peak;

   // update peak
   if (base > peak)
      GlobalVariableSet(gv_name, base);

   // risk money
   return base * (risk_percent / 100.0);
}
#endif
//+------------------------------------------------------------------+
