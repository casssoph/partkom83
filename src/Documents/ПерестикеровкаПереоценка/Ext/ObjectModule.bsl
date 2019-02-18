﻿Перем мВалютаРегламентированногоУчета Экспорт;
Перем мМенеджерОбъекта;

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьПроведение(Ссылка, Отказ, лПараметры);
	
	// ЛНА, Замер  APDEX ++(
	Попытка		
		APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("ПерестикеровкаПереоценка_Проведение", "Кол-во строк: "+Товары.Количество(), , Ссылка);
	Исключение
	КонецПопытки;
	//)--


КонецПроцедуры// ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьОтменуПроведения(Ссылка, Отказ, лПараметры);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	лКлючАлгоритма = "Документ_ПерестикеровкаПереоценка_МодульОбъекта_ПередЗаписью";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	// ЛНА, Замер  APDEX ++(
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПерестикеровкаПереоценка_Проведение");
		
	КонецЕсли;
	
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияПриСдвигеДаты(ЭтотОбъект, РежимЗаписи, "ТоварыНаСкладах");
	
	Для Каждого Товар Из Товары Цикл
		Если НЕ ЗначениеЗаполнено(Товар.ЕдиницаИзмерения) тогда
			Товар.ЕдиницаИзмерения = Товар.Номенклатура.ЕдиницаХраненияОстатков;
			Товар.Коэффициент = Товар.ЕдиницаИзмерения.Коэффициент;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Товар.ЕдиницаИзмеренияНовая) тогда
			Товар.ЕдиницаИзмеренияНовая = Товар.НоменклатураНовая.ЕдиницаХраненияОстатков;
			Товар.КоэффициентНовый = Товар.ЕдиницаИзмеренияНовая.Коэффициент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ЭтоНовый() Тогда 
		СсылкаНаДокумент = ЭтотОбъект.ПолучитьСсылкуНового();
		
		Если СсылкаНаДокумент.Пустая() Тогда 
			СсылкаНаДокумент = Документы.ПерестикеровкаПереоценка.ПолучитьСсылку();
			ЭтотОбъект.УстановитьСсылкуНового(СсылкаНаДокумент);
		КонецЕсли;
	Иначе
		СсылкаНаДокумент = ЭтотОбъект.Ссылка;
	КонецЕсли;
	
	
	//НайденныеСтроки = Товары.НайтиСтроки(Новый Структура("СтрокаПриходаОприходованная", Справочники.ИдентификаторыСтрокПриходов.ПустаяСсылка()));
	
	Для Каждого СтрокаТЧ Из Товары Цикл 
		
		Если  ЗначениеЗаполнено(СтрокаТЧ.СтрокаПриходаОприходованная)
			И ОбщегоНазначения.СсылкаСуществует(СтрокаТЧ.СтрокаПриходаОприходованная) Тогда
			Продолжить;
		КонецЕсли;
		
		лСсылкаСтрокаПриходов = Справочники.ИдентификаторыСтрокПриходов.ПолучитьСсылку();
		лСтрокаПрихода = Справочники.ИдентификаторыСтрокПриходов.СоздатьЭлемент();
		лСтрокаПрихода.УстановитьСсылкуНового(лСсылкаСтрокаПриходов);
		лСтрокаПрихода.Приход = СсылкаНаДокумент;
		лСтрокаПрихода.Наименование = лСсылкаСтрокаПриходов.УникальныйИдентификатор();
		Если ЗначениеЗаполнено(СтрокаТЧ.СтрокаПрихода) Тогда 
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТЧ.СтрокаПрихода, "НомерГТД,СтранаПроисхождения,ТорговаяТочка,ДоговорКонтрагента");
			ЗаполнитьЗначенияСвойств(лСтрокаПрихода, Реквизиты);
		КонецЕсли;
		лСтрокаПрихода.Дата = ЭтотОбъект.Дата;
		лСтрокаПрихода.Записать();
		
		СтрокаТЧ.СтрокаПриходаОприходованная = лСтрокаПрихода.Ссылка;
	КонецЦикла;
	
	//Если НЕ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
	//    Сообщить("Изменить документ вручную пока невозможно.");
	//	Отказ = Истина;
	//КонецЕсли;
	
	Если ВидОперации <> Перечисления.ВидыОперацийУценки.Перестикеровка Тогда
		Запрос = Новый Запрос(
		
		);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АктРассмотренияВозврата)
		И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СтатусАРВ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АктРассмотренияВозврата, "СтатусДокумента");
		Если СтатусАРВ = Справочники.СтатусыДокументов.АРВ_ГВДозаполнить
			ИЛИ  СтатусАРВ = Справочники.СтатусыДокументов.АРВ_СкладПерестикеровкаУценка Тогда
			РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.Добавить(
			АктРассмотренияВозврата,
			Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ОбработатьЭтапПроцесса,
			СтатусАРВ);			
		КонецЕсли;		
	КонецЕсли;
	
	//По одному акту нельзя вводить несколько документов
	Если ЗначениеЗаполнено(АктРассмотренияВозврата) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПерестикеровкаПереоценка.Ссылка
		|ИЗ
		|	Документ.ПерестикеровкаПереоценка КАК ПерестикеровкаПереоценка
		|ГДЕ
		|	ПерестикеровкаПереоценка.АктРассмотренияВозврата = &АктРассмотренияВозврата
		|	И ПерестикеровкаПереоценка.Ссылка <> &Ссылка";
		
		Запрос.УстановитьПараметр("АктРассмотренияВозврата", АктРассмотренияВозврата);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() > 0 Тогда
			Отказ = Истина;
			ВызватьИсключение "По документу """+АктРассмотренияВозврата+""" уже создан документ перестикеровки!";
		КонецЕсли;
	КонецЕсли;


	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	СозданВ77 = Ложь;
	АктРассмотренияВозврата = Документы.АктРассмотренияВозврата.ПустаяСсылка();
	СтатусДокумента = Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаНовый;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктРассмотренияВозврата") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктРассмотренияВозврата.КодВозврата КАК КодВозврата,
		|	АктРассмотренияВозврата.Организация КАК Организация,
		|	АктРассмотренияВозврата.Ссылка КАК АктРассмотренияВозврата,
		|	АктРассмотренияВозврата.ДокументПродажи.Склад,
		|	АктРассмотренияВозврата.СуммаВключаетНДС,
		|	АктРассмотренияВозврата.УчитыватьНДС
		|ИЗ
		|	Документ.АктРассмотренияВозврата КАК АктРассмотренияВозврата
		|	ГДЕ Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		Результат = Запрос.Выполнить();
		Шапка = Результат.Выбрать();
		Шапка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
		
		Если Шапка.КодВозврата = Справочники.КодыВозврата.Перестикеровать Тогда
			ВидОперации = Перечисления.ВидыОперацийУценки.Перестикеровка;
		ИначеЕсли Шапка.КодВозврата = Справочники.КодыВозврата.Уценка Тогда
			ВидОперации = Перечисления.ВидыОперацийУценки.Уценка;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийУценки.Уценка;
		КонецЕсли;
		
		ВалютаДокумента 	= ПараметрыСеанса.ВалютаРубль;
		КурсДокумента		= 1;
		КратностьДокумента	= 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	АктРассмотренияВозвратаТовары.Качество,
		|	АктРассмотренияВозвратаТовары.ЕдиницаИзмерения,
		|	АктРассмотренияВозвратаТовары.Коэффициент,
		|	АктРассмотренияВозвратаТовары.КоличествоРазмещено КАК КоличествоПлан,
		|	АктРассмотренияВозвратаТовары.КоличествоРазмещено КАК Количество,
		|	АктРассмотренияВозвратаТовары.Цена КАК ЦенаСтарая,
		|	АктРассмотренияВозвратаТовары.СтрокаЗаявки КАК СтрокаЗаявки,
		|	АктРассмотренияВозвратаТовары.СтрокаПрихода,
		|	АктРассмотренияВозвратаТовары.Ссылка.КодСписания КАК КодСписания,
		|	ВЫБОР
		|		КОГДА АктРассмотренияВозвратаТовары.Ссылка.КодВозврата = &КодВозвратаУценка
		|			ТОГДА АктРассмотренияВозвратаТовары.ЦенаПослеУценки
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЦенаНовая
		|ИЗ
		|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
		|ГДЕ
		|	АктРассмотренияВозвратаТовары.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("КодВозвратаУценка", Справочники.КодыВозврата.Уценка);
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		РезультатЗапроса = Запрос.Выполнить();
		Товары.Загрузить(РезультатЗапроса.Выгрузить())		
		
	КонецЕсли;
	
	СтатусДокумента = Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаНовый;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
КонецПроцедуры


Функция ВсеПлановоеКоличествоРазмещено() Экспорт
	
	ВсеПлановоеКоличествоРазмещено = Истина;
	Для каждого СтрокаТЧ Из Товары Цикл
		
		Если СтрокаТЧ.Количество <> СтрокаТЧ.КоличествоПлан Тогда
			ВсеПлановоеКоличествоРазмещено = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВсеПлановоеКоличествоРазмещено;
	
КонецФункции

Процедура ЗаполнитьРазмещенноеКоличество(ТекстОшибки = "", СообщатьОбОшибке = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РазмещениеТоваровОбороты.Номенклатура,
		|	РазмещениеТоваровОбороты.Качество,
		|	РазмещениеТоваровОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.РазмещениеТоваров.Обороты(, , , ДокументОснование = &ДокументОснование) КАК РазмещениеТоваровОбороты";
	
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаОстатков = РезультатЗапроса.Выгрузить();
	
	лТекстОшибки = "";
	СтруктураОтбора = Новый Структура("Номенклатура, Качество");
	Для каждого СтрокаТЧ Из Товары Цикл
		
		СтрокаТЧ.Количество = 0;
		
		СтруктураОтбора.Номенклатура = СтрокаТЧ.НоменклатураНовая;
		СтруктураОтбора.Качество 	 = СтрокаТЧ.КачествоНовый;
		СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураОтбора);
		
		Размещено = 0;
		Если СтрокиОстатков.Количество() Тогда
			Размещено = СтрокиОстатков[0].Количество;			
		КонецЕсли;
		
		Если Размещено <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Списать = Мин(Размещено, СтрокаТЧ.Количество);
		
		СтрокаТЧ.Количество = Списать;
		СтрокиОстатков[0].Количество = СтрокиОстатков[0].Количество - Списать;
		
	КонецЦикла;
	
	//Излишки размещения кинем на первую попавшуюся партию
	Для каждого СтрокаОстатков Из ТаблицаОстатков Цикл
		
		Если СтрокаОстатков.Количество <= 0 Тогда
			Продолжить;
		КонецЕсли;
		СтруктураОтбора = Новый Структура("НоменклатураНовая, КачествоНовый");
		СтруктураОтбора.НоменклатураНовая = СтрокаОстатков.Номенклатура;
		СтруктураОтбора.КачествоНовый 	  = СтрокаОстатков.Качество;
		
		СтрокиТоваров =  Товары.НайтиСтроки(СтруктураОтбора);
		Если СтрокиТоваров.Количество() Тогда
			СтрокиТоваров[0].Количество = СтрокиТоваров[0].Количество + СтрокаОстатков.Количество;
		Иначе
			//Размещена строка, которой нет в документе возврата от покупателя
			лТекстОшибки = "В документе возврата отсутствует размещенная строка:
							| Номенклатура: "+СтрокаОстатков.Номенклатура+", Качество: "+СтрокаОстатков.Качество+", Строка заявки: "+СтрокаОстатков.СтрокаЗаявки+", Количество: "+СтрокаОстатков.Количество;
			
		КонецЕсли;
	
	КонецЦикла;
	
	ТекстОшибки = ТекстОшибки + ?(ЗначениеЗаполнено(ТекстОшибки), Символы.ПС, "") + лТекстОшибки;
	
	Если СообщатьОбОшибке и ЗначениеЗаполнено(лТекстОшибки) Тогда
		 Сообщить(ТекстОшибки, СтатусСообщения.Важное);		
	КонецЕсли;
	
	
КонецПроцедуры




мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мМенеджерОбъекта = Документы[Метаданные().Имя];