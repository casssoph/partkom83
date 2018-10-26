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
	
	ПересчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПересчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти);
	
	РассчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПересчитатьЦенуПоСуммеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦенуПоСуммеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.Цена = ?(СтрокаТабличнойЧасти.Количество = 0, 0,  СтрокаТабличнойЧасти.Сумма/СтрокаТабличнойЧасти.Количество);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти) Экспорт
	
	СтрокаТабличнойЧасти.СуммаНДС = РассчитатьСуммуНДСТабЧастиСервер(СтрокаТабличнойЧасти.Сумма,
	Объект.УчитыватьНДС, Объект.СуммаВключаетНДС,
	СтрокаТабличнойЧасти.СтавкаНДС);
	
КонецПроцедуры // РассчитатьСуммуНДСТабЧасти()

&НаСервереБезКонтекста
Функция РассчитатьСуммуНДСТабЧастиСервер(Сумма, УчитыватьНДС, СуммаВключаетНДС, СтавкаНДС) Экспорт
	
	Возврат УчетНДС.РассчитатьСуммуНДС(Сумма,
	УчитыватьНДС, СуммаВключаетНДС,
	УчетНДС.ПолучитьСтавкуНДС(СтавкаНДС));
	
КонецФункции 

&НаКлиенте
Процедура РассчитатьИтоги() Экспорт
	
	СуммаВсего = ПолучитьСуммуСНДС();
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьВнешнийВидФормы();
	ВыполнитьАлгоритмПриОткрытииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокЭП.Параметры.УстановитьЗначениеПараметра("ОснованиеПисьма", Объект.Ссылка);
	СобытияАктовРассмотренияВозврата.Параметры.УстановитьЗначениеПараметра("АктРассмотренияВозврата", Объект.Ссылка);
	
	РеквизитыДляКонтроляИсторииИзменения = Документы.АктРассмотренияВозврата.ИменаРеквизитовДляКонтроляИстории();
	
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
	
	ТолькоПросмотр = НЕ Справочники.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.СтатусДоступенТекущемуПользователю(Объект.СтатусДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыПроцесса

&НаКлиенте
Процедура ВыполнитьКоманду(Команда)
	
	Если СохранитьВИсториюИзменения Тогда
		Записать();
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

#КонецОбласти


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
Процедура ПересчитатьСтрокиТабличнойЧастиПриИзмененииНДС()
	
	Для каждого СтрокаТабличнойЧасти ИЗ Объект.Товары Цикл
		РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РассчитатьИтоги();
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
Процедура УстановитьРучноеИзменениеРеквизита(ИмяРеквизита)
	
	Если РеквизитыДляКонтроляИсторииИзменения.НайтиПоЗначению(ИмяРеквизита) <> Неопределено Тогда
		СохранитьВИсториюИзменения = Истина; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры







  