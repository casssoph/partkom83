﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)

	// Описание исходного текста запроса.
	ТекстЗапроса =
	 "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	 |	РезервыТоваровОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
	 |	РезервыТоваровОстаткиИОбороты.Склад КАК Склад,
	 |	РезервыТоваровОстаткиИОбороты.Качество КАК Качество,
	 |	РезервыТоваровОстаткиИОбороты.Склад.Филиал КАК Филиал,
	 |	ПРЕДСТАВЛЕНИЕ(РезервыТоваровОстаткиИОбороты.Склад),
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	 |	НАЧАЛОПЕРИОДА(РезервыТоваровОстаткиИОбороты.Период, ГОД) КАК ПериодГод
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	 |{ВЫБРАТЬ
	 |	КоличествоНачальныйОстаток,
	 |	КоличествоКонечныйОстаток,
	 |	КоличествоПриход,
	 |	КоличествоРасход,
	 |	Склад.* КАК Склад,
	 |	Качество.*,
	 |	Филиал.* КАК Филиал,
	 |	РезервыТоваровОстаткиИОбороты.Регистратор.*,
	 |	ПериодДень,
	 |	ПериодНеделя,
	 |	ПериодДекада,
	 |	ПериодМесяц,
	 |	ПериодКвартал,
	 |	ПериодПолугодие,
	 |	ПериодГод
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}
	 |ИЗ
	 |	РегистрНакопления.РезервыТоваров.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ) КАК РезервыТоваровОстаткиИОбороты
	|//СОЕДИНЕНИЯ
	 |{ГДЕ
	 |	РезервыТоваровОстаткиИОбороты.КоличествоНачальныйОстаток,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоКонечныйОстаток,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоПриход,
	 |	РезервыТоваровОстаткиИОбороты.КоличествоРасход,
	 |	РезервыТоваровОстаткиИОбороты.Склад.* КАК Склад,
	 |	РезервыТоваровОстаткиИОбороты.Качество.*,
	 |	РезервыТоваровОстаткиИОбороты.Склад.Филиал.* КАК Филиал,
	 |	РезервыТоваровОстаткиИОбороты.Регистратор.*,
	 |	РезервыТоваровОстаткиИОбороты.ПериодДень,
	 |	РезервыТоваровОстаткиИОбороты.ПериодНеделя,
	 |	РезервыТоваровОстаткиИОбороты.ПериодДекада,
	 |	РезервыТоваровОстаткиИОбороты.ПериодМесяц,
	 |	РезервыТоваровОстаткиИОбороты.ПериодКвартал,
	 |	РезервыТоваровОстаткиИОбороты.ПериодПолугодие,
	 |	РезервыТоваровОстаткиИОбороты.ПериодГод
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}
	 |{УПОРЯДОЧИТЬ ПО
	 |	Склад.* КАК Склад,
	 |	Качество.*,
	 |	Филиал.* КАК Филиал,
	 |	РезервыТоваровОстаткиИОбороты.Регистратор.*,
	 |	ПериодДень,
	 |	ПериодНеделя,
	 |	ПериодДекада,
	 |	ПериодМесяц,
	 |	ПериодКвартал,
	 |	ПериодПолугодие,
	 |	ПериодГод,
	 |	КоличествоНачальныйОстаток,
	 |	КоличествоКонечныйОстаток,
	 |	КоличествоПриход,
	 |	КоличествоРасход
	 |	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	 |ИТОГИ
	 |	СУММА(КоличествоНачальныйОстаток),
	 |	СУММА(КоличествоКонечныйОстаток),
	 |	СУММА(КоличествоПриход),
	 |	СУММА(КоличествоРасход)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	 |ПО
	 |	ОБЩИЕ
	 |{ИТОГИ ПО
	 |	Склад.* КАК Склад,
	 |	Качество.*,
	 |	Филиал.* КАК Филиал,
	 |	РезервыТоваровОстаткиИОбороты.Регистратор.*,
	 |	ПериодДень,
	 |	ПериодНеделя,
	 |	ПериодДекада,
	 |	ПериодМесяц,
	 |	ПериодКвартал,
	 |	ПериодПолугодие,
	 |	ПериодГод
	 |	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ}
|";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РезервыТоваровОстаткиИОбороты.Склад", "Склад", "Склад", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РезервыТоваровОстаткиИОбороты.Склад.Филиал", "Филиал", "Филиал", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Филиалы);
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
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТорговаяТочка", "Торговая точка");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СостояниеСтрокиЗаявки", "Состояние строки заявки");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Склад", "Склад");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Качество", "Качество");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Филиал", "Филиал");
	
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРеглНачальныйОстаток", "Сумма начальный остаток");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРеглКонечныйОстаток", "Сумма конечный остаток");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРеглПриход", "Сумма взаиморасчетов приход");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРеглРасход", "Сумма взаиморасчетов расход");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриход", "Приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасход", "Расход");
	
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрНачальныйОстаток", "Сумма валютная начальный остаток");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрКонечныйОстаток", "Сумма валютная конечный остаток");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрПриход", "Сумма валютная приход");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрРасход", "Сумма валютная расход");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаВзаиморасчетов", "Валюта взаиморасчетов");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглКонечныйОстаток", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглПриход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРеглРасход",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаЗаявки", "Сумма заявки");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "Количество", "Количество");
	
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная" );
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток", "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма валютная");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Склад");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Филиал");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СтрокаЗаявки");
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
