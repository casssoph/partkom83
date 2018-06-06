﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (клиент).
// 
// Выполняется на клиенте.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает панель отчетов. Используется в модуле общей команды.
//
// Параметры:
//   ПутьКПодсистеме - Строка - Имя раздела или путь к подсистеме, для которой открывается панель отчетов.
//       Задается в формате: "ИмяРаздела[.ИмяВложеннойПодсистемы1][.ИмяВложеннойПодсистемы2][...]".
//       NB! Раздел должен быть описан в ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//   ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - Передается "как есть" из параметров обработчика команды.
//
Процедура ПоказатьПанельОтчетов(ПутьКПодсистеме, ПараметрыВыполненияКоманды, Удалить_Заголовок = "") Экспорт
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыКлиента = ПараметрыКлиента();
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		ИдентификаторЗамера = Новый УникальныйИдентификатор;
		МодульОценкаПроизводительностиКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиентСервер");
		МодульОценкаПроизводительностиКлиентСервер.НачатьРучнойЗамерВремени(
			"ПанельОтчетов.Открытие",
			ИдентификаторЗамера,
			ПараметрыКлиента.ПрефиксЗамеров + "; " + ПутьКПодсистеме);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиентСервер.ЗакончитьРучнойЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает диалог настройки размещения нескольких вариантов в разделах.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   ДополнительныеПараметры (*) Необязательный.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования окна владельца.
//
Процедура ОткрытьДиалогРазмещенияВариантовВРазделах(МассивВариантов, ДополнительныеПараметры = Неопределено, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов, которые необходимо разместить в разделах.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("МассивВариантов, ДополнительныеПараметры", МассивВариантов, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.РазмещениеВРазделах", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса пользовательских настроек выбранных вариантов отчетов.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования окна владельца.
//
Процедура ОткрытьДиалогСбросаНастроекПользователей(МассивВариантов, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов, для которых необходимо сбросить пользовательские настройки.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивВариантов", МассивВариантов);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросПользовательскихНастроек", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса настроек размещения выбранных вариантов отчетов программы.
//   Проверки рекомендуется осуществлять до вызова.
//
// Параметры:
//   МассивВариантов - Массив из СправочникСсылка.ВариантыОтчетов - Варианты отчетов, для которых открывается диалог.
//   Владелец - УправляемаяФорма - Необязательный. Используется только для блокирования окна владельца.
//
Процедура ОткрытьДиалогСбросаНастроекРазмещения(МассивВариантов, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(МассивВариантов) <> Тип("Массив") ИЛИ МассивВариантов.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов программы, для которых необходимо сбросить настройки размещения.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивВариантов", МассивВариантов);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросНастроекРазмещения", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Оповещает открытые панели отчетов, формы списков и элементов о изменениях.
//
// Параметры:
//   Параметр - Произвольный - Необязательный. Могут быть переданы любые необходимые данные.
//   Источник - Произвольный - Необязательный. Источник события. Например, можно передать другую форму.
//
Процедура ОбновитьОткрытыеФормы(Параметр = Неопределено, Источник = Неопределено) Экспорт
	
	Оповестить(ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта(), Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму отчета.
//
// Параметры:
//   ФормаВладелец - УправляемаяФорма, Неопределено - Форма, из которой открывается отчет.
//   Вариант - Структура, Коллекция - Параметры формы.
//       * Ссылка - СправочникСсылка.ВариантыОтчетов - Ссылка варианта отчета.
//       * ТипОтчета - Строка, ПеречислениеСсылка.ТипыОтчетов - "Внутренний" или "Дополнительный".
//       * ИмяОтчета - Строка - Имя отчета как оно задано в метаданных.
//       * КлючВарианта - Строка - Имя варианта отчета как оно задано в СКД отчета.
//       * Отчет - Произвольный - Ссылка отчета. Для внутренних отчетов можно не указывать.
//       * ВыполнятьЗамеры - Булево - Необязательный. Истина если необходимо замерять время открытия.
//       * ИмяОперации - Строка - Необязательный. Имя ключевой операции для замеров времени открытия.
//   ДополнительныеПараметры - Структура, Неопределено - Дополнение к стандартным параметрам открытия формы отчета.
//
// Вспомогательные методы:
//   ВариантыОтчетов.ПараметрыОткрытия(ВариантСсылка) подготавливает параметры открытия
//     на основании ссылки варианта отчета.
//
Процедура ОткрытьФормуОтчета(Знач ФормаВладелец, Знач Вариант, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Тип = ТипЗнч(Вариант);
	Если Тип = Тип("Структура") Тогда
		ПараметрыОткрытия = Вариант;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВариантыОтчетов")
		Или Тип = ВариантыОтчетовКлиентСервер.ТипСсылкиДополнительногоОтчета() Тогда
		ПараметрыОткрытия = ВариантыОтчетовВызовСервера.ПараметрыОткрытия(Вариант);
	Иначе
		ПараметрыОткрытия = Новый Структура("Ссылка, Отчет, ТипОтчета, ИмяОтчета, КлючВарианта, КлючЗамеров");
		Если ТипЗнч(ФормаВладелец) = Тип("УправляемаяФорма") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ФормаВладелец);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Вариант);
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
	КонецЕсли;
	
	ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "ВыполнятьЗамеры", Ложь);
	
	ПараметрыОткрытия.ТипОтчета = ВариантыОтчетовКлиентСервер.ТипОтчетаСтрокой(ПараметрыОткрытия.ТипОтчета, ПараметрыОткрытия.Отчет);
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ТипОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определен тип отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	ИначеЕсли ПараметрыОткрытия.ТипОтчета = "Внутренний" Или ПараметрыОткрытия.ТипОтчета = "Расширение" Тогда
		Вид = "Отчет";
		КлючЗамеров = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "КлючЗамеров");
		Если ЗначениеЗаполнено(КлючЗамеров) Тогда
			ПараметрыКлиента = ПараметрыКлиента();
			Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
				ПараметрыОткрытия.ВыполнятьЗамеры = Истина;
				ПараметрыОткрытия.Вставить("ИмяОперации", КлючЗамеров + ".Открытие");
				ПараметрыОткрытия.Вставить("КомментарийОперации", ПараметрыКлиента.ПрефиксЗамеров);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ПараметрыОткрытия.ТипОтчета = "Дополнительный" Тогда
		Вид = "ВнешнийОтчет";
		Если Не ПараметрыОткрытия.Свойство("Подключен") Тогда
			ВариантыОтчетовВызовСервера.ПриПодключенииОтчета(ПараметрыОткрытия);
		КонецЕсли;
		Если Не ПараметрыОткрытия.Подключен Тогда
			СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ФормаВладелец, ПараметрыОткрытия);
			Возврат;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Вариант внешнего отчета можно открыть только из формы отчета.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ИмяОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определено имя отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	ПолноеИмяОтчета = Вид + "." + ПараметрыОткрытия.ИмяОтчета;
	
	Уникальность = ПолноеИмяОтчета;
	Если ЗначениеЗаполнено(ПараметрыОткрытия.КлючВарианта) Тогда
		Уникальность = Уникальность + "/КлючВарианта." + ПараметрыОткрытия.КлючВарианта;
	КонецЕсли;
	ПараметрыОткрытия.Вставить("КлючПараметровПечати",        Уникальность);
	ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", Уникальность);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "КомментарийОперации");
		ИдентификаторЗамера = Новый УникальныйИдентификатор;
		МодульОценкаПроизводительностиКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиентСервер");
		МодульОценкаПроизводительностиКлиентСервер.НачатьРучнойЗамерВремени(
			ПараметрыОткрытия.ИмяОперации,
			ИдентификаторЗамера,
			ПараметрыОткрытия.КомментарийОперации);
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Истина);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиентСервер.ЗакончитьРучнойЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает карточку варианта отчета с настройками размещения в программе.
//
// Параметры:
//   ВариантСсылка - СправочникСсылка.ВариантыОтчетов - Ссылка варианта отчета.
//
Процедура ПоказатьНастройкиОтчета(ВариантСсылка) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьКарточку", Истина);
	ПараметрыФормы.Вставить("Ключ", ВариантСсылка);
	ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемИспользованиеПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Использование = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Использование = 2 Тогда
		СтрокаДерева.Использование = 0;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемВажностьПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Важность = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Важность <> "" Тогда
		СтрокаДерева.Использование = 1;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Аналог ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста, работающий за 1 вызов.
//   В отличие от ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария позволяет устанавливать свой заголовок
//   и работает с реквизитами таблиц.
//
Процедура РедактироватьМногострочныйТекст(ФормаИлиОбработчик, ТекстРедактирования, ВладелецРеквизита, ИмяРеквизита, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Комментарий'");
	КонецЕсли;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ФормаИлиОбработчик", ФормаИлиОбработчик);
	ПараметрыИсточника.Вставить("ВладелецРеквизита",  ВладелецРеквизита);
	ПараметрыИсточника.Вставить("ИмяРеквизита",       ИмяРеквизита);
	Обработчик = Новый ОписаниеОповещения("РедактироватьМногострочныйТекстЗавершение", ЭтотОбъект, ПараметрыИсточника);
	
	ПоказатьВводСтроки(Обработчик, ТекстРедактирования, Заголовок, , Истина);
	
КонецПроцедуры

// Обработчик результата работы процедуры РедактироватьМногострочныйТекст.
Процедура РедактироватьМногострочныйТекстЗавершение(Текст, ПараметрыИсточника) Экспорт
	
	Если ТипЗнч(ПараметрыИсточника.ФормаИлиОбработчик) = Тип("УправляемаяФорма") Тогда
		Форма      = ПараметрыИсточника.ФормаИлиОбработчик;
		Обработчик = Неопределено;
	Иначе
		Форма      = Неопределено;
		Обработчик = ПараметрыИсточника.ФормаИлиОбработчик;
	КонецЕсли;
	
	Если Текст <> Неопределено Тогда
		
		Если ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементДерева")
			Или ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементКоллекции") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыИсточника.ВладелецРеквизита, Новый Структура(ПараметрыИсточника.ИмяРеквизита, Текст));
		Иначе
			ПараметрыИсточника.ВладелецРеквизита[ПараметрыИсточника.ИмяРеквизита] = Текст;
		КонецЕсли;
		
		Если Форма <> Неопределено Тогда
			Если Не Форма.Модифицированность Тогда
				Форма.Модифицированность = Истина;
			КонецЕсли;
			#Если ВебКлиент Тогда
				Форма.ОбновитьОтображениеДанных(); // Для платформы.
			#КонецЕсли
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчик <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик, Текст);
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыКлиента()
	Возврат ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(),
		"ВариантыОтчетов");
КонецФункции

#КонецОбласти

Процедура УстановитьЗаголовокОтчета(ОтчетОбъект, ОтчетФорма) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НомераОтчетовОбработок.Номер
	|ИЗ
	|	РегистрСведений.НомераОтчетовОбработок КАК НомераОтчетовОбработок
	|ГДЕ
	|	НомераОтчетовОбработок.ОтчетОбработка = &ОтчетОбработка";
	
	Запрос.УстановитьПараметр("ОтчетОбработка", Строка(ОтчетОбъект));
	
	ТабЗ = Запрос.Выполнить().Выгрузить();
	
	Если ТабЗ.Количество() = 0 Тогда
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Автоматический);
		Попытка
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	МАКСИМУМ(НомераОтчетовОбработок.Номер) КАК Номер
			|ИЗ
			|	РегистрСведений.НомераОтчетовОбработок КАК НомераОтчетовОбработок
			|
			|ДЛЯ ИЗМЕНЕНИЯ
			|	РегистрСведений.НомераОтчетовОбработок";
			
			
			ТабМакс = Запрос.Выполнить().Выгрузить();
			Если ТабМакс.Количество() = 0 Тогда
				СлНомер = 1;
			Иначе
				СлНомер = ТабМакс[0].Номер;
				Если СлНомер = Null Тогда
					СлНомер = 1;
				Иначе
					СлНомер = СлНомер + 1;
				КонецЕсли;
				
			КонецЕсли;
			
			нз = РегистрыСведений.НомераОтчетовОбработок.СоздатьМенеджерЗаписи();
			нз.ОтчетОбработка = Строка(ОтчетОбъект);
			нз.Номер = СлНомер;
			нз.Записать(Истина);
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	Иначе
		СлНомер = ТабЗ[0].Номер;
		
	КонецЕсли;
	
	ОтчетФорма.АвтоЗаголовок = Ложь;
	ОтчетФорма.Заголовок = "#" + Строка(СлНомер) + ". " + ОтчетФорма.Заголовок;
	
КонецПроцедуры
