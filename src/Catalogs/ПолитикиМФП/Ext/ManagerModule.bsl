﻿
Функция ПолитикаУникальна(Ссылка, Владелец, ПериодДействия) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолитикиМФП.Ссылка
		|ИЗ
		|	Справочник.ПолитикиМФП КАК ПолитикиМФП
		|ГДЕ
		|	ПолитикиМФП.Ссылка <> &Ссылка
		|	И ПолитикиМФП.Владелец = &Владелец
		|	И ПолитикиМФП.ПериодДействия = &ПериодДействия
		|	И НЕ ПолитикиМФП.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ПериодДействия", ПериодДействия);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьПолитикуМФПДляОрганизации(Организация, ДатаДействия) Экспорт
	
	Политика = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПолитикиМФП.Ссылка
		|ИЗ
		|	Справочник.ПолитикиМФП КАК ПолитикиМФП
		|ГДЕ
		|	ПолитикиМФП.Владелец = &Владелец
		|	И ПолитикиМФП.ПериодДействия <= &ПериодДействия
		|	И НЕ ПолитикиМФП.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПолитикиМФП.ПериодДействия УБЫВ";
	
	Запрос.УстановитьПараметр("Владелец", Организация);
	Запрос.УстановитьПараметр("ПериодДействия", НачалоДня(ДатаДействия));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Политика = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Политика;
	
КонецФункции

Функция КонтрагентОрганизации(Организация, ДатаДействия) Экспорт
	
	КонтрагентОрганизации = Неопределено;
	
	Политика = ПолучитьПолитикуМФПДляОрганизации(Организация, ДатаДействия);	
	
	Если ЗначениеЗаполнено(Политика) Тогда
		КонтрагентОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Политика, "Контрагент");
	КонецЕсли;
	
	Возврат КонтрагентОрганизации;
	
КонецФункции

Функция ПолучитьОрганизацииПродажМФП(ДатаДействия) Экспорт
	
	Политика = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолитикиМФП.Владелец,
	|	МАКСИМУМ(ПолитикиМФП.ПериодДействия) КАК ПериодДействия
	|ПОМЕСТИТЬ МаксПериоды
	|ИЗ
	|	Справочник.ПолитикиМФП КАК ПолитикиМФП
	|ГДЕ
	|	ПолитикиМФП.ПериодДействия <= &ПериодДействия
	|	И НЕ ПолитикиМФП.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	ПолитикиМФП.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПолитикиМФП.Ссылка
	|ПОМЕСТИТЬ ТаблицаПолитик
	|ИЗ
	|	Справочник.ПолитикиМФП КАК ПолитикиМФП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксПериоды КАК МаксПериоды
	|		ПО (МаксПериоды.ПериодДействия = ПолитикиМФП.ПериодДействия)
	|			И (МаксПериоды.Владелец = ПолитикиМФП.Владелец)
	|ГДЕ
	|	НЕ ПолитикиМФП.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка КАК Политика,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавец,
	|	СобственныеОрганизацииРазрешенаПокупка.ПроцентНаценки
	|ИЗ
	|	Справочник.ПолитикиМФП.СобственныеОрганизацииРазрешенаПокупка КАК СобственныеОрганизацииРазрешенаПокупка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПолитик КАК ТаблицаПолитик
	|		ПО (ТаблицаПолитик.Ссылка = СобственныеОрганизацииРазрешенаПокупка.Ссылка)
	|ГДЕ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаПокупкаУСобственныхОрганизаций";
	
	Запрос.УстановитьПараметр("ПериодДействия", НачалоДня(ДатаДействия));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ПолучитьПараметрыПолитикиМФПДляОрганизации(Организация, ДатаДействия) Экспорт
	
	Политика = ПолучитьПолитикуМФПДляОрганизации(Организация, ДатаДействия);
	
	Если Не ЗначениеЗаполнено(Политика) Тогда
		Возврат Неопределено;
	КонецЕсли;

	ПараметрыПолитики = Новый Структура;
	ПараметрыПолитики.Вставить("ПериодДействия", 							Политика.ПериодДействия);
	ПараметрыПолитики.Вставить("Контрагент", 								Политика.Контрагент);
	ПараметрыПолитики.Вставить("РазрешенаПродажаВнешнимКлиентам", 			Политика.РазрешенаПродажаВнешнимКлиентам);
	ПараметрыПолитики.Вставить("РазрешенаПродажаСобственнымОрганизациям", 	Политика.РазрешенаПродажаСобственнымОрганизациям);
	
	ОрганизацииПродажМФП = ПолучитьОрганизацииПродажМФП(ДатаДействия);
	
	ОрганизацииДляЗакупки = Новый ТаблицаЗначений;
	ОрганизацииДляЗакупки.Колонки.Добавить("Организация", 		Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ОрганизацииДляЗакупки.Колонки.Добавить("Приоритет", 		Новый ОписаниеТипов("Число"), Новый КвалификаторыЧисла(15,0));
	ОрганизацииДляЗакупки.Колонки.Добавить("ПроцентНаценки", 	Новый ОписаниеТипов("Число"), Новый КвалификаторыЧисла(15,2));
	ОрганизацииДляЗакупки.Колонки.Добавить("Политика", 			Новый ОписаниеТипов("СправочникСсылка.ПолитикиМФП"));
	
	Приоритет = 0;
	НовСтр 					= ОрганизацииДляЗакупки.Добавить();
	НовСтр.Приоритет 		= Приоритет;
	НовСтр.Организация 		= Организация;
	НовСтр.ПроцентНаценки 	= 0;
	НовСтр.Политика 		= Политика;
	
	ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП);
	
	ПараметрыПолитики.Вставить("ОрганизацииДляЗакупки", ОрганизацииДляЗакупки);
	
	Возврат ПараметрыПолитики;
	
КонецФункции

Процедура ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП)
	
	КоличествоСтрокДо = ОрганизацииДляЗакупки.Количество();
	
	ОрганизациииДляОбхода = ОрганизацииДляЗакупки.Скопировать();
	
	Приоритет = Приоритет + 1;
	Для каждого СтрокаТЗ Из ОрганизациииДляОбхода Цикл
		
		НайденныеСтроки = ОрганизацииПродажМФП.НайтиСтроки(Новый Структура("ОрганизацияПокупатель", СтрокаТЗ.Организация));
		
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если ОрганизацииДляЗакупки.Найти(НайденнаяСтрока.ОрганизацияПродавец, "Организация") = Неопределено Тогда
				НовСтр 					= ОрганизацииДляЗакупки.Добавить();
				НовСтр.Приоритет 		= Приоритет;
				НовСтр.Организация 		= НайденнаяСтрока.ОрганизацияПродавец;
				НовСтр.ПроцентНаценки 	= НайденнаяСтрока.ПроцентНаценки;
				НовСтр.Политика 		= НайденнаяСтрока.Политика;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	КоличествоСтрокПосле = ОрганизацииДляЗакупки.Количество();
	Если КоличествоСтрокПосле <> КоличествоСтрокДо Тогда
		ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП);
	КонецЕсли;
	
КонецПроцедуры

  
