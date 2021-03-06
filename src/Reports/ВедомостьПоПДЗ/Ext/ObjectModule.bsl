﻿#Если Клиент Тогда
// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)
	УниверсальныйОтчет.ДатаНач = ТекущаяДата();
	УниверсальныйОтчет.ДатаКон = ТекущаяДата();
	Неиспользуемые = Справочники.Контрагенты.НайтиПоНаименованию("яНеиспользуемые");
	ДатаКон = УниверсальныйОтчет.ДатаКон;
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаКонца",УниверсальныйОтчет.ДатаКон);	// Описание исходного текста запроса.
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Неиспользуемые",Неиспользуемые);	// Описание исходного текста запроса.
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СуммаОтбораДолга",СуммаОтбораДолга);	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МенеджерыТорговыхТочекСрезПоследних.Менеджер,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.Организация КАК Организация,
	|	РАЗНОСТЬДАТ(&ДатаКонца, ВзаиморасчетыОстатки.ДокументРасчетов.ДатаОплаты, ДЕНЬ) * -1 КАК Просрочка,
	|	ВзаиморасчетыОстатки.ДокументРасчетов.ДатаОплаты Как ДатаОплаты,
	|	ВзаиморасчетыОстатки.ДокументРасчетов,
	|	ВзаиморасчетыОстатки.СуммаУпрОстаток КАК Остаток,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.ВидДоговора
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|{ВЫБРАТЬ
	|	Менеджер.*,
	|	ДоговорКонтрагента.*,
	|	Контрагент.*,
	|	Организация.*,
	|	Просрочка,
	|	ДатаОплаты,
	|	Остаток,
	|	ДокументРасчетов.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИЗ
	|	РегистрНакопления.Взаиморасчеты.Остатки(&ДатаКон, ) КАК ВзаиморасчетыОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МенеджерыТорговыхТочек.СрезПоследних(&ДатаКон, ) КАК МенеджерыТорговыхТочекСрезПоследних
	|		ПО ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец.ОсновнаяТорговаяТочка.Ссылка = МенеджерыТорговыхТочекСрезПоследних.ТорговаяТочка.Ссылка
	|//СОЕДИНЕНИЯ
	|ГДЕ
	|	МенеджерыТорговыхТочекСрезПоследних.ВидМенеджера = ЗНАЧЕНИЕ(Перечисление.ВидыМенеджеров.Продажи)
	|	И ВзаиморасчетыОстатки.ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|	И НЕ ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец В ИЕРАРХИИ (&Неиспользуемые)
	|	И ВзаиморасчетыОстатки.ДокументРасчетов.ДатаОплаты < &ДатаКонца
	|	И ВзаиморасчетыОстатки.СуммаУпрОстаток >= &СуммаОтбораДолга
	|{ГДЕ
	|	МенеджерыТорговыхТочекСрезПоследних.Менеджер.*,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.*,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец.* КАК Контрагент,
	|	ВзаиморасчетыОстатки.ДоговорКонтрагента.Организация.* КАК Организация,
	|	(РАЗНОСТЬДАТ(&ДатаКон, ВзаиморасчетыОстатки.ДокументРасчетов.ДатаОплаты, ДЕНЬ)) КАК Просрочка,
	|	ВзаиморасчетыОстатки.СуммаУпрОстаток КАК Остаток,
	|	ВзаиморасчетыОстатки.ДокументРасчетов.*
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО
	|	Менеджер.*,
	|	ДоговорКонтрагента.*,
	|	Контрагент.*,
	|	Организация.*,
	|	Просрочка,
	|	Остаток,
	|	ДатаОплаты,
	|	ДокументРасчетов.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|}
	|ИТОГИ
	|	МАКСИМУМ(Просрочка),
	|	МИНИМУМ(ДатаОплаты),
	|	СУММА(Остаток)
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|{ИТОГИ ПО
	|	Менеджер.*,
	|	ДоговорКонтрагента.*,
	|	Контрагент.*,
	|	Организация.*,
	|	ДокументРасчетов.*
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ}
	|";
	
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ВзаиморасчетыОстатки.ДоговорКонтрагента.Организация", "Организация", "Организация", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец", "Контрагент", "Контрагент", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("ВзаиморасчетыОстатки.ДоговорКонтрагента", "ДоговорКонтрагента", "Договор контрагента", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДоговорыКонтрагентов);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("МенеджерыТорговыхТочекСрезПоследних.Менеджер", "Менеджер", "Менеджер", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Менеджеры);
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
	УниверсальныйОтчет.ИмяРегистра = "Взаиморасчеты";
	
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

	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Организация", "Организация");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Контрагент", "Контрагент");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Менеджер", "Менеджер");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументРасчетов", "Кредитный документ");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаОплаты", "Дата оплаты");

	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаНачальныйОстаток", "Начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Остаток", "Конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Просрочка", "Просрочено дней");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаОплаты", "Дата оплаты");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаРегистрации", "Приход");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВыбытия", "Расход");
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
	//УниверсальныйОтчет.ДобавитьПолеГруппировка("ВалютаДенежныхСредств", "БанковскийСчетКасса", "ВалютаДенежныхСредств", "Валюта счета (кассы)");
	
	// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаПриход",           "Приход",            Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРасход",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаКонечныйОстаток",  "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=2", "Сумма", "Сумма в валюте счета (кассы)");
	
	//ВалютаУпр = глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование;
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
   //Процедура ДобавитьПоказатель(ИмяПоля, ПредставлениеПоля = Неопределено, ВключенПоУмолчанию = Неопределено, ФорматнаяСтрока = Неопределено, ИмяГруппы = Неопределено, ПредставлениеГруппы = Неопределено, Ширина = 0) Экспорт
	УниверсальныйОтчет.ДобавитьПоказатель("Остаток",           "Сумма Долга",            Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Долг");
	УниверсальныйОтчет.ДобавитьПоказатель("Просрочка",           "Просрочено дней",            Истина,"ДЛФ=Д" , "СуммаУпр", "Долг");
	УниверсальныйОтчет.ДобавитьПоказатель("ДатаОплаты",           "Дата оплаты",            Истина,"ДЛФ=Д" , "СуммаУпр", "Долг");
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаВыбытия",           "Расход",            Истина, "ЧЦ=15; ЧДЦ=2", "Дата1", "Регистрация в реестре" );
	//УниверсальныйОтчет.ДобавитьПоказатель("ДатаРегистрации",  		"Дата",  			Истина,"ДЛФ=Д" , "Дата2", "Выбытие из реестра" );
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаРегистрации",  		"Приход",  			Истина, "ЧЦ=15; ЧДЦ=2", "Дата2", "Выбытие из реестра" );
	//УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрОборот",           "Оборот",              Ложь, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма в " + ВалютаУпр);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Менеджер");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокументРасчетов");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	//ДобавитьОтбор(ПутьКДанным, Использование = Неопределено, ВидСравнения = Неопределено, Значение = Неопределено, ЗначениеС = Неопределено, ЗначениеПо = Неопределено, ИспользоватьВБыстрыхОтборах = Истина)
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	//УниверсальныйОтчет.ДобавитьОтбор("ЦФОДляБюджета");
	//УниверсальныйОтчет.ДобавитьОтбор("РегионыДляБюджета");
	УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагента");	
	УниверсальныйОтчет.ДобавитьОтбор("Менеджер");	
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагента.Владелец.ОсновнаяТорговаяТочка.Регион");	
	
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
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаДенежныхСредств");
	//УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВидДенежныхСредств");
	
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
	//УниверсальныйОтчет.ДатаНач = ТекущаяДата();
	//УниверсальныйОтчет.ДатаКон = ТекущаяДата();
	//Неиспользуемые = Справочники.Контрагенты.НайтиПоНаименованию("яНеиспользуемые");
	ДатаКон = УниверсальныйОтчет.ДатаКон;
	
    УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаКонца",УниверсальныйОтчет.ДатаКон);	// Описание исходного текста запроса.
	//УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("Неиспользуемые",Неиспользуемые);	// Описание исходного текста запроса.
    УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СуммаОтбораДолга",СуммаОтбораДолга);	// Описание исходного текста запроса.
	
	
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
УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли