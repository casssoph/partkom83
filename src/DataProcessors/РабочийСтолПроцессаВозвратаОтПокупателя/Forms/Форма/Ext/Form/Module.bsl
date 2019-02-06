﻿&НаКлиенте
Перем мСканер;

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
		//Возврат от покупателя
		
		ЭтотГод = ПериодПоискаВозвратовПоШтрихкодуУКД = "ТекущийГод";
		
		Док = ШтрихкодированиеДокументов.НайтиДокументПоШтрихкодуНомеруПериод(Данные,Ложь,ЭтотГод);
		Если ЗначениеЗаполнено(Док) И ТипЗнч(Док) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
			
			ВидПД = ПредопределенноеЗначение("Перечисление.ВидыПечатныхДокументов.УКД");
			
			Попытка
				ВозвратыОтПокупателяСервер.ОтразитьВозвратПечатныхДокументов(Док, Истина, ВидПД);
			Исключение
				Сообщить("Не удалось установить пометку о получении документа: "+ОписаниеОшибки(), СтатусСообщения.Важное);
			КонецПопытки;
			
			ДатыВозвратаДокументов = РегистрыСведений.ДатыВозвратаДокументов.ДанныеДокумента(Док, ВидПД);
			Если ДатыВозвратаДокументов.Документ = Неопределено Тогда
				Сообщить(""+Док+": отметка о получении документов не установлена");
				ОткрытьЗначение(Док);
			Иначе
				Сообщить(""+Док+": получен "+ДатыВозвратаДокументов.ДатаВозврата+", "+ДатыВозвратаДокументов.Пользователь);
				//ОткрытьЗначение(Док);
			КонецЕсли;
			
		Иначе
			Сообщить("Не найден документ ""Возврат товаров от покупателя"" по штрихкоду "+Данные);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Данные) Тогда
		//Пробуем найти АРВ
		АРВ = Документы.АктРассмотренияВозврата.НайтиПоРеквизиту("Штрихкод", Данные);
		Если ЗначениеЗаполнено(АРВ) Тогда
			ОткрытьЗначение(АРВ);
		Иначе
			Сообщить("Не найден акт возврата по штрихкоду """+Данные+""""); 			
		КонецЕсли;
		
	КонецЕсли;

	ВнешнееСобытиеНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключать = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),
	"ИспользоватьСканерШтрихкода");
	
	Если Подключать Тогда
		Порт=1;
		Попытка
			ПодключитьВнешнююКомпоненту("AddIn.vk_rs232");
			мСканер = Новый("AddIn.vk_rs232");
			мСканер.ОткрытьПорт("COM"+Строка(Порт));
			мСканер.КонецСтроки = Символ(13);
		Исключение
			Сообщить("Не удалось подключить сканер штрихкода: "+ОписаниеОшибки());
		КонецПопытки;	
		
	КонецЕсли;
	
	Элементы.ПериодПоискаВозвратовПоШтрихкодуУКД.Видимость = Подключать;
	ПериодПоискаВозвратовПоШтрихкодуУКД = Элементы.ПериодПоискаВозвратовПоШтрихкодуУКД.СписокВыбора[0].Значение;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии()
	
	Если (мСканер <> Неопределено) тогда
		Попытка
			мСканер.ЗакрытьПорт();	
		Исключение
		КонецПопытки;	
	КонецЕсли;
	мСканер = Неопределено;

КонецПроцедуры


&НаКлиенте
Процедура ПечатьУКД(Команда)
	ОткрытьФорму("Обработка.МассоваяПечатьУКД.Форма.Форма");
КонецПроцедуры

