﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьТаблицуПартий(ЭтаФорма.ВладелецФормы.Объект);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Поставщик = Параметры.Поставщик;
КонецПроцедуры

&НаСервере
Процедура ПоставщикПриИзмененииНаСервере(Пар)
	ЗаполнитьТаблицуПартий(Пар);
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	ЗаполнитьТаблицуПартий(ЭтаФорма.ВладелецФормы.Объект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПартий(Знач АРВДанныеФормы)
	
	лКлючАлгоритма = "Документ_АктРассмотренияВозврата_ФормаПодбораПартии_ЗаполнитьТаблицуПартий";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	ТаблицаПартий.Очистить();
	
	ДокОбъект = ДанныеФормыВЗначение(АРВДанныеФормы, Тип("ДокументОбъект.АктРассмотренияВозврата")); 
	СтруктураОстатков = ДокОбъект.ОстаткиПартийПоРазмещениям();
	Если СтруктураОстатков.ОстаткиПартий.Итог("Количество") = 0 Тогда
		СтруктураОстатков = ДокОбъект.ОстаткиПартийПоРТУ(); 
	КонецЕсли;
		
	//Отбор по поставщику
	Если ЗначениеЗаполнено(Поставщик) Тогда
		ОстаткиПартий = СтруктураОстатков.ОстаткиПартий.Скопировать(Новый Структура("Поставщик", Поставщик));
	Иначе
		ОстаткиПартий = СтруктураОстатков.ОстаткиПартий;
	КонецЕсли;
		
	Для Каждого Стр Из ОстаткиПартий Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаПартий.Добавить(), Стр)
	КонецЦикла;	

КонецПроцедуры


&НаСервере
Процедура ТаблицаПартийВыборНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПартийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТаблицаПартийВыборНаСервере();
	
	ПараметрЗакрытия = Неопределено;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		СтрокаТЧ = ТаблицаПартий.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПараметрЗакрытия = Новый Структура("СтрокаПрихода, ЦенаСебестоимости", СтрокаТЧ.СтрокаПрихода, СтрокаТЧ.ЦенаСебестоимости);
	КонецЕсли;
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

