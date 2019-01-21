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
		|	СобытияКОбработкеАктовРассмотренияВозврата.ПараметрСобытия,
		|	СобытияКОбработкеАктовРассмотренияВозврата.КоличествоПопыток,
		|	СобытияКОбработкеАктовРассмотренияВозврата.Ошибка,
		|	СобытияКОбработкеАктовРассмотренияВозврата.ДатаОбработки,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.ПометкаУдаления КАК ПометкаУдаления,
		|	СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата.Проведен КАК Проведен
		|ИЗ
		|	РегистрСведений.СобытияКОбработкеАктовРассмотренияВозврата КАК СобытияКОбработкеАктовРассмотренияВозврата
		|ГДЕ
		|	(СобытияКОбработкеАктовРассмотренияВозврата.АктРассмотренияВозврата = &Документ
		|			ИЛИ &ВсеДокументы)
		//|	И СобытияКОбработкеАктовРассмотренияВозврата.КоличествоПопыток >= &КоличествоПопытокМин
		//|	И (СобытияКОбработкеАктовРассмотренияВозврата.КоличествоПопыток <= &КоличествоПопытокМакс
		//|			ИЛИ &КоличествоПопытокМакс = 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
	
	Запрос.УстановитьПараметр("КоличествоПопытокМин", КоличествоПопытокМин);
	Запрос.УстановитьПараметр("КоличествоПопытокМакс", КоличествоПопытокМакс);
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("ВсеДокументы", Не ЗначениеЗаполнено(Документ));
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	ТекДата = ТекущаяДата();
	
	Пока Выборка.Следующий() Цикл
		
		//Записи с количеством ошибок больше максимального обрабатываем не чаще заданной периодичности
		Если Выборка.Ошибка И Выборка.КоличествоПопыток > КоличествоПопытокМакс  Тогда
			ПрошлоСМоментаОбработкиМинут = Цел((ТекДата -  Выборка.ДатаОбработки)/60);
			Если ПрошлоСМоментаОбработкиМинут <= ПериодичностьОбработкиОшибокМинут Тогда			
			    Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ТекстОшибки = "";
		Успешно = Истина;
		
		Если Выборка.Проведен Тогда
			Если Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ЗагрузкаВозвратаОтПокупателяИзТопЛог Тогда
				Успешно = ОбработатьВозвратИзТоплог(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ПросроченСрокВозвратаТовараКлиентом Тогда
				Успешно = ОбработатьПросрочкуСрокаВозвратаТовараОтКлиента(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ВходящееЭлектронноеПисьмо Тогда
				Успешно = ОбработатьВходящееЭлектронноеПисьмо(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ЗагрузкаРазмещенияИзТопЛог Тогда
				Успешно = ОбработатьРазмещениеИзТопЛог(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ВыполнитьПереходВСледующийСтатус Тогда
				Успешно = ОбработатьПереходВСледующийСтатус(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ВыполнитьКомандыТекущегоСтатуса Тогда
				Успешно = ВыполнитьКомандыТекущегоСтатуса(Выборка, ТекстОшибки);
			ИначеЕсли Выборка.Событие = Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ОбработатьЭтапПроцесса Тогда
				Успешно = ОбработатьЭтапПроцесса(Выборка, ТекстОшибки);
			КонецЕсли;
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
				текЗапись.ОписаниеОшибки 	= ТекстОшибки;
				текЗапись.Ошибка 		 	= Истина;
				текЗапись.КоличествоПопыток = текЗапись.КоличествоПопыток + 1;
				текЗапись.ДатаОбработки 	= ТекущаяДата();
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

Функция ОбработатьЭтапПроцесса(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если Не ЗначениеЗаполнено(Выборка.ПараметрСобытия) Тогда
		ТекстОшибки = "Не заполнен параметр события";
		Возврат Ложь;
	КонецЕсли;
	Если НЕ ТипЗнч(Выборка.ПараметрСобытия) = Тип("СправочникСсылка.СтатусыДокументов") Тогда
		ТекстОшибки = "В качестве параметра события должен быть указан статус документа";
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "СтатусДокумента, Контрагент, Поставщик, Ответственный, Номер, Дата");
	Если НЕ РеквизитыАРВ.СтатусДокумента = Выборка.ПараметрСобытия Тогда
		//Возможно Акт уже перевели руками в другой статус, считаем что действие отработано
		Возврат Истина;
	КонецЕсли;
	
	УспешноКоманды = ВыполнитьКомандыТекущегоСтатуса(Выборка, 	 ТекстОшибки);
	
	Если Не УспешноКоманды Тогда
		Возврат УспешноКоманды;
	КонецЕсли;
	
	УспешноПереход = ОбработатьПереходВСледующийСтатус(Выборка, ТекстОшибки);
	
	Возврат УспешноПереход;	
	
КонецФункции

//Выполняет все команды текущего статуса
//В качесте параметра должен быть указан текущий статус АРВ
Функция  ВыполнитьКомандыТекущегоСтатуса(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если Не ЗначениеЗаполнено(Выборка.ПараметрСобытия) Тогда
		ТекстОшибки = "Не заполнен параметр события";
		Возврат Ложь;
	КонецЕсли;
	Если НЕ ТипЗнч(Выборка.ПараметрСобытия) = Тип("СправочникСсылка.СтатусыДокументов") Тогда
		ТекстОшибки = "В качестве параметра события должен быть указан статус документа";
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "СтатусДокумента, Контрагент, Поставщик, Ответственный, Номер, Дата");
	Если НЕ РеквизитыАРВ.СтатусДокумента = Выборка.ПараметрСобытия Тогда
		//Возможно Акт уже перевели руками в другой статус, считаем что действие отработано
		Возврат Истина;
	КонецЕсли;
	
	//Получим команды для выполнения
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыДокументовКомандыПроцесса.НомерСтроки,
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса
		|ИЗ
		|	Справочник.СтатусыДокументов.КомандыПроцесса КАК СтатусыДокументовКомандыПроцесса
		|ГДЕ
		|	СтатусыДокументовКомандыПроцесса.Ссылка = &ТекущийСтатус
		|	И НЕ СтатусыДокументовКомандыПроцесса.Ссылка.ПометкаУдаления
		|	И СтатусыДокументовКомандыПроцесса.КомандаПроцесса.Автоматически
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатусыДокументовКомандыПроцесса.НомерСтроки";
	Запрос.УстановитьПараметр("ТекущийСтатус", РеквизитыАРВ.СтатусДокумента);
	МассивКоманд = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КомандаПроцесса");
	
	УспешноВыполненоКоманд = 0;
	ТекстОшибокВыполнения = "";
	Для каждого КомандаКВыполнению Из МассивКоманд Цикл
		ТекстОшибкиВыполнения = "";
		Если ВозвратыОтПокупателяСервер.ВыполнитьКомандуДляАРВВТранзакции(КомандаКВыполнению,, Выборка.АктРассмотренияВозврата, ТекстОшибкиВыполнения) Тогда
			УспешноВыполненоКоманд = УспешноВыполненоКоманд+1;
		Иначе
			ТекстОшибокВыполнения = ТекстОшибокВыполнения + ?(ЗначениеЗаполнено(ТекстОшибокВыполнения), Символы.ПС, "")+ТекстОшибкиВыполнения;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ УспешноВыполненоКоманд = МассивКоманд.Количество() Тогда
		ТекстОшибки = "Выполнены не все команды. Выполнено: "+УспешноВыполненоКоманд+" из "+МассивКоманд.Количество();
		ТекстОшибки = ТекстОшибки + Символы.ПС + ТекстОшибокВыполнения;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Успешно;	
	
КонецФункции

//Выполняет переход в следующий статус, если для перехода доступен только один статус
//В качесте параметра должен быть указан текущий статус АРВ
Функция  ОбработатьПереходВСледующийСтатус(Выборка, ТекстОшибки = "")
	
	Успешно = Истина;
	
	Если Не ЗначениеЗаполнено(Выборка.ПараметрСобытия) Тогда
		ТекстОшибки = "Не заполнен параметр события";
		Возврат Ложь;
	КонецЕсли;
	Если НЕ ТипЗнч(Выборка.ПараметрСобытия) = Тип("СправочникСсылка.СтатусыДокументов") Тогда
		ТекстОшибки = "В качестве параметра события должен быть указан статус документа";
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыАРВ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.АктРассмотренияВозврата, "СтатусДокумента, Контрагент, Поставщик, Ответственный, Номер, Дата");
	Если НЕ РеквизитыАРВ.СтатусДокумента = Выборка.ПараметрСобытия Тогда
		//Возможно Акт уже перевели руками в другой статус, считаем что действие отработано
		Возврат Истина;
	КонецЕсли;
	
	//Получим список статусов для автоперехода
	СписокКВыполнению = Справочники.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ДоступныеВзаимосвязиТекущегоСтатуса(РеквизитыАРВ.СтатусДокумента, "Автоматически");
	
	ДокументОбъект = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
	КомандаКВыполнению = Неопределено;
	КомандКПереходу = 0;
	Для каждого ЭлСписка Из СписокКВыполнению Цикл
		
		Если ВозвратыОтПокупателяСервер.УсловияКомандыВыполнены(ЭлСписка.Значение, ДокументОбъект) Тогда
			КомандаКВыполнению = ЭлСписка.Значение;
			КомандКПереходу = КомандКПереходу + 1;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если КомандКПереходу <> 1 Тогда
		ТекстОшибки = "Невозможно опеределить статус для перехода, доступно статусов: "+КомандКПереходу;
		Возврат Истина; //Считаем что отработали успешно
	Иначе
		//Пробуем перевести в новый статус
		ТекстОшибкиВыполнения = "";
		Успешно = ВозвратыОтПокупателяСервер.ВыполнитьКомандуДляАРВВТранзакции(КомандаКВыполнению,, Выборка.АктРассмотренияВозврата, ТекстОшибкиВыполнения);
		Если Не Успешно Тогда
			ТекстОшибки = "Ошибка выполнения команды "+КомандаКВыполнению+Символы.ПС+ТекстОшибкиВыполнения;
		КонецЕсли;		
	КонецЕсли;
	
	Возврат Успешно;	
	
КонецФункции

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
	ПисьмоОтПоставщика 	= РеквизитыЭП.Контрагент = РеквизитыАРВ.Поставщик;
	
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
			//Для каждого СтрокаТЧ Из ДокВозврата.Товары Цикл
			//	СтрокаТЧ.Количество = 0;
			//	СтрокаТЧ.Сумма 		= 0;
			//	ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(СтрокаТЧ, ДокВозврата);
			//КонецЦикла; 
			
			ДокВозврата.Записать(?(ДокВозврата.Проведен, 
			РежимЗаписиДокумента.Проведение, 
			РежимЗаписиДокумента.Запись));
			
		КонецЦикла;
		
		//Переводим в отказ АРВ
		АРВ = Выборка.АктРассмотренияВозврата.ПолучитьОбъект();
		АРВ.Заблокировать();
		АРВ.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_ГВОтказ;
		
		//Отправим отказ клиенту
		ДанныеТоваров = ДанныеТоваровАктаДляОтказа(Выборка.АктРассмотренияВозврата);
		АРВ.ПричинаОтказаВВозврате 	= "Уважаемые покупатели! Срок передачи возврата ("+
		ДанныеТоваров.Наименование+", "+ДанныеТоваров.ИзготовительНаименование+", "+ДанныеТоваров.Артикул+" в кол-ве "+ДанныеТоваров.Количество+" шт.)"+
		" на наш склад истек.
		| Спасибо за понимание.";
		АРВ.МенеджерОтказаВВозврате = Справочники.Пользователи.ПустаяСсылка();
		АРВ.ОтправленаПричинаОтказаВВозврате = Истина;
		
		//Для каждого СтрокаТЧ Из АРВ.Товары Цикл
		//	
		//	СтрокаТЧ.Количество = 0;
		//	
		//	СтруктураДействий = Новый Структура;
		//	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
		//	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", РеквизитыАРВ.УчитыватьНДС, РеквизитыАРВ.СуммаВключаетНДС));			
		//	СтруктураДействий.Вставить("ПересчитатьСебестоимость",  ?(СтрокаТЧ.Количество > 0, "Количество", "КоличествоПлан"));
		//	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТЧ, СтруктураДействий, Неопределено); 
		//	
		//КонецЦикла;                 	
		
		АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", ОписаниеИзменения);
		
		РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.Добавить(Выборка.АктРассмотренияВозврата, 
		Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ОбработатьЭтапПроцесса,
		АРВ.СтатусДокумента);
		
		АРВ.Записать(РежимЗаписиДокумента.Проведение);
		
		Документы.АктРассмотренияВозврата.ОтправитьТекстОтказаНаСайт(АРВ.Ссылка);
		
		ЗафиксироватьТранзакцию();
		
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = ОписаниеОшибки();
		Успешно		= Ложь;
	КонецПопытки;
	
	Возврат Успешно;
	
	
КонецФункции

Функция ДанныеТоваровАктаДляОтказа(АРВСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктРассмотренияВозвратаТовары.Номенклатура.Код КАК Код,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Наименование КАК Наименование,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Артикул КАК Артикул,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Изготовитель.Наименование КАК ИзготовительНаименование,
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	СУММА(АктРассмотренияВозвратаТовары.КоличествоПлан) КАК Количество
		|ИЗ
		|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
		|ГДЕ
		|	АктРассмотренияВозвратаТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	АктРассмотренияВозвратаТовары.Номенклатура,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Код,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Наименование,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Артикул,
		|	АктРассмотренияВозвратаТовары.Номенклатура.Изготовитель.Наименование";
	
	Запрос.УстановитьПараметр("Ссылка", АРВСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка;	
	
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
				
				ОтправитьСообщениеКлиентуНаСайтПоПринятомуВозврату(Выборка.ПараметрСобытия);
				
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
			
			Если Не ЗначениеЗаполнено(АРВ.СтатусПроверкиДокументовПокупателя) Тогда
				АРВ.СтатусПроверкиДокументовПокупателя = Перечисления.АРВ_СтатусыПроверкиДокументовПокупателя.НеПроверены;
			КонецЕсли;
			
			//СтатусПроверкиДокументовПоставщика должен меняться только когда появится возврат поставщику
			//Если Не ЗначениеЗаполнено(АРВ.СтатусПроверкиДокументовПоставщика) Тогда
			//	Если АРВ.КодВозврата = Справочники.КодыВозврата.ВозвратПоставщику Тогда
			//		АРВ.СтатусПроверкиДокументовПоставщика = Перечисления.АРВ_СтатусыПроверкиДокументовПоставщика.НеПроверены;
			//	Иначе
			//		АРВ.СтатусПроверкиДокументовПоставщика = Перечисления.АРВ_СтатусыПроверкиДокументовПоставщика.ПроверкаНеНужна;
			//	КонецЕсли;
			//КонецЕсли;
			
			
			Если ЗначениеЗаполнено(ОписаниеИзменения) Тогда
				АРВ.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", ОписаниеИзменения);
			КонецЕсли;
			
			АРВ.Записать(?(АРВ.Проведен, 
			РежимЗаписиДокумента.Проведение, 
			РежимЗаписиДокумента.Запись));
			
			ЗафиксироватьТранзакцию();
			
			Если РеквизитыВозврата.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяРазмещен Тогда
				РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.Добавить(
				Выборка.АктРассмотренияВозврата, 
				Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ВыполнитьПереходВСледующийСтатус, 
				РеквизитыАРВ.СтатусДокумента);
			КонецЕсли;

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

Процедура ОтправитьСообщениеКлиентуНаСайтПоПринятомуВозврату(ВозвратСсылка)
	
	//Возврат;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВозвратСсылка, "АктРассмотренияВозврата, КодВозврата.Код");
	
	Акт = Реквизиты.АктРассмотренияВозврата;
	Если ЗначениеЗаполнено(Реквизиты.КодВозвратаКод) Тогда
		КодВозврата = Реквизиты.КодВозвратаКод;
	Иначе
		КодВозврата = "0";
	КонецЕсли;
	Штрихкод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Акт, "Штрихкод");
	
	//Ручной ввод
	Префикс = Документы.АктРассмотренияВозврата.ПрефиксШтрихкодаДляРучногоСозданияАРВ();
	Если СтрНайти(Штрихкод, Префикс) > 0 Тогда
		Возврат;
	КонецЕсли;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Ссылка,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Наименование КАК Наименование,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Артикул КАК Артикул,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Изготовитель.Наименование КАК ИзготовительНаименование,
		|	СУММА(ВозвратТоваровОтПокупателяТовары.Количество) КАК Количество,
		|	СУММА(ВозвратТоваровОтПокупателяТовары.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
		|ГДЕ
		|	ВозвратТоваровОтПокупателяТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Ссылка,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Наименование,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Артикул,
		|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Изготовитель.Наименование";
	
	Запрос.УстановитьПараметр("Ссылка", ВозвратСсылка);
	
	ТЗ = Запрос.Выполнить().Выгрузить();	

	Если ТЗ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СтрокаТЗ = ТЗ[0];
	ТипКаталога = 3;
	ИмяФайла = "send_"+Штрихкод+".txt";
	
	//Вернули деньги
	ТипКаталога = 3;
	Строка2 = "robot";
	Строка3 = Строка(КодВозврата);
	Строка4 = "0";
	
	СтрокаПринято = "Товар "+СтрокаТЗ.ИзготовительНаименование+", "+СтрокаТЗ.Артикул+", "+СтрокаТЗ.Наименование+" принят на региональный склад. ";
	Строка5 = СтрокаПринято + "На Ваш баланс зачислены средства в размере "+ Формат(СтрокаТЗ.Сумма, "ЧДЦ=2") +" руб.";
	Документы.АктРассмотренияВозврата.ОтправитьЭлмаподобноеСообщениеНаСайт(Акт, Строка2, Строка3, Строка4, Строка5, ТипКаталога, ИмяФайла);	
	
КонецПроцедуры

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
		Если РеквизитыВозврата.СтатусДокумента <> Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят
			ИЛИ РеквизитыВозврата.СтатусДокумента <> Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяНовый Тогда
			//Если возврат не принят, но пришло размещение, то все равно обработаем его (считаем что приемка была)
			Возврат Успешно;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Выборка.ПараметрСобытия) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда //Перемещение
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Проведен, СтатусДокумента, ВидОперации");
		
		//Только для возврата в продажу
		Если РеквизитыОснования.ВидОперации <> Перечисления.ВидыОперацийПеремещенияТоваров.ВозвратВПродажу Тогда
			Возврат Успешно;
		КонецЕсли;
		
		//Только в статусе новый
		Если РеквизитыОснования.СтатусДокумента <> Справочники.СтатусыДокументов.ПеремещениеТоваровНовый Тогда
			Возврат Успешно;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Выборка.ПараметрСобытия) = Тип("ДокументСсылка.ПерестикеровкаПереоценка") Тогда //ПерестикеровкаПереоценка
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПараметрСобытия, "Проведен, СтатусДокумента, ВидОперации");
		
		//Только в статусе новый
		Если РеквизитыОснования.СтатусДокумента <> Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаНовый Тогда
			Возврат Успешно;
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки = "В качестве параметра события должен быть указан документ ""Возврат товаров от покупателя"" или ""Перемещение товаров"" или ""Перестикеровка/переоценка""";
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
		ИначеЕсли ТипЗнч(Выборка.ПараметрСобытия) = Тип("ДокументСсылка.ПерестикеровкаПереоценка") Тогда
			Если ДокументОбъект.ВсеПлановоеКоличествоРазмещено() Тогда
				ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаЗавершен;
			КонецЕсли;
		Иначе//Перемещение
			Если ДокументОбъект.ВсеКоличествоРазмещено() Тогда
				ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ПеремещениеТоваровПоступил;
			КонецЕсли;
			Документы.ПеремещениеТоваров.ЗаполнитьОрганизацииТЧТоварыПоПартиям(ДокументОбъект);
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

