﻿&НаКлиенте
Перем Сисинфо,ПринудительноеЗакрытие;
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КорневойУзел = ДеревоМетаданных.ПолучитьЭлементы();
	ВыбираемыеТипы = Параметры.ВыбираемыеТипы.Типы();
	
	Для Каждого ВозможныйТип Из ВыбираемыеТипы Цикл
		ДобавитьТипВСписок(ВозможныйТип,КорневойУзел);
	КонецЦикла;
	Если ВыбираемыеТипы.Количество() = 0 Тогда
		ЗаполнитьВсемиТипами();
	КонецЕсли;
	Если НЕ Параметры.МножественныйВыбор Тогда
		Элементы.ДеревоМетаданныхПометка.Видимость = Ложь;
		
	Иначе
		Элементы.ДеревоМетаданных.МножественныйВыбор = Истина;
		Элементы.ДеревоМетаданных.УстановитьДействие("ВыборЗначения","");
		ОтмеченныеТипы = Параметры.НачальнаяПометка.Типы();
		Если НЕ ОтмеченныеТипы.Количество() = 0 Тогда
			Для Каждого КорневойУзел Из ДеревоМетаданных.ПолучитьЭлементы() Цикл
				Для Каждого СтрокаТипа Из КорневойУзел.ПолучитьЭлементы() Цикл
					Если ОтмеченныеТипы.Найти(СтрокаТипа.ОписаниеТипов.Типы()[0])<> Неопределено Тогда
						СтрокаТипа.Пометка = Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсемиТипами() Экспорт
	КорневойУзел = ДеревоМетаданных.ПолучитьЭлементы();
	ПримитивныеТипы = КорневойУзел.Добавить();
	ПримитивныеТипы.ТипМетаданных = "Примитивные";
	СтрокаПримитивных = ПримитивныеТипы.ПолучитьЭлементы();
	
	НоваяСтрока = СтрокаПримитивных.Добавить();
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("Число");
	НоваяСтрока.ТипМетаданных = "Примитивные";
	НоваяСтрока.Имя = "Число";
	НоваяСтрока.Синоним = "Число";
	НоваяСтрока.Представление = "Число";
	
	НоваяСтрока = СтрокаПримитивных.Добавить();
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("Строка");
	НоваяСтрока.ТипМетаданных = "Примитивные";
	НоваяСтрока.Имя = "Строка";
	НоваяСтрока.Синоним = "Строка";
	НоваяСтрока.Представление = "Строка";
	
	НоваяСтрока = СтрокаПримитивных.Добавить();
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("Булево");
	НоваяСтрока.ТипМетаданных = "Примитивные";
	НоваяСтрока.Имя = "Булево";
	НоваяСтрока.Синоним = "Булево";
	НоваяСтрока.Представление = "Булево";
	
	НоваяСтрока = СтрокаПримитивных.Добавить();
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("Дата");
	НоваяСтрока.ТипМетаданных = "Примитивные";
	НоваяСтрока.Имя = "Дата";
	НоваяСтрока.Синоним = "Дата";
	НоваяСтрока.Представление = "Дата";
	
	НоваяСтрока = СтрокаПримитивных.Добавить();
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("Тип");
	НоваяСтрока.ТипМетаданных = "Примитивные";
	НоваяСтрока.Имя = "Тип";
	НоваяСтрока.Синоним = "Тип";
	НоваяСтрока.Представление = "Тип";
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "Справочник";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.Справочники Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "Справочник";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
		НоваяСтрока.Представление = Мета.ПредставлениеОбъекта;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "Документ";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.Документы Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "Документ";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
		НоваяСтрока.Представление = Мета.ПредставлениеОбъекта;
	КонецЦикла;

	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "Перечисление";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.Перечисления Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ПеречислениеСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "Перечисление";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "ПланВидовХарактеристик";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.ПланыВидовХарактеристик Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "ПланВидовХарактеристик";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "ПланСчетов";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.ПланыСчетов Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ПланСчетовСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "ПланСчетов";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "ПланОбмена";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.ПланыОбмена Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ПланОбменаСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "ПланОбмена";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "ПланВидовРасчета";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.ПланыВидовРасчета Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ПланВидовРасчетаСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "ПланВидовРасчета";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "БизнесПроцесс";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.БизнесПроцессы Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("БизнесПроцессСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "БизнесПроцесс";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	ТекРодитель = КорневойУзел.Добавить();
	ТекРодитель.ТипМетаданных = "Задача";
	ТекРодитель = ТекРодитель.ПолучитьЭлементы();
	Для Каждого Мета Из Метаданные.Задачи Цикл
		НоваяСтрока = ТекРодитель.Добавить();
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ЗадачаСсылка."+Мета.Имя);
		НоваяСтрока.ТипМетаданных = "Задача";
		НоваяСтрока.Имя = Мета.Имя;
		НоваяСтрока.Синоним = Мета.Синоним;
	КонецЦикла;
	
	Для Каждого ВИД Из Метаданные.ВнешниеИсточникиДанных Цикл
		ТекРодитель = КорневойУзел.Добавить();
		ТекРодитель.ТипМетаданных = ВИД.Имя;
		ТекРодитель = ТекРодитель.ПолучитьЭлементы();
		
		Для Каждого Мета Из Вид.Таблицы Цикл
			Если Строка(Мета.ТипДанныхТаблицы) = "ОбъектныеДанные" Тогда
				НоваяСтрока = ТекРодитель.Добавить();
				НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВнешнийИсточникДанныхТаблицаСсылка."+ВИД.Имя+"."+Мета.Имя);
				НоваяСтрока.ТипМетаданных = ВИД.Имя;
				НоваяСтрока.Имя = Мета.Имя;
				НоваяСтрока.Синоним = Мета.Синоним;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	НоваяСтрока = ПолучитьГруппу("Специальные");
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидДвиженияНакопления");
	НоваяСтрока.ТипМетаданных = "Специальные";
	НоваяСтрока.Имя = "ВидДвиженияНакопления";
	НоваяСтрока.Синоним = "Вид движения накопления";
	
	НоваяСтрока = ПолучитьГруппу("Специальные");
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидДвиженияБухгалтерии");
	НоваяСтрока.ТипМетаданных = "Специальные";
	НоваяСтрока.Имя = "ВидДвиженияБухгалтерии";
	НоваяСтрока.Синоним = "Вид движения бухгалтерии";
	
	НоваяСтрока = ПолучитьГруппу("Специальные");
	НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидСчета");
	НоваяСтрока.ТипМетаданных = "Специальные";
	НоваяСтрока.Имя = "ВидСчета";
	НоваяСтрока.Синоним = "Вид счета плана счетов";

КонецПроцедуры // ЗаполнитьВсемиТипами()


&НаСервере
Процедура ДобавитьТипВСписок(ВозможныйТип,КорневойУзел)
	МассивДляТипа = Новый Массив;
	МассивДляТипа.Добавить(ВозможныйТип);
	Если ВозможныйТип = Тип("Число") Тогда
		НоваяСтрока = ПолучитьГруппу("Примитивные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
		НоваяСтрока.ТипМетаданных = "Примитивные";
		НоваяСтрока.Имя = "Число";
		НоваяСтрока.Синоним = "Число";
		НоваяСтрока.Представление = "Число";
	ИначеЕсли ВозможныйТип = Тип("Строка") Тогда
		НоваяСтрока = ПолучитьГруппу("Примитивные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
		НоваяСтрока.ТипМетаданных = "Примитивные";
		НоваяСтрока.Имя = "Строка";
		НоваяСтрока.Синоним = "Строка";
		НоваяСтрока.Представление = "Строка";
	ИначеЕсли ВозможныйТип = Тип("Булево") Тогда
		НоваяСтрока = ПолучитьГруппу("Примитивные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
		НоваяСтрока.ТипМетаданных = "Примитивные";
		НоваяСтрока.Имя = "Булево";
		НоваяСтрока.Синоним = "Булево";
		НоваяСтрока.Представление = "Булево";
	ИначеЕсли ВозможныйТип = Тип("Дата") Тогда
		НоваяСтрока = ПолучитьГруппу("Примитивные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
		НоваяСтрока.ТипМетаданных = "Примитивные";
		НоваяСтрока.Имя = "Дата";
		НоваяСтрока.Синоним = "Дата";
		НоваяСтрока.Представление = "Дата";
	ИначеЕсли ВозможныйТип = Тип("Тип") Тогда
		НоваяСтрока = ПолучитьГруппу("Примитивные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
		НоваяСтрока.ТипМетаданных = "Примитивные";
		НоваяСтрока.Имя = "Тип";
		НоваяСтрока.Синоним = "Тип";
		НоваяСтрока.Представление = "Тип";
	ИначеЕсли ВозможныйТип = Тип("ВидДвиженияНакопления") Тогда
		НоваяСтрока = ПолучитьГруппу("Специальные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидДвиженияНакопления");
		НоваяСтрока.ТипМетаданных = "Специальные";
		НоваяСтрока.Имя = "ВидДвиженияНакопления";
		НоваяСтрока.Синоним = "Вид движения накопления";
		НоваяСтрока.Представление = "Тип";
	ИначеЕсли ВозможныйТип = Тип("ВидДвиженияБухгалтерии") Тогда
		НоваяСтрока = ПолучитьГруппу("Специальные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидДвиженияБухгалтерии");
		НоваяСтрока.ТипМетаданных = "Специальные";
		НоваяСтрока.Имя = "ВидДвиженияБухгалтерии";
		НоваяСтрока.Синоним = "Вид движения бухгалтерии";
		НоваяСтрока.Представление = "Тип";
	ИначеЕсли ВозможныйТип = Тип("ВидСчета") Тогда
		НоваяСтрока = ПолучитьГруппу("Специальные");
		НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов("ВидСчета");
		НоваяСтрока.ТипМетаданных = "Специальные";
		НоваяСтрока.Имя = "ВидСчета";
		НоваяСтрока.Синоним = "Вид счета плана счетов";
		НоваяСтрока.Представление = "Тип";
	Иначе
		Мета = Метаданные.НайтиПоТипу(ВозможныйТип);
		Если Мета<>Неопределено Тогда
			ПолноеИмя = Мета.ПолноеИмя();
			ПоложениеТочки = Найти(ПолноеИмя,".");
			Если ПоложениеТочки = 0 Тогда
				ИмяГруппы = "Прочее"
			Иначе
				ИмяГруппы = Лев(ПолноеИмя,ПоложениеТочки-1);
			КонецЕсли;
			НоваяСтрока = ПолучитьГруппу(ИмяГруппы);
			НоваяСтрока.ОписаниеТипов = Новый ОписаниеТипов(МассивДляТипа);
			НоваяСтрока.ТипМетаданных = ИмяГруппы;
			НоваяСтрока.Имя = Мета.Имя;
			НоваяСтрока.Синоним = Мета.Синоним;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // ДобавитьТипВСписок()

&НаСервере
Функция ПолучитьГруппу(Имя)
	СписокКорневыхГрупп = ДеревоМетаданных.ПолучитьЭлементы();
	Для Каждого ТекГруппа Из СписокКорневыхГрупп Цикл
		Если ТекГруппа.ТипМетаданных = Имя Тогда
			Возврат ТекГруппа.ПолучитьЭлементы().Добавить();			;
		КонецЕсли;
	КонецЦикла;
	
	НужнаяГруппа = СписокКорневыхГрупп.Добавить();
	НужнаяГруппа.ТипМетаданных = Имя;
	Возврат НужнаяГруппа.ПолучитьЭлементы().Добавить();
	
КонецФункции // ПолучитьГруппу()

&НаКлиенте
Процедура ДеревоМетаданныхВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	ТекДанные = ДеревоМетаданных.НайтиПоИдентификатору(Значение);
	Закрыть(ТекДанные.ОписаниеТипов.ПривестиЗначение());
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенияЗавершение(Результат,ДополнительныеПараметры) Экспорт
	Закрыть(Результат);
КонецПроцедуры // ВыборЗначенияЗавершение()


&НаКлиенте
Функция Это82() Экспорт
	Если СисИнфо = Неопределено Тогда
		СисИнфо = Новый СистемнаяИнформация;
	КонецЕсли;
	Возврат Лев(СисИнфо.ВерсияПриложения,3)="8.2";
КонецФункции // Верси

&НаКлиенте
Процедура Выбрать(Команда)
	МассивОписаний = Новый Массив;
	Для Каждого КорневойУзел Из ДеревоМетаданных.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаТипа Из КорневойУзел.ПолучитьЭлементы() Цикл
			Если СтрокаТипа.Пометка Тогда
				МассивОписаний.Добавить(СтрокаТипа.ОписаниеТипов.типы()[0]);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Закрыть(Новый ОписаниеТипов(МассивОписаний));
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если НЕ ПринудительноеЗакрытие = Истина и Элементы.ДеревоМетаданныхПометка.Видимость Тогда//выбирается в ТЗ множественный тип
		Отказ= Истина;
		МассивОписаний = Новый Массив;
		Для Каждого КорневойУзел Из ДеревоМетаданных.ПолучитьЭлементы() Цикл
			Для Каждого СтрокаТипа Из КорневойУзел.ПолучитьЭлементы() Цикл
				Если СтрокаТипа.Пометка Тогда
					МассивОписаний.Добавить(СтрокаТипа.ОписаниеТипов.типы()[0]);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ПринудительноеЗакрытие = Истина;
		Закрыть(Новый ОписаниеТипов(МассивОписаний));
	КонецЕсли;
КонецПроцедуры
