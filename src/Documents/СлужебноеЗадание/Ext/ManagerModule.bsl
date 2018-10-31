﻿Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.СлужебноеЗадание;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхМетаданныеОтбора) Экспорт
	Если (вхМетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog) тогда
		Возврат (Новый Структура("Шапка", "Водитель"));
	КонецЕсли;
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
КонецФункции

Процедура ЗагрузитьЭлемент(ОбъектXDTO, вхОтправитель, Отказ, вхПараметры = Неопределено) Экспорт
	лМетаданныеПланаОбмена = Метаданные.НайтиПоТипу(ТипЗнч(вхОтправитель));
	Если (лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog
		Или лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ) Тогда 
		Если ОбъектXDTO.Тип().Имя = "СменаВодителяСЗ" Тогда 
			Попытка
				ЗагрузитьСменаВодителяСЗ(ОбъектXDTO);
			Исключение
				СтруктураОшибки = Новый Структура;
				СтруктураОшибки.Вставить("ОбъектXDTO", ОбъектXDTO.Тип().Имя);
				СтруктураОшибки.Вставить("GUID", ОбъектXDTO.НомерСлужебногоЗадания);
				СтруктураОшибки.Вставить("ИмяОбъектаМетаданных", "СлужебноеЗаданиеСменаВодителя");
				СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
				СтруктураОшибки.Вставить("НомерСообщения", вхПараметры.НомерСообщения);
				СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
				СтруктураОшибки.Вставить("НомерПотока", ?(лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1));
				ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗагрузитьСменаВодителяСЗ(ОбъектXDTO)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СлужебноеЗадание.Ссылка,
	               |	СлужебноеЗадание.Водитель,
	               |	СлужебноеЗадание.ТранспортнаяКомпания
	               |ИЗ
	               |	Документ.СлужебноеЗадание КАК СлужебноеЗадание
	               |ГДЕ
	               |	СлужебноеЗадание.Номер = &НомерСлужебногоЗадания
	               |	И ГОД(СлужебноеЗадание.Дата) = ГОД(&ДатаСлужебногоЗадания)";
	Запрос.УстановитьПараметр("НомерСлужебногоЗадания", ОбъектXDTO.НомерСлужебногоЗадания);
	Запрос.УстановитьПараметр("ДатаСлужебногоЗадания", ОбъектXDTO.ДатаСлужебногоЗадания);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		ВызватьИсключение "Смена водителя в СЗ. Не найдено служебное задание. Номер СЗ: " + ОбъектXDTO.НомерСлужебногоЗадания;
	Иначе
		Если ЗначениеЗаполнено(ОбъектXDTO.ИДВодителя) Тогда 
			Водитель = Справочники.Водители.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.ИДВодителя));
		Иначе
			Водитель = Справочники.Водители.ПустаяСсылка();
		КонецЕсли;
		Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(Водитель) Тогда 
			ВызватьИсключение "Смена водителя в СЗ. Не найден водитель с: " + ОбъектXDTO.ИДВодителя + ". Номер СЗ: " + ОбъектXDTO.НомерСлужебногоЗадания;
		КонецЕсли;
		
		ТранспортнаяКомпания = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Водитель, "ТранспортнаяКомпания");
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Если Не (Выборка.Водитель = Водитель И Выборка.ТранспортнаяКомпания = ТранспортнаяКомпания) Тогда 
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Водитель = Водитель;
			ДокументОбъект.ТранспортнаяКомпания = ТранспортнаяКомпания;
			ДокументОбъект.Записать();
		КонецЕсли;
	КонецЕсли;		
КонецПроцедуры

Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена) Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции
