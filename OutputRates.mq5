//+------------------------------------------------------------------+
//|                                                  OutputRates.mq5 |
//+------------------------------------------------------------------+
#property script_show_inputs

input datetime start_time = D'01.01.2015';
input datetime stop_time = D'01.01.2016';

void OnStart()
{
   //int hInd = iMA(_Symbol, 0, 5, 0, MODE_SMA, PRICE_CLOSE);
   //int hInd = iMA(_Symbol, 0, 14, 0, MODE_EMA, PRICE_CLOSE);
   //int hInd = iMA(_Symbol, 0, 14, 0, MODE_SMMA, PRICE_MEDIAN);
   //int hInd = iMA(_Symbol, 0, 4, 0, MODE_LWMA, PRICE_CLOSE);
   //int hInd = iATR(_Symbol, 0, 14);
   //int hInd = iDEMA(_Symbol, 0, 14, 0, PRICE_CLOSE);
   //int hInd = iTEMA(_Symbol, 0, 14, 0, PRICE_CLOSE);
   //int hInd = iMomentum(_Symbol, 0, 5, PRICE_CLOSE);
   //int hInd = iRSI(_Symbol, 0, 10, PRICE_CLOSE);
   //int hInd = iStdDev(_Symbol, 0, 14, 3, MODE_SMA, PRICE_WEIGHTED);
   //int hInd = iAO(_Symbol, 0);
   //int hInd = iAC(_Symbol, 0);
   //int hInd = iBearsPower(_Symbol, 0, 13);
   //int hInd = iBullsPower(_Symbol, 0, 13);
   //int hInd = iCCI(_Symbol, 0, 14, PRICE_TYPICAL);
   //int hInd = iDeMarker(_Symbol, 0, 14);
   //int hInd = iEnvelopes(_Symbol, 0, 10, 0, MODE_SMA, PRICE_CLOSE, 1.0);
   //int hInd = iMACD(_Symbol, 0, 12, 26, 9, PRICE_CLOSE);
   //int hInd = iOsMA(_Symbol, 0, 12, 26, 9, PRICE_CLOSE);
   //int hInd = iTriX(_Symbol, 0, 14, PRICE_CLOSE);
   //int hInd = iAMA(_Symbol, 0, 15, 2, 30, 0, PRICE_CLOSE);
   //int hInd = iFrAMA(_Symbol, 0, 14, 0, PRICE_CLOSE);
   //int hInd = iRVI(_Symbol, 0, 10);
   //int hInd = iWPR(_Symbol, 0, 14);
   //int hInd = iVIDyA(_Symbol, 0, 15, 12, 0, PRICE_CLOSE);
   //int hInd = iBands(_Symbol, 0, 20, 5, 2.0, PRICE_CLOSE);
   //int hInd = iStochastic(_Symbol, 0, 10, 3, 5, MODE_SMA, STO_LOWHIGH);
   //int hInd = iCustom(_Symbol, 0, "HLBand", 20);
   //int hInd = iAlligator(_Symbol, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
   //int hInd = iGator(_Symbol, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
   //int hInd = iADX(_Symbol, 0, 14);
   //int hInd = iADXWilder(_Symbol, 0, 14);
   //int hInd = iSAR(_Symbol, 0, 0.02, 0.2);
   int hInd = iIchimoku(_Symbol, 0, 9, 26, 52);
   int buffers = 5;  //バッファ数

   MqlRates rates[];
   int copied = CopyRates(Symbol(), 0, start_time, stop_time, rates);

   double buf0[], buf1[], buf2[], buf3[], buf4[];
   string slabel = "Time,Open,High,Low,Close";
   if(buffers > 0){
      CopyBuffer(hInd, 0, start_time, stop_time, buf0);
      slabel = slabel+",Ind0";
   }
   if(buffers > 1){
      CopyBuffer(hInd, 1, start_time, stop_time, buf1);
      slabel = slabel+",Ind1";
   }
   if(buffers > 2){
      CopyBuffer(hInd, 2, start_time, stop_time, buf2);
      slabel = slabel+",Ind2";
   }
   if(buffers > 3){
      CopyBuffer(hInd, 3, start_time, stop_time, buf3);
      slabel = slabel+",Ind3";
   }
   if(buffers > 4){
      CopyBuffer(hInd, 4, start_time, stop_time, buf4);
      slabel = slabel+",Ind4";
   }

   //ファイル出力
   int hFile = FileOpen(_Symbol+IntegerToString(_Period)+".txt", FILE_WRITE|FILE_CSV|FILE_ANSI);
   if(hFile == INVALID_HANDLE) return;
   FileWrite(hFile, slabel); 
   for(int i=0; i<copied; i++)
   {
      string out = StringFormat("%s,%g,%g,%g,%g",
                                 TimeToString(rates[i].time),
                                 rates[i].open,
                                 rates[i].high,
                                 rates[i].low,
                                 rates[i].close);
      if(buffers > 0) out = out + StringFormat(",%.15g", buf0[i]);
      if(buffers > 1) out = out + StringFormat(",%.15g", buf1[i]);
      if(buffers > 2) out = out + StringFormat(",%.15g", buf2[i]);
      if(buffers > 3) out = out + StringFormat(",%.15g", buf3[i]);
      if(buffers > 4) out = out + StringFormat(",%.15g", buf4[i]);
      FileWrite(hFile, out); 
   }
   FileClose(hFile);
   MessageBox(IntegerToString(copied)+" data written");
}
