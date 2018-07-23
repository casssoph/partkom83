﻿//Обмен 1С-Сайт: ОбменПартКом83_Сайт_состояние_заявок//
Процедура ДобавитьДанныеСостояниеСтрокЗаявок(Список, НомерСообщения) Экспорт
	
	Если НЕ РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт","Выгружать состояния строк заявок", Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаОтбораЗаявок = "";
	ТекущаяДата = ТекущаяДата();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип("http://ws-02.part-kom.ru/partkom83/hs/SiteExchange/XMLSchema", "СостояниеСтрокиЗаявки");
	Выборка = ВыборкаСостоянийСтрокЗаявок();
	Пока Выборка.Следующий() Цикл
		
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка, "IDSite,Дата,Артикул,АртикулЗамены,КоличествоВЗаявке,КоличествоЗаказано,КоличествоОтказано,КоличествоНаСкладе,КоличествоВыдано");
		ОбъектXDTO.Состояние = Выборка.Состояние.УникальныйИдентификатор();
		ОбъектXDTO.Склад = Выборка.Склад.УникальныйИдентификатор();
		ОбъектXDTO.НомерЗаявки = Выборка.ДокументЗаявки.Номер;
		Список.Добавить(ОбъектXDTO);
		
		UUIDx = ОбщегоНазначения.ПреобразоватьGUIDВФорматHEX(Выборка.СтрокаЗаявки.УникальныйИдентификатор());
		СтрокаОтбораЗаявок = СтрокаОтбораЗаявок + ?(СтрокаОтбораЗаявок = "", UUIDx , ", " + UUIDx);
		
		//Отмечаем непосредственно через запрос SQL//
		//Запись = РегистрыСведений.СостояниеЗаявокПокупателя.СоздатьМенеджерЗаписи();
		//Запись.СтрокаЗаявки = Выборка.СтрокаЗаявки;
		//Запись.Прочитать();
		//Запись.НомерСообщенияОтправленного = НомерСообщения;
		//Запись.ДатаОтправки = ТекущаяДата;
		//Запись.Записать();
		
	КонецЦикла;
	
	ОтметитьОтправленныеСтрокиВSQL(НомерСообщения, СтрокаОтбораЗаявок);
	
КонецПроцедуры
Процедура ФиксацияПринятогоСообщения(НомерСообщения) Экспорт
	
	Попытка
		СоединениеSQL  = Новый COMОбъект("ADODB.Connection");
		КомандаSQL     = Новый COMОбъект("ADODB.Command");
		ВыборкаSQL     = Новый COMОбъект("ADODB.RecordSet");
		
		СоединениеSQL.ConnectionString = DataExchangeModule.СтрокаСоединенияSQL();
		
		СоединениеSQL.ConnectionTimeout = 30;
		СоединениеSQL.CommandTimeout = 6000;
		
		СоединениеSQL.Open();
		КомандаSQL.ActiveConnection   = СоединениеSQL;
		КомандаSQL.CommandText = ТекстЗапросаФиксацииСообщения(НомерСообщения);
		КомандаSQL.Execute();
		
		СоединениеSQL.Close();
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры
Функция ТекстЗапросаФиксацииСообщения(НомерСообщения)
	
	Отказ = Ложь;
	ТекстЗапроса = "";
	СтруктураХранения = ПолучитьСтруктуруХраненияБазыДанных();
	ОписаниеТаблицы = СтруктураХранения.Найти("РегистрСведений.СостояниеЗаявокПокупателя", "ИмяТаблицы");
	Если ОписаниеТаблицы = Неопределено Тогда
		Отказ = Истина;
	Иначе
		ИмяТаблицыХранения = "_" + ОписаниеТаблицы.ИмяТаблицыХранения;
		ОписаниеПолей = ОписаниеТаблицы.Поля;
		ПолеПолученоСайтом = "_" + ИмяПоляТаблицы(ОписаниеПолей, "ПолученоСайтом", Отказ);
		ПолеНомерСообщенияОтправленного = "_" + ИмяПоляТаблицы(ОписаниеПолей, "НомерСообщенияОтправленного", Отказ);
		ПолеДатаОбработкиСайтом = "_" + ИмяПоляТаблицы(ОписаниеПолей, "ДатаОбработкиСайтом", Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ТекущаяДата = ТекущаяДата();
		Дата = "DATEADD(DAY,0, '" + Формат(ТекущаяДата(), "ДФ='yyyy-MM-dd HH:mm:ss'") + "')";
		ТекстЗапроса =	"UPDATE " + ИмяТаблицыХранения + " set " + ПолеПолученоСайтом + " = 1, " + ПолеДатаОбработкиСайтом + " = " + Дата + " " +
						"WHERE " + ПолеПолученоСайтом + " =  0 and (" +ПолеНомерСообщенияОтправленного + " between 1 and " + Формат(НомерСообщения, "ЧН=; ЧГ=") + ")";
	Иначе
		ВызватьИсключение("Ошибка формирования текста запроса SQL");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ВыборкаСостоянийСтрокЗаявок()
	
	КоличествоОбъектов = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен (Общее)","Количество объектов в обмене", 1000);
	ОбратныйПорядокВыборки = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен (Общее)","Обратный порядок выборки", Истина);
	УсловиеОтбора = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен (Общее)","Условие запроса состояний строк заявок", "");
	
	Запрос = Новый Запрос(ТекстЗапросаВыборкиСостояний());
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1234", Формат(КоличествоОбъектов, "ЧГ="));
	Если НЕ ОбратныйПорядокВыборки Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " УБЫВ", "");
	КонецЕсли;
	Если ЗначениеЗаполнено(УсловиеОтбора) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ИСТИНА", "И " + УсловиеОтбора);
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции
Функция ТекстЗапросаВыборкиСостояний()
	
	//При изменении текста запроса, требуется учесть замены текста запроса в процедуре ВыборкаСостоянийСтрокЗаявок()//
	Возврат "ВЫБРАТЬ ПЕРВЫЕ 1234
	        |	СостояниеЗаявокПокупателя.ДатаИзменения КАК Дата,
	        |	ВЫБОР
	        |		КОГДА СостояниеЗаявокПокупателя.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	        |			ТОГДА ЕСТЬNULL(СостояниеЗаявокПокупателя.СтрокаЗаявки.Заявка.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	        |		ИНАЧЕ СостояниеЗаявокПокупателя.Склад
	        |	КОНЕЦ КАК Склад,
	        |	СостояниеЗаявокПокупателя.Номенклатура,
	        |	СостояниеЗаявокПокупателя.IDSite,
	        |	СостояниеЗаявокПокупателя.СтрокаЗаявки,
	        |	СостояниеЗаявокПокупателя.Состояние,
	        |	СостояниеЗаявокПокупателя.КоличествоВЗаявке,
	        |	СостояниеЗаявокПокупателя.КоличествоЗаказано,
	        |	СостояниеЗаявокПокупателя.КоличествоОтказ КАК КоличествоОтказано,
	        |	СостояниеЗаявокПокупателя.КоличествоПоступило КАК КоличествоНаСкладе,
	        |	СостояниеЗаявокПокупателя.КоличествоОтгружено КАК КоличествоВыдано,
	        |	ВЫБОР
	        |		КОГДА СостояниеЗаявокПокупателя.СтрокаЗаявки.ПоследняяКорректировка <> ЗНАЧЕНИЕ(Документ.КорректировкаЗаявкиПокупателя.ПустаяСсылка)
	        |			ТОГДА СостояниеЗаявокПокупателя.СтрокаЗаявки.ПоследняяКорректировка
	        |		ИНАЧЕ СостояниеЗаявокПокупателя.СтрокаЗаявки.Заявка
	        |	КОНЕЦ КАК ДокументСвязи
	        |ПОМЕСТИТЬ ДанныеСтрокиЗаявки
	        |ИЗ
	        |	РегистрСведений.СостояниеЗаявокПокупателя КАК СостояниеЗаявокПокупателя
	        |ГДЕ
	        |	НЕ СостояниеЗаявокПокупателя.СтрокаЗаявки.Виртуальная
	        |	И НЕ СостояниеЗаявокПокупателя.ПолученоСайтом
	        |	И ИСТИНА
	        |
	        |УПОРЯДОЧИТЬ ПО
	        |	СостояниеЗаявокПокупателя.ДатаИзменения УБЫВ
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЗаявкаПокупателяТовары.Ссылка КАК Документ,
	        |	ЗаявкаПокупателяТовары.СтрокаЗаявки,
	        |	ЗаявкаПокупателяТовары.Номенклатура
	        |ПОМЕСТИТЬ ОпределениеНоменклатуры
	        |ИЗ
	        |	Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
	        |ГДЕ
	        |	ЗаявкаПокупателяТовары.Ссылка В
	        |			(ВЫБРАТЬ
	        |				ДанныеСтрокиЗаявки.ДокументСвязи
	        |			ИЗ
	        |				ДанныеСтрокиЗаявки КАК ДанныеСтрокиЗаявки)
	        |	И ЗаявкаПокупателяТовары.СтрокаЗаявки В
	        |			(ВЫБРАТЬ
	        |				ДанныеСтрокиЗаявки.СтрокаЗаявки
	        |			ИЗ
	        |				ДанныеСтрокиЗаявки КАК ДанныеСтрокиЗаявки)
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	КорректировкаЗаявкиПокупателяТовары.Ссылка,
	        |	КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки,
	        |	КорректировкаЗаявкиПокупателяТовары.Номенклатура
	        |ИЗ
	        |	Документ.КорректировкаЗаявкиПокупателя.Товары КАК КорректировкаЗаявкиПокупателяТовары
	        |ГДЕ
	        |	КорректировкаЗаявкиПокупателяТовары.Ссылка В
	        |			(ВЫБРАТЬ
	        |				ДанныеСтрокиЗаявки.ДокументСвязи
	        |			ИЗ
	        |				ДанныеСтрокиЗаявки КАК ДанныеСтрокиЗаявки)
	        |	И КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки В
	        |			(ВЫБРАТЬ
	        |				ДанныеСтрокиЗаявки.СтрокаЗаявки
	        |			ИЗ
	        |				ДанныеСтрокиЗаявки КАК ДанныеСтрокиЗаявки)
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ДанныеСтрокиЗаявки.Дата,
	        |	ЕСТЬNULL(ДанныеСтрокиЗаявки.СтрокаЗаявки.Заявка, ЗНАЧЕНИЕ(Документ.ЗаявкаПокупателя.ПустаяСсылка)) КАК ДокументЗаявки,
	        |	ВЫБОР
	        |		КОГДА ДанныеСтрокиЗаявки.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	        |			ТОГДА ЕСТЬNULL(ОпределениеНоменклатуры.Номенклатура.Артикул, """")
	        |		ИНАЧЕ ЕСТЬNULL(ДанныеСтрокиЗаявки.Номенклатура.Артикул, """")
	        |	КОНЕЦ КАК Артикул,
	        |	ЕСТЬNULL(ВозможныеЗаменыНоменклатурыСрезПоследних.НоменклатураЗамена.Артикул, """") КАК АртикулЗамены,
	        |	ДанныеСтрокиЗаявки.Склад,
	        |	ДанныеСтрокиЗаявки.IDSite,
	        |	ДанныеСтрокиЗаявки.СтрокаЗаявки,
	        |	ДанныеСтрокиЗаявки.Состояние,
	        |	ДанныеСтрокиЗаявки.КоличествоВЗаявке,
	        |	ДанныеСтрокиЗаявки.КоличествоЗаказано,
	        |	ДанныеСтрокиЗаявки.КоличествоОтказано,
	        |	ДанныеСтрокиЗаявки.КоличествоНаСкладе,
	        |	ДанныеСтрокиЗаявки.КоличествоВыдано,
	        |	ДанныеСтрокиЗаявки.ДокументСвязи
	        |ИЗ
	        |	ДанныеСтрокиЗаявки КАК ДанныеСтрокиЗаявки
	        |		ЛЕВОЕ СОЕДИНЕНИЕ ОпределениеНоменклатуры КАК ОпределениеНоменклатуры
	        |		ПО ДанныеСтрокиЗаявки.СтрокаЗаявки = ОпределениеНоменклатуры.СтрокаЗаявки
	        |			И ДанныеСтрокиЗаявки.ДокументСвязи = ОпределениеНоменклатуры.Документ
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВозможныеЗаменыНоменклатуры.СрезПоследних(, ) КАК ВозможныеЗаменыНоменклатурыСрезПоследних
	        |		ПО ДанныеСтрокиЗаявки.СтрокаЗаявки = ВозможныеЗаменыНоменклатурыСрезПоследних.СтрокаЗаявки";
	
КонецФункции
Процедура ОтметитьОтправленныеСтрокиВSQL(НомерСообщения, СтрокаОтбораSSID)
	
	Попытка
		СоединениеSQL  = Новый COMОбъект("ADODB.Connection");
		КомандаSQL     = Новый COMОбъект("ADODB.Command");
		ВыборкаSQL     = Новый COMОбъект("ADODB.RecordSet");
		
		СоединениеSQL.ConnectionString = DataExchangeModule.СтрокаСоединенияSQL();
		
		СоединениеSQL.ConnectionTimeout = 30;
		СоединениеSQL.CommandTimeout = 6000;
		
		СоединениеSQL.Open();
		КомандаSQL.ActiveConnection   = СоединениеSQL;
		КомандаSQL.CommandText = ТекстЗапросаОтметкиОтправленного(НомерСообщения, СтрокаОтбораSSID);
		КомандаSQL.Execute();
		
		СоединениеSQL.Close();
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры
Функция ТекстЗапросаОтметкиОтправленного(НомерСообщения, СтрокаОтбораSSID)
	
	Отказ = Ложь;
	ТекстЗапроса = "";
	СтруктураХранения = ПолучитьСтруктуруХраненияБазыДанных();
	ОписаниеТаблицы = СтруктураХранения.Найти("РегистрСведений.СостояниеЗаявокПокупателя", "ИмяТаблицы");
	Если ОписаниеТаблицы = Неопределено Тогда
		Отказ = Истина;
	Иначе
		ИмяТаблицыХранения = "_" + ОписаниеТаблицы.ИмяТаблицыХранения;
		ОписаниеПолей = ОписаниеТаблицы.Поля;
		ПолеДатаОтправки = "_" + ИмяПоляТаблицы(ОписаниеПолей, "ДатаОтправки", Отказ);
		ПолеНомерСообщенияОтправленного = "_" + ИмяПоляТаблицы(ОписаниеПолей, "НомерСообщенияОтправленного", Отказ);
		ПолеIDSite = "_" + ИмяПоляТаблицы(ОписаниеПолей, "IDSite", Отказ);
		ПолеСтрокаЗаявки = "_" + ИмяПоляТаблицы(ОписаниеПолей, "СтрокаЗаявки", Отказ) + "RRef";
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ТекущаяДата = ТекущаяДата();
		Дата = "DATEADD(DAY,0, '" + Формат(ТекущаяДата(), "ДФ='yyyy-MM-dd HH:mm:ss'") + "')";
		ТекстЗапроса =	"UPDATE " + ИмяТаблицыХранения + " set " + ПолеНомерСообщенияОтправленного + " = " + Формат(НомерСообщения, "ЧГ=") + ", " + ПолеДатаОтправки + " = " + Дата + " " +
						"WHERE " + ПолеСтрокаЗаявки + " in (" + СтрокаОтбораSSID + ")";
	Иначе
		ВызватьИсключение("Ошибка формирования текста запроса SQL");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции
Функция ИмяПоляТаблицы(ОписаниеПолей, ИмяПоля, Отказ)
	
	ИмяПоляХранения = "";	
	Строка = ОписаниеПолей.Найти(ИмяПоля, "ИмяПоля");
	Если Строка = Неопределено Тогда
		Отказ = Истина;
	Иначе
		ИмяПоляХранения = Строка.ИмяПоляХранения;
	КонецЕсли;
	
	Возврат ИмяПоляХранения;
	
КонецФункции

