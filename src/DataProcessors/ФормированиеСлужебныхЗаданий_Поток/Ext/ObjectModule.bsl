﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОчередьФормированияСлужебныхЗаданий.Период,
	               |	ОчередьФормированияСлужебныхЗаданий.ПараметрФормированияСЗ КАК ПараметрФормированияСЗ,
	               |	ОчередьФормированияСлужебныхЗаданий.НомерПотока,
	               |	ОчередьФормированияСлужебныхЗаданий.ДатаОкончания КАК ДатаОкончания,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры
	               |ИЗ
	               |	РегистрСведений.ОчередьФормированияСлужебныхЗаданий КАК ОчередьФормированияСлужебныхЗаданий
	               |ГДЕ
	               |	ОчередьФормированияСлужебныхЗаданий.ДатаОкончания >= &Дата
	               |	И ОчередьФормированияСлужебныхЗаданий.НомерПотока = &НомерПотока
	               |	И ОчередьФормированияСлужебныхЗаданий.ДатаЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаОкончания";
	Запрос.УстановитьПараметр("Дата", ТекущаяДата() - 60);
	Запрос.УстановитьПараметр("НомерПотока", НомерПотока);
	НачатьТранзакцию();
	Результат = Запрос.Выполнить();
	ЗафиксироватьТранзакцию();
	
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл 
			Обработка= Обработки.ФормированиеСлужебныхЗаданий_Новый.Создать();
			Параметры = Выборка.Параметры.Получить();
			Обработка.ЗаполнитьТаблицы(Параметры);
			Обработка.СоздатьДокументыСЗ(Параметры);
			Набор = РегистрыСведений.ОчередьФормированияСлужебныхЗаданий.СоздатьНаборЗаписей();
			Набор.Отбор.ПараметрФормированияСЗ.Установить(Выборка.ПараметрФормированияСЗ);
			Набор.Отбор.НомерПотока.Установить(Выборка.НомерПотока);
			Набор.Отбор.Период.Установить(Выборка.Период);
			Набор.Прочитать();
			
			Для Каждого Запись Из Набор Цикл 
				Запись.ДатаЗавершения = ТекущаяДата(); 
			КонецЦикла;
			Набор.Записать();
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры