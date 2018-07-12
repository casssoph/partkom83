﻿//Контроль изменения реквизитов
Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	Структура = Новый Структура;
	
	Если МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт тогда
		Структура.Вставить("Шапка", "Наименование,Код,Приоритет");
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции
Функция ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора);
	
КонецФункции

//Сохранения объекта в XDTO
Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочник.ГруппыКонтрагентов");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	
	МассивОбъектов = Новый Массив;
	
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		
		ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты);
		
		Выборка = ОбъектыОбмена[2].Выбрать();
		Пока Выборка.Следующий() цикл
			ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
			ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
			ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка, "Код,Наименование,Приоритет");
			
			МассивОбъектов.Добавить(ОбъектXDTO);
		КонецЦикла;			
		
		Выборка = ОбъектыОбмена[3].Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
			ОбъектXDTO.ТипОбъекта = "Справочник.ГруппыКонтрагентов";
			ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
			
			МассивОбъектов.Добавить(ОбъектXDTO);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

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
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ГруппыКонтрагентов) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ГруппыКонтрагентов).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ГруппыКонтрагентов)) <> ЗНАЧЕНИЕ(Справочник.ГруппыКонтрагентов.ПустаяСсылка)
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
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	Объекты.Ссылка.Код КАК Код,
	                      |	Объекты.Ссылка.Приоритет КАК Приоритет
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