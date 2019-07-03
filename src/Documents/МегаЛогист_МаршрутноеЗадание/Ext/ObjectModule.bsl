﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
//
// Параметры:
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа.
//  Отказ - флаг отказа в проведении.
//  Заголовок - заголовок сообщения об ошибках.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить.
	СтруктураОбязательныхПолей = Новый Структура;

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ДвиженияПоРегиструДокументыМаршрутныхЗаданий(СтруктураШапкиДокумента, ТаблицаПоДокументам, Отказ, Заголовок)

	НаборДвижений	= Движения.МегаЛогист_ДокументыМаршрутныхЗаданий;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();

	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоДокументам, ТаблицаДвижений);
	Для Каждого тСтрока Из ТаблицаДвижений Цикл
		тСтрока.Регистратор = Ссылка;
	КонецЦикла;

	НаборДвижений.мПериод          	= Дата;
	НаборДвижений.мТаблицаДвижений	= ТаблицаДвижений;
	НаборДвижений.Записывать		= Истина;

	Если Не Отказ Тогда
		Движения.МегаЛогист_ДокументыМаршрутныхЗаданий.ВыполнитьДвижения();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегиструДокументыМаршрутныхЗаданий()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередУстановкойПометкиУдаления(Отказ) 
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		МаршрутныйЛист = МегаЛогист_УправлениеДоставкой.ПолучитьМаршрутныйЛистПоЗаданию(Ссылка);
		Если ЗначениеЗаполнено(МаршрутныйЛист) Тогда
			Сообщить("Установка пометки невозможна! Задание включено в маршрутный лист - " + Строка(МаршрутныйЛист), СтатусСообщения.Важное);
			Отказ = Истина;
			Возврат;
		КонецЕсли;  
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();

	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.КРаспределению;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ПриЗаписи".
//
Процедура ПриЗаписи(Отказ)
	
	лКлючАлгоритма = "Документ_МегаЛогист_МаршрутноеЗадание_МодульОбъекта_ПриЗаписи";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
		
    Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИсторияСтатусовМаршрутныхЗаданийСрезПоследних.МаршрутноеЗадание,
	               |	ИсторияСтатусовМаршрутныхЗаданийСрезПоследних.Статус
	               |ИЗ
	               |	РегистрСведений.МегаЛогист_ИсторияСтатусовМаршрутныхЗаданий.СрезПоследних(, МаршрутноеЗадание = &МаршрутноеЗадание) КАК ИсторияСтатусовМаршрутныхЗаданийСрезПоследних";
	Запрос.УстановитьПараметр("МаршрутноеЗадание" ,Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Статус = Статус Тогда
		Возврат;
	КонецЕсли;
	
	мзСМЗ = РегистрыСведений.МегаЛогист_ИсторияСтатусовМаршрутныхЗаданий.СоздатьМенеджерЗаписи();
	мзСМЗ.Период			= ТекущаяДата();
	мзСМЗ.МаршрутноеЗадание = Ссылка;
	мзСМЗ.Статус			= Статус;
	мзСМЗ.Ответственный		= ПараметрыСеанса.ТекущийПользователь;
	Попытка
		мзСМЗ.Записать();
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
		Отказ = Истина;
	КонецПопытки;
	
	Если Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Отменен Тогда 
		Мегалогист_Партком.ЭкспрессДоставка_cancel(Ссылка);
	КонецЕсли;
		
КонецПроцедуры

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	///////////////////////////////////////////
	//Мироненко Д.С 27.11.2017 10:10:29 НАЧАЛО
	//Комментарий: 
	ЗаполнитьТребования(ДанныеЗаполнения);
	//Мироненко Д.С 27.11.2017 10:10:34 КОНЕЦ
	///////////////////////////////////////////
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Номер = "";
		ЗаказПокупателя = ДанныеЗаполнения.Ссылка;
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			Возврат;
		КонецЕсли;
		Дата=ТекущаяДата();
	 	ТипКИ						= Перечисления.ТипыКонтактнойИнформации.Телефон;
		ВидОсновногоТелефона		= ПолучитьВидКИ(Перечисления.ТипыКонтактнойИнформации.Телефон, "Основной телефон");
		ЗаписьОсновногоТелефона 	= ПолучитьЗаписьКИ(ТипКИ, ВидОсновногоТелефона, КонтактноеЛицоКонтрагента);
	    Телефон						= ЗаписьОсновногоТелефона.Представление;
	    //АдресДоставки				= УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдресаПоСтрока(ЗаказПокупателя.АдресДоставки);
		ДатаДоставки				= ЗаказПокупателя.ДатаОтгрузки;	
		//ДополнениеКАдресуДоставки	= ЗаказПокупателя.ДополнениеКАдресуДоставки;
		Статус						= Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.КРаспределению;
		Ответственный				= глЗначениеПеременной("глТекущийПользователь");
		ТипЗадания					= Справочники.МегаЛогист_ТипыМаршрутныхЗаданий.ДоставкаДоКлиента;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей.ДатаДоставки,
		               |	МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей.ВремяДоставкиС,
		               |	МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей.ВремяДоставкиПо,
		               |	МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей.Курьер
		               |ИЗ
		               |	РегистрСведений.МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей КАК МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей
		               |ГДЕ
		               |	МегаЛогист_ДополнительныеРеквизитыЗаказовПокупателей.Заказ = &ЗаказПокупателя";
		Запрос.УстановитьПараметр("ЗаказПокупателя"	, ЗаказПокупателя);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ВремяДоставкиС		= Выборка.ВремяДоставкиС;	
			ВремяДоставкиПо		= Выборка.ВремяДоставкиПо;	
			Курьер				= Выборка.Курьер;			
		КонецЕсли;
		
        ЗаполнитьДокументыРеализации();
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Сделка)
		И ТипЗнч(ДанныеЗаполнения.Сделка) = Тип("ДокументСсылка.ЗаявкаПокупателя")Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.Сделка);
		Номер = "";
		ЗаказПокупателя = ДанныеЗаполнения.Сделка;
	
		Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.КРаспределению;
		Ответственный  = глЗначениеПеременной("глТекущийПользователь"); 
        ЗаполнитьДокументыВозврата();
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	// Сформируем структуру реквизитов шапки документа.
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");

	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Документ"              , "ДокументСсылка");
	
	РезультатЗапросаПоДокументамРеализации = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ДокументыРеализации", СтруктураПолей);
	ТаблицаПоДокументамРеализации = РезультатЗапросаПоДокументамРеализации.Выгрузить();
	
	РезультатЗапросаПоДокументамВозврата = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ДокументыВозврата", СтруктураПолей);
	ТаблицаПоДокументамВозврата = РезультатЗапросаПоДокументамВозврата.Выгрузить();
	
	ДвиженияПоРегиструДокументыМаршрутныхЗаданий(СтруктураШапкиДокумента, ТаблицаПоДокументамРеализации, Отказ, Заголовок);
	ДвиженияПоРегиструДокументыМаршрутныхЗаданий(СтруктураШапкиДокумента, ТаблицаПоДокументамВозврата, Отказ, Заголовок);
	
	///////////////////////////////////////////
	//Мироненко Д.С 27.11.2017 10:26:29 НАЧАЛО
	//Комментарий: 
	
	ДвижениеПоРегиструТребований();
	
	//Мироненко Д.С 27.11.2017 10:26:31 КОНЕЦ
	///////////////////////////////////////////
			
КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	
	///////////////////////////////////////////
	//Мироненко Д.С 27.11.2017 10:23:31 НАЧАЛО
	//Комментарий: 
	
	УдалениеТребований(Ссылка);
	
	//Мироненко Д.С 27.11.2017 10:23:32 КОНЕЦ
	///////////////////////////////////////////

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ПересчитатьСуммуНаличныхКПолучению()

	СуммаНаличныхКПолучению = 0;
	
	Если Не ЗначениеЗаполнено(ЗаказПокупателя) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумента = ЗаказПокупателя.Метаданные();
	Если НЕ ОбщегоНазначения.ЕстьРеквизитДокумента("СтруктурнаяЕдиница", МетаданныеДокумента) Тогда
		Возврат;
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(ЗаказПокупателя.СтруктурнаяЕдиница) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЗаказПокупателя.СтруктурнаяЕдиница) <> Тип("СправочникСсылка.Кассы") Тогда
		Возврат;
	КонецЕсли;
	
	СуммаНаличныхКПолучению = ДокументыРеализации.Итог("СуммаДокумента");
	
КонецПроцедуры

Процедура ПересчитатьСуммуНаличныхКВозврату()

	СуммаНаличныхКВозврату = 0;
	
	Если Не ЗначениеЗаполнено(ЗаказПокупателя) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумента = ЗаказПокупателя.Метаданные();
	Если НЕ ОбщегоНазначения.ЕстьРеквизитДокумента("СтруктурнаяЕдиница", МетаданныеДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЗаказПокупателя.СтруктурнаяЕдиница) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЗаказПокупателя.СтруктурнаяЕдиница) <> Тип("СправочникСсылка.Кассы") Тогда
		Возврат;
	КонецЕсли;
	
	СуммаНаличныхКВозврату = ДокументыВозврата.Итог("СуммаДокумента");
	
КонецПроцедуры

Процедура ЗаполнитьДокументыРеализации() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК ДокументСсылка,
	               |	РеализацияТоваровУслуг.Дата,
	               |	РеализацияТоваровУслуг.Номер,
	               |	РеализацияТоваровУслуг.СуммаДокумента
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МегаЛогист_ДокументыМаршрутныхЗаданий КАК МегаЛогист_ДокументыМаршрутныхЗаданий
	               |		ПО РеализацияТоваровУслуг.Ссылка = МегаЛогист_ДокументыМаршрутныхЗаданий.Документ
	               |			И (МегаЛогист_ДокументыМаршрутныхЗаданий.Регистратор <> &МаршрутноеЗадание)
	               |ГДЕ
	               |	РеализацияТоваровУслуг.ДокументОснование = &Сделка
	               |	И РеализацияТоваровУслуг.Проведен = ИСТИНА
	               |	И МегаЛогист_ДокументыМаршрутныхЗаданий.Документ ЕСТЬ NULL ";
	Запрос.УстановитьПараметр("Сделка"				,ЗаказПокупателя);
	Запрос.УстановитьПараметр("МаршрутноеЗадание"	,Ссылка);
	тбзДок = Запрос.Выполнить().Выгрузить();
	ДокументыРеализации.Загрузить(тбзДок);
	ПересчитатьСуммуНаличныхКПолучению();
	
КонецПроцедуры // ЗаполнитьПоЗаказу()

Процедура ЗаполнитьДокументыВозврата() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВозвратТоваровОтПокупателя.Ссылка КАК ДокументСсылка,
	               |	ВозвратТоваровОтПокупателя.Дата,
	               |	ВозвратТоваровОтПокупателя.Номер,
	               |	ВозвратТоваровОтПокупателя.СуммаДокумента
	               |ИЗ
	               |	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МегаЛогист_ДокументыМаршрутныхЗаданий КАК МегаЛогист_ДокументыМаршрутныхЗаданий
	               |		ПО (МегаЛогист_ДокументыМаршрутныхЗаданий.Документ = ВозвратТоваровОтПокупателя.Ссылка)
	               |			И (МегаЛогист_ДокументыМаршрутныхЗаданий.Регистратор = &МаршрутноеЗадание)
	               |ГДЕ
	               |	(ВозвратТоваровОтПокупателя.Сделка = &Сделка
	               |			ИЛИ ВозвратТоваровОтПокупателя.Сделка.Сделка = &Сделка)
	               |	И ВозвратТоваровОтПокупателя.Проведен = ИСТИНА
	               |	И МегаЛогист_ДокументыМаршрутныхЗаданий.Документ ЕСТЬ NULL ";
	Запрос.УстановитьПараметр("Сделка"	,ЗаказПокупателя);
	Запрос.УстановитьПараметр("МаршрутноеЗадание"	,Ссылка);
	тбзДок = Запрос.Выполнить().Выгрузить();
	ДокументыВозврата.Загрузить(тбзДок);
	ПересчитатьСуммуНаличныхКВозврату();
	
КонецПроцедуры

Функция ПолучитьВидКИ(ТипКИ, ВидКИ) Экспорт
	
	СправочникВКИ = Справочники.ВидыКонтактнойИнформации;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыКонтактнойИнформации.Ссылка
	               |ИЗ
	               |	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	               |ГДЕ
	               //|	ВидыКонтактнойИнформации.ВидОбъектаКонтактнойИнформации = &ВидОбъектаКонтактнойИнформации
	               |	ВидыКонтактнойИнформации.Тип = &Тип
	               |	И ВидыКонтактнойИнформации.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("ВидОбъектаКонтактнойИнформации",Перечисления.ВидыОбъектовКонтактнойИнформации.КонтактныеЛицаКонтрагентов);
	Запрос.УстановитьПараметр("Тип",ТипКИ);
	Запрос.УстановитьПараметр("Наименование",ВидКИ);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ВидКонтактнойИнформации = Выборка.Ссылка;
	Иначе
	//НайденныйЭлемент = СправочникВКИ.НайтиПоНаименованию(ВидКИ, Истина);
	//Если НайденныйЭлемент.Пустая() Тогда
		//НовыйЭлемент = СправочникВКИ.СоздатьЭлемент();
		//НовыйЭлемент.Наименование = ВидКИ;
		//НовыйЭлемент.Тип = ТипКИ;
		//НовыйЭлемент.ВидОбъектаКонтактнойИнформации = Перечисления.ВидыОбъектовКонтактнойИнформации.КонтактныеЛицаКонтрагентов;
		//НовыйЭлемент.Записать();
		//
		//ВидКонтактнойИнформации = НовыйЭлемент.Ссылка;
	//Иначе
	//	ВидКонтактнойИнформации = НайденныйЭлемент;	
	КонецЕсли;
	
	Возврат ВидКонтактнойИнформации;
	
КонецФункции

Функция ПолучитьЗаписьКИ(ТипКИ, ВидКИ, Клиент) Экспорт
	
	НаборЗаписейКИ = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	НаборЗаписейКИ.Отбор.Объект.Установить(Клиент);
	НаборЗаписейКИ.Отбор.Тип.Установить(ТипКИ);
	НаборЗаписейКИ.Отбор.Вид.Установить(ВидКИ);
	НаборЗаписейКИ.Прочитать();
	
	Если НаборЗаписейКИ.Количество()=1 Тогда
		ЗаписьКИ = НаборЗаписейКИ[0];
	Иначе
		ЗаписьКИ = НаборЗаписейКИ.Добавить();
		ЗаписьКИ.Объект = Клиент;
		ЗаписьКИ.Тип = ТипКИ;
		ЗаписьКИ.Вид = ВидКИ;
	КонецЕсли;
	
	Возврат ЗаписьКИ;
	
КонецФункции

///////////////////////////////////////////
//Мироненко Д.С 27.11.2017 10:01:01 НАЧАЛО
//Комментарий: Процедура заполнения требований

Процедура ЗаполнитьТребования(ДанныеЗаполнения)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Мегалогист_ТребованияКЗаказам.Требование
	|ИЗ
	|	РегистрСведений.Мегалогист_ТребованияКЗаказам КАК Мегалогист_ТребованияКЗаказам
	|ГДЕ
	|	Мегалогист_ТребованияКЗаказам.Заказ = &Заказ";
	
	Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
	
	Результат = Запрос.Выполнить();
	ТребованияКТС.Загрузить(Результат.Выгрузить());
	

КонецПроцедуры

Процедура УдалениеТребований(СсылкаНаДокумент)

	НаборЗаписей = РегистрыСведений.Мегалогист_ТребованияКЗаказам.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Заказ.Значение 		= СсылкаНаДокумент;
	НаборЗаписей.Отбор.Заказ.Использование 	= Истина;
	
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура ДвижениеПоРегиструТребований()

	НаборЗаписей = РегистрыСведений.Мегалогист_ТребованияКЗаказам.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Заказ.Значение 		= Ссылка;
	НаборЗаписей.Отбор.Заказ.Использование 	= Истина;
	
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	ТребованияКТС.Свернуть("Требование");
	Для каждого СтрокаТЧ Из ТребованияКТС Цикл
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.Заказ = Ссылка;
		НоваяСтрока.Требование = СтрокаТЧ.Требование;
	КонецЦикла;
	НаборЗаписей.Записать();


КонецПроцедуры


//Мироненко Д.С 27.11.2017 10:01:39 КОНЕЦ
///////////////////////////////////////////

мТекущийКурьер = Неопределено;
