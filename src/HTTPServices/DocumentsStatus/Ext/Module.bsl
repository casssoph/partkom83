﻿
Функция ПолучитьОтчетПолучить(Запрос)
	
	лКлючАлгоритма = "HTTPсервис_DocumentsStatus_ПолучитьОтчетПолучить";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	НачалоПериода = XMLЗначение(Тип("Дата"), Запрос.ПараметрыURL("НачалоПериода"));
	ОкончаниеПериода = XMLЗначение(Тип("Дата"), Запрос.ПараметрыURL("ОкончаниеПериода"));
	СкладОтправитель = Запрос.ПараметрыURL("СкладОтправитель");
	СкладПолучатель = Запрос.ПараметрыURL("СкладПолучатель");
	
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
		СтрокаОшибки = "Не заполнен параметр «НачалоПериода»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		СтрокаОшибки = "Не заполнен параметр «ОкончаниеПериода»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СкладОтправитель) Тогда
		СтрокаОшибки = "Не заполнен параметр «СкладОтправитель»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СкладПолучатель) Тогда
		СтрокаОшибки = "Не заполнен параметр «СкладПолучатель»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Ответ = Новый HTTPСервисОтвет(400);	
		Ответ.Заголовки.Вставить("Content-Type", "application/xml");	
		Ответ.УстановитьТелоИзСтроки(СтрокаОшибки, "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	КонецЕсли;

	ПараметрыЗапроса = Новый Структура("НачалоПериода, ОкончаниеПериода, СкладОтправитель, СкладПолучатель",  НачалоПериода, ОкончаниеПериода, СкладОтправитель, СкладПолучатель);
	
	Ответ = Новый HTTPСервисОтвет(200);	
	Ответ.Заголовки.Вставить("Content-Type", "application/xml");	
	Ответ.УстановитьТелоИзСтроки(ЗаписатьВJSON(ПараметрыЗапроса), "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
	Возврат Ответ;
	
КонецФункции

Функция ЗаписатьВJSON(ПараметрыЗапроса)
	
	лКлючАлгоритма = "HTTPсервис_DocumentsStatus_ЗаписатьВJSON";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;
	////////////////////////////////////////////////////////////////////////////
	
	тЗапись = Новый ЗаписьJSON;
	тЗапись.УстановитьСтроку();
	
	тДанные = ПолучитьДанные(ПараметрыЗапроса);

	ЗаписатьJSON(тЗапись, тДанные);
	
	Возврат тЗапись.Закрыть();
	
КонецФункции

Функция ПолучитьДанные(ПараметрыЗапроса)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЗ.Ссылка,
	|	МАКСИМУМ(ЕСТЬNULL(ВЗ.КоличествоПлан, 0)) КАК КоличествоПлан,
	|	МАКСИМУМ(ЕСТЬNULL(ВЗ.Размещено, 0)) КАК Размещено
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПеремещениеТоваров.Ссылка КАК Ссылка,
	|		СУММА(ПеремещениеТоваровТовары.КоличествоПлан) КАК КоличествоПлан,
	|		NULL КАК Размещено
	|	ИЗ
	|		Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	|			ПО ПеремещениеТоваров.Ссылка = ПеремещениеТоваровТовары.Ссылка
	|	ГДЕ
	|		ПеремещениеТоваров.ВидОперации = &ВидОперации
	|		И ПеремещениеТоваров.Проведен
	|		И ПеремещениеТоваров.ВыгруженВТопЛог
	|		И НЕ ПеремещениеТоваров.флНеВыгружатьВТопЛог
	|		И ПеремещениеТоваров.СкладОтправитель.ФизическийСклад <> ПеремещениеТоваров.СкладПолучатель.ФизическийСклад
	|		И ПеремещениеТоваров.СкладПолучатель.ТоварыВПути
	|		И ПеремещениеТоваров.АктРассмотренияВозврата.Ссылка ЕСТЬ NULL
	|		И (&БезОтбораПоОтправителям = ИСТИНА
	|				ИЛИ ПеремещениеТоваров.СкладОтправитель.ФизическийСклад.Код В (&СписокОтправителей))
	|		И (&БезОтбораПоПолучателям = ИСТИНА
	|				ИЛИ ПеремещениеТоваров.СкладПолучатель.ФизическийСклад.ФизическийСклад.Код В (&СписокПолучателей))
	|		И ПеремещениеТоваров.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПеремещениеТоваров.Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПеремещениеТоваров.Ссылка,
	|		NULL,
	|		СУММА(РазмещениеТоваровТовары.Количество)
	|	ИЗ
	|		Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК РазмещениеТоваровТовары
	|			ПО ПеремещениеТоваров.Ссылка = РазмещениеТоваровТовары.Ссылка.ДокументОснование
	|	ГДЕ
	|		ПеремещениеТоваров.ВидОперации = &ВидОперации
	|		И ПеремещениеТоваров.Проведен
	|		И ПеремещениеТоваров.ВыгруженВТопЛог
	|		И НЕ ПеремещениеТоваров.флНеВыгружатьВТопЛог
	|		И ПеремещениеТоваров.СкладОтправитель.ФизическийСклад <> ПеремещениеТоваров.СкладПолучатель.ФизическийСклад
	|		И ПеремещениеТоваров.СкладПолучатель.ТоварыВПути
	|		И ПеремещениеТоваров.АктРассмотренияВозврата.Ссылка ЕСТЬ NULL
	|		И (&БезОтбораПоОтправителям = ИСТИНА
	|				ИЛИ ПеремещениеТоваров.СкладОтправитель.ФизическийСклад.Код В (&СписокОтправителей))
	|		И (&БезОтбораПоПолучателям = ИСТИНА
	|				ИЛИ ПеремещениеТоваров.СкладПолучатель.ФизическийСклад.ФизическийСклад.Код В (&СписокПолучателей))
	|		И ПеремещениеТоваров.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПеремещениеТоваров.Ссылка) КАК ВЗ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЗ.Ссылка";
	
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыЗапроса.НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПараметрыЗапроса.ОкончаниеПериода);
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийПеремещенияТоваров.СвободноеПеремещение);
	
	СписокОтправителей = ПараметрыЗапроса.СкладОтправитель;
	СписокОтправителей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокОтправителей, ",");
	
	Запрос.УстановитьПараметр("БезОтбораПоОтправителям", Не СписокОтправителей.Количество());
	Запрос.УстановитьПараметр("СписокОтправителей", СписокОтправителей);
	
	СписокПолучателей = ПараметрыЗапроса.СкладПолучатель;
	СписокПолучателей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокПолучателей, ",");
	
	Запрос.УстановитьПараметр("БезОтбораПоПолучателям", Не СписокПолучателей.Количество());
	Запрос.УстановитьПараметр("СписокПолучателей", СписокПолучателей);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивРезультат = Новый Массив;
	
	Ключи = "GUID, КоличествоПлан, Размещено";
	Пока Выборка.Следующий() Цикл
		СтруктураОтвета = Новый Структура(Ключи);
		ЗаполнитьЗначенияСвойств(СтруктураОтвета, Выборка);
		СтруктураОтвета.GUID = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		МассивРезультат.Добавить(СтруктураОтвета);
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции
