﻿///////////////////////////////////////////////////////////////////////////////
// СИСТЕМНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает часто используемые настройки и значения
Функция глВНЗначениеПеременной(Знач ИмяПараметра) Экспорт
	
	Возврат внЖурналРегистрацииСервер.глВНЗначениеПеременной(ИмяПараметра);
	
КонецФункции

// Возвращает Ложь или Истина в зависимости от того регистрировать ли события объекта метаданных или нет
Функция РегистрироватьСобытиеОбъекта(Знач ПолноеИмя) Экспорт
		
	Возврат внЖурналРегистрацииСервер.РегистрироватьСобытиеОбъекта(ПолноеИмя);
		
КонецФункции // РегистрироватьСобытиеОбъекта

// Возвращает список значений с объектами 
Функция МассивПредопределенныхНеРегистрируемыхОбъектов() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("РегистрСведений.внКэшЖурналаРегистрации");
	Результат.Добавить("РегистрСведений.внНастройкиЖурналаРегистрации");
	Результат.Добавить("РегистрСведений.внРегистрируемыеОбъекты");
	Результат.Добавить("РегистрСведений.ИсторияЗаявокПокупателя");
	Результат.Добавить("РегистрСведений.СостояниеЗаявокПокупателя");

	Возврат Результат;
	
КонецФункции // МассивПредопределенныхНеРегистрируемыхОбъектов

// Функция позволяет определить запуск происходит в дубле информационной базы, где включен журнал регистрации или нет
Функция ВеренПараметрУникальности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Если стоит не ИспользоватьПараметрУникальностиИБ, то возвращаем всегда Истина и ничего не проверяем
	Если НЕ глВНЗначениеПеременной("ИспользоватьПараметрУникальностиИБ") Тогда
		
		Возврат Истина;
		
	Иначе
		
		ПУСписокСерверов	= НРег(глВНЗначениеПеременной("ПараметрУникальностиСписокСерверов"));
		ПУИмяБазы			= НРег(глВНЗначениеПеременной("ПараметрУникальностиИмяБазы"));
		
		ПУ					= внЖурналРегистрации.ПараметрУникальностиИБ();
		ТекущийСервер		= ПУ.Сервер;
		ТекущееИмяБазы 		= ПУ.ИмяБазы;
		
		Если ПустаяСтрока(ПУСписокСерверов) Тогда
			
			Возврат ПУИмяБазы = ТекущееИмяБазы;
			
		Иначе
			
			Если Найти(ПУСписокСерверов, "|") > 0 Тогда
				РазделительПоиска = "|";
			Иначе
				РазделительПоиска = ";";
			КонецЕсли;
			МассивСерверов		= внЖурналРегистрации.внРазложитьСтрокуВМассивПодстрок(ПУСписокСерверов, РазделительПоиска, Истина);
			Для Каждого Сервер Из МассивСерверов Цикл
				
				Если СокрЛП(Сервер) = ТекущийСервер И ПУИмяБазы = ТекущееИмяБазы Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
				
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // ВеренПараметрУникальности

// Возвращает число идентфикатор данной ИБ
Функция ПолучитьИдентификаторИБ() Экспорт
			
	Возврат глВНЗначениеПеременной("ИдентификаторИБ");
	
КонецФункции // ПолучитьИдентификаторИБ

// Возвращает число идентфикатор данной ИБ
Функция ПолучитьИдентификаторУзлаРИБ() Экспорт
			
	Возврат глВНЗначениеПеременной("ИдентификаторУзлаРИБ");
	
КонецФункции // ПолучитьИдентификаторУзлаРИБ

// Возвращает таблицу с колонками МетаданныеОбъекта, ИмяТЧ, ИмяРеквизита с регистрируемыми/не регистрируемыми значениями
Функция ТаблицаРегистрацииОбъектовМетаданных(ПолноеИмя) Экспорт
		
	Возврат внЖурналРегистрацииСервер.ТаблицаРегистрацииОбъектовМетаданных(ПолноеИмя);
	
КонецФункции // ТаблицаРегистрацииОбъектовМетаданных

// Истина если тип обмена в настрйоках "Полный обмен"
Функция ТипОбменаРИБПолный() Экспорт
		
	Возврат внЖурналРегистрацииСервер.ТипОбменаРИБПолный();
	
КонецФункции // ТипОбменаРИБПолный

// Проверяет текущуая конфигурация использует БСП или нет
Функция КонфигурацияИспользуетБСП() Экспорт

	Возврат внЖурналРегистрацииСервер.КонфигурацияИспользуетБСП();
	
КонецФункции

// Получает имя компьютра из параметров сеанса для текущего пользователя
Функция ПолучитьИмяКомпьютера() Экспорт
	
	Возврат внЖурналРегистрацииСервер.ПолучитьИмяКомпьютера();
	
КонецФункции

// Получает имя пользователя
// Для обычного пользователя возвращает имя, для изменений в фоновом задании для 8.3 строку "Фоновое задание"
Функция ПолучитьИмяПользователя() Экспорт
	                                          
	Возврат ?(ПустаяСтрока(ИмяПользователя()), НСтр("ru = 'Фоновое задание'"), ИмяПользователя()); 
	
КонецФункции // ПолучитьИмяПользователя

// Получает версию платформы в формате 8.2 или 8.3
Функция внВерсияПлатформы() Экспорт
	
	СисИнфо 		= Новый СистемнаяИнформация;
	ПодстрокиВерсии = внЖурналРегистрации.внРазложитьСтрокуВМассивПодстрок(СисИнфо.ВерсияПриложения, ".");
	Возврат ПодстрокиВерсии[0] + "." + ПодстрокиВерсии[1];
	
КонецФункции

// Проверка для 8.3 используется ли модальность
// Сохранена поддержка 8.2, для них всегда возвращается Истина
Функция ИспользуетсяРежимМодальности() Экспорт
	
	Попытка
		
		Возврат Вычислить("Метаданные.РежимИспользованияМодальности = Метаданные.СвойстваОбъектов.РежимИспользованияМодальности.Использовать");
		
	Исключение
		
		Возврат Истина;
		
	КонецПопытки;
	
КонецФункции // ИспользуетсяРежимМодальности

// Проверка, что система в тестовом режиме
Функция ЭтоТестовыйРежим() Экспорт
	
	Возврат Метаданные.Имя = "ВнешнийЖурналРегистрации";
	
КонецФункции // ЭтоТестовыйРежим
