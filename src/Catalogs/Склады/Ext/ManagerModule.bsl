﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные() Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код,Город,СкладVMI,Филиал");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
	
КонецФункции

Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты);
	ИначеЕсли МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда	
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_TopLog(МассивОбъектов, ТаблицаСсылокНаОбъекты);
	Иначе
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты)
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.Склады");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты);
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		ОбъектXDTO.ФизическийСклад = Выборка.ФизическийСклад.УникальныйИдентификатор();
		ОбъектXDTO.Филиал = Выборка.Филиал.УникальныйИдентификатор();
		
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка, "Наименование,ГородНаименование,ПризнакVMI,Адрес,Оптовый");
		
		Если Выборка.ТипСклада <> NULL Тогда 
			ОбъектXDTO.ТипСклада = Выборка.ТипСклада;
		КонецЕсли;
		
		ОбъектXDTO.Код = ЧислоБезВедущихНулей(Выборка.Код);
		ОбъектXDTO.КодСайта = ЧислоБезВедущихНулей(Выборка.КодСайта);
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;	
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.Склады";
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
	
КонецПроцедуры
Функция ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады)) <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
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
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.СкладVMI
	                      |			ТОГДА 1
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК ПризнакVMI,
	                      |	ЕСТЬNULL(Объекты.Ссылка.Город.Наименование, """") КАК ГородНаименование,
	                      |	Объекты.Ссылка.КодСайта КАК КодСайта,
	                      |	Объекты.Ссылка.Филиал КАК Филиал,
	                      |	Объекты.Ссылка.ФизическийСклад КАК ФизическийСклад,
	                      |	ЕСТЬNULL(КонтактнаяИнформация.Представление, """") КАК Адрес,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.СкладVMI
	                      |				ИЛИ Объекты.Ссылка.ОсновнойСкладРегиона
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК Оптовый,
	                      |	ПРЕДСТАВЛЕНИЕ(Объекты.Ссылка.ТипСклада) КАК ТипСклада
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                      |		ПО Объекты.Ссылка = КонтактнаяИнформация.Объект
	                      |			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	                      |			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресСклада))
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

Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_TopLog(МассивОбъектов, ТаблицаСсылокНаОбъекты)
	
	URI = "http://partkom83-TopLogExchangeScheme.ru";
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.Склады");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_TopLog(ТаблицаСсылокНаОбъекты);
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,, "Ссылка");
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.Склады";
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
		
КонецПроцедуры
Функция ДанныеОбъектовПланаОбменаОбменПартКом83_TopLog(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады)) <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
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
	                      |	Объекты.Ссылка КАК Ссылка,
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	Объекты.Ссылка.ПометкаУдаления КАК ПометкаУдаления,
	                      |	Объекты.Ссылка.ЭтоГруппа КАК ЭтоГруппа
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

Функция ЧислоБезВедущихНулей(Строка)
	
	ЧислоСтрокой = 0;
	Попытка
		ЧислоСтрокой = Формат(Число(Строка), "ЧГ=");
	Исключение
	КонецПопытки;
	
	Возврат ЧислоСтрокой;
	
КонецФункции

Функция СкладыБракаИНедостач() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Склады.СкладНедостач КАК СкладНедостач
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	НЕ Склады.ЭтоГруппа
		|	И НЕ Склады.СкладНедостач = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|	И НЕ Склады.СкладНедостач.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СкладНедостач");
	
КонецФункции

Функция СкладыРегионов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	НЕ Склады.ЭтоГруппа
		|	И Склады.ОсновнойСкладРегиона
		|	И НЕ Склады.ТоварыВПути";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад");
	
КонецФункции