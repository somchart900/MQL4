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
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern double LotsXponent =1;
double LotsD =Lots;
extern int SL =3000;
extern int TP =1500;
extern int MagicNumber =10002;
extern int Slippage =100;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =1300;
extern int TralingStep =200;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
int ticket,BuyOpen,SellOpen; 
double last,bath,SellOpenProfit,BuyOpenProfit,lastbar,bb,mark;
double B=AccountBalance();
input ENUM_TIMEFRAMES P_Period =PERIOD_H1;
extern string extoken = "6Cpi4vZIHB6xYh9RnCHpgmIzmSe4J5G8hps49dBs1kB" ;
extern bool Notify =false;
//----------------------------------------------------------------------------------------------------------
void Openbuy(){

     for(int i = 0;i < OrdersHistoryTotal();i++){  
     bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
                if(OrderProfit()<0){ Lots = OrderLots()*LotsXponent;}else{Lots=LotsD;}
           } 
      }  

  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"Buy",MagicNumber,0,clrNONE);
  lastbar=Bars;
}
//---------------------------
void OpenSell(){
     for(int i = 0;i < OrdersHistoryTotal();i++){  
     bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
                if(OrderProfit()<0){ Lots = OrderLots()*LotsXponent;}else{Lots=LotsD;}
           } 
      } 
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"Sell",MagicNumber,0,clrNONE);
  lastbar=Bars;
}
//-----------------------------

//-------------------------------------------------------------------------------------------------- 
void  CloseSell(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
                if(OrderProfit()>0){ res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);}
           }
          
      }
}  
void  CloseBuy(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){    
            if(OrderProfit()>0){  res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);}
           } 
      }
}  

 void CloseAll(){
   bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){    
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){    
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
 
 }
//-----------------------------------------------------------------------------------------------------  

 void GetStatBuy(){ BuyOpen=0; BuyOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;BuyOpenProfit+=OrderProfit()+OrderSwap();
           //Lots = OrderLots(); 
           } 
      }   
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetStatSell(){SellOpen=0; SellOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++; SellOpenProfit+=OrderProfit()+OrderSwap();
           //Lots = OrderLots();
           }
      }   
}   
 //-----------------------------
double SAR,SAR1;
void GetIndy(){
  SAR1=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,1);
  SAR=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,0); 

}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy(); GetStatBuy();GetStatSell();
   if(OrdersTotal()==0){mark=AccountBalance();}
   if(SAR > Open[0] && SAR1 < Open[1] ){if(lastbar!=Bars){CloseBuy();OpenSell();}}
   if(SAR < Open[0] && SAR1 > Open[1] ){if(lastbar!=Bars){CloseSell();Openbuy();}}
   if(OrdersTotal()>=2){if(AccountEquity()>mark+1.0){CloseAll();}}        
} 
//----------------------------------------------------------------------------------------------------------  
void TrailingStop(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber){
                 if(OrderType() == OP_BUY){
                     if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point){                 
                         if(OrderStopLoss() < Bid-TralingStep*Point){ 
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                         }
                     }
                     
                 }
                 if(OrderType() == OP_SELL){
                    if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point){
                        if(OrderStopLoss() > Ask+TralingStep*Point){
                           res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);                        
                        }
                    }   
                 }
                          
              }       
      }
   } 
}

//-----------------------------------------------------------------------------------------------------------------------------         
void eng(){


ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSet("1", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("1","Profit System", 20, NULL, clrGray);
ObjectSet("1", OBJPROP_XDISTANCE, 20);
ObjectSet("1", OBJPROP_YDISTANCE, 20);

ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
ObjectSet("2", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("2",StringFormat("BuyOpen = %G",BuyOpen), 15, NULL, clrGray);
ObjectSet("2", OBJPROP_XDISTANCE, 20);
ObjectSet("2", OBJPROP_YDISTANCE, 70);

ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
ObjectSet("3", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("3",StringFormat("BuyProfit = %G",BuyOpenProfit), 15,NULL, clrGray);
ObjectSet("3", OBJPROP_XDISTANCE, 20);
ObjectSet("3", OBJPROP_YDISTANCE, 100);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSet("4", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("4",StringFormat("SellOpen = %G",SellOpen), 15,NULL, clrGray);
ObjectSet("4", OBJPROP_XDISTANCE, 20);
ObjectSet("4", OBJPROP_YDISTANCE, 130);


ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSet("5", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("5",StringFormat("SellProfit=%G",SellOpenProfit), 15,NULL, clrGray);
ObjectSet("5", OBJPROP_XDISTANCE, 20);
ObjectSet("5", OBJPROP_YDISTANCE, 160);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSet("6", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("6",StringFormat("Equity = %G",AccountEquity()), 15,NULL, clrGray);
ObjectSet("6", OBJPROP_XDISTANCE, 20);
ObjectSet("6", OBJPROP_YDISTANCE, 190);

ObjectCreate("7", OBJ_LABEL, 0, 0, 0);
ObjectSet("7", OBJPROP_CORNER,CORNER_RIGHT_UPPER);
ObjectSetText("7",StringFormat("Balance = %G",AccountBalance()), 15,NULL, clrGray);
ObjectSet("7", OBJPROP_XDISTANCE, 20);
ObjectSet("7", OBJPROP_YDISTANCE, 220);
}
//----------------------------------------------------------------------
void LineNotify(string token,string Massage){
 string headers;
 char post[], result[];

headers="Authorization: Bearer "+token+"\r\n";
 headers+="Content-Type: application/x-www-form-urlencoded\r\n";

ArrayResize(post,StringToCharArray("message="+Massage,post,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 10000, post, result, headers);

Print("Status code: " , res, ", error: ", GetLastError());
 Print("Server response: ", CharArrayToString(result));
}
 
void sendline(){if(AccountBalance() > B){bb=AccountBalance()-B;B=AccountBalance(); LineNotify(extoken," โบรคเกอร์ "+AccountCompany()+" พอร์ท  "+IntegerToString(AccountNumber())+" บวก "+DoubleToString(bb,2)+" USC");}}  

void OnTick(){if(Period() != P_Period){ChartSetSymbolPeriod(ChartID(),_Symbol,P_Period);}
eng();
if(Enable_TrailingStop)TrailingStop(); 
if(Notify)sendline();
Treding();

}
//----------------------------------------------------------------------------------------------------------

