﻿Перем мМенеджерОбъекта;

Процедура ПриКопировании(ОбъектКопирования)
	СозданВ77 = Ложь;
	СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяНовый;//VMI-17
КонецПроцедуры

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер,Дата,СтатусДокумента");
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВозвратТоваровОтПокупателяТовары.СтрокаЗаявки КАК СтрокаЗаявки,
		               |	СУММА(ВозвратТоваровОтПокупателяТовары.Количество) КАК Количество
		               |ПОМЕСТИТЬ втВозвраты
		               |ИЗ
		               |	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
		               |ГДЕ
		               |	ВозвратТоваровОтПокупателяТовары.Ссылка.ДокументОснование = &Ссылка
		               |	И ВозвратТоваровОтПокупателяТовары.Ссылка.Проведен
		               |	И ВозвратТоваровОтПокупателяТовары.Ссылка.СтатусДокумента = &СтатусДокумента
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ВозвратТоваровОтПокупателяТовары.СтрокаЗаявки
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	СтрокаЗаявки
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслугТовары.Номенклатура,
		               |	РеализацияТоваровУслугТовары.Качество,
		               |	РеализацияТоваровУслугТовары.Количество - ЕСТЬNULL(втВозвраты.Количество, 0) КАК КоличествоПлан,
		               |	РеализацияТоваровУслугТовары.ЕдиницаИзмерения,
		               |	РеализацияТоваровУслугТовары.Коэффициент,
		               |	РеализацияТоваровУслугТовары.Цена,
		               |	РеализацияТоваровУслугТовары.Сумма * РеализацияТоваровУслугТовары.Количество - ЕСТЬNULL(втВозвраты.Количество, 0) / РеализацияТоваровУслугТовары.Количество КАК Сумма,
		               |	РеализацияТоваровУслугТовары.СтавкаНДС,
		               |	РеализацияТоваровУслугТовары.СуммаНДС * РеализацияТоваровУслугТовары.Количество - ЕСТЬNULL(втВозвраты.Количество, 0) / РеализацияТоваровУслугТовары.Количество КАК СуммаНДС,
		               |	РеализацияТоваровУслугТовары.СтрокаЗаявки,
		               |	РеализацияТоваровУслугТовары.КомментарийИзСайта,
		               |	РеализацияТоваровУслугТовары.IDSite,
		               |	РеализацияТоваровУслугТовары.ПроцентСкидкиНаценки,
		               |	РеализацияТоваровУслугТовары.Количество - ЕСТЬNULL(втВозвраты.Количество, 0) КАК Количество
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		               |		ЛЕВОЕ СОЕДИНЕНИЕ втВозвраты КАК втВозвраты
		               |		ПО РеализацияТоваровУслугТовары.СтрокаЗаявки = втВозвраты.СтрокаЗаявки
		               |ГДЕ
		               |	РеализацияТоваровУслугТовары.Ссылка = &Ссылка
		               |	И РеализацияТоваровУслугТовары.Количество - ЕСТЬNULL(втВозвраты.Количество, 0) > 0";
						//Запрос = Новый Запрос("ВЫБРАТЬ
						//                      |	РеализацияТоваровУслугТовары.Номенклатура,
						//                      |	РеализацияТоваровУслугТовары.Качество,
						//                      |	РеализацияТоваровУслугТовары.Количество,
						//                      |	РеализацияТоваровУслугТовары.ЕдиницаИзмерения,
						//                      |	РеализацияТоваровУслугТовары.Коэффициент,
						//                      |	РеализацияТоваровУслугТовары.Цена,
						//                      |	РеализацияТоваровУслугТовары.Сумма,
						//                      |	РеализацияТоваровУслугТовары.СтавкаНДС,
						//                      |	РеализацияТоваровУслугТовары.СуммаНДС,
						//                      |	РеализацияТоваровУслугТовары.СтрокаЗаявки КАК СтрокаЗаявки,
						//                      |	РеализацияТоваровУслугТовары.КомментарийИзСайта,
						//                      |	РеализацияТоваровУслугТовары.IDSite,
						//                      |	РеализацияТоваровУслугТовары.ПроцентСкидкиНаценки,
						//                      |	РеализацияТоваровУслугТовары.КоличествоПлан,
						//                      |	РеализацияТоваровУслугТовары.Ссылка
						//                      |ПОМЕСТИТЬ втТЧ
						//                      |ИЗ
						//                      |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
						//                      |ГДЕ
						//                      |	РеализацияТоваровУслугТовары.Ссылка = &Ссылка
						//                      |
						//                      |ИНДЕКСИРОВАТЬ ПО
						//                      |	СтрокаЗаявки
						//                      |;
						//                      |
						//                      |////////////////////////////////////////////////////////////////////////////////
						//                      |ВЫБРАТЬ
						//                      |	втТЧ.Номенклатура,
						//                      |	втТЧ.Качество,
						//                      |	втТЧ.Количество - ЕСТЬNULL(ТоварыКОтгрузкеОбороты.КоличествоОборот, 0) - ЕСТЬNULL(ПродажиОбороты.КоличествоВозвратОборот, 0) КАК Количество,
						//                      |	втТЧ.ЕдиницаИзмерения,
						//                      |	втТЧ.Коэффициент,
						//                      |	втТЧ.Цена,
						//                      |	втТЧ.Сумма * (втТЧ.Количество - ЕСТЬNULL(ТоварыКОтгрузкеОбороты.КоличествоОборот, 0) - ЕСТЬNULL(ПродажиОбороты.КоличествоВозвратОборот, 0)) / втТЧ.Количество КАК Сумма,
						//                      |	втТЧ.СтавкаНДС,
						//                      |	втТЧ.СуммаНДС * (втТЧ.Количество - ЕСТЬNULL(ТоварыКОтгрузкеОбороты.КоличествоОборот, 0) - ЕСТЬNULL(ПродажиОбороты.КоличествоВозвратОборот, 0)) / втТЧ.Количество КАК СуммаНДС,
						//                      |	втТЧ.СтрокаЗаявки,
						//                      |	втТЧ.КомментарийИзСайта,
						//                      |	втТЧ.IDSite,
						//                      |	втТЧ.ПроцентСкидкиНаценки,
						//                      |	втТЧ.Количество - ЕСТЬNULL(ТоварыКОтгрузкеОбороты.КоличествоОборот, 0) - ЕСТЬNULL(ПродажиОбороты.КоличествоВозвратОборот, 0) КАК КоличествоПлан,
						//                      |	втТЧ.Количество КАК КоличествоРеализации,
						//                      |	втТЧ.Сумма КАК СуммаРеализации,
						//                      |	втТЧ.Ссылка КАК Реализация
						//                      |ИЗ
						//                      |	втТЧ КАК втТЧ
						//                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке.Обороты(
						//                      |				НЕОПРЕДЕЛЕНО,
						//                      |				&ТекущаяДата,
						//                      |				,
						//                      |				СтрокаЗаявки В
						//                      |						(ВЫБРАТЬ
						//                      |							втТЧ.СтрокаЗаявки
						//                      |						ИЗ
						//                      |							втТЧ КАК втТЧ)
						//                      |					И Статус = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ВозвратТоваровОтПокупателя)) КАК ТоварыКОтгрузкеОбороты
						//                      |		ПО втТЧ.СтрокаЗаявки = ТоварыКОтгрузкеОбороты.СтрокаЗаявки
						//                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи.Обороты(
						//                      |				НЕОПРЕДЕЛЕНО,
						//                      |				&ТекущаяДата,
						//                      |				,
						//                      |				СтрокаЗаявки В
						//                      |						(ВЫБРАТЬ
						//                      |							втТЧ.СтрокаЗаявки
						//                      |						ИЗ
						//                      |							втТЧ КАК втТЧ)
						//                      |					И Статус = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслуг)) КАК ПродажиОбороты
						//                      |		ПО втТЧ.СтрокаЗаявки = ПродажиОбороты.СтрокаЗаявки
						//                      |ГДЕ
						//                      |	втТЧ.Количество - ЕСТЬNULL(ТоварыКОтгрузкеОбороты.КоличествоОборот, 0) - ЕСТЬNULL(ПродажиОбороты.КоличествоВозвратОборот, 0) > 0");
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		//Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
		Запрос.УстановитьПараметр("СтатусДокумента", Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяНовый;
		ДокументОснование = ДанныеЗаполнения;
		Дата = ТекущаяДата();
		ДополнительныеСвойства.Вставить("ВводНаОсновании");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
  ЭтотОбъект.ДополнительныеСвойства.Контроль.Вставить("НовыеЗначения",
	Новый Соответствие);
	ЭтотОбъект.ДополнительныеСвойства.Контроль.НовыеЗначения.Вставить(
	Метаданные.Последовательности.ПоРасчетамСКонтрагентами, 
	мМенеджерОбъекта.ПолучитьЗначенияРеквизитовКонтроля(ЭтотОбъект.Ссылка,
	Метаданные.Последовательности.ПоРасчетамСКонтрагентами));
	
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьПроведение(Ссылка, Отказ, лПараметры);
		
	Если Не глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам") Тогда 
		РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, "ПоРасчетамСКонтрагентами");
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьОтменуПроведения(Ссылка, Отказ, лПараметры);
		
	Если Не глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам") Тогда 
		РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, "ПоРасчетамСКонтрагентами");
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		//#XX-100 Kalinin V.A. ( 2018-06-15 )
	Если Не ЗначениеЗаполнено(Менеджер) тогда 
	ЗапросМенеджеров = новый  Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		                                 |	МенеджерыТорговыхТочекСрезПоследних.Менеджер
		                                 |ИЗ
		                                 |	РегистрСведений.МенеджерыТорговыхТочек.СрезПоследних(
		                                 |			,
		                                 |			ВидМенеджера = ЗНАЧЕНИЕ(Перечисление.ВидыМенеджеров.Продажи)
		                                 |				И ТорговаяТочка = &ТорговаяТочка) КАК МенеджерыТорговыхТочекСрезПоследних" );
		ЗапросМенеджеров.УстановитьПараметр("ТорговаяТочка",ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент,"ОсновнаяТорговаяТочка"));
		
		Результат = ЗапросМенеджеров.Выполнить();
		Если не Результат.Пустой() тогда 
			Выборка  = Результат.Выбрать();
			Выборка.Следующий();
			Менеджер = Выборка.Менеджер;
		КонецЕсли;
	КонецЕсли;		
	
	
		
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		СсылкаНаДокумент = ЭтотОбъект.ПолучитьСсылкуНового();
		Если СсылкаНаДокумент.Пустая() Тогда 
			СсылкаНаДокумент = Документы.ВозвратТоваровОтПокупателя.ПолучитьСсылку();
			ЭтотОбъект.УстановитьСсылкуНового(СсылкаНаДокумент);
		КонецЕсли;
	Иначе
		СсылкаНаДокумент = Ссылка;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда 	//Генерируем строки прихода для возврата товаров от покупателя без основания
		СтруктураПоиска = Новый Структура("СтрокаПрихода", Справочники.ИдентификаторыСтрокПриходов.ПустаяСсылка());
		НайденныеСтроки = Товары.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекСтрока Из НайденныеСтроки Цикл
			
			СсылкаНаОбъект = Справочники.ИдентификаторыСтрокПриходов.ПолучитьСсылку();

			НоваяСтрокаПрихода = Справочники.ИдентификаторыСтрокПриходов.СоздатьЭлемент();
			НоваяСтрокаПрихода.Дата = ЭтотОбъект.Дата;
			НоваяСтрокаПрихода.Приход = СсылкаНаДокумент;
			НоваяСтрокаПрихода.УстановитьСсылкуНового(СсылкаНаОбъект);
			НоваяСтрокаПрихода.Наименование = СсылкаНаОбъект.УникальныйИдентификатор();
			НоваяСтрокаПрихода.Записать();
			
			ТекСтрока.СтрокаПрихода = НоваяСтрокаПрихода.Ссылка;
			
		КонецЦикла;
	КонецЕсли;	

	//Если ОбменДанными.Загрузка  Тогда
	//	Возврат;
	//КонецЕсли;

	
	ЭтотОбъект.ДополнительныеСвойства.Очистить();
	ЭтотОбъект.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если (РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения) тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить("Контроль", Новый Структура);
		Если НЕ ЭтоНовый() тогда
			ЭтотОбъект.ДополнительныеСвойства.Контроль.Вставить("СтарыеЗначения", Новый Соответствие);
			ЭтотОбъект.ДополнительныеСвойства.Контроль.СтарыеЗначения.Вставить(
			Метаданные.Последовательности.ПоРасчетамСКонтрагентами, мМенеджерОбъекта.ПолучитьЗначенияРеквизитовКонтроля(
			ЭтотОбъект.Ссылка, Метаданные.Последовательности.ПоРасчетамСКонтрагентами));
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтатусДокумента) Тогда
		СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяНовый
	КонецЕсли;
	
	
	
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары");
	Если Лев(Номер,1)="D" Тогда 
		Сообщить("Документ создан в 1с7. В 1с8 его менять запрещено. Все изменения в 1с8 нужно так же выполнить и в 1с!");
		Если Не РольДоступна("полныеПрава") Тогда 
			Отказ=Истина;
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	Филиал = Справочники.Контрагенты.ФилиалКонтрагента(Контрагент);

КонецПроцедуры



Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	//ОбщегоНазначения.ДобавитьПрефиксОрганизации(ЭтотОбъект, Префикс);
	//ОбщегоНазначения.ДобавитьПрефиксУзла(Префикс);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка И НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		//если это мать его колобок, нужно получить из 1с7 документ основание
		СсылкаНаРеализацию = ПодключитьсяКБазеСемерки(Ссылка.УникальныйИдентификатор());
		Если Лев(СсылкаНаРеализацию, 1) = "{" Тогда
			СсылкаНаРеализацию = Прав(СсылкаНаРеализацию, СтрДлина(СсылкаНаРеализацию) - 1);
		КонецЕсли;
		Если Прав(СсылкаНаРеализацию, 1) = "}" Тогда
			СсылкаНаРеализацию = Лев(СсылкаНаРеализацию, СтрДлина(СсылкаНаРеализацию) - 1);
		КонецЕсли;
		Если СсылкаНаРеализацию <> Неопределено Тогда
			ДокОснование = Документы.РеализацияТоваровУслуг.ПолучитьСсылку(Новый УникальныйИдентификатор(СсылкаНаРеализацию));
			Если ЗначениеЗаполнено(ДокОснование) Тогда
				ДокументОснование = ДокОснование;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	  //Если РежимЗаписи = РежимЗаписиДокумента.Проведение тогда 
	КорректировкаСебестоимостиТоваров();
	//КонецЕсли;

	
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	ВозвратТоваровОтПокупателяТовары.СтрокаПрихода
	//               |ИЗ
	//               |	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
	//               |ГДЕ
	//               |	ВозвратТоваровОтПокупателяТовары.Ссылка = &Ссылка
	//               |	И ВозвратТоваровОтПокупателяТовары.СтрокаПрихода.Приход = ЗНАЧЕНИЕ(Документ.ВозвратТоваровОтПокупателя.ПустаяСсылка)";
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	
	//	Объект = Выборка.СтрокаПрихода.ПолучитьОбъект();
	//	Объект.Приход = Ссылка;
	//	Объект.Записать();
	//	
	//КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Организация");
	ПроверяемыеРеквизиты.Добавить("Контрагент");
	ПроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");
	ПроверяемыеРеквизиты.Добавить("Склад");
	ПроверяемыеРеквизиты.Добавить("Товары.Количество");
	ПроверяемыеРеквизиты.Добавить("Товары.Цена");
	ПроверяемыеРеквизиты.Добавить("Товары.Сумма");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура КорректировкаСебестоимостиТоваров() Экспорт 
//# Kalinin V.A. ( 2018-06-30 )
ЗапросСценами = новый Запрос("ВЫБРАТЬ
                             |	ВозвратТоваровОтПокупателяТовары.Номенклатура,
                             |	ВозвратТоваровОтПокупателяТовары.Качество,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.Склад,
                             |	ВозвратТоваровОтПокупателяТовары.СтрокаЗаявки,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.ТорговаяТочка,
                             |	СУММА(ВозвратТоваровОтПокупателяТовары.Количество) КАК КоличествоВозврат,
                             |	СУММА(ВозвратТоваровОтПокупателяТовары.Сумма) КАК СуммаРеглВозврат,
                             |	СУММА(ВозвратТоваровОтПокупателяТовары.Сумма) КАК СуммаУпрВозврат,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка КАК Регистратор,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.Дата КАК Период,
                             |	СРЕДНЕЕ(ВозвратТоваровОтПокупателяТовары.Себестоимость) КАК Себестоимость,
                             |	ВозвратТоваровОтПокупателяТовары.СебестоимостьЦена
                             |ПОМЕСТИТЬ ВтДанные
                             |ИЗ
                             |	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
                             |ГДЕ
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка = &Ссылка
                             |	И ВозвратТоваровОтПокупателяТовары.Себестоимость = 0
                             |
                             |СГРУППИРОВАТЬ ПО
                             |	ВозвратТоваровОтПокупателяТовары.Номенклатура,
                             |	ВозвратТоваровОтПокупателяТовары.Качество,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.Склад,
                             |	ВозвратТоваровОтПокупателяТовары.СтрокаЗаявки,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.ТорговаяТочка,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка,
                             |	ВозвратТоваровОтПокупателяТовары.Ссылка.Дата,
                             |	ВозвратТоваровОтПокупателяТовары.СебестоимостьЦена
                             |;
                             |
                             |////////////////////////////////////////////////////////////////////////////////
                             |ВЫБРАТЬ
                             |	СРЕДНЕЕ(Продажи.СебестоимостьРубли / Продажи.Количество) КАК Себестоимость,
                             |	Продажи.Номенклатура
                             |ПОМЕСТИТЬ ВтПродажи
                             |ИЗ
                             |	РегистрНакопления.Продажи КАК Продажи
                             |ГДЕ
                             |	Продажи.Регистратор = ВЫРАЗИТЬ(&Ссылка КАК Документ.ВозвратТоваровОтПокупателя).ДокументОснование
                             |
                             |СГРУППИРОВАТЬ ПО
                             |	Продажи.Номенклатура
                             |;
                             |
                             |////////////////////////////////////////////////////////////////////////////////
                             |ВЫБРАТЬ
                             |	ВтДанные.Номенклатура,
                             |	ВтДанные.Качество,
                             |	ВтДанные.Склад,
                             |	ВтДанные.СтрокаЗаявки,
                             |	ВтДанные.ТорговаяТочка,
                             |	ВтДанные.КоличествоВозврат,
                             |	ВтДанные.СуммаРеглВозврат,
                             |	ВтДанные.СуммаУпрВозврат,
                             |	ВтДанные.Регистратор,
                             |	ВтДанные.Период,
                             |	ВЫБОР
                             |		КОГДА ВтДанные.Себестоимость = 0
                             |			ТОГДА ЕСТЬNULL(ВтПродажи.Себестоимость, 0) * ВтДанные.КоличествоВозврат
                             |		ИНАЧЕ ВтДанные.Себестоимость
                             |	КОНЕЦ КАК Себестоимость,
                             |	ВЫБОР
                             |		КОГДА ВтДанные.СебестоимостьЦена = 0
                             |			ТОГДА ЕСТЬNULL(ВтПродажи.Себестоимость, 0)
                             |		ИНАЧЕ ВтДанные.СебестоимостьЦена
                             |	КОНЕЦ КАК СебестоимостьЦена
                             |ПОМЕСТИТЬ ВТДанныеИПродажи
                             |ИЗ
                             |	ВтДанные КАК ВтДанные
                             |		ЛЕВОЕ СОЕДИНЕНИЕ ВтПродажи КАК ВтПродажи
                             |		ПО ВтДанные.Номенклатура = ВтПродажи.Номенклатура
                             |;
                             |
                             |////////////////////////////////////////////////////////////////////////////////
                             |ВЫБРАТЬ
                             |	ПартииТоваров.Номенклатура,
                             |	МАКСИМУМ(ПартииТоваров.СуммаРубли / ПартииТоваров.Количество) КАК СебестоимостьЦена
                             |ПОМЕСТИТЬ ЦенаПартии
                             |ИЗ
                             |	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
                             |ГДЕ
                             |	ПартииТоваров.ВидДвижения = ЗНАЧЕНИЕ(виддвижениянакопления.ПРИХОД)
                             |	И ПартииТоваров.Номенклатура В
                             |			(ВЫБРАТЬ
                             |				ВТДанныеИПродажи.Номенклатура КАК Номенклатура
                             |			ИЗ
                             |				ВТДанныеИПродажи КАК ВТДанныеИПродажи
                             |			ГДЕ
                             |				ВТДанныеИПродажи.Себестоимость = 0)
                             |	И ПартииТоваров.Период <= &Момент
                             |	И ПартииТоваров.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
                             |
                             |СГРУППИРОВАТЬ ПО
                             |	ПартииТоваров.Номенклатура
                             |;
                             |
                             |////////////////////////////////////////////////////////////////////////////////
                             |ВЫБРАТЬ
                             |	ВТДанныеИПродажи.Номенклатура,
                             |	ВТДанныеИПродажи.Качество,
                             |	ВТДанныеИПродажи.Склад,
                             |	ВТДанныеИПродажи.СтрокаЗаявки,
                             |	ВТДанныеИПродажи.ТорговаяТочка,
                             |	ВТДанныеИПродажи.КоличествоВозврат,
                             |	ВТДанныеИПродажи.СуммаРеглВозврат,
                             |	ВТДанныеИПродажи.СуммаУпрВозврат,
                             |	ВТДанныеИПродажи.Регистратор,
                             |	ВТДанныеИПродажи.Период,
                             |	ВЫБОР
                             |		КОГДА ВТДанныеИПродажи.Себестоимость = 0
                             |			ТОГДА ЦенаПартии.СебестоимостьЦена * ВТДанныеИПродажи.КоличествоВозврат
                             |		ИНАЧЕ ВТДанныеИПродажи.Себестоимость
                             |	КОНЕЦ КАК Себестоимость,
                             |	ВЫБОР
                             |		КОГДА ВТДанныеИПродажи.СебестоимостьЦена = 0
                             |			ТОГДА ЦенаПартии.СебестоимостьЦена
                             |		ИНАЧЕ ВТДанныеИПродажи.СебестоимостьЦена
                             |	КОНЕЦ КАК СебестоимостьЦена
                             |ИЗ
                             |	ВТДанныеИПродажи КАК ВТДанныеИПродажи
                             |		ЛЕВОЕ СОЕДИНЕНИЕ ЦенаПартии КАК ЦенаПартии
                             |		ПО ВТДанныеИПродажи.Номенклатура = ЦенаПартии.Номенклатура
                             |			И (ВТДанныеИПродажи.Себестоимость = 0)" );

	ЗапросСценами.УстановитьПараметр("Момент",Дата);
	ЗапросСценами.УстановитьПараметр("Ссылка",Ссылка);
	Выборка =  ЗапросСценами.Выполнить().Выбрать();
	Пока выборка.Следующий() цикл 
	 СтрокиТоваров = Товары.НайтиСтроки(Новый Структура("Номенклатура",Выборка.Номенклатура));
	 Для Каждого СтрокаТоваров из СтрокиТоваров цикл 
	 ЗаполнитьЗначенияСвойств(СтрокаТоваров,Выборка,"СебестоимостьЦена,Себестоимость");
	КонецЦикла;				
	КонецЦикла;				
		

	
	
	
КонецПроцедуры	
	
Функция ПолучитьЗаписиПоследовательности(вхПоследовательность) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лМетаданныеДокумента = Метаданные();
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лЭтоОтменаПроведения = Ложь;
	лРежимЗаписи = Неопределено;
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("РежимЗаписи", лРежимЗаписи) тогда
		лЭтоОтменаПроведения = (лРежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
	
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		Если НЕ лЭтоОтменаПроведения И (ЭтотОбъект.СуммаДокумента <> 0) И ЭтотОбъект.Дата >= ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты Тогда
			лСтрокаРезультат = лРезультат.Добавить();
			лСтрокаРезультат.ДоговорКонтрагента = ЭтотОбъект.ДоговорКонтрагента;
			лСтрокаРезультат.Период = ЭтотОбъект.Дата;
			лСтрокаРезультат.Регистратор = ЭтотОбъект.Ссылка;
		КонецЕсли;
		
		Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
		
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СформироватьТекстЗапроса(ГУИД_Документа)
	
	ТекстЗапроса = 
	"select
	|	g2.[_Id] as СсылкаНаРеализацию
	|from
	|	[Work_P1C].[dbo].[adoURBD_Guids] as g1
	|	inner join DH1656 as d on g1.[_Object] = d.IDDOC
	|	inner join [Work_P1C].[dbo].[adoURBD_Guids] as g2 on right(d.SP1633, 9) = g2.[_Object]
	|	
	|where
	|	(g1.[_MetaType] = 12) and (g1.[_MetaId] = 1656) and (g1.[_Id] = '" + ГУИД_Документа + "')
	|	and (left(d.SP1633, 4) = ' 18R')
	|	and (g2.[_MetaType] = 12) and (g2.[_MetaId] = 1611)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПодключитьсяКБазеСемерки(ГУИД_Документа) 
	СсылкаНаРеализацию = Неопределено;
	
	стрПодключения = "Provider=SQLOLEDB;Data Source=1CSQL01-G9;Initial Catalog=Work_P1C;Integrated Security=SSPI";
	
	Попытка
		Connection = Новый COMОбъект("ADODB.Connection");
		Connection.ConnectionString = стрПодключения;
		Connection.ConnectionTimeOut = 15;
		
		Connection.Open(Connection.ConnectionString);
		
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат СсылкаНаРеализацию;
		
	КонецПопытки;
	
	RS = Новый COMОбъект("ADODB.Recordset");
	
	RS.Open(СформироватьТекстЗапроса(ГУИД_Документа), Connection);
		
	Пока RS.EOF() = 0 Цикл
		СсылкаНаРеализацию = RS.Fields("СсылкаНаРеализацию").Value;
					
		RS.MoveNext();
		
	КонецЦикла;
	
	RS.Close();
	Connection.Close(); 
	
	Возврат СсылкаНаРеализацию;
	
КонецФункции
#КонецОбласти

мМенеджерОбъекта = Документы[Метаданные().Имя];
