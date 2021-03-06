﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт
	//"ВЫБРАТЬ
	//|	Дог.Ссылка КАК Договор,
	//|	Дог.Владелец КАК Контрагент,
	//|	Дог.Организация,
	//|	Дог.ДоговорИнвестКонтракт КАК ИнвестКонтракт,
	//|	Дог.ДоговорНаОферту КАК Оферта
	//|ПОМЕСТИТЬ Полн
	
	Запрос = Новый Запрос;
	Если Не ЭтоАктивнаяЗадачаJirа(ПредопределенноеЗначение("Справочник.ЗадачиJira.XX2447")) Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УчетныеЗаписиСайта.Владелец.Владелец КАК Контрагент
		|ПОМЕСТИТЬ КА
		|ИЗ
		|	Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Д.Ссылка,
		|	Д.Владелец,
		|	Д.Организация,
		|	Д.ДоговорИнвестКонтракт,
		|	Д.ДоговорНаОферту
		|ПОМЕСТИТЬ Д
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК Д
		|ГДЕ
		|	Д.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
		|	И НЕ Д.ДоговорИнвестКонтракт
		|	И Д.Владелец.ГоловнойКонтрагент В
		|			(ВЫБРАТЬ
		|				КА.Контрагент
		|			ИЗ
		|				КА КАК КА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Р.ДоговорКонтрагента.Владелец.ГоловнойКонтрагент КАК Контрагент,
		|	Р.ДоговорКонтрагента.Организация КАК Организация,
		|	СУММА(Р.СуммаРеглОстаток) КАК Сумма
		|ПОМЕСТИТЬ О
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Остатки(
		|			&ТекущаяДата,
		|			ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
		|				И НЕ ДоговорКонтрагента.ДоговорИнвестКонтракт
		|				И ДоговорКонтрагента.Владелец.ГоловнойКонтрагент В
		|					(ВЫБРАТЬ
		|						КА.Контрагент
		|					ИЗ
		|						КА КАК КА)) КАК Р
		|
		|СГРУППИРОВАТЬ ПО
		|	Р.ДоговорКонтрагента.Владелец.ГоловнойКонтрагент,
		|	Р.ДоговорКонтрагента.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Д.Ссылка КАК Договор,
		|	ЕСТЬNULL(О.Сумма, 0) КАК Сумма
		|ПОМЕСТИТЬ ППЦ
		|ИЗ
		|	Д КАК Д
		|		ЛЕВОЕ СОЕДИНЕНИЕ О КАК О
		|		ПО Д.Владелец.ГоловнойКонтрагент = О.Контрагент
		|			И Д.Организация = О.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ППЦ.Договор,
		|	СУММА(ППЦ.Сумма) КАК Сумма
		|ИЗ
		|	ППЦ КАК ППЦ
		|ГДЕ
		|	НЕ ППЦ.Договор.СлужебныйДоговор
		//	|	И НЕ ППЦ.Договор.ДоговорПриостановлен
		|	И НЕ ППЦ.Договор.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	ППЦ.Договор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ППЦ.Договор,
		|	СУММА(ППЦ.Сумма)
		|ИЗ
		|	ППЦ КАК ППЦ
		|ГДЕ
		|	НЕ ППЦ.Договор.СлужебныйДоговор
		|	И ППЦ.Договор.ДоговорПриостановлен
		//|	И НЕ ППЦ.Договор.ПометкаУдаления
		|	И ППЦ.Договор.ВидОплаты = ЗНАЧЕНИЕ(Перечисление.ВидыДенежныхСредств.Безналичные)
		|
		|СГРУППИРОВАТЬ ПО
		|	ППЦ.Договор";
		
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УчетныеЗаписиСайта.Владелец.Владелец КАК Контрагент
		|ПОМЕСТИТЬ КА
		|ИЗ
		|	Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Д.Ссылка,
		|	Д.Владелец,
		|	Д.Организация,
		|	Д.ДоговорИнвестКонтракт,
		|	Д.ДоговорНаОферту
		|ПОМЕСТИТЬ Д
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК Д
		|ГДЕ
		|	Д.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
		|	И НЕ Д.ДоговорИнвестКонтракт
		|	И Д.Владелец.ГоловнойКонтрагент В
		|			(ВЫБРАТЬ
		|				КА.Контрагент
		|			ИЗ
		|				КА КАК КА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Р.ДоговорКонтрагента,
		|	СУММА(Р.СуммаРеглОстаток) КАК Сумма
		|ПОМЕСТИТЬ О
		|ИЗ
		|	РегистрНакопления.Взаиморасчеты.Остатки(
		|			&ТекущаяДата,
		|			ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
		|				И НЕ ДоговорКонтрагента.ДоговорИнвестКонтракт
		|				И ДоговорКонтрагента.Владелец.ГоловнойКонтрагент В
		|					(ВЫБРАТЬ
		|						КА.Контрагент
		|					ИЗ
		|						КА КАК КА)) КАК Р
		|
		|СГРУППИРОВАТЬ ПО
		|	Р.ДоговорКонтрагента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Д.Ссылка КАК Договор,
		|	ЕСТЬNULL(О.Сумма, 0) КАК Сумма
		|ПОМЕСТИТЬ ППЦ
		|ИЗ
		|	Д КАК Д
		|		ЛЕВОЕ СОЕДИНЕНИЕ О КАК О
		|	ПО Д.Ссылка = О.ДоговорКонтрагента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ППЦ.Договор,
		|	СУММА(ППЦ.Сумма) КАК Сумма
		|ИЗ
		|	ППЦ КАК ППЦ
		|ГДЕ
		|	НЕ ППЦ.Договор.СлужебныйДоговор
		|	И НЕ ППЦ.Договор.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	ППЦ.Договор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ППЦ.Договор,
		|	СУММА(ППЦ.Сумма)
		|ИЗ
		|	ППЦ КАК ППЦ
		|ГДЕ
		|	НЕ ППЦ.Договор.СлужебныйДоговор
		|	И ППЦ.Договор.ДоговорПриостановлен
		|	И ППЦ.Договор.ВидОплаты = ЗНАЧЕНИЕ(Перечисление.ВидыДенежныхСредств.Безналичные)
		|
		|СГРУППИРОВАТЬ ПО
		|	ППЦ.Договор"
	КонецЕсли;

	Период = ТекущаяДата();
	
	Запрос.УстановитьПараметр("ТекущаяДата", Период);
	
	#Если Клиент Тогда
		имяФайла = "C:\Обмен\Балансы\b_";
	#Иначе
		имяФайла = "\\php-hp.part-kom.ru\exchange\1C\toWeb\balance\b_";
	#КонецЕсли
	имяФайла = ИмяФайла + Формат(Период, "ДФ=yyyyMMddhhmmss") + ".csv";
	тхт = Новый ЗаписьТекста(имяФайла, КодировкаТекста.ANSI);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Договор) Тогда
			Сумма = -Выборка.Сумма;
			Сумма = Строка(Сумма);
			Сумма = СтрЗаменить(Сумма, Символы.НПП, "");
			Сумма = СтрЗаменить(Сумма, " ", "");
			Сумма = СтрЗаменить(Сумма, ",", ".");
			стр = СокрЛП(Выборка.Договор.УникальныйИдентификатор()) + ";" + Сумма;
			тхт.ЗаписатьСтроку(стр);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры