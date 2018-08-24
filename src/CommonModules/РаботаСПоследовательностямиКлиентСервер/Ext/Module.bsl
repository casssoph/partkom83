﻿
Функция ЭтоПоддерживаемаяПоследовательность(вхПоследовательность) Экспорт
	
	лТип = ТипЗнч(вхПоследовательность);
	лМетаданныеПоследовательности = Неопределено;
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ЭтоПоддерживаемаяПоследовательность]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Результат = Истина;
	//Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
	//	Результат = Ложь;
	//КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьГраницуПоследовательности(вхПоследовательность, вхФильтр = Неопределено) Экспорт
	
	лТип = ТипЗнч(вхПоследовательность);
	лМетаданныеПоследовательности = Неопределено;
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьГраницуПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лЗапрос = Новый Запрос;
	лТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.МоментВремени
	|ИЗ
	|	Последовательность." + лМетаданныеПоследовательности.Имя + ".Границы КАК Т";
	
	Если (лМетаданныеПоследовательности.Измерения.Количество() > 0)
		И (ТипЗнч(вхФильтр) = Тип("Структура")) тогда
		лТекстЗапроса = лТекстЗапроса + "
		|ГДЕ
		|	1 = 1";
		Для Каждого лИзмерение Из лМетаданныеПоследовательности.Измерения цикл
			лТекстЗапроса = лТекстЗапроса + "
			|	И Т." + лИзмерение.Имя + " = &" + лИзмерение.Имя;
			лЗапрос.УстановитьПараметр(лИзмерение.Имя, вхФильтр[лИзмерение.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	лТекстЗапроса = лТекстЗапроса + "		
	|ДЛЯ ИЗМЕНЕНИЯ
	|	Последовательность." + лМетаданныеПоследовательности.Имя + ".Границы";
	лЗапрос.Текст = лТекстЗапроса;
	
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Если лВыборка.Следующий() тогда
		Возврат лВыборка.МоментВремени;
	КонецЕсли;
	
	Возврат ?(ЭтоПоддерживаемаяПоследовательность(лМетаданныеПоследовательности),
	(Новый МоментВремени('00010101')), (Новый МоментВремени('39991231235959')));
	
КонецФункции

Функция ПолучитьГраницы(вхСсылкаНаДокумент, вхМетаданныеПоследовательности, вхИсходная, вхТребуемая) Экспорт
	
	лПоддерживаемая = ЭтоПоддерживаемаяПоследовательность(вхМетаданныеПоследовательности);
	лФильтр = Новый Структура;
	Для Каждого лИзмерение Из вхМетаданныеПоследовательности.Измерения цикл
		лФильтр.Вставить(лИзмерение.Имя, );
	КонецЦикла;
	
	лДобавить = Неопределено;
	лУдалить = Неопределено;
	лТаблицыИдентичны = ТаблицыИдентичны(вхИсходная, вхТребуемая, лДобавить, лУдалить);
	лЗамещать = (лУдалить.Количество() > 0);
	Результат = Новый ТаблицаЗначений;
	Для Каждого лКолонка Из вхИсходная.Колонки цикл
		Результат.Колонки.Добавить(лКолонка.Имя, лКолонка.ТипЗначения);
	КонецЦикла;
	
	// границы
	Для Каждого лСтрокаТребуемая Из вхТребуемая цикл
		ЗаполнитьЗначенияСвойств(лФильтр, лСтрокаТребуемая);
		лСтрокаГраницы = ОбщегоНазначения.НайтиСтрокуТаблицы(Результат, лФильтр);
		Если (лСтрокаГраницы = Неопределено) тогда
			лСтрокаГраницы = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаГраницы, лСтрокаТребуемая);
		ИначеЕсли (лСтрокаГраницы.Период > лСтрокаТребуемая.Период) тогда
			лМоментВремени = Новый МоментВремени(лСтрокаГраницы.Период, вхСсылкаНаДокумент);
			Если НЕ(лПоддерживаемая И Последовательности[вхМетаданныеПоследовательности.Имя].Проверить(лМоментВремени, лФильтр)) тогда
				лСтрокаГраницы.Период = лСтрокаТребуемая.Период;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого лСтрокаУдалить Из лУдалить цикл
		ЗаполнитьЗначенияСвойств(лФильтр, лСтрокаУдалить);
		лСтрокаГраницы = ОбщегоНазначения.НайтиСтрокуТаблицы(Результат, лФильтр);
		Если (лСтрокаГраницы = Неопределено) тогда
			лСтрокаГраницы = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаГраницы, лСтрокаУдалить);
		ИначеЕсли (лСтрокаГраницы.Период > лСтрокаУдалить.Период) тогда
			лМоментВремени = Новый МоментВремени(лСтрокаГраницы.Период, вхСсылкаНаДокумент);
			Если НЕ(лПоддерживаемая И Последовательности[вхМетаданныеПоследовательности.Имя].Проверить(лМоментВремени, лФильтр)) тогда
				лСтрокаГраницы.Период = лСтрокаУдалить.Период;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СкопироватьСтруктуруТаблицыЗначений(вхИсходнаяТаблица) Экспорт
	
	Если ТипЗнч(вхИсходнаяТаблица) <> Тип("ТаблицаЗначений") тогда
		ВызватьИсключение "[СкопироватьСтруктуруТаблицыЗначений]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений;
	Для Каждого лКолонка Из вхИсходнаяТаблица.Колонки цикл
		Результат.Колонки.Добавить(лКолонка.Имя, лКолонка.ТипЗначения);
	КонецЦикла;
	
	Возврат Результат;	
	
КонецФункции

Функция ТаблицыИдентичны(вхИсходная, вхТребуемая, выхДобавить, выхУдалить) Экспорт
	
	Перем лИмяСлужебнойКолонки;
	
	Результат = Истина;
	выхДобавить = Новый ТаблицаЗначений;
	выхУдалить = Новый ТаблицаЗначений;
	
	лТипТаблицаЗначений = Тип("ТаблицаЗначений");
	Если (ТипЗнч(вхИсходная) <> лТипТаблицаЗначений) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Если (ТипЗнч(вхТребуемая) <> лТипТаблицаЗначений) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если (вхИсходная.Колонки.Количество() <> вхТребуемая.Колонки.Количество()) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: в параметры функции переданы таблицы различной структуры.";
	КонецЕсли;
	
	лИменаКолонок = "";
	Для Каждого лИсходнаяКолонка Из вхИсходная.Колонки цикл
		лТребуемаяКолонка = вхТребуемая.Колонки.Найти(лИсходнаяКолонка.Имя);
		Если (лТребуемаяКолонка = Неопределено) тогда
			ВызватьИсключение "[ТаблицыИдентичны]: в параметры функции переданы таблицы различной структуры.";
		КонецЕсли;
		лИменаКолонок = лИменаКолонок + лИсходнаяКолонка.Имя + ",";
		выхДобавить.Колонки.Добавить(лТребуемаяКолонка.Имя, лТребуемаяКолонка.ТипЗначения);
		выхУдалить.Колонки.Добавить(лИсходнаяКолонка.Имя, лИсходнаяКолонка.ТипЗначения);
	КонецЦикла;
	лИменаКолонок = Лев(лИменаКолонок, СтрДлина(лИменаКолонок) - 1);
	
	лКолИсходная = вхИсходная.Количество();
	лКолТребуемая = вхТребуемая.Количество();
	Если (лКолИсходная = 0) И (лКолТребуемая = 0) тогда
	ИначеЕсли (лКолИсходная = 0) И (лКолТребуемая > 0) тогда // для оптимизации
		Результат = Ложь;
		выхДобавить = вхТребуемая.Скопировать();
	ИначеЕсли (лКолИсходная > 0) И (лКолТребуемая = 0) тогда // для оптимизации
		Результат = Ложь;
		выхУдалить = вхИсходная.Скопировать();
	Иначе // общий случай
		лИмяСлужебнойКолонки = "_" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
		
		лОбрТаб = вхИсходная.Скопировать();
		лОбрТаб.Колонки.Добавить(лИмяСлужебнойКолонки, Новый ОписаниеТипов("Число",
		Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Любой)));
		лОбрТаб.ЗаполнитьЗначения(-1, лИмяСлужебнойКолонки);
		
		Для Каждого лСтрокаТребуемая Из вхТребуемая цикл
			лСтрокаОбрТаб = лОбрТаб.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаОбрТаб, лСтрокаТребуемая);
			лСтрокаОбрТаб[лИмяСлужебнойКолонки] = 1;
		КонецЦикла;
		
		лОбрТаб.Свернуть(лИменаКолонок, лИмяСлужебнойКолонки);
		
		Для Каждого лСтрокаОбрТаб Из лОбрТаб цикл
			
			лТекЗнач = лСтрокаОбрТаб[лИмяСлужебнойКолонки];
			Если (лТекЗнач = 0) тогда
				Продолжить;
			ИначеЕсли (лТекЗнач < 0) тогда
				лТекТаб = выхУдалить;
				лГраница = -лТекЗнач;
			Иначе
				лТекТаб = выхДобавить;
				лГраница = лТекЗнач;
			КонецЕсли;
			
			Результат = Ложь;
			
			Для к = 1 по лГраница цикл
				лСтрокаТекТаб = лТекТаб.Добавить();
				ЗаполнитьЗначенияСвойств(лСтрокаТекТаб, лСтрокаОбрТаб);
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	
	Результат = Новый Структура;
	лМетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(вхСсылкаНаОбъект));
	Если (лМетаданныеОбъекта <> Неопределено) тогда
		лМенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лМетаданныеОбъекта);
		лРеквизитыКонтроля = лМенеджерОбъекта.ПолучитьРеквизитыКонтроля(вхПараметр);
		
		лШапка = Неопределено;
		Если лРеквизитыКонтроля.Свойство("Шапка", лШапка) тогда
			Результат.Вставить("Шапка", ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаОбъект, лШапка));	
		КонецЕсли;
		
		лТабличныеЧасти = Неопределено;
		Если лРеквизитыКонтроля.Свойство("ТабличныеЧасти", лТабличныеЧасти) тогда
			Результат.Вставить("ТабличныеЧасти", Новый Структура);
			Для Каждого лЭлементСтруктуры Из лТабличныеЧасти цикл
				Результат.ТабличныеЧасти.Вставить(лЭлементСтруктуры.Ключ,
				ОбщегоНазначения.ЗначенияРеквизитовТабличнойЧастиОбъекта(вхСсылкаНаОбъект, лЭлементСтруктуры.Ключ, лЭлементСтруктуры.Значение));		
			КонецЦикла;			
		КонецЕсли;
		
		лДвижения = Неопределено;
		Если лРеквизитыКонтроля.Свойство("Движения", лДвижения) тогда
			Результат.Вставить("Движения", Новый Соответствие);	
			Для Каждого лЭлементСоответствия Из лДвижения цикл
				Результат.Движения.Вставить(лЭлементСоответствия.Ключ, ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаОбъект,
				лЭлементСоответствия.Ключ, лЭлементСоответствия.Значение));
			КонецЦикла;			
		КонецЕсли;
		
		лПоследовательности = Неопределено;
		Если лРеквизитыКонтроля.Свойство("Последовательности", лПоследовательности) тогда
			Результат.Вставить("Последовательности", Новый Соответствие);	
			Для Каждого лЭлементСоответствия Из лПоследовательности цикл
				Результат.Последовательности.Вставить(лЭлементСоответствия.Ключ, ПроведениеДокументовКлиентСервер.ЗначенияПоследовательностейДокумента(вхСсылкаНаОбъект,
				лЭлементСоответствия.Ключ, лЭлементСоответствия.Значение));
			КонецЦикла;			
		КонецЕсли;
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Процедура ЗарегистрироватьОбъект(вхОбъектДокумента, вхПоследовательность) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъект]: неправильный параметр номер 2.";
	КонецЕсли;
	
	лМетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(вхОбъектДокумента));
	Если (лМетаданныеДокумента = Неопределено) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъект]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъект]: документ не входит в последовательность.";
	КонецЕсли;
	
	лСсылкаНаДокумент = вхОбъектДокумента.Ссылка;
	лМенеджерПоследовательности = Последовательности[лМетаданныеПоследовательности.Имя];
	лОтбор = Новый Структура;
	Для Каждого лИзмерение Из лМетаданныеПоследовательности.Измерения цикл
		лОтбор.Вставить(лИзмерение.Имя, );	
	КонецЦикла;
	
	лТребуемая = вхОбъектДокумента.ПолучитьЗаписиПоследовательности(лМетаданныеПоследовательности);
	лИсходная = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(
	лМетаданныеПоследовательности, ПроведениеДокументовКлиентСервер.ЗначенияПоследовательностейДокумента(
	лСсылкаНаДокумент, лМетаданныеПоследовательности));
	лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая);
	
	ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(лСсылкаНаДокумент, лМетаданныеПоследовательности, лРазностныеДанные);
		
КонецПроцедуры

Функция РазностныеДанные(вхИсходная, вхТребуемая) Экспорт
	
	лДобавить = Неопределено;
	лУдалить = Неопределено;
	
	Результат = Новый Структура;
	Результат.Вставить("Идентичны", ТаблицыИдентичны(вхИсходная, вхТребуемая, лДобавить, лУдалить));
	Результат.Вставить("Замещать", (лУдалить.Количество() > 0));
	Результат.Вставить("Исходная", вхИсходная);
	Результат.Вставить("Требуемая", вхТребуемая);
	Результат.Вставить("Добавить", лДобавить);
	Результат.Вставить("Удалить", лУдалить);
	Если Результат.Замещать тогда
		Результат.Вставить("Движения", вхТребуемая);
	Иначе
		Результат.Вставить("Движения", лДобавить);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИзмененныеИзмерения(вхМетаданныеПоследовательности, вхДобавить, вхУдалить) 
	
	Результат = Новый ТаблицаЗначений;
	лФильтр = Новый Структура;
	Для Каждого лИзмерение Из вхМетаданныеПоследовательности.Измерения цикл
		Результат.Колонки.Добавить(лИзмерение.Имя, лИзмерение.Тип);
		лФильтр.Вставить(лИзмерение.Имя, );
	КонецЦикла;
	
	Для Каждого лСтрокаДобавить Из вхДобавить цикл
		ЗаполнитьЗначенияСвойств(лФильтр, лСтрокаДобавить);
		лСтрокаРезультат = ОбщегоНазначения.НайтиСтрокуТаблицы(Результат, лФильтр);
		Если (лСтрокаРезультат = Неопределено) тогда
			лСтрокаРезультат = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаРезультат, лФильтр);
		КонецЕсли;			
	КонецЦикла;
	
	Для Каждого лСтрокаУдалить Из вхУдалить цикл
		ЗаполнитьЗначенияСвойств(лФильтр, лСтрокаУдалить);
		лСтрокаРезультат = ОбщегоНазначения.НайтиСтрокуТаблицы(Результат, лФильтр);
		Если (лСтрокаРезультат = Неопределено) тогда
			лСтрокаРезультат = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаРезультат, лФильтр);
		КонецЕсли;			
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[НачатьКорректировкуГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	лМенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(вхСсылкаНаДокумент);
	
	Если ТипЗнч(вхПараметры) <> Тип("Структура") тогда
		вхПараметры = Новый Структура;
	КонецЕсли;
	
	Если НЕ вхПараметры.Свойство("Последовательности") тогда
		вхПараметры.Вставить("Последовательности", Новый Соответствие);
	КонецЕсли;
	
	лФильтр = Неопределено;
	вхПараметры.Свойство("Фильтр", лФильтр);
	
	вхПараметры.Последовательности.Вставить(лМетаданныеПоследовательности, 
	лМенеджерДокумента.ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, лМетаданныеПоследовательности, лФильтр));
	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ЗакончитьКорректировкуГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	лМенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(вхСсылкаНаДокумент);
	лМенеджерПоследовательности = Последовательности[лМетаданныеПоследовательности.Имя];
	лОтбор = Новый Структура;
	Для Каждого лИзмерение Из лМетаданныеПоследовательности.Измерения цикл
		лОтбор.Вставить(лИзмерение.Имя, );	
	КонецЦикла;
	
	лФильтр = Неопределено;
	Если ТипЗнч(вхПараметры) = Тип("Структура") тогда
		вхПараметры.Свойство("Фильтр", лФильтр);
	КонецЕсли;
		
	лСтарыеЗначения = вхПараметры.Последовательности.Получить(лМетаданныеПоследовательности);
	лНовыеЗначения = лМенеджерДокумента.ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, лМетаданныеПоследовательности, лФильтр);
	лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лСтарыеЗначения, лНовыеЗначения);
	лИзмененныеДанные = ПолучитьИзмененныеИзмерения(лМетаданныеПоследовательности, 
	лРазностныеДанные.Добавить, лРазностныеДанные.Удалить);
	
	лГраницы = РаботаСПоследовательностямиКлиентСервер.ПолучитьГраницы(
	вхСсылкаНаДокумент, лМетаданныеПоследовательности, лСтарыеЗначения, лНовыеЗначения);
	
	// границы
	Для Каждого лСтрокаГраницы Из лГраницы цикл
		лРезультатСравнения = Неопределено; //Сбрасываем значение, иначе переходит в следующий такт цикла. Добавлено Валиахметов А.А.
		ЗаполнитьЗначенияСвойств(лОтбор, лСтрокаГраницы);
		лМоментВремени = Новый МоментВремени(лСтрокаГраницы.Период, вхСсылкаНаДокумент);
		лИзменен = (ОбщегоНазначения.НайтиСтрокуТаблицы(лИзмененныеДанные, лОтбор) <> Неопределено);
		Если НЕ лИзменен тогда
    	лГраница = РаботаСПоследовательностямиКлиентСервер.ПолучитьГраницуПоследовательности(лМетаданныеПоследовательности, лОтбор);
			лРезультатСравнения = лГраница.Сравнить(лМоментВремени);
			Если (лРезультатСравнения = 1) тогда
				лМоментВремени = лГраница;
			КонецЕсли;
		КонецЕсли;
		
		//Проверка "лМенеджерПоследовательности.Проверить(лМоментВремени, лОтбор)" убрана, не всегда отрабатывает правильно
		//Заменено на ОпределитьНеобходимостьСдвигаГраницы()
		
		СдвигатьГраницу = ОпределитьНеобходимостьСдвигаГраницы(лМоментВремени, лМетаданныеПоследовательности.Имя, лОтбор);
		Если СдвигатьГраницу
			И (лРезультатСравнения <> 0) тогда
			лМенеджерПоследовательности.УстановитьГраницу(лМоментВремени, лОтбор);
		КонецЕсли;
	КонецЦикла;
	
	//Сдвигаем границу если запись по номенклатуре есть в последовательности, но движений по нет не было и нет
	Если лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет И ТипЗнч(лФильтр) = Тип("Структура") и лФильтр.Свойство("Номенклатура") Тогда 
		Если лСтарыеЗначения.Количество() = 0 и лНовыеЗначения.Количество() = 0 Тогда 
			ЗаполнитьЗначенияСвойств(лОтбор, лФильтр);
			лГраница = ПолучитьГраницуПоследовательности(вхПоследовательность, лФильтр);	
			лМоментВремени = вхСсылкаНаДокумент.МоментВремени();
			лРезультатСравнения = лГраница.Сравнить(лМоментВремени);
			Если (лРезультатСравнения = 1) тогда
				лМоментВремени = лГраница;
			КонецЕсли;
			
			Если лМенеджерПоследовательности.Проверить(лМоментВремени, лОтбор)
				И (лРезультатСравнения <> 0) Тогда
				лМенеджерПоследовательности.УстановитьГраницу(лМоментВремени, лОтбор);  
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьНеобходимостьСдвигаГраницы(ДокументМоментВремени, ИмяПоследовательности, Отбор = Неопределено) Экспорт
	
	лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(ИмяПоследовательности);
	
	// Границу последовательности можно сдвигать вперед только если между границей
	// и документом нет других документов в последовательности
	Запрос = Новый Запрос;
	лТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Последовательность.Регистратор
	               |ИЗ
	               |	Последовательность.ПартионныйУчет КАК Последовательность
	               |ГДЕ
	               |	Последовательность.МоментВремени > &ГраницаМоментВремени
	               |	И Последовательность.Регистратор <> &ГраницаСсылка
	               |	И Последовательность.Регистратор <> &ДокументСсылка
	               |	И Последовательность.МоментВремени < &ДокументМоментВремени";
	
	Если (лМетаданныеПоследовательности.Измерения.Количество() > 0)
		И (ТипЗнч(Отбор) = Тип("Структура")) тогда

		Для Каждого лИзмерение Из лМетаданныеПоследовательности.Измерения цикл
			лТекстЗапроса = лТекстЗапроса + "
			|	И Последовательность." + лИзмерение.Имя + " = &" + лИзмерение.Имя;
			Запрос.УстановитьПараметр(лИзмерение.Имя, Отбор[лИзмерение.Имя]);
		КонецЦикла;
	КонецЕсли;

	лТекстЗапроса = СтрЗаменить(лТекстЗапроса, "ПартионныйУчет", ИмяПоследовательности);
	
	Запрос.Текст = лТекстЗапроса;
	
	ГраницаМоментВремени = РаботаСПоследовательностямиКлиентСервер.ПолучитьГраницуПоследовательности(ИмяПоследовательности, Отбор);
	
	//Дату для границы надо получить из данных последовательности (в границе она равна дате документа)
	ПериодИзПоследовательности = ПериодИзПоследовательности(ГраницаМоментВремени.Ссылка, ИмяПоследовательности);
	Если ЗначениеЗаполнено(ПериодИзПоследовательности) И ГраницаМоментВремени.Дата <> ПериодИзПоследовательности Тогда
		Параметр_ГраницаМоментВремени = Новый МоментВремени(ПериодИзПоследовательности, ГраницаМоментВремени.Ссылка); 
	Иначе
		Параметр_ГраницаМоментВремени = ГраницаМоментВремени; 
	КонецЕсли;
	
	//Дату для документа тоже надо получить из данных последовательности
	ПериодИзПоследовательности = ПериодИзПоследовательности(ДокументМоментВремени.Ссылка, ИмяПоследовательности);
	Если ЗначениеЗаполнено(ПериодИзПоследовательности) И ДокументМоментВремени.Дата <> ПериодИзПоследовательности Тогда
		Параметр_ДокументМоментВремени = Новый МоментВремени(ПериодИзПоследовательности, ДокументМоментВремени.Ссылка); 
	Иначе
		Параметр_ДокументМоментВремени = ДокументМоментВремени; 
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ГраницаСсылка", 			 ГраницаМоментВремени.Ссылка);
	Запрос.УстановитьПараметр("ДокументСсылка", 		 ДокументМоментВремени.Ссылка);
	Запрос.УстановитьПараметр("ГраницаМоментВремени", 	 Параметр_ГраницаМоментВремени);
	Запрос.УстановитьПараметр("ДокументМоментВремени", 	 Параметр_ДокументМоментВремени);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции 

Функция ПериодИзПоследовательности(Ссылка, ИмяПоследовательности)
	
	Период = Дата(1,1,1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	                |	Период
	                |ИЗ
	                |	Последовательность.ПартионныйУчет КАК Последовательность
	                |ГДЕ
	                |	Последовательность.Регистратор = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПартионныйУчет", ИмяПоследовательности);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Период = Выборка.Период;
	КонецЕсли;
	
	Возврат  Период;
	
КонецФункции

Функция РазделенныеДанные(вхТаблица, вхФильтр, вхУчитыватьРегистр = Истина) Экспорт
	
	Результат = Новый Структура("Включенные,Исключенные");
	Если (ТипЗнч(вхФильтр) = Тип("Структура")) тогда
		Результат.Включенные = РаботаСПоследовательностямиКлиентСервер.СкопироватьСтруктуруТаблицыЗначений(вхТаблица);
		Результат.Исключенные = РаботаСПоследовательностямиКлиентСервер.СкопироватьСтруктуруТаблицыЗначений(вхТаблица);
		лСтрокиТаблицы = ОбщегоНазначения.НайтиСтрокиТаблицы(вхТаблица, вхФильтр, вхУчитыватьРегистр);
		Для Каждого лСтрокаТаблица Из вхТаблица цикл
			Если (лСтрокиТаблицы.Найти(лСтрокаТаблица) = Неопределено) тогда
				лТекТаблица = Результат.Исключенные;
			Иначе
				лТекТаблица = Результат.Включенные;
			КонецЕсли;
			лСтрокаТекТаблица = лТекТаблица.Добавить();
			ЗаполнитьЗначенияСвойств(лСтрокаТекТаблица, лСтрокаТаблица);
		КонецЦикла;
	Иначе
		Результат.Включенные = вхТаблица.Скопировать();
		Результат.Исключенные = РаботаСПоследовательностямиКлиентСервер.СкопироватьСтруктуруТаблицыЗначений(вхТаблица);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, вхПоследовательность, Проведение) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъектПоСсылке]: неправильный параметр номер 2.";
	КонецЕсли;
	
	лМетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(вхСсылкаНаДокумент));
	Если (лМетаданныеДокумента = Неопределено) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъектПоСсылке]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ЗарегистрироватьОбъектПоСсылке]: документ не входит в последовательность.";
	КонецЕсли;
	
	лСсылкаНаДокумент = вхСсылкаНаДокумент;
	лМенеджерПоследовательности = Последовательности[лМетаданныеПоследовательности.Имя];
	лОтбор = Новый Структура;
	Для Каждого лИзмерение Из лМетаданныеПоследовательности.Измерения цикл
		лОтбор.Вставить(лИзмерение.Имя, );	
	КонецЦикла;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(вхСсылкаНаДокумент);
	лТребуемая = МенеджерОбъекта.ПолучитьЗаписиПоследовательности(вхСсылкаНаДокумент, лМетаданныеПоследовательности, Проведение);	
	лИсходная = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(
	лМетаданныеПоследовательности, ПроведениеДокументовКлиентСервер.ЗначенияПоследовательностейДокумента(
	лСсылкаНаДокумент, лМетаданныеПоследовательности));
	лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая);
	
	ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(лСсылкаНаДокумент, лМетаданныеПоследовательности, лРазностныеДанные);
		
КонецПроцедуры

//Добавлено Валихметов А.А.
Функция ТаблицыИдентичныНовое(Знач Исходная, Знач Требуемая, Дельта, Знач АгрегатныеКолонки) Экспорт 
	
	Дельта = Новый ТаблицаЗначений;
	
	лТипТаблицаЗначений = Тип("ТаблицаЗначений");
	Если (ТипЗнч(Исходная) <> лТипТаблицаЗначений) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Если (ТипЗнч(Требуемая) <> лТипТаблицаЗначений) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если (Исходная.Колонки.Количество() <> Требуемая.Колонки.Количество()) тогда
		ВызватьИсключение "[ТаблицыИдентичны]: в параметры функции переданы таблицы различной структуры.";
	КонецЕсли;
	
	МассивАгрегатныхКолонок = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(АгрегатныеКолонки);
	МассивГруппируемыхКолонок = Новый Массив;
	
	ГруппируемыеКолонки = "";
	Для Каждого ИсходнаяКолонка Из Исходная.Колонки цикл
		ТребуемаяКолонка = Требуемая.Колонки.Найти(ИсходнаяКолонка.Имя);
		Если (ТребуемаяКолонка = Неопределено) тогда
			ВызватьИсключение "[ТаблицыИдентичны]: в параметры функции переданы таблицы различной структуры.";
		КонецЕсли;
		Если МассивАгрегатныхКолонок.Найти(ИсходнаяКолонка.Имя) = Неопределено Тогда 
			ГруппируемыеКолонки = ГруппируемыеКолонки + ИсходнаяКолонка.Имя + ",";
			МассивГруппируемыхКолонок.Добавить(ИсходнаяКолонка.Имя);
		КонецЕсли;
		Дельта.Колонки.Добавить(ТребуемаяКолонка.Имя, ТребуемаяКолонка.ТипЗначения);
	КонецЦикла;
	
	ГруппируемыеКолонки = Лев(ГруппируемыеКолонки, СтрДлина(ГруппируемыеКолонки) - 1);
	
	Исходная.Свернуть(ГруппируемыеКолонки, АгрегатныеКолонки);
	Требуемая.Свернуть(ГруппируемыеКолонки, АгрегатныеКолонки);
	
	КолИсходная = Исходная.Количество();
	КолТребуемая = Требуемая.Количество();
	
	Если (КолИсходная = 0) И (КолТребуемая = 0) тогда
		
	ИначеЕсли (КолИсходная = 0) И (КолТребуемая > 0) тогда // для оптимизации
		Дельта = Требуемая.Скопировать();
	ИначеЕсли (КолИсходная > 0) И (КолТребуемая = 0) тогда // для оптимизации
		Дельта = Исходная.Скопировать();
		Для Каждого СтрокаТЧ Из Дельта Цикл 
			Для Каждого Колонка Из МассивАгрегатныхКолонок Цикл 
				СтрокаТЧ[Колонка] = - СтрокаТЧ[Колонка];	
			КонецЦикла;
		КонецЦикла;
	Иначе // общий случай
		Для Каждого СтрокаТребуемая Из Требуемая Цикл 
			Отбор = Новый Структура(ГруппируемыеКолонки);
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаТребуемая);
			СтрокиИсх = Исходная.НайтиСтроки(Отбор);
			Если СтрокиИсх.Количество() = 0 Тогда 
				ЗаполнитьЗначенияСвойств(Дельта.Добавить(), СтрокаТребуемая);
			Иначе
				СтрокаИсходная = СтрокиИсх.Получить(0);
				СтрокиСовпадают = Истина;
				Для Каждого Колонка Из МассивАгрегатныхКолонок Цикл  
					Если Не (СтрокаТребуемая[Колонка] = СтрокаИсходная[Колонка]) Тогда 
						СтрокиСовпадают = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;	
				Если Не СтрокиСовпадают Тогда 
					СтрокаДельта = Дельта.Добавить(); 
					ЗаполнитьЗначенияСвойств(СтрокаДельта, СтрокаТребуемая, ГруппируемыеКолонки);
					Для Каждого Колонка Из МассивАгрегатныхКолонок  Цикл 
						СтрокаДельта[Колонка] =  СтрокаТребуемая[Колонка] -  СтрокаИсходная[Колонка];
					КонецЦикла;	
				КонецЕсли;
				Исходная.Удалить(СтрокаИсходная);
			КонецЕсли;
		КонецЦикла;
		Для Каждого СтрокаИсходная Из Исходная Цикл 
			СтрокаДельта = Дельта.Добавить(); 					
			ЗаполнитьЗначенияСвойств(СтрокаДельта, СтрокаИсходная);
			Для Каждого Колонка Из МассивАгрегатныхКолонок Цикл 
				СтрокаДельта[Колонка] = - СтрокаДельта[Колонка];	
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Дельта.Количество() = 0;
	
КонецФункции

