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
		|	СобытияКОбработкеАктовРассмотренияВозврата.ПараметрСобытия
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
		Если Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ЗагрузкаВозвратаОтПокупателяИзТопЛог Тогда
			Успешно = ОбработатьВозвратИзТоплог(Выборка, ТекстОшибки);
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
			НЗ.Прочитать();
			Для каждого текЗапись Из НЗ Цикл
				текЗапись.ОписаниеОшибки = ТекстОшибки;
				текЗапись.Ошибка 		 = Истина;
			КонецЦикла;
			НЗ.Записать();
			
			КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(
			Выборка.АктРассмотренияВозврата, 
			Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаОбработкиОчередиСобытийПроцессаВозвратов,
			ТекстОшибки,
			,
			Истина,
			"Период: "+Выборка.Период+", Событие: "+Выборка.Событие+", Параметр: "+Выборка.ПараметрСобытия,
			"ОбработкаОчередиСобытийПроцессаВозвратов.ВыполнитьОбработку()");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОбработатьВозвратИзТоплог(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Выборка.ПараметрСобытия) 
		ИЛИ ТипЗнч(Выборка.ПараметрСобытия) <> Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		ТекстОшибки = "В качестве параметра события должен быть указан документ ""Возврат товаров от покупателя!""";
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыВозврата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Проведен, СтатусДокумента, КодВозврата");
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "Ответственный, КодВозвратаОбновленИзТоплог, СтатусДокумента, КодВозврата");
	
	Если Не РеквизитыВозврата.Проведен Тогда
		Возврат Успешно;
	КонецЕсли;
	
	КодВозвратаНовый = РеквизитыВозврата.КодВозврата;

	//Изменение кода возврата
	Если РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят
		И НЕ РеквизитыАРВ.КодВозвратаОбновленИзТоплог 
		И РеквизитыАРВ.КодВозврата <> КодВозвратаНовый 
		И РеквизитыАРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар Тогда
		
		ОписаниеИзменения = "Изменение кода возврата из топлог.
		| старый код: "+РеквизитыАРВ.КодВозврата+", новый код: "+КодВозвратаНовый;
		
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
		
	ИначеЕсли РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяОтказ
		И РеквизитыАРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар  Тогда
		
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

