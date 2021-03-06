﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт 
	СоздатьПеремещения();
	//СоздатьРеализации();
КонецПроцедуры

Процедура СоздатьПеремещения()
	
	Перем Документ, Запрос, КолонкиСвертки, НоваяСтрока, Отбор, Результат, СверТаблица, СтрокаТовары, СтрокаТЧ, Строки, Таблица;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РезервыТоваровОстатки.Номенклатура,
	               |	РезервыТоваровОстатки.Склад КАК СкладОтправитель,
	               |	РезервыТоваровОстатки.СтрокаЗаявки.МаршрутДоставки.Склад КАК СкладПолучатель,
	               |	РезервыТоваровОстатки.КоличествоОстаток КАК Количество,
	               |	РезервыТоваровОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	               |	РезервыТоваровОстатки.Качество,
	               |	РезервыТоваровОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	               |	РезервыТоваровОстатки.СтрокаЗаявки
	               |ИЗ
	               |	РегистрНакопления.РезервыТоваров.Остатки(
	               |			,
	               |			Склад.ОбменСTopLog
	               |				И СтрокаЗаявки.МаршрутДоставки.Склад.ФизическийСклад.АвтоматическоеПеремещение
	               |				И СтрокаЗаявки.МаршрутДоставки.Склад.ОбменСTopLog
	               |				И СтрокаЗаявки.Заявка.ИсточникЗаявки = &ИсточникЗаявки
	               |				И (СтрокаЗаявки.ПрайсПоставщика.Склад ЕСТЬ NULL
	               |					ИЛИ СтрокаЗаявки.ПрайсПоставщика.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	               |				И Склад.ФизическийСклад <> СтрокаЗаявки.МаршрутДоставки.Склад.ФизическийСклад) КАК РезервыТоваровОстатки";
	Запрос.УстановитьПараметр("ИсточникЗаявки", Перечисления.ИсточникиЗаявок.СайтРозница);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый); 
		Результат = Запрос.Выполнить();
	ЗафиксироватьТранзакцию();
	
	Таблица = Результат.Выгрузить();
	
	КолонкиСвертки = "СкладОтправитель,СкладПолучатель";
	СверТаблица = Таблица.Скопировать(, КолонкиСвертки);
	СверТаблица.Свернуть(КолонкиСвертки);
	
	Для Каждого СтрокаТЧ Из СверТаблица Цикл 
		Документ = Документы.ПеремещениеТоваров.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(Документ, СтрокаТЧ, КолонкиСвертки);
		Отбор = Новый Структура(КолонкиСвертки);
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаТЧ);
		Строки = Таблица.НайтиСтроки(Отбор); 
		Для Каждого СтрокаТовары Из Строки Цикл 
			НоваяСтрока = Документ.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
		КонецЦикла;
		Попытка
			ПодобратьПартии(Документ);
			
			Документ.Дата = ТекущаяДата();
			Документ.ДополнительныеСвойства.Вставить("ОперативноеПроведение", Истина);
			
			Документ.ВидОперации = Перечисления.ВидыОперацийПеремещенияТоваров.СвободноеПеремещение;
			Документ.СкладПолучатель = Документ.СкладПолучатель.СкладТоварВПути;
			Документ.ФилиалОтправитель = Документ.СкладОтправитель.Филиал;
			Документ.ФилиалПолучатель = Документ.СкладПолучатель.Филиал;
			Документ.СтатусДокумента = Справочники.СтатусыДокументов.ПеремещениеТоваровПоступил;
			Документ.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			Сообщить(ОписаниеОшибки);
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Процедура ПодобратьПартии(Документ)
	
	Товары = Документ.Товары.Выгрузить(, "Номенклатура,Качество");
	Товары.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	Товары.ЗаполнитьЗначения(Документ.СкладОтправитель, "Склад");
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	Товары.Номенклатура,
	                |	Товары.Склад,
	                |	Товары.Качество
	                |ПОМЕСТИТЬ Товары
	                |ИЗ
	                |	 &Товары КАК Товары
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	ПартииТоваровОстатки.Номенклатура,
	                |	ПартииТоваровОстатки.Качество,
	                |	ПартииТоваровОстатки.Организация,
	                |	ПартииТоваровОстатки.КоличествоОстаток КАК Количество,
	                |	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка.Владелец КАК Поставщик
	                |ИЗ
	                |	РегистрНакопления.ПартииТоваров.Остатки(
	                |			,
	                |			(Номенклатура, Склад, Качество) В
	                |				(ВЫБРАТЬ
	                |					Товары.Номенклатура,
	                |					Товары.Склад,
	                |					Товары.Качество
	                |				ИЗ
	                |					Товары)) КАК ПартииТоваровОстатки";
	
	Запрос.УстановитьПараметр("Товары", Товары);
	
	Товары = Документ.Товары.Выгрузить();
	Документ.Товары.Очистить();
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		Результат = Запрос.Выполнить();
	ЗафиксироватьТранзакцию();
	
	ОстаткиПартий = Результат.Выгрузить();
	
	КолонкиРаспределения = "Номенклатура,Качество";
	Если Документ.СкладОтправитель.СкладVMI Тогда 
		КолонкиРаспределения = КолонкиРаспределения + ",Поставщик";
	КонецЕсли;
	
	Для Каждого СтрокаТовары Из Товары Цикл 
		Отбор = Новый Структура(КолонкиРаспределения);
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаТовары);
		
		Если Документ.СкладОтправитель.СкладVMI Тогда
			Отбор.Поставщик = СтрокаТовары.СтрокаЗаявки.Поставщик;
		КонецЕсли;
		
		Строки = ОстаткиПартий.НайтиСтроки(Отбор);
		Индекс = 0;
		КоличествоРаспределить = СтрокаТовары.Количество;
		
		Пока КоличествоРаспределить > 0 И Индекс < Строки.Количество() Цикл 
			СтрокаОст = Строки.Получить(Индекс);
			СписываемоеКоличество = Мин(КоличествоРаспределить, СтрокаОст.Количество);
			Если СписываемоеКоличество > 0 Тогда 
				НоваяСтрока = Документ.Товары.Добавить();                       
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
				НоваяСтрока.Количество = СписываемоеКоличество;
				НоваяСтрока.КоличествоПлан = НоваяСтрока.Количество;
				НоваяСтрока.Организация = СтрокаОст.Организация;
				
				КоличествоРаспределить = КоличествоРаспределить - СписываемоеКоличество;
				СтрокаОст.Количество = СтрокаОст.Количество - СписываемоеКоличество;
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;
	КонецЦикла;
	ВремТаблица = Документ.Товары.Выгрузить(, "Организация,Количество");
	ВремТаблица.Свернуть("Организация", "Количество");
	ВремТаблица.Сортировать("Количество Убыв");
	Документ.Организация = ВремТаблица.Получить(0).Организация;
	
	Строки = Документ.Товары.НайтиСтроки(Новый Структура("Организация", Документ.Организация));
	Для Каждого СтрокаТовары Из Строки Цикл 
		СтрокаТовары.Организация = Неопределено;
	КонецЦикла;
КонецПроцедуры

