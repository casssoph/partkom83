﻿// Обработчик события УстановкаПараметровСеанса()
//
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	//// БЛОКИРОВКА ФОНОВЫХ ЗАДАНИЙ ПРИ КОПИРОВАНИИ РАБОЧЕЙ
	// Добавлено Валиахметов А.А. 19.02.2018	
	Если Не ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() И Не Константы.ПроведеноОтключениеРеглЗаданий.Получить() Тогда 
		УстановитьПривилегированныйРежим(Истина);
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	РегламентныеЗадания.ИдентификаторРегламентногоЗадания
		               |ИЗ
		               |	Справочник.РегламентныеЗадания КАК РегламентныеЗадания
		               |ГДЕ
		               |	НЕ РегламентныеЗадания.ЭтоГруппа";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			Результат = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторРегламентногоЗадания);
			Если Результат <> Неопределено И Результат.Использование Тогда 
				Результат.Использование = Ложь;
				Результат.Записать();
				#Если Не ВнешнееСоединение Тогда
					Сообщить("Отключено регл. задание: " + Результат.Наименование); 
				#КонецЕсли
			КонецЕсли;
		КонецЦикла;
		Константы.ПроведеноОтключениеРеглЗаданий.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		ВызватьИсключение "Выполнено отключение регламентных заданий. Перезапустите сеанс.";
	КонецЕсли;
	// Конец Добавлено Валиахметов А.А. 19.02.2018	

	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	
	// Выполняем только один раз - при запуске
	Если ИменаПараметровСеанса = Неопределено Тогда
		
		ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Новый Структура);
	
		ПолныеПрава.ОпределитьПараметрыСеансаДляОбменаДанными();
		
		ПолныеПрава.УстановитьПараметрыСеансаДатыПерехода();
		
		ПолныеПрава.УстановитьОсновныеВалютыУпрУчета();
		
		ПолныеПрава.УстановитьПараметрСеансаИзКонстанты("ОпределятьСтратегиюПогашенияПартийТоваровПоСкладу");
		ПолныеПрава.УстановитьПараметрСеансаИзКонстанты("СтратегияСписанияПартий");          
		
		//[Тарасов А.В.]
		ПолныеПрава.ЗаполнитьСписокРегистровЗапрещенныхКПроведению();
		//[Тарасов А.В.]
	КонецЕсли;
	
	//<< вн

    внЖурналРегистрации.УстановкаПараметровСеанса();

    //>>
	
	// APDEX, ЛНА 2018-09-13
	
	Если ИменаПараметровСеанса = Неопределено ИЛИ ИменаПараметровСеанса.Найти("APDEX_НастройкиЗамеров")<>Неопределено Тогда
		ХранилищеЗначения = Новый ХранилищеЗначения(Новый Соответствие);
		ПараметрыСеанса.APDEX_ТекущийЗамерВремени = ХранилищеЗначения;
		
		
		APDEX_Настройки = APDEX_ОценкаПроизводительностиСерверВызовСервера.ПолучитьНастройки();
		APDEX_НастройкиЗамеров = Новый Структура;
		APDEX_НастройкиЗамеров.Вставить("APDEX_ОтключитьЗамер",APDEX_Настройки.APDEX_ОтключитьЗамер);
		APDEX_НастройкиЗамеров.Вставить("APDEX_МинимальноеВремяЗамера",APDEX_Настройки.APDEX_МинимальноеВремяЗамера);
		//APDEX_НастройкиЗамеров.Вставить("APDEX_ИдентификаторБазыAPDEX",APDEX_Настройки.APDEX_ИдентификаторБазыAPDEX);
		APDEX_НастройкиЗамеров.Вставить("APDEX_СпособЗаписиЗамеров",APDEX_Настройки.APDEX_СпособЗаписиЗамеров);
		
		ПараметрыСеанса.APDEX_НастройкиЗамеров = Новый ФиксированнаяСтруктура(APDEX_НастройкиЗамеров);
	КонецЕсли;
	
	// Алгоритмы, ЛНА
	СтруктураАлгоритмов = Новый Структура;
	#Если Клиент Тогда
		СтруктураАлгоритмов.Вставить("ЭтоКлиент");
	#КонецЕсли
	
	#Если Сервер Тогда
		СтруктураАлгоритмов.Вставить("ЭтоСервер");
	#КонецЕсли	
	
	ПараметрыСеанса.КэшАлгоритмов = Новый ХранилищеЗначения(СтруктураАлгоритмов);
	
КонецПроцедуры // УстановкаПараметровСеанса