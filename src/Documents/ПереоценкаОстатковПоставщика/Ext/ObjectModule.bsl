﻿Перем мМенеджерОбъекта;
//Рудаков регистрация отправки сообщения поставщику
Перем мЗарегистрироватьИзмененияДляОтправкиНаПочту;
//Рудаков Конец

Процедура ОбновитьТаблицуТоваров(вхТовары) Экспорт
	Товары.Очистить();
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(вхТовары, Товары);
	
КонецПроцедуры

Процедура ОбновитьНоменклатуруПоставщика() Экспорт
	Если ТоварыПоставщика.Количество() > 0 Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТП.АртикулПоставщика,
		|	ТП.ИзготовительПоставщика,
		|	ТП.Цена
		|ПОМЕСТИТЬ ТП
		|ИЗ
		|	&ТП КАК ТП
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТП.АртикулПоставщика,
		|	ТП.ИзготовительПоставщика,
		|	НК.Ссылка КАК НоменклатураПоставщика,
		|	ТП.Цена
		|ПОМЕСТИТЬ ТЧ
		|ИЗ
		|	ТП КАК ТП
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НК
		|		ПО ТП.АртикулПоставщика = НК.АртикулПоставщика
		|			И ТП.ИзготовительПоставщика = НК.ИзготовительПоставщика
		|ГДЕ
		|	НК.Владелец = &Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЧ.АртикулПоставщика,
		|	ТЧ.ИзготовительПоставщика,
		|	ТЧ.НоменклатураПоставщика,
		|	ТЧ.Цена,
		|	ЕСТЬNULL(Р.Цена, 0) КАК ЦенаСтарая
		|ИЗ
		|	ТЧ КАК ТЧ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(&НачалоДня, ) КАК Р
		|		ПО ТЧ.НоменклатураПоставщика = Р.Номенклатура"
		);
	
		Запрос.УстановитьПараметр("ТП", ТоварыПоставщика);
		Запрос.УстановитьПараметр("Владелец", Контрагент);
		Запрос.УстановитьПараметр("НачалоДня", НачалоДня(Дата));
	
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество() > 0 Тогда
			ТоварыПоставщика.Очистить();
			ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Результат, ТоварыПоставщика);
			
		КонецЕсли;
		
		Для Каждого Товар Из ТоварыПоставщика Цикл
			Если Товар.ЦенаСтарая = 0 Тогда
				//возможно прайс еще не загружался
				Товар.ПроцентОтклонения = 0;
			Иначе
				ТекПроцентОтклонения = (Товар.Цена - Товар.ЦенаСтарая)/Товар.ЦенаСтарая * 100;
				Если ТекПроцентОтклонения < 0 Тогда
					ТекПроцентОтклонения = - ТекПроцентОтклонения;
				КонецЕсли;
				Товар.ПроцентОтклонения = ТекПроцентОтклонения;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Товары.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьПроведение(Ссылка, Отказ, лПараметры);
	
	// ЛНА, Замер  APDEX ++(
	Попытка		
		APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("ПереоценкаОстатковПоставщика_Проведение", СокрЛП(Ссылка));
	Исключение
	КонецПопытки;
	//)--
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	лПараметры = Новый Структура;
	лПараметры.Вставить("ДанныеОбъекта", ЭтотОбъект.ДополнительныеСвойства);
	мМенеджерОбъекта.ВыполнитьОтменуПроведения(Ссылка, Отказ, лПараметры);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// ЛНА, Замер  APDEX ++(
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПереоценкаОстатковПоставщика_Проведение");
		
	КонецЕсли;
	//)--
	
	Дата = КонецДня(Дата);
	
	//При загрузке из ОП номенклатура уже определена и повторно можно не делать,
	//интерактивной загрузки пока нет - PaSe
	//ОбновитьНоменклатуруПоставщика();
	//Для Каждого Товар Из ТоварыПоставщика Цикл
	//	Если Товар.НеПереоценивать Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	МинПартия = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Товар.НоменклатураПоставщика, "МинКолПартии");
	//	Если МинПартия = 0 Тогда
	//		Товар.НеПереоценивать = Истина;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	мЗарегистрироватьИзмененияДляОтправкиНаПочту = Ложь;
	
	Если Дата >= Константы.ДатаЗаявкиСоздаютсяВ83.Получить() Тогда
				
		мЗарегистрироватьИзмененияДляОтправкиНаПочту = Истина;
		
	КонецЕсли;
	
	//Добавлено Валиахметов А.А. 07.03.2018 PK83-283				
	ОбщегоНазначения.ЗаполнитьДопСвойстваДокумента(ЭтотОбъект, РежимЗаписи);
	//Конец Добавлено Валиахметов А.А. 07.03.2018
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если мЗарегистрироватьИзмененияДляОтправкиНаПочту Тогда
		ЭлектронныеДокументы.ЗарегистрироватьДляОтправкиПочты(Ссылка);
				
	КонецЕсли;
	
КонецПроцедуры

мМенеджерОбъекта = Документы[Метаданные().Имя];

