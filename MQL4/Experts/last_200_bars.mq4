/*
   This script keeps updating the file EURJPY_1_last_200_bars.csv with the latest 200 bars of 1 minute quotes
   actually EURJPY_1 is, and can be applied to charts of different instruments (EURJPY) and different timeframe (1)
   eg: the file can look like GBPUSD_5_last_200_bars.csv for 5min bars of GBPUSD
   
*/

enum II {};
enum II2 {
    D12 = 0 //-----------------------------------------------------------------------------------------------------
};
enum TF {
    Current = 0, //Текущий
    M1 = 1, //Минута
    M5 = 5, //5 минут
    M15 = 15, //15 минут
    M30 = 30, //30 минут
    H1 = 60, //Час
    H4 = 240, //4 часа
    D1 = 1440, //День
    W1 = 10080, //Неделя
    MN = 43200 //Месяц
};
//---
sinput II2 LINE0; //-----------------------------------------------------------------------------------------------------
sinput II info0; // • Главные опции
sinput TF WTF = M1; //Таймфрейм
sinput int HowManyBars = 200; // How manu last bars to save
sinput string filename = "last_200_bars"; //Имя файла
sinput II2 LINE1; //-----------------------------------------------------------------------------------------------------
//---
int h = 0;

datetime last_time;
//---
int Last200Bars()
{
    int BarsBack;
    if (iBars(Symbol(), WTF)<HowManyBars)
      BarsBack=iBars(Symbol(), WTF);
    else
      BarsBack=HowManyBars;
    
    string f = Symbol()+"_"+ WTF+"_"+filename+".csv";
    // remove the previous one
    FileDelete(f);
    h = FileOpen(f, FILE_WRITE | FILE_CSV | FILE_SHARE_READ | FILE_SHARE_WRITE , ",");
    if (h == INVALID_HANDLE)
        return (INIT_FAILED);
    
    string time = "";
    datetime dt=0;
    for (int i = HowManyBars; i > 0; i--) {
        dt = iTime(Symbol(), WTF, i); 
        //dt += StrToTime("01:00");
        time = TimeToStr(dt, TIME_MINUTES);
        FileWrite(h, dateUS(dt), time, DoubleToStr(iClose(Symbol(), WTF, i+1), Digits));
    }
   
    FileClose(h);
    last_time = dt;
    return (INIT_SUCCEEDED);
}

string dateUS(datetime t)
{
     
    return (TimeMonth(t) + "/" + TimeDay(t) + "/" + TimeYear(t));
}


void OnTick()
{
    //static datetime timess = 0; // should be initialized to the last bar logged in Init
    if (last_time != iTime(Symbol(), WTF, 0)) 
    {
         last_time = iTime(Symbol(), WTF, 0); // WE TAKE THE TIME OF CURRENT BAR AND THAT'S IT
         Last200Bars();        
        
    }
    
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
