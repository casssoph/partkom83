﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//Сохраним старые Значения
	СтруктураРеквизитов = Документы.АктРассмотренияВозврата.СтруктураРеквизитовДляКонтроляИстории();
	Если Не ЭтоНовый() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Ссылка);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("РеквизитыСсылкиПередЗаписью", СтруктураРеквизитов);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСтатусПроверкиБухгалтерией();
	
	//Составной тип
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Неопределено;
	КонецЕсли;
	
	//Качество по умолчанию
	КачествоНовый = Справочники.Качество.Новый;
	Для каждого СтрокаТабличнойЧасти Из Товары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.Качество) Тогда
			СтрокаТабличнойЧасти.Качество = КачествоНовый;
		КонецЕсли;
	КонецЦикла;
	
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары");
	
	УчитыватьНДС 		= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "УчитыватьНДС");
	СуммаВключаетНДС 	= УчитыватьНДС;
	
	ПроверкиПередЗаписью(Отказ, РежимЗаписи, РежимПроведения);	
	
КонецПроцедуры

Процедура ПроверкиПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если СтатусДокумента = Справочники.СтатусыДокументов.АРВ_Новый Тогда
			
			//Проверим что партии заполнены корректно
			ПроверитьЗаполнитьПартииВТабличнойЧасти(,,,Ложь);
			
		КонецЕсли;
		
		
	КонецЕсли;	
	
	
	
	
	
	
	
	
КонецПроцедуры

Функция ПроверитьЗаполнитьПартииВТабличнойЧасти(СообщатьОбОшибке = Истина, ТекстОшибки = "", ВызыватьИсключение = Истина, ЗаполнитьТЧ = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДокументПродажи) Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС +"Не указан документ продажи!";
		Если  ВызыватьИсключение Тогда
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли СообщатьОбОшибке Тогда
			Сообщить(ТекстОшибки);
		КонецЕсли;
		
		Возврат Ложь;
		
	КонецЕсли;
	
	БылиОшибки = Ложь;
	лТекстОшибки = "";
	
	ОстаткиПартийПоРТУ = ОстаткиПартийПоРТУ();
	
	ТаблицаРаспределения = Товары.Выгрузить().СкопироватьКолонки();
	
	Для каждого СтрокаРаспределить Из Товары Цикл
		
		Распределить = СтрокаРаспределить.Количество;
		
		СтрокиОстатков = ОстаткиПартийПоРТУ.НайтиСтроки(Новый структура("Номенклатура", СтрокаРаспределить.Номенклатура)); 
		
		НовыеСтроки = Новый Массив;
		МассивКоэф = Новый Массив;
		ОбщийОстатокПоСтроке = 0;
		Для каждого СтрокаОстатка Из СтрокиОстатков Цикл
			
			ОбщийОстатокПоСтроке = ОбщийОстатокПоСтроке + СтрокаОстатка.Количество;
			
			Распределено = Мин(Распределить, СтрокаОстатка.Количество);
			
			Если Распределено <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ТаблицаРаспределения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределить);
			НоваяСтрока.СтрокаПрихода 		= СтрокаОстатка.СтрокаПрихода;
			НоваяСтрока.СебестоимостьЦена 	= СтрокаОстатка.ЦенаСебестоимости;
			НоваяСтрока.Количество 	  		= Распределено;
			
			Распределить = Распределить - Распределено;
			СтрокаОстатка.Количество = СтрокаОстатка.Количество - Распределено;
			
			
			//Для распределения суммы компенсации
			НовыеСтроки.Добавить(НоваяСтрока);
			МассивКоэф.Добавить(НоваяСтрока.Количество);
			
		КонецЦикла;
		
		//Распределим сумму компенсации
		Если НовыеСтроки.Количество() > 0 Тогда
			
			СуммыКомпенсации = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СтрокаРаспределить.СуммаКомпенсации, МассивКоэф); 
			
			Если СуммыКомпенсации <> Неопределено Тогда
				Для каждого НоваяСтрока Из НовыеСтроки Цикл
					НоваяСтрока.СуммаКомпенсации = СуммыКомпенсации[НовыеСтроки.Найти(НоваяСтрока)];
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если Распределить > 0 Тогда
			
			лТекстОшибки = лТекстОшибки + "
			|
			| "+СтрокаРаспределить.Номенклатура+" (артикул: "+
						СтрокаРаспределить.Номенклатура.Артикул + 
						", изготовитель: "+СтрокаРаспределить.Номенклатура.Изготовитель+")"+"
			| К возврату: "+СтрокаРаспределить.Количество +"
			| Доступно для возврата: "+ОбщийОстатокПоСтроке +"
			| Превышение: "+Распределить;
						
			БылиОшибки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если БылиОшибки Тогда
		
		ТекстОшибки = ТекстОшибки +
		"
		|В реализации " + ДокументПродажи.Номер + " от " + ДокументПродажи.Дата + " недостаточно товаров для возврата: 
		| " + лТекстОшибки;
		
	КонецЕсли;
	
	Если БылиОшибки И СообщатьОбОшибке Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
	Если БылиОшибки И ВызыватьИсключение Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Не БылиОшибки Тогда
		
		Товары.Загрузить(ТаблицаРаспределения);
		
		Для каждого СтрокаТабличнойЧасти Из Товары Цикл

			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
			СтруктураДействий.Вставить("РассчитатьСуммуНДС", ЭтотОбъект);
			СтруктураДействий.Вставить("ПересчитатьСебестоимость");
			ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Не БылиОшибки;	
	
КонецФункции

Функция ЗаполнитьЦеныПоДокументуРеализации(СообщатьОбОшибке = Истина, ТекстОшибки = "", ВызыватьИсключение = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДокументПродажи) Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС +"Не указан документ продажи!";
		Если  ВызыватьИсключение Тогда
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли СообщатьОбОшибке Тогда
			Сообщить(ТекстОшибки);
		КонецЕсли;
		
		Возврат Ложь;
		
	КонецЕсли;
	
	БылиОшибки = Ложь;
	лТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслугТовары.Ссылка,
		|	РеализацияТоваровУслугТовары.Номенклатура,
		|	РеализацияТоваровУслугТовары.Количество,
		|	ВЫБОР
		|		КОГДА РеализацияТоваровУслугТовары.ЦенаСоСкидкой = 0
		|			ТОГДА РеализацияТоваровУслугТовары.Цена
		|		ИНАЧЕ РеализацияТоваровУслугТовары.ЦенаСоСкидкой
		|	КОНЕЦ КАК Цена,
		|	РеализацияТоваровУслугТовары.Сумма,
		|	РеализацияТоваровУслугТовары.СтавкаНДС,
		|	РеализацияТоваровУслугТовары.СуммаНДС
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|ГДЕ
		|	РеализацияТоваровУслугТовары.Ссылка = &ДокументПродажи";
	
	Запрос.УстановитьПараметр("ДокументПродажи", ДокументПродажи);
	
	ТоварыРТУ = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТабличнойЧасти Из Товары Цикл
		
		СтрокиРТУ = ТоварыРТУ.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТабличнойЧасти.Номенклатура));
		Если СтрокиРТУ.Количество() > 0 Тогда
			
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокиРТУ[0], "Цена");
			
			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("ПересчитатьЦенуПослеУценки");
			СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
			СтруктураДействий.Вставить("РассчитатьСуммуНДС", ЭтотОбъект);			
			ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
			
		Иначе
			
			лТекстОшибки = лТекстОшибки + "
			|
			| "+СтрокаТабличнойЧасти.Номенклатура+" (артикул: "+
			СтрокаТабличнойЧасти.Номенклатура.Артикул + 
			", изготовитель: "+СтрокаТабличнойЧасти.Номенклатура.Изготовитель+")";
			
			БылиОшибки = Истина;
		Конецесли;
		
	КонецЦикла;
	
	Если БылиОшибки Тогда
		
		ТекстОшибки = ТекстОшибки +
		"
		|Невозможно заполнить цены. В реализации " + ДокументПродажи.Номер + " от " + ДокументПродажи.Дата + " не найдены товары: 
		| " + лТекстОшибки;
		
	КонецЕсли;
	
	Если БылиОшибки И СообщатьОбОшибке Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
	Если БылиОшибки И ВызыватьИсключение Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецФункции

Функция ОстаткиПартийПоРТУ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	СУММА(АктРассмотренияВозвратаТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
		|ГДЕ
		|	АктРассмотренияВозвратаТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	АктРассмотренияВозвратаТовары.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПартииТоваров.Номенклатура,
		|	ПартииТоваров.СтрокаПрихода,
		|	СУММА(ПартииТоваров.Количество) КАК Количество,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ПартииТоваров.Количество = 0
		|				ТОГДА 0
		|			ИНАЧЕ ПартииТоваров.СуммаРубли / ПартииТоваров.Количество
		|		КОНЕЦ) КАК ЦенаСебестоимости
		|ПОМЕСТИТЬ СписанныеПартии
		|ИЗ
		|	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТовары КАК втТовары
		|		ПО (втТовары.Номенклатура = ПартииТоваров.Номенклатура)
		|ГДЕ
		|	ПартииТоваров.Регистратор = &ДокументПродажи
		|	И ПартииТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
		|	И ПартииТоваров.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	ПартииТоваров.Номенклатура,
		|	ПартииТоваров.СтрокаПрихода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписанныеПартии.Номенклатура,
		|	СписанныеПартии.СтрокаПрихода,
		|	СписанныеПартии.Количество
		|ПОМЕСТИТЬ ОстаткиПартий
		|ИЗ
		|	СписанныеПартии КАК СписанныеПартии
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	АктРассмотренияВозвратаТовары.СтрокаПрихода,
		|	-АктРассмотренияВозвратаТовары.Количество
		|ИЗ
		|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТовары КАК втТовары
		|		ПО (втТовары.Номенклатура = АктРассмотренияВозвратаТовары.Номенклатура)
		|ГДЕ
		|	АктРассмотренияВозвратаТовары.Ссылка.Дата < &Дата
		|	И АктРассмотренияВозвратаТовары.Ссылка.Проведен
		|	И НЕ АктРассмотренияВозвратаТовары.Ссылка = &Ссылка
		|	И АктРассмотренияВозвратаТовары.Ссылка.ДокументПродажи = &ДокументПродажи
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура,
		|	ВозвратТоваровОтПокупателяТовары.СтрокаПрихода,
		|	-ВозвратТоваровОтПокупателяТовары.Количество
		|ИЗ
		|	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТовары КАК втТовары
		|		ПО (втТовары.Номенклатура = ВозвратТоваровОтПокупателяТовары.Номенклатура)
		|ГДЕ
		|	ВозвратТоваровОтПокупателяТовары.Ссылка.Дата < &Дата
		|	И ВозвратТоваровОтПокупателяТовары.Ссылка.Проведен
		|	И ВозвратТоваровОтПокупателяТовары.Ссылка.ДокументОснование = &ДокументПродажи
		|	И ВозвратТоваровОтПокупателяТовары.Ссылка.АктРассмотренияВозврата = ЗНАЧЕНИЕ(Документ.АктРассмотренияВозврата.ПустаяСсылка)
		|	И НЕ ВозвратТоваровОтПокупателяТовары.СтрокаПрихода = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиПартий.Номенклатура,
		|	ОстаткиПартий.СтрокаПрихода,
		|	МАКСИМУМ(ЕСТЬNULL(СписанныеПартии.ЦенаСебестоимости, 0)) КАК ЦенаСебестоимости,
		|	СУММА(ОстаткиПартий.Количество) КАК Количество
		|ИЗ
		|	ОстаткиПартий КАК ОстаткиПартий
		|		ЛЕВОЕ СОЕДИНЕНИЕ СписанныеПартии КАК СписанныеПартии
		|		ПО ОстаткиПартий.Номенклатура = СписанныеПартии.Номенклатура
		|			И ОстаткиПартий.СтрокаПрихода = СписанныеПартии.СтрокаПрихода
		|ГДЕ
		|	НЕ ОстаткиПартий.СтрокаПрихода = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиПартий.Номенклатура,
		|	ОстаткиПартий.СтрокаПрихода
		|
		|ИМЕЮЩИЕ
		|	СУММА(ОстаткиПартий.Количество) > 0";
	
	//!!! Добавить вычитание количества по возвратам от покупателя без АРВ !!!
	
	Запрос.УстановитьПараметр("Дата", ?(Не ЗначениеЗаполнено(Дата), ТекущаяДата(), Дата));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументПродажи", ДокументПродажи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Процедура УстановитьСтатусПроверкиБухгалтерией()
	
	СтатусПроверкиБухгалтерией = Документы.АктРассмотренияВозврата.СтатусПроверкиБухгалтерией(СтатусПроверкиДокументовПокупателя, СтатусПроверкиДокументовПоставщика);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Изменение статуса нужно записывать всегда!!
	ОтразитьИзменениеСтатусаПриЗаписи();
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Документы.АктРассмотренияВозврата.АРВУникаленПоШтрихкоду(Ссылка) Тогда
		ВызватьИсключение "Штрихкод АРВ не уникален!";		
	КонецЕсли;
	
	//Отразить изменение реквизитов
	СохранитьВИсториюИзмененияПриЗаписи();
	
КонецПроцедуры

Процедура ОтразитьИзменениеСтатусаПриЗаписи() Экспорт
	
	Если ДополнительныеСвойства.РеквизитыСсылкиПередЗаписью.СтатусДокумента
			<> Ссылка.СтатусДокумента Тогда
			
		ПараметрыСобытия = РегистрыСведений.СобытияАктовРассмотренияВозврата.ИнициализироватьСтруктуруПараметровСобытия();
		ПараметрыСобытия.Описание = "Изменение статуса документа";
		ЗаполнитьЗначенияСвойств(ПараметрыСобытия, Ссылка);
		ПараметрыСобытия.ЭтоНовый = ДополнительныеСвойства.ЭтоНовый;
		ПараметрыСобытия.СтарыйСтатус = ДополнительныеСвойства.РеквизитыСсылкиПередЗаписью.СтатусДокумента;
		РегистрыСведений.СобытияАктовРассмотренияВозврата.ДобавитьСобытие(Ссылка, ПараметрыСобытия);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьВИсториюИзмененияПриЗаписи() Экспорт
	
	ОписаниеИзменения = "";
	ЭтоНовый = Ложь;
	Если ДополнительныеСвойства.Свойство("СохранитьВИсториюИзменения", ОписаниеИзменения) Тогда
		
		ПараметрыСобытия = РегистрыСведений.СобытияАктовРассмотренияВозврата.ИнициализироватьСтруктуруПараметровСобытия();
		ПараметрыСобытия.Описание = ОписаниеИзменения;
		ЗаполнитьЗначенияСвойств(ПараметрыСобытия, Ссылка);
		
		Если ОписаниеИзменения = "РучноеИзменениеРеквизита" Тогда //Сохраним запись в историю, если реквизиты меняли руками на форме
			
			СтруктураРеквизитов = Документы.АктРассмотренияВозврата.СтруктураРеквизитовДляКонтроляИстории();
			ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Ссылка);
			
			ПараметрыСобытия.Описание = ОписаниеИзмененныхРеквизитовДляИстории(ДополнительныеСвойства.РеквизитыСсылкиПередЗаписью, СтруктураРеквизитов, ПараметрыСобытия);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыСобытия.Описание) Тогда
			РегистрыСведений.СобытияАктовРассмотренияВозврата.ДобавитьСобытие(Ссылка, ПараметрыСобытия);
		КонецЕсли;
		
	ИначеЕсли ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый) И ЭтоНовый Тогда //Сохраним запись в историю для нового документа
		
		ПараметрыСобытия = РегистрыСведений.СобытияАктовРассмотренияВозврата.ИнициализироватьСтруктуруПараметровСобытия();
		ПараметрыСобытия.Описание = "Создание документа";
		ЗаполнитьЗначенияСвойств(ПараметрыСобытия, Ссылка);
		РегистрыСведений.СобытияАктовРассмотренияВозврата.ДобавитьСобытие(Ссылка, ПараметрыСобытия);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеИзмененныхРеквизитовДляИстории(РеквизитыСтарые, РеквизитыНовые, ПараметрыСобытия)
	
	Описание = "";	
	
	ИменаРеквизитов = Документы.АктРассмотренияВозврата.ИменаРеквизитовДляКонтроляИстории();

	Для каждого ЭлСписка Из ИменаРеквизитов Цикл
		
		Если НЕ РеквизитыСтарые[ЭлСписка.Значение] = РеквизитыНовые[ЭлСписка.Значение] Тогда
			
			Описание = Описание + ?(ЗначениеЗаполнено(Описание), Символы.ПС, "") + 
							"Изменен реквизит: """+ЭлСписка.Представление+""", новое значение: "+РеквизитыНовые[ЭлСписка.Значение];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Описание;
	
КонецФункции

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Организация");
	ПроверяемыеРеквизиты.Добавить("Контрагент");
	ПроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");
	ПроверяемыеРеквизиты.Добавить("Штрихкод");
	ПроверяемыеРеквизиты.Добавить("ПричинаВозврата");
	ПроверяемыеРеквизиты.Добавить("Товары.Номенклатура");
	ПроверяемыеРеквизиты.Добавить("Товары.Количество");
	ПроверяемыеРеквизиты.Добавить("Товары.СебестоимостьЦена");
	ПроверяемыеРеквизиты.Добавить("Товары.Себестоимость");
	ПроверяемыеРеквизиты.Добавить("Товары.СтрокаПрихода");
	
КонецПроцедуры
