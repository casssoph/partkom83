﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	
	
	ВыполнитьАлгоритмПриОткрытииНаСервере();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры


&НаСервере
Процедура ВыполнитьАлгоритмПриОткрытииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыДокументовТаблицаАлгоритмов.Алгоритм,
		|	СтатусыДокументовТаблицаАлгоритмов.Алгоритм.Код КАК Код,
		|	СтатусыДокументовТаблицаАлгоритмов.Алгоритм.Наименование КАК Наименование,
		|	СтатусыДокументовТаблицаАлгоритмов.Алгоритм.Алгоритм КАК ТекстАлгоритма
		|ИЗ
		|	Справочник.СтатусыДокументов.ТаблицаАлгоритмов КАК СтатусыДокументовТаблицаАлгоритмов
		|ГДЕ
		|	СтатусыДокументовТаблицаАлгоритмов.Ссылка = &Ссылка
		|	И СтатусыДокументовТаблицаАлгоритмов.МоментВыполненияАлгоритма = &МоментВыполненияАлгоритма
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатусыДокументовТаблицаАлгоритмов.НомерСтроки";
	
	Запрос.УстановитьПараметр("МоментВыполненияАлгоритма", 	Перечисления.МоментыВыполненияАлгоритма.ПриОткрытииФормыДокумента);
	Запрос.УстановитьПараметр("Ссылка", 					Объект.СтатусДокумента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			Выполнить(Выборка.ТекстАлгоритма);
		Исключение
			ТекстОшибки = "Ошибка при выполнении алгоритма """+Выборка.Наименование+" ("+Выборка.Код+")""!";
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Важное);
			ЗаписьЖурналаРегистрации("Открытие формы Акта возврата",УровеньЖурналаРегистрации.Ошибка,,Объект.Ссылка,ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	ВозвратыОтПокупателяКлиентСервер.ЗаполнитьКомандыНаФорме( ЭтаФорма, Объект.СтатусДокумента, Истина );
	
	
КонецПроцедуры


//КОМАНДЫ ПРОЦЕССА {

&НаКлиенте
Процедура ВыполнитьКоманду(Команда)
	
	ВозвратыОтПокупателяКлиентСервер.ВыполнитьКоманду( ЭтаФорма, Команда );
	
КонецПроцедуры


&НаСервере
Функция ВыполнитьКомандуПроцесса( пКоманда ) Экспорт
	
	Возврат ВозвратыОтПокупателяСервер.ВыполнитьКомандуДляЗадачиВТранзакции(пКоманда, ЭтаФорма);
	
КонецФункции	//ВыполнитьКоманду

  