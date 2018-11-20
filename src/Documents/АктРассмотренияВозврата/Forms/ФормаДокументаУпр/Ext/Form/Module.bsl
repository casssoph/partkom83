﻿#Область ОбработчикиСтрокТабличнойЧасти

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииНаСервере(Идентификатор)
	
	ПриИзмененииНоменклатурыНаСервере(Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТоварыНоменклатураПриИзмененииНаСервере(Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатурыНаСервере(Идентификатор)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(Идентификатор);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяСтрока.Номенклатура, "ЕдиницаХраненияОстатков, ЕдиницаХраненияОстатков.Коэффициент, СтавкаНДС");
	
	ТекущаяСтрока.СтавкаНДС 		= Реквизиты.СтавкаНДС;
	ТекущаяСтрока.ЕдиницаИзмерения 	= Реквизиты.ЕдиницаХраненияОстатков;
	ТекущаяСтрока.Коэффициент 		= Реквизиты.ЕдиницаХраненияОстатковКоэффициент;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("ПересчитатьСебестоимость");
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 

	РассчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПослеУценки");
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	
	РассчитатьИтоги();
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПересчитатьЦенуПоСуммеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПослеУценки");
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	
	РассчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦенуПоСуммеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.Цена = ?(СтрокаТабличнойЧасти.Количество = 0, 0,  СтрокаТабличнойЧасти.Сумма/СтрокаТабличнойЧасти.Количество);
	
КонецПроцедуры


&НаКлиенте
Процедура РассчитатьИтоги() Экспорт
	
	СуммаВсего = ПолучитьСуммуСНДС();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПересчитатьСтрокиТабличнойЧастиПриИзмененииНДС()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	Для каждого СтрокаТабличнойЧасти ИЗ Объект.Товары Цикл
		ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПроцентУценкиПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПослеУценки");
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиЭлементовФормы


&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОрганизации()
	
	Объект.УчитыватьНДС 		= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "УчитыватьНДС");
	Объект.СуммаВключаетНДС 	= Объект.УчитыватьНДС;
	
	ПересчитатьСтрокиТабличнойЧастиПриИзмененииНДС();
	
	НастроитьВнешнийВидФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура КодВозвратаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СтатусПроверкиДокументовПоставщикаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СтатусПроверкиДокументовПокупателяПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Функция ЗаполнитьПартииВТабличнойЧасти(СообщатьОбОшибке = Истина, ТекстОшибки = "", ВызыватьИсключение = Истина) Экспорт
	
	ЗаполнитьПартииВТабличнойЧастиНаСервере(СообщатьОбОшибке, ТекстОшибки, ВызыватьИсключение);
	
КонецФункции

&НаСервере
Функция ЗаполнитьПартииВТабличнойЧастиНаСервере(СообщатьОбОшибке = Истина, ТекстОшибки = "", ВызыватьИсключение = Истина) Экспорт
	
	 ДокОбъект = РеквизитФормыВЗначение("Объект");
	 ДокОбъект.ЗаполнитьПартииВТабличнойЧасти();
	 ДокОбъект.ЗаполнитьЦеныПоДокументуРеализации();
	 ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	
КонецФункции

&НаКлиенте
Процедура ПодборДокументаПродажи(Команда)
	
	НоменклатураОтбор = Неопределено;
	Если Объект.Товары.Количество()> 0 Тогда
		НоменклатураОтбор = Объект.Товары[0].Номенклатура;
	КонецЕсли;
	
	ОО = Новый ОписаниеОповещения("ПослеВыбораДокументаПродажи", ЭтаФорма);
	
	ПараметрыПодбора = Новый Структура("Контрагент, Номенклатура", Объект.Контрагент, НоменклатураОтбор);
	ОткрытьФорму("Документ.АктРассмотренияВозврата.Форма.ФормаПодбораДокументаПродажи", ПараметрыПодбора, Элементы.Товары,,,,ОО);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораДокументаПродажи(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		Объект.ДокументПродажи = РезультатЗакрытия;		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Не ЗначениеЗаполнено(Объект.СтатусДокумента) Тогда
			Объект.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_Новый;
		КонецЕсли;
		
		ПриЧтенииСозданииНаСервере();

	КонецЕсли;
	
	
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	НастроитьВнешнийВидФормы();
	ВыполнитьАлгоритмПриОткрытииНаСервере();
	
	СписокЭП.Параметры.УстановитьЗначениеПараметра("ОснованиеПисьма", Объект.Ссылка);
	СобытияАктовРассмотренияВозврата.Параметры.УстановитьЗначениеПараметра("АктРассмотренияВозврата", Объект.Ссылка);
	
	РеквизитыДляКонтроляИсторииИзменения = Документы.АктРассмотренияВозврата.ИменаРеквизитовДляКонтроляИстории();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РассчитатьИтоги();
КонецПроцедуры

#КонецОбласти

#Область Прочее

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
			ТекстОшибки = "Ошибка при выполнении алгоритма """+Выборка.Наименование+" ("+Выборка.Код+")""! "+ОписаниеОшибки();
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Важное);
			ЗаписьЖурналаРегистрации("Открытие формы Акта возврата",УровеньЖурналаРегистрации.Ошибка,,Объект.Ссылка,ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСуммуСНДС() Экспорт
	
	Сумма = Объект.Товары.Итог("Сумма");
	
	Если Объект.УчитыватьНДС И Не Объект.СуммаВключаетНДС Тогда
		
		Сумма = Сумма + Объект.Товары.Итог("СуммаНДС");
		
	КонецЕсли;
	
	Возврат Сумма;

КонецФункции // ПолучитьСуммуСНДС()

&НаКлиенте
Функция ПолучитьСуммуНДС() Экспорт

	Если Объект.УчитыватьНДС Тогда
		
		Возврат Объект.Товары.Итог("СуммаНДС");
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;

КонецФункции // ПолучитьСуммуНДС()

&НаКлиенте
Процедура УстановитьРучноеИзменениеРеквизита(ИмяРеквизита)
	
	Если РеквизитыДляКонтроляИсторииИзменения.НайтиПоЗначению(ИмяРеквизита) <> Неопределено Тогда
		СохранитьВИсториюИзменения = Истина; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкаВнешнегоВидаФормы

&НаСервере
Процедура НастроитьВнешнийВидФормы() 
	
	ВозвратыОтПокупателяСервер.ЗаполнитьКомандыНаФорме(ЭтаФорма, Объект.СтатусДокумента, Истина );
	
	УстановитьДоступностьФормы();
	
	Элементы.ТоварыСтавкаНДС.Видимость 	= Объект.УчитыватьНДС;
	Элементы.ТоварыСуммаНДС.Видимость 	= Объект.УчитыватьНДС;

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьФормы() 
	
	Если ЗначениеЗаполнено(Объект.СтатусДокумента) Тогда
		ТолькоПросмотр = НЕ Справочники.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.СтатусДоступенТекущемуПользователю(Объект.СтатусДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандыПроцесса

&НаКлиенте
Процедура ВыполнитьКоманду(Команда)
	
	Если СохранитьВИсториюИзменения Тогда
		Записать(?(Объект.Проведен, 
					РежимЗаписиДокумента.Проведение, 
					РежимЗаписиДокумента.Запись));
	КонецЕсли;
	
	ВозвратыОтПокупателяКлиент.ВыполнитьКоманду( ЭтаФорма, Команда );
	ЭтаФорма.ОбновитьОтображениеДанных();
	НастроитьВнешнийВидФормы();
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьКомандуПроцесса( пКоманда ) Экспорт
	
	Возврат ВозвратыОтПокупателяСервер.ВыполнитьКомандуДляАРВВТранзакции(пКоманда, ЭтаФорма);
	
КонецФункции	//ВыполнитьКоманду

&НаКлиенте
Процедура СтатусДокументаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если СохранитьВИсториюИзменения Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "РучноеИзменениеРеквизита");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмоНаСервере()
	ВозвратыОтПокупателяСервер.СоздатьЭлектронноеПисьмоНаОсновании(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмо(Команда)
	СоздатьЭлектронноеПисьмоНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПартииПоДокументуПродажи(Команда)
	ТекстОшибки = "";
	ЗаполнитьПартииВТабличнойЧастиНаСервере(Истина, ТекстОшибки, Ложь);
	РассчитатьИтоги();
КонецПроцедуры

#КонецОбласти





  