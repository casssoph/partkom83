﻿
//Получение параметров политик МФП для списания партий
Функция ПолучитьПараметрыПолитикиМФПДляОрганизации(Организация, ДатаДействия, ВызыватьИсключение = Ложь) Экспорт
	
	Политика = ПолучитьПолитикуМФПДляОрганизации(Организация, ДатаДействия, ВызыватьИсключение);
	
	Если Не ЗначениеЗаполнено(Политика) Тогда
		Возврат Неопределено;
	КонецЕсли;

	ПараметрыПолитики = Новый Структура;
	ПараметрыПолитики.Вставить("ПериодДействия", 							Политика.ПериодДействия);
	ПараметрыПолитики.Вставить("Контрагент", 								Политика.Контрагент);
	ПараметрыПолитики.Вставить("РазрешенаПродажаВнешнимКлиентам", 			Политика.РазрешенаПродажаВнешнимКлиентам);
	ПараметрыПолитики.Вставить("РазрешенаЗакупкаУВнешнихПоставщиков", 		Политика.РазрешенаЗакупкаУВнешнихПоставщиков);
	ПараметрыПолитики.Вставить("РазрешенаПокупкаУСобственныхОрганизаций", 	Политика.РазрешенаПокупкаУСобственныхОрганизаций);
	ПараметрыПолитики.Вставить("РазрешенаЦепочкаЗакупок", 					Политика.РазрешенаЦепочкаЗакупок);
	//ПараметрыПолитики.Вставить("РазрешенВозврат", 							Политика.РазрешенВозврат);
	
	ОрганизацииПродажМФП = ПолучитьОрганизацииПродажМФП(ДатаДействия);
	
	ОрганизацииДляЗакупки = Новый ТаблицаЗначений;
	ОрганизацииДляЗакупки.Колонки.Добавить("Организация", 			Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ОрганизацииДляЗакупки.Колонки.Добавить("ДоговорКонтрагента", 	Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	ОрганизацииДляЗакупки.Колонки.Добавить("Приоритет", 			Новый ОписаниеТипов("Число"), Новый КвалификаторыЧисла(15,0));
	ОрганизацииДляЗакупки.Колонки.Добавить("ПроцентНаценки", 		Новый ОписаниеТипов("Число"), Новый КвалификаторыЧисла(15,2));
	ОрганизацииДляЗакупки.Колонки.Добавить("Политика", 				Новый ОписаниеТипов("СправочникСсылка.ПолитикиМФП"));
	
	МаксПриоритет = 9999;
	Если Не ПараметрыПолитики.РазрешенаЦепочкаЗакупок Тогда
		МаксПриоритет = 1;
	КонецЕсли;
	
	Приоритет = 0;
	НовСтр 					= ОрганизацииДляЗакупки.Добавить();
	НовСтр.Приоритет 		= Приоритет;
	НовСтр.Организация 		= Организация;
	НовСтр.ПроцентНаценки 	= 0;
	НовСтр.Политика 		= Политика;
	
	ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП, МаксПриоритет);
	
	ПараметрыПолитики.Вставить("ОрганизацииДляЗакупки", ОрганизацииДляЗакупки);
	
	Возврат ПараметрыПолитики;
	
КонецФункции

Процедура ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП, МаксПриоритет)
	
	КоличествоСтрокДо = ОрганизацииДляЗакупки.Количество();
	
	ОрганизациииДляОбхода = ОрганизацииДляЗакупки.Скопировать();
	
	Приоритет = Приоритет + 1;
	Для каждого СтрокаТЗ Из ОрганизациииДляОбхода Цикл
		
		НайденныеСтроки = ОрганизацииПродажМФП.НайтиСтроки(Новый Структура("ОрганизацияПокупатель", СтрокаТЗ.Организация));
		
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если ОрганизацииДляЗакупки.Найти(НайденнаяСтрока.ОрганизацияПродавец, "Организация") = Неопределено Тогда
				НовСтр 						= ОрганизацииДляЗакупки.Добавить();
				НовСтр.Приоритет 			= Приоритет;
				НовСтр.Организация 			= НайденнаяСтрока.ОрганизацияПродавец;
				НовСтр.ПроцентНаценки 		= НайденнаяСтрока.ПроцентНаценки;
				НовСтр.Политика 			= НайденнаяСтрока.Политика;
				НовСтр.ДоговорКонтрагента	= НайденнаяСтрока.ДоговорКонтрагента;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	КоличествоСтрокПосле = ОрганизацииДляЗакупки.Количество();
	Если КоличествоСтрокПосле <> КоличествоСтрокДо И Приоритет < МаксПриоритет Тогда
		ДобавитьОрганизацииЗакупкиРекурсивно(ОрганизацииДляЗакупки, Приоритет, ОрганизацииПродажМФП, МаксПриоритет);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОрганизацииПродажМФП(ДатаДействия, СпособПередачиТоваров = Неопределено) Экспорт
	
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
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаЦепочкаЗакупок КАК ПолитикаРазрешенаЦепочкаЗакупок,
	//|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенВозврат КАК ПолитикаРазрешенВозврат,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Контрагент КАК КонтрагентПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавец,
	|	СобственныеОрганизацииРазрешенаПокупка.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	СобственныеОрганизацииРазрешенаПокупка.ПроцентНаценки,
	|	СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров
	|ИЗ
	|	Справочник.ПолитикиМФП.СобственныеОрганизацииРазрешенаПокупка КАК СобственныеОрганизацииРазрешенаПокупка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПолитик КАК ТаблицаПолитик
	|		ПО (ТаблицаПолитик.Ссылка = СобственныеОрганизацииРазрешенаПокупка.Ссылка)
	|ГДЕ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаПокупкаУСобственныхОрганизаций
	|	И (СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров = &СпособПередачиТоваров
	|			ИЛИ &ВсеСпособыПередачи)";
	
	Запрос.УстановитьПараметр("ПериодДействия", 		НачалоДня(ДатаДействия));
	Запрос.УстановитьПараметр("СпособПередачиТоваров", 	СпособПередачиТоваров);
	Запрос.УстановитьПараметр("ВсеСпособыПередачи", 	Не ЗначениеЗаполнено(СпособПередачиТоваров));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

//ПРОДАЖИ
//Получение правил МФП для создания документов МФП
Функция ПравилаСозданияМФП(ДатаСоздания, СпособПередачиТоваров = Неопределено) Экспорт
	
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
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаЦепочкаЗакупок КАК ПолитикаРазрешенаЦепочкаЗакупок,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавецСписаниеПартий,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупательСписаниеПартий,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавец,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров,
	|	СобственныеОрганизацииРазрешенаПокупка.ДоговорКонтрагента,
	|	СобственныеОрганизацииРазрешенаПокупка.ДоговорКонтрагентаВозврат,
	|	СобственныеОрганизацииРазрешенаПокупка.ПроцентНаценки,
	|	0 КАК Порядок
	|ИЗ
	|	Справочник.ПолитикиМФП.СобственныеОрганизацииРазрешенаПокупка КАК СобственныеОрганизацииРазрешенаПокупка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПолитик КАК ТаблицаПолитик
	|		ПО (ТаблицаПолитик.Ссылка = СобственныеОрганизацииРазрешенаПокупка.Ссылка)
	|ГДЕ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаПокупкаУСобственныхОрганизаций
	|	И (СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров = &СпособПередачиТоваров
	|			ИЛИ &ВсеСпособыПередачи)";
	
	Запрос.УстановитьПараметр("ПериодДействия", НачалоДня(ДатаСоздания));	
	Запрос.УстановитьПараметр("СпособПередачиТоваров", 	СпособПередачиТоваров);
	Запрос.УстановитьПараметр("ВсеСпособыПередачи", 	Не ЗначениеЗаполнено(СпособПередачиТоваров));
	
	ТаблицаПрямыхПродаж = Запрос.Выполнить().Выгрузить();
	
	ПравилаСозданияМФП 	= ТаблицаПрямыхПродаж.Скопировать();

	Порядок = 1;
	ОбработатьТабРекурсивно(ПравилаСозданияМФП, Порядок);

	Возврат ПравилаСозданияМФП;	
	
КонецФункции

Процедура ОбработатьТабРекурсивно(ТаблицаМногошаговыхПродаж, Порядок)
	
	КолДо = ТаблицаМногошаговыхПродаж.Количество();
	
	Для каждого СтрокаТаблицы ИЗ ТаблицаМногошаговыхПродаж Цикл
		Если СтрокаТаблицы.ПолитикаРазрешенаЦепочкаЗакупок Тогда
			ОбработатьСтрокуТаблицы(СтрокаТаблицы.ОрганизацияПокупательСписаниеПартий, СтрокаТаблицы, ТаблицаМногошаговыхПродаж, Порядок);
		КонецЕсли;
	КонецЦикла;
	
	КолПосле = ТаблицаМногошаговыхПродаж.Количество();
	Если КолДо <> КолПосле Тогда
		ОбработатьТабРекурсивно(ТаблицаМногошаговыхПродаж, Порядок);
	КонецЕсли;
		
КонецПроцедуры

Функция ОбработатьСтрокуТаблицы(ПокупательПартии, СтрокаТаблицы, ТаблицаМногошаговыхПродаж,  Порядок)

	ТаблицаКОбработке = ТаблицаМногошаговыхПродаж.Скопировать(Новый Структура("ОрганизацияПокупательСписаниеПартий", СтрокаТаблицы.ОрганизацияПродавецСписаниеПартий));
	
	Для каждого СтрокаДляОбработки Из ТаблицаКОбработке Цикл
		
		ПродавецПартии = СтрокаДляОбработки.ОрганизацияПродавецСписаниеПартий;
		
		СтруктураСтрокиПравил 											= СтруктураСтрокиПравил();
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиПравил, СтрокаТаблицы);
		СтруктураСтрокиПравил.ОрганизацияПродавецСписаниеПартий 		= ПродавецПартии;
		СтруктураСтрокиПравил.ОрганизацияПокупательСписаниеПартий 		= ПокупательПартии;
		СтруктураСтрокиПравил.Порядок 									= Порядок;
		СтруктураСтрокиПравил.ПолитикаРазрешенаЦепочкаЗакупок 			= Ложь;

		Если ПроверитьДобавитьВТаблицу(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил) Тогда
			Порядок = Порядок+1;
		КонецЕсли;
		
		СтруктураСтрокиПравил 										= СтруктураСтрокиПравил();
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиПравил, СтрокаДляОбработки);
		СтруктураСтрокиПравил.ОрганизацияПродавецСписаниеПартий 	= ПродавецПартии;
		СтруктураСтрокиПравил.ОрганизацияПокупательСписаниеПартий 	= ПокупательПартии;
		СтруктураСтрокиПравил.Порядок 								= Порядок;
		Если ПроверитьДобавитьВТаблицу(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил) Тогда
			Порядок = Порядок+1;
		КонецЕсли;
		
	КонецЦикла;

КонецФункции

Функция СтруктураСтрокиПравил()
	
	СтруктураСтрокиПравил = Новый Структура("ОрганизацияПродавецСписаниеПартий, ОрганизацияПокупательСписаниеПартий, ОрганизацияПродавец, ОрганизацияПокупатель, ПроцентНаценки, Политика, Порядок, СпособПередачиТоваров, ДоговорКонтрагента, ДоговорКонтрагентаВозврат, ПолитикаРазрешенаЦепочкаЗакупок");
	
	Возврат СтруктураСтрокиПравил;
	
КонецФункции

Функция ПроверитьДобавитьВТаблицу(вхТаблица, ДобавляемыыеДанные, ПоляОтбора = "")
	
	Если ПоляОтбора = "" Тогда
		ПоляОтбора = "ОрганизацияПродавецСписаниеПартий, ОрганизацияПокупательСписаниеПартий, ОрганизацияПродавец, ОрганизацияПокупатель";
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура(ПоляОтбора);
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, ДобавляемыыеДанные);
	
	НайденныеСтроки = вхТаблица.НайтиСтроки(СтруктураОтбора);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(вхТаблица.Добавить(), ДобавляемыыеДанные);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


//ВОЗВРАТЫ
//Получение правил МФП для создания документов возвратов МФП
Функция ПравилаСозданияВозвратовМФП(ДатаСоздания) Экспорт
	
	ПравилаСозданияМФП =  ПравилаСозданияМФП(ДатаСоздания);
	ПравилаСозданияВозвратовМФП = ПравилаСозданияМФП.СкопироватьКолонки();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПравилаСозданияМФП", ПравилаСозданияМФП);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаСозданияМФП.Политика,
	|	ПравилаСозданияМФП.ПолитикаРазрешенаЦепочкаЗакупок,
	|	ПравилаСозданияМФП.ОрганизацияПродавецСписаниеПартий,
	|	ПравилаСозданияМФП.ОрганизацияПокупательСписаниеПартий,
	|	ПравилаСозданияМФП.ОрганизацияПродавец,
	|	ПравилаСозданияМФП.ОрганизацияПокупатель,
	|	ПравилаСозданияМФП.СпособПередачиТоваров,
	|	ПравилаСозданияМФП.ДоговорКонтрагента,
	|	ПравилаСозданияМФП.ДоговорКонтрагентаВозврат,
	|	ПравилаСозданияМФП.ПроцентНаценки,
	|	ПравилаСозданияМФП.Порядок
	|ПОМЕСТИТЬ ПравилаСозданияМФП
	|ИЗ
	|	&ПравилаСозданияМФП КАК ПравилаСозданияМФП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПравилаСозданияМФП.Политика,
	|	ПравилаСозданияМФП.ПолитикаРазрешенаЦепочкаЗакупок,
	|	ПравилаСозданияМФП.ОрганизацияПродавецСписаниеПартий КАК ОрганизацияПродавецСписаниеПартий,
	|	ПравилаСозданияМФП.ОрганизацияПокупательСписаниеПартий КАК ОрганизацияПокупательСписаниеПартий,
	|	ПравилаСозданияМФП.ОрганизацияПродавец,
	|	ПравилаСозданияМФП.ОрганизацияПокупатель,
	|	ПравилаСозданияМФП.СпособПередачиТоваров,
	|	ПравилаСозданияМФП.ДоговорКонтрагента,
	|	ПравилаСозданияМФП.ДоговорКонтрагентаВозврат,
	|	ПравилаСозданияМФП.ПроцентНаценки,
	|	ПравилаСозданияМФП.Порядок
	|ИЗ
	|	ПравилаСозданияМФП КАК ПравилаСозданияМФП
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПродавецСписаниеПартий,
	|	ОрганизацияПокупательСписаниеПартий,
	|	ПравилаСозданияМФП.Порядок
	|ИТОГИ ПО
	|	ОрганизацияПродавецСписаниеПартий,
	|	ОрганизацияПокупательСписаниеПартий";
	
	Результат = Запрос.Выполнить();
	
	ВыборкаОрганизацияПродавецСписаниеПартий = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаОрганизацияПродавецСписаниеПартий.Следующий() Цикл
		
		ОрганизацияПокупательСписаниеПартий = ВыборкаОрганизацияПродавецСписаниеПартий.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ОрганизацияПокупательСписаниеПартий.Следующий() Цикл
			
			Выборка = ОрганизацияПокупательСписаниеПартий.Выбрать();
			
			Пропустить = Ложь;
			Пока Выборка.Следующий() Цикл
				
				Если Выборка.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.Покупка Тогда
					Пропустить = Истина;
				КонецЕсли;
				
				Если Пропустить Тогда
					Продолжить;
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(ПравилаСозданияВозвратовМФП.Добавить(), Выборка);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ПравилаСозданияВозвратовМФП;
	
КонецФункции


//Прочее
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

Функция ПолучитьПолитикуМФПДляОрганизации(Организация, ДатаДействия, ВызыватьИсключение = Ложь) Экспорт
	
	Политика = Неопределено;
	
	//Если организация не работет, вызовем исключение
	ОрганизацияЗакрыта = Справочники.Организации.ОрганизацияЗакрыта(Организация, ДатаДействия, ВызыватьИсключение); 
		
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
	
	Если Политика = Неопределено И ВызыватьИсключение Тогда
		ТекстОшибки = "Не задана политика МФП для организации """+Организация+""" на "+Формат(ДатаДействия,"ДФ=dd.MM.yyyy")+"!";
		ВызватьИсключение ТекстОшибки;
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

Функция ОрганизацияКонтрагента(Контрагент, ДатаДействия) Экспорт
	
	ОрганизацияКонтрагента = Неопределено;
	
	ОрганизацииПродажМФП = ПолучитьОрганизацииПродажМФП(ДатаДействия);	
	
	НайденныеСтроки = ОрганизацииПродажМФП.НайтиСтроки(Новый Структура("КонтрагентПокупатель", Контрагент));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		ОрганизацияКонтрагента = НайденныеСтроки[0].ОрганизацияПокупатель;
	КонецЕсли;
	
	Возврат ОрганизацияКонтрагента;
	
КонецФункции

Функция РазрешенныеПокупателиДляОрганизацииПродавца(Организация, ДатаДействия) Экспорт
	
	ПравилаСозданияМФП = ПравилаСозданияМФП(ДатаДействия);
	
	ТаблицаПоПродавцу = ПравилаСозданияМФП.Скопировать(Новый Структура("ОрганизацияПродавецСписаниеПартий", Организация));
	
	ТаблицаПоПродавцу.Свернуть("ОрганизацияПокупательСписаниеПартий");
	
	Возврат ТаблицаПоПродавцу.ВыгрузитьКолонку("ОрганизацияПокупательСписаниеПартий");
	
КонецФункции

Функция СобственыеКонтрагенты(ДатаДействия) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериодДействия", ДатаДействия);
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
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПолитикиМФП.Контрагент
	|ИЗ
	|	Справочник.ПолитикиМФП КАК ПолитикиМФП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксПериоды КАК МаксПериоды
	|		ПО (МаксПериоды.ПериодДействия = ПолитикиМФП.ПериодДействия)
	|			И (МаксПериоды.Владелец = ПолитикиМФП.Владелец)
	|ГДЕ
	|	НЕ ПолитикиМФП.ПометкаУдаления";
	
	Контрагенты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
	
	Возврат Контрагенты;	
	
КонецФункции

Функция СобственныеОрганизации(ДатаДействия) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериодДействия", ДатаДействия);
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
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПолитикиМФП.Владелец КАК Организация
	|ИЗ
	|	Справочник.ПолитикиМФП КАК ПолитикиМФП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксПериоды КАК МаксПериоды
	|		ПО (МаксПериоды.ПериодДействия = ПолитикиМФП.ПериодДействия)
	|			И (МаксПериоды.Владелец = ПолитикиМФП.Владелец)
	|ГДЕ
	|	НЕ ПолитикиМФП.ПометкаУдаления";
	
	СобственныеОрганизации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
	
	Возврат СобственныеОрганизации;	
	
КонецФункции

//Не Используются
Функция устарела_ПравилаСозданияМФП(ДатаСоздания, СпособПередачиТоваров = Неопределено) Экспорт
	
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
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавецСписаниеПартий,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупательСписаниеПартий,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавец,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров,
	|	СобственныеОрганизацииРазрешенаПокупка.ДоговорКонтрагента,
	|	СобственныеОрганизацииРазрешенаПокупка.ПроцентНаценки,
	|	0 КАК Порядок
	|ИЗ
	|	Справочник.ПолитикиМФП.СобственныеОрганизацииРазрешенаПокупка КАК СобственныеОрганизацииРазрешенаПокупка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПолитик КАК ТаблицаПолитик
	|		ПО (ТаблицаПолитик.Ссылка = СобственныеОрганизацииРазрешенаПокупка.Ссылка)
	|ГДЕ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаПокупкаУСобственныхОрганизаций
	|	И (СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров = &СпособПередачиТоваров
	|			ИЛИ &ВсеСпособыПередачи)";
	
	Запрос.УстановитьПараметр("ПериодДействия", НачалоДня(ДатаСоздания));	
	Запрос.УстановитьПараметр("СпособПередачиТоваров", 	СпособПередачиТоваров);
	Запрос.УстановитьПараметр("ВсеСпособыПередачи", 	Не ЗначениеЗаполнено(СпособПередачиТоваров));
	
	ТаблицаПрямыхПродаж = Запрос.Выполнить().Выгрузить();
	
	ПравилаСозданияМФП 					= ТаблицаПрямыхПродаж.Скопировать();
	ТаблицаМногошаговыхПродаж 			= ТаблицаПрямыхПродаж.СкопироватьКолонки();
	ТаблицаДобавленныхНаЭтапеИтерации 	= ТаблицаПрямыхПродаж.СкопироватьКолонки();
	
	Для каждого СтрокаТаблицы ИЗ ТаблицаПрямыхПродаж Цикл 
		НомерИтерации = 1;
		устарела_ОбработатьРекурсивно(СтрокаТаблицы.ОрганизацияПокупательСписаниеПартий, СтрокаТаблицы, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, ТаблицаДобавленныхНаЭтапеИтерации, НомерИтерации);
		ТаблицаДобавленныхНаЭтапеИтерации.Очистить();
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ТаблицаМногошаговыхПродаж Цикл
		
		СтруктураСтрокиПравил = СтруктураСтрокиПравил();
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиПравил, СтрокаТаблицы);
		
		СтруктураОтбора = Новый Структура("ОрганизацияПродавецСписаниеПартий, ОрганизацияПокупательСписаниеПартий");
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТаблицы);
		
		НайденныеСтроки = ТаблицаПрямыхПродаж.НайтиСтроки(СтруктураОтбора);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			ПроверитьДобавитьВТаблицу(ПравилаСозданияМФП, СтруктураСтрокиПравил);
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат ПравилаСозданияМФП;	
	
КонецФункции

Функция устарела_ОбработатьРекурсивно(ПокупательПартии, СтрокаТаблицы, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, ТаблицаДобавленныхНаЭтапеИтерации, НомерИтерации)
	
	ТаблицаКОбработке = ТаблицаПрямыхПродаж.Скопировать(Новый Структура("ОрганизацияПокупательСписаниеПартий", СтрокаТаблицы.ОрганизацияПродавецСписаниеПартий));
	
	Порядок = 1;
	Для каждого СтрокаДляОбработки Из ТаблицаКОбработке Цикл
		
		ПродавецПартии = СтрокаДляОбработки.ОрганизацияПродавецСписаниеПартий;
		
		//Добавим строки прошлых итераций
		//ТаблицаДобавленныхНаЭтапеИтерацииДобавить = ТаблицаДобавленныхНаЭтапеИтерации.Скопировать(Новый Структура("ОрганизацияПокупательСписаниеПартий", ПокупательПартии));
		Для каждого СтрокаДобавить Из ТаблицаДобавленныхНаЭтапеИтерации Цикл
			
			СтруктураСтрокиПравил = СтруктураСтрокиПравил();
			ЗаполнитьЗначенияСвойств(СтруктураСтрокиПравил, СтрокаДобавить);
			СтруктураСтрокиПравил.ОрганизацияПродавецСписаниеПартий = ПродавецПартии;
			СтруктураСтрокиПравил.Порядок = Порядок;
			ПроверитьДобавитьВТаблицу(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил);
			
			Порядок = Порядок+1;
		КонецЦикла;
		
		Если НомерИтерации = 1 Тогда
			
			СтруктураСтрокиПравил 											= СтруктураСтрокиПравил();
			СтруктураСтрокиПравил.ОрганизацияПродавецСписаниеПартий 		= ПродавецПартии;
			СтруктураСтрокиПравил.ОрганизацияПокупательСписаниеПартий 		= ПокупательПартии;
			СтруктураСтрокиПравил.ОрганизацияПродавец 						= СтрокаТаблицы.ОрганизацияПродавец;
			СтруктураСтрокиПравил.ОрганизацияПокупатель 					= СтрокаТаблицы.ОрганизацияПокупатель;
			СтруктураСтрокиПравил.ПроцентНаценки 							= СтрокаТаблицы.ПроцентНаценки;
			СтруктураСтрокиПравил.Политика 									= СтрокаТаблицы.Политика;
			СтруктураСтрокиПравил.СпособПередачиТоваров 					= СтрокаТаблицы.СпособПередачиТоваров;
			СтруктураСтрокиПравил.ДоговорКонтрагента 						= СтрокаТаблицы.ДоговорКонтрагента;
			СтруктураСтрокиПравил.Порядок 									= Порядок;
			ПроверитьДобавитьВТаблицу(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил);
			
			//Запишем в добавленные
			ПроверитьДобавитьВТаблицу(ТаблицаДобавленныхНаЭтапеИтерации, СтруктураСтрокиПравил);
			
			Порядок = Порядок+1;
		КонецЕсли;
		
		СтруктураСтрокиПравил 										= СтруктураСтрокиПравил();
		СтруктураСтрокиПравил.ОрганизацияПродавецСписаниеПартий 	= ПродавецПартии;
		СтруктураСтрокиПравил.ОрганизацияПокупательСписаниеПартий 	= ПокупательПартии;
		СтруктураСтрокиПравил.ОрганизацияПродавец 					= СтрокаДляОбработки.ОрганизацияПродавец;
		СтруктураСтрокиПравил.ОрганизацияПокупатель 				= СтрокаДляОбработки.ОрганизацияПокупатель;
		СтруктураСтрокиПравил.ПроцентНаценки 						= СтрокаДляОбработки.ПроцентНаценки;
		СтруктураСтрокиПравил.Политика 								= СтрокаДляОбработки.Политика;
		СтруктураСтрокиПравил.СпособПередачиТоваров 				= СтрокаДляОбработки.СпособПередачиТоваров;
		СтруктураСтрокиПравил.ДоговорКонтрагента 					= СтрокаДляОбработки.ДоговорКонтрагента;
		СтруктураСтрокиПравил.Порядок 								= Порядок;
		ПроверитьДобавитьВТаблицу(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил);
		
		//Запишем в добавленные
		//ПроверитьДобавитьВТаблицу(ТаблицаДобавленныхНаЭтапеИтерации, СтруктураСтрокиПравил);
		
		Порядок = Порядок+1;

		НомерИтерации = НомерИтерации+1;
		
		устарела_ОбработатьРекурсивно(ПокупательПартии, СтрокаДляОбработки, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, ТаблицаДобавленныхНаЭтапеИтерации, НомерИтерации);
		
	КонецЦикла;
	//	ТаблицаДобавленныхНаЭтапеИтерации.Очистить();
КонецФункции


Функция устарела_ПравилаСозданияВозвратовМФП(ДатаСоздания) Экспорт
	
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
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПолучатель,
	|	СобственныеОрганизацииРазрешенаПокупка.Организация КАК ОрганизацияПродавец,
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.Владелец КАК ОрганизацияПокупатель,
	|	СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров,
	|	СобственныеОрганизацииРазрешенаПокупка.ДоговорКонтрагента,
	|	СобственныеОрганизацииРазрешенаПокупка.ПроцентНаценки,
	|	0 КАК Порядок
	|ИЗ
	|	Справочник.ПолитикиМФП.СобственныеОрганизацииРазрешенаПокупка КАК СобственныеОрганизацииРазрешенаПокупка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПолитик КАК ТаблицаПолитик
	|		ПО (ТаблицаПолитик.Ссылка = СобственныеОрганизацииРазрешенаПокупка.Ссылка)
	|ГДЕ
	|	СобственныеОрганизацииРазрешенаПокупка.Ссылка.РазрешенаПокупкаУСобственныхОрганизаций
	|	И СобственныеОрганизацииРазрешенаПокупка.СпособПередачиТоваров = &СпособПередачиТоваров";
	
	Запрос.УстановитьПараметр("ПериодДействия", НачалоДня(ДатаСоздания));	
	Запрос.УстановитьПараметр("СпособПередачиТоваров", Перечисления.СпособыПередачиТоваров.ПокупкаВозврат);	
	
	ТаблицаПрямыхПродаж = Запрос.Выполнить().Выгрузить();
	
	ПравилаСозданияМФП 					= ТаблицаПрямыхПродаж.Скопировать();
	ТаблицаМногошаговыхПродаж 			= ТаблицаПрямыхПродаж.СкопироватьКолонки();
	
	Для каждого СтрокаТаблицы ИЗ ТаблицаПрямыхПродаж Цикл 
		НомерИтерации = 1;
		Порядок = 1;
		Отказ = Ложь;
		устарела_ОбработатьРекурсивноВозвраты(СтрокаТаблицы.ОрганизацияПолучатель, СтрокаТаблицы, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, НомерИтерации, Порядок, Отказ);
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ТаблицаМногошаговыхПродаж Цикл
		
		СтруктураСтрокиПравил = устарела_СтруктураСтрокиПравилВозвраты();
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиПравил, СтрокаТаблицы);
		устарела_ПроверитьДобавитьВТаблицуВозвраты(ПравилаСозданияМФП, СтруктураСтрокиПравил, Отказ);
		
	КонецЦикла;
		
	Возврат ПравилаСозданияМФП;	
	
КонецФункции

Процедура устарела_ОбработатьРекурсивноВозвраты(ПокупательПартии, СтрокаТаблицы, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, НомерИтерации, Порядок, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКОбработке = ТаблицаПрямыхПродаж.Скопировать(Новый Структура("ОрганизацияПокупатель", СтрокаТаблицы.ОрганизацияПродавец));
	
	Для каждого СтрокаДляОбработки Из ТаблицаКОбработке Цикл
		
		ПродавецПартии = СтрокаДляОбработки.ОрганизацияПродавец;
		
		Если НомерИтерации = 1 Тогда
			
			СтруктураСтрокиПравил 											= устарела_СтруктураСтрокиПравилВозвраты();
			СтруктураСтрокиПравил.ОрганизацияПолучатель				 		= ПокупательПартии;
			СтруктураСтрокиПравил.ОрганизацияПродавец 						= СтрокаТаблицы.ОрганизацияПродавец;
			СтруктураСтрокиПравил.ОрганизацияПокупатель 					= СтрокаТаблицы.ОрганизацияПокупатель;
			СтруктураСтрокиПравил.ПроцентНаценки 							= СтрокаТаблицы.ПроцентНаценки;
			СтруктураСтрокиПравил.Политика 									= СтрокаТаблицы.Политика;
			СтруктураСтрокиПравил.СпособПередачиТоваров 					= СтрокаТаблицы.СпособПередачиТоваров;
			СтруктураСтрокиПравил.ДоговорКонтрагента 						= СтрокаТаблицы.ДоговорКонтрагента;
			СтруктураСтрокиПравил.Порядок 									= Порядок;
			устарела_ПроверитьДобавитьВТаблицуВозвраты(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил, Отказ);
			
			Порядок = Порядок + 1;
		КонецЕсли;
		
		СтруктураСтрокиПравил 										= устарела_СтруктураСтрокиПравилВозвраты();
		СтруктураСтрокиПравил.ОрганизацияПолучатель				 	= ПокупательПартии;
		СтруктураСтрокиПравил.ОрганизацияПродавец 					= СтрокаДляОбработки.ОрганизацияПродавец;
		СтруктураСтрокиПравил.ОрганизацияПокупатель 				= СтрокаДляОбработки.ОрганизацияПокупатель;
		СтруктураСтрокиПравил.ПроцентНаценки 						= СтрокаДляОбработки.ПроцентНаценки;
		СтруктураСтрокиПравил.Политика 								= СтрокаДляОбработки.Политика;
		СтруктураСтрокиПравил.СпособПередачиТоваров 				= СтрокаДляОбработки.СпособПередачиТоваров;
		СтруктураСтрокиПравил.ДоговорКонтрагента 					= СтрокаДляОбработки.ДоговорКонтрагента;
		СтруктураСтрокиПравил.Порядок 								= Порядок;
		устарела_ПроверитьДобавитьВТаблицуВозвраты(ТаблицаМногошаговыхПродаж, СтруктураСтрокиПравил, Отказ);
		
		Порядок = Порядок + 1;

		НомерИтерации = НомерИтерации + 1;
		
		устарела_ОбработатьРекурсивноВозвраты(ПокупательПартии, СтрокаДляОбработки, ТаблицаПрямыхПродаж, ТаблицаМногошаговыхПродаж, НомерИтерации, Порядок, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция устарела_СтруктураСтрокиПравилВозвраты()
	
	СтруктураСтрокиПравил = Новый Структура("ОрганизацияПолучатель, ОрганизацияПродавец, ОрганизацияПокупатель, ПроцентНаценки, Политика, Порядок, СпособПередачиТоваров, ДоговорКонтрагента");
	
	Возврат СтруктураСтрокиПравил;
	
КонецФункции

Процедура устарела_ПроверитьДобавитьВТаблицуВозвраты(вхТаблица, ДобавляемыыеДанные, Отказ)
	
	Если НЕ ДобавляемыыеДанные.СпособПередачиТоваров = Перечисления.СпособыПередачиТоваров.ПокупкаВозврат Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	СтруктураОтбора = Новый Структура("ОрганизацияПолучатель, ОрганизацияПродавец, ОрганизацияПокупатель");
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, ДобавляемыыеДанные);
	
	НайденныеСтроки = вхТаблица.НайтиСтроки(СтруктураОтбора);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(вхТаблица.Добавить(), ДобавляемыыеДанные);
	ИначеЕсли НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].Порядок = ДобавляемыыеДанные.Порядок;
	КонецЕсли;
	
КонецПроцедуры

