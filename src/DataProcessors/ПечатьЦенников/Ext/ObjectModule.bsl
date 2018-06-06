﻿#Если Клиент Тогда

// Процедура заполняет построитель отчета.
//
Процедура ЗаполнитьПостроительОтчета() Экспорт

	ТекстЗапроса = "
|ВЫБРАТЬ
	|ИСТИНА КАК Печать,
	|СпрНоменклатура.Номенклатура КАК Номенклатура,
	|СпрНоменклатура.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|0 КАК Цена,
	|1 КАК Количество
|ИЗ
	|(ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	НЕ СпрНоменклатура.ЭтоГруппа
	|{ГДЕ
	|	СпрНоменклатура.Ссылка.* КАК Номенклатура}) КАК СпрНоменклатура	//|	 КАК СпрНоменклатура
	|";
	
	Если ТолькоИмеющиесяВНаличии Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	(ВЫБРАТЬ
		|		НаСкладе.Номенклатура,
		|		СУММА(НаСкладе.Количество) КАК Количество
		|	ИЗ
		|		(ВЫБРАТЬ
		|			НаСкладе.Номенклатура,
		|			НаСкладе.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыНаСкладах.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   Склад.* КАК Склад}) КАК НаСкладе
		|		ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			ВРознице.Номенклатура,
		|			ВРознице.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыВРознице.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   Склад.* КАК Склад}) КАК ВРознице
		|		ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			ВНТТ.Номенклатура,
		|			ВНТТ.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыВНТТ.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   Склад.* КАК Склад}) КАК ВНТТ
		|		) КАК НаСкладе
		|	СГРУППИРОВАТЬ ПО
		|		НаСкладе.Номенклатура,
		|	) КАК НаСкладе
		|ПО
		|	СпрНоменклатура.Номенклатура = НаСкладе.Номенклатура
		|ГДЕ
		|	ЕСТЬNULL(НаСкладе.Количество, 0) > 0
		|";
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Номенклатура.Наименование
	|";

	// Соответствие имен полей в запросе и их представлений в отчете.
	СтруктураПредставлениеПолей = Новый Структура(
	"Номенклатура,    Склад",
	"Номенклатура",  "Склад");

	ПостроительОтчета.Текст = ТекстЗапроса;

	ПостроительОтчета.ЗаполнитьНастройки();

	// Создадим список доступных отборов.
	СоответствиеДоступныхОтборов = Новый Соответствие;
	СоответствиеДоступныхОтборов.Вставить("Номенклатура", 0);
	//СоответствиеДоступныхОтборов.Вставить("ХарактеристикаНоменклатуры", 0);
	СоответствиеДоступныхОтборов.Вставить("Склад", 0);

	Для Каждого ДоступноеПоле Из ПостроительОтчета.ДоступныеПоля Цикл
		Если СоответствиеДоступныхОтборов[ДоступноеПоле.Имя] =Неопределено Тогда
			ДоступноеПоле.Отбор = Ложь;
		Иначе
			ДоступноеПоле.Отбор = Истина;
		КонецЕсли;
	КонецЦикла;

	// Создадим массив отборов.
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Номенклатура");
	//МассивОтбора.Добавить("ХарактеристикаНоменклатуры");

	Если ТолькоИмеющиесяВНаличии Тогда
		МассивОтбора.Добавить("Склад");
	КонецЕсли;

	Для Каждого ЭлементОтбора Из МассивОтбора Цикл
		Если ПостроительОтчета.Отбор.Найти(ЭлементОтбора) = Неопределено Тогда
			ПостроительОтчета.Отбор.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;

	// Вызовем стандартную процедуру заполнения представлений.
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);

КонецПроцедуры // ЗаполнитьПостроительОтчета()

// Процедура перезаполняет цены в табличной части.
//
Процедура ПерезаполнитьЦены() Экспорт

	СтруктураЗначений = Новый Структура;
	СтруктураЗначений.Вставить("НовыйТипЦен", ТипЦен);

	ЗапросПоЦенам = Ценообразование.СформироватьЗапросПоЦенам(СтруктураЗначений,
	   Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры,
	   Товары.ВыгрузитьКолонку("Номенклатура"),
	   РабочаяДата,
	   Неопределено).Выгрузить();
	ЗапросПоЦенам.Индексы.Добавить("Номенклатура");

	//ПустаяХарактеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	ТипЦенРассчитывается = ТипЦен.Рассчитывается;

	СтруктураКурса = МодульВалютногоУчета.ПолучитьКурсВалюты(Валюта, РабочаяДата);
	Курс = СтруктураКурса.Курс;
	Кратность = СтруктураКурса.Кратность;

	Для Каждого СтрокаТовара Из Товары Цикл
		//ХарактеристикаНоменклатуры = СтрокаТовара.ХарактеристикаНоменклатуры;

		СтруктураПоиска = Новый Структура("Номенклатура", СтрокаТовара.Номенклатура);

		СтрокиЦен = ЗапросПоЦенам.НайтиСтроки(СтруктураПоиска);

		СтрокаБезХарактеристики = Неопределено;
		СтрокаСХарактеристикой = Неопределено;

		Для Каждого СтрокаЦен Из СтрокиЦен Цикл
			//Если СтрокаЦен.ХарактеристикаНоменклатуры = ПустаяХарактеристика Тогда
				СтрокаБезХарактеристики = СтрокаЦен;
			//ИначеЕсли СтрокаЦен.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры Тогда
			//	СтрокаСХарактеристикой = СтрокаЦен;
			//КонецЕсли;
		КонецЦикла;

		//Если СтрокаСХарактеристикой <> Неопределено Тогда
		//	НайденнаяСтрока = СтрокаСХарактеристикой;
		//ИначеЕсли СтрокаБезХарактеристики <> Неопределено Тогда
			НайденнаяСтрока = СтрокаБезХарактеристики;
		//Иначе
		//	НайденнаяСтрока = Неопределено;
		//КонецЕсли;

		Если (НайденнаяСтрока <> Неопределено) И (НайденнаяСтрока.Цена <> 0) Тогда
			Цена = НайденнаяСтрока.Цена * (1 + ?(ТипЦенРассчитывается, НайденнаяСтрока.ПроцентСкидкиНаценки / 100, 0));
			Цена = Ценообразование.ОкруглитьЦену(Цена, ТипЦен.ПорядокОкругления, ТипЦен.ОкруглятьВБольшуюСторону);
			Цена = Ценообразование.ПересчитатьЦенуПриИзмененииВалюты(Цена, НайденнаяСтрока.ВалютаЦены, Валюта, Курс, Кратность);

			СтрокаТовара.ЕдиницаИзмерения = НайденнаяСтрока.ЕдиницаИзмеренияЦены;
		Иначе
			Цена = 0;
		КонецЕсли;

		СтрокаТовара.Цена = Цена;
	КонецЦикла;

КонецПроцедуры // ПерезаполнитьЦены()

// Функция формирует табличный документ - печатная форма ценника.
//
// Возвращаемое значение:
//  ТабличныйДокумент - сформированный табличный документ или Неопределено, если есть ошибки.
//
Функция ПечатьЦенника() Экспорт

	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Предупреждение("Не выбрана организация!");
		Возврат Неопределено;
	КонецЕсли;

	ТабДокумент                     = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Ценник";
	Макет                           = ПолучитьМакет("Ценник");
	ОбластьЦенника                  = Макет.ПолучитьОбласть("Строка|Столбец");

	ДатаПечати = РабочаяДата;

	ТекСтолбец = 0;
	ТекСтрока  = 0;

	Для Каждого СтрокаТаблицы Из Товары Цикл
		Если СтрокаТаблицы.Печать Тогда
			Для Тмп = 1 По СтрокаТаблицы.Количество Цикл
				ОбластьЦенника.Параметры.Заполнить(СтрокаТаблицы);
				ОбластьЦенника.Параметры.НоменклатураНаименование        = СтрокаТаблицы.Номенклатура.НаименованиеПолное;
				//ОбластьЦенника.Параметры.ХарактеристикаНаименование      = СтрокаТаблицы.ХарактеристикаНоменклатуры;
				ОбластьЦенника.Параметры.ЕдиницаНаименование             = СтрокаТаблицы.ЕдиницаИзмерения;
				ОбластьЦенника.Параметры.Цена                            = ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.Цена, Валюта, "00");
				ОбластьЦенника.Параметры.ДатаПечати                      = ДатаПечати;
				ОбластьЦенника.Параметры.Организация                     = Организация;
				ОбластьЦенника.Параметры.ОрганизацияНаименование         = Организация;
				ОбластьЦенника.Параметры.НоменклатураСтранаПроисхождения = СтрокаТаблицы.Номенклатура.СтранаПроисхождения;

				Если ТекСтолбец = 0 Тогда
					ТабДокумент.Вывести(ОбластьЦенника);
				Иначе
					ТабДокумент.Присоединить(ОбластьЦенника);
				КонецЕсли;

				ТекСтолбец = ТекСтолбец + 1;

				Если ТекСтолбец = 5 Тогда
					ТекСтрока  = ТекСтрока + 1;
					ТекСтолбец = 0;
				КонецЕсли;

				Если ТекСтрока = 3 Тогда
					ТекСтрока = 0;
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	ТабДокумент.ТолькоПросмотр = Истина;

	Возврат ТабДокумент;

КонецФункции // ПечатьЦенника()

// Функция выполняет проверку параметров для заполнения цен.
//
// Возвращаемое значение:
//  Булево - Истина, если все параметры заданы.
//
Функция ПроверитьПараметрыЗаполненияЦен(ПечетьБезПроверкиЗаполненияПараметров = Неопределено) Экспорт

	Перем РезультатПроверки, СтрокаСообщения;

	РезультатПроверки = Истина;
	СтрокаСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда
		РезультатПроверки = Ложь;
		СтрокаСообщения = "Не выбран тип цен! Укажите тип цен и повторите перезаполнение цен." + Символы.ПС;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		РезультатПроверки = Ложь;
		СтрокаСообщения = СтрокаСообщения + "Не выбрана валюта!  Укажите валюту и повторите перезаполнение цен.";
	КонецЕсли;

	Если НЕ РезультатПроверки И ПечетьБезПроверкиЗаполненияПараметров <> Истина Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения);
	КонецЕсли;
	Возврат РезультатПроверки;

КонецФункции // ПроверитьПараметрыЗаполненияЦен()

#КонецЕсли

