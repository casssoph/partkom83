﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные() Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код,КодДляСайта,ВидОтказа,ВидСостояния");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора);
	
КонецФункции


Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты);
	Иначе
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты)
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.СостоянияСтрокДокументов");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты);

	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		ОбъектXDTO.ВидОтказа = Выборка.ВидОтказа.УникальныйИдентификатор();
		ОбъектXDTO.ВидСостояния = Выборка.ВидСостояния.УникальныйИдентификатор();
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка, "Код,Наименование,НаименованиеДляСайта,КодДляСайта");
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.СостоянияСтрокДокументов";
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
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
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.СостоянияСтрокДокументов) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.СостоянияСтрокДокументов).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.СостоянияСтрокДокументов)) <> ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПустаяСсылка)
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
	                      |	Объекты.Ссылка.КодДляСайта КАК КодДляСайта,
	                      |	Объекты.Ссылка.ВидОтказа КАК ВидОтказа,
	                      |	Объекты.Ссылка.ВидСостояния КАК ВидСостояния,
	                      |	Объекты.Ссылка.НаименованиеДляСайта КАК НаименованиеДляСайта
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
