﻿Перем МассивПользователи Экспорт;
Перем МассивКомпьютеры Экспорт;
Перем МассивМетаданных Экспорт;
Перем МассивОбъектов Экспорт;
Перем МассивСобытий Экспорт;
Перем МассивУзловРИБ Экспорт;
Перем ПредставлениеОбъекта Экспорт;
Перем МассивОбъектовСсылок Экспорт;
Перем ТолькоИзменения Экспорт;

Функция ПолучитьДатуНачалаПериодаПоУмолчанию(ТекДата) Экспорт
	
	ДатаНачала = НачалоДня(ТекДата);
	Вариант = внЖурналРегистрацииПовтИсп.глВНЗначениеПеременной("ДавностьПросмотраВЖурналеПоУмолчанию");	
	// 0 без огранчений, 1 - за квартал, 2 - за месяц, 3 - за неделю, 4 за день, 5 за час
	Если Вариант = 1 Тогда
		Возврат ДобавитьМесяц(ТекДата, -3);
	ИначеЕсли Вариант = 2 Тогда
		Возврат ТекДата - 86400 * 30;
	ИначеЕсли Вариант = 3 Тогда
		Возврат ТекДата - 86400 * 7;
	ИначеЕсли Вариант = 4 Тогда
		Возврат ТекДата - 86400;
	ИначеЕсли Вариант = 5 Тогда
		Возврат ТекДата - 3600;
	Иначе
		Возврат Дата(1, 1, 1);
	КонецЕсли;
	
КонецФункции

Функция ПериодВыборкиСтрокойПоУмолчанию() Экспорт
	
	Вариант = внЖурналРегистрацииПовтИсп.глВНЗначениеПеременной("ДавностьПросмотраВЖурналеПоУмолчанию");	
	Если Вариант = 1 Тогда
		Возврат "квартал";
	ИначеЕсли Вариант = 2 Тогда
		Возврат "месяц";
	ИначеЕсли Вариант = 3 Тогда
		Возврат "неделю";
	ИначеЕсли Вариант = 4 Тогда
		Возврат "день";
	ИначеЕсли Вариант = 5 Тогда
		Возврат "час";
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПериодПоУмолчанию() Экспорт
	
	ДатаНач = ПолучитьДатуНачалаПериодаПоУмолчанию(ТекущаяДата());
	ДатаКон = КонецДня(ТекущаяДата());	
	
КонецПроцедуры

Процедура ОчиститьОтборы() Экспорт
	
	// Очищаем все отборы
	МассивПользователи		= Новый Массив();
	МассивКомпьютеры		= Новый Массив();
	МассивМетаданных		= Новый Массив();
	МассивОбъектов			= Новый Массив();
	МассивСобытий			= Новый Массив();
	МассивУзловРИБ			= Новый Массив();
	МассивОбъектовСсылок	= Новый Массив();
	ПредставлениеОбъекта 	= "";
	ТолькоИзменения			= Ложь;
	
КонецПроцедуры

ОчиститьОтборы();