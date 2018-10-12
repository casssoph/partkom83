﻿
&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	
	СхемаКомпоновкиДанных = Обработки.СписаниеЗависшихРезервов.ПолучитьМакет("МакетКомпоновки");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщикНастроек();
	ВосстановитьНастройки();
	
	УстановитьПараметрЗапросаДвиженияРезервов(Неопределено);

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрЗапросаДвиженияРезервов(СтрокаЗаявки)
	
	  ДвижениеРезервов.Параметры.УстановитьЗначениеПараметра("СтрокаЗаявки", СтрокаЗаявки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений") , Ложь, );
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
	ТаблицаРезультата = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Объект.Резервы.Загрузить(ТаблицаРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройки();

КонецПроцедуры

#Область ПроцедурыРаботыСНастройкамиПользователя
&НаКлиенте
Процедура СохранитьНастройки()
	
	Настройки = Новый Структура();
	Настройки.Вставить("ПользовательскиеНастройки", КомпоновщикНастроек.ПользовательскиеНастройки);

	СохранитьНастройкиНаСервере(Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(Настройки)
	
	КлючОбъекта = "Обработка.СписаниеЗависшихРезервов";
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, "Настройки", Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.СписаниеЗависшихРезервов", "Настройки");
	
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		
		КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ЗначениеНастроек.ПользовательскиеНастройки);
		
		ЗаполнитьЗначенияСвойств(Объект, ЗначениеНастроек);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ЗначениеНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	ИспользоватьАвтомат = ИспользоватьАвтомат(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	СохраненнаяНастройка = Новый Структура;
	СохраненнаяНастройка.Вставить("КомпоновщикНастроекНастройки", 					КомпоновщикНастроек.Настройки);
	СохраненнаяНастройка.Вставить("КомпоновщикНастроекПользовательскиеНастройки", 	КомпоновщикНастроек.ПользовательскиеНастройки);
	СохраненнаяНастройка.Вставить("КомпоновщикНастроекФиксированныеНастройки", 		КомпоновщикНастроек.ФиксированныеНастройки);
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	СтруктураНастройки.Вставить("ИмяОбъекта", "ОбработкаСписаниеЗависшихРезервов");
	СтруктураНастройки.Вставить("НаименованиеНастройки", "Основная" + ?(ИспользоватьАвтомат, " (авто)", ""));
	СтруктураНастройки.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);
	СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", Ложь);
	СтруктураНастройки.Вставить("СохранятьАвтоматически",  Ложь);

	Результат = УниверсальныеМеханизмы.СохранениеНастроек(СтруктураНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНастройку(Команда)

	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	СтруктураНастройки.Вставить("ИмяОбъекта", "ОбработкаСписаниеЗависшихРезервов");
	СтруктураНастройки.Вставить("НаименованиеНастройки", "Основная");
	
	Результат = УниверсальныеМеханизмы.ВосстановлениеНастроек(СтруктураНастройки);
	Если Результат <> Неопределено Тогда
		
		КомпоновщикНастроекПользовательскиеНастройки = Неопределено;
		Если Результат.СохраненнаяНастройка.Свойство("КомпоновщикНастроекПользовательскиеНастройки", КомпоновщикНастроекПользовательскиеНастройки) Тогда
			Если Не КомпоновщикНастроекПользовательскиеНастройки = Неопределено Тогда
				КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроекПользовательскиеНастройки)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры


#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Объект.Резервы Цикл
		СтрокаТаблицы.Выбрать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ПереключитьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьФлажки(Устанавливать)
	
	Если Элементы.Резервы.ВыделенныеСтроки.Количество() > 1 Тогда
		
		Для Каждого ВыделеннаяСтрока Из Элементы.Резервы.ВыделенныеСтроки Цикл
			СтрокаТаблицы = Объект.Резервы.НайтиПоИдентификатору(ВыделеннаяСтрока);
			СтрокаТаблицы.Выбрать = Устанавливать;
		КонецЦикла;
		
	Иначе
		
		Для Каждого СтрокаТаблицы Из Объект.Резервы Цикл
			СтрокаТаблицы.Выбрать = Устанавливать;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезервыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Резервы.ВыделенныеСтроки.Количество() = 1 Тогда
		СтрокаЗаявки = Объект.Резервы.НайтиПоИдентификатору(Элементы.Резервы.ВыделенныеСтроки[0]).СтрокаЗаявки;
	Иначе
		СтрокаЗаявки = Неопределено;
	КонецЕсли;
	
	ДвижениеРезервов.Параметры.УстановитьЗначениеПараметра("СтрокаЗаявки", СтрокаЗаявки);
	
КонецПроцедуры

&НаСервере
Функция ИспользоватьАвтомат(Знач вхПользовательскиеНастройки) Экспорт
	
	Возврат Обработки.СписаниеЗависшихРезервов.ИспользоватьАвтомат(вхПользовательскиеНастройки);
	
КонецФункции

#КонецОбласти

#Область НеИспользуется

&НаСервере
Процедура ЗакрытьЗаявкуНаСервере()
	
	ТаблицаЗаявок = Объект.Резервы.Выгрузить(Новый структура("Выбрать", Истина), "Заявка");
	ТаблицаЗаявок.Свернуть("Заявка");
	Если ТаблицаЗаявок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Документы.ЗакрытиеЗаявокПокупателя.СоздатьДокумент();
	Для каждого СтрокаТЗ Из ТаблицаЗаявок Цикл
		Документ.Заявки.Добавить().Документ = СтрокаТЗ.Заявка;
	КонецЦикла;
	Документ.Дата = ТекущаяДата();
	Документ.Ответственный = ПолныеПрава.ТекущийПользователь();
	Документ.Организация = Константы.ОрганизацияПоУмолчаниюБезнал.Получить();
	Документ.Комментарий = "Списание зависших резервов";
	Попытка
		Документ.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Заявки закрыты документом "+Документ);
		ОбновитьНаСервере();
	Исключение
		Сообщить("Не удалось закрыть заявки, ошибка: "+ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЗаявку(Команда)
	
	ЗакрытьЗаявкуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СписатьРезерв

&НаСервере
Процедура СписатьРезервНаСервере()
	
	ТаблицаСтрок = Объект.Резервы.Выгрузить(Новый структура("Выбрать", Истина), "Заявка, СтрокаЗаявки, ВРезерве");
	ТаблицаСтрок.Свернуть("Заявка, СтрокаЗаявки", "ВРезерве");
	
	ТаблицаЗаявок = ТаблицаСтрок.Скопировать(,"Заявка");
	ТаблицаЗаявок.Свернуть("Заявка");
	
	Для каждого СтрокаТЗ Из ТаблицаЗаявок Цикл
		Обработки.СписаниеЗависшихРезервов.ЗакрытьРезервПоЗаявке(СтрокаТЗ.Заявка, ТаблицаСтрок.Скопировать(Новый структура("Заявка", СтрокаТЗ.Заявка), "СтрокаЗаявки, ВРезерве"));
	КонецЦикла;
	
	Сообщить("Обработано заявок: "+ТаблицаЗаявок.Количество());
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписатьРезерв(Команда)
	СписатьРезервНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОтправитьПоЭлектроннойПочте

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ТабличныйДокументДляОтправки = ТабличныйДокументДляОтправки();
	
	УправлениеОтчетами.ОтправитьДокументПоЭлектроннойПочте(ТабличныйДокументДляОтправки, "Зависшие резервы", "");

КонецПроцедуры

Функция ТабличныйДокументДляОтправки()
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), , , , Ложь, );
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент();
	ТабличныйДокументДляОтправки = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат ТабличныйДокументДляОтправки;
	
КонецФункции

#КонецОбласти

#Область АвтоЗакрытие

&НаСервере
Процедура  ВыполнитьАвтоЗакрытие()
	
	ОБработки.СписаниеЗависшихРезервов.ВыполнитьАвтоЗакрытие();
	
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	ВыполнитьАвтоЗакрытие()
	
КонецПроцедуры

#КонецОбласти

