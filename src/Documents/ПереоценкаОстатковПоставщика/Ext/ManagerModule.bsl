﻿
//// ОБРАБОТЧИКИ МОДУЛЯ ОБЪЕКТА

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	лКонтроль = Неопределено;
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДанныеОбъекта.Контроль", лКонтроль);
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	
		
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ЦеныНоменклатурыКонтрагентов") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ЦеныНоменклатурыКонтрагентов",
		РегистрыСведений_ЦеныНоменклатурыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры), Истина);
	КонецЕсли;
	
	//Если НЕ ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда
		Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.НоменклатураПоставщика.Номенклатура КАК Номенклатура,
			               |	&СтатусПартии КАК СтатусПартии
			               |ИЗ
			               |	Документ.ПереоценкаОстатковПоставщика.ТоварыПоставщика КАК ПереоценкаОстатковПоставщикаТоварыПоставщика
			               |ГДЕ
			               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.Ссылка = &Ссылка
			               |	И ЕСТЬNULL(ПереоценкаОстатковПоставщикаТоварыПоставщика.НоменклатураПоставщика.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
			               |	И НЕ ПереоценкаОстатковПоставщикаТоварыПоставщика.НеПереоценивать";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартии.ПринятыйНаОтветХранение);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрНакопления.ПартииТоваров");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("СтатусПартии", "СтатусПартии");
			
			ЭлементБлокировки = БлокировкаДанных.Добавить("Последовательность.ПартионныйУчет");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
			БлокировкаДанных.Заблокировать();
			
			лОчищать = ПроведениеДокументовКлиентСервер.НеобходимоОчиститьДвиженияПартииТоваров(вхСсылкаНаДокумент, лФильтр);		
			
			НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
			
			Если лОчищать тогда
				Если лФильтр = Неопределено Тогда 
					ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);
					лБазовая = Неопределено;
					ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ПартииТоваров", лБазовая);
				Иначе
					// Очищаем только движения по фильтру
					лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
					лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
					ОбщегоНазначения.ЗаписатьДвиженияДокументаБезОбработки(вхСсылкаНаДокумент, РегистрыНакопления.ПартииТоваров, лРазделенныеБазовая.Исключенные, Истина); 
					лБазовая = лРазделенныеБазовая.Исключенные;
				КонецЕсли;
			Иначе
				лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
			КонецЕсли;
			
			лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
			лИсходная = лРазделенныеБазовая.Включенные;
			
			лТребуемая = РегистрыНакопления_ПартииТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры, лФильтр);
			
			лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
			ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров,
			лРазностныеДанные, лРазделенныеБазовая.Исключенные);
			
			ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
			Если лФильтр = Неопределено Тогда 
				РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Истина);
			КонецЕсли;
		КонецЕсли;
		
	//КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент);
	ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	
	РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Ложь);
КонецПроцедуры

//// ТАБЛИЦЫ ДВИЖЕНИЙ ДОКУМЕНТОВ

Функция РегистрыНакопления_ПартииТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры, вхФильтр = Неопределено)
	
	ТаблицаДвижений = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ПартииТоваров", ТаблицаДвижений);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "Дата,Контрагент,ПрайсПоставщикаVMI,УчитыватьНДС,СуммаВключаетНДС");
	
	Если Реквизиты.Дата < глЗначениеПеременной("ДатаЗапускаПроведенияПоПартиямРезервам") Тогда
		Возврат ТаблицаДвижений;
	КонецЕсли;
	
	ВалютаРубль = ПараметрыСеанса.ВалютаРубль;
	ВалютаДоллар = ПараметрыСеанса.ВалютаДоллар;
	ВалютаЕвро = ПараметрыСеанса.ВалютаЕвро;
	КурсДоллара = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДоллар, Реквизиты.Дата);
	КурсЕвро = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаЕвро, Реквизиты.Дата);
	
	Если Реквизиты.Дата >= глЗначениеПеременной("ДатаПереоценкиОстатковПоставщикаСоздаютсяВ83") Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.НоменклатураПоставщика.Номенклатура КАК Номенклатура,
		               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.НоменклатураПоставщика,
		               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.Цена КАК ЦенаНовая,
		               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.НомерСтроки КАК НомерСтрокиВДокументе
		               |ПОМЕСТИТЬ втТовары
		               |ИЗ
		               |	Документ.ПереоценкаОстатковПоставщика.ТоварыПоставщика КАК ПереоценкаОстатковПоставщикаТоварыПоставщика
		               |ГДЕ
		               |	ПереоценкаОстатковПоставщикаТоварыПоставщика.Ссылка = &Ссылка
		               |	И ЕСТЬNULL(ПереоценкаОстатковПоставщикаТоварыПоставщика.НоменклатураПоставщика.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		               |	И НЕ ПереоценкаОстатковПоставщикаТоварыПоставщика.НеПереоценивать
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	Номенклатура
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ПартииТоваровОстатки.Номенклатура,
		               |	ПартииТоваровОстатки.Склад,
		               |	ПартииТоваровОстатки.Качество,
		               |	ПартииТоваровОстатки.СтатусПартии,
		               |	ПартииТоваровОстатки.СтрокаПрихода,
		               |	ПартииТоваровОстатки.Организация,
		               |	ПартииТоваровОстатки.КоличествоОстаток КАК Количество,
		               |	ПартииТоваровОстатки.СуммаРублиОстаток КАК СуммаРубли,
		               |	ПартииТоваровОстатки.СуммаДолларыОстаток КАК СуммаДоллары,
		               |	ПартииТоваровОстатки.СуммаЕвроОстаток КАК СуммаЕвро,
		               |	ПартииТоваровОстатки.СуммаБезНДСОстаток КАК СуммаБезНДС
		               |ПОМЕСТИТЬ втПартии
		               |ИЗ
		               |	РегистрНакопления.ПартииТоваров.Остатки(
		               |			&КонПериода,
		               |			Номенклатура В
		               |					(ВЫБРАТЬ
		               |						втТовары.Номенклатура
		               |					ИЗ
		               |						втТовары)
		               |				И СтатусПартии = &СтатусПартии
		               |				И СтрокаПрихода.ТорговаяТочка.Владелец = &Контрагент) КАК ПартииТоваровОстатки
		               |ГДЕ
		               |	ПартииТоваровОстатки.КоличествоОстаток > 0
		               |
		               |ДЛЯ ИЗМЕНЕНИЯ
		               |	РегистрНакопления.ПартииТоваров.Остатки
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ПартииТоваровОстатки.Номенклатура,
		               |	ПартииТоваровОстатки.Склад,
		               |	ПартииТоваровОстатки.Качество,
		               |	ПартииТоваровОстатки.СтатусПартии,
		               |	ПартииТоваровОстатки.СтрокаПрихода,
		               |	ПартииТоваровОстатки.Организация,
		               |	ПартииТоваровОстатки.Количество КАК Количество,
		               |	ПартииТоваровОстатки.СуммаРубли КАК СуммаРубли,
		               |	ПартииТоваровОстатки.СуммаДоллары КАК СуммаДоллары,
		               |	ПартииТоваровОстатки.СуммаЕвро КАК СуммаЕвро,
		               |	ПартииТоваровОстатки.СуммаБезНДС КАК СуммаБезНДС,
		               |	втТовары.НоменклатураПоставщика,
		               |	втТовары.ЦенаНовая,
		               |	втТовары.НомерСтрокиВДокументе
		               |ИЗ
		               |	втТовары КАК втТовары
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втПартии КАК ПартииТоваровОстатки
		               |		ПО втТовары.Номенклатура = ПартииТоваровОстатки.Номенклатура
		               |ГДЕ
		               |	ПартииТоваровОстатки.Количество > 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура,
		               |	ЦеныНоменклатурыКонтрагентовСрезПоследних.Валюта,
		               |	ЦеныНоменклатурыКонтрагентовСрезПоследних.Цена КАК ЦенаСтарая
		               |ИЗ
		               |	РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(
		               |			&КонПериода,
		               |			Номенклатура В
		               |					(ВЫБРАТЬ
		               |						втТовары.НоменклатураПоставщика
		               |					ИЗ
		               |						втТовары)
		               |				И ПрайсПоставщика = &ПрайсПоставщика) КАК ЦеныНоменклатурыКонтрагентовСрезПоследних
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	втТовары.Номенклатура,
		               |	МИНИМУМ(втТовары.НомерСтрокиВДокументе) КАК НомерСтрокиВДокументе
		               |ПОМЕСТИТЬ втНомера
		               |ИЗ
		               |	втТовары КАК втТовары
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	втТовары.Номенклатура
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ПереоценкаОстатковПоставщикаТовары.Номенклатура,
		               |	ПереоценкаОстатковПоставщикаТовары.Качество,
		               |	ПереоценкаОстатковПоставщикаТовары.ЦенаСтарая,
		               |	ПереоценкаОстатковПоставщикаТовары.ЦенаНовая,
		               |	ПереоценкаОстатковПоставщикаТовары.флНеПереоценивать,
		               |	ЕСТЬNULL(втНомера.НомерСтрокиВДокументе, 0) КАК НомерСтрокиВДокументе
		               |ИЗ
		               |	Документ.ПереоценкаОстатковПоставщика.Товары КАК ПереоценкаОстатковПоставщикаТовары
		               |		ЛЕВОЕ СОЕДИНЕНИЕ втНомера КАК втНомера
		               |		ПО ПереоценкаОстатковПоставщикаТовары.Номенклатура = втНомера.Номенклатура
		               |ГДЕ
		               |	ПереоценкаОстатковПоставщикаТовары.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
		Запрос.УстановитьПараметр("КонПериода", вхСсылкаНаДокумент.МоментВремени());
		Запрос.УстановитьПараметр("ПрайсПоставщика", Реквизиты.ПрайсПоставщикаVMI);
		Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартии.ПринятыйНаОтветХранение);
		Запрос.УстановитьПараметр("Контрагент", Реквизиты.Контрагент);
		
		Если ТипЗнч(вхФильтр) = Тип("Структура") И вхФильтр.Свойство("Номенклатура") Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УсловиеПоНоменклатуре%", " И ПереоценкаОстатковПоставщикаТовары.НоменклатураПоставщика.Номенклатура = &Номенклатура");
			Запрос.Текст = Запрос.Текст + " И ПереоценкаОстатковПоставщикаТовары.Номенклатура = &Номенклатура";
			Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УсловиеПоНоменклатуре%", "");
		КонецЕсли;
		
		Результаты = Запрос.ВыполнитьПакет();
		
		Выборка = Результаты[2].Выбрать();
		Цены = Результаты[3].Выгрузить();
		Товары = Результаты[5].Выгрузить();
		
		НовыеТовары = Новый ТаблицаЗначений;
		НовыеТовары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		НовыеТовары.Колонки.Добавить("Качество", Новый ОписаниеТипов("СправочникСсылка.Качество"));
		НовыеТовары.Колонки.Добавить("ЦенаНовая", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
		НовыеТовары.Колонки.Добавить("ЦенаСтарая", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
		НовыеТовары.Колонки.Добавить("НомерСтрокиВДокументе", ОбщегоНазначения.ОписаниеТипаЧисло(10));
		
		Пока Выборка.Следующий() Цикл 
			СтрокаТовары = Товары.Найти(Выборка.Номенклатура, "Номенклатура");
			Если СтрокаТовары <> Неопределено И СтрокаТовары.флНеПереоценивать Тогда 
				Продолжить;
			КонецЕсли;
			
			НоваСтрока = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваСтрока, Выборка);
			НоваСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
			НоваСтрока.ВнутреннееПеремещение = Истина;
			
			НоваяСтрокаПриход = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПриход, Выборка);
			НоваяСтрокаПриход.ВнутреннееПеремещение = Истина;
			НоваяСтрокаПриход.ВидДвижения = ВидДвиженияНакопления.Приход;
			
			НоваяСтрокаПриход.СуммаРубли = НоваяСтрокаПриход.Количество * Выборка.ЦенаНовая;
			Если Выборка.СуммаРубли <> 0 Тогда
				НоваяСтрокаПриход.СуммаБезНДС = НоваяСтрокаПриход.СуммаРубли * Выборка.СуммаБезНДС/Выборка.СуммаРубли;
			КонецЕсли;		
			
			НоваяСтрокаПриход.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрокаПриход.СуммаРубли, ВалютаРубль,
			ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
			НоваяСтрокаПриход.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрокаПриход.СуммаРубли, ВалютаРубль,
			ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
			
			СтрокаТовары = НовыеТовары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТовары, Выборка, "Номенклатура,Качество,ЦенаНовая");
			
			СтрокаЦены = Цены.Найти(Выборка.НоменклатураПоставщика, "Номенклатура");
			Если СтрокаЦены <> Неопределено Тогда 
				СтрокаТовары.ЦенаСтарая = СтрокаЦены.ЦенаСтарая;
			КонецЕсли;
		КонецЦикла;
		
		лДобавлять = Неопределено;
		лУдалять = Неопределено;
		Товары.Колонки.Удалить("флНеПереоценивать");
		НужноМенятьДок = Не РаботаСПоследовательностямиКлиентСервер.ТаблицыИдентичны(Товары, НовыеТовары, лДобавлять, лУдалять);
		Если НужноМенятьДок Тогда 
			ДокОб = вхСсылкаНаДокумент.ПолучитьОбъект();
			Для Каждого лСтрока Из лУдалять Цикл 
				Строки = ДокОб.Товары.НайтиСтроки(Новый Структура("Номенклатура,Качество,ЦенаНовая,ЦенаСтарая,НомерСтроки", лСтрока.Номенклатура, лСтрока.Качество, лСтрока.ЦенаНовая, лСтрока.ЦенаСтарая, лСтрока.НомерСтрокиВДокументе));	
				Для Каждого СтрокаТЧ Из Строки Цикл
					ДокОб.Товары.Удалить(СтрокаТЧ);
				КонецЦикла;
			КонецЦикла;
			Для Каждого лСтрока Из лДобавлять Цикл 
				ЗаполнитьЗначенияСвойств(ДокОб.Товары.Добавить(), лСтрока);	
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПереоценкаОстатковПоставщикаТовары.Номенклатура КАК Номенклатура,
		               |	ПереоценкаОстатковПоставщикаТовары.ЦенаНовая
		               |ПОМЕСТИТЬ втТовары
		               |ИЗ
		               |	Документ.ПереоценкаОстатковПоставщика.Товары КАК ПереоценкаОстатковПоставщикаТовары
		               |ГДЕ
		               |	ПереоценкаОстатковПоставщикаТовары.Ссылка = &Ссылка
		               |	И НЕ ПереоценкаОстатковПоставщикаТовары.флНеПереоценивать  %УсловиеПоНоменклатуре%
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	Номенклатура
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ПартииТоваровОстатки.Номенклатура,
		               |	ПартииТоваровОстатки.Склад,
		               |	ПартииТоваровОстатки.Качество,
		               |	ПартииТоваровОстатки.СтатусПартии,
		               |	ПартииТоваровОстатки.СтрокаПрихода,
		               |	ПартииТоваровОстатки.Организация,
		               |	ПартииТоваровОстатки.КоличествоОстаток КАК Количество,
		               |	ПартииТоваровОстатки.СуммаРублиОстаток КАК СуммаРубли,
		               |	ПартииТоваровОстатки.СуммаДолларыОстаток КАК СуммаДоллары,
		               |	ПартииТоваровОстатки.СуммаЕвроОстаток КАК СуммаЕвро,
		               |	ПартииТоваровОстатки.СуммаБезНДСОстаток КАК СуммаБезНДС,
		               |	втТовары.ЦенаНовая
		               |ИЗ
		               |	РегистрНакопления.ПартииТоваров.Остатки(
		               |			&КонПериода,
		               |			Номенклатура В
		               |					(ВЫБРАТЬ
		               |						втТовары.Номенклатура
		               |					ИЗ
		               |						втТовары)
		               |				И СтатусПартии = &СтатусПартии
		               |				И СтрокаПрихода.ТорговаяТочка.Владелец = &Контрагент) КАК ПартииТоваровОстатки
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТовары КАК втТовары
		               |		ПО ПартииТоваровОстатки.Номенклатура = втТовары.Номенклатура ГДЕ ПартииТоваровОстатки.КоличествоОстаток > 0";
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
		Запрос.УстановитьПараметр("КонПериода", вхСсылкаНаДокумент.МоментВремени());
		Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартии.ПринятыйНаОтветХранение);
		Запрос.УстановитьПараметр("Контрагент", Реквизиты.Контрагент);
		
		Если ТипЗнч(вхФильтр) = Тип("Структура") И вхФильтр.Свойство("Номенклатура") Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УсловиеПоНоменклатуре%", " И ПереоценкаОстатковПоставщикаТовары.Номенклатура = &Номенклатура");
			Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УсловиеПоНоменклатуре%", "");
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			НоваСтрока = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваСтрока, Выборка);
			НоваСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
			
			НоваяСтрокаПриход = ТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПриход, Выборка);
			НоваяСтрокаПриход.ВидДвижения = ВидДвиженияНакопления.Приход;
			
			НоваяСтрокаПриход.СуммаРубли = НоваяСтрокаПриход.Количество * Выборка.ЦенаНовая;
			Если Выборка.СуммаРубли <> 0 Тогда 
				НоваяСтрокаПриход.СуммаБезНДС = НоваяСтрокаПриход.СуммаРубли * Выборка.СуммаБезНДС/Выборка.СуммаРубли;
			Иначе
				НоваяСтрокаПриход.СуммаБезНДС = НоваяСтрокаПриход.СуммаРубли - УчетНДС.РассчитатьСуммуНДС(НоваяСтрокаПриход.СуммаРубли, Реквизиты.УчитыватьНДС, Реквизиты.СуммаВключаетНДС, Перечисления.СтавкиНДС.НДС20);	
			КонецЕсли;
			НоваяСтрокаПриход.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрокаПриход.СуммаРубли, ВалютаРубль,
			ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
			НоваяСтрокаПриход.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрокаПриход.СуммаРубли, ВалютаРубль,
			ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаДвижений.ЗаполнитьЗначения(вхСсылкаНаДокумент, "Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Реквизиты.Дата, "Период");
	
	Возврат ТаблицаДвижений;
			
КонецФункции

Функция РегистрыСведений_ЦеныНоменклатурыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	Таб = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраСведений("ЦеныНоменклатурыКонтрагентов", Таб);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Ссылка.Ссылка КАК Регистратор,
	|	Т.Ссылка.Дата КАК Период,
	|	Т.Ссылка.ПрайсПоставщикаVMI КАК ПрайсПоставщика,
	|	Т.НоменклатураПоставщика КАК Номенклатура,
	|	Т.Ссылка.ВалютаДокумента КАК Валюта,
	|	МАКСИМУМ(Т.Цена) КАК Цена
	|ИЗ
	|	Документ.ПереоценкаОстатковПоставщика.ТоварыПоставщика КАК Т
	|ГДЕ
	|	Т.Ссылка = &Ссылка
	|	И НЕ Т.НеПереоценивать
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Ссылка.Ссылка,
	|	Т.Ссылка.Дата,
	|	Т.Ссылка.ПрайсПоставщикаVMI,
	|	Т.НоменклатураПоставщика,
	|	Т.Ссылка.ВалютаДокумента"
	);
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), Таб);
	
	Возврат Таб;
	
КонецФункции
//// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Функция ПолучитьЗаписиПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, Проведение) Экспорт 
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лМетаданныеДокумента = вхСсылкаНаДокумент.Метаданные();
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Если Проведение 
			И Дата >= ПараметрыСеанса.ДатаНачалаРаботыТовары 
			И Дата >= глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	ПереоценкаОстатковПоставщикаТовары.Ссылка.Дата КАК Период,
			               |	ПереоценкаОстатковПоставщикаТовары.Ссылка КАК Регистратор,
			               |	ПереоценкаОстатковПоставщикаТовары.Номенклатура КАК Номенклатура
			               |ИЗ
			               |	Документ.ПереоценкаОстатковПоставщика.Товары КАК ПереоценкаОстатковПоставщикаТовары
			               |ГДЕ
			               |	ПереоценкаОстатковПоставщикаТовары.Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(лРезультат.Добавить(), Выборка); 
			КонецЦикла;
		КонецЕсли;
		
		Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
		
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхФильтр = Неопределено) Экспорт
	
	Результат = Неопределено;
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.ПартииТоваров, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПечатьОшибкиПриЗагрузкеПрайса(текДокумент) Экспорт
	ТабДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("ОшибкиПриЗагрузке");
	Область = Макет.ПолучитьОбласть("Шапка");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПереоценкаОстатковПоставщика.Номер,
	|	ПереоценкаОстатковПоставщика.Дата,
	|	ПереоценкаОстатковПоставщика.Контрагент.НаименованиеПолное КАК Поставщик,
	|	ПереоценкаОстатковПоставщика.ДоговорКонтрагента.Наименование КАК Договор,
	|	ПереоценкаОстатковПоставщика.ПрайсПоставщикаVMI.Наименование КАК Прайс,
	|	ПереоценкаОстатковПоставщика.ПрайсПоставщикаVMI.ПроцентОтклонения КАК ПроцентОтклонения,
	|	ПереоценкаОстатковПоставщика.ПрайсПоставщикаVMI.Код КАК КодПрайса
	|ИЗ
	|	Документ.ПереоценкаОстатковПоставщика КАК ПереоценкаОстатковПоставщика
	|ГДЕ
	|	ПереоценкаОстатковПоставщика.Ссылка = &Ссылка"
	);
	Запрос.УстановитьПараметр("Ссылка", текДокумент);
	
	Р = Запрос.Выполнить().Выбрать();
	ПроцентПрайсПлюс = 0;
	ПроцентПрайсМинус = 0;
	Пока Р.Следующий() Цикл
		Область.Параметры.Номер = Р.Номер;
		Область.Параметры.Дата = Формат(Р.Дата, "ДЛФ=DD");
		Область.Параметры.Поставщик = Р.Поставщик;
		Область.Параметры.Договор = Р.Договор;
		Область.Параметры.ПрайсПоставщика = Р.Прайс;//Р.КодПрайса;
		ПроцентПрайсПлюс = Р.ПроцентОтклонения;
		Если ПроцентПрайсПлюс > 100 Тогда
			ПроцентПрайсМинус = ПроцентПрайсПлюс - 100;
		Иначе
			ПроцентПрайсМинус = ПроцентПрайсПлюс;
		КонецЕсли;
		
	КонецЦикла;
	
	ТабДокумент.Вывести(Область);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЧ.АртикулПоставщика,
	|	ТЧ.ИзготовительПоставщика,
	|	ТЧ.Цена,
	|	ТЧ.ЦенаСтарая,
	|	ТЧ.ПроцентОтклонения,
	|	ТЧ.НоменклатураПоставщика.Артикул КАК Артикул,
	|	ТЧ.НоменклатураПоставщика.Изготовитель КАК Изготовитель,
	|	ТЧ.НоменклатураПоставщика.МинКолПартии КАК МинКолПартии,
	|	ТЧ.НеПереоценивать
	|ИЗ
	|	Документ.ПереоценкаОстатковПоставщика.ТоварыПоставщика КАК ТЧ
	|ГДЕ
	|	ТЧ.Ссылка = &Ссылка";
	//|	И ТЧ.ПроцентОтклонения > ТЧ.Ссылка.ПрайсПоставщикаVMI.ПроцентОтклонения";
	Запрос.УстановитьПараметр("Ссылка", текДокумент);
	
	Р = Запрос.Выполнить().Выбрать();
	//Если Р.Количество() = 0 Тогда
	//	Область = Макет.ПолучитьОбласть("Успех");
	//	ТабДокумент.Вывести(Область);
	//	
	//Иначе
		Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
		Область.Параметры.ПроцентПрайс = ПроцентПрайсПлюс;
		ТабДокумент.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Строка");
		ВыделеннаяОбласть = Макет.ПолучитьОбласть("СтрокаКрасная");
		
		Пока Р.Следующий() Цикл
			если Р.НеПереоценивать тогда 
					ВыделеннаяОбласть.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
					ВыделеннаяОбласть.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
					ВыделеннаяОбласть.Параметры.Цена = Р.Цена;
					ВыделеннаяОбласть.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
					ВыделеннаяОбласть.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
					ТабДокумент.Вывести(ВыделеннаяОбласть);
				
			иначе 
					Область.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
					Область.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
					Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
					Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
					Область.Параметры.МинКолПартии = Р.МинКолПартии;
					Область.Параметры.Цена = Р.Цена;
					Область.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
					Область.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
					ТабДокумент.Вывести(Область);

				
				
			КонецЕсли;	
			
			
			//#PK83-324 Kalinin V.A. ( 2018-05-31 )
			//Если Р.ЦенаСтарая > 0 И Р.Цена > Р.ЦенаСтарая И ПроцентПрайсПлюс > 0 Тогда
			//	Если Р.ПроцентОтклонения > ПроцентПрайсПлюс Тогда
			//		ВыделеннаяОбласть.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
			//		ВыделеннаяОбласть.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
			//		Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
			//		Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
			//		Область.Параметры.МинКолПартии = Р.МинКолПартии;
			//		ВыделеннаяОбласть.Параметры.Цена = Р.Цена;
			//		ВыделеннаяОбласть.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
			//		ВыделеннаяОбласть.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
			//		ТабДокумент.Вывести(ВыделеннаяОбласть);
			//	Иначе
			//		Область.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
			//		Область.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
			//		Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
			//		Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
			//		Область.Параметры.МинКолПартии = Р.МинКолПартии;
			//		Область.Параметры.Цена = Р.Цена;
			//		Область.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
			//		Область.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
			//		ТабДокумент.Вывести(Область);
			//	
			//	КонецЕсли;
			//	
			//ИначеЕсли Р.ЦенаСтарая > 0 И Р.Цена < Р.ЦенаСтарая И ПроцентПрайсМинус > 0 Тогда
			//	Если Р.ПроцентОтклонения > ПроцентПрайсМинус Тогда
			//		ВыделеннаяОбласть.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
			//		ВыделеннаяОбласть.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
			//		ВыделеннаяОбласть.Параметры.Цена = Р.Цена;
			//		Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
			//		Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
			//		Область.Параметры.МинКолПартии = Р.МинКолПартии;
			//		ВыделеннаяОбласть.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
			//		ВыделеннаяОбласть.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
			//		ТабДокумент.Вывести(ВыделеннаяОбласть);
			//	Иначе
			//		Область.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
			//		Область.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
			//		Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
			//		Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
			//		Область.Параметры.МинКолПартии = Р.МинКолПартии;
			//		Область.Параметры.Цена = Р.Цена;
			//		Область.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
			//		Область.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
			//		ТабДокумент.Вывести(Область);
			//	
			//	КонецЕсли;
			//	
			//Иначе
			//	Область.Параметры.АртикулПоставщика = Р.АртикулПоставщика;
			//	Область.Параметры.ИзготовительПоставщика = Р.ИзготовительПоставщика;
			//	Область.Параметры.Цена = Р.Цена;
			//	Область.Параметры.Артикул = Р.Артикул;//ЭлектронныеДокументы.НормализоватьСтрокуАртикула(Р.АртикулПоставщика);
			//	Область.Параметры.Изготовитель = Р.ИзготовительПоставщика;
			//	Область.Параметры.МинКолПартии = Р.МинКолПартии;
			//	Область.Параметры.ЦенаСтарая = Р.ЦенаСтарая;
			//	Область.Параметры.ПроцентОтклонения = Р.ПроцентОтклонения;
			//	ТабДокумент.Вывести(Область);
			//	
			//КонецЕсли;			
			
		КонецЦикла;
		
	//КонецЕсли;
	
	Возврат ТабДокумент;
		
КонецФункции

Функция СформироватьРезультатПереоценки(текДокумент) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	П.Регистратор,
	|	П.Склад.Наименование КАК Склад,
	|	П.Номенклатура,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА П.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА П.СуммаРубли / П.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЦенаСтарая,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА П.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА П.СуммаРубли / П.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЦенаНовая,
	|	СУММА(ВЫБОР
	|			КОГДА П.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА П.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ П
	|ИЗ
	|	РегистрНакопления.ПартииТоваров КАК П
	|ГДЕ
	|	П.Регистратор = &ТекДокумент
	|	И П.Склад.СкладVMI
	|
	|СГРУППИРОВАТЬ ПО
	|	П.Регистратор,
	|	П.Склад,
	|	П.Номенклатура,
	|	П.Склад.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	П.Склад КАК Склад,
	|	Д.НоменклатураПоставщика.АртикулПоставщика КАК АртикулПоставщика,
	|	Д.НоменклатураПоставщика.ИзготовительПоставщика КАК ИзготовительПоставщика,
	|	П.ЦенаСтарая,
	|	П.ЦенаНовая,
	|	П.Количество
	|ИЗ
	|	П КАК П
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереоценкаОстатковПоставщика.ТоварыПоставщика КАК Д
	|		ПО П.Регистратор = Д.Ссылка
	|			И П.Номенклатура = Д.НоменклатураПоставщика.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склад,
	|	АртикулПоставщика,
	|	ИзготовительПоставщика
	|ИТОГИ ПО
	|	Склад"
	);
	Запрос.УстановитьПараметр("ТекДокумент", текДокумент);
	
	Р = Запрос.Выполнить();
	Если Р.Пустой() Тогда
		Возврат Новый Структура("ФайлыЕсть, СписокДокументов", Ложь, Неопределено);
		
	КонецЕсли;
	
	СписокДокументов = Новый ТаблицаЗначений;
	СписокДокументов.Колонки.Добавить("МаскаФайла");
	СписокДокументов.Колонки.Добавить("ИмяФайла");
	СписокДокументов.Колонки.Добавить("ТабДокумент");
	
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(текДокумент, "Дата,Номер");
	МаскаИмениФайла = Строка(Год(Реквизиты.Дата)) + "_" + Строка(Месяц(Реквизиты.Дата)) + "_" + Строка(День(Реквизиты.Дата));
	МаскаИмениФайла = СтрЗаменить(МаскаИмениФайла, " ", "");
	МаскаИмениФайла = МаскаИмениФайла + Реквизиты.Номер;
	
	Выборка = Р.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Склад");
	Пока Выборка.Следующий() Цикл
		НаименованиеСклада = СокрЛП(Выборка.Склад);
		НаименованиеСклада = СтрЗаменить(НаименованиеСклада, " ", "_");
				
		ТабДокумент = Новый ТабличныйДокумент;
		Макет = ПолучитьМакет("СписокПереоцененныхПартий");
		Область = Макет.ПолучитьОбласть("Шапка");
		ТабДокумент.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Строка");
		ВыборкаСтрок = Выборка.Выбрать();
		Пока ВыборкаСтрок.Следующий() Цикл
			Область.Параметры.АртикулПоставщика = ВыборкаСтрок.АртикулПоставщика;
			Область.Параметры.ИзготовительПоставщика = ВыборкаСтрок.ИзготовительПоставщика;
			Область.Параметры.ЦенаСтарая = ВыборкаСтрок.ЦенаСтарая;
			Область.Параметры.ЦенаНовая = ВыборкаСтрок.ЦенаНовая;
			Область.Параметры.Количество = ВыборкаСтрок.Количество;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
		
		нс = СписокДокументов.Добавить();
		нс.МаскаФайла = МаскаИмениФайла;
		нс.ИмяФайла = МаскаИмениФайла + "_" + НаименованиеСклада + ".xls";
		нс.ТабДокумент = ТабДокумент;
		
	КонецЦикла;
	
	Возврат Новый Структура("ФайлыЕсть, СписокДокументов", Истина, СписокДокументов);
			
КонецФункции

Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.ПереоценкаОстатковПоставщика;
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Если (вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом83_77) тогда
		Результат = ОбменДаннымиКлиентСервер.РеквизитыКонтроляПоДокументу(ПолучитьМетаданные(), ИсключаемыеРеквизитыКонтроляРегистрации());
	Иначе
		Результат.Вставить("Шапка", "Дата,Проведен");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр);
КонецФункции

Функция ИсключаемыеРеквизитыКонтроляРегистрации() Экспорт
	
	ИсключаемыеРеквизиты = ОбменДаннымиКлиентСервер.ИнициализироватьТаблицуИсключаемыхРеквизитовКонтроля();
	ОбменДаннымиКлиентСервер.ДобавитьВИсключаемыеРевизиты(ИсключаемыеРеквизиты, "Ссылка");
	
	Возврат ИсключаемыеРеквизиты;
	
КонецФункции
