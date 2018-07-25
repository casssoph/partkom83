﻿
Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.КорректировкаДолга;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	Результат = Новый Структура;
	Если (вхПараметр = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		Результат.Вставить("Шапка", "Дата,Проведен");
	ИначеЕсли (вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом77_83) тогда
		Результат.Вставить("Шапка", "Номер,Дата,Проведен,ПометкаУдаления,Организация,"
		"КонтрагентДебитор,Комментарий,ВидОперации,ВалютаДокумента,КурсДокумента,КратностьДокумента,"
		"КонтрагентКредитор,ДоговорКонтрагента");
		Результат.Вставить("ТабличныеЧасти", Новый Структура("СуммыДолга", "ДоговорКонтрагента,"
		"Сумма,КурсВзаиморасчетов,КратностьВзаиморасчетов,ВидЗадолженности,"
		"ДокументРасчетовСКонтрагентом,СуммаРегл,СуммаНУ"));
	ИначеЕсли вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом83_77 тогда
		Результат = ОбменДаннымиКлиентСервер.РеквизитыКонтроляПоДокументу(ПолучитьМетаданные(), ИсключаемыеРеквизитыКонтроляРегистрации());
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ИсключаемыеРеквизитыКонтроляРегистрации() Экспорт
	
	ИсключаемыеРеквизиты = ОбменДаннымиКлиентСервер.ИнициализироватьТаблицуИсключаемыхРеквизитовКонтроля();
	ОбменДаннымиКлиентСервер.ДобавитьВИсключаемыеРевизиты(ИсключаемыеРеквизиты, "Ссылка");
	
	Возврат ИсключаемыеРеквизиты;
	
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

Функция РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	
	лРеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "ВидОперации,ВалютаДокумента");
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата") < ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты
		ИЛИ лРеквизитыДокумента.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносДепозита Тогда
		ТаблицаДвижений = Неопределено;
		ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", ТаблицаДвижений);
		Возврат ТаблицаДвижений
	КонецЕсли;
		
	// формируем таблицы для запроса остатков по задолженности
	лПараметрыОстатков = Новый ТаблицаЗначений;
	лПараметрыОстатков.Колонки.Добавить("ДоговорКонтрагента", Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	лПараметрыОстатков.Колонки.Добавить("ЗнакСуммы", Новый ОписаниеТипов("Число"));
	
	лСуммыДолга = ОбщегоНазначения.ЗначенияРеквизитовТабличнойЧастиОбъекта(вхСсылкаНаДокумент, "СуммыДолга", "ДоговорКонтрагента,Сумма,КурсВзаиморасчетов,КратностьВзаиморасчетов,ВидЗадолженности,ДокументРасчетовСКонтрагентом,СуммаРегл,СуммаНУ");
	
	Если (лРеквизитыДокумента.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженности)тогда
		
		Для Каждого лСтрокаСуммыДолга Из лСуммыДолга цикл
			лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
			лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
			лСтрокаПараметрыОстатков.ЗнакСуммы = -1;
			
			лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
			лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
			лСтрокаПараметрыОстатков.ЗнакСуммы = 1;
		КонецЦикла;
		
	ИначеЕсли (лРеквизитыДокумента.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета) тогда
		
		Для Каждого лСтрокаСуммыДолга Из лСуммыДолга цикл
			Если лСтрокаСуммыДолга.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская тогда
				лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
				лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
				лСтрокаПараметрыОстатков.ЗнакСуммы = 1;
			ИначеЕсли лСтрокаСуммыДолга.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская тогда
				лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
				лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
				лСтрокаПараметрыОстатков.ЗнакСуммы = -1;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли (лРеквизитыДокумента.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности) тогда	
		
		Для Каждого лСтрокаСуммыДолга Из лСуммыДолга цикл
			лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
			лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
			лСтрокаПараметрыОстатков.ЗнакСуммы = 1;
		КонецЦикла;
		
	ИначеЕсли (лРеквизитыДокумента.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженостиХолднинг) тогда	
		
		Для Каждого лСтрокаСуммыДолга Из лСуммыДолга цикл
			лСтрокаПараметрыОстатков = лПараметрыОстатков.Добавить();
			лСтрокаПараметрыОстатков.ДоговорКонтрагента = лСтрокаСуммыДолга.ДоговорКонтрагента;
			лСтрокаПараметрыОстатков.ЗнакСуммы = ?(лСтрокаСуммыДолга.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская,1,-1);
		КонецЦикла;

		
	КонецЕсли;
	
	// запрос остатков по долгам
	лСтрокиПараметрыОстатков = лПараметрыОстатков.НайтиСтроки(Новый Структура("ЗнакСуммы", 1));
	лДоговорыКонтрагентов = Новый Массив;
	Для Каждого лСтрокаПараметрыОстатков Из лСтрокиПараметрыОстатков цикл
		лДоговорыКонтрагентов.Добавить(лСтрокаПараметрыОстатков.ДоговорКонтрагента);	
	КонецЦикла;
	лТабОстПлюс = УправлениеВзаиморасчетами.ПолучитьОстаткиПоВзаиморасчетам(вхСсылкаНаДокумент.МоментВремени(), лДоговорыКонтрагентов, 1);
	//нам должны
	
	лСтрокиПараметрыОстатков = лПараметрыОстатков.НайтиСтроки(Новый Структура("ЗнакСуммы", -1));
	лДоговорыКонтрагентов = Новый Массив;
	Если  вхСсылкаНаДокумент.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженостиХолднинг тогда 
		    лДоговорыКонтрагентов.Добавить(вхСсылкаНаДокумент.ДоговорКонтрагента);
	КонецЕсли;	

	Для Каждого лСтрокаПараметрыОстатков Из лСтрокиПараметрыОстатков цикл
		лДоговорыКонтрагентов.Добавить(лСтрокаПараметрыОстатков.ДоговорКонтрагента);	
	КонецЦикла;
	лТабОстМинус = УправлениеВзаиморасчетами.ПолучитьОстаткиПоВзаиморасчетам(вхСсылкаНаДокумент.МоментВремени(), лДоговорыКонтрагентов, -1);
	//мы должны
	
	лРезультатПлюс = Неопределено;
	лРезультатМинус = Неопределено;
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "Дата, ВидОперации, ВалютаДокумента");
	ТаблицаДвижений = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", ТаблицаДвижений);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КорректировкаДолгаСуммыДолга.ВидЗадолженности,
	|	КорректировкаДолгаСуммыДолга.Сумма КАК СуммаУпр,
	|	КорректировкаДолгаСуммыДолга.КурсВзаиморасчетов как КурсВзаиморасчетов,
	|	КорректировкаДолгаСуммыДолга.КратностьВзаиморасчетов как КратностьВзаиморасчетов,
	|	КорректировкаДолгаСуммыДолга.Ссылка.ВалютаДокумента КАК ВалютаДокумента,
	|	КорректировкаДолгаСуммыДолга.ДокументРасчетовСКонтрагентом,
	|	КорректировкаДолгаСуммыДолга.СуммаРегл,
	|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	КорректировкаДолгаСуммыДолга.Ссылка.ДоговорКонтрагента КАК ДоговорКонтрагентаДебитор,
	|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента КАК ДоговорКонтрагентаКредитор,
	|	КорректировкаДолгаСуммыДолга.Ссылка.ВидОперации
	|ИЗ
	|	Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолгаСуммыДолга
	|ГДЕ
	|	КорректировкаДолгаСуммыДолга.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	СуммаРаспределитьПлюс = лТабОстПлюс.Итог("Сумма");
	СуммаРаспределитьМинус = лТабОстМинус.Итог("Сумма");
	
	Для Каждого Строка из РезультатЗапроса Цикл
		
		лВалютаВзаиморасчетов = Строка.ВалютаВзаиморасчетов;
		лКурсВзаиморасчетов = ?(Строка.КурсВзаиморасчетов=0,1,Строка.КурсВзаиморасчетов);
		лКратностьВзаиморасчетов = ?(Строка.КратностьВзаиморасчетов=0,1,Строка.КратностьВзаиморасчетов);
		лСумма = Строка.СуммаУпр;
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженности Тогда
			
			Если Строка.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаДебитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, 1, лТабОстМинус, ТаблицаДвижений);
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			Иначе
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаДебитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстМинус, ТаблицаДвижений);
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			КонецЕсли;
			
		ИначеЕсли Строка.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета Тогда
			
			Если Строка.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаДебитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстМинус, ТаблицаДвижений);
			Иначе
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			КонецЕсли;
			
		ИначеЕсли Строка.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности Тогда
			
			Если Строка.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстМинус, ТаблицаДвижений);
			Иначе
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			КонецЕсли;
			
		ИначеЕсли Строка.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносДепозита Тогда
			
			Если Строка.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская Тогда
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, -1, лТабОстМинус, ТаблицаДвижений);
			КонецЕсли;
			
		ИначеЕсли  Строка.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженостиХолднинг Тогда
			
				Если Строка.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаДебитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, лСумма, 1, лТабОстМинус, ТаблицаДвижений);
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			Иначе
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаДебитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов, -лСумма, 1, лТабОстМинус, ТаблицаДвижений);
				УправлениеВзаиморасчетами.ДополнитьДвиженияПоВзаиморасчетам(вхСсылкаНаДокумент, Строка.ДоговорКонтрагентаКредитор, Строка.ДокументРасчетовСКонтрагентом, лВалютаВзаиморасчетов, лКурсВзаиморасчетов, лКратностьВзаиморасчетов,лСумма, 1, лТабОстПлюс, ТаблицаДвижений);
			КонецЕсли;


			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаДвижений;
	
КонецФункции

Функция РегистрыНакопления_ДепозитыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	ТабДвижений = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ДепозитыКонтрагентов", ТабДвижений);
	
	Если ОбщегоНазначения.ПолучитьРеквизитОбъекта(вхСсылкаНаДокумент, "ВидОперации") = Перечисления.ВидыОперацийКорректировкаДолга.ПереносДепозита Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	КорректировкаДолгаСуммыДолга.Ссылка.Дата КАК Период,
		|	КорректировкаДолгаСуммыДолга.Ссылка КАК Регистратор,
		|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента,
		|	КорректировкаДолгаСуммыДолга.Сумма КАК СуммаУпр,
		|	КорректировкаДолгаСуммыДолга.СуммаРегл,
		|	КорректировкаДолгаСуммыДолга.КурсВзаиморасчетов,
		|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
		|	КорректировкаДолгаСуммыДолга.КратностьВзаиморасчетов
		|ИЗ
		|	Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолгаСуммыДолга
		|ГДЕ
		|	КорректировкаДолгаСуммыДолга.Ссылка = &Ссылка
		|	И КорректировкаДолгаСуммыДолга.Ссылка.Организация <> КорректировкаДолгаСуммыДолга.ДоговорКонтрагента.Организация
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
		|	КорректировкаДолгаСуммыДолга.Ссылка.Дата,
		|	КорректировкаДолгаСуммыДолга.Ссылка,
		|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента,
		|	КорректировкаДолгаСуммыДолга.Сумма,
		|	КорректировкаДолгаСуммыДолга.СуммаРегл,
		|	КорректировкаДолгаСуммыДолга.КурсВзаиморасчетов,
		|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента.ВалютаВзаиморасчетов,
		|	КорректировкаДолгаСуммыДолга.КратностьВзаиморасчетов
		|ИЗ
		|	Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолгаСуммыДолга
		|ГДЕ
		|	КорректировкаДолгаСуммыДолга.Ссылка = &Ссылка
		|	И КорректировкаДолгаСуммыДолга.Ссылка.Организация = КорректировкаДолгаСуммыДолга.ДоговорКонтрагента.Организация"
		);
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
		
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабДвижений);
		
	КонецЕсли;
	
	Возврат ТабДвижений;
	
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
				Если лКонтроль.Свойство("СтарыеЗначения") Тогда
					лСтарыеЗначения = лКонтроль.СтарыеЗначения.Получить(Метаданные.Последовательности.ПоРасчетамСКонтрагентами);
					лНовыеЗначения = лКонтроль.НовыеЗначения.Получить(Метаданные.Последовательности.ПоРасчетамСКонтрагентами);
					Если (лСтарыеЗначения <> Неопределено) И (лНовыеЗначения <> Неопределено) тогда
						лОчищать = (лСтарыеЗначения.Шапка.Дата < лНовыеЗначения.Шапка.Дата)
						И лСтарыеЗначения.Шапка.Проведен;
					КонецЕсли;
				КонецЕсли;
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
		Если НовоеПроведениеПоВзаиморасчетам и лФильтр = Неопределено Тогда 
			РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПоРасчетамСКонтрагентами", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ДепозитыКонтрагентов") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ДепозитыКонтрагентов",
		РегистрыНакопления_ДепозитыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
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
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "Дата,ВидОперации");
	
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) Тогда
		Если Проведение
			И (Реквизиты.Дата >= ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты)
			И (Реквизиты.ВидОперации <> Перечисления.ВидыОперацийКорректировкаДолга.ПереносДепозита)
			тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	КорректировкаДолгаСуммыДолга.Ссылка.Дата КАК Период,
			|	КорректировкаДолгаСуммыДолга.ДоговорКонтрагента,
			|	КорректировкаДолгаСуммыДолга.Сумма,
			|	КорректировкаДолгаСуммыДолга.Ссылка КАК Регистратор
			|ИЗ
			|	Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолгаСуммыДолга
			|ГДЕ
			|	КорректировкаДолгаСуммыДолга.Ссылка = &Ссылка
			|	И КорректировкаДолгаСуммыДолга.Сумма <> 0";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);			   
			СуммыДолга = Запрос.Выполнить().Выгрузить();			   
			Для Каждого лСтрокаСуммыДолга Из СуммыДолга цикл				
				Если НЕ ОбщегоНазначения.ИспользоватьПогашениеПоРасчетнымДокументам(лСтрокаСуммыДолга.ДоговорКонтрагента) тогда
					Продолжить;
				КонецЕсли;
				лСтрокаРезультат = лРезультат.Добавить();
				ЗаполнитьЗначенияСвойств(лСтрокаРезультат, лСтрокаСуммыДолга);
			КонецЦикла;
		КонецЕсли;
	Иначе 		
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
	Возврат Результат;

КонецФункции