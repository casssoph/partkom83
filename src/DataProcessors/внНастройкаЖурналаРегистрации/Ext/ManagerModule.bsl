﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ

//
// Процедура выполняет обновление информационной базы в случае необходимости.
//
Процедура ВыполнитьОбновление() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущаяВерсия	= внЖурналРегистрацииПовтИсп.глВНЗначениеПеременной("Версия");
	ПоследняяВерсия = "3.0.6.1";
	
	Если ТекущаяВерсия = ПоследняяВерсия Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекущаяВерсия) Тогда
		
		// Это первый запуск
		ЗаполнитьПервоначальнымиДанными();
		
	Иначе
		
		Если ТекущаяВерсия = "3.0.5.0" Тогда
			ОбновитьДоВерсии_3_0_6();
		КонецЕсли;
		
		Сообщить("Подсистема <Журнал регистрации изменений во внешней ИБ 1С> обновлена на версию " + ПоследняяВерсия);
		
	КонецЕсли;
	
	// Если БСП обновим идентификаторы
	Попытка
		Если Метаданные.Справочники.Найти("ИдентификаторыОбъектовМетаданных") <> Неопределено Тогда
			Выполнить("Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьДанныеСправочника()");
		КонецЕсли;
	Исключение		
	КонецПопытки;
	
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("Версия", ПоследняяВерсия);
	ОбновитьПовторноИспользуемыеЗначения();
		
КонецПроцедуры

Процедура ЗаполнитьПервоначальнымиДанными() Экспорт
	
	// Удаляем регистры из регистрируемых объектов
	НаборЗаписей = РегистрыСведений.внРегистрируемыеОбъекты.СоздатьНаборЗаписей();
	Для каждого Регистр Из Метаданные.РегистрыСведений Цикл
		НоваяЗапись						= НаборЗаписей.Добавить();
		НоваяЗапись.МетаданныеОбъекта	= Регистр.ПолноеИмя();
		НоваяЗапись.ИмяТЧ				= "";
		НоваяЗапись.ИмяРеквизита		= "";
	КонецЦикла;
	НаборЗаписей.Записать(Истина);
	
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ИспользоватьПараметрУникальностиИБ",	Истина);
	Параметры																								= внЖурналРегистрации.ПараметрУникальностиИБ();
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ПараметрУникальностиСписокСерверов",	Параметры.Сервер);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ПараметрУникальностиИмяБазы",			Параметры.ИмяБазы);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ИдентификаторИБ",						Метаданные.Имя);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ТипОбменаРИБ",							Перечисления.внТипОбменаРИБ.ОбменЧерезРИБХранительЖурнала);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ТипИБ",								Перечисления.внТипИБ.Серверная);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ОткрыватьСобытияСФильтромИзменений",	Истина);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("РазмерПакетаПереносаДанных",			100);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("ДавностьПросмотраВЖурналеПоУмолчанию",	2);
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("МетодРегистрацииОбъектовМетаданных",	Перечисления.внМетодыРегистрацииНовыхОбъектов.ФиксироватьВыбранныеОбъектыИНовые);
	
КонецПроцедуры

Процедура ОбновитьДоВерсии_3_0_6() Экспорт
	
	внЖурналРегистрацииСервер.УстановитьНастройкуЖурналаРегистрации("МетодРегистрацииОбъектовМетаданных",	Перечисления.внМетодыРегистрацииНовыхОбъектов.ФиксироватьВыбранныеОбъектыИНовые);
	
КонецПроцедуры
