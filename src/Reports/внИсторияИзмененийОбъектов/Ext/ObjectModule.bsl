﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка 		= Ложь;

	ВнешниеДанные 				= ПолучитьДанныеВнешнихНаборов(ВыбранныйОбъект);
	ВнешниеНаборыДанных 		= Новый Структура;
	ВнешниеНаборыДанных.Вставить("Данные", ВнешниеДанные);
	ТаблицаВерсий 				= ВнешниеДанные;
	
	НастройкиКомпоновкиДанных 	= КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета 			= Новый КомпоновщикМакетаКомпоновкиДанных;
	ТекСхема 					= ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки 			= КомпоновщикМакета.Выполнить(ТекСхема, НастройкиКомпоновкиДанных, ДанныеРасшифровки);
	ПроцессорКомпоновки 		= Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	ПроцессорВывода 			= Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();

	НачальнаяСтрока 			= 1;
	НачальныйСтолбец 			= 2;
	
	Для Столбец = НачальныйСтолбец По ДокументРезультат.ШиринаТаблицы Цикл
		
		ДокументРезультат.Область(1, Столбец, 5, Столбец).Объединить();
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает ТЗ с данными по объектам
Функция ПолучитьДанныеВнешнихНаборов(ВыбранныйОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТЗ = Новый ТаблицаЗначений;
	
	ТЗ.Колонки.Добавить("Объект");
	ТЗ.Колонки.Добавить("ИмяТЧ", 				Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("ИмяТЧОписание", 		Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("ИмяРеквизита", 		Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("ИмяРеквизитаОписание", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("НомерСтрокиТЧ", 		Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Любой)));
	ТЗ.Колонки.Добавить("НомерСтрокиТЧОписание",Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("НомерВерсии", 			Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Любой)));
	ТЗ.Колонки.Добавить("НомерВерсииОписание",	Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));

	ТЗ.Колонки.Добавить("Значение",				Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("Представление",		Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(300, ДопустимаяДлина.Переменная)));
	ТЗ.Колонки.Добавить("ДатаИзменения",		Новый ОписаниеТипов("Дата", , ,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТЗ.Колонки.Добавить("ТипИзменения",			Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(2, 0, ДопустимыйЗнак.Любой)));
	
	НомерПоследнейВерсии = 0;
	
	// ЗАПОЛНЯЕМ ДАННЫЕ ИЗ ИБ
	// Сначала данные из внешней базы
	
	внСоединение = внЖурналРегистрации.ПолучитьСоединение();
	Если внСоединение = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// В хранителе, обработаны
	Запрос = внСоединение.NewObject("Запрос");		
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	внЖурналРегистрации.Код КАК Код,
		|	внЖурналРегистрации.ДатаИзменения КАК ДатаИзменения,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.Пользователь) КАК Пользователь,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.Компьютер) КАК Компьютер,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.УзелРИБ) КАК УзелРИБ,
		|	внИзменения.СтароеЗначение,
		|	внИзменения.СтароеПредставление,
		|	внИзменения.НовоеЗначение,
		|	внИзменения.НовоеПредставление,
		|	внИзменения.Изменено,
		|	внРеквизитыОбъектов.ИмяТЧ КАК ИмяТЧ,
		|	внРеквизитыОбъектов.ИмяРеквизита КАК ИмяРеквизита,
		|	внРеквизитыОбъектов.ТипРеквизита,
		|	внИзменения.НомерСтрокиТЧ КАК НомерСтрокиТЧ,
		|	внИдентификаторыОбъектов.Наименование КАК ИдентификаторОбъекта,
		|	внЖурналРегистрации.Версия
		|ИЗ
		|	РегистрСведений.внИзменения КАК внИзменения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.внЖурналРегистрации КАК внЖурналРегистрации
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.внИдентификаторыОбъектов КАК внИдентификаторыОбъектов
		|			ПО внЖурналРегистрации.ИдентификаторОбъекта = внИдентификаторыОбъектов.Ссылка
		|		ПО внИзменения.Изменение = внЖурналРегистрации.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.внРеквизитыОбъектов КАК внРеквизитыОбъектов
		|		ПО внИзменения.Реквизит = внРеквизитыОбъектов.Ссылка
		|ГДЕ
		|	внЖурналРегистрации.ИнформационнаяБаза = &ИнформационнаяБаза
		|	И внИдентификаторыОбъектов.Наименование = &ИдентификаторОбъекта
		|	И внЖурналРегистрации.СостояниеЗаписи > 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаИзменения,
		|	Код,
		|	ИмяТЧ,
		|	НомерСтрокиТЧ,
		|	ИмяРеквизита"
	;

	Запрос.УстановитьПараметр("ИнформационнаяБаза"	, внСоединение.внЖурналРегистрации.ПолучитьСсылкуИнформационнойБазы(внЖурналРегистрацииПовтИсп.ПолучитьИдентификаторИБ()));
	Запрос.УстановитьПараметр("ИдентификаторОбъекта", внЖурналРегистрации.СистемноеПредставлениеОбъекта(ВыбранныйОбъект));
	Выборка = Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТЗ.Добавить();
		Попытка
			НоваяСтрока.Объект 			= внЖурналРегистрации.ЗначениеИзСтрокиВнутрСервер(Выборка.ИдентификаторОбъекта);
		Исключение
			НоваяСтрока.Объект 			= Выборка.ИдентификаторОбъекта;
		КонецПопытки;
		
		НоваяСтрока.ИмяРеквизита = Выборка.ИмяРеквизита;
		
		Если НЕ ПустаяСтрока(Выборка.ИмяТЧ) Тогда
			НоваяСтрока.ИмяТЧ 			= Выборка.ИмяТЧ;
			НоваяСтрока.НомерСтрокиТЧ 	= Выборка.НомерСтрокиТЧ;
		КонецЕсли;
		
		НоваяСтрока.Значение 			= Выборка.НовоеЗначение;
		НоваяСтрока.Представление 		= Выборка.НовоеПредставление;
		НоваяСтрока.ДатаИзменения 		= Выборка.ДатаИзменения;
		НоваяСтрока.НомерВерсии 		= Выборка.Версия;
		
		НоваяСтрока.НомерВерсииОписание =
			"Версия из ИБ №" + Строка(НоваяСтрока.НомерВерсии) + Символы.ПС + 
			Выборка.УзелРИБ + Символы.ПС + 
			Выборка.Пользователь + " (" + Выборка.Компьютер + ")" + Символы.ПС + 
			Формат(НоваяСтрока.ДатаИзменения, "ДЛФ=DT") + " (изменения определены)";
			
		Попытка
			Если НомерПоследнейВерсии < НоваяСтрока.НомерВерсии Тогда
				НомерПоследнейВерсии = НоваяСтрока.НомерВерсии;
			КонецЕсли;			
		Исключение
		КонецПопытки;
			
	КонецЦикла;
	
	// В хранителе, не обработаны
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	внЖурналРегистрации.Код КАК Код,
		|	внЖурналРегистрации.ДатаИзменения КАК ДатаИзменения,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.Пользователь) КАК Пользователь,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.Компьютер) КАК Компьютер,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(внЖурналРегистрации.УзелРИБ) КАК УзелРИБ,
		|	внИдентификаторыОбъектов.Наименование КАК ИдентификаторОбъекта,
		|	внЖурналРегистрации.Ссылка
		|ИЗ
		|	Справочник.внЖурналРегистрации КАК внЖурналРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.внИдентификаторыОбъектов КАК внИдентификаторыОбъектов
		|		ПО внЖурналРегистрации.ИдентификаторОбъекта = внИдентификаторыОбъектов.Ссылка
		|ГДЕ
		|	внЖурналРегистрации.ИнформационнаяБаза = &ИнформационнаяБаза
		|	И внИдентификаторыОбъектов.Наименование = &ИдентификаторОбъекта
		|	И внЖурналРегистрации.СостояниеЗаписи = 1
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаИзменения,
		|	Код"
	;

	Запрос.УстановитьПараметр("ИнформационнаяБаза"	, внСоединение.внЖурналРегистрации.ПолучитьСсылкуИнформационнойБазы(внЖурналРегистрацииПовтИсп.ПолучитьИдентификаторИБ()));
	Запрос.УстановитьПараметр("ИдентификаторОбъекта", внЖурналРегистрации.СистемноеПредставлениеОбъекта(ВыбранныйОбъект));
	Выборка = Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
		
		Попытка
			ИдентификаторОбъекта 			= внЖурналРегистрации.ЗначениеИзСтрокиВнутрСервер(Выборка.ИдентификаторОбъекта);
		Исключение
			ИдентификаторОбъекта 			= Выборка.ИдентификаторОбъекта;
		КонецПопытки;
		
		НомерПоследнейВерсии				= НомерПоследнейВерсии + 1;
		
		Данные = Выборка.Ссылка.Данные.Получить();
		Для Каждого Строки Из Данные Цикл
			
			НоваяСтрока = ТЗ.Добавить();
			НоваяСтрока.Объект 				= ИдентификаторОбъекта;
			
			НоваяСтрока.ИмяРеквизита 		= Строки.ИмяРеквизита;
			
			Если НЕ ПустаяСтрока(Строки.ИмяТЧ) Тогда
				НоваяСтрока.ИмяТЧ 			= Строки.ИмяТЧ;
				НоваяСтрока.НомерСтрокиТЧ 	= Строки.НомерСтрокиТЧ;
			КонецЕсли;
			
			НоваяСтрока.Значение 			= Строки.Значение;
			НоваяСтрока.Представление 		= Строки.Представление;
			НоваяСтрока.ДатаИзменения 		= Выборка.ДатаИзменения;
			НоваяСтрока.НомерВерсии 		= НомерПоследнейВерсии;
			
			НоваяСтрока.НомерВерсииОписание =
				"Версия из ИБ №" + Строка(НоваяСтрока.НомерВерсии) + Символы.ПС + 
				Выборка.УзелРИБ + Символы.ПС + 
				Выборка.Пользователь + " (" + Выборка.Компьютер + ")" + Символы.ПС + 
				Формат(НоваяСтрока.ДатаИзменения, "ДЛФ=DT") + " (изменения НЕ определены)";
				
			КонецЦикла;
			
	КонецЦикла;

	
	// ЗАПОЛНЯЕМ ДАННЫЕ ИЗ КЭША
	// Данные из кэша		
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	внКэшЖурналаРегистрации.НомерЗаписи КАК Код,
		|	внКэшЖурналаРегистрации.Пользователь,
		|	внКэшЖурналаРегистрации.Компьютер,
		|	внКэшЖурналаРегистрации.ДатаИзменения КАК ДатаИзменения,
		|	внКэшЖурналаРегистрации.ИдентификаторОбъекта,
		|	внКэшЖурналаРегистрации.УзелРИБ,
		|	внКэшЖурналаРегистрации.Данные,
		|	внКэшЖурналаРегистрации.МетаданныеОбъекта
		|ИЗ
		|	РегистрСведений.внКэшЖурналаРегистрации КАК внКэшЖурналаРегистрации
		|ГДЕ
		|	внКэшЖурналаРегистрации.ИдентификаторОбъекта = &ИдентификаторОбъекта
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаИзменения,
		|	внКэшЖурналаРегистрации.НомерЗаписи"
	);                                         
	
	Запрос.УстановитьПараметр("ИдентификаторОбъекта", внЖурналРегистрации.СистемноеПредставлениеОбъекта(ВыбранныйОбъект));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ИзмененияТЧ = Выборка.Данные.Получить();
		Если ИзмененияТЧ = Неопределено Тогда
			ИзмененияТЧ = внЖурналРегистрации.СоздатьИзмененияТЧ();
		Иначе
			ИзмененияТЧ = внЖурналРегистрации.ДеСериализоватьОбъект(ИзмененияТЧ, Выборка);
		КонецЕсли;                   
		
		НомерПоследнейВерсии				= НомерПоследнейВерсии + 1;
		
		Для Каждого Строки Из ИзмененияТЧ Цикл
			
			НоваяСтрока = ТЗ.Добавить();
			Попытка
				НоваяСтрока.Объект 			= внЖурналРегистрации.ЗначениеИзСтрокиВнутрСервер(Выборка.ИдентификаторОбъекта);
			Исключение
				НоваяСтрока.Объект 			= Выборка.ИдентификаторОбъекта;
			КонецПопытки;
			
			НоваяСтрока.ИмяРеквизита 		= Строки.ИмяРеквизита;
			
			Если НЕ ПустаяСтрока(Строки.ИмяТЧ) Тогда
				НоваяСтрока.ИмяТЧ 			= Строки.ИмяТЧ;
				НоваяСтрока.НомерСтрокиТЧ 	= Строки.НомерСтрокиТЧ;
			КонецЕсли;
			
			НоваяСтрока.Значение 			= Строки.Значение;
			Попытка
				НоваяСтрока.Представление	= Строка(ЗначениеИзСтрокиВнутр(Строки.Значение));
			Исключение
				НоваяСтрока.Представление	= Строки.Представление;
			КонецПопытки;							
			НоваяСтрока.ДатаИзменения		= Выборка.ДатаИзменения;
			
			НоваяСтрока.НомерВерсии 		= НомерПоследнейВерсии;
			НоваяСтрока.НомерВерсииОписание = 
				"Версия из кэша №" + Строка(НоваяСтрока.НомерВерсии) + Символы.ПС + 
				Выборка.УзелРИБ + Символы.ПС + 
				Выборка.Пользователь + " (" + Выборка.Компьютер + ")" + Символы.ПС + 
				Формат(Выборка.ДатаИзменения, "ДЛФ=DT") + " (изменения НЕ определены)";
		КонецЦикла;
			
	КонецЦикла;		
	
	ТЗ.ЗаполнитьЗначения(0, "ТипИзменения");
	
	// ПЕРЕБИРАЕМ ТЗ И ЗАПОЛНЯЕМ СИНОНИМЫ
	//
	Для Индекс = 0 По ТЗ.Количество() - 1 Цикл
		
		Строки				= ТЗ.Получить(Индекс);
		СтрокиИмяТЧ			= Строки.ИмяТЧ;
		СтрокиИмяРеквизита	= Строки.ИмяРеквизита;
		СтрокиНомерСтрокиТЧ	= Строки.НомерСтрокиТЧ;
		
		Попытка
			ОбъектМетаданные 				= Строки.Объект.Метаданные();
		Исключение
			ОбъектМетаданные 				= Неопределено;
		КонецПопытки;
		
		ПредставлениеРеквизита				= "";				
		
		Если НЕ ПустаяСтрока(Строки.ИмяТЧ) Тогда
			ПредставлениеТЧ					= "";
			Строки.НомерСтрокиТЧОписание	= "Строка №" + Формат(Строки.НомерСтрокиТЧ, "ЧРД=; ЧРГ=; ЧН=0");
			
			Если ОбъектМетаданные <> Неопределено Тогда
				Попытка
					Реквизит				= ОбъектМетаданные.ТабличныеЧасти[СтрокиИмяТЧ].Реквизиты[СтрокиИмяРеквизита];
					ПредставлениеРеквизита	= Реквизит.Синоним;
				Исключение
				КонецПопытки;
			КонецЕсли;
			
			Попытка
				Реквизит					= ОбъектМетаданные.ТабличныеЧасти[СтрокиИмяТЧ];
				ПредставлениеТЧ				= Реквизит.Синоним;
			Исключение
			КонецПопытки;
			
			Если ПустаяСтрока(ПредставлениеТЧ) Тогда
				Строки.ИмяТЧОписание		= СтрокиИмяТЧ;
			Иначе
				Строки.ИмяТЧОписание		= ПредставлениеТЧ;
			КонецЕсли;
			
		Иначе			
			Если ОбъектМетаданные <> Неопределено Тогда
				Попытка
					Реквизит				= ОбъектМетаданные.Реквизиты[СтрокиИмяРеквизита];
					ПредставлениеРеквизита	= Реквизит.Синоним;
				Исключение
				КонецПопытки;
				
				Если ПустаяСтрока(ПредставлениеРеквизита) Тогда
					Попытка
						Реквизит				= ОбъектМетаданные.СтандартныеРеквизиты[СтрокиИмяРеквизита];
						ПредставлениеРеквизита	= Реквизит.Синоним;
					Исключение
					КонецПопытки;					
				КонецЕсли;
				
				Если ПустаяСтрока(ПредставлениеРеквизита) Тогда
					Попытка
						Реквизит				= ОбъектМетаданные.СтандартныеРеквизиты[СтрокиИмяРеквизита];
						ПредставлениеРеквизита	= Реквизит.Синоним;
					Исключение
					КонецПопытки;					
				КонецЕсли;				
			КонецЕсли;
		КонецЕсли;
		
		// Не нашли синоним реквизита
		Если ПустаяСтрока(ПредставлениеРеквизита) Тогда
			Строки.ИмяРеквизитаОписание			= СтрокиИмяРеквизита;
		Иначе
			Строки.ИмяРеквизитаОписание			= ПредставлениеРеквизита;
		КонецЕсли;
		
		// Определяем предыдущие значения и заполняем ТипИзменения
		ТипИзменения = -1;
		ИндексНазад = Индекс - 1;
		Пока ИндексНазад >= 0 Цикл			
			СтрокиНазад = ТЗ.Получить(ИндексНазад);
			
			Если СтрокиИмяТЧ = СтрокиНазад.ИмяТЧ И СтрокиИмяРеквизита = СтрокиНазад.ИмяРеквизита И СтрокиНомерСтрокиТЧ = СтрокиНазад.НомерСтрокиТЧ Тогда
				
				Если Строки.Значение <> СтрокиНазад.Значение Тогда
					Если Строки.Значение = "" Тогда
						ТипИзменения = 3; // Удаление
					Иначе
						ТипИзменения = 2; // Изменение
					КонецЕсли;
				Иначе
					ТипИзменения = 0;
				КонецЕсли;
				
				Прервать;
				
			КонецЕсли;
			
			ИндексНазад = ИндексНазад - 1;
		КонецЦикла;
		
		Если ТипИзменения = -1 Тогда
			ТипИзменения = 1;
		КонецЕсли;
		
		Строки.ТипИзменения = ТипИзменения;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТЗ;
	
КонецФункции // ПолучитьДанныеВнешнихНаборов
