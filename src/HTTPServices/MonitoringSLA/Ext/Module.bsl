﻿
Функция ПолучитьОтчетПолучить(Запрос) Экспорт
	
	Ответ = Новый HTTPСервисОтвет(200);	
	Ответ.Заголовки.Вставить("Content-Type", "application/json");	
	Ответ.УстановитьТелоИзСтроки(ЗаписатьВJSON(), "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
	Возврат Ответ;
	
КонецФункции

Функция ЗаписатьВJSON()
	
	тЗапись = Новый ЗаписьJSON;
	тЗапись.УстановитьСтроку();
	
	тДанные = Новый Структура("IsWorking, OrdersQuery, RetailOrdersQuery, WMSRTUQuery, WMSPTUQuery, SWQueryIn, WMSExchangeQuery",
							IsWorking(),OrdersQuery(),RetailOrdersQuery(),WMSRTUQuery(),WMSPTUQuery(),SWQueryIn(),WMSExchangeQuery());
							
	ЗаписатьJSON(тЗапись, тДанные);
	
	Возврат тЗапись.Закрыть();
	
КонецФункции

Функция IsWorking()
	//Что делает метод: ничего, просто возвращает 1
	//Ответ метода (int): 1
	
	Возврат 1;
	
КонецФункции

Функция OrdersQuery()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_OrdersQuery";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: считает количество заявок в очереди на загрузку с оптового сайта (все незагруженные заявки которые есть в 1С 8.3)
	//Ответ метода (int): количество заявок в очереди на загрузку с оптового сайта
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК OrdersQuery
	|ИЗ
	|	РегистрСведений.ОбъектыОбмена КАК ОбъектыОбмена
	|ГДЕ
	|	НЕ ОбъектыОбмена.Обработано
	|	И ОбъектыОбмена.ВидОбмена = &ВидОбмена";
	
	Запрос.УстановитьПараметр("ВидОбмена", Перечисления.ВидыОбменов.Обмен1С_Сайт_Заявки);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.OrdersQuery;
	
КонецФункции

Функция RetailOrdersQuery()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_RetailOrdersQuery";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: считает количество заявок в очереди на загрузку с розничного сайта (все незагруженные заявки которые есть в 1С 8.3)
	//Ответ метода (int): количество заявок в очереди на загрузку с розничного сайта 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК RetailOrdersQuery
	|ИЗ
	|	РегистрСведений.ОбъектыОбмена КАК ОбъектыОбмена
	|ГДЕ
	|	НЕ ОбъектыОбмена.Обработано
	|	И ОбъектыОбмена.ВидОбмена = &ВидОбмена";
	
	Запрос.УстановитьПараметр("ВидОбмена", Перечисления.ВидыОбменов.Обмен1С_Сайт_Розница);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.RetailOrdersQuery;
	
КонецФункции

Функция WMSRTUQuery()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_WMSRTUQuery";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: считает количество РТУ в очереди в плане обмена в WMS
	//Ответ метода (int): количество РТУ в очереди в плане обмена в WMS 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК WMSRTUQuery
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Изменения КАК РеализацияТоваровУслугИзменения
	|ГДЕ
	|	РеализацияТоваровУслугИзменения.Узел = &Узел";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена("ОбменПартКом83_TopLog_РТУ", 3));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.WMSRTUQuery;
	
КонецФункции

Функция WMSPTUQuery()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_WMSPTUQuery";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: считает количество ПТУ + перемещения в очереди в плане обмена в WMS
	//Ответ метода (int): количество ПТУ + перемещения в очереди в плане обмена в WMS 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ВЗ.WMSPTUQuery) КАК WMSPTUQuery
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(*) КАК WMSPTUQuery
	|	ИЗ
	|		Документ.ПоступлениеТоваровУслуг.Изменения КАК ПоступлениеТоваровУслугИзменения
	|	ГДЕ
	|		ПоступлениеТоваровУслугИзменения.Узел = &Узел
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КОЛИЧЕСТВО(*)
	|	ИЗ
	|		Документ.ПеремещениеТоваров.Изменения КАК ПеремещениеТоваровИзменения
	|	ГДЕ
	|		ПеремещениеТоваровИзменения.Узел = &Узел) КАК ВЗ";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена("ОбменПартКом83_TopLog", 3));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.WMSPTUQuery;
	
КонецФункции

Функция SWQueryIn()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_SWQueryIn";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: проверяет есть ли ошибки в последней загрузке из ОП.
	//Ответ метода (int): 0 если есть ошибка в обмене или со времени последнего обмена прошло больше 10 минут, если ошибок нет и время меньше 10 минут, то возвращает 1
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияОбменовПоСообщениямСрезПоследних.Период,
	|	ИсторияОбменовПоСообщениямСрезПоследних.Ошибка,
	|	ИсторияОбменовПоСообщениямСрезПоследних.НомерСообщения
	|ИЗ
	|	РегистрСведений.ИсторияОбменовПоСообщениям.СрезПоследних(
	|			,
	|			НомерСообщения В
	|					(ВЫБРАТЬ
	|						ОбменПартКом83_ОкноПоставщика.НомерПринятого КАК НомерПринятого
	|					ИЗ
	|						ПланОбмена.ОбменПартКом83_ОкноПоставщика КАК ОбменПартКом83_ОкноПоставщика
	|					ГДЕ
	|						ОбменПартКом83_ОкноПоставщика.Ссылка = &Узел)
	|				И Узел = &Узел) КАК ИсторияОбменовПоСообщениямСрезПоследних";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена("ОбменПартКом83_ОкноПоставщика", 3));
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();	
	
	Если ТекущаяДатаСеанса() - Выборка.Период > 600 Тогда
		Возврат 0;
	ИначеЕсли Выборка.Ошибка Тогда
		Возврат 0;
	Иначе
		Возврат 1;
	КонецЕсли;
	
КонецФункции

Функция WMSExchangeQuery()
	
	лКлючАлгоритма = "HTTPсервис_MonitoringSLA_WMSExchangeQuery";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	//Что делает метод: анализирует, есть ли ошибки в последнем обмене с WMS
	//Ответ метода (int): 1 - если ошибок нет, 0 - если ошибки есть
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияОбменовПоСообщениямСрезПоследних.Период,
	|	ИсторияОбменовПоСообщениямСрезПоследних.НомерСообщения
	|ИЗ
	|	РегистрСведений.ИсторияОбменовПоСообщениям.СрезПоследних(
	|			,
	|			НомерСообщения В
	|					(ВЫБРАТЬ
	|						ОбменПартКом83_TopLog.НомерПринятого
	|					ИЗ
	|						ПланОбмена.ОбменПартКом83_TopLog КАК ОбменПартКом83_TopLog
	|					ГДЕ
	|						ОбменПартКом83_TopLog.Ссылка = &Узел)
	|				И Узел = &Узел
	|				И НЕ Исходящее) КАК ИсторияОбменовПоСообщениямСрезПоследних
	|ГДЕ
	|	ИсторияОбменовПоСообщениямСрезПоследних.Ошибка";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена("ОбменПартКом83_TopLog", 3));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 1;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

