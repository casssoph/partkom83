
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

Функция GetDocForBitKod(Data,Number,Answer,Kod) 
	
	Возврат DataExchangeModule.GetDocForBitKod(Data,Number,Answer,Kod); 
	
КонецФункции

Функция GetDocumentsForExchangeToplog(DataB, DataC)
	
	Возврат DataExchangeModule.ПолучитьДокументыДляОбменаТоплог(DataB, DataC);
	
КонецФункции

Функция CheckDocumentsForExchangeToplog(Query)
	
	Возврат DataExchangeModule.ПроверитьДокументыДляОбменаТоплог(Query);
	
КонецФункции

Функция IDSiteStatus(IDSite)
	
	Возврат DataExchangeModule.IDSiteStatus(IDSite);
	
КонецФункции

Функция GetRefusalParties()
	
	Возврат DataExchangeModule.ПолучитьОтказыПоПартиям();
	
КонецФункции

Функция RTYControl()
	
	Возврат DataExchangeModule.ПолучитьСписокРТУ();
	
КонецФункции

Функция RegisterToExchange(ObjectType, ObjectKey)
	
	Возврат DataExchangeModule.RegisterToExchange(ObjectType, ObjectKey);
	
КонецФункции

Функция DocumentCompare(StartDate, FinalDate, DocumentTable)
	
	Возврат DataExchangeModule.СравнитьДокументы(StartDate, FinalDate, DocumentTable);
	
КонецФункции

Функция GetDebt(UserLoginArray,DateBegin,DateEnd)
	
	Возврат DataExchangeModule.ВыгрузитьОборотыПоКлиентам(UserLoginArray,DateBegin,DateEnd);
	
КонецФункции

Функция SendShippingDocs(GUID, Date, EMail)
	
	Возврат DataExchangeModule.ЗарегистрироватьОтправкуОтгрузочныхДокументовКлиентуПоЗапросуССайта(GUID, Date, EMail);
	
КонецФункции

//ХудинВВ XX-2951 01082019
Функция GetTableByQuery(QueryText, QueryParams, GetUID)
	Возврат DataExchangeModule.GetTableByQuery(QueryText, QueryParams, GetUID);
КонецФункции
 
//ДАННЫЙ МОДУЛЬ ИЗМЕНЯТЬ С ОСТОРОЖНОСТЬЮ, Т.К. ТУТ ОТКЛЮЧЕНА ПРОВЕРКА СИНТАКСИСА
//ЗДЕСЬ ТОЛЬКО ПЕРЕХОДЫ В ОБЩИЙ МОДУЛЬ DataExchangeModule