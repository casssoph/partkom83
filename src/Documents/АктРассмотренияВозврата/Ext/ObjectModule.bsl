﻿
#Область События

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
	
	//Поставщик
	Если Не ЗначениеЗаполнено(Поставщик) И ЗначениеЗаполнено(Ссылка) Тогда
		Поставщик = Документы.АктРассмотренияВозврата.ПоставщикПоДаннымПартий(Ссылка);
	КонецЕсли;
	
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары");
	
	УчитыватьНДС 		= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "УчитыватьНДС");
	СуммаВключаетНДС 	= УчитыватьНДС;
	
	УстановитьНовыйШтрихкод();
	
	ПроверкиПередЗаписью(Отказ, РежимЗаписи, РежимПроведения);	
	
КонецПроцедуры

Процедура УстановитьНовыйШтрихкод()
	
	//Устанавливаем штриход, если АРВ вводят руками. 
	//если АРВ приходит с сайта, то штрихкод уже должен быть заполнен 
	Если Не ЗначениеЗаполнено(Штрихкод) Тогда
		
		ПрефиксШК = Документы.АктРассмотренияВозврата.ПрефиксШтрихкодаДляРучногоСозданияАРВ();
		
		ДлинаШКСПрефиксом = Метаданные.Документы.АктРассмотренияВозврата.Реквизиты.Штрихкод.Тип.КвалификаторыСтроки.Длина;
		
		НомерЧисло = 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
		|    ПОДСТРОКА(Документ.Штрихкод, &НачальныйСимволЧисла, &КонечныйСимволЧисла) КАК Штрихкод
		|ИЗ
		|    Документ.АктРассмотренияВозврата КАК Документ
		|ГДЕ
		|    ПОДСТРОКА(Документ.Штрихкод, 1, 2) = &Префикс
		|    И Документ.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ГОД) И КОНЕЦПЕРИОДА(&Дата, ГОД)
		|    И НЕ ПОДСТРОКА(Документ.Штрихкод, &НачальныйСимволЧисла, &КонечныйСимволЧисла) ПОДОБНО ""%[^0-9]%""
		|
		|УПОРЯДОЧИТЬ ПО
		|    Штрихкод УБЫВ";
		
		Запрос.УстановитьПараметр("Префикс",ПрефиксШК);
		Запрос.УстановитьПараметр("НачальныйСимволЧисла",СтрДлина(ПрефиксШК)+1);
		Запрос.УстановитьПараметр("КонечныйСимволЧисла", ДлинаШКСПрефиксом);
		Запрос.УстановитьПараметр("Дата",	Дата);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Попытка
				ШтрихкодЧисло = Число(Выборка.Штрихкод)+1;
				Штрихкод = ПрефиксШК+Формат(ШтрихкодЧисло,"ЧЦ="+Строка(ДлинаШКСПрефиксом-СтрДлина(ПрефиксШК))+"; ЧВН=; ЧГ=");    
			Исключение
			КонецПопытки;
		Иначе    
			ШтрихкодЧисло = 1;
			Штрихкод = ПрефиксШК+Формат(ШтрихкодЧисло,"ЧЦ="+Строка(ДлинаШКСПрефиксом-СтрДлина(ПрефиксШК))+"; ЧВН=; ЧГ=");    
		КОнецЕсли;
		
	КонецЕсли;		
	
КонецПроцедуры

Процедура ПроверкиПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если СтатусДокумента = Справочники.СтатусыДокументов.АРВ_Новый Тогда
			
			//Проверим что партии заполнены корректно
			ПроверитьЗаполнитьПартииВТабличнойЧасти(,,,Ложь);
			
		КонецЕсли;
		
		Если Справочники.Организации.ОрганизацияЗакрыта(Организация, Дата) Тогда
			ВызватьИсключение "Организация "+Организация+" закрыта. Создание возврата невозможно.";
		КонецЕсли;
		
		Если КодВозврата = Справочники.КодыВозврата.ВозвратПоставщику
			И Не ЗначениеЗаполнено(Поставщик) Тогда
			ВызватьИсключение "Для выбранного кода возврата необходимо указать поставщика товара!";
		КонецЕсли;
		
		//Пока разрешаем создавать Акт только на один товар. Каждый товар отдельным актом.
		ТЗНоменклатура = Товары.Выгрузить(,"Номенклатура");
		ТЗНоменклатура.Свернуть("Номенклатура");
		Если ТЗНоменклатура.Количество() > 1 Тогда
			ВызватьИсключение "Выбрано более одного товара. На каждый возвращаемый товар необходимо оформлять отдельный Акт возврата";
		КонецЕсли;
		
	КонецЕсли;	
	
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

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Организация");
	ПроверяемыеРеквизиты.Добавить("Контрагент");
	ПроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");
	ПроверяемыеРеквизиты.Добавить("Штрихкод");
	ПроверяемыеРеквизиты.Добавить("ПричинаВозврата");
	ПроверяемыеРеквизиты.Добавить("КодВозврата");
	ПроверяемыеРеквизиты.Добавить("Товары.Номенклатура");
	ПроверяемыеРеквизиты.Добавить("Товары.Количество");
	ПроверяемыеРеквизиты.Добавить("Товары.СебестоимостьЦена");
	ПроверяемыеРеквизиты.Добавить("Товары.Себестоимость");
	ПроверяемыеРеквизиты.Добавить("Товары.СтрокаПрихода");
	ПроверяемыеРеквизиты.Добавить("Товары.СтрокаЗаявки");
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеПоРТУ

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
	
	ОстаткиПартийСтруктура = ОстаткиПартийПоРТУ();
	
	ОстаткиПартийПоРТУ 	= ОстаткиПартийСтруктура.ОстаткиПартий;
	ОстаткиПоТипу		 = ОстаткиПартийСтруктура.ОстаткиПоТипу;
	
	ТаблицаРаспределения = Товары.Выгрузить().СкопироватьКолонки();
	
	Для каждого СтрокаРаспределить Из Товары Цикл
		
		//фактическое количество = 0
		Если СтрокаРаспределить.КоличествоПлан = 0 Тогда
			НоваяСтрока = ТаблицаРаспределения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределить);
		   	Продолжить;
		КонецЕсли;
		
		Распределить = СтрокаРаспределить.КоличествоПлан;
		
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
			
			СтрокиКоличествоВРТУ = ОстаткиПоТипу.НайтиСтроки(Новый структура("Тип, Номенклатура", "КоличествоВРТУ", СтрокаРаспределить.Номенклатура));
			КоличествоВРТУ = ?(СтрокиКоличествоВРТУ.Количество() = 0,0, СтрокиКоличествоВРТУ[0].Количество);
			
			СтрокиКоличествоВозвращено = ОстаткиПоТипу.НайтиСтроки(Новый структура("Тип, Номенклатура", "КоличествоВозвращено", СтрокаРаспределить.Номенклатура));
			КоличествоВозвращено = ?(СтрокиКоличествоВозвращено.Количество() = 0,0, -СтрокиКоличествоВозвращено[0].Количество);
			
			лТекстОшибки = лТекстОшибки + "
			|
			| "+СтрокаРаспределить.Номенклатура+" (артикул: "+
						СтрокаРаспределить.Номенклатура.Артикул + 
						", изготовитель: "+СтрокаРаспределить.Номенклатура.Изготовитель+")"+"
			| К возврату: "+СтрокаРаспределить.КоличествоПлан +"
			| В документе продажи: "+КоличествоВРТУ +"
			| В ранее созданных возвратах: "+КоличествоВозвращено +"
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
			СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", ЭтотОбъект);
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
			СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", ЭтотОбъект);
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

Функция ЗаполнитьСтрокиЗаявкиПоДокументуПродажи(ПерезаполнятьЗаполненные = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(ДокументПродажи) тогда 
		ТаблицаРеализации  =  ОбщегоНазначения.ЗначенияРеквизитовТабличнойЧастиОбъекта(ДокументПродажи,"Товары","СтрокаЗаявки,Номенклатура");
		Для каждого СтрокаВозврата из Товары цикл 
			НайденнаяСтрока = ТаблицаРеализации.Найти(СтрокаВозврата.Номенклатура,"Номенклатура");
			Если НЕ НайденнаяСтрока = Неопределено тогда
				Если Не ЗначениеЗаполнено(СтрокаВозврата.СтрокаЗаявки) Тогда
					ЗаполнитьЗначенияСвойств(СтрокаВозврата,НайденнаяСтрока,"СтрокаЗаявки");
				ИначеЕсли ПерезаполнятьЗаполненные Тогда
					ЗаполнитьЗначенияСвойств(СтрокаВозврата,НайденнаяСтрока,"СтрокаЗаявки");
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
	
КонецФункции

Функция ОстаткиПартийПоРТУ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЧТовары.Номенклатура,
		|	ТЧТовары.СтрокаПрихода,
		|	ТЧТовары.Количество
		|ПОМЕСТИТЬ ТЧТовары
		|ИЗ
		|	&ТЧТовары КАК ТЧТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	СУММА(АктРассмотренияВозвратаТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ втТовары
		|ИЗ
		|	ТЧТовары КАК АктРассмотренияВозвратаТовары
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
		|	И НЕ ПартииТоваров.ВнутреннееПеремещение
		|	И ПартииТоваров.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	ПартииТоваров.Номенклатура,
		|	ПартииТоваров.СтрокаПрихода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""КоличествоВРТУ"" КАК Тип,
		|	СписанныеПартии.Номенклатура,
		|	СписанныеПартии.СтрокаПрихода,
		|	СписанныеПартии.Количество
		|ПОМЕСТИТЬ ОстаткиПартийПоТипу
		|ИЗ
		|	СписанныеПартии КАК СписанныеПартии
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	""КоличествоВозвращено"",
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
		|	""КоличествоВозвращено"",
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
		|	ОстаткиПартийПоТипу.Номенклатура,
		|	ОстаткиПартийПоТипу.СтрокаПрихода,
		|	СУММА(ОстаткиПартийПоТипу.Количество) КАК Количество
		|ПОМЕСТИТЬ ОстаткиПартий
		|ИЗ
		|	ОстаткиПартийПоТипу КАК ОстаткиПартийПоТипу
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиПартийПоТипу.Номенклатура,
		|	ОстаткиПартийПоТипу.СтрокаПрихода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиПартийПоТипу.Тип,
		|	ОстаткиПартийПоТипу.Номенклатура,
		|	СУММА(ОстаткиПартийПоТипу.Количество) КАК Количество
		|ИЗ
		|	ОстаткиПартийПоТипу КАК ОстаткиПартийПоТипу
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиПартийПоТипу.Тип,
		|	ОстаткиПартийПоТипу.Номенклатура
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
	Запрос.УстановитьПараметр("ТЧТовары", Товары.Выгрузить());
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ВозвращаемоеЗначение = Новый структура();
	ВозвращаемоеЗначение.Вставить("ОстаткиПоТипу", 	РезультатыЗапроса[РезультатыЗапроса.Количество()-2].Выгрузить());
	ВозвращаемоеЗначение.Вставить("ОстаткиПартий", 	РезультатыЗапроса[РезультатыЗапроса.Количество()-1].Выгрузить());
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	КодВозврата = Справочники.КодыВозврата.ВПродажуНаСклад;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ДокументПродажи = ДанныеЗаполнения;
		Дата = ТекущаяДата();
		СтатусДокумента = Справочники.СтатусыДокументов.АРВ_Новый;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДокументПродажи, "Организация, Контрагент, ДоговорКонтрагента, СуммаВключаетНДС, УчитыватьНДС");
		
		Для каждого СтрокаОснования Из ДанныеЗаполнения.Товары Цикл
			Если СтрокаОснования.Количество <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОснования,, "Количество");
			НоваяСтрока.КоличествоПлан = СтрокаОснования.Количество;
			
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры


#КонецОбласти

#Область ЗаполнениеПоВозвратуОтПокупателя

//Тип количества = "Принятое" или "Размещенное"
Функция ОбновитьКоличествоПоВозвратуОтПокупателя(ВозвратОтПокупателяСсылка, ТипКоличества = "Принятое") Экспорт
	
	КоличествоИзменено = Ложь;
	
	ИмяПоля = "";
	Если ТипКоличества = "Принятое" Тогда
		ИмяПоля = "Количество";
	ИначеЕсли ТипКоличества = "Размещенное" Тогда 
		ИмяПоля = "КоличествоРазмещено";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИмяПоля) Тогда
		ВызватьИсключение "Задан неверный тип количества для пересчета!";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура,
		|	СУММА(ВозвратТоваровОтПокупателяТовары.Количество) КАК Количество,
		|	ВозвратТоваровОтПокупателяТовары.СтрокаПрихода
		|ИЗ
		|	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
		|ГДЕ
		|	ВозвратТоваровОтПокупателяТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура,
		|	ВозвратТоваровОтПокупателяТовары.СтрокаПрихода";
	
	Запрос.УстановитьПараметр("Ссылка", ВозвратОтПокупателяСсылка);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Количество", ИмяПоля);
	
	ТоварыВозврата = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТЧ ИЗ Товары Цикл
		
		СтрокиВозврата = ТоварыВозврата.НайтиСтроки(Новый Структура("Номенклатура, СтрокаПрихода", СтрокаТЧ.Номенклатура, СтрокаТЧ.СтрокаПрихода));
		
		КоличествоСтарое = СтрокаТЧ.Количество;
		
		СтрокаТЧ[ИмяПоля] = 0;
		Для каждого СтрокаВозврата Из СтрокиВозврата Цикл
			СтрокаТЧ[ИмяПоля] = СтрокаТЧ[ИмяПоля] + СтрокаВозврата[ИмяПоля];
		КонецЦикла;
		
		Если КоличествоСтарое <> СтрокаТЧ[ИмяПоля] Тогда
			КоличествоИзменено = Истина;			
		КонецЕсли;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
		СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", УчитыватьНДС, СуммаВключаетНДС));			
		СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", УчитыватьНДС, СуммаВключаетНДС));			
		СтруктураДействий.Вставить("ПересчитатьСебестоимость");
		ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТЧ, СтруктураДействий, Неопределено); 
		
	КонецЦикла;
	
	Возврат КоличествоИзменено;
	
КонецФункции

#КонецОбласти

#Область Прочее

Процедура УстановитьСтатусПроверкиБухгалтерией()
	
	СтатусПроверкиБухгалтерией = Документы.АктРассмотренияВозврата.СтатусПроверкиБухгалтерией(СтатусПроверкиДокументовПокупателя, СтатусПроверкиДокументовПоставщика);
	
КонецПроцедуры

Функция ЭтоРучнойВвод() Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Префикс = Документы.АктРассмотренияВозврата.ПрефиксШтрихкодаДляРучногоСозданияАРВ();
	
	Возврат СтрНайти(Штрихкод, Префикс) > 0; 
	
КонецФункции

#КонецОбласти

#Область СохранениевРегистрСобытий

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

Процедура ПриКопировании(ОбъектКопирования)
	// Вставить содержимое обработчика.
КонецПроцедуры


#КонецОбласти

