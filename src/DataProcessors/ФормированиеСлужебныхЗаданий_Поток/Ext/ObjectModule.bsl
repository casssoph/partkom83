﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОчередьФормированияСлужебныхЗаданий.ПараметрФормированияСЗ,
	               |	ОчередьФормированияСлужебныхЗаданий.Параметры
	               |ИЗ
	               |	РегистрСведений.ОчередьФормированияСлужебныхЗаданий КАК ОчередьФормированияСлужебныхЗаданий
	               |ГДЕ
	               |	ОчередьФормированияСлужебныхЗаданий.ДатаОкончания >= &Дата
	               |	И ОчередьФормированияСлужебныхЗаданий.НомерПотока = &НомерПотока
	               |	И ОчередьФормированияСлужебныхЗаданий.ДатаЗавершения = ДАТАВРЕМЯ(1, 1, 1)";
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
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры