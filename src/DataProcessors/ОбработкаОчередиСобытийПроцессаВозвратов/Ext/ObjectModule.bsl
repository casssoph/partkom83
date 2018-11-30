﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт
	
	 ВыполнитьОбработку();
	
КонецПроцедуры


Процедура ВыполнитьОбработку() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СобытияКОбработкеАктовРассмотренияВозврата.Период КАК Период,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата,
		|	СобытияКОбработкеАктовРассмотренияВозврата.Событие,
		|	СобытияКОбработкеАктовРассмотренияВозврата.ИсточникСобытия,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.СтатусДокумента КАК СтатусДокумента,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.КодВозврата КАК КодВозврата,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.КодВозвратаОбновленИзТоплог КАК КодВозвратаОбновленИзТоплог,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.Ответственный КАК Ответственный
		|ИЗ
		|	РегистрСведений.СобытияКОбработкеАктовРассмотренияВозврата КАК СобытияКОбработкеАктовРассмотренияВозврата
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = "";
		Успешно = Истина;
		Если Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ОбновлениеКодаВозвратаИзТоплог Тогда
			Успешно = ОбработатьОбновлениеКодаВозвратаИзТоплог(Выборка, ТекстОшибки);
		ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.УстановкаОтказаИзТоплог Тогда
			Успешно = ОбработатьОтказИзТоплог(Выборка, ТекстОшибки);
		КонецЕсли;
		
		Если Успешно Тогда
			
			НЗ = РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.СоздатьНаборЗаписей();
			НЗ.Отбор.Период.Установить(Выборка.Период);
			НЗ.Отбор.АктРассмотренияВозврата.Установить(Выборка.АктРассмотренияВозврата);
			НЗ.Отбор.Событие.Установить(Выборка.Событие);
			НЗ.Записать();
			
		Иначе
			
			НЗ = РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.СоздатьНаборЗаписей();
			НЗ.Отбор.Период.Установить(Выборка.Период);
			НЗ.Отбор.АктРассмотренияВозврата.Установить(Выборка.АктРассмотренияВозврата);
			НЗ.Отбор.Событие.Установить(Выборка.Событие);
			Для каждого текЗапись Из НЗ Цикл
				текЗапись.ОписаниеОшибки = ТекстОшибки;
				текЗапись.Ошибка 		 = Истина;
			КонецЦикла;
			НЗ.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОбработатьОтказИзТоплог(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	СтатусВозвратаОтПокупателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Источник, "СтатусДокумента");
	
	Если СтатусВозвратаОтПокупателя = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяОтказ
		И Выборка.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар  Тогда
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		Попытка
			АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
			АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВОтказ;
			АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "Отказ в возврате из топлог");
			
			АРВ.Заблокировать();
			
			АРВ.Записать(?(АРВ.Проведен, 
			РежимЗаписиДокумента.Проведение, 
			РежимЗаписиДокумента.Запись));
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ТекстОшибки = ОписаниеОшибки();
			Успешно		= Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

Функция ОбработатьОбновлениеКодаВозвратаИзТоплог(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	КодВозвратаНовый = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Источник, "КодВозврата");
	
	Если НЕ Выборка.КодВозвратаОбновленИзТоплог 
		И Выборка.КодВозврата <> КодВозвратаНовый 
		И  Выборка.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар  Тогда
		
		ОписаниеИзменения = "Изменение кода возврата из топлог.
		| старый код: "+Выборка.КодВозврата+", новый код: "+КодВозвратаНовый;
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		Попытка
			
			АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
			АРВ.Заблокировать();
			АРВ.КодВозврата = КодВозвратаНовый;
			АРВ.КодВозвратаОбновленИзТоплог = Истина;
			
			АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", ОписаниеИзменения);
			
			АРВ.Записать(?(АРВ.Проведен, 
			РежимЗаписиДокумента.Проведение, 
			РежимЗаписиДокумента.Запись));
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ТекстОшибки = ОписаниеОшибки();
			Успешно		= Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

