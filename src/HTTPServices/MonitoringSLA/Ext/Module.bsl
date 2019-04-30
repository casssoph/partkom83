﻿
Функция ПолучитьОтчетПолучить(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);	
	Ответ.Заголовки.Вставить("Content-Type", "application/xml");	
	Ответ.УстановитьТелоИзСтроки(ЗаписатьВJSON(), "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
	Возврат Ответ;
	
КонецФункции

Процедура ЗаписатьВJSON()
	
	тЗапись = Новый ЗаписьJSON;
	тЗапись.УстановитьСтроку();
	
	тДанные = Новый Структура("IsWorking, OrdersQuery, RetailOrdersQuery, WMSRTUQuery, WMSPTUQuery, SWQueryIn, WMSExchangeQuery",
							IsWorking(),OrdersQuery(),RetailOrdersQuery(),WMSRTUQuery(),WMSPTUQuery(),SWQueryIn(),WMSExchangeQuery());
							
	ЗаписатьJSON(тЗапись, тДанные);
	
	Возврат тЗапись.Закрыть();
	
КонецПроцедуры

Функция IsWorking()
	//Что делает метод: ничего, просто возвращает 1
	//Ответ метода (int): 1
	
	Возврат 1;
	
КонецФункции

Функция OrdersQuery()
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
	
	Запрос.УстановитьПараметр("ВидОбмена", Перечисления.ВидыОбменов.Обмен1С_Сайт_Заявки;
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.OrdersQuery;
	
КонецФункции

Функция RetailOrdersQuery()
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
	
	Запрос.УстановитьПараметр("ВидОбмена", Перечисления.ВидыОбменов.Обмен1С_Сайт_Розница;
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.RetailOrdersQuery;
	
КонецФункции

Функция WMSRTUQuery()
	
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
	
	//Что делает метод: считает количество ПТУ + перемещения в очереди в плане обмена в WMS
	//Ответ метода (int): количество ПТУ + перемещения в очереди в плане обмена в WMS 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ВЗ.WMSRTUQuery) КАК WMSRTUQuery
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(*) КАК WMSRTUQuery
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
	//Что делает метод: проверяет есть ли ошибки в последней загрузке из ОП.
	//Ответ метода (int): 0 если есть ошибка в обмене или со времени последнего обмена прошло больше 10 минут, если ошибок нет и время меньше 10 минут, то возвращает 1
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияОбменовПоСообщениямСрезПоследних.Период,
	|	ИсторияОбменовПоСообщениямСрезПоследних.Ошибка
	|ИЗ
	|	РегистрСведений.ИсторияОбменовПоСообщениям.СрезПоследних(
	|			,
	|			Узел = &Узел
	|				И НЕ Исходящее) КАК ИсторияОбменовПоСообщениямСрезПоследних";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена("ОбменПартКом83_ОкноПоставщика", 3));
	
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
	//Что делает метод: анализирует, есть ли ошибки в последнем обмене с WMS
	//Ответ метода (int): 1 - если ошибок нет, 0 - если ошибки есть
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.ИсторияОбменовПоСообщениям.СрезПоследних(
	|			,
	|			Узел = &Узел
	|				И НЕ Исходящее И Ошибка) КАК ИсторияОбменовПоСообщениямСрезПоследних";
	
	Запрос.УстановитьПараметр("Узел", ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена("ОбменПартКом83_TopLog", 3));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 1;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

