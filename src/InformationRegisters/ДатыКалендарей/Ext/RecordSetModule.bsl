﻿////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет ресурсы "Пятидневка", "Шестидневка" и "КалендарныеДни"
Процедура ЗаполнитьРесурсыЗаписиРегистра(ЗаписьРегистра) Экспорт
	
	// рабочий день
	Если ЗаписьРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Рабочий ИЛИ
		ЗаписьРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Предпраздничный Тогда
		
		ЗаписьРегистра.Пятидневка  = 1;
		ЗаписьРегистра.Шестидневка = 1;
		ЗаписьРегистра.КалендарныеДни = 1;
		
		// суббота	
	ИначеЕсли ЗаписьРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Суббота Тогда
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 1;
		ЗаписьРегистра.КалендарныеДни = 1;
		
		// воскресение
	ИначеЕсли ЗаписьРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Воскресенье Тогда
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 0;
		ЗаписьРегистра.КалендарныеДни = 1;
		
		// празничный день	
	Иначе  
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 0;
		ЗаписьРегистра.КалендарныеДни = 0;
		
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

Функция ПервоначальноеЗаполнениеРегистра(КонтрольнаяДата, мКалендарь,Сообщать = Истина) Экспорт
	
	ТаблицаРегистра = Новый ТаблицаЗначений();
	ТаблицаРегистра.Колонки.Добавить("ДатаКалендаря");
	ТаблицаРегистра.Колонки.Добавить("ВидДня");
	ТаблицаРегистра.Индексы.Добавить("ДатаКалендаря");

	мДлинаСуток = 86400;
	
	// Заполнение регистра за год
	ПервоеЯнваря = НачалоГода(КонтрольнаяДата);
	СписокПраздниковВВыходные = Новый СписокЗначений;
	
	СписокПраздников = РегламентированнаяОтчетность.ПолучитьСписокПраздниковРФ(Год(КонтрольнаяДата));
	
	Для НомерДня = 1 По ДеньГода(КонецГода(КонтрольнаяДата)) Цикл
		
		ЗаписываемаяДата 	= НачалоДня(ПервоеЯнваря + мДлинаСуток * (НомерДня - 1));
		ПраздничныйДень = СписокПраздников.НайтиПоЗначению("" + Формат(ЗаписываемаяДата, "ДФ = 'ММ'") + Формат(ЗаписываемаяДата, "ДФ = 'дд'"));
		
		НоваяЗаписьРегистраВидДня =Перечисления.ВидыДнейКалендаря.Рабочий; 
		
		Если ПраздничныйДень <> Неопределено Тогда
			
			НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейКалендаря.Праздник;
			
			Если ДеньНедели(ЗаписываемаяДата) > 5 Тогда
				
				СписокПраздниковВВыходные.Добавить(ЗаписываемаяДата, ПраздничныйДень);
				
			КонецЕсли;
			
			// Предпразничные дни
			Если НомерДня > 1 Тогда
				
				СтрокаТаблицы = ТаблицаРегистра.Найти(ЗаписываемаяДата - мДлинаСуток,"ДатаКалендаря");
				Если СтрокаТаблицы.ВидДня = Перечисления.ВидыДнейКалендаря.Рабочий Тогда
					СтрокаТаблицы.ВидДня = Перечисления.ВидыДнейКалендаря.Предпраздничный;
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе
			
			Если ДеньНедели(ЗаписываемаяДата) = 6 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейКалендаря.Суббота
			ИначеЕсли ДеньНедели(ЗаписываемаяДата) = 7 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейКалендаря.Воскресенье
			Иначе
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейКалендаря.Рабочий
			КонецЕсли; 
			
		КонецЕсли; 
		
		// Запишем в таблицу значений
		НоваяСтрокаТаблицыРегистра = ТаблицаРегистра.Добавить();
		НоваяСтрокаТаблицыРегистра.ДатаКалендаря = ЗаписываемаяДата;
		НоваяСтрокаТаблицыРегистра.ВидДня        = НоваяЗаписьРегистраВидДня;
		
	КонецЦикла; 
	
	// 31 декабря предпраздничный день в таблице
	Если НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Рабочий Тогда
		НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.ВидыДнейКалендаря.Предпраздничный;
	КонецЕсли;
	ПеренестиВыходныеДни(Год(КонтрольнаяДата), мКалендарь, ТаблицаРегистра);
	Если Сообщать и СписокПраздниковВВыходные.Количество() > 0 Тогда
		
		ЗаКакойГод = Год(КонтрольнаяДата);
		
		Сообщить("При заполнении календаря на " + Формат(ЗаКакойГод,"ЧЦ=4; ЧГ=0") + " год обнаружены государственные праздники, попадающие на выходные дни:"); 
		
		Для Сч = 1 По СписокПраздниковВВыходные.Количество() Цикл
			Сообщить("   " + Формат(СписокПраздниковВВыходные[Сч - 1].Значение, "ДФ ='дд ММММ'") + " - " + СписокПраздниковВВыходные[Сч - 1])
		КонецЦикла; 
		
		Сообщить("Необходимо перенести эти выходные дни на следующий после праздничного рабочий день.", СтатусСообщения.Внимание)
		
	КонецЕсли; 
	
	Возврат ТаблицаРегистра
	
КонецФункции

Процедура ПеренестиВыходныеДни(Год, мКалендарь = Неопределено, КалендарьТаблицаЗначений = Неопределено) Экспорт
	
	Если мКалендарь = неопределено Тогда
		мКалендарь = Справочники.Календари.Регламентированный;
	КонецЕсли;
	
	ТаблицаПеремещаемыхВидовДня = Новый ТаблицаЗначений();
	ТаблицаПеремещаемыхВидовДня.Колонки.Добавить("ЗаменяемаяДата", Новый ОписаниеТипов("Дата"));
	ТаблицаПеремещаемыхВидовДня.Колонки.Добавить("ДатаЧемЗаменяем", Новый ОписаниеТипов("Дата"));
	ТаблицаПеремещаемыхВидовДня.Колонки.Добавить("ЗаменяемаяДатаВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДнейКалендаря"));
	ТаблицаПеремещаемыхВидовДня.Колонки.Добавить("ДатаЧемЗаменяемВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДнейКалендаря"));
	
	Если Год = 2012 Тогда
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Обновление изменений в календаре                                                                                                          //
		// Постановление от 15 марта 2012 г. №201 "О внесении изменения в постановление Правительства Российской Федерации от 20 июля 2011 г. № 581" //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		СтрокаДаты = ТаблицаПеремещаемыхВидовДня.Добавить();
		СтрокаДаты.ЗаменяемаяДата = '20120507';
		СтрокаДаты.ДатаЧемЗаменяем = '20120505';
		СтрокаДаты.ЗаменяемаяДатаВидДня = Перечисления.ВидыДнейКалендаря.Рабочий;
		СтрокаДаты.ДатаЧемЗаменяемВидДня = Перечисления.ВидыДнейКалендаря.Суббота;
		
		СтрокаДаты = ТаблицаПеремещаемыхВидовДня.Добавить();
		СтрокаДаты.ЗаменяемаяДата = '20120508';
		СтрокаДаты.ДатаЧемЗаменяем = '20120512';
		СтрокаДаты.ЗаменяемаяДатаВидДня = Перечисления.ВидыДнейКалендаря.Предпраздничный;
		СтрокаДаты.ДатаЧемЗаменяемВидДня = Перечисления.ВидыДнейКалендаря.Суббота;
	КонецЕсли;
	
	Если ТаблицаПеремещаемыхВидовДня.Количество() = 0.00 Тогда
		возврат;
	Иначе
		Если КалендарьТаблицаЗначений = Неопределено Тогда
			////////////////////////////////////////////////////////////////////////////////
			// Обновление регистра сведений Регламентированный производственный календарь //
			// Для даты ЗаменяемаяДата вид дня заменяется на ДатаЧемЗаменяемВидДня        //
			// Для даты ДатаЧемЗаменяем вид дня заменяется на ЗаменяемаяДатаВидДня        //
			////////////////////////////////////////////////////////////////////////////////
			Запрос = Новый Запрос();
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ТаблицаПеремещаемыхВидовДня.ЗаменяемаяДата        КАК ЗаменяемаяДата,
			|	ТаблицаПеремещаемыхВидовДня.ДатаЧемЗаменяем       КАК ДатаЧемЗаменяем,
			|	ТаблицаПеремещаемыхВидовДня.ЗаменяемаяДатаВидДня  КАК ЗаменяемаяДатаВидДня,
			|	ТаблицаПеремещаемыхВидовДня.ДатаЧемЗаменяемВидДня КАК ДатаЧемЗаменяемВидДня
			|ПОМЕСТИТЬ ТаблицаПеремещаемыхВидовДня
			|ИЗ
			|	&ТаблицаПеремещаемыхВидовДня КАК ТаблицаПеремещаемыхВидовДня
			|ИНДЕКСИРОВАТЬ ПО
			|	ЗаменяемаяДата,
			|	ДатаЧемЗаменяем
			|;
			|ВЫБРАТЬ
			|	ТаблицаПеремещаемыхВидовДня.ЗаменяемаяДата  КАК ЗаменяемаяДата,
			|	ТаблицаПеремещаемыхВидовДня.ДатаЧемЗаменяем КАК ДатаЧемЗаменяем,
			|	КалендарьЗаменяемаяДата.ВидДня              КАК ВидДняЗаменяемаяДата,
			|	КалендарьДатаЧемЗаменяем.ВидДня             КАК ВидДняДатаЧемЗаменяем
			|ИЗ
			|	ТаблицаПеремещаемыхВидовДня КАК ТаблицаПеремещаемыхВидовДня
			|ЛЕВОЕ СОЕДИНЕНИЕ
			|	РегистрСведений.ДатыКалендарей КАК КалендарьЗаменяемаяДата
			|ПО
			|	ТаблицаПеремещаемыхВидовДня.ЗаменяемаяДата = КалендарьЗаменяемаяДата.ДатаКалендаря
			|	И КалендарьЗаменяемаяДата.Год = &Год
			|	И КалендарьЗаменяемаяДата.Календарь = &Календарь
			|	И ТаблицаПеремещаемыхВидовДня.ЗаменяемаяДатаВидДня = КалендарьЗаменяемаяДата.ВидДня
			|ЛЕВОЕ СОЕДИНЕНИЕ
			|	РегистрСведений.ДатыКалендарей КАК КалендарьДатаЧемЗаменяем
			|ПО
			|	ТаблицаПеремещаемыхВидовДня.ДатаЧемЗаменяем = КалендарьДатаЧемЗаменяем.ДатаКалендаря
			|	И КалендарьДатаЧемЗаменяем.Год = &Год
			|	И КалендарьДатаЧемЗаменяем.Календарь = &Календарь
			|	И ТаблицаПеремещаемыхВидовДня.ДатаЧемЗаменяемВидДня = КалендарьДатаЧемЗаменяем.ВидДня
			|ГДЕ
			|	НЕ КалендарьЗаменяемаяДата.ДатаКалендаря ЕСТЬ NULL
			|	И НЕ КалендарьДатаЧемЗаменяем.ДатаКалендаря ЕСТЬ NULL
			|";
			Запрос.УстановитьПараметр("ТаблицаПеремещаемыхВидовДня", ТаблицаПеремещаемыхВидовДня);
			Запрос.УстановитьПараметр("Год", Год);
			Запрос.УстановитьПараметр("Календарь", мКалендарь);
			РезультатЗапросаВидыДней = Запрос.Выполнить();
			Если НЕ РезультатЗапросаВидыДней.Пустой() Тогда
				ВыборкаЗаменяемыхВидовДня = РезультатЗапросаВидыДней.Выбрать();
				НаборЗаписей = РегистрыСведений.РегламентированныйПроизводственныйКалендарь.СоздатьНаборЗаписей();
				//НаборЗаписей.Отбор.Год.Установить(Год);
				//НаборЗаписей.Отбор.Год.Установить(мКалендарь);
				НаборЗаписей.Отбор.Календарь.Значение		 = мКалендарь;
				НаборЗаписей.Отбор.Календарь.Использование = Истина;
				НаборЗаписей.Отбор.Год.Значение		 = Год;
				НаборЗаписей.Отбор.Год.Использование = Истина;
				Пока ВыборкаЗаменяемыхВидовДня.Следующий() Цикл
					НаборЗаписей.Отбор.ДатаКалендаря.Установить(ВыборкаЗаменяемыхВидовДня.ЗаменяемаяДата);
					ЗаписьНабора = НаборЗаписей.Добавить();
					ЗаписьНабора.Год = Год;
					ЗаписьНабора.Календарь = мКалендарь;
					ЗаписьНабора.ДатаКалендаря = ВыборкаЗаменяемыхВидовДня.ЗаменяемаяДата;
					ЗаписьНабора.ВидДня = ВыборкаЗаменяемыхВидовДня.ВидДняДатаЧемЗаменяем;
					НаборЗаписей.ЗаполнитьРесурсыЗаписиРегистра(ЗаписьНабора);
					НаборЗаписей.Записать();
					НаборЗаписей.Очистить();
					
					НаборЗаписей.Отбор.ДатаКалендаря.Установить(ВыборкаЗаменяемыхВидовДня.ДатаЧемЗаменяем);
					ЗаписьНабора = НаборЗаписей.Добавить();
					ЗаписьНабора.Год = Год;
					ЗаписьНабора.Календарь = мКалендарь;
					ЗаписьНабора.ДатаКалендаря = ВыборкаЗаменяемыхВидовДня.ДатаЧемЗаменяем;
					ЗаписьНабора.ВидДня = ВыборкаЗаменяемыхВидовДня.ВидДняЗаменяемаяДата;
					НаборЗаписей.ЗаполнитьРесурсыЗаписиРегистра(ЗаписьНабора);
					НаборЗаписей.Записать();
					НаборЗаписей.Очистить();
				КонецЦикла;
			КонецЕсли;
		Иначе
			/////////////////////////////////////////////////////////////////////////
			// Заполнение из формы регламентированного производственного календаря //
			/////////////////////////////////////////////////////////////////////////
			Для каждого СтрокаЗаменяемыеДаты Из ТаблицаПеремещаемыхВидовДня Цикл
				СтрокаТаблицыЗаменяемаяДата = КалендарьТаблицаЗначений.Найти(СтрокаЗаменяемыеДаты.ЗаменяемаяДата, "ДатаКалендаря");
				СтрокаТаблицыДатаЧемЗаменяем = КалендарьТаблицаЗначений.Найти(СтрокаЗаменяемыеДаты.ДатаЧемЗаменяем, "ДатаКалендаря");
				Если СтрокаТаблицыЗаменяемаяДата = Неопределено ИЛИ СтрокаТаблицыДатаЧемЗаменяем = Неопределено Тогда
					продолжить;
				Иначе
					ЗаменяемаяДатаВидДня = СтрокаТаблицыЗаменяемаяДата.ВидДня;
					ДатаЧемЗаменяемВидДня = СтрокаТаблицыДатаЧемЗаменяем.ВидДня;
					СтрокаТаблицыЗаменяемаяДата.ВидДня = ДатаЧемЗаменяемВидДня;
					СтрокаТаблицыДатаЧемЗаменяем.ВидДня = ЗаменяемаяДатаВидДня;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет запись в регистр сведений "РегламентированныйПроизводственныйКалендарь" данных из временной таблицы 
Процедура ЗаписатьИзТаблицыВРегистр(ТаблицаРегистра,ГодЗаписи, мКалендарь) Экспорт

	// Очистим старые данные за год
	НаборЗаписей = РегистрыСведений.ДатыКалендарей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Календарь.Значение		 = мКалендарь;
	НаборЗаписей.Отбор.Календарь.Использование = Истина;
	НаборЗаписей.Отбор.Год.Значение		 = ГодЗаписи;
	НаборЗаписей.Отбор.Год.Использование = Истина;
	НаборЗаписей.Прочитать();
	
	ЕстьЗаписиВРегистре = НаборЗаписей.Количество() > 0;
	
	// Запишем новые данные за год
	Если ЕстьЗаписиВРегистре Тогда
		Для каждого Запись Из НаборЗаписей Цикл
			СтрокаТаблицы = ТаблицаРегистра.Найти(Запись.ДатаКалендаря,"ДатаКалендаря");
			Запись.ВидДня = СтрокаТаблицы.ВидДня;
			// Установим ресурсы "Пятидневка", "Шестидневка" и "КалендарныеДни"
			ЗаполнитьРесурсыЗаписиРегистра(Запись);
		КонецЦикла; 
	Иначе
		Для Каждого СтрокаТаблицы ИЗ ТаблицаРегистра Цикл
			НоваяЗаписьРегистра = НаборЗаписей.Добавить();
			НоваяЗаписьРегистра.ДатаКалендаря = СтрокаТаблицы.ДатаКалендаря;
			НоваяЗаписьРегистра.Год			  = Год(СтрокаТаблицы.ДатаКалендаря);
			НоваяЗаписьРегистра.Календарь = мКалендарь;
			НоваяЗаписьРегистра.ВидДня		  = СтрокаТаблицы.ВидДня;
			// Установим ресурсы "Пятидневка", "Шестидневка" и "КалендарныеДни"
			ЗаполнитьРесурсыЗаписиРегистра(НоваяЗаписьРегистра);
		КонецЦикла; 
	КонецЕсли;
	
	// запишем набор записей
	НаборЗаписей.Записать();
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ МОДУЛЯ
