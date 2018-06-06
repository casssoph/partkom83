﻿Перем мЗарегистрироватьИзмененияДляСайта;

Процедура ПередУдалением(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: СостоянияСтрокДокументов", Ложь) Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные());
	КонецЕсли
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: СостоянияСтрокДокументов", Ложь) И НЕ ЭтоГруппа Тогда
		мЗарегистрироватьИзмененияДляСайта = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если мЗарегистрироватьИзмененияДляСайта тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если ИспользуетсяВЗаказахПоУмолчанию Тогда
			ПроверитьИспользованиеПризнака(Ссылка, "ИспользуетсяВЗаказахПоУмолчанию", Отказ);
		КонецЕсли;
		
		Если ИспользуетсяВЗаявкахПоУмолчанию Тогда
			ПроверитьИспользованиеПризнака(Ссылка, "ИспользуетсяВЗаявкахПоУмолчанию", Отказ);
		КонецЕсли;
		
		Если ИспользуетсяВРеализацияхПоУмолчанию Тогда
			ПроверитьИспользованиеПризнака(Ссылка, "ИспользуетсяВРеализацияхПоУмолчанию", Отказ);
		КонецЕсли;
		
		Если ИспользуетсяВПоступленияхПоУмолчанию Тогда
			ПроверитьИспользованиеПризнака(Ссылка, "ИспользуетсяВПоступленияхПоУмолчанию", Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИспользованиеПризнака(Ссылка, вхПризнак, Отказ)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	СостоянияСтрокДокументов.Ссылка
	|ИЗ
	|	Справочник.СостоянияСтрокДокументов КАК СостоянияСтрокДокументов
	|ГДЕ
	|	СостоянияСтрокДокументов.Ссылка <> &Ссылка
	|	И СостоянияСтрокДокументов." + вхПризнак;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект[вхПризнак] = Ложь;
		Попытка
			Объект.Записать();
		Исключение
			Отказ = Истина;
			ВызватьИсключение "Не удалось записать элемент " + Объект;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

мЗарегистрироватьИзмененияДляСайта = Ложь;
