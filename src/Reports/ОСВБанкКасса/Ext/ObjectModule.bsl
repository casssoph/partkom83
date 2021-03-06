﻿#Если Клиент Тогда
// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)

	// Описание исходного текста запроса.
	ТекстЗапроса = "";
//	 "ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	 |	ДенежныеСредстваОстаткиИОбороты.Регистратор,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
//	 |	НАЧАЛОПЕРИОДА(ДенежныеСредстваОстаткиИОбороты.Период, ГОД) КАК ПериодГод,
//	 |	ДенежныеСредстваОстаткиИОбороты.ВидДенежныхСредств,
//	 |	ДенежныеСредстваОстаткиИОбороты.БанковскийСчетКасса,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаПриход КАК СуммаПриход,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаРасход КАК СуммаРасход,
//	 |	ВЫРАЗИТЬ(ДенежныеСредстваОстаткиИОбороты.БанковскийСчетКасса.Владелец КАК Справочник.Организации) КАК Организация,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаОборот КАК СуммаОборот
//	|	//ПОЛЯ_СВОЙСТВА
//	|	//ПОЛЯ_КАТЕГОРИИ
//	 |{ВЫБРАТЬ
//	 |	Регистратор.*,
//	 |	ПериодДень,
//	 |	ПериодНеделя,
//	 |	ПериодДекада,
//	 |	ПериодМесяц,
//	 |	ПериодКвартал,
//	 |	ПериодПолугодие,
//	 |	ПериодГод,
//	 |	Организация.*,
//	 |	ВидДенежныхСредств.*,
//	 |	БанковскийСчетКасса.*,
//	 |	СуммаНачальныйОстаток,
//	 |	СуммаКонечныйОстаток,
//	 |	СуммаПриход,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаРасход,
//	 |	СуммаОборот
//	|	//ПСЕВДОНИМЫ_СВОЙСТВА
//	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
//		|}
//	 |ИЗ
//	 |	РегистрНакопления.ДенежныеСредства.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {(&Периодичность)}, , ) КАК ДенежныеСредстваОстаткиИОбороты
//	|//СОЕДИНЕНИЯ
//	 |{ГДЕ
//	 |	ДенежныеСредстваОстаткиИОбороты.Регистратор.*,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодДень,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодНеделя,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодДекада,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодМесяц,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодКвартал,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодПолугодие,
//	 |	ДенежныеСредстваОстаткиИОбороты.ПериодГод,
//	 |	ВЫРАЗИТЬ(ДенежныеСредстваОстаткиИОбороты.БанковскийСчетКасса.Владелец КАК Справочник.Организации) КАК Организация,
//	 |	ДенежныеСредстваОстаткиИОбороты.БанковскийСчетКасса.*,
//	 |	ДенежныеСредстваОстаткиИОбороты.ВидДенежныхСредств.*,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаПриход КАК СуммаПриход,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаРасход КАК СуммаРасход,
//	 |	ДенежныеСредстваОстаткиИОбороты.СуммаОборот
//	|	//УСЛОВИЯ_СВОЙСТВА
//	|	//УСЛОВИЯ_КАТЕГОРИИ
//	|}
//	 |{УПОРЯДОЧИТЬ ПО
//	 |	Регистратор.*,
//	 |	ПериодДень,
//	 |	ПериодНеделя,
//	 |	ПериодДекада,
//	 |	ПериодМесяц,
//	 |	ПериодКвартал,
//	 |	ПериодПолугодие,
//	 |	ПериодГод,
//	 |	ВидДенежныхСредств.*,
//	 |	БанковскийСчетКасса.*,
//	 |	Организация.*
//	 |	СуммаНачальныйОстаток,
//	 |	СуммаКонечныйОстаток,
//	 |	СуммаПриход,
//	 |	СуммаРасход,
//	 |	СуммаОборот
//	 |	//ПСЕВДОНИМЫ_СВОЙСТВА
//	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
//	|}
//	 |ИТОГИ
//	 |	СУММА(СуммаНачальныйОстаток),
//	 |	СУММА(СуммаКонечныйОстаток),
//	 |	СУММА(СуммаПриход),
//	 |	СУММА(СуммаРасход),
//	 |	СУММА(СуммаОборот)
//	|	//ИТОГИ_СВОЙСТВА
//	|	//ИТОГИ_КАТЕГОРИИ
//	 |ПО
//	 |	ОБЩИЕ
//	 |{ИТОГИ ПО
//	 |	Регистратор.*,
//	 |	ПериодДень,
//	 |	ПериодНеделя,
//	 |	ПериодДекада,
//	 |	ПериодМесяц,
//	 |	ПериодКвартал,
//	 |	ПериодПолугодие,
//	 |	ПериодГод,
//	 |	Организация.*,
//	 |	ВидДенежныхСредств.*,
//	 |	БанковскийСчетКасса.*
//	 |	//ПСЕВДОНИМЫ_СВОЙСТВА
//	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ}
//|";

	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ДенежныеСредстваОстаткиИОбороты.БанковскийСчетКасса.Владелец", "Организация", "Организация", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации);
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
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета по метаданным регистра накопления
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
	//УниверсальныйОтчет.ИмяРегистра = "ДенежныеСредства";
	
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
	
	
	УстановитьТекстЗапроса();

	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДвижениеДенежныхСредствЦФО", "Центр финансовой ответственности");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДвижениеДенежныхСредствРегион", "Регион");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатьяДвиженияДенежныхСредств", "Статьи движения ден.средств");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументРасчетовСКонтрагентом", "Документ расчетов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВидДенежныхСредств", "Вид денежных средств");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("БанковскийСчетКасса", "Счет/касса");

	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаНачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаКонечныйОстаток", "Конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаПриход", "Приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРасход", "Расход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаОборот", "Оборот");

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
	
	//УниверсальныйОтчет.ДобавитьПолеГруппировка("Организация",           "БанковскийСчетКасса", "Владелец",              "Организация");
	УниверсальныйОтчет.ДобавитьПолеГруппировка("ВалютаДенежныхСредств", "БанковскийСчетКасса", "ВалютаДенежныхСредств", "Валюта счета (кассы)");
	
	// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаПриход",           "Приход",            Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаРасход",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаКонечныйОстаток",  "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	
	//ВалютаУпр = глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование;
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход",           "Приход",            Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток",  "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("БанковскийСчетКасса");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ПериодДень");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Регистратор");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("БанковскийСчетКасса");
	УниверсальныйОтчет.ДобавитьОтбор("ВидДенежныхСредств");
	УниверсальныйОтчет.ДобавитьОтбор("ВалютаДенежныхСредств");
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаДенежныхСредств");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВидДенежныхСредств");
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);

КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
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