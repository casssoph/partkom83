﻿
//Калинин PK83-475 170518
//В идеале надо бы это переписать , чтобы все навигационные кнопки создавались ПриСозданииНаСервере, БСП-ми функциями, как в типовых. 
#Область КомандыНавигации
&НаКлиенте
Процедура СтруктураПодчинености(Команда)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		//РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Элементы.Список.ТекущаяСтрока));
		РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ДвиженияДокумента(Команда)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ОткрытьФорму("Отчет.ОтчетПоДвижениямДокумента.Форма", Новый Структура("Документ,СпособВыводаОтчета", Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Элементы.Список.ТекущаяСтрока), "ПоВертикали"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияДокумента(Команда)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ФормаСравненияКорректировок = Обработки.ИсторияДокумента.ПолучитьФорму("ФормаСравненияКорректировок");
		ФормаСравненияКорректировок.Документ = Элементы.Список.ТекущаяСтрока;
		ФормаСравненияКорректировок.ТолькоИзменения = Истина;
		ФормаСравненияКорректировок.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНомеру(Команда)
	
	Номер = "";
	Если Не ВвестиЗначение(Номер, "Введите номер заявки", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(11, ДопустимаяДлина.Фиксированная))) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрДлина(Номер) < 11 Тогда 
		Предупреждение("Введите 11-значный номер", 5);
		Возврат;
	КонецЕсли;
	
	ИскомыйЭлементОтбора = Неопределено;
	
	Для Каждого ЭлтОтбора Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл 
		Если ТипЗнч(ЭлтОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлтОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номер") Тогда
			ИскомыйЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлтОтбора.ИдентификаторПользовательскойНастройки);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ИскомыйЭлементОтбора = Неопределено Тогда 
		ИскомыйЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИскомыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номер");
	КонецЕсли;
	
	ИскомыйЭлементОтбора.ПравоеЗначение = Номер;
	ИскомыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ИскомыйЭлементОтбора.Использование = Истина;

КонецПроцедуры




#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
КонецПроцедуры
