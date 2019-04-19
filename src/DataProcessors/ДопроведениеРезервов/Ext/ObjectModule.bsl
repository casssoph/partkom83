﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт 
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	ПеремещениеТоваровТовары.Ссылка,
	//               |	ПеремещениеТоваровТовары.СтрокаЗаявки,
	//               |	СУММА(ПеремещениеТоваровТовары.Количество) КАК Количество
	//               |ПОМЕСТИТЬ втТовары
	//               |ИЗ
	//               |	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	//               |ГДЕ
	//               |	ПеремещениеТоваровТовары.Ссылка.Дата >= &Дата
	//               |	И ПеремещениеТоваровТовары.Ссылка.Проведен
	//               |	И ПеремещениеТоваровТовары.Ссылка.СтатусДокумента = &СтатусДокумента
	//               |	И ПеремещениеТоваровТовары.СтрокаЗаявки <> &ПустаяСтрокаЗаявки
	//               |	И ПеремещениеТоваровТовары.Количество > 0
	//               |	И НЕ ПеремещениеТоваровТовары.СтрокаЗаявки.ТипПоставки = ЗНАЧЕНИЕ(Перечисление.ТипПоставки.ПополнениеСклада)
	//               |	И НЕ ПеремещениеТоваровТовары.СтрокаЗаявки.Виртуальная
	//               |
	//               |СГРУППИРОВАТЬ ПО
	//               |	ПеремещениеТоваровТовары.Ссылка,
	//               |	ПеремещениеТоваровТовары.СтрокаЗаявки
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	втТовары.Ссылка,
	//               |	втТовары.СтрокаЗаявки,
	//               |	ВЫБОР
	//               |		КОГДА ЗаявкиПокупателейОстаткиИОбороты.КоличествоНачальныйОстаток < втТовары.Количество
	//               |			ТОГДА ЗаявкиПокупателейОстаткиИОбороты.КоличествоНачальныйОстаток
	//               |		ИНАЧЕ втТовары.Количество
	//               |	КОНЕЦ КАК Количество
	//               |ПОМЕСТИТЬ втТовары2
	//               |ИЗ
	//               |	РегистрНакопления.ЗаявкиПокупателей.ОстаткиИОбороты(
	//               |			,
	//               |			,
	//               |			Регистратор,
	//               |			,
	//               |			СтрокаЗаявки В
	//               |				(ВЫБРАТЬ
	//               |					втТовары.СтрокаЗаявки
	//               |				ИЗ
	//               |					втТовары)) КАК ЗаявкиПокупателейОстаткиИОбороты
	//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТовары КАК втТовары
	//               |		ПО ЗаявкиПокупателейОстаткиИОбороты.Регистратор = втТовары.Ссылка
	//               |			И ЗаявкиПокупателейОстаткиИОбороты.СтрокаЗаявки = втТовары.СтрокаЗаявки
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	втТовары2.Ссылка,
	//               |	втТовары2.СтрокаЗаявки,
	//               |	втТовары2.Количество,
	//               |	ЕСТЬNULL(РезервыТоваровОбороты.КоличествоПриход, 0) КАК ВсталоВРезерв
	//               |ИЗ
	//               |	втТовары2 КАК втТовары2
	//               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РезервыТоваров.Обороты(
	//               |				,
	//               |				,
	//               |				Регистратор,
	//               |				СтрокаЗаявки В
	//               |					(ВЫБРАТЬ
	//               |						втТовары2.СтрокаЗаявки
	//               |					ИЗ
	//               |						втТовары2)) КАК РезервыТоваровОбороты
	//               |		ПО втТовары2.Ссылка = РезервыТоваровОбороты.Регистратор
	//               |			И втТовары2.СтрокаЗаявки = РезервыТоваровОбороты.СтрокаЗаявки
	//               |ГДЕ
	//               |	втТовары2.Количество > ЕСТЬNULL(РезервыТоваровОбороты.КоличествоПриход, 0)"
				   
				   
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкиПокупателейОстатки.СтрокаЗаявки,
	               |	ЗаявкиПокупателейОстатки.КоличествоОстаток
	               |ПОМЕСТИТЬ втЗаявки
	               |ИЗ
	               |	РегистрНакопления.ЗаявкиПокупателей.Остатки(
	               |			,
	               |			СтрокаЗаявки.ТипПоставки = &ТипПоставки
	               |				И (СтрокаЗаявки = &СтрокаЗаявки
	               |					ИЛИ &ВсеСтрокиЗаявок)) КАК ЗаявкиПокупателейОстатки
	               |ГДЕ
	               |	ЗаявкиПокупателейОстатки.КоличествоОстаток > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	РезервыТоваровОстатки.СтрокаЗаявки,
	               |	РезервыТоваровОстатки.КоличествоОстаток
	               |ПОМЕСТИТЬ втРезервы
	               |ИЗ
	               |	РегистрНакопления.РезервыТоваров.Остатки(
	               |			,
	               |			СтрокаЗаявки В
	               |				(ВЫБРАТЬ
	               |					втЗаявки.СтрокаЗаявки
	               |				ИЗ
	               |					втЗаявки)) КАК РезервыТоваровОстатки
	               |ГДЕ
	               |	РезервыТоваровОстатки.КоличествоОстаток > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт.СтрокаЗаявки,
	               |	вт.КоличествоОстаток - ЕСТЬNULL(втРезервы.КоличествоОстаток, 0) КАК КоличествоОстаток
	               |ПОМЕСТИТЬ втЗаявкиМинусРезервы
	               |ИЗ
	               |	втЗаявки КАК вт
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втРезервы КАК втРезервы
	               |		ПО вт.СтрокаЗаявки = втРезервы.СтрокаЗаявки
	               |ГДЕ
	               |	вт.КоличествоОстаток - ЕСТЬNULL(втРезервы.КоличествоОстаток, 0) > 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПеремещениеТоваровТовары.Ссылка,
	               |	ПеремещениеТоваровТовары.Ссылка.Дата,
	               |	СУММА(ПеремещениеТоваровТовары.Количество) КАК Количество,
	               |	ПеремещениеТоваровТовары.СтрокаЗаявки,
	               |	втЗаявкиМинусРезервы.КоличествоОстаток,
	               |	ПеремещениеТоваровТовары.Номенклатура,
	               |	ПеремещениеТоваровТовары.Ссылка.СкладПолучатель
	               |ПОМЕСТИТЬ вт2
	               |ИЗ
	               |	втЗаявкиМинусРезервы КАК втЗаявкиМинусРезервы
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	               |		ПО втЗаявкиМинусРезервы.СтрокаЗаявки = ПеремещениеТоваровТовары.СтрокаЗаявки
	               |ГДЕ
	               |	ПеремещениеТоваровТовары.Ссылка.Проведен
	               |	И ПеремещениеТоваровТовары.Ссылка.СтатусДокумента = &СтатусДокумента
	               |	И ПеремещениеТоваровТовары.Ссылка.ВидОперации = &ВидОперации
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПеремещениеТоваровТовары.Ссылка.Дата,
	               |	ПеремещениеТоваровТовары.СтрокаЗаявки,
	               |	втЗаявкиМинусРезервы.КоличествоОстаток,
	               |	ПеремещениеТоваровТовары.Ссылка,
	               |	ПеремещениеТоваровТовары.Номенклатура,
	               |	ПеремещениеТоваровТовары.Ссылка.СкладПолучатель
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт2.Ссылка КАК Ссылка,
	               |	вт2.Дата КАК Дата,
	               |	вт2.Количество,
	               |	вт2.СтрокаЗаявки КАК СтрокаЗаявки,
	               |	вт2.КоличествоОстаток КАК КоличествоОстаток,
	               |	ЕСТЬNULL(РезервыТоваровОбороты.КоличествоПриход, 0) КАК КоличествоРезерв,
	               |	вт2.Количество - ЕСТЬNULL(РезервыТоваровОбороты.КоличествоПриход, 0) КАК МожноДобавитьРезерв,
	               |	вт2.Номенклатура,
	               |	вт2.СкладПолучатель КАК СкладПолучатель
	               |ИЗ
	               |	вт2 КАК вт2
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РезервыТоваров.Обороты(, , Регистратор, ) КАК РезервыТоваровОбороты
	               |		ПО вт2.Ссылка = РезервыТоваровОбороты.Регистратор
	               |			И вт2.СтрокаЗаявки = РезервыТоваровОбороты.СтрокаЗаявки
	               |			И вт2.Номенклатура = РезервыТоваровОбороты.Номенклатура
	               |ГДЕ
	               |	вт2.Количество > ЕСТЬNULL(РезервыТоваровОбороты.КоличествоПриход, 0)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата УБЫВ
	               |ИТОГИ
	               |	МАКСИМУМ(Дата),
	               |	МАКСИМУМ(КоличествоОстаток),
	               |	МАКСИМУМ(СкладПолучатель)
	               |ПО
	               |	СтрокаЗаявки,
	               |	Ссылка";
	Запрос.УстановитьПараметр("ТипПоставки", Перечисления.ТипПоставки.Кросс);
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийПеремещенияТоваров.ПриемкаТопЛог);
	Запрос.УстановитьПараметр("СтатусДокумента", Справочники.СтатусыДокументов.ПеремещениеТоваровПоступил);
	Запрос.УстановитьПараметр("СтрокаЗаявки", СтрокаЗаявки);
	Запрос.УстановитьПараметр("ВсеСтрокиЗаявок", Не ЗначениеЗаполнено(СтрокаЗаявки));
	НачатьТранзакцию();
		Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СтрокаЗаявки");
	ЗафиксироватьТранзакцию();
	
	Пока Выборка.Следующий() Цикл 
		ВыборкаПоДокументам = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
		КоличествоОстаток = Выборка.КоличествоОстаток;
		Пока ВыборкаПоДокументам.Следующий() Цикл 
			ВыборкаПоТоварам = ВыборкаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ТаблицаДвижений = Новый ТаблицаЗначений;
			ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("РезервыТоваров", ТаблицаДвижений);
			
			Пока ВыборкаПоТоварам.Следующий() Цикл 
				ДобавляемыйРезерв = Мин(КоличествоОстаток, 	ВыборкаПоТоварам.МожноДобавитьРезерв);
				Если ДобавляемыйРезерв > 0 Тогда 
					НоваяСтрока = ТаблицаДвижений.Добавить();	
					НоваяСтрока.Период = ВыборкаПоДокументам.Дата;
					НоваяСтрока.Регистратор = ВыборкаПоДокументам.Ссылка;
					НоваяСтрока.Номенклатура = ВыборкаПоТоварам.Номенклатура;
					НоваяСтрока.Склад = ВыборкаПоДокументам.СкладПолучатель;
					НоваяСтрока.Качество = Справочники.Качество.Новый;
					НоваяСтрока.СтрокаЗаявки = ВыборкаПоТоварам.СтрокаЗаявки;
					
					НоваяСтрока.Количество =  ДобавляемыйРезерв;
					НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
				КонецЕсли;
				КоличествоОстаток = КоличествоОстаток - ДобавляемыйРезерв;
				
			КонецЦикла;
			Если ТаблицаДвижений.Количество() > 0 Тогда 	
				ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДвижений, ДобавленоРезервов);
				Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(ВыборкаПоДокументам.Ссылка,
										Метаданные.РегистрыНакопления.РезервыТоваров);
				ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДвижений, Результат);
				
				Набор = РегистрыНакопления.РезервыТоваров.СоздатьНаборЗаписей();
				Набор.Отбор.Регистратор.Установить(ВыборкаПоДокументам.Ссылка);
				Набор.Загрузить(Результат);
				Набор.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ЗаписатьФайл();
КонецПроцедуры

Процедура ЗаписатьФайл()
	Если ДобавленоРезервов.Количество() > 0 Тогда 
		Текст = Новый ТекстовыйДокумент;
		Стр = "Номер перемещения; Дата перемещения; Номенклатура; Уид номенклатуры; IDSite; Количество";
		Текст.ДобавитьСтроку(Стр);
		Для Каждого СтрокаТЧ Из ДобавленоРезервов Цикл
			Стр = "" + СтрокаТЧ.Регистратор.Номер + ";"  + СтрокаТЧ.Регистратор.Дата + ";" + СтрокаТЧ.Номенклатура.Наименование + ";" + СтрокаТЧ.Номенклатура.УникальныйИдентификатор() + ";" + СтрокаТЧ.СтрокаЗаявки.IDSite + ";" + СтрокатЧ.Количество;
			Текст.ДобавитьСтроку(Стр);
		КонецЦикла;
		Текст.Записать(ПутьКФайлу + "\ДопроведениеРезервов" + Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd-hh-mm-ss") + ".txt");
	КонецЕсли;	
КонецПроцедуры