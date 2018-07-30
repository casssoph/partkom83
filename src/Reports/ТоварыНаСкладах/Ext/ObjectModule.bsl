﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)

	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток, 0) КАК КоличествоНачальныйОстаток,
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток, 0) КАК КоличествоКонечныйОстаток,
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоПриход, 0) КАК КоличествоПриход,";
	Если Не ЦеныИзЦенообразования Тогда 
		ТекстЗапроса = ТекстЗапроса +"
		|	ЕСТЬNULL(ПартииТоваровОбороты.СуммаРублиПриход, 0) КАК СебестоимостьПриход,";
	Иначе 
		ТекстЗапроса = ТекстЗапроса +"
		|	ЕСТЬNULL((ЦеныНоменклатурыСрезПоследних.Цена * ТоварыНаСкладахОстаткиИОбороты.КоличествоПриход), 0) КАК СебестоимостьПриход,";
	КонецЕсли;	 
	ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоРасход, 0) КАК КоличествоРасход,";
	Если Не ЦеныИзЦенообразования Тогда 
		ТекстЗапроса = ТекстЗапроса +"
		|	ЕСТЬNULL(ПартииТоваровОбороты.СуммаРублиРасход, 0) КАК СебестоимостьРасход,";
	Иначе 
		ТекстЗапроса = ТекстЗапроса +"
		|	ЕСТЬNULL((ЦеныНоменклатурыСрезПоследних.Цена * ТоварыНаСкладахОстаткиИОбороты.КоличествоРасход), 0) КАК СебестоимостьРасход,";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса +"
	|	ТоварыНаСкладахОстаткиИОбороты.Склад КАК Склад,
	|	ТоварыНаСкладахОстаткиИОбороты.Качество КАК Качество,
	|	ПРЕДСТАВЛЕНИЕ(ТоварыНаСкладахОстаткиИОбороты.Склад),
	|	ТоварыНаСкладахОстаткиИОбороты.Регистратор,
	|	ТоварыНаСкладахОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(ТоварыНаСкладахОстаткиИОбороты.Период, ГОД) КАК ПериодГод,
	|	ТоварыНаСкладахОстаткиИОбороты.Склад.Филиал КАК Филиал
	|{ВЫБРАТЬ
	|	КоличествоНачальныйОстаток,
	|	КоличествоКонечныйОстаток,
	|	КоличествоПриход,
	|	СебестоимостьПриход,
	|	КоличествоРасход,
	|	СебестоимостьРасход,
	|	Номенклатура.*,
	|	Склад.*,
	|	Качество.*,
	|	Регистратор.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Филиал.* КАК Филиал}
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ) КАК ТоварыНаСкладахОстаткиИОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваров.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ПартииТоваровОбороты
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаНач, ) КАК ЦеныНоменклатурыСрезПоследних
	|			ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = ПартииТоваровОбороты.Номенклатура)
	|		ПО ТоварыНаСкладахОстаткиИОбороты.Регистратор = ПартииТоваровОбороты.Регистратор
	|			И ТоварыНаСкладахОстаткиИОбороты.Номенклатура = ПартииТоваровОбороты.Номенклатура
	|			И ТоварыНаСкладахОстаткиИОбороты.Склад = ПартииТоваровОбороты.Склад
	
	|{ГДЕ
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток, 0) КАК КоличествоНачальныйОстаток,
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток, 0) КАК КоличествоКонечныйОстаток,
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоПриход, 0) КАК КоличествоПриход,";
	Если Не ЦеныИзЦенообразования Тогда 
		ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL(ПартииТоваровОбороты.СуммаРублиПриход, 0) КАК СебестоимсотьПриход,";
	Иначе 
		ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL((ЦеныНоменклатурыСрезПоследних.Цена * ТоварыНаСкладахОстаткиИОбороты.КоличествоПриход), 0) КАК СебестоимсотьПриход,";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL(ТоварыНаСкладахОстаткиИОбороты.КоличествоРасход, 0) КАК КоличествоРасход,";
	Если Не ЦеныИзЦенообразования Тогда 
		ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL(ПартииТоваровОбороты.СуммаРублиРасход, 0) КАК СебестоимостьРасход,";
	Иначе 
		ТекстЗапроса = ТекстЗапроса +"
	|	ЕСТЬNULL((ЦеныНоменклатурыСрезПоследних.Цена * ТоварыНаСкладахОстаткиИОбороты.КоличествоРасход), 0) КАК СебестоимостьРасход,";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса +"
	|	ТоварыНаСкладахОстаткиИОбороты.Склад.*,
	|	ТоварыНаСкладахОстаткиИОбороты.Качество.*,
	|	ТоварыНаСкладахОстаткиИОбороты.Регистратор.*,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодДень,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодНеделя,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодДекада,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодМесяц,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодКвартал,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодПолугодие,
	|	ТоварыНаСкладахОстаткиИОбороты.ПериодГод,
	|	ТоварыНаСкладахОстаткиИОбороты.Номенклатура.* КАК Номенклатура,
	|	ТоварыНаСкладахОстаткиИОбороты.Склад.Филиал.* КАК Филиал}
	|{УПОРЯДОЧИТЬ ПО
	|	Склад.*,
	|	Качество.*,
	|	Регистратор.*,
	|	Номенклатура.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Филиал.* КАК Филиал,
	|	КоличествоНачальныйОстаток,
	|	КоличествоКонечныйОстаток,
	|	КоличествоПриход,
	|	СебестоимостьПриход,
	|	КоличествоРасход,
	|	СебестоимостьРасход}
	|ИТОГИ
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(КоличествоКонечныйОстаток),
	|	СУММА(КоличествоПриход),
	|	СУММА(СебестоимостьПриход),
	|	СУММА(КоличествоРасход),
	|	СУММА(СебестоимостьРасход)
	|ПО
	|	ОБЩИЕ
	|{ИТОГИ ПО
	|	Склад.*,
	|	Качество.*,
	|	Номенклатура.*,
	|	Регистратор.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Филиал.* КАК Филиал}";
	
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ТоварыНаСкладахОстаткиИОбороты.Склад", "Склад", "Склад", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ТоварыНаСкладахОстаткиИОбороты.Склад.Филиал", "Филиал", "Филиал", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Филиалы);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ТоварыНаСкладахОстаткиИОбороты.ЕдиницаИзмерения.Владелец", "Номенклатура", "Номенклатура", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура);
		//УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ЗаявкиПокупателей.ТорговаяТочка", "ТорговаяТочка", "ТорговаяТочка", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ТорговыеТочки);
		//УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ЗаявкиПокупателей.ДоговорКонтрагента", "ДоговорКонтрагента", "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		//УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Сделка", "Сделка", "Сделка", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		//УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.Сделка", "Сделка", "Сделка", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документ_ЗаказПокупателя);
		//УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Взаиморасчеты.ДокументРасчетовСКонтрагентом", "ДокументРасчетовСКонтрагентом", "Документ расчетов с контрагентом", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;

КонецПроцедуры

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	УстановитьТекстЗапроса();
	
	ВалютаУпр = "(" + СокрЛП(глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование) + ")";
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТорговаяТочка", "Торговая точка");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СостояниеСтрокиЗаявки", "Состояние строки заявки");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Филиал", "Филиал");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Качество", "Качество");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Склад", "Склад");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриход", "Приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СебестоимостьПриход", "Себестоимость приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасход", "Расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СебестоимостьРасход", "Себестоимость расход");
	
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглКонечныйОстаток",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "нач. остаток, шт.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход", "приход, шт.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("СебестоимостьПриход",  "Себестоимость приход, руб.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход", "расход, шт.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("СебестоимостьРасход",  "Себестоимость расход, руб.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток",  "кон. остаток, шт.", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная" );
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток", "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Склад");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Качество");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Филиал");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТорговаяТочка");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокументРасчетовСКонтрагентом");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	 //|	ЗаявкиПокупателей.Склад Как Склад,
	 //|	ЗаявкиПокупателей.Качество Как Качество,
	 //|	ЗаявкиПокупателей.СтрокаЗаявки Как СтрокаЗаявки,
	 //|	ЗаявкиПокупателей.СостояниеСтрокиЗаявки Как СостояниеСтрокиЗаявки,
	 //|	ЗаявкиПокупателей.ТорговаяТочка как ТорговаяТочка,
	
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Склад");
	//УниверсальныйОтчет.ДобавитьОтбор("Филиал");
	//УниверсальныйОтчет.ДобавитьОтбор("СтрокаЗаявки");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	//УниверсальныйОтчет.УстановитьСвязьПолей("ВалютаВзаиморасчетов", "ДоговорКонтрагента");
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаВзаиморасчетов");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формированием отчета можно установить необходимые параметры универсального отчета
	
	ЕстьПолеРегистратор = Ложь;
	Для каждого ВыбранноеПоле Из УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля Цикл
	
		ЕстьПолеРегистратор = Найти(ВыбранноеПоле.ПутьКДанным, "Регистратор") > 0;
		Если ЕстьПолеРегистратор Тогда
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	НастройкиПостроителя = УниверсальныйОтчет.ПостроительОтчета.ПолучитьНастройки(); 
	УстановитьТекстЗапроса(ЕстьПолеРегистратор);
	УниверсальныйОтчет.ПостроительОтчета.УстановитьНастройки(НастройкиПостроителя); 
	
	Если ЕстьПолеРегистратор Тогда
		
		НетГруппировкиПоДоговору = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ДоговорКонтрагента") = Неопределено;
		Если НетГруппировкиПоДоговору Тогда
		
			НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент");
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Организация");
			КонецЕсли;
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ВалютаВзаиморасчетов");
			КонецЕсли;
			
			Если НужноеИзмерение = Неопределено Тогда
				ИндексДоговора = 0;
			Иначе
				ИндексДоговора = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Индекс(НужноеИзмерение) + 1;
			КонецЕсли;
				
			УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Вставить("ДоговорКонтрагента", , , , , ИндексДоговора);
		
		КонецЕсли;
	
	КонецЕсли;
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);

КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
