﻿
&НаКлиенте
Процедура МоиАкты(Команда)
	УстановитьОтборПоОтветственному(ПараметрыСеанса.ТекущийПользователь);
КонецПроцедуры

&НаКлиенте
Процедура АктыБезОтветственного(Команда)
	УстановитьОтборПоОтветственному()
КонецПроцедуры

&НаКлиенте
Процедура АктыМоейГруппы(Команда)
	УстановитьОтборПоОтветственному(ПараметрыСеанса.ТекущийПользователь.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя)
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоОтветственному(ПользовательОтбора = Неопределено)
	
	УстановитьОтборСписка(АктыРассмотренияВозврата.КомпоновщикНастроек, "Ответственный", ПользовательОтбора, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСписка(пКомпоновщикНастроек, ИмяПоля, ЗначениеПоля = Неопределено, ВидСравнения = Неопределено, Использование = Истина)

	ЭлОтбора = НайтиЭлементОтбора(пКомпоновщикНастроек.Настройки.Отбор.Элементы, ИмяПоля);
	
	ЭлОтбора.ПравоеЗначение = ЗначениеПоля;
	ЭлОтбора.Использование = Использование;
	ЭлОтбора.ВидСравнения = ВидСравнения;
	
	Для каждого ЭлементОтбора Из пКомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если Строка(ЭлементОтбора.ИдентификаторПользовательскойНастройки) = ЭлОтбора.ИдентификаторПользовательскойНастройки Тогда
			ЭлементОтбора.ПравоеЗначение = ЭлОтбора.ПравоеЗначение;
			ЭлементОтбора.Использование = ЭлОтбора.Использование;
			ЭлементОтбора.ВидСравнения = ЭлОтбора.ВидСравнения;
		КонецЕсли;
	КонецЦикла;             
	
КонецПроцедуры

&НаКлиенте
Функция НайтиЭлементОтбора(КоллекцияЭлементов, ИмяЭлемента)
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если Строка(ЭлементОтбора.ЛевоеЗначение) = ИмяЭлемента Тогда
			ВозвращаемоеЗначение = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции


&НаСервере
Процедура АктыРассмотренияВозвратаПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//
	//Элементы.АктыРассмотренияВозврата.СоздатьЭлементыФормыПользовательскихНастроек(Элементы.КомпоновщикНастроекПользовательскиеНастройки, , 2);
	//УстановитьВидимостьНастроек(Элементы.КомпоновщикНастроекПользовательскиеНастройки);
	
КонецПроцедуры

//Для вывода вида сравнения у пользовательских настроек
&НаСервере
Процедура УстановитьВидимостьНастроек(ГруппаНастроек)
	
    МассивКлонируемыхЭлементов = Новый Массив;
    Для каждого ПодчиненныйЭлемент Из ГруппаНастроек.ПодчиненныеЭлементы Цикл
        Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
            УстановитьВидимостьНастроек(ПодчиненныйЭлемент);
        Иначе
            Если СтрНайти(ПодчиненныйЭлемент.Имя, "ВидСравнения") <> 0 Тогда
                МассивКлонируемыхЭлементов.Добавить(ПодчиненныйЭлемент);
            КонецЕсли;
        КонецЕсли;
	КонецЦикла;
	
    Для каждого КлонируемыйЭлемент Из МассивКлонируемыхЭлементов Цикл
        Клон = ЭтаФорма.Элементы.Вставить(КлонируемыйЭлемент.Имя + "Клон", ТипЗнч(КлонируемыйЭлемент), КлонируемыйЭлемент.Родитель, КлонируемыйЭлемент);
        ЗаполнитьЗначенияСвойств(Клон, КлонируемыйЭлемент, "Вид, ПоложениеЗаголовка, РастягиватьПоГоризонтали, ПутьКДанным");
        КлонируемыйЭлемент.Видимость = Ложь;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	Элементы.АктыРассмотренияВозврата.Обновить();
КонецПроцедуры


&НаСервереБезКонтекста
Процедура АктыРассмотренияВозвратаПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаСервере
Процедура ВнешнееСобытиеНаСервере()
	//Вставить содержимое обработчика
КонецПроцедуры


&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	
	Если Лев(Данные, 5) = "pkdvp" Тогда
		
		Док = ШтрихкодированиеДокументов.НайтиДокументПоШтрихкодуНомеруПериод(Данные,Ложь,Ложь);
		Если ЗначениеЗаполнено(Док) И ТипЗнч(Док) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
			ВозвратыОтПокупателяСервер.ОтразитьВозвратПечатныхДокументов(Док, Истина, ПредопределенноеЗначение("Перечисление.ВидыПечатныхДокументов.УКД"));
			ОткрытьЗначение(Док);
		Иначе
			Сообщить("Не найден документ со штрихкодом "+Данные);
		КонецЕсли;
	КонецЕсли;

	
	ВнешнееСобытиеНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Порт=1;
	Попытка
		ПодключитьВнешнююКомпоненту("AddIn.vk_rs232");
		мСканер = Новый("AddIn.vk_rs232");
		мСканер.ОткрытьПорт("COM"+Строка(Порт));
		мСканер.КонецСтроки = Символ(13);
	Исключение
		Сообщить("Не удалось подключить сканер штрихкода: "+ОписаниеОшибки());
	КонецПопытки;	

КонецПроцедуры

