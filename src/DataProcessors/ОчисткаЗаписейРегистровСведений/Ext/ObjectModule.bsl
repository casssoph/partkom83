﻿
Процедура ВыполнитьРегламентноеЗадание() Экспорт
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ВыполнитьРегламентноеЗадание";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	ТекстОшибки = "";
	ВосстановитьНастройки();
	ВыполнитьОчисткуЗаписейРегистров(ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		//Записать в крит события, добавить событие
		ЗаписьЖурналаРегистрации("Обработка Очистка записей регистров сведений",УровеньЖурналаРегистрации.Ошибка,,,"Ошибка: "+ТекстОшибки,);
		
		Сообщить("Ошибка:", СтатусСообщения.Важное);
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

Функция ВыполнитьОчисткуЗаписейРегистров(ТекстОшибки = "") Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ВыполнитьОчисткуЗаписейРегистров";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Успешно = Истина;
	
	//Проверим настройки
	Успешно = ПроверитьНастройкиПередВыполнением(ТекстОшибки);
	
	//Получим подключение
	Если Успешно Тогда
		Соединение = ПолучитьСоединение(ТекстОшибки);
		
		Если Соединение = Неопределено Тогда
			Успешно = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	//Очищаем
	Если Успешно Тогда
		Для каждого СтрокаНастроек Из ТаблицаРегистров Цикл
			
			Если Не СтрокаНастроек.Использовать Тогда
				Продолжить;
			КонецЕсли;
			
			Попытка
				ОчиститьРегистрСведенийВSQL(Соединение, СтрокаНастроек, ЗаписыватьЛог);
			Исключение
				
				Успешно = Ложь;
				ДобавитьВТекстОшибки(ТекстОшибки, "Ошибка удаления записей: Имя регистра: "+СтрокаНастроек.Имя+":"+ОписаниеОшибки());
				
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

//Контроль заполнения

Функция ПроверитьНастройкиПередВыполнением(ТекстОшибки) Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ПроверитьНастройкиПередВыполнением";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Успешно = Истина;
	
	Если НЕ НастройкиКорректны(ТекстОшибки) Тогда
		Успешно = Ложь;
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

Функция НастройкиКорректны(ТекстОшибки = "")
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_НастройкиКорректны";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	НастройкиКорректны = Истина;
	
	Для каждого СтрокаТаблицыРегистров Из ТаблицаРегистров Цикл
		
		Если Не СтрокаТаблицыРегистров.Использовать Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицыРегистров.Имя) Тогда
			ДобавитьВТекстОшибки(ТекстОшибки, "Не задано имя регистра в строке "+СтрокаТаблицыРегистров.НомерСтроки);
			НастройкиКорректны = Ложь;	
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТаблицыРегистров.ИмяПоляПериода) Тогда
			ДобавитьВТекстОшибки(ТекстОшибки, "Не задано имя поля периода в строке "+СтрокаТаблицыРегистров.НомерСтроки);
			НастройкиКорректны = Ложь;	
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыРегистров.РежимГраницы) Тогда
			ДобавитьВТекстОшибки(ТекстОшибки, "Не задан режим границы в строке "+СтрокаТаблицыРегистров.НомерСтроки);
			НастройкиКорректны = Ложь;	
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыРегистров.ГраницаДата)
			И НЕ ЗначениеЗаполнено(СтрокаТаблицыРегистров.ГраницаКоличествоЗаписей) Тогда
			ДобавитьВТекстОшибки(ТекстОшибки, "Не задано значение границы в строке "+СтрокаТаблицыРегистров.НомерСтроки);
			НастройкиКорректны = Ложь;	
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыРегистров.Порция) Тогда
			ДобавитьВТекстОшибки(ТекстОшибки, "Не задана порция в строке "+СтрокаТаблицыРегистров.НомерСтроки);
			НастройкиКорректны = Ложь;	
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НастройкиКорректны;	
	
КонецФункции

//Удаление записей

Функция ОчиститьРегистрСведенийВSQL(Соединение, ПараметрыОчистки, ЗаписыватьВЖР = Ложь)
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ОчиститьРегистрСведенийВSQL";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	ОбъектМетаданных = Метаданные.РегистрыСведений.Найти(ПараметрыОчистки.Имя);
	
	ИмяРегистра = ПараметрыОчистки.Имя;
	
	ПолеДаты = ПараметрыОчистки.ИмяПоляПериода;
	
	Если ПараметрыОчистки.РежимГраницы = "ПоДате" Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 "+ПолеДаты+" ИЗ РегистрСведений." + ИмяРегистра + " ГДЕ "+ПолеДаты+" <= &Дата");
		Запрос.УстановитьПараметр("Дата", КонецДня(ПараметрыОчистки.ГраницаДата));
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ПараметрыОчистки.РежимГраницы = "ПоКоличествуЗаписей" Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ Сумма(1) КАК КоличествоЗаписей ИЗ РегистрСведений." + ИмяРегистра);
		Выборка = Запрос.Выполнить().Выбрать();
		КоличествоЗаписей = 0;
		Если Выборка.Следующий() Тогда
			КоличествоЗаписей = Выборка.КоличествоЗаписей;
		КонецЕсли;
		
		Если КоличествоЗаписей <= ПараметрыОчистки.ГраницаКоличествоЗаписей Тогда
			Возврат Ложь;
		КонецЕсли;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ЗаписыватьВЖР Тогда
		ЗаписьЖурналаРегистрации("Очистка данных",УровеньЖурналаРегистрации.Ошибка,,,ИмяРегистра,);
	КонецЕсли;

	МассивМетаданнных = Новый Массив();
	МассивМетаданнных.Добавить(ОбъектМетаданных);
	
	ТаблицаБД = СтруктураХраненияБазыДанных(МассивМетаданнных);
	
	СтрокаТЗ = ТаблицаБД.Найти("Основная", "Назначение");
	ИмяТаблицы = СтрокаТЗ.ИмяТаблицыХранения;
	ИмяПоляПериода = СтрокаТЗ.Поля.Найти(ПолеДаты, "ИмяПоля").ИмяПоляХранения;
	
	Для каждого СтрокаТаблицыБазыДанных ИЗ ТаблицаБД Цикл
		Если СтрокаТаблицыБазыДанных.Назначение = "Основная" Тогда
			ОбрезатьТаблицуВSQL(Соединение, ИмяТаблицы, ПараметрыОчистки, ИмяПоляПериода, ЗаписыватьВЖР);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Процедура ОбрезатьТаблицуВSQL(Соединение, ИмяТаблицы, ПараметрыОчистки, ИмяПоляПериода, ЗаписыватьВЖР = Ложь)
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ОбрезатьТаблицуВSQL";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Команда = "";
	Если ПараметрыОчистки.РежимГраницы = "ПоДате" Тогда
		
		//Команда = "DELETE TOP ("+ Формат(ПараметрыОчистки.Порция,"ЧГ=0") +") FROM dbo._" + ИмяТаблицы + " as t
		//|	WHERE _"+ИмяПоляПериода+" < " + ДатаSQL(ПараметрыОчистки.ГраницаДата)+"
		//|	Order by _"+ИмяПоляПериода;
		
		Команда = "DELETE FROM dbo._" + ИмяТаблицы + "
		|	WHERE _"+ИмяПоляПериода+" IN 
		|	(SELECT TOP ("+ Формат(ПараметрыОчистки.Порция,"ЧГ=0") +") _"+ИмяПоляПериода+" 
		|	FROM dbo._" + ИмяТаблицы + " 
		|	WHERE _"+ИмяПоляПериода+" < " + ДатаSQL(ПараметрыОчистки.ГраницаДата)+"
		|	Order by _"+ИмяПоляПериода+" )";
		
	ИначеЕсли ПараметрыОчистки.РежимГраницы = "ПоКоличествуЗаписей" Тогда
		
		Команда = "DELETE FROM dbo._" + ИмяТаблицы + "
		|	WHERE _"+ИмяПоляПериода+" IN 
		|	(SELECT TOP ("+ Формат(ПараметрыОчистки.Порция,"ЧГ=0") +") _"+ИмяПоляПериода+" 
		|	FROM dbo._" + ИмяТаблицы + " 
		|	Order by _"+ИмяПоляПериода+" )";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Команда) Тогда
		ВыполнитьКомандуSQL(Команда, Соединение, ЗаписыватьВЖР);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКомандуSQL(Команда, Соединение, ЗаписыватьВЖР = Ложь)
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ВыполнитьКомандуSQL";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если ЗаписыватьВЖР Тогда
		ЗаписьЖурналаРегистрации("ВыполнитьКомандуSQL",УровеньЖурналаРегистрации.Ошибка,,,"Команда = " + Команда,);
		ЗаписьЖурналаРегистрации("ВыполнитьКомандуSQL",УровеньЖурналаРегистрации.Ошибка,,,"Начало выполнения: " + ТекущаяДата());
	КонецЕсли;
	
	НачатьТранзакцию();
	
	КомандаSQL     = Новый COMОбъект("ADODB.Command");
	КомандаSQL.ActiveConnection   = Соединение;
	КомандаSQL.CommandText = Команда;
	КомандаSQL.CommandTimeout = 1800;
	
	Выборка = КомандаSQL.Execute();
	
	
	аа =1;
	
	ЗафиксироватьТранзакцию();
	
	
	Если ЗаписыватьВЖР Тогда
		ЗаписьЖурналаРегистрации("ВыполнитьКомандуSQL",УровеньЖурналаРегистрации.Ошибка,,,"Окончание выполнения: " + ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры

//Подключение 

Функция ПолучитьСоединение(ТекстОшибки = "", СообщатьОбОшибке = Истина)
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ПолучитьСоединение";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Попытка
		
		Соединение  = Новый COMОбъект("ADODB.Connection");
		Команда     = Новый COMОбъект("ADODB.Command");
		Выборка     = Новый COMОбъект("ADODB.RecordSet");
		
		СтрокаПодключения = ПолучитьСтрокуПодключения();
		Соединение.ConnectionString = СтрокаПодключения;
		Соединение.ConnectionTimeout = 30;
		Соединение.CommandTimeout = 900;
		Соединение.Open();
		Команда.ActiveConnection   = Соединение;
		
		Возврат Соединение;
		
	Исключение
		
		ДобавитьВТекстОшибки(ТекстОшибки, "Ошибка установки соединения с SQL. Строка подключения: "+СтрокаПодключения+", описание ошибки: "+ОписаниеОшибки());
		
		Если СообщатьОбОшибке Тогда
			Сообщить(ТекстОшибки);
		КонецЕсли;
		
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции

Функция ПолучитьСтрокуПодключения()
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ПолучитьСтрокуПодключения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	СтрокаПодключения = "";
	
	Если ИспользоватьСобственныеНастройкиПодключения Тогда
		
		СтрокаПодключения =
		"driver={SQL Server};" +
		"server="+ИмяСервераSQL+";"+
		"database="+БазаДанныхSQL+";";
		
		Если ПроверкаПодлинностиWindows Тогда
			СтрокаПодключения = СтрокаПодключения + "Trusted_Connection=Yes";
		Иначе
			СтрокаПодключения = СтрокаПодключения + 	
			"uid="+ПользовательSQL+";"+
			"pwd="+ПарольSQL+";"+
			"Trusted_Connection=No";
		КонецЕсли;
	Иначе
		
		СтрокаПодключения = РаботаСSQL.СтрокаСоединенияSQL();	
		
	КонецЕсли;
	
	Возврат СтрокаПодключения;
	
КонецФункции

 //Прочее

Процедура ДобавитьВТекстОшибки(ТекстОшибки, Добавка)
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки +Символы.ПС+Добавка;
	Иначе
		ТекстОшибки = Добавка;
	КонецЕсли;	
	
КонецПроцедуры
 
Функция ДатаSQL(вхДата)
	
	ДатаПараметр = ДобавитьМесяц(КонецДня(вхДата),24000);
	
	Возврат "CONVERT(datetime, '"+Формат(ДатаПараметр,"ДФ='yyyy-MM-dd HH:mm:ss'")+"', 21)";	
	
КонецФункции

Функция СтруктураХраненияБазыДанных(МассивОбъектовМетаданных)
	
	Возврат ПолучитьСтруктуруХраненияБазыДанных(МассивОбъектовМетаданных);	
	
КонецФункции

Функция СписокДоступныхРегистровСведений() Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_СписокДоступныхРегистровСведений";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	СЗ = Новый СписокЗначений;
	Для каждого РегистрСведений Из Метаданные.РегистрыСведений Цикл
		
		Если //НЕ Строка(РегистрСведений.РежимЗаписи) = "Независимый"
			//ИЛИ Строка(РегистрСведений.ПериодичностьРегистраСведений) = "Непериодический" 
			РегистрСведений.РазрешитьИтогиСрезПервых = Истина
			ИЛИ РегистрСведений.РазрешитьИтогиСрезПоследних = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Если СписокДоступныхПолейПериодовРегистраСведений(РегистрСведений.Имя).Количество() Тогда
			СЗ.Добавить(РегистрСведений.Имя, РегистрСведений.Имя);	
		КонецЕсли;
		
	КонецЦикла;	
	
	СЗ.СортироватьПоЗначению();
	
	Возврат СЗ;
	
КонецФункции

Функция СписокДоступныхПолейПериодовРегистраСведений(Имя) Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_СписокДоступныхПолейПериодовРегистраСведений";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	СписокДоступныхПолейПериодов = Новый СписокЗначений;
	
	Если Не ЗначениеЗаполнено(Имя) Тогда
		Возврат СписокДоступныхПолейПериодов;
	КонецЕсли;
	
	МД = Метаданные.РегистрыСведений[Имя];
	
	Если Строка(МД.ПериодичностьРегистраСведений) <> "Непериодический" Тогда
		СписокДоступныхПолейПериодов.Добавить("Период");
	Иначе
		
		//Берем все, которые имеют тип Дата
		Для каждого Итератор Из МД.Измерения Цикл
			Если Итератор.Тип.СодержитТип(Тип("Дата")) Тогда
				СписокДоступныхПолейПериодов.Добавить(Итератор.Имя);
			КонецЕсли;
		КонецЦикла;
		Для каждого Итератор Из МД.Ресурсы Цикл
			Если Итератор.Тип.СодержитТип(Тип("Дата")) Тогда
				СписокДоступныхПолейПериодов.Добавить(Итератор.Имя);
			КонецЕсли;
		КонецЦикла;	
		Для каждого Итератор Из МД.Реквизиты Цикл
			Если Итератор.Тип.СодержитТип(Тип("Дата")) Тогда
				СписокДоступныхПолейПериодов.Добавить(Итератор.Имя);
			КонецЕсли;
		КонецЦикла;	
		
	КонецЕсли;
	
	Возврат СписокДоступныхПолейПериодов;
	
КонецФункции

Функция СписокРежимовГраниц() Экспорт
	
	СЗ = Новый СписокЗначений;
	СЗ.Добавить("ПоДате", "ПоДате");
	СЗ.Добавить("ПоКоличествуЗаписей", "ПоКоличествуЗаписей");
	
	Возврат СЗ;
	
КонецФункции

//Настройки

Процедура ВосстановитьНастройки() Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ВосстановитьНастройки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	СтруктураНастройки = ИнициализироватьСтруктуруНастройки();
	
	Если УниверсальныеМеханизмы.ПолучитьНастройку(СтруктураНастройки)
		И ТипЗнч(СтруктураНастройки.СохраненнаяНастройка) = Тип("Структура") Тогда
		
		Для Каждого текРеквизит Из ЭтотОбъект.Метаданные().Реквизиты Цикл
			ЗначРеквизита = Неопределено;
			Если СтруктураНастройки.СохраненнаяНастройка.Свойство(текРеквизит.Имя, ЗначРеквизита) Тогда
				ЭтотОбъект[текРеквизит.Имя] = ЗначРеквизита;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого текИмяТЧ Из ЭтотОбъект.Метаданные().ТабличныеЧасти Цикл
			ЗначТЧ = Неопределено;
			Если СтруктураНастройки.СохраненнаяНастройка.Свойство(текИмяТЧ.Имя, ЗначТЧ) Тогда
				ЭтотОбъект[текИмяТЧ.Имя].Загрузить(ЗначТЧ);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Сообщить("Не найдено сохраненной настройки!");		
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьНастройки() Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_СохранитьНастройки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	СохраненнаяНастройка = Новый Структура;
	Для Каждого текРеквизит Из ЭтотОбъект.Метаданные().Реквизиты Цикл
		СохраненнаяНастройка.Вставить(текРеквизит.Имя, ЭтотОбъект[текРеквизит.Имя]);
	КонецЦикла;
	Для Каждого текТабЧасть Из ЭтотОбъект.Метаданные().ТабличныеЧасти Цикл
		СохраненнаяНастройка.Вставить(текТабЧасть.Имя, ЭтотОбъект[текТабЧасть.Имя].Выгрузить());
	КонецЦикла;

	СтруктураНастройки = ИнициализироватьСтруктуруНастройки();
	СтруктураНастройки.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);

	УниверсальныеМеханизмы.СохранитьНастройку(СтруктураНастройки)

КонецПроцедуры

Функция ИнициализироватьСтруктуруНастройки() Экспорт
	
	лКлючАлгоритма = "Обработка_ОчисткаЗаписейРегистровСведений_МодульОбъекта_ИнициализироватьСтруктуруНастройки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", Справочники.Пользователи.ПустаяСсылка());
	СтруктураНастройки.Вставить("ИмяОбъекта", "ОбработкаОчисткаЗаписейРегистровСведений");
	СтруктураНастройки.Вставить("НаименованиеНастройки", "Основная");
	
	Возврат СтруктураНастройки;
	
КонецФункции
