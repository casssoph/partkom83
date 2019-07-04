﻿Процедура ЗаполнитьОтчет(СтруктураОтчета) Экспорт
	
	СтруктураОтчета.ТабличныйДокумент.Очистить();
	ПроверкаЗаполненияПараметров(СтруктураОтчета);
	Если НЕ СтруктураОтчета.Ошибка Тогда
		СформироватьОтчет(СтруктураОтчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаЗаполненияПараметров(СтруктураОтчета)
	
	//Если заполнен договор, контролируем //
	Если ЗначениеЗаполнено(Договор) Тогда
		Если ЗначениеЗаполнено(Организация) И Организация <> Договор.Организация Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = "Указанная организация не соответствует организации договора" + Символы.ПС;
		КонецЕсли;
		// + 20181009 Пушкин XX-1047
		//Если ЗначениеЗаполнено(Контрагент) И Контрагент <> Договор.Владелец Тогда
		Если Контрагент.Количество() > 0 И Контрагент.НайтиПоЗначению(Договор.Владелец) = Неопределено Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = СтруктураОтчета.ТекстОшибки + "Указанный контрагент не соответствует владельцу договора" + Символы.ПС;
		КонецЕсли;
		//Контрагент = Договор.Владелец;
		Если Контрагент.НайтиПоЗначению(Договор.Владелец) = Неопределено тогда
			Контрагент.Добавить(Договор.Владелец);
		КонецЕсли;
		// - 20181009 Пушкин XX-1047
		Организация = Договор.Организация;
	КонецЕсли;
	
КонецПроцедуры
Процедура СформироватьОтчет(СтруктураОтчета)
	
	Состояние("Вывод отчета..");
	СтруктураОтчета.Вставить("Макет", ПолучитьМакет("Макет"));
	ДанныеОтчета = ДанныеДляОтчета(СтруктураОтчета);
		
	ВывестиШапку(СтруктураОтчета);
	ОбходПоОрганизации(СтруктураОтчета, ДанныеОтчета);
	
КонецПроцедуры

Процедура ВывестиШапку(СтруктураОтчета)
	
	ПредставлениеОтбора = "";
	Если ЗначениеЗаполнено(Организация) Тогда
		ПредставлениеОтбора = ПредставлениеОтбора + Символы.ПС + "Организация: " + Организация;
	КонецЕсли;
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ПредставлениеОтбора = ПредставлениеОтбора + Символы.ПС + "Контрагент: " + Контрагент;
	КонецЕсли;
	Если ЗначениеЗаполнено(Договор) Тогда
		ПредставлениеОтбора = ПредставлениеОтбора + Символы.ПС + "Договор: " + Договор + "(" + Договор.Код + ")";
	КонецЕсли;
	ПредставлениеОтбора = ПредставлениеОтбора + Символы.ПС + "Период: " + ПредставлениеПериода(НачалоПериода, КонецДня(ОкончаниеПериода), "ДФ=dd.MM.yyyy");
	
	Шапка = "Организация";
	Если СтруктураОтчета.ОтражатьКонтрагентов Тогда
		Шапка = Шапка + ", Контрагент";
	КонецЕсли;
	Если СтруктураОтчета.ОтражатьДоговор Тогда
		Шапка = Шапка + ", Договор";
	КонецЕсли;
	Шапка = Шапка + ", Документ";
	ОбластьШапка = СтруктураОтчета.Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ЗаголовокШапки = Шапка;
	ОбластьШапка.Параметры.ПредставлениеОтбора = ПредставлениеОтбора;
	СтруктураОтчета.ТабличныйДокумент.Вывести(ОбластьШапка);
	
КонецПроцедуры
Процедура ОбходПоОрганизации(СтруктураОтчета, Выборка)
	
	Пока Выборка.Следующий() Цикл
		СтрокаОрганизация = СтруктураОтчета.Макет.ПолучитьОбласть("СтрокаОрганизация");
		ЗаполнитьЗначенияСвойств(СтрокаОрганизация.Параметры, Выборка, "Организация,ОрганизацияПредставление,Дебет,Кредит");
		
		СтруктураОтчета.ТабличныйДокумент.Вывести(СтрокаОрганизация);
		СтруктураОтчета.ТабличныйДокумент.НачатьГруппуСтрок();
		
		ОбходПоКонтрагенту(СтруктураОтчета, Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), СтрокаОрганизация);
		
		//Меняем строку организации(с проставленными суммами)
		УстановитьСальдо(СтрокаОрганизация.Параметры.НачальныйОстатокДт, СтрокаОрганизация.Параметры.НачальныйОстатокКт, СтрокаОрганизация.Параметры.НачальныйОстатокДт - СтрокаОрганизация.Параметры.НачальныйОстатокКт);
		УстановитьСальдо(СтрокаОрганизация.Параметры.КонечныйОстатокДт, СтрокаОрганизация.Параметры.КонечныйОстатокКт, СтрокаОрганизация.Параметры.КонечныйОстатокДт - СтрокаОрганизация.Параметры.КонечныйОстатокКт);
		СтруктураОтчета.ТабличныйДокумент.ВставитьОбласть(СтрокаОрганизация.Области.СтрокаОрганизация, СтруктураОтчета.ТабличныйДокумент.Области.СтрокаОрганизация,,Истина);
		СтруктураОтчета.ТабличныйДокумент.ЗакончитьГруппуСтрок();
	КонецЦикла;
	
КонецПроцедуры
Процедура ОбходПоКонтрагенту(СтруктураОтчета, Выборка, СтрокаОрганизация)
	
	Пока Выборка.Следующий() Цикл
		
		КА.Добавить(Выборка.Контрагент);
		//Сообщить(Выборка.Контрагент);
		
		СтрокаКонтрагент = СтруктураОтчета.Макет.ПолучитьОбласть("СтрокаКонтрагент");
		ЗаполнитьЗначенияСвойств(СтрокаКонтрагент.Параметры, Выборка, "Контрагент,КонтрагентПредставление,Дебет,Кредит");
		Если СтруктураОтчета.ОтражатьКонтрагентов Тогда
			СтруктураОтчета.ТабличныйДокумент.Вывести(СтрокаКонтрагент);
			СтруктураОтчета.ТабличныйДокумент.НачатьГруппуСтрок();
		КонецЕсли;

		ОбходПоДоговору(СтруктураОтчета, Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), СтрокаКонтрагент);
		
		//Меняем строку контрагента(с проставленными суммами)
		УстановитьСальдо(СтрокаКонтрагент.Параметры.НачальныйОстатокДт, СтрокаКонтрагент.Параметры.НачальныйОстатокКт, СтрокаКонтрагент.Параметры.НачальныйОстатокДт - СтрокаКонтрагент.Параметры.НачальныйОстатокКт);
		УстановитьСальдо(СтрокаКонтрагент.Параметры.КонечныйОстатокДт, СтрокаКонтрагент.Параметры.КонечныйОстатокКт, СтрокаКонтрагент.Параметры.КонечныйОстатокДт - СтрокаКонтрагент.Параметры.КонечныйОстатокКт);
		Если СтруктураОтчета.ОтражатьКонтрагентов Тогда
			СтруктураОтчета.ТабличныйДокумент.ВставитьОбласть(СтрокаКонтрагент.Области.СтрокаКонтрагент, СтруктураОтчета.ТабличныйДокумент.Области.СтрокаКонтрагент,,Истина);
			СтруктураОтчета.ТабличныйДокумент.ЗакончитьГруппуСтрок();
		КонецЕсли;
		
		СуммироватьСальдоПоГруппе(СтрокаОрганизация.Параметры, СтрокаКонтрагент.Параметры);
	КонецЦикла;
	
КонецПроцедуры
Процедура ОбходПоДоговору(СтруктураОтчета, Выборка, СтрокаКонтрагент)
	
	Пока Выборка.Следующий() Цикл

		СтрокаДоговор = СтруктураОтчета.Макет.ПолучитьОбласть("СтрокаДоговор");
		ЗаполнитьЗначенияСвойств(СтрокаДоговор.Параметры, Выборка);
		НачальныйОстатокПоДоговору = Выборка.НачальныйОстатокПоДоговору;
		КонечныйОстатокПоДоговору = Выборка.НачальныйОстатокПоДоговору + Выборка.Дебет - Выборка.Кредит;
		УстановитьСальдо(СтрокаДоговор.Параметры.КонечныйОстатокДт, СтрокаДоговор.Параметры.КонечныйОстатокКт, КонечныйОстатокПоДоговору);
		
		Если СтруктураОтчета.ОтражатьДоговор Тогда
			СтруктураОтчета.ТабличныйДокумент.Вывести(СтрокаДоговор);
			СтруктураОтчета.ТабличныйДокумент.НачатьГруппуСтрок();
		КонецЕсли;
		
		ОбходПоДокументам(СтруктураОтчета, Выборка.Выбрать(), НачальныйОстатокПоДоговору);
		
		Если СтруктураОтчета.ОтражатьДоговор Тогда
			СтруктураОтчета.ТабличныйДокумент.ЗакончитьГруппуСтрок();
		КонецЕсли;
		СуммироватьСальдоПоГруппе(СтрокаКонтрагент.Параметры, СтрокаДоговор.Параметры);
	КонецЦикла;
	
КонецПроцедуры
Процедура ОбходПоДокументам(СтруктураОтчета, Выборка, ОстатокПоДоговору)

	Пока Выборка.Следующий() Цикл
		
		//{{ХудинВВ 20180618 jira XX-156
		Если ЗначениеЗаполнено(Выборка.СчетФактура) Тогда
			Документ 				= Выборка.СчетФактура;
		    ДокументПредставление 	= Выборка.СчетФактураПредставление;
		Иначе
			Документ 				= Выборка.Документ;
		    ДокументПредставление 	= Выборка.ДокументПредставление;
		КонецЕсли;
		//}}
		
		СтрокаДокумент = СтруктураОтчета.Макет.ПолучитьОбласть("СтрокаДокумент");
		ЗаполнитьЗначенияСвойств(СтрокаДокумент.Параметры, Выборка, "Дебет,Кредит");
		
		СтрокаДокумент.Параметры.Документ = Документ;
		СтрокаДокумент.Параметры.ДокументДата = ?(ЗначениеЗаполнено(Документ) И ЗначениеЗаполнено(Документ.Дата), Документ.Дата, "");
		СтрокаДокумент.Параметры.ДокументПредставление = ПредставлениеДокумента(Документ, ДокументПредставление);
		УстановитьСальдо(СтрокаДокумент.Параметры.НачальныйОстатокДт, СтрокаДокумент.Параметры.НачальныйОстатокКт, ОстатокПоДоговору);
		ОстатокПоДоговору = ОстатокПоДоговору + Выборка.Дебет - Выборка.Кредит;
		УстановитьСальдо(СтрокаДокумент.Параметры.КонечныйОстатокДт, СтрокаДокумент.Параметры.КонечныйОстатокКт, ОстатокПоДоговору);
		СтруктураОтчета.ТабличныйДокумент.Вывести(СтрокаДокумент);
		Если ЗначениеЗаполнено(Выборка.СчетФактура) И ВыводитьСчетаФактуры Тогда
			СтрокаСчетФактура = СтруктураОтчета.Макет.ПолучитьОбласть("СтрокаСчетФактура");
			ЗаполнитьЗначенияСвойств(СтрокаСчетФактура.Параметры, Выборка);
			СтрокаСчетФактура.Параметры.СчетФактураПредставление = ПредставлениеДокумента(Выборка.СчетФактура, Выборка.СчетФактураПредставление);
			СтруктураОтчета.ТабличныйДокумент.Вывести(СтрокаСчетФактура);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция ДанныеДляОтчета(СтруктураОтчета)
	
	лКлючАлгоритма = "Справочник_ЗадачиJira_МодульОбъекта_ДанныеДляОтчета";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
		
	КА.Очистить();
	
	Состояние("Запрос..");
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДепозитыКонтрагентовОстатки.ДоговорКонтрагента,
	                      |	ДепозитыКонтрагентовОстатки.СуммаУпрОстаток КАК Сумма
	                      |ПОМЕСТИТЬ НачальныйОстаток
	                      |ИЗ
	                      |	РегистрНакопления.ДепозитыКонтрагентов.Остатки(
	                      |			&НачалоПериода,
	                      |			ИСТИНА = ИСТИНА
	                      |				И &СУчетомДепозита) КАК ДепозитыКонтрагентовОстатки
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ВзаиморасчетыОстатки.ДоговорКонтрагента,
	                      |	ВзаиморасчетыОстатки.СуммаУпрОстаток
	                      |ИЗ
	                      |	РегистрНакопления.Взаиморасчеты.Остатки(&НачалоПериода, ИСТИНА = ИСТИНА) КАК ВзаиморасчетыОстатки
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	НачальныйОстаток.ДоговорКонтрагента,
	                      |	СУММА(НачальныйОстаток.Сумма) КАК Сумма
	                      |ПОМЕСТИТЬ НачальныйОстатокПоДоговору
	                      |ИЗ
	                      |	НачальныйОстаток КАК НачальныйОстаток
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	НачальныйОстаток.ДоговорКонтрагента
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВзаиморасчетыОбороты.Период КАК Дата,
	                      |	ВзаиморасчетыОбороты.ДоговорКонтрагента,
	                      |	ВзаиморасчетыОбороты.Регистратор КАК Документ,
	                      |	ВзаиморасчетыОбороты.СуммаУпрПриход КАК Дебет,
	                      |	ВзаиморасчетыОбороты.СуммаУпрРасход КАК Кредит
	                      |ПОМЕСТИТЬ Обороты
	                      |ИЗ
	                      |	РегистрНакопления.Взаиморасчеты.Обороты(&НачалоПериода, &КонецПериода, Регистратор, ИСТИНА = ИСТИНА) КАК ВзаиморасчетыОбороты
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	ДепозитыКонтрагентовОбороты.Период,
	                      |	ДепозитыКонтрагентовОбороты.ДоговорКонтрагента,
	                      |	ДепозитыКонтрагентовОбороты.Регистратор,
	                      |	ДепозитыКонтрагентовОбороты.СуммаУпрПриход,
	                      |	ДепозитыКонтрагентовОбороты.СуммаУпрРасход
	                      |ИЗ
	                      |	РегистрНакопления.ДепозитыКонтрагентов.Обороты(
	                      |			&НачалоПериода,
	                      |			&КонецПериода,
	                      |			Регистратор,
	                      |			ИСТИНА = ИСТИНА
	                      |				И &СУчетомДепозита) КАК ДепозитыКонтрагентовОбороты
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Обороты.Документ,
	                      |	МАКСИМУМ(СчетФактураВыданныйДокументыОснования.Ссылка) КАК СчетФактура
	                      |ПОМЕСТИТЬ ВсеСчетаФактуры
	                      |ИЗ
	                      |	Обороты КАК Обороты
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	                      |		ПО Обороты.Документ = СчетФактураВыданныйДокументыОснования.ДокументОснование
	                      //|ГДЕ
	                     // |	НЕ СчетФактураВыданныйДокументыОснования.Ссылка.ПометкаУдаления
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Обороты.Документ
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	Обороты.Документ,
	                      |	МАКСИМУМ(СчетФактураПолученныйДокументыОснования.Ссылка)
	                      |ИЗ
	                      |	Обороты КАК Обороты
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураПолученныйДокументыОснования
	                      |		ПО Обороты.Документ = СчетФактураПолученныйДокументыОснования.ДокументОснование
	                    //  |ГДЕ
	                    //  |	НЕ СчетФактураПолученныйДокументыОснования.Ссылка.ПометкаУдаления
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Обороты.Документ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВсеСчетаФактуры.Документ,
	                      |	МАКСИМУМ(ВсеСчетаФактуры.СчетФактура) КАК СчетФактура
	                      |ПОМЕСТИТЬ СчетаФактурыПоДокументам
	                      |ИЗ
	                      |	ВсеСчетаФактуры КАК ВсеСчетаФактуры
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ВсеСчетаФактуры.Документ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента.Организация, Обороты.ДоговорКонтрагента.Организация) КАК Организация,
	                      |	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента.Организация, Обороты.ДоговорКонтрагента.Организация)) КАК ОрганизацияПредставление,
	                      |	ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента.Владелец, Обороты.ДоговорКонтрагента.Владелец) КАК Контрагент,
	                      |	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента.Владелец, Обороты.ДоговорКонтрагента.Владелец)) КАК КонтрагентПредставление,
	                      |	ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента, Обороты.ДоговорКонтрагента) КАК ДоговорКонтрагента,
	                      |	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(НачальныйОстатокПоДоговору.ДоговорКонтрагента, Обороты.ДоговорКонтрагента)) КАК ДоговорКонтрагентаПредставление,
	                      |	ЕСТЬNULL(НачальныйОстатокПоДоговору.Сумма, 0) КАК НачальныйОстатокПоДоговору,
	                      |	Обороты.Документ,
	                      |	ПРЕДСТАВЛЕНИЕ(Обороты.Документ) КАК ДокументПредставление,
	                      |	ЕСТЬNULL(СчетаФактурыПоДокументам.СчетФактура, ЗНАЧЕНИЕ(Документ.СчетФактураВыданный.ПустаяСсылка)) КАК СчетФактура,
	                      |	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(СчетаФактурыПоДокументам.СчетФактура, ЗНАЧЕНИЕ(Документ.СчетФактураВыданный.ПустаяСсылка))) КАК СчетФактураПредставление,
	                      |	Обороты.Дата КАК Дата,
	                      |	ЕСТЬNULL(Обороты.Дебет, 0) КАК Дебет,
	                      |	ЕСТЬNULL(Обороты.Кредит, 0) КАК Кредит,
	                      |	ВЫБОР
	                      |		КОГДА ЕСТЬNULL(НачальныйОстатокПоДоговору.Сумма, 0) > 0
	                      |			ТОГДА ЕСТЬNULL(НачальныйОстатокПоДоговору.Сумма, 0)
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК НачальныйОстатокДт,
	                      |	ВЫБОР
	                      |		КОГДА ЕСТЬNULL(НачальныйОстатокПоДоговору.Сумма, 0) < 0
	                      |			ТОГДА -ЕСТЬNULL(НачальныйОстатокПоДоговору.Сумма, 0)
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК НачальныйОстатокКт
	                      |ИЗ
	                      |	НачальныйОстатокПоДоговору КАК НачальныйОстатокПоДоговору
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ Обороты КАК Обороты
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ СчетаФактурыПоДокументам КАК СчетаФактурыПоДокументам
	                      |			ПО Обороты.Документ = СчетаФактурыПоДокументам.Документ
	                      |		ПО НачальныйОстатокПоДоговору.ДоговорКонтрагента = Обороты.ДоговорКонтрагента
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата
	                      |ИТОГИ
	                      |	МАКСИМУМ(НачальныйОстатокПоДоговору),
	                      |	СУММА(Дебет),
	                      |	СУММА(Кредит),
	                      |	МАКСИМУМ(НачальныйОстатокДт),
	                      |	МАКСИМУМ(НачальныйОстатокКт)
	                      |ПО
	                      |	Организация,
	                      |	Контрагент,
	                      |	ДоговорКонтрагента");

	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИСТИНА = ИСТИНА", УсловиеОтбора(СтруктураОтчета));
	Запрос.УстановитьПараметр("СУчетомДепозита", СУчетомДепозита);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВыводитьСчетаФактуры", ВыводитьСчетаФактуры);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ОкончаниеПериода));
	
	Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
КонецФункции
Функция УсловиеОтбора(СтруктураОтчета)
	
	СтруктураОтчета.Вставить("ОтражатьКонтрагентов", НЕ ЗначениеЗаполнено(Контрагент));
	СтруктураОтчета.Вставить("ОтражатьДоговор", Истина);
	
	Если ЗначениеЗаполнено(Договор) Тогда
		Условие = "ДоговорКонтрагента = &Договор";
		СтруктураОтчета.ОтражатьДоговор = Ложь;
	Иначе
		КонтрагентЗаполнен = ЗначениеЗаполнено(Контрагент);
		ОрганизацияЗаполнена = ЗначениеЗаполнено(Организация);
		// + 20181009 Пушкин XX-1047
		Если КонтрагентЗаполнен И ОрганизацияЗаполнена Тогда
			//Условие = "ДоговорКонтрагента.Организация = &Организация И ДоговорКонтрагента.Владелец = &Контрагент";
			Условие = "ДоговорКонтрагента.Организация = &Организация И ДоговорКонтрагента.Владелец В ИЕРАРХИИ (&Контрагент)";
		ИначеЕсли КонтрагентЗаполнен Тогда
			//Условие = "ДоговорКонтрагента.Владелец = &Контрагент"
			Условие = "ДоговорКонтрагента.Владелец В ИЕРАРХИИ (&Контрагент)"
		// - 20181009 Пушкин XX-1047	
		ИначеЕсли ОрганизацияЗаполнена Тогда
			Условие = "ДоговорКонтрагента.Организация = &Организация";
		Иначе
			Условие = "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Условие;
	
КонецФункции
Функция ПредставлениеДокумента(Документ, НачальноеПредставление)
	
	Представление = НачальноеПредставление;
	Тип = ТипЗнч(Документ);
	Если		Тип = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ТолькоУслуги = Документ.Товары.Количество() = 0 И Документ.Услуги.Количество() <> 0;
		Представление = Представление + ?(ТолькоУслуги, "(Услуги)", "");
		Если ОтображатьНомерВходящихДокументов И ЗначениеЗаполнено(Документ.НомерВходящегоДокумента) Тогда
			Представление = Представление + Символы.ПС + "(Вх.док:" + Документ.НомерВходящегоДокумента + ?(ЗначениеЗаполнено(Документ.ДатаВходящегоДокумента), " от " +Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "") + ")";
		КонецЕсли;
	ИначеЕсли	Тип = Тип("ДокументСсылка.КорректировкаПоступленияТоваровУслуг")Тогда
		Если ОтображатьНомерВходящихДокументов И ЗначениеЗаполнено(Документ.НомерВходящегоДокумента) Тогда
			Представление = Представление + Символы.ПС + "(Вх.док:" + Документ.НомерВходящегоДокумента + ?(ЗначениеЗаполнено(Документ.ДатаВходящегоДокумента), " от " +Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "") + ")";
		КонецЕсли;
	ИначеЕсли	Тип = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
		Если ОтображатьНомерВходящихДокументов И ЗначениеЗаполнено(Документ.НомерДокВходящий) Тогда
			Представление = Представление + Символы.ПС + "(Вх.док:" + Документ.НомерДокВходящий + ?(ЗначениеЗаполнено(Документ.ДатаДокВходящий), " от " +Формат(Документ.ДатаДокВходящий, "ДФ=dd.MM.yyyy"), "") + ")";
		КонецЕсли;
	ИначеЕсли	Тип = Тип("ДокументСсылка.ПлатежноеПоручениеВходящее") Тогда
		Если ОтображатьНомерВходящихДокументов И ЗначениеЗаполнено(Документ.НомерВходящегоДокумента) Тогда
			Представление = Представление + Символы.ПС + "(Вх.док:" + Документ.НомерВходящегоДокумента + ?(ЗначениеЗаполнено(Документ.ДатаВходящегоДокумента), " от " +Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "") + ")";
		КонецЕсли;
	ИначеЕсли	Тип = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		Если ОтображатьНомерВходящихДокументов И ЗначениеЗаполнено(Документ.НомерВходящегоДокумента) Тогда
			Представление = Представление + Символы.ПС + "(Вх.док:" + Документ.НомерВходящегоДокумента + ?(ЗначениеЗаполнено(Документ.ДатаВходящегоДокумента), " от " +Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy"), "") + ")";
		КонецЕсли;
	КонецЕсли;
	
	
	Возврат Представление;
	
КонецФункции
Процедура УстановитьСальдо(СальдоДт, СальдоКт, Остаток)
	
	Если Остаток > 0 Тогда
		СальдоДт = Остаток;
		СальдоКт = 0;
	Иначе
		СальдоДт = 0;
		СальдоКт = -Остаток;
	КонецЕсли;
	
КонецПроцедуры
Процедура СуммироватьСальдоПоГруппе(Группа, Строка)
	
	Группа.НачальныйОстатокДт = Строка.НачальныйОстатокДт + ?(ЗначениеЗаполнено(Группа.НачальныйОстатокДт), Группа.НачальныйОстатокДт, 0);
	Группа.НачальныйОстатокКт = Строка.НачальныйОстатокКт + ?(ЗначениеЗаполнено(Группа.НачальныйОстатокКт), Группа.НачальныйОстатокКт, 0);
	Группа.КонечныйОстатокДт = Строка.КонечныйОстатокДт + ?(ЗначениеЗаполнено(Группа.КонечныйОстатокДт), Группа.КонечныйОстатокДт, 0);
	Группа.КонечныйОстатокКт = Строка.КонечныйОстатокКт + ?(ЗначениеЗаполнено(Группа.КонечныйОстатокКт), Группа.КонечныйОстатокКт, 0);
	
КонецПроцедуры