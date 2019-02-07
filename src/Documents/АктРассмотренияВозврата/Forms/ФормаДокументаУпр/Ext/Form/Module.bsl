﻿&НаКлиенте 
Перем ЗакрытиеРазрешено;

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры
#Область ОбработчикиСтрокТабличнойЧасти

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
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("ПересчитатьСебестоимость",  ?(СтрокаТабличнойЧасти.Количество > 0, "Количество", "КоличествоПлан"));
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 

	РассчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПланПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("ПересчитатьСебестоимость",  ?(СтрокаТабличнойЧасти.Количество > 0, "Количество", "КоличествоПлан"));
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
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
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
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	
	РассчитатьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦенуПоСуммеСтрокиТабличнойЧасти(СтрокаТабличнойЧасти)
	
	СтрокаТабличнойЧасти.Цена = ?(СтрокаТабличнойЧасти.Количество = 0, 0,  СтрокаТабличнойЧасти.Сумма/СтрокаТабличнойЧасти.Количество);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьИтоги() Экспорт
	
	СуммаВсего 		= ПолучитьСуммуСНДС("Сумма");
	СуммаВсегоПлан 	= ПолучитьСуммуСНДС("СуммаПлан");
	
КонецПроцедуры 

&НаКлиенте
Процедура ПересчитатьСтрокиТабличнойЧастиПриИзмененииНДС()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	Для каждого СтрокаТабличнойЧасти ИЗ Объект.Товары Цикл
		СтрокаТабличнойЧасти.СтавкаНДС = ?(Объект.УчитыватьНДС, СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС, Перечисления.СтавкиНДС.БезНДС);
		ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПроцентУценкиПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииПроцентаСуммыУценки(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаУценкиПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииПроцентаСуммыУценки(СтрокаТабличнойЧасти);
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОрганизации()
	
	Объект.УчитыватьНДС 		= УчитыватьНДСНаСервереБезКонтекста(Объект.Организация, Объект.ДоговорКонтрагента);
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

&НаСервереБезКонтекста
Функция УчитыватьНДСНаСервереБезКонтекста(Организация, ДоговорКонтрагента)
	
	ВариантУчетаНДС = УчетНДСПовтИсп.ВариантУчетаНДСОрганизации(Организация);
	
	УчитыватьНДС = УчетНДСПовтИсп.УчитыватьНДСПоВариантуУчета(ВариантУчетаНДС, ДоговорКонтрагента.ВидОплаты); 
	
	Возврат УчитыватьНДС;
	
КонецФункции

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
	 ДокОбъект.ПроверитьЗаполнитьПартииВТабличнойЧасти();
	 ДокОбъект.ЗаполнитьСтрокиЗаявкиПоДокументуПродажи();
	 ДокОбъект.ЗаполнитьЦеныПоДокументуРеализации();
	 ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	
КонецФункции

&НаКлиенте
Процедура ПодборДокументаПродажи(Команда)
	
	НоменклатураОтбор = Неопределено;
	Если Объект.Товары.Количество()> 0 Тогда
		НоменклатураОтбор = Объект.Товары[0].Номенклатура;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НоменклатураОтбор) Тогда
		Сообщить("Не выбрана номенклатура!");
		Возврат;
	КонецЕсли;
	
	ОО = Новый ОписаниеОповещения("ПослеВыбораДокументаПродажи", ЭтаФорма);
	
	ПараметрыПодбора = Новый Структура("Контрагент, Номенклатура, ДатаОснования", Объект.Контрагент, НоменклатураОтбор, Объект.Дата);
	ОткрытьФорму("Документ.АктРассмотренияВозврата.Форма.ФормаПодбораДокументаПродажи", ПараметрыПодбора, Элементы.Товары,,,,ОО);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораДокументаПродажи(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		
		Объект.ДокументПродажи = РезультатЗакрытия;	
		ПриИзмененииДокументаПродажи();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПартииПоДокументуПродажи(Команда)
	ЗаполнитьПартииПоДокументуПродажиКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПартииПоДокументуПродажиКлиент()
	ТекстОшибки = "";
	ЗаполнитьПартииВТабличнойЧастиНаСервере(Истина, ТекстОшибки, Ложь);
	ЗаполнитьДопРеквизитыТЧТовары();
	РассчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ДокументПродажиПриИзменении(Элемент)
	
	ПриИзмененииДокументаПродажи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДокументаПродажи()
	
	Если ЗначениеЗаполнено(Объект.ДокументПродажи) Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументПродажи, "Организация, Контрагент, ДоговорКонтрагента, Контрагент.ОсновнойДоговорКонтрагента, Контрагент.ОсновнойДоговорКонтрагента.Организация");
		
		ОрганизацияЗакрыта = Справочники.Организации.ОрганизацияЗакрыта(Реквизиты.Организация, Объект.Дата);
		
		Если ОрганизацияЗакрыта Тогда
			Объект.Организация 			= Реквизиты.КонтрагентОсновнойДоговорКонтрагентаОрганизация;	
			Объект.Контрагент 			= Реквизиты.Контрагент;
			Объект.ДоговорКонтрагента 	= Реквизиты.КонтрагентОсновнойДоговорКонтрагента;
			Сообщить("Организация """+Реквизиты.Организация+""" закрыта. Организация заменена на организацию из действующего договора с клиентом.");
		Иначе
			Объект.Организация 			= Реквизиты.Организация;	
			Объект.Контрагент 			= Реквизиты.Контрагент;
			Объект.ДоговорКонтрагента 	= Реквизиты.ДоговорКонтрагента;
		КонецЕсли;
		
		ЗаполнитьПартииПоДокументуПродажиКлиент();
		
		УстановитьРучноеИзменениеРеквизита("ДокументПродажи");
		
		ПриИзмененииКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусДокументаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СрокВозвратаКлиентаПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры   

&НаКлиенте
Процедура ПричинаВозвратаПриИзменении(Элемент)
//	Элементы.ПричинаОтказаКлиента.Видимость = Объект.ПричинаВозврата = ПредопределенноеЗначение("Справочник.ПричиныВозврата.ОтказОтДетали");
КонецПроцедуры

&НаКлиенте
Процедура ПричинаВозвратаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Справочники.ПричиныВозврата.ПричиныВозвратаВерхнегоУровня();
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПричинаОтказаКлиентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ПричинаВозврата) Тогда
		ДанныеВыбора = Справочники.ПричиныВозврата.ПодчиненныеПричиныВозврата(Объект.ПричинаВозврата);
	КонецЕсли;
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтрокаПриходаПриИзменении(Элемент)
	
	ЗаполнитьДопРеквизитыТЧТовары();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДопРеквизитыТЧТовары()
	
	Для каждого СтрокаТЧ Из Объект.Товары Цикл
		СтрокаТЧ.Приход = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.СтрокаПрихода, "Приход");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВозвратаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Справочники.КодыВозврата.СписокВыбораКодовВозврата();
КонецПроцедуры

&НаКлиенте
Процедура КодВозвратаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Объект.КодВозврата = ВыбранноеЗначение;
		УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#Область Печать

&НаКлиенте
Процедура ПечатьТорг12Клиента(Команда)
	
	ВывестиТорг12Клиента();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиТорг12Клиента()
	
   ТабДок = Документы.АктРассмотренияВозврата.ПечатьТОРГ12(Объект.Ссылка);
   ТабДок.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСФКлиента(Команда)
	ВывестиСФКлиента();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСФКлиента()
	
   ТабДок = Документы.АктРассмотренияВозврата.ПечатьСчетаФактуры(Объект.Ссылка);
   ТабДок.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктаРассмотренияВозврата(Команда)
	ВывестиАктРассмотренияВозврата();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиАктРассмотренияВозврата()
	
   ТабДок = Документы.АктРассмотренияВозврата.ПечатьАктРассмотренияВозврата(Объект.Ссылка);
   ТабДок.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктаПриемаПередачи(Команда)
	ВывестиАктПриемаПередачи();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиАктПриемаПередачи()
	
   ТабДок = Документы.АктРассмотренияВозврата.ПечатьАктаПриемаПередачиВозврата(Объект.Ссылка);
   ТабДок.Показать();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СтруктураПодчиненности(Команда)
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияДокументаПоРегистрам(Команда)
	РаботаСДиалогами.НапечататьДвиженияДокумента(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмоНаСервере(Кому = "Покупатель")
	ВозвратыОтПокупателяСервер.СоздатьЭлектронноеПисьмоНаОсновании(Объект.Ссылка, Кому, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailДляВозвратов"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмо(Команда)
	СоздатьЭлектронноеПисьмоНаСервере("Покупатель");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлектронноеПисьмоПоставщику(Команда)
	СоздатьЭлектронноеПисьмоНаСервере("Поставщик");
КонецПроцедуры


&НаКлиенте
Процедура ВозвратТоваровОтПокупателяНадписьНажатие(Элемент)
	ОткрытьЗначение(ВозвратТоваровОтПокупателя);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПользователиГруппыДоступностиТекущегоПользователяНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка,
		|	Пользователи.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя = &ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя
		|	И НЕ Пользователи.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя = ЗНАЧЕНИЕ(Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	Запрос.УстановитьПараметр("ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыСеанса.ТекущийПользователь, "ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	СЗ = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СЗ.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат СЗ;	
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПользователяГруппыДоступности(Команда)
	
	СЗ = ПользователиГруппыДоступностиТекущегоПользователяНаСервере();
	Оп = Новый ОписаниеОповещения("ПослеВыбораОтветственногоПользователя", ЭтотОбъект,);
	
	ПоказатьВыборИзМеню(Оп, СЗ, Элементы.ВыбратьПользователяГруппыДоступности);

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОтветственногоПользователя(ВыбранныйЭлемент, ДопПараметр) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.Ответственный = ВыбранныйЭлемент.Значение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоАктуВозврата(Команда)
	
	ПараметрыОткрытия = Новый Структура("АктРассмотренияВозврата, СформироватьПриОткрытии", Объект.Ссылка, Истина);
	ОткрытьФорму("Отчет.ДокументыПоАктуВозврата.Форма.ФормаОтчетаУпр", ПараметрыОткрытия); 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоПоВозвратуОтПокупателяНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	
	ТаблицаВозвратов = Документы.АктРассмотренияВозврата.ДокументыВозвратаОтПокупателяПоАРВ(Объект.Ссылка, 
	"Проведен и СтатусДокумента = Значение(Справочник.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят)
	|ИЛИ СтатусДокумента = Значение(Справочник.СтатусыДокументов.ВозвратТоваровОтПокупателяРазмещен)");
	
	Если ТаблицаВозвратов.Количество() = 0 Тогда
		Сообщить("Не найден документ возврата от покупателя в статусе ""Принят"" или ""Размещен"" по акту возврата");
		Возврат;
	КонецЕсли;
	
	Если ТаблицаВозвратов[0].СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят Тогда
		ДокОбъект.ОбновитьКоличествоПоВозвратуОтПокупателя(ТаблицаВозвратов[0].Ссылка, "Принятое");
	Иначе
		ДокОбъект.ОбновитьКоличествоПоВозвратуОтПокупателя(ТаблицаВозвратов[0].Ссылка, "Принятое");
		ДокОбъект.ОбновитьКоличествоПоВозвратуОтПокупателя(ТаблицаВозвратов[0].Ссылка, "Размещенное");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоПоВозвратуОтПокупателя(Команда)
	ОбновитьКоличествоПоВозвратуОтПокупателяНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТоварыВидУценкиПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВидУценкиПриИзменении(Элемент)
	ТоварыВидУценкиПриИзмененииНаСервере();
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.ВидУценки = ПредопределенноеЗначение("Перечисление.ВидыУценки.ОбработкаОднойДетали") Тогда
		 СтрокаТабличнойЧасти.ПроцентУценки = 0;
	ИначеЕсли СтрокаТабличнойЧасти.ВидУценки = ПредопределенноеЗначение("Перечисление.ВидыУценки.УценкаЗаТовар") Тогда
		 СтрокаТабличнойЧасти.СуммаУценки = 0;
	КонецЕсли;

	ПриИзмененииПроцентаСуммыУценки(СтрокаТабличнойЧасти);

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПроцентаСуммыУценки(СтрокаТабличнойЧасти)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПослеУценки");
	СтруктураДействий.Вставить("ПересчитатьСуммуАРВ");
	СтруктураДействий.Вставить("РассчитатьСуммуНДС", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	СтруктураДействий.Вставить("РассчитатьСуммуНДСПлан", Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));			
	ОбработкаТабличныхЧастей.ПересчитатьСтрокуТабличнойЧасти(СтрокаТабличнойЧасти, СтруктураДействий, Неопределено); 
	
КонецПроцедуры

&НаКлиенте
Процедура Файлы(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Сообщить("Сначала запишите документ");
		Возврат;
	КонецЕсли;
	
	СтруктураДляСпискаИзображдений = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	СтруктураДляСпискаДополнительныхФайлов = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Объект.Ссылка, Ложь, Ложь);
	ОбязательныеОтборы = Новый Структура("Объект", Объект.Ссылка);
	
	РаботаСФайлами.ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображдений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыНаСайтеНажатие(Элемент)
	СсылкаНаСайт = ВозвратыОтПокупателяСервер.АдресВложенийСайта()+Объект.Штрихкод;
	ЗапуститьПриложение(СсылкаНаСайт);
КонецПроцедуры

&НаКлиенте
Процедура ВариантСписанияПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
	УстановитьВидимостьВиновногоЛицаДляСписания();
КонецПроцедуры


&НаКлиенте
Процедура ПричинаОтказаВВозвратеПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Объект.МенеджерОтказаВВозврате) Тогда
		Объект.МенеджерОтказаВВозврате = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументИзБазы77(Команда)
	
	КлючУникальности = Строка(УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторФормыВладельца", КлючУникальности);
	
	ОткрытьФорму("Документ.АктРассмотренияВозврата.Форма.ФормаЗагрузкиНакладнойИз77",ПараметрыФормы,,КлючУникальности);

КонецПроцедуры

&НаКлиенте
Процедура ВиновноеЛицоДляСписанияПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура КодСписанияПриИзменении(Элемент)
	УстановитьРучноеИзменениеРеквизита(Элемент.Имя);
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
		
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		
		ПриЧтенииСозданииНаСервере();
		
		//Запрещаем копировать Акт возврата
		Если НЕ Параметры.ЗначениеКопирования.Пустая() Тогда
			Отказ = Истина; 
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
		//Запрещаем создавать, если статус Новый не доступен
		Если НЕ Справочники.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.СтатусДоступенТекущемуПользователю(Справочники.СтатусыДокументов.АРВ_Новый) Тогда
			Сообщить("Статус ""Новый"" не доступен текущему пользователю, создание Акта возврата запрещено!", СтатусСообщения.Важное);
			Отказ = Истина;
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
	
	СписокВыбораКодовВозврата =  Справочники.КодыВозврата.СписокВыбораКодовВозврата();
	Для Каждого ЭлСЗ Из СписокВыбораКодовВозврата Цикл
		Элементы.КодВозврата.СписокВыбора.Добавить(ЭлСЗ.Значение, ЭлСЗ.Представление);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	НастроитьВнешнийВидФормы();
	ВыполнитьАлгоритмПриОткрытииНаСервере();
	
	СписокЭП.Параметры.УстановитьЗначениеПараметра("ОснованиеПисьма", Объект.Ссылка);
	СобытияАктовРассмотренияВозврата.Параметры.УстановитьЗначениеПараметра("АктРассмотренияВозврата", Объект.Ссылка);
	
	РеквизитыДляКонтроляИсторииИзменения = Документы.АктРассмотренияВозврата.ИменаРеквизитовДляКонтроляИстории();
	
	ВозвратТоваровОтПокупателяЗаголовок = "";
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ВозвратыТоваровОтПокупателя = Документы.АктРассмотренияВозврата.ДокументыВозвратаОтПокупателяПоАРВ(Объект.Ссылка);
		Если ВозвратыТоваровОтПокупателя.Количество() > 0 Тогда
			ВозвратТоваровОтПокупателя = ВозвратыТоваровОтПокупателя[0].Ссылка;
			ВозвратТоваровОтПокупателяЗаголовок = ""+ВозвратыТоваровОтПокупателя[0].Ссылка+" ( "+ВозвратыТоваровОтПокупателя[0].СтатусДокумента+", "+ВозвратыТоваровОтПокупателя[0].Склад+" )";
		КонецЕсли;	
	Иначе
		ВозвратТоваровОтПокупателя = Неопределено;
		Элементы.ВозвратТоваровОтПокупателяНадпись.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ВозвратТоваровОтПокупателяНадпись.Заголовок = ВозвратТоваровОтПокупателяЗаголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РассчитатьИтоги();
	ЗаполнитьДопРеквизитыТЧТовары();
	
	Если СтрНайти(Объект.Комментарий, "#НеОткрыватьФорму#") > 0 Тогда
		Отказ = Истина;
		ТекстОшибки = СокрЛП(СтрЗаменить(Объект.Комментарий, "#НеОткрыватьФорму#", ""));
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			Предупреждение(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	Если ИзмененныеРеквизиты.Количество() > 0 Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "РучноеИзменениеРеквизита");
	КонецЕсли;
	
	//Для статуса Новый при ручном создании можно указывать код возврата 02 или пустой
	Если Объект.СтатусДокумента = Справочники.СтатусыДокументов.АРВ_Новый 
		И Документы.АктРассмотренияВозврата.ЭтоРучнойВвод(Объект) Тогда
		
		Если Не ЗначениеЗаполнено(Объект.КодВозврата) ИЛИ Объект.КодВозврата = Справочники.КодыВозврата.ВПродажуНаСклад Тогда
			//Это разрешено
		Иначе
			Сообщить("Код возврата необходимо указать ""02"" или оставить пустым!", СтатусСообщения.Важное);
			Отказ = Истина;			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Если установили отметку о проверке документов, то добавим запись в регистр
	Если ТекущийОбъект.СтатусПроверкиДокументовПокупателя = Перечисления.АРВ_СтатусыПроверкиДокументовПокупателя.Проверены Тогда
		
		ДокументыВозврата = Документы.АктРассмотренияВозврата.ДокументыВозвратаОтПокупателяПоАРВ(ТекущийОбъект.Ссылка);
		Для каждого СтрокаДокумента Из ДокументыВозврата Цикл
			РегистрыСведений.ДатыВозвратаДокументов.Добавить(СтрокаДокумента.Ссылка, Перечисления.ВидыПечатныхДокументов.УКД);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	НастроитьВнешнийВидФормы();
	ВыполнитьАлгоритмПриОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте 
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВопроса = КодВозвратаДиалога.Да  Тогда
		ЗакрытиеРазрешено = Истина; 
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если (Объект.СтатусДокумента = ПредопределенноеЗначение("Справочник.СтатусыДокументов.АРВ_ГПРКОтказ")
		 ИЛИ Объект.СтатусДокумента = ПредопределенноеЗначение("Справочник.СтатусыДокументов.АРВ_КРООтказ")
		 ИЛИ Объект.СтатусДокумента = ПредопределенноеЗначение("Справочник.СтатусыДокументов.АРВ_ГВОтказ")) 
		И НЕ Объект.ОтправленаПричинаОтказаВВозврате Тогда
		
		Если  ЗакрытиеРазрешено = Неопределено	Тогда 
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), "Причина отказа не отправлена клиенту. Закрыть документ без отправки причины?", РежимДиалогаВопрос.ДаНет); 
			Отказ = Истина; 
		КонецЕсли; 
		
	КонецЕсли;
	
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
		|   И НЕ Алгоритм.ПометкаУдаления
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
Функция ПолучитьСуммуСНДС(ИмяПоля = "Сумма") Экспорт
	
	Сумма = Объект.Товары.Итог(ИмяПоля);
	
	ИмяПоляНДС = ?(ИмяПоля = "Сумма", "СуммаНДС", "СуммаНДСПлан");
	
	Если Объект.УчитыватьНДС И Не Объект.СуммаВключаетНДС Тогда
		
		Сумма = Сумма + Объект.Товары.Итог(ИмяПоляНДС);
		
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
		Если ИзмененныеРеквизиты.НайтиПоЗначению(ИмяРеквизита) = Неопределено Тогда
			 ИзмененныеРеквизиты.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция Модифицированность() Экспорт
	Возврат Модифицированность;
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьВиновногоЛицаДляСписания()
	
	Элементы.ВиновноеЛицоДляСписания.Видимость = Объект.ВариантСписания = ПредопределенноеЗначение("Перечисление.ВариантыСписанияВозврата.ПродажаНаВиновноеЛицо");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаОповещенияНаСервере(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ОбновитьДокументПродажиАРВ"
		И ЗначениеЗаполнено(Параметр.ДокументСсылка)
		И Строка(УникальныйИдентификатор) = Параметр.ИдентификаторФормы Тогда
		
		Объект.ДокументПродажи = Параметр.ДокументСсылка;
		АРВОбъект = РеквизитФормыВЗначение("Объект");
		АРВОбъект.Товары.Очистить();
		АРВОбъект.Заполнить(Параметр.ДокументСсылка);
		ЗначениеВРеквизитФормы(АРВОбъект, "Объект");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьДокументПродажиАРВ" Тогда
		ОбработкаОповещенияНаСервере(ИмяСобытия, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область НастройкаВнешнегоВидаФормы

&НаСервере
Процедура НастроитьВнешнийВидФормы() 
	
	ВозвратыОтПокупателяСервер.ЗаполнитьКомандыНаФорме(ЭтаФорма, Объект.СтатусДокумента, Истина );
	
	УстановитьДоступностьФормы();
	
	Если Объект.СтатусДокумента <> ПредопределенноеЗначение("Справочник.СтатусыДокументов.АРВ_РаботаЗавершена") Тогда
		НаходитсяВСтатусеМинут = Документы.АктРассмотренияВозврата.ПродолжительностьНахожденияВСтатусе(Объект.Ссылка);
		Элементы.ПродолжительностьНахожденияВСтатусе.Заголовок = ВозвратыОтПокупателяСервер.МинутыВСтроку(НаходитсяВСтатусеМинут);
	Иначе
		Элементы.ПродолжительностьНахожденияВСтатусе.Заголовок = "";
	КонецЕсли;
	
	ТекстОшибкиОбработки = РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.ТекстОшибкиОбработки(Объект.Ссылка);
	Элементы.ТекстОшибкиОбработки.Видимость = Ложь;
	//Элементы.ТекстОшибкиОбработки.Заголовок = "Ошибка обработки Акта:"+Символы.ПС+ТекстОшибкиОбработки;
	
	Элементы.КартинкаОшибки.Видимость = ЗначениеЗаполнено(ТекстОшибкиОбработки);
	Элементы.КартинкаОшибки.Подсказка = "Ошибка обработки Акта:"+Символы.ПС+ТекстОшибкиОбработки;
	
	//Элементы.ПричинаОтказаКлиента.Видимость = Объект.ПричинаВозврата = Справочники.ПричиныВозврата.ОтказОтДетали;
	
	Элементы.ТоварыСтавкаНДС.Видимость 		= Объект.УчитыватьНДС;
	Элементы.ТоварыСуммаНДС.Видимость 		= Объект.УчитыватьНДС;
	Элементы.ТоварыСуммаНДСПлан.Видимость 	= Объект.УчитыватьНДС;
	
	КоличествоФайловПоОбъекту = Справочники.ХранилищеДополнительнойИнформации.КоличествоЗаписейПоОбъекту(Объект.Ссылка);
	Элементы.ФормаФайлы.Заголовок = "Файлы";
	Если КоличествоФайловПоОбъекту > 0 Тогда
		Элементы.ФормаФайлы.Картинка = БиблиотекаКартинок.ТолькоСкрепка;
		Элементы.ФормаФайлы.Заголовок = Элементы.ФормаФайлы.Заголовок + "("+КоличествоФайловПоОбъекту+")"; 
	Иначе
		Элементы.ФормаФайлы.Картинка = Новый Картинка;
	КонецЕсли;
	
	ЭтоРучнойВвод = Документы.АктРассмотренияВозврата.ЭтоРучнойВвод(Объект);
	Элементы.ФайлыНаСайте.Видимость = НЕ ЭтоРучнойВвод;
	
	Элементы.ВиновноеЛицоДляСписания.Видимость 	= Объект.ВариантСписания = ПредопределенноеЗначение("Перечисление.ВариантыСписанияВозврата.ПродажаНаВиновноеЛицо");
	Элементы.КодСписания.Видимость 				= Объект.ВариантСписания = ПредопределенноеЗначение("Перечисление.ВариантыСписанияВозврата.Списание")
	ИЛИ (Объект.КодВозврата = Справочники.КодыВозврата.Перестикеровать ИЛИ Объект.КодВозврата = Справочники.КодыВозврата.Уценка);
	
	

	УстановитьЗаголовок();
	
	ВыполнитьАлгоритмПриОткрытииНаСервере();
	
	Элементы.ИнформационнаяНадписьВерх.Видимость = ЗначениеЗаполнено(Элементы.ИнформационнаяНадписьВерх.Заголовок);
	Элементы.ИнформационнаяНадписьНиз.Видимость = ЗначениеЗаполнено(Элементы.ИнформационнаяНадписьНиз.Заголовок);
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Шаблон = НСтр("ru='%1 (%2) %3 от %4'");
	Иначе
		Шаблон = НСтр("ru='%1 (создание)'");
	КонецЕсли;
	ЗаголовокТекстом = НСтр("ru = 'Акт рассмотрения возврата'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ЗаголовокТекстом, Объект.СтатусДокумента, Объект.Номер, Объект.Дата);
	
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
	
	Если ИзмененныеРеквизиты.Количество()>0 Тогда
		
		ПараметрыЗаписи = Новый структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", ?(Объект.Проведен, 
													РежимЗаписиДокумента.Проведение, 
													РежимЗаписиДокумента.Запись));
		
		Записать(ПараметрыЗаписи);
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
Процедура СоздатьЭлектронноеПисьмо1(Команда)
	СоздатьЭлектронноеПисьмоНаСервере("Пользователь");
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	//Если ЗначениеЗаполнено(ТекстОшибкиОбработки) Тогда
		 РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.СброситьДатуОбработкиОшибки(Объект.Ссылка);
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПриИзмененииКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКонтрагента()
	
	ПриИзмененииКонтрагентаПроверитьНаличиеЛогина();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКонтрагентаПроверитьНаличиеЛогина()
	
	ТекстОшибки = "";
	Если НЕ ВозвратыОтПокупателяСервер.РазрешитьРучноеРедактированиеАРВ()
		И Справочники.УчетныеЗаписиСайта.ДанныеУчетнойЗаписиКонтрагента(Объект.Контрагент).УчетнаяЗапись <> Неопределено Тогда
		ТекстОшибки = Документы.АктРассмотренияВозврата.ТекстОшибкиЕстьЛогинКонтрагента();
		Предупреждение(ТекстОшибки);
		Сообщить(ТекстОшибки, СтатусСообщения.Важное);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ФормаКоманднаяПанель.Доступность = Не ЗначениеЗаполнено(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзменений(Команда)
	ОбщегоНазначенияКлиент.ПоказатьИсториюИзмененияОбъекта(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПричинаОтказаВВозвратеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФормаВыбораПричины = ПолучитьФорму("Справочник.ПричиныОтказаВВозвратеКлиенту.ФормаВыбора");
	РезультатВыбора = ФормаВыбораПричины.ОткрытьМодально();
	
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда
		Объект.ПричинаОтказаВВозврате = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РезультатВыбора, "ТекстСообщенияНаСайт");
	КонецЕсли;

КонецПроцедуры


#КонецОбласти






  