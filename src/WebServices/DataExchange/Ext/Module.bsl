
//ЛОГИКА МЕТОДОВ ВЫНЕСЕНА В ОБЩИЙ МОДУЛЬ

Функция DoDataExchange(InData, OutData) 
	
	Возврат DataExchangeModule.DoDataExchange(InData, OutData);
	
КонецФункции

Функция GetExchangeMessage(ExchangePlan, Sender, ReceivedNo) 
	
	Возврат DataExchangeModule.GetExchangeMessage(ExchangePlan, Sender, ReceivedNo);
	
КонецФункции

Функция SetExchangeMessage(InData) 
	
	Возврат DataExchangeModule.SetExchangeMessage(InData);
	
КонецФункции

Функция CleanRegistry(ExchangeID, MessageNo, Data) 
	
	Возврат DataExchangeModule.CleanRegistry(ExchangeID, MessageNo, Data);
	
КонецФункции

Функция GetData(Data) 
	
	Возврат DataExchangeModule.GetData(Data);
	
КонецФункции

Функция AddRegistry(ExchangePlan, ExchangeID, Data)   	
	
	Возврат DataExchangeModule.AddRegistry(ExchangePlan, ExchangeID, Data);
	
КонецФункции

Функция GetGUID(Data)  
	
	Возврат DataExchangeModule.GetGUID(Data);
	
КонецФункции

Функция GetDocForBit(Data,Number,Answer) 
	
	Возврат DataExchangeModule.GetDocForBit(Data,Number,Answer); 
	
КонецФункции
 
//ДАННЫЙ МОДУЛЬ ИЗМЕНЯТЬ С ОСТОРОЖНОСТЬЮ, Т.К. ТУТ ОТКЛЮЧЕНА ПРОВЕРКА СИНТАКСИСА
//ЗДЕСЬ ТОЛЬКО ПЕРЕХОДЫ В ОБЩИЙ МОДУЛЬ DataExchangeModule