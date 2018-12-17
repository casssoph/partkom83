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
		ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ПросроченСрокВозвратаТовараКлиентом Тогда
			Успешно = ОбработатьПросрочкуСрокаВозвратаТовараОтКлиента(Выборка, ТекстОшибки);
		ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ВходящееЭлектронноеПисьмо Тогда
			Успешно = ОбработатьВходящееЭлектронноеПисьмо(Выборка, ТекстОшибки);
		ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ЗагрузкаРазмещенияИзТопЛог Тогда
			Успешно = ОбработатьРазмещениеИзТопЛог(Выборка, ТекстОшибки);
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

//Пришло письмо от покупателя или поставщика
Функция ОбработатьВходящееЭлектронноеПисьмо(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если Не ЗначениеЗаполнено(Выборка.ПараметрСобытия) Тогда
		ТекстОшибки = "В качестве параметра события должен быть указан документ ""Электронное письмо!""";
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыЭП = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Контрагент");
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "СтатусДокумента, Контрагент, Поставщик, Ответственный, Номер, Дата");
	
	ПисьмоОтКлиента 	= РеквизитыЭП.Контрагент = РеквизитыАРВ.Контрагент;
	ПисьмоОтПоставщика 	= РеквизитыЭП.Контрагент = РеквизитыАРВ.Контрагент;
	
	Если ПисьмоОтКлиента Тогда
		
		Если РеквизитыАРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГПРКЗапросПокупателю Тогда
			
			
			Попытка
				АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
				АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГПРКПолученОтветОтПокупателя;
				АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "Получен ответ от клиента: "+Выборка.ПараметрСобытия);
				
				АРВ.Записать(?(АРВ.Проведен, 
				РежимЗаписиДокумента.Проведение, 
				РежимЗаписиДокумента.Запись));
				
			Исключение
				ОтменитьТранзакцию();
				
				ТекстОшибки = ОписаниеОшибки();
				Успешно		= Ложь;
			КонецПопытки;
			
		КонецЕсли;
		
	ИначеЕсли ПисьмоОтПоставщика Тогда
		
		Если РеквизитыАРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГПРКЗапросПоставщику Тогда
			
			Попытка
				АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
				АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГПРКПолученОтветОтПоставщика;
				АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "Получен ответ от поставщика: "+Выборка.ПараметрСобытия);
				
				АРВ.Записать(?(АРВ.Проведен, 
				РежимЗаписиДокумента.Проведение, 
				РежимЗаписиДокумента.Запись));
				
			Исключение
				ОтменитьТранзакцию();
				
				ТекстОшибки = ОписаниеОшибки();
				Успешно		= Ложь;
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		//Это непонятно от кого письмо, не будем ничего менять
	КонецЕсли;
	
	//Отправим оповещение ответственному на почту
	Если Успешно И ЗначениеЗаполнено(РеквизитыАРВ.Ответственный) И ТипЗнч(РеквизитыАРВ.Ответственный) = Тип("СправочникСсылка.Пользователи") Тогда
		
		АдресЭлПочты = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(РеквизитыАРВ.Ответственный, Справочники.ВидыКонтактнойИнформации.EmailПользователя);;
		
		Если ЗначениеЗаполнено(АдресЭлПочты) Тогда
			
			СтрокаОт = "";
			Если ПисьмоОтКлиента Тогда
				СтрокаОт = "клиента";
			ИначеЕсли ПисьмоОтПоставщика Тогда
				СтрокаОт = "поставщика";
			КонецЕсли;
			
			Тема = "Входящее письмо от "+СтрокаОт+" "+РеквизитыЭП.Контрагент+" по акту возврата "+РеквизитыАРВ.Номер+" от "+Формат(РеквизитыАРВ.Дата, "ДФ=dd.MM.yyyy");
			
			ТекстПисьма = Документы.ЭлектронноеПисьмо.ТекстПисьмаТекстом(Выборка.ПараметрСобытия);
			Тело = Тема+"
			|
			| "+Выборка.ПараметрСобытия+":
			| 
			| "+ТекстПисьма;
			
			СтруктураНовогоПисьма = Новый Структура;
			СтруктураНовогоПисьма.Вставить("ВидТекста", Перечисления.ВидыТекстовЭлектронныхПисем.Текст);
			СтруктураНовогоПисьма.Вставить("Тело", Тело);
			СтруктураНовогоПисьма.Вставить("Тема", Тема);	
			СтруктураНовогоПисьма.Вставить("Кому", АдресЭлПочты);

			РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ВходящееЭлектронноеПисьмоПоПроцессуВозвратов,
			СтруктураНовогоПисьма.Тело, СтруктураНовогоПисьма.Тема, СтруктураНовогоПисьма.Кому,,,);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Успешно;	
	
КонецФункции

//Переводим в отказ АРВ и возврат от покупателя, если вышел срок ожидания приемки возврата
Функция ОбработатьПросрочкуСрокаВозвратаТовараОтКлиента(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	ДнейПросрочкиМакс = Константы.КоличествоДнейОжиданияПриемкиВозврата.Получить();

	//Не заданы
	Если ДнейПросрочкиМакс = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "СтатусДокумента,УчитыватьНДС,СуммаВключаетНДС,ПометкаУдаления");
	
	Если РеквизитыАРВ.ПометкаУдаления Тогда
		Возврат Истина;
	КонецЕсли;
	
	//Переводим в отказ только из этого статуса
	Если РеквизитыАРВ.СтатусДокумента <> Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар Тогда
		Возврат Истина;
	КонецЕсли;	
	
	МинутВСтатусе = Документы.АктРассмотренияВозврата.ПродолжительностьНахожденияВСтатусе(Выборка.АктРассмотренияВозврата);
	ДнейВСтатусе  = МинутВСтатусе/1440;
	
	//Еще рано
	Если ДнейВСтатусе <= ДнейПросрочкиМакс Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДокументыВозврата = Документы.АктРассмотренияВозврата.ДокументыВозвратаОтПокупателяПоАРВ(Выборка.АктРассмотренияВозврата, "Не ПометкаУдаления");
	
	ОписаниеИзменения = "Истекло количество дней ожидания приемки возврата. 
	| Максимум дней: "+ДнейПросрочкиМакс+"
	| Ждали: "+ВозвратыОтПокупателяСервер.МинутыВСтроку(МинутВСтатусе);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		//Переводим в отказ возвраты
		Для каждого СтрокаВозврата Из ДокументыВозврата Цикл
			
			ДокВозврата = СтрокаВозврата.Ссылка.ПолучитьОбъект();
			ДокВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяОтказ;
			Для каждого СтрокаТЧ Из ДокВозврата.Товары Цикл
				СтрокаТЧ.Количество = 0;
				СтрокаТЧ.Сумма 		= 0;
				ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(СтрокаТЧ, ДокВозврата);
			КонецЦикла; 
			
			ДокВозврата.Записать(?(ДокВозврата.Проведен, 
			РежимЗаписиДокумента.Проведение, 
			РежимЗаписиДокумента.Запись));
			
		КонецЦикла;
		
		//Переводим в отказ АРВ
		АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
		АРВ.Заблокировать();
		АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВОтказ;
		Для каждого СтрокаТЧ Из АРВ.Товары Цикл
			
			СтрокаТЧ.Количество = 0;
			
			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
			СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", РеквизитыАРВ.УчитыватьНДС, РеквизитыАРВ.СуммаВключаетНДС));			
			СтруктураДействий.Вставить("ПересчитатьСебестоимость",  ?(СтрокаТЧ.Количество > 0, "Количество", "КоличествоПлан"));
			ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТЧ, СтруктураДействий, Неопределено); 
			
		КонецЦикла;                 	
		
		АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", ОписаниеИзменения);
		
		АРВ.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = ОписаниеОшибки();
		Успешно		= Ложь;
	КонецПопытки;
	
	Возврат Успешно;
	
	
КонецФункции

//- Меняем код возврата и количество в АРВ, если возврат принят
//- Ставим отказ в АРВ, если возврат принят с отказом (нулевое количество)
//- Пересчитываем количество принятое и размещенное
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
	Если (РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят
		ИЛИ РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяРазмещен) 
		И РеквизитыАРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВЖдемТовар Тогда
		
		ОписаниеИзменения = "";
		
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		Попытка
			
			АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
			АРВ.Заблокировать();
			
			Если НЕ РеквизитыАРВ.КодВозвратаОбновленИзТоплог Тогда
				
				АРВ.КодВозврата = КодВозвратаНовый;
				АРВ.КодВозвратаОбновленИзТоплог = Истина;
				
				ОписаниеИзменения = "Изменение кода возврата из топлог.
				| старый код: "+РеквизитыАРВ.КодВозврата+", новый код: "+КодВозвратаНовый;
				
			КонецЕсли;
			
			ИзмененоПринятое 	= Ложь;
			ИзмененоРазмещенное = Ложь;
			Если РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят Тогда
				ИзмененоПринятое 	=  АРВ.ОбновитьКоличествоПоВозвратуОтПокупателя(Выборка.ПараметрСобытия, "Принятое");
			Иначе
				ИзмененоПринятое 	=  АРВ.ОбновитьКоличествоПоВозвратуОтПокупателя(Выборка.ПараметрСобытия, "Принятое");
				ИзмененоРазмещенное =  АРВ.ОбновитьКоличествоПоВозвратуОтПокупателя(Выборка.ПараметрСобытия, "Размещенное");
			КонецЕсли;
			
			Если ИзмененоПринятое Тогда
				ОписаниеИзменения = ОписаниеИзменения + Символы.ПС + "Обновлено принятое количество по данным возврата от покупателя";
			КонецЕсли;
			Если ИзмененоРазмещенное Тогда
				ОписаниеИзменения = ОписаниеИзменения + Символы.ПС + "Обновлено размещенное количество по данным возврата от покупателя";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОписаниеИзменения) Тогда
				АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", ОписаниеИзменения);
			КонецЕсли;
			
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
			АРВ.Заблокировать();
			АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВОтказ;
			АРВ.ОбновитьКоличествоПоВозвратуОтПокупателя(Выборка.ПараметрСобытия);
			
			АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "Отказ в возврате из топлог");
			
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

//Заполняем размещенное количество в возврате от покупателя
//Меняем статус возврата на Размещен, если размещено все количество
Функция ОбработатьРазмещениеИзТопЛог(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Выборка.ПараметрСобытия)  Тогда
		ТекстОшибки = "Не заполнен параметр события";
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Выборка.ПараметрСобытия) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		
		РеквизитыВозврата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Проведен, СтатусДокумента, ДатаЗавершенияРазмещения");
		
		Если ЗначениеЗаполнено(РеквизитыВозврата.ДатаЗавершенияРазмещения) Тогда
			Возврат Успешно;
		КонецЕсли;
		
		//Только в статусе принят
		Если РеквизитыВозврата.СтатусДокумента <> Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят Тогда
			Возврат Успешно;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Выборка.ПараметрСобытия) <> Тип("ДокументСсылка.ПеремещениеТоваров") Тогда //Перемещение
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Проведен, СтатусДокумента, ВидОперации");
		
		//Только для возврата в продажу
		Если РеквизитыОснования.ВидОперации <> Перечисления.ВидыОперацийПеремещенияТоваров.ВозвратВПродажу Тогда
			Возврат Успешно;
		КонецЕсли;
		
		//Только в статусе новый
		Если РеквизитыОснования.СтатусДокумента <> Справочники.СтатусыДокументов.ПеремещениеТоваровНовый Тогда
			Возврат Успешно;
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки = "В качестве параметра события должен быть указан документ ""Возврат товаров от покупателя"" или ""Перемещение товаров""";
		Возврат Ложь;
		
	КонецЕсли;
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		ДокументОбъект = Выборка.ПараметрСобытия.ПолучитьОбъект();
		ДокументОбъект.Заблокировать();
		ДокументОбъект.ЗаполнитьРазмещенноеКоличество();
		
		Если ТипЗнч(Выборка.ПараметрСобытия) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
			Если ДокументОбъект.ВсеПринятоеКоличествоРазмещено() Тогда
				ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяРазмещен;
			КонецЕсли;
		Иначе//Перемещение
			Если ДокументОбъект.ВсеКоличествоРазмещено() Тогда
				ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ПеремещениеТоваровПоступил;
			КонецЕсли;
		КонецЕсли;
		
		ДокументОбъект.Записать(?(ДокументОбъект.Проведен, 
		РежимЗаписиДокумента.Проведение, 
		РежимЗаписиДокумента.Запись));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = ОписаниеОшибки();
		Успешно		= Ложь;
	КонецПопытки;
	
	Возврат Успешно;
	
КонецФункции

