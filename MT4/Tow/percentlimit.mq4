//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  { 
 ObjectsDeleteAll();
 ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
 ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
 ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
 ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
 ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
 ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
 ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
//---                                 
//if(Period() != 43200){ChartSetSymbolPeriod(ChartID(),_Symbol,PERIOD_MN1);}

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll();
 }
 
 
extern int percent=30; //ระบุจำนวนเปอร์เซ็นต์ที่ต้องการ

void OnTick(){
      percent=10; 
     double limit=AccountBalance()*percent/100;     //คำนวณเปอร์เซ็นต์เป็นสกุลเงินของบัญชี
     if(AccountBalance()>AccountEquity()){       //ตรวจสอบบัญชีว่าขณะนี้ติดลบอยู่หรือไม่ ถ้าหากติดลบอยู่ก็คำนวณว่าติดลบอยู่เท่าไหร่
             double realingloss=AccountBalance()-AccountEquity(); //จำนวนเงินที่ติดลบ
             if(realingloss > limit){ //ถ้ามากว่าเปอร์เซ็นต์ทีกำหนดปิดทั้งหมด
             //เรียกฟังปิดทั้งหมด
             }
             Comment(realingloss+" "+limit);
     }
}
//----------------------------------------------------------------------------------------------------------

