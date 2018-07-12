﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора);
	
КонецФункции


Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	ОбъектыОбмена = ДанныеЗарегистрированныхОбъектов(ТаблицаСсылокНаОбъекты);
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда
		ВыгрузитьДанныеПланаОбменПартКом83_TopLog(Результат, ОбъектыОбмена)	
	ИначеЕсли МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда 
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(Результат, ОбъектыОбмена)
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ОбъектыОбмена)
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.МаршрутыДоставки");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,, "Ссылка");
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;	
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.МаршрутыДоставки";
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;

	
КонецПроцедуры
Процедура ВыгрузитьДанныеПланаОбменПартКом83_TopLog(МассивОбъектов, ОбъектыОбмена)
	
	URI = ПланыОбмена.ОбменПартКом83_TopLog.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.МаршрутыДоставки");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,, "Ссылка");
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		ОбъектXDTO.РодительСсылка = XMLСтрока(Выборка.Родитель);
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;	
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.МаршрутыДоставки";
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;

	
КонецПроцедуры

Функция ДанныеЗарегистрированныхОбъектов(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.МаршрутыДоставки) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.МаршрутыДоставки).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.МаршрутыДоставки)) <> ЗНАЧЕНИЕ(Справочник.Водители.ПустаяСсылка)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ЭтоУдаление
	                      |ПОМЕСТИТЬ Объекты
	                      |ИЗ
	                      |	ЗарегистрированныеОбъекты КАК ЗарегистрированныеОбъекты
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка,
	                      |	Объекты.Ссылка.Код КАК Код,
	                      |	Объекты.Ссылка.Родитель КАК Родитель,
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	Объекты.Ссылка.ПометкаУдаления КАК ПометкаУдаления,
	                      |	Объекты.Ссылка.ЭтоГруппа КАК ЭтоГруппа,
	                      |	Объекты.Ссылка.Код КАК route_code,
	                      |	Объекты.Ссылка.Наименование КАК name,
	                      |	ЕСТЬNULL(Объекты.Ссылка.Родитель.Код, 0) КАК parent_code,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.ЭтоГруппа
	                      |			ТОГДА 1
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК is_folder,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.ПометкаУдаления
	                      |			ТОГДА ""delete""
	                      |		ИНАЧЕ ""change""
	                      |	КОНЕЦ КАК operation_type
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	НЕ Объекты.ЭтоУдаление
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	Объекты.ЭтоУдаление");
	Запрос.УстановитьПараметр("ТаблицаСсылокНаОбъекты", ТаблицаСсылокНаОбъекты);
	
	Возврат Запрос.ВыполнитьПакет();
	
КонецФункции
