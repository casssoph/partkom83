﻿Процедура ЗаполнитьАктСверки(СтруктураОтчета) Экспорт
	
	СтруктураОтчета.ТабличныйДокумент.Очистить();
	ПроверкаЗаполненияПараметров(СтруктураОтчета);
	Если НЕ СтруктураОтчета.Ошибка Тогда
		УстановитьРеквизитыОтчета(СтруктураОтчета);
		УстановитьКонтактнуюИнформацию(СтруктураОтчета);
		СформироватьОтчет(СтруктураОтчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаЗаполненияПараметров(СтруктураОтчета)
	
	//Либо массив договоров//
	Если ТипЗнч(СтруктураОтчета.Договор) = Тип("Массив") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ДоговорыКонтрагентов.Владелец КАК Контрагент,
		                      |	ДоговорыКонтрагентов.Организация
		                      |ИЗ
		                      |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		                      |ГДЕ
		                      |	ДоговорыКонтрагентов.Ссылка В(&МассивДоговоров)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ДоговорыКонтрагентов.Владелец,
		                      |	ДоговорыКонтрагентов.Организация");
		Запрос.УстановитьПараметр("МассивДоговоров", СтруктураОтчета.Договор);
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество() = 0 Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = "Пустой список договоров" + Символы.ПС;
		ИначеЕсли Результат.Количество() > 1 Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = "В списке договоров различные контрагенты/организации" + Символы.ПС;
		Иначе
			СтруктураОтчета.Контрагент = Результат[0].Контрагент;
			СтруктураОтчета.Организация = Результат[0].Организация;
		КонецЕсли;
	//Либо один договор
	ИначеЕсли ЗначениеЗаполнено(СтруктураОтчета.Договор) Тогда
		Если ЗначениеЗаполнено(СтруктураОтчета.Организация) И СтруктураОтчета.Организация <> СтруктураОтчета.Договор.Организация Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = "Указанная организация не соответствует организации договора" + Символы.ПС;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтруктураОтчета.Контрагент) И СтруктураОтчета.Контрагент <> СтруктураОтчета.Договор.Владелец Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = СтруктураОтчета.ТекстОшибки + "Указанный контрагент не соответствует владельцу договора" + Символы.ПС;
		КонецЕсли;
		СтруктураОтчета.Контрагент = СтруктураОтчета.Договор.Владелец;
		СтруктураОтчета.Организация = СтруктураОтчета.Договор.Организация;
	Иначе
	//Либо Организация + Контрагент//
		Если НЕ ЗначениеЗаполнено(СтруктураОтчета.Организация) Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = "Не указана организация" + Символы.ПС;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтруктураОтчета.Контрагент) Тогда
			СтруктураОтчета.Ошибка = Истина;
			СтруктураОтчета.ТекстОшибки = СтруктураОтчета.ТекстОшибки + "Не указан контрагент" + Символы.ПС;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
Процедура СформироватьОтчет(СтруктураОтчета)
	
	ДанныеОтчета = ДанныеДляОтчета(СтруктураОтчета);
	Макет = ПолучитьМакет("Макет");
	ДебетОборот = 0;
	КредитОборот = 0;
	
	Если ?(СтруктураОтчета.Свойство("ВыводитьЗаголовок"), СтруктураОтчета.ВыводитьЗаголовок, Истина) Тогда
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ЗаполнитьЗначенияСвойств(ОбластьЗаголовок.Параметры, СтруктураОтчета);
		СтруктураОтчета.ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	КонецЕсли;
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, СтруктураОтчета);
	ОбластьШапка.Параметры.Дебет = ?(ДанныеОтчета.Остаток > 0, ДанныеОтчета.Остаток, 0);
	ОбластьШапка.Параметры.Кредит = ?(ДанныеОтчета.Остаток < 0, -ДанныеОтчета.Остаток, 0);
	СтруктураОтчета.ТабличныйДокумент.Вывести(ОбластьШапка);
	
	НомерСтроки = 1;
	Пока ДанныеОтчета.Обороты.Следующий() Цикл
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, ДанныеОтчета.Обороты);
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		СтруктураОтчета.ТабличныйДокумент.Вывести(ОбластьСтрока);
		
		ДебетОборот = ДебетОборот + ДанныеОтчета.Обороты.Дебет;
		КредитОборот = КредитОборот + ДанныеОтчета.Обороты.Кредит;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, СтруктураОтчета);
	ОбластьПодвал.Параметры.Дебет = ДебетОборот;
	ОбластьПодвал.Параметры.Кредит = КредитОборот;
	
	Сальдо = ДанныеОтчета.Остаток + ДебетОборот - КредитОборот;
	СтруктураОтчета.Вставить("Сальдо", Сальдо);
	
	ОбластьПодвал.Параметры.ДебетСальдо = ?(Сальдо > 0, Сальдо, 0);
	ОбластьПодвал.Параметры.КредитСальдо = ?(Сальдо < 0, -Сальдо, 0);
	ОбластьПодвал.Параметры.ИтоговаяСтрока = ИтоговаяСтрока(СтруктураОтчета, Сальдо);
	СтруктураОтчета.ТабличныйДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры

Функция ДанныеДляОтчета(СтруктураОтчета)
	
	Если  ТипЗнч(СтруктураОтчета.Договор) = Тип("Массив") ИЛИ ЗначениеЗаполнено(СтруктураОтчета.Договор) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст=" ВЫБРАТЬ
		|	ДепозитыКонтрагентовОстатки.СуммаУпрОстаток КАК Сумма
		|ПОМЕСТИТЬ НачальныйОстаток
		|ИЗ
		|	РегистрНакопления.ДепозитыКонтрагентов.Остатки(&НачалоПериода, ДоговорКонтрагента В (&Договор)) КАК ДепозитыКонтрагентовОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВзаиморасчетыОстатки.СуммаУпрОстаток
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Остатки(&НачалоПериода, ДоговорКонтрагента В (&Договор)) КАК ВзаиморасчетыОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВзаиморасчетыОбороты.Период КАК Дата,
		|	ВЫБОР
		|		КОГДА СчетФактураВыданныйДокументыОснования.Ссылка ЕСТЬ NULL
		|			ТОГДА ТИПЗНАЧЕНИЯ(ВзаиморасчетыОбороты.Регистратор)
		|		ИНАЧЕ ТИПЗНАЧЕНИЯ(СчетФактураВыданныйДокументыОснования.Ссылка)
		|	КОНЕЦ КАК ВидДокумента,";
		Если ВыводитьНомераРТУИВозвратов Тогда 
			Запрос.Текст=Запрос.Текст+"
			|	ВзаиморасчетыОбороты.Регистратор.Номер КАК Номер,";
		Иначе	  
			Запрос.Текст=Запрос.Текст+"
			|	ЕСТЬNULL(СчетФактураВыданныйДокументыОснования.Ссылка.Номер, ВзаиморасчетыОбороты.Регистратор.Номер) КАК Номер,";
		КонецЕсли;	  
		Запрос.Текст=Запрос.Текст+"
		|	ВзаиморасчетыОбороты.Регистратор КАК Документ,
		|	ВзаиморасчетыОбороты.СуммаУпрПриход КАК Дебет,
		|	ВзаиморасчетыОбороты.СуммаУпрРасход КАК Кредит
		|ПОМЕСТИТЬ Обороты
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Обороты(&НачалоПериода, &КонецПериода, Регистратор, ДоговорКонтрагента В (&Договор)) КАК ВзаиморасчетыОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования";
		Если ВыводитьНомераРТУИВозвратов Тогда 
		    Запрос.Текст=Запрос.Текст+"
			|		ПО (ВзаиморасчетыОбороты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг)";
		Иначе	
		    Запрос.Текст=Запрос.Текст+"
			|		ПО (СчетФактураВыданныйДокументыОснования.Ссылка.Проведен
			|			И ВзаиморасчетыОбороты.Регистратор = СчетФактураВыданныйДокументыОснования.ДокументОснование)";
		КонецЕсли;	  
		Запрос.Текст=Запрос.Текст+"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДепозитыКонтрагентовОбороты.Период,
		|	ТИПЗНАЧЕНИЯ(ДепозитыКонтрагентовОбороты.Регистратор),
		|	ДепозитыКонтрагентовОбороты.Регистратор.Номер,
		|	ДепозитыКонтрагентовОбороты.Регистратор,
		|	ДепозитыКонтрагентовОбороты.СуммаУпрПриход,
		|	ДепозитыКонтрагентовОбороты.СуммаУпрРасход
		|ИЗ
		|	РегистрНакопления.ДепозитыКонтрагентов.Обороты(&НачалоПериода, &КонецПериода, Регистратор, ДоговорКонтрагента В (&Договор)) КАК ДепозитыКонтрагентовОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(НачальныйОстаток.Сумма) КАК Сумма
		|ИЗ
		|	НачальныйОстаток КАК НачальныйОстаток
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Обороты.Дата КАК Дата,
		|	Обороты.ВидДокумента,
		|	Обороты.Номер,
		|	Обороты.Документ,
		|	Обороты.Дебет,
		|	Обороты.Кредит
		|ИЗ
		|	Обороты КАК Обороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	ДепозитыКонтрагентовОстатки.СуммаУпрОстаток КАК Сумма
		|ПОМЕСТИТЬ НачальныйОстаток
		|ИЗ
		|	РегистрНакопления.ДепозитыКонтрагентов.Остатки(
		|			&НачалоПериода,
		|			ДоговорКонтрагента.Владелец = &Контрагент
		|				И ДоговорКонтрагента.Организация = &Организация) КАК ДепозитыКонтрагентовОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВзаиморасчетыОстатки.СуммаУпрОстаток
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Остатки(
		|			&НачалоПериода,
		|			ДоговорКонтрагента.Владелец = &Контрагент
		|				И ДоговорКонтрагента.Организация = &Организация) КАК ВзаиморасчетыОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВзаиморасчетыОбороты.Период КАК Дата,
		|	ВЫБОР
		|		КОГДА СчетФактураВыданныйДокументыОснования.Ссылка ЕСТЬ NULL
		|			ТОГДА ТИПЗНАЧЕНИЯ(ВзаиморасчетыОбороты.Регистратор)
		|		ИНАЧЕ ТИПЗНАЧЕНИЯ(СчетФактураВыданныйДокументыОснования.Ссылка)
		|	КОНЕЦ КАК ВидДокумента,";
		Если ВыводитьНомераРТУИВозвратов Тогда 
			Запрос.Текст=Запрос.Текст+"
			|	ВзаиморасчетыОбороты.Регистратор.Номер КАК Номер,";
		Иначе	  
			Запрос.Текст=Запрос.Текст+"
			|	ЕСТЬNULL(СчетФактураВыданныйДокументыОснования.Ссылка.Номер, ВзаиморасчетыОбороты.Регистратор.Номер) КАК Номер,";
		КонецЕсли;	  
		Запрос.Текст=Запрос.Текст+"
		|	ВзаиморасчетыОбороты.Регистратор КАК Документ,
		|	ВзаиморасчетыОбороты.СуммаУпрПриход КАК Дебет,
		|	ВзаиморасчетыОбороты.СуммаУпрРасход КАК Кредит
		|ПОМЕСТИТЬ Обороты
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Регистратор,
		|			ДоговорКонтрагента.Владелец = &Контрагент
		|				И ДоговорКонтрагента.Организация = &Организация) КАК ВзаиморасчетыОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования";
		Если ВыводитьНомераРТУИВозвратов Тогда 
		    Запрос.Текст=Запрос.Текст+"
			|		ПО (ВзаиморасчетыОбороты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг)";
		Иначе	
		    Запрос.Текст=Запрос.Текст+"
			|		ПО (СчетФактураВыданныйДокументыОснования.Ссылка.Проведен
			|			И ВзаиморасчетыОбороты.Регистратор = СчетФактураВыданныйДокументыОснования.ДокументОснование)";
		КонецЕсли;	  
		Запрос.Текст=Запрос.Текст+"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДепозитыКонтрагентовОбороты.Период,
		|	ТИПЗНАЧЕНИЯ(ДепозитыКонтрагентовОбороты.Регистратор),
		|	ДепозитыКонтрагентовОбороты.Регистратор.Номер,
		|	ДепозитыКонтрагентовОбороты.Регистратор,
		|	ДепозитыКонтрагентовОбороты.СуммаУпрПриход,
		|	ДепозитыКонтрагентовОбороты.СуммаУпрРасход
		|ИЗ
		|	РегистрНакопления.ДепозитыКонтрагентов.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Регистратор,
		|			ДоговорКонтрагента.Владелец = &Контрагент
		|				И ДоговорКонтрагента.Организация = &Организация) КАК ДепозитыКонтрагентовОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(НачальныйОстаток.Сумма) КАК Сумма
		|ИЗ
		|	НачальныйОстаток КАК НачальныйОстаток
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Обороты.Дата КАК Дата,
		|	Обороты.ВидДокумента,
		|	Обороты.Номер,
		|	Обороты.Документ,
		|	Обороты.Дебет,
		|	Обороты.Кредит
		|ИЗ
		|	Обороты КАК Обороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", СтруктураОтчета.Организация);
	Запрос.УстановитьПараметр("Контрагент", СтруктураОтчета.Контрагент);
	Запрос.УстановитьПараметр("Договор", СтруктураОтчета.Договор);
	Запрос.УстановитьПараметр("НачалоПериода", СтруктураОтчета.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(СтруктураОтчета.ОкончаниеПериода));
	Результат = Запрос.ВыполнитьПакет();
	
	Остаток = Результат[2].Выбрать();
	Обороты = Результат[3].Выбрать();
	
	Возврат Новый Структура("Остаток,Обороты", ?(Остаток.Следующий(), Остаток.Сумма, 0), Обороты);
	
	
КонецФункции
Процедура УстановитьРеквизитыОтчета(СтруктураОтчета)
	
	СтруктураОтчета.Вставить("ТекущаяДата", Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy"));
	СтруктураОтчета.Вставить("НачалоПериодаТекст", Формат(СтруктураОтчета.НачалоПериода, "ДФ=dd.MM.yyyy"));
	СтруктураОтчета.Вставить("КонецПериодаТекст", Формат(СтруктураОтчета.ОкончаниеПериода, "ДФ=dd.MM.yyyy"));
	СтруктураОтчета.Вставить("КонтрагентТекст", Строка(СтруктураОтчета.Контрагент.НаименованиеПолное)+" ("+Строка(СтруктураОтчета.Контрагент.Код)+")");
	СтруктураОтчета.Вставить("ОрганизацияТекст", СтруктураОтчета.Организация.НаименованиеПолное);
	
КонецПроцедуры
Функция ИтоговаяСтрока(СтруктураОтчета,  Сальдо)
	
	Если Сальдо = 0 Тогда
		Строка = " задолженностей нет";
	ИначеЕсли Сальдо > 0 Тогда
		Строка = " задолженность в пользу " + СтруктураОтчета.ОрганизацияТекст + " " + Формат(Сальдо, "ЧГ=") + "руб.";
	Иначе
		Строка = " задолженность в пользу " + СтруктураОтчета.КонтрагентТекст + " " + Формат(-Сальдо, "ЧГ=") + "руб.";
	КонецЕсли;
	
	Возврат Строка
	
КонецФункции
Процедура УстановитьКонтактнуюИнформацию(СтруктураОтчета)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КонтактнаяИнформация.Вид,
	                      |	КонтактнаяИнформация.Представление
	                      |ПОМЕСТИТЬ Данные
	                      |ИЗ
	                      |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                      |ГДЕ
	                      |	КонтактнаяИнформация.Объект = &Организация
	                      |	И КонтактнаяИнформация.Вид В (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонОрганизации))
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
	                      |				КОГДА Данные.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации)
	                      |					ТОГДА ЕСТЬNULL(Данные.Представление, """")
	                      |				ИНАЧЕ "" - ""
	                      |			КОНЕЦ), """") КАК Адрес,
	                      |	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
	                      |				КОГДА Данные.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя)
	                      |					ТОГДА ЕСТЬNULL(Данные.Представление, """")
	                      |				ИНАЧЕ "" - ""
	                      |			КОНЕЦ), """") КАК EMail,
	                      |	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
	                      |				КОГДА Данные.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонОрганизации)
	                      |					ТОГДА ЕСТЬNULL(Данные.Представление, """")
	                      |				ИНАЧЕ "" - ""
	                      |			КОНЕЦ), """") КАК Телефон
	                      |ИЗ
	                      |	Данные КАК Данные");
	Запрос.УстановитьПараметр("Организация", ПараметрыСеанса.ТекущийПользователь);//СтруктураОтчета.Организация);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	ЕстьДанные = Не РезультатЗапроса.Пустой();
	Выборка.Следующий();
	
	СтруктураОтчета.Вставить("Адрес", ?(ЕстьДанные, Выборка.Адрес, "-"));
	СтруктураОтчета.Вставить("EMail", ?(ЕстьДанные, Выборка.EMail, "-")+"; Tatarova-MV@part-kom.ru");
	СтруктураОтчета.Вставить("Телефон", ?(ЕстьДанные, Выборка.Телефон, "-"));
	
КонецПроцедуры