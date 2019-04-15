﻿// 15.04.19 Строганов Роман > 
Функция ВыгрузитьВОкноПоставщика(СсылкаНаОбъект, СтруктураАдресаФайлов) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ВыгрузитьВОкноПоставщика";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////	
	
	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда 
		ИмяРеквизита = "СтрокаДляРабочейБазы";
	Иначе
		ИмяРеквизита = "СтрокаДляТестовойБазы";
	КонецЕсли;
		
	КаталогФайловДляСайта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.КаталогФайловДляСайта, ИмяРеквизита);
	
	Попытка
		КопироватьФайл(СтруктураАдресаФайлов.ПолноеИмяФайла, КаталогФайловДляСайта + СтруктураАдресаФайлов.ИмяФайла);
		КопироватьФайл(СтруктураАдресаФайлов.ПолноеИмяФайлаРасшВедомость, КаталогФайловДляСайта + СтруктураАдресаФайлов.ИмяФайлаРасшВедомость);
	Исключение
		ВызватьИсключение "Не удалось скопировать файл." + ОписаниеОшибки();
	КонецПопытки;
	
	ДатаВремяОбновленияАкта = СтрЗаменить(ПеревернутьДату(ТекущаяДатаСеанса()), " ", "") + " " + СокрЛП(Формат(ТекущаяДатаСеанса(), "ДЛФ=T")); 
	ДатаВремяОбновленияВедомости = СтрЗаменить(ПеревернутьДату(ТекущаяДатаСеанса()), " ", "") + " " + СокрЛП(Формат(ТекущаяДатаСеанса(), "ДЛФ=T"));
	
	СтрокаПодключенияADO = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.СтрокаПодключенияADO, ИмяРеквизита);
	
	АдресСервераMySQL = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.АдресСервераОП, ИмяРеквизита); 
	ИмяБазы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ИмяБазыОП, ИмяРеквизита);
	ИмяПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ИмяПользователяОП, ИмяРеквизита);
	ПарольПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ПарольОП, ИмяРеквизита);
	
	Если Не ЗначениеЗаполнено(АдресСервераMySQL) Тогда 
		ВызватьИсключение "В константах не заполнен адрес сервера MySQL";
	КонецЕсли;
	
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%АдресСервера%", АдресСервераMySQL);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ИмяБазы%", ИмяБазы);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ИмяПользователя%", ИмяПользователя);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ПарольПользователя%", ПарольПользователя);
	
	ADOСоединение  = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionString = СтрокаПодключенияADO;
	ADOСоединение.ConnectionTimeout = 30;
	ADOСоединение.CommandTimeout = 6000;

	Попытка
		ADOСоединение.Open();
	Исключение
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки; 
	
	RS = Новый ComОбъект("ADODB.Recordset"); 
	
	ИмяТаблицы = "import_bonus";
	
	ТекНомерДок = СсылкаНаОбъект.Номер + "_" + СокрЛП(Формат(Год(СсылкаНаОбъект.Дата), "ЧГ=0")); 
	
	ТекстЗапроса_Поиск = "SELECT * FROM "+ИмяТаблицы+" WHERE act_number = '"+ТекНомерДок+"'";
	
	RS.Open(ТекстЗапроса_Поиск, ADOСоединение);
	
	ТекстЗапроса_Добавление = "INSERT INTO "+ ИмяТаблицы +"(act_number) VALUES ('"+ ТекНомерДок + "')";
	
	Command = Новый COMОбъект("ADODB.Command");
	Command.CommandTimeout = 100;
	Command.CommandText = ТекстЗапроса_Поиск;
	Command.CommandType = 1;
	Command.ActiveConnection = ADOСоединение;
	
	Попытка
		Command.Execute();
	Исключение
		ВызватьИсключение 
		"Ошибка выгрузки бонусов в «Окно поставщика». 
		|Запрос к таблицам MySQL на сайте вызвал ошибку. 
		|Описание ошибки: " + ОписаниеОшибки();
	КонецПопытки;
	
	Если RS.EOF() Тогда
		
		Command = Новый COMОбъект("ADODB.Command");
		Command.CommandTimeout = 100;
		Command.CommandText = ТекстЗапроса_Добавление;
		Command.CommandType = 1;
		Command.ActiveConnection = ADOСоединение;
		
		Попытка
			Command.Execute();
		Исключение
			ВызватьИсключение 
			"Ошибка выгрузки бонусов в «Окно поставщика». 
			|Запрос к таблицам MySQL на сайте вызвал ошибку. 
			|Описание ошибки: " + ОписаниеОшибки();
		КонецПопытки;
		
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КорректировкаДолга.ДатаАкта КАК ДатаАкта,
	|	КорректировкаДолга.КонтрагентДебитор КАК Контрагент,
	|	КорректировкаДолга.ПериодАнализаНачало КАК ПериодАнализаНачало,
	|	КорректировкаДолга.ПериодАнализаОкончание КАК ПериодАнализаОкончание,
	|	КорректировкаДолга.ПроцентБонуса КАК ПроцентБонуса,
	|	ЕСТЬNULL(ВложенныйЗапрос.Сумма, 0) КАК СуммаПремии,
	|	КорректировкаДолга.СканПолучен КАК СканПолучен,
	|	КорректировкаДолга.ОригиналПолучен КАК ОригиналПолучен,
	|	КорректировкаДолга.ДатаПолученияОригинала КАК ДатаПолученияОригинала
	|ИЗ
	|	Документ.КорректировкаДолга КАК КорректировкаДолга
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КорректировкаДолгаСуммыДолга.Ссылка КАК Ссылка,
	|			СУММА(КорректировкаДолгаСуммыДолга.Сумма) КАК Сумма
	|		ИЗ
	|			Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолгаСуммыДолга
	|		
	|		СГРУППИРОВАТЬ ПО
	|			КорректировкаДолгаСуммыДолга.Ссылка) КАК ВложенныйЗапрос
	|		ПО КорректировкаДолга.Ссылка = ВложенныйЗапрос.Ссылка
	|ГДЕ
	|	КорректировкаДолга.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ТекстЗапроса_Обновление = "";
	
	Если ЗначениеЗаполнено(СтруктураАдресаФайлов.ИмяФайла) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", act_file = '" + СтруктураАдресаФайлов.ИмяФайла +"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураАдресаФайлов.ИмяФайлаРасшВедомость) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", vedomost_file = '"+ СтруктураАдресаФайлов.ИмяФайлаРасшВедомость +"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаВремяОбновленияАкта) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", act_file_date = '"+ ДатаВремяОбновленияАкта+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаВремяОбновленияВедомости) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", vedomost_file_date = '"+ ДатаВремяОбновленияВедомости + "'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ДатаАкта) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", act_date = '"+ПеревернутьДату(СсылкаНаОбъект.ДатаАкта)+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.СуммаПремии) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", act_sum = '"+XMLСтрока(Выборка.СуммаПремии)+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.Контрагент) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", supplier_code = '"+ Выборка.Контрагент.Код+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ПериодАнализаНачало) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", period_start = '"+ПеревернутьДату(Выборка.ПериодАнализаНачало)+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ПериодАнализаОкончание) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", period_end = '"+ПеревернутьДату(Выборка.ПериодАнализаОкончание)+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.СканПолучен) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", has_scan = '"+ ?(Выборка.СканПолучен, 1, 0) +"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ОригиналПолучен) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", has_original = '"+ ?(Выборка.ОригиналПолучен, 1, 0)+"'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ДатаПолученияОригинала) Тогда
		ТекстЗапроса_Обновление = ТекстЗапроса_Обновление + ", original_date = '"+?(ЗначениеЗаполнено(Выборка.ДатаПолученияОригинала), Выборка.ДатаПолученияОригинала, "0000-00-00") +"'";
	КонецЕсли;
	
	ТекстЗапроса_Обновление = Сред(ТекстЗапроса_Обновление, 2);
	
	ТекстЗапроса_Обновление = "UPDATE "+ИмяТаблицы+" SET " + ТекстЗапроса_Обновление + " WHERE act_number = '"+ТекНомерДок+"'";

	Command = Новый COMОбъект("ADODB.Command");
	Command.CommandTimeout = 100;
	Command.CommandText = ТекстЗапроса_Обновление;
	Command.CommandType = 1;
	Command.ActiveConnection = ADOСоединение;
	
	Попытка
		Command.Execute();
	Исключение
		ВызватьИсключение 
		"Ошибка выгрузки бонусов в «Окно поставщика». 
		|Запрос к таблицам MySQL на сайте вызвал ошибку. 
		|Описание ошибки: " + ОписаниеОшибки();
	КонецПопытки;
	
	// Документ выгрузили, теперь надо в специальную таблицу записать об этом
	
	КодТаблицы 	= "import_bonus";
	КодЗаписи 	= "bonus";
	
	ТекстЗапроса_Добавление = "INSERT INTO exchange_messages (date_created,`table`,record_id,operation,source) VALUES (NOW(), '"+КодТаблицы+"', '"+ТекНомерДок+"', '"+КодЗаписи+"','1С');";
	
	Command = Новый COMОбъект("ADODB.Command");
	Command.CommandTimeout = 100;
	Command.CommandText = ТекстЗапроса_Добавление;
	Command.CommandType = 1;
	Command.ActiveConnection = ADOСоединение;
	
	Попытка
		Command.Execute(); 
	Исключение
		ВызватьИсключение 
		"Ошибка выгрузки бонусов в «Окно поставщика». 
		|Запрос к таблицам MySQL на сайте вызвал ошибку. 
		|Описание ошибки: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ADOСоединение.Close();
	
КонецФункции

Функция ПеревернутьДату(Знач ТекДата, Дата_сВременем = 0) Экспорт
	
	// должно быть так '2011-04-05' (причем можно и так '2011-4-5')
	
	Если Дата_сВременем = 0 Тогда
		Тмп = "" + Формат(Год(ТекДата), "ЧГ=0") + "-" + Месяц(ТекДата) + "-" + День(ТекДата);
	Иначе
		//с 28.01.2016 (проект "новые 4 срока")
		Тмп = ПеревернутьДату(Дата(Лев(ТекДата, 10))) + Сред(ТекДата, 11);
	КонецЕсли;
	
	Возврат Тмп;
	
КонецФункции

Функция ЗаписатьФайлыДляВыгрузкиОтправкиПоставщикам(ДокументСсылка) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ЗаписатьФайлыДляВыгрузкиОтправкиПоставщикам";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если Не ЗначениеЗаполнено(ДокументСсылка) Тогда
		ВызватьИсключение "Не заполнен документ для формирования документов по премии 2%";	
	КонецЕсли;
	
	лок_ТекущаяДата = ТекущаяДатаСеанса();
	КаталогФайлов = КаталогВременныхФайлов() + "SYSLOG\Bonus\";
	
	Файл = Новый Файл(КаталогФайлов);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(КаталогФайлов);
	КонецЕсли;
	
	КаталогФайлов = КаталогФайлов + Год(лок_ТекущаяДата)+"-"+Месяц(лок_ТекущаяДата)+"-"+День(лок_ТекущаяДата)+"\";
	Файл = Новый Файл(КаталогФайлов);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(КаталогФайлов);
	КонецЕсли;
	
	КаталогФайлов = КаталогФайлов + СокрЛП(ДокументСсылка.КонтрагентДебитор.Код) + "\";
	Файл = Новый Файл(КаталогФайлов);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(КаталогФайлов);
	КонецЕсли;
	
	// Акт о предоставлении премии
	ИмяФайла = "Акт_" + СокрЛП(ДокументСсылка.Номер) + "_" + СтрЗаменить(Формат(ДокументСсылка.Дата, "ДФ=dd.MM.yyyy"), ".","") + "_" + СтрЗаменить(Прав(ТекущаяДата(), 8), ":","" ) + ".pdf";
	ПолноеИмяФайла = КаталогФайлов + ИмяФайла ;
	
	ПечатнаяФорма = Справочники.ВнешниеОбработки.НайтиПоНаименованию("Акт о предоставлении премии");
	ОбработкаОбъект = ПечатнаяФорма.ПолучитьОбъект();
	
	ИмяФайлаОтчета = ПолучитьИмяВременногоФайла("epf");
	ДанныеОбработки = ОбработкаОбъект.ХранилищеВнешнейОбработки.Получить();
	ДанныеОбработки.Записать(ИмяФайлаОтчета); 
	
	ПечатнаяФорма = ВнешниеОбработки.Создать(ИмяФайлаОтчета);
	ТабличныйДокумент = ПечатнаяФорма.Печать(ДокументСсылка);
	
	Попытка
		ТабличныйДокумент.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);
	Исключение
		ВызватьИсключение "Ошибка записи акта: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	// Расшифровочная ведомость
	ИмяФайлаРасшВедомость = "Расш_ведомость_" + СокрЛП(ДокументСсылка.Номер) + "_" + СтрЗаменить(Формат(ДокументСсылка.Дата, "ДФ=dd.MM.yyyy"), ".","") + "_" + СтрЗаменить(Прав(ТекущаяДата(), 8), ":","") + ".pdf";
	ПолноеИмяФайлаРасшВедомость = КаталогФайлов + ИмяФайлаРасшВедомость;
	
	ПечатнаяФорма = Справочники.ВнешниеОбработки.НайтиПоНаименованию("Расшифровочная ведомость по премиям");
	ОбработкаОбъект = ПечатнаяФорма.ПолучитьОбъект();
	
	ИмяФайлаОтчета = ПолучитьИмяВременногоФайла("epf");
	ДанныеОбработки = ОбработкаОбъект.ХранилищеВнешнейОбработки.Получить();
	ДанныеОбработки.Записать(ИмяФайлаОтчета); 
	
	ПечатнаяФорма = ВнешниеОбработки.Создать(ИмяФайлаОтчета);
	ТабличныйДокумент = ПечатнаяФорма.Печать(ДокументСсылка);
	
	Попытка
		ТабличныйДокумент.Записать(ПолноеИмяФайлаРасшВедомость, ТипФайлаТабличногоДокумента.PDF);
	Исключение
		ВызватьИсключение "Ошибка записи расшифровочной ведомости: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат Новый Структура("ИмяФайла, ИмяФайлаРасшВедомость, ПолноеИмяФайла, ПолноеИмяФайлаРасшВедомость", ИмяФайла, ИмяФайлаРасшВедомость, ПолноеИмяФайла, ПолноеИмяФайлаРасшВедомость);
	
КонецФункции

Процедура ИнициироватьВыгрузкуОтправкуАктов(ДокументСсылка, ОтправлятьНаПочту = Ложь, ВыгружатьВОкноПоставщика = Истина) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ИнициироватьВыгрузкуОтправкуАктов";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Попытка
		СтруктураАдресаФайлов = ЗаписатьФайлыДляВыгрузкиОтправкиПоставщикам(ДокументСсылка);
	Исключение
		ВызватьИсключение "Не удалось записать файлы по премиям 2% для документа UID: " + ДокументСсылка.УникальныйИдетификатор() + " + по причине: " + ОписаниеОшибки();
	КонецПопытки;
	
	Если ОтправлятьНаПочту Тогда
		ОтправитьДокументыНаПочтуПоставщика(ДокументСсылка, СтруктураАдресаФайлов);
	КонецЕсли;
	
	Если ВыгружатьВОкноПоставщика Тогда
		
		Попытка
			ВыгрузитьВОкноПоставщика(ДокументСсылка, СтруктураАдресаФайлов);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Акт выгружен №" + ДокументСсылка.Номер + "в «Окно поставщика»");
		Исключение
			ВызватьИсключение "Не удалось выгрузить акт №" + ДокументСсылка.Номер + " в «Окно поставщика»." + ОписаниеОшибки();
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры
 
Процедура ОтправитьДокументыНаПочтуПоставщика(ДокументСсылка, СтруктураАдресаФайлов)
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ОтправитьДокументыНаПочтуПоставщика";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
		
	ТекстПисьма = Справочники.ШаблоныТекстовПисем.РасчетБонусаОтПоставщика.ТекстПисьма;
	
	Если Не Справочники.ШаблоныТекстовПисем.РасчетБонусаОтПоставщика.Используется Или Не ЗначениеЗаполнено(ТекстПисьма) Тогда
		ТекстПисьма = ПолучитьТекстПисьмаПоУмолчанию(ДокументСсылка);
	КонецЕсли;
	
	Склад = "Нижний_Новгород";
	
	ТемаПисьма = Справочники.ШаблоныТекстовПисем.РасчетБонусаОтПоставщика.ТемаПисьма;
	
	Если Не Справочники.ШаблоныТекстовПисем.РасчетБонусаОтПоставщика.Используется Или Не ЗначениеЗаполнено(ТемаПисьма) Тогда
		ТемаПисьма = "Акт о начислении премии за период: %1-%2! %3";
	КонецЕсли;	
	
	ТемаПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТемаПисьма, 
	Формат(ДокументСсылка.ПериодАнализаНачало, "ДФ=dd.MM.yyyy"),
	Формат(ДокументСсылка.ПериодАнализаОкончание, "ДФ=dd.MM.yyyy"),
	Склад);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Тема", ТемаПисьма);
	СтруктураПараметров.Вставить("ТекстПисьма", ТекстПисьма);
	
	СписокАдресатов = ПолучитьСписокАдресатов(ДокументСсылка);
	
	Событие = Справочники.СобытияДляОтправкиЭлектронныхПисем.РасчетПремии2Процента;
	
	Вложения = Новый СписокЗначений;
	Вложения.Добавить(Новый Структура("ИмяФайла, Хранилище", СтруктураАдресаФайлов.ИмяФайла, Новый ДвоичныеДанные(СтруктураАдресаФайлов.ПолноеИмяФайла)));
	Вложения.Добавить(Новый Структура("ИмяФайла, Хранилище", СтруктураАдресаФайлов.ИмяФайлаРасшВедомость, Новый ДвоичныеДанные(СтруктураАдресаФайлов.ПолноеИмяФайлаРасшВедомость)));
	
	Попытка
		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Событие, СтруктураПараметров.ТекстПисьма, СтруктураПараметров.Тема, 
		СписокАдресатов, "UTF8", , Вложения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Акт №" + ДокументСсылка.Номер + " отправлен!");
		
		ЗафиксироватьОтправкуАктаВДополнительныхСвойствах(ДокументСсылка);
		
	Исключение
		ВызватьИсключение "Не удалось отправить акт №" + ДокументСсылка.Номер + ". Описание ошибки:" + ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьТекстПисьмаПоУмолчанию(ДокументСсылка)
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ПолучитьТекстПисьмаПоУмолчанию";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Возврат 
	"Уважаемые коллеги!
	|
	|Направляем акт о начислении премии (согласно Приложения 4 к Оферте договора поставки)!
	|Данная премия начисляется 1 раз в квартал и составляет  " + ДокументСсылка.ПроцентБонуса + "% ("+ ЧислоПрописью(ДокументСсылка.ПроцентБонуса) + " %) от общей стоимости Товаров, отгруженных Покупателю Поставщиком за указанный период.
	|
	|Необходимо: 
	|• В срок до 17-го числа текущего месяца приложить скан подписанного и с печатью акта в личном кабинете Поставщика (окно поставщика – раздел Бонусы)
	|• В срок до 20-го числа текущего месяца направить оригинал подписанного и с печатью акта
	|
	|По всем вопросам просьба обращаться к Вашему личному менеджеру ПартКом. 
	|
	|С уважением,
	|Компания ПартКом.";
	
КонецФункции

Функция ПолучитьСписокАдресатов(ДокументСсылка)
	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ПолучитьСписокАдресатов";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.АдресЭП КАК АдресЭлектроннойПочты
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И КонтактнаяИнформация.Вид В(&МассивВидов)
	|	И КонтактнаяИнформация.Объект = &Объект";
	
	МассивВидов = Новый Массив;
	
	МассивВидов.Добавить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами"));
	
	Запрос.УстановитьПараметр("МассивВидов", МассивВидов);
	Запрос.УстановитьПараметр("Объект", ДокументСсылка.КонтрагентДебитор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение "Не удалось определить адрес электронной почты контрагента " + ДокументСсылка.КонтрагентДебитор;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий(); 
	
	СписокАдресатов = Новый СписокЗначений;
	СписокАдресатов.Добавить(ВыборкаДетальныеЗаписи.АдресЭлектроннойПочты);
	
	Возврат СписокАдресатов;
	
КонецФункции

Процедура ЗафиксироватьОтправкуАктаВДополнительныхСвойствах(ДокументСсылка)	
	лКлючАлгоритма = "ОбщийМодуль_БонусыПоставщиковСервер_ЗафиксироватьОтправкуАктаВДополнительныхСвойствах";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
		
	МенеджерЗаписи = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = ДокументСсылка;
	МенеджерЗаписи.Свойство = ПланыВидовХарактеристик.СвойстваОбъектов.Бонус2_ДатаОтправкиДокументовНаПочту;
	МенеджерЗаписи.Значение = ТекущаяДатаСеанса();
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры
// 15.04.19 Строганов Роман <