﻿
Перем ТабДок, Секция;

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	//Если Не РассылатьПокупателям И Не РассылатьПоставщикам Тогда 
	//	Отказ = Истина;
	//	Сообщить("Выберите хотя бы один вид контрагентов для рассылки: поставщиков или покупателей");
	//КонецЕсли;
	Если СтараяОрганизацияТребуется Тогда 
		ПроверяемыеРеквизиты.Добавить("СтараяОрганизация");
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьРассылку() Экспорт 
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Контрагент,
	               |	Контрагенты.ОсновнойДоговорКонтрагента.Организация КАК Организация
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.ОсновнойДоговорКонтрагента.Организация В(&Организация)
	               |	И Контрагенты.Покупатель
	               |	И ВЫБОР
	               |			КОГДА &ВидДоговора = 1
	               |				ТОГДА Контрагенты.ОсновнойДоговорКонтрагента.ДоговорПриостановлен
	               |			КОГДА &ВидДоговора = 2
	               |				ТОГДА НЕ Контрагенты.ОсновнойДоговорКонтрагента.ДоговорПриостановлен
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ";
	
	Запрос.УстановитьПараметр("Организация", Организации.ВыгрузитьКолонку(0));
	//Запрос.УстановитьПараметр("РассылатьПокупателям", РассылатьПокупателям);
	//Запрос.УстановитьПараметр("РассылатьПоставщикам", РассылатьПоставщикам);
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Если СтараяОрганизацияТребуется Тогда 
		ОтсеятьПоСтаройОрганизации(Таблица);
	КонецЕсли;
	
	//Если Не ВыгружатьЕслиНетДолгов Тогда 
	//	ОтсеятьБезДолгов(Таблица);
	//КонецЕсли;
	Если Не ВыгружатьЕслиНетДолгов Тогда 
		ПолучитьСальдо(Таблица);
		Строки = Таблица.НайтиСтроки(Новый Структура("Сальдо", 0));
		Для Каждого СтрокаТЧ Из Строки Цикл 
			Таблица.Удалить(СтрокаТЧ);
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьEmail(Таблица);
	
	
	Таблица.Колонки.Добавить("Отослан", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("Ошибка", Новый ОписаниеТипов("Булево")); 
	Таблица.Колонки.Добавить("ТекстОшибки", ОбщегоНазначения.ОписаниеТипаСтрока(300));
	Таблица.Колонки.Добавить("Удалить", Новый ОписаниеТипов("Булево"));	
	СверТаблица = Таблица.Скопировать(, "Контрагент");
	СверТаблица.Свернуть("Контрагент");
		
	Для Каждого СтрокаСв Из СверТаблица Цикл 
		Строки = Таблица.НайтиСтроки(Новый Структура("Контрагент", СтрокаСв.Контрагент));
		Для Каждого СтрокаТЧ Из Строки Цикл 
			Если ЗначениеЗаполнено(СтрокаТЧ.Адрес) Тогда 
				СтруктураОтчета = СформироватьОтчет(СтрокаТЧ.Контрагент, СтрокаТЧ.Организация);
				СтруктураОтчета.Вставить("Удалить", Ложь);
				
				СтрокаТЧ.Отослан = ОтослатьПоПочте(СтруктураОтчета, Адрес);
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтруктураОтчета, "Ошибка, ТекстОшибки, Удалить");
				Если СтрокаТЧ.Ошибка Тогда 
					СтрокаТЧ.ТекстОшибки = "Ошибка: " + СтрокаТЧ.ТекстОшибки;
				КонецЕсли;
			Иначе
				СтрокаТЧ.Ошибка = Истина;
				СтрокаТЧ.ТекстОшибки = "У контрагента" + СтрокаТЧ.Контрагент + " нет адреса для обмена документами";
			КонецЕсли;
		КонецЦикла;
		#Если Клиент Тогда 
			Состояние("Обработано " + СверТаблица.Индекс(СтрокаСв) + " из " + СверТаблица.Количество());
		#КонецЕсли
	КонецЦикла;
	Строки = Таблица.НайтиСтроки(Новый Структура("Удалить", Истина));
	
	Для Каждого СтрокаТЧ Из Строки Цикл 
		Таблица.Удалить(СтрокаТЧ);
	КонецЦикла;
	
	//#Если Клиент Тогда 
	Если ЭтоАдресВременногоХранилища(Адрес) Тогда 	
		СформироватьТабличныйДокумент(Таблица);
	КонецЕсли;
	//#КонецЕсли
КонецПроцедуры

Процедура ЗаполнитьEmail(Таблица)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&Таблица КАК Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КонтактнаяИнформация.Объект КАК Контрагент,
	               |	КонтактнаяИнформация.Представление КАК Адрес
	               |ПОМЕСТИТЬ втАдреса
	               |ИЗ
	               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Объект В
	               |			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |				Таблица.Контрагент
	               |			ИЗ
	               |				Таблица)
	               |	И КонтактнаяИнформация.Вид = &ВидЭмейл
	               |	И КонтактнаяИнформация.Представление <> """"
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация,
	               |	ЕСТЬNULL(втАдреса.Адрес, """") КАК Адрес
	               |ИЗ
	               |	Таблица КАК Таблица
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втАдреса КАК втАдреса
	               |		ПО Таблица.Контрагент = втАдреса.Контрагент";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.УстановитьПараметр("ВидЭмейл", Справочники.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами);
	Таблица = Запрос.Выполнить().Выгрузить();
КонецПроцедуры

Процедура ОтсеятьПоСтаройОрганизации(Таблица)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&Таблица КАК Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ДоговорыКонтрагентов.Владелец
	               |ПОМЕСТИТЬ вт
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	ДоговорыКонтрагентов.Организация = &Организация
	               |	И ДоговорыКонтрагентов.Владелец В
	               |			(ВЫБРАТЬ
	               |				Таблица.Контрагент
	               |			ИЗ
	               |				Таблица)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация
	               |ПОМЕСТИТЬ вт2
	               |ИЗ
	               |	Таблица КАК Таблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт КАК вт
	               |		ПО Таблица.Контрагент = вт.Владелец
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт2.Контрагент,
	               |	вт2.Организация
	               |ИЗ
	               |	вт2 КАК вт2
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	вт2.Контрагент,
	               |	&Организация
	               |ИЗ
	               |	вт2 КАК вт2";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.УстановитьПараметр("Организация", СтараяОрганизация);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

Функция СформироватьОтчет(Контрагент, Организация)
	
	СтруктураОтчета = Новый Структура("Ошибка,ТекстОшибки", Ложь, "");
	СтруктураОтчета.Вставить("Организация", Организация);
	СтруктураОтчета.Вставить("Контрагент", Контрагент);
	СтруктураОтчета.Вставить("Договор", Неопределено);
	СтруктураОтчета.Вставить("НачалоПериода", НачалоПериода);
	СтруктураОтчета.Вставить("ОкончаниеПериода", КонецПериода);
	СтруктураОтчета.Вставить("ТабличныйДокумент", Новый ТабличныйДокумент);
	
	Отчет = Отчеты.АктСверкиВзаиморасчетов.Создать();
	Отчет.ЗаполнитьАктСверки(СтруктураОтчета);
	
	Возврат СтруктураОтчета;
	
КонецФункции

Функция ОтослатьПоПочте(СтруктураОтчета, Адрес)
	
	Если Не СтруктураОтчета.Ошибка Тогда 		
				
		Параметры = Новый Структура;
		Параметры.Вставить("Отчет", СтруктураОтчета.ТабличныйДокумент);
		Параметры.Вставить("ШаблонПисьма", Справочники.ШаблоныТекстовПисем.ПустаяСсылка());
		Параметры.Вставить("ВидТекстаПисьма", Перечисления.ВидыТекстовЭлектронныхПисем.Текст);
		Параметры.Вставить("АдресЭлектроннойПочтыКонтрагента", Адрес);
		Параметры.Вставить("ОбъектПечати", СтруктураОтчета.Контрагент);
		Параметры.Вставить("ВложенияHTML", Ложь);
		Параметры.Вставить("ВложенияTXT", Ложь);
		Параметры.Вставить("ВложенияXLS", Истина);
		Параметры.Вставить("ВложенияMXL", Ложь);
		Параметры.Вставить("ИмяФайлаВложения", "Акт сверки взаиморасчетов");
		Параметры.Вставить("ТемаСообщения", "Акт сверки взаиморасчетов");
		Параметры.Вставить("ЗаполнятьТекстПисьма", Истина);
        Попытка
			Если ВыгружатьЕслиНетДолгов Или СтруктураОтчета.Сальдо <> 0 Тогда  
				УправлениеЭлектроннойПочтой.ОтправитьОтчет(Параметры);
				Если ВыгружатьЕслиНетДолгов И СтруктураОтчета.Сальдо = 0 Тогда 
					СтруктураОтчета.ТекстОшибки = "Нет долгов";
				КонецЕсли;	
				Возврат Истина;
			ИначеЕсли Не ВыгружатьЕслиНетДолгов И СтруктураОтчета.Сальдо = 0 Тогда 
				СтруктураОтчета.Удалить = Истина;
			КонецЕсли;
		Исключение
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = ОписаниеОшибки();
		КонецПопытки;		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура СформироватьТабличныйДокумент(Таблица)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация,
	               |	Таблица.Отослан,
	               |	Таблица.Ошибка,
	               |	Таблица.ТекстОшибки
	               |ПОМЕСТИТЬ Таблица
	               |ИЗ
	               |	&Таблица КАК Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Таблица.Контрагент,
	               |	Таблица.Организация,
	               |	Таблица.Отослан,
	               |	Таблица.Ошибка,
	               |	Таблица.ТекстОшибки
	               |ИЗ
	               |	Таблица КАК Таблица
	               |ИТОГИ ПО
	               |	Таблица.Контрагент";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
    ТабДок = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("Макет");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Вывести(Шапка);
	
	Секция = ТабДок.ПолучитьОбласть("R2");
    ТабДок.НачатьАвтогруппировкуСтрок();
    ПечатьДерева (Дерево,,Дерево.Колонки);
    ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ПоместитьВоВременноеХранилище(ТабДок, Адрес);
	//ТабДок.Показать();
КонецПроцедуры

Процедура ПечатьДерева(СтрокаДерева, Уровень = 0, Колонки)
    Для Каждого стр Из СтрокаДерева.Строки Цикл
        НомерКолонки = 0;
        отступ = "";
        Для н = 1 По Уровень Цикл   
            отступ = отступ + " ";
        КонецЦикла;
        Для Каждого КЛ Из Колонки Цикл
            НомерКолонки = НомерКолонки + 1;
            Секция.Область(1, НомерКолонки).Текст = ?(НомерКолонки = 1, отступ+стр[КЛ.Имя], стр[КЛ.Имя]);
        КонецЦикла;
        ТабДок.Вывести(Секция,Уровень+1);
        ПечатьДерева(стр,Уровень+1,Колонки);
    КонецЦикла;
КонецПроцедуры

Процедура ПолучитьСальдо(Таблица) 		
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Таблица.Контрагент КАК Контрагент,
	                      |	Таблица.Организация КАК Организация
	                      |ПОМЕСТИТЬ Таблица
	                      |ИЗ
	                      |	&Таблица КАК Таблица
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	Контрагент,
	                      |	Организация
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ДепозитыКонтрагентовОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	                      |	ДепозитыКонтрагентовОстатки.ДоговорКонтрагента.Организация КАК Организация,
	                      |	СУММА(ДепозитыКонтрагентовОстатки.СуммаУпрОстаток) КАК Сумма
	                      |ПОМЕСТИТЬ втДепозиты
	                      |ИЗ
	                      |	РегистрНакопления.ДепозитыКонтрагентов.Остатки(
	                      |			&КонецПериода,
	                      |			(ДоговорКонтрагента.Владелец, ДоговорКонтрагента.Организация) В
	                      |				(ВЫБРАТЬ
	                      |					Таблица.Контрагент,
	                      |					Таблица.Организация
	                      |				ИЗ
	                      |					Таблица КАК Таблица)) КАК ДепозитыКонтрагентовОстатки
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ДепозитыКонтрагентовОстатки.ДоговорКонтрагента.Владелец,
	                      |	ДепозитыКонтрагентовОстатки.ДоговорКонтрагента.Организация
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	Контрагент,
	                      |	Организация
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	                      |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Организация КАК Организация,
	                      |	СУММА(ВзаиморасчетыОстатки.СуммаУпрОстаток) КАК Сумма
	                      |ПОМЕСТИТЬ втВзаиморасчеты
	                      |ИЗ
	                      |	РегистрНакопления.Взаиморасчеты.Остатки(
	                      |			&КонецПериода,
	                      |			(ДоговорКонтрагента.Владелец, ДоговорКонтрагента.Организация) В
	                      |				(ВЫБРАТЬ
	                      |					Таблица.Контрагент,
	                      |					Таблица.Организация
	                      |				ИЗ
	                      |					Таблица КАК Таблица)) КАК ВзаиморасчетыОстатки
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец,
	                      |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Организация
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	Контрагент,
	                      |	Организация
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Таблица.Контрагент,
	                      |	Таблица.Организация,
	                      |	ЕСТЬNULL(втДепозиты.Сумма, 0) + ЕСТЬNULL(втВзаиморасчеты.Сумма, 0) КАК Сальдо
	                      |ИЗ
	                      |	Таблица КАК Таблица
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ втДепозиты КАК втДепозиты
	                      |		ПО Таблица.Контрагент = втДепозиты.Контрагент
	                      |			И Таблица.Организация = втДепозиты.Организация
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ втВзаиморасчеты КАК втВзаиморасчеты
	                      |		ПО Таблица.Контрагент = втВзаиморасчеты.Контрагент
	                      |			И Таблица.Организация = втВзаиморасчеты.Организация");
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода); 
	Таблица = Запрос.Выполнить().Выгрузить();

КонецПроцедуры
