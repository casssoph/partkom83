﻿
Функция РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	ТаблицаДвижений = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", ТаблицаДвижений);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата") < ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты Тогда
		Возврат ТаблицаДвижений
	КонецЕсли;
	
	СформироватьДвижения = Истина;
	
	Если ТипЗнч(вхПараметры) = Тип("Структура") И вхПараметры.Свойство("Фильтр") И ТипЗнч(вхПараметры.Фильтр) = Тип("Структура") И вхПараметры.Фильтр.Свойство("ДоговорКонтрагента") И Не вхПараметры.Фильтр.ДоговорКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ДоговорКонтрагента") Тогда
		СформироватьДвижения = Ложь;
	КонецЕсли;
		
	Если СформироватьДвижения Тогда
		
		ДоговорКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ДоговорКонтрагента");
		ВалютаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ВалютаДокумента");
		КурсВзаиморасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "КурсВзаиморасчетов");
		КратностьВзаиморасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "КратностьВзаиморасчетов");
		СуммаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "СуммаДокумента");
		ЗнакДвижения = 1;
		
		ТаблицаДвижений = УправлениеВзаиморасчетами.ПростоеПроведениеПоВзаиморасчетам(вхСсылкаНаДокумент, ДоговорКонтрагента, Неопределено, ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов, СуммаДокумента, ЗнакДвижения);
		
	КонецЕсли;
	
	Возврат ТаблицаДвижений
	
КонецФункции

Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.ОтчетКомиссионераОПродажах;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Шапка", "Дата,Проведен");
	Возврат Результат;
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр);
КонецФункции

Функция ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхФильтр = Неопределено) Экспорт
	
	Результат = Неопределено;
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.Взаиморасчеты, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	лКонтроль = Неопределено;
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДанныеОбъекта.Контроль", лКонтроль);
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "Взаиморасчеты") тогда
		// регистр накопления "Взаиморасчеты"
		НовоеПроведениеПоВзаиморасчетам = глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам");
		
		лОчищать = Ложь;
		Если НовоеПроведениеПоВзаиморасчетам Тогда 
			лОчищать = ПроведениеДокументовКлиентСервер.НеобходимоОчиститьДвиженияВзаиморасчеты(вхСсылкаНаДокумент);
		Иначе
			Если (лКонтроль <> Неопределено) тогда
				лОчищать = (лКонтроль.СтарыеЗначения.Шапка.Дата < лКонтроль.НовыеЗначения.Шапка.Дата)
				И лКонтроль.СтарыеЗначения.Шапка.Проведен;
			КонецЕсли;
		КонецЕсли;	
		
		НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
		
		Если лОчищать тогда
			ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты);
			лБазовая = Неопределено;
			ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", лБазовая);
			лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
		Иначе
			лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
			лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты);	
		КонецЕсли;
		
		лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
		лИсходная = лРазделенныеБазовая.Включенные;
		//лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
		лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
		ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты,
		лРазностныеДанные, лРазделенныеБазовая.Исключенные);
		
		ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
		
		Если НовоеПроведениеПоВзаиморасчетам И лФильтр = Неопределено Тогда 
			РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПоРасчетамСКонтрагентами", Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент);
	ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
	
	Если глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам") Тогда 
		РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПоРасчетамСКонтрагентами", Ложь);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьЗаписиПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, Проведение) Экспорт 
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лМетаданныеДокумента = вхСсылкаНаДокумент.Метаданные();
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "Дата,ДоговорКонтрагента");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) Тогда
		Если Проведение
			И (Реквизиты.Дата >= ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты)
			И  ОбщегоНазначения.ИспользоватьПогашениеПоРасчетнымДокументам(Реквизиты.ДоговорКонтрагента)
			тогда
			лСтрокаРезультат = лРезультат.Добавить();
			лСтрокаРезультат.ДоговорКонтрагента = Реквизиты.ДоговорКонтрагента;
			лСтрокаРезультат.Период = Реквизиты.Дата;
			лСтрокаРезультат.Регистратор = вхСсылкаНаДокумент;
		КонецЕсли;
	Иначе 		
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
	Возврат Результат;

КонецФункции