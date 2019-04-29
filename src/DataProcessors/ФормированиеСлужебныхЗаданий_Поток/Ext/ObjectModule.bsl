﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт 
	
	лКлючАлгоритма = "Обработка_ФормированиеСлужебныхЗаданий_Поток_МодульОбъекта_ВыполнитьРегламентноеЗадание";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОчередьФормированияСлужебныхЗаданий.Период КАК Период,
	               |	ОчередьФормированияСлужебныхЗаданий.ПараметрФормированияСЗ КАК ПараметрФормированияСЗ,
	               |	ОчередьФормированияСлужебныхЗаданий.НомерПотока КАК НомерПотока,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаЗапуска КАК ДатаЗапуска,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаНачалаУпаковки КАК ДатаНачалаУпаковки,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаОкончания КАК ДатаОкончания,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаОтгрузки КАК ДатаОтгрузки,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДеньНедели КАК ДеньНедели,
	               |	НЕ ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаОкончания >= &Дата КАК ПотокНеУспел,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаЗапуска,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаНачалаУпаковки,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаОкончания,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДатаОтгрузки,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры_ДеньНедели
	               |ИЗ
	               |	РегистрСведений.ОчередьФормированияСлужебныхЗаданий КАК ОчередьФормированияСлужебныхЗаданий
	               |ГДЕ
	               |	ОчередьФормированияСлужебныхЗаданий.НомерПотока = &НомерПотока
	               |	И ОчередьФормированияСлужебныхЗаданий.ДатаЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаОкончания";
	Запрос.УстановитьПараметр("Дата", ТекущаяДата() - 60); //берем лаг минуту, т.е. даем потоку возможность минуту, чтобы выписать
	Запрос.УстановитьПараметр("НомерПотока", НомерПотока);
	//НачатьТранзакцию();
	Результат = Запрос.Выполнить();
	//ЗафиксироватьТранзакцию();
	
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл 
			
			Ошибка = Ложь;
			ТекстОшибки = "";
			
			Попытка
				Если Не Выборка.ПотокНеУспел Тогда 
					Обработка= Обработки.ФормированиеСлужебныхЗаданий_Новый.Создать();
					
					СтруктураП = Новый Структура();
					СтруктураП.Вставить("ДатаЗапуска");
					СтруктураП.Вставить("ДатаНачалаУпаковки");
					СтруктураП.Вставить("ДатаОкончания");
					СтруктураП.Вставить("ДатаОтгрузки");
					СтруктураП.Вставить("ДеньНедели");
					
					ЗаполнитьЗначенияСвойств(СтруктураП, Выборка);
					
					Параметры = Обработка.ЗаполнитьПараметрыОбработкиСогласноОснованию(Выборка.ПараметрФормированияСЗ, СтруктураП);
					
					Обработка.ЗаполнитьТаблицы(Параметры);
					Обработка.СоздатьДокументыСЗ(Параметры);
				КонецЕсли;
			Исключение
				Если ТранзакцияАктивна() Тогда 
					ОтменитьТранзакцию();
				КонецЕсли;
				ТекстОшибки = ОписаниеОшибки();
				Ошибка = Истина;
			КонецПопытки;
			Менеджер = РегистрыСведений.ОчередьФормированияСлужебныхЗаданий.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Менеджер, Выборка);
			
			Менеджер.ДатаЗавершения = ТекущаяДата();
			Менеджер.ТекстОшибки = ТекстОшибки;
			Менеджер.Ошибка = Ошибка;
			Менеджер.Записать();
			//Набор = РегистрыСведений.ОчередьФормированияСлужебныхЗаданий.СоздатьНаборЗаписей();
			//Набор.Отбор.ПараметрФормированияСЗ.Установить(Выборка.ПараметрФормированияСЗ);
			//Набор.Отбор.НомерПотока.Установить(Выборка.НомерПотока);
			//Набор.Отбор.Период.Установить(Выборка.Период);
			//Набор.Прочитать();
			//
			//Для Каждого Запись Из Набор Цикл 
			//	Запись.ДатаЗавершения = ТекущаяДата(); 
			//	Запись.ТекстОшибки = ТекстОшибки;
			//	Запись.Ошибка = Ошибка;
			//	Запись.ПотокНеУспел = Выборка.ПотокНеУспел;
			//КонецЦикла;
			//Набор.Записать();
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры