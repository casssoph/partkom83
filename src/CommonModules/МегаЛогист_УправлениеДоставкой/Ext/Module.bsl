﻿

Процедура УстановитьСтатусМаршрутногоЗадания(ДокументСсылка, мСтатус, Отказ = Ложь) Экспорт
	
	тДок = ДокументСсылка.ПолучитьОбъект();
	тДок.Статус = мСтатус;
	Попытка
		тДок.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьМаршрутныйЛистПоЗаданию(МаршрутноеЗадание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МегаЛогист_ДокументыМаршрутныхЛистов.Регистратор КАК Ссылка
	               |ИЗ
	               |	РегистрСведений.МегаЛогист_ДокументыМаршрутныхЛистов КАК МегаЛогист_ДокументыМаршрутныхЛистов
	               |ГДЕ
	               |	МегаЛогист_ДокументыМаршрутныхЛистов.Документ = &МаршрутноеЗадание";
	Запрос.УстановитьПараметр("МаршрутноеЗадание"	, МаршрутноеЗадание);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

//вспомогательная функция возвращает время одной строкой
Функция ПреобразоватьВремяВСтроку(Время)
	Если ЗначениеЗаполнено(Время) Тогда
		Длина = СтрДлина(Время);	
		Ш = 1;
		Результат = "";
		Символ	= Сред(Время, Ш, 1);
		Пока (Найти("0123456789:", Символ) <> 0) и (Символ <> "") и (Ш <= Длина) Цикл
			Если Символ <> ":" Тогда
				Результат	= Результат + Символ;	
			КонецЕсли;	
			Ш = Ш +1;
			Символ	= Сред(Время, Ш, 1);
		КонецЦикла;	
		Если СтрДлина(Результат) < 6 Тогда
			Результат = "0" + Результат;
		КонецЕсли;	
		Возврат Результат;	
	Иначе
		Возврат "000000";
	КонецЕсли;	
КонецФункции	

Функция НайтиПересеченияПоВремени(СтруктураНовойЗаписи) Экспорт
	Запрос	= Новый Запрос;
	ТекстЗапроса	=
	"ВЫБРАТЬ
	|	В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяС,
	|	В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяПо
	|ИЗ
	|	РегистрСведений.В_ДоставкаСтоимостьОтВремени.СрезПоследних(&ДатаДоставки, ) КАК В_ДоставкаСтоимостьОтВремениСрезПоследних
	|ГДЕ
	|	(В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяС >= &ВремяС
	|				И В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяС <= &ВремяПо
	|			ИЛИ В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяПо >= &ВремяС
	|				И В_ДоставкаСтоимостьОтВремениСрезПоследних.ВремяПо <= &ВремяПО)
	|	И В_ДоставкаСтоимостьОтВремениСрезПоследних.Период = &Период";
	Запрос.Текст			= ТекстЗапроса;
	Запрос.УстановитьПараметр("ВремяС", СтруктураНовойЗаписи.ВремяС);
	Запрос.УстановитьПараметр("ВремяПо", СтруктураНовойЗаписи.ВремяПо);
	Запрос.УстановитьПараметр("ДатаДоставки", НачалоДня(СтруктураНовойЗаписи.Дата));
	Запрос.УстановитьПараметр("Период", НачалоДня(СтруктураНовойЗаписи.Дата));
	
	Запрос.Текст	= ТекстЗапроса;
	
	ТаблицаРезультата	=	Запрос.Выполнить().Выгрузить();
	Если ТаблицаРезультата.Количество() > 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;	
	
КонецФункции	

Процедура ПолучитьТоварыДляМаршрутногоЗадания(Объект,Товары) Экспорт
	
	Товары.Очистить();
	
	Для Каждого СтрокаРеализации из Объект.ДокументыРеализации цикл
		Док=СтрокаРеализации.ДокументСсылка;	
	    	
		Если НЕ ЗначениеЗаполнено(Док) тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ Док.Проведен тогда
			Возврат;
		КонецЕсли;
	
		Если Док.Метаданные().ТабличныеЧасти.Найти("Товары") <> Неопределено Тогда		
			Для Каждого СтрокаТовара из Док.Товары цикл
				НоваяСтрока=Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТовара);			
			КонецЦикла;		
		КонецЕсли;
		
		//Заполним факт цену и факт количество
		СтруктураПоиска=Новый Структура("Номенклатура,ХарактеристикаНоменклатуры");
		Для Каждого СтрокаТовары из Товары цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска,СтрокаТовары);
			НайденныеСтроки = Объект.ТоварыФакт.НайтиСтроки(СтруктураПоиска);
			Для Каждого НайденнаяСтрока из НайденныеСтроки цикл
				СтрокаТовары.КоличествоФакт=СтрокаТовары.КоличествоФакт+НайденнаяСтрока.Количество;			
			КонецЦикла;
			
			СтрокаТовары.Цена=?(СтрокаТовары.Количество=0,0,СтрокаТовары.Сумма/СтрокаТовары.Количество);		
			СтрокаТовары.СуммаФакт=СтрокаТовары.Цена*СтрокаТовары.КоличествоФакт;
					
		КонецЦикла;
	КонецЦикла;	
	
КонецПроцедуры

//Для отчета СКД
Функция ЭтоПроблемноеМЗ(МЗ) Экспорт
		
	ДокументОснование=МЗ.ЗаказПокупателя;
	
	Возврат Ложь
	
КонецФункции

Функция ПолучитьВес(ДокументОснование,ДатаДоставки)Экспорт
	
	ВесОбъем=Мегалогист.ПолучитьВесОбъем(ДокументОснование);
	Возврат ВесОбъем.Вес;
	
КонецФункции

Функция ПолучитьОбъем(ДокументОснование,ДатаДоставки)Экспорт
	
	ВесОбъем=Мегалогист.ПолучитьВесОбъем(ДокументОснование);
	Возврат ВесОбъем.Объем;
	
КонецФункции

Функция ПолучитьВыручкуПоДоставке(МЗ,ДатаДоставки)Экспорт
	
	Если МЗ.Статус<>Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполнен тогда
		Возврат 0;
	КонецЕсли;
	
	ДокументОснование=МЗ.ЗаказПокупателя;
	
	Выручка=0;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.МегаЛогист_МаршрутноеЗадание") тогда
		Док=ДокументОснование.ДокументОснование;
	иначе
		Док=ДокументОснование;	
	КонецЕсли;
	
	Если Док=Неопределено тогда
		Возврат Выручка;
	КонецЕсли;
	
	Если Док.Метаданные().ТабличныеЧасти.Найти("Товары") <> Неопределено Тогда
		Для Каждого СтрокаТовара из Док.Товары цикл
			
			Если ТипЗнч(Док) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда
			ИначеЕсли ТипЗнч(Док) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				Если Док.Дата<>ДатаДоставки тогда
					Продолжить;
				КонецЕсли;	
			Иначе
				Продолжить;
			КонецЕсли;	
			
			Выручка=Выручка+СтрокаТовара.Сумма;			
		КонецЦикла;
	КонецЕсли;	
		
	Возврат Выручка;
	

КонецФункции	

Функция ЭтоСвоевременнаяДоставка(МЗ) Экспорт
		
	Если МЗ.ВремяДоставкиФакт>=МЗ.ВремяДоставкиС и МЗ.ВремяДоставкиФакт<=МЗ.ВремяДоставкиПо тогда
		Возврат 1;
	КонецЕсли;	
	
	Возврат 0;
	
КонецФункции

Функция ЭтоНеСвоевременнаяДоставка(МЗ) Экспорт
			
	Если МЗ.ВремяДоставкиФакт>=МЗ.ВремяДоставкиС и МЗ.ВремяДоставкиФакт<=МЗ.ВремяДоставкиПо тогда
		Возврат 0;
	КонецЕсли;	
	
	Возврат 1;
	
КонецФункции

Функция КоличествоТочекВРейсе(МЛ) Экспорт
	
	КоличествоТочекВРейсе=0;
	
	Для Каждого СтрокаМЛ из МЛ.МаршрутныеЗадания цикл
		КоличествоТочекВРейсе=КоличествоТочекВРейсе+1;
	КонецЦикла;	
	
	Возврат КоличествоТочекВРейсе
	
КонецФункции

Функция ПолучитьРасходТопливаНа100км(Транспорт) Экспорт
	
	РасходТопливаНа100км=0;
	
	Запрос=Новый Запрос();
	Запрос.УстановитьПараметр("Транспорт",Транспорт);
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	МегаЛогист_ХарактеристикиТранспортныхСредств.РасходТопливаНа100км
	             |ИЗ
	             |	Справочник.МегаЛогист_ХарактеристикиТранспортныхСредств КАК МегаЛогист_ХарактеристикиТранспортныхСредств
	             |ГДЕ
	             |	МегаЛогист_ХарактеристикиТранспортныхСредств.ТранспортноеСредство = &Транспорт";
	Результат=Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() тогда
		РасходТопливаНа100км=Результат.РасходТопливаНа100км;
	КонецЕсли;
	
	Возврат РасходТопливаНа100км;
	
КонецФункции
