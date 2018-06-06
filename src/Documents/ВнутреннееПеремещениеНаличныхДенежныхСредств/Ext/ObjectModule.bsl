﻿// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мУдалятьДвижения;

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьТаблицуПечатныхФорм()

// Формирует структуру полей, обязательных для заполнения при отражении движения средств.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолей()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("ОрганизацияОтправитель");
	СтруктураПолей.Вставить("ОрганизацияПолучатель");
	СтруктураПолей.Вставить("Касса");
	СтруктураПолей.Вставить("КассаПолучатель");
	СтруктураПолей.Вставить("СуммаДокумента");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует движения по регистрам
// СтруктураКурсыВалют - структура, содержащая курсы необходимых для расчетов валют.
//
Процедура ДвиженияПоРегистрам(СтруктураКурсыВалют)
	
	СуммаУпр = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаДокумента, СтруктураКурсыВалют.ВалютаДокумента,
			СтруктураКурсыВалют.ВалютаУпрУчета, 
			СтруктураКурсыВалют.ВалютаДокументаКурс,
			СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
			СтруктураКурсыВалют.ВалютаДокументаКратность,
			СтруктураКурсыВалют.ВалютаУпрУчетаКратность);
			
	// По регистру "Денежные средства к получению"
	
	ТаблицаДенежныеСредстваКПолучению = Движения.ДенежныеСредстваКПолучению.ВыгрузитьКолонки();

	СтрокаДвижений = ТаблицаДенежныеСредстваКПолучению.Добавить();
	
	СтрокаДвижений.Организация         = ОрганизацияПолучатель;
	СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.СуммаУпр            = СуммаУпр;
	СтрокаДвижений.ДокументПолучения   = Ссылка;
	
	Движения.ДенежныеСредстваКПолучению.мПериод          = Дата;
	Движения.ДенежныеСредстваКПолучению.мТаблицаДвижений = ТаблицаДенежныеСредстваКПолучению;
	Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
	
	// По регистру "Денежные средства к списанию"
	
	ТаблицаДенежныеСредстваКСписанию = Движения.ДенежныеСредстваКСписанию.ВыгрузитьКолонки();

	СтрокаДвижений = ТаблицаДенежныеСредстваКСписанию.Добавить();
	
	СтрокаДвижений.Организация         = ОрганизацияОтправитель;
	СтрокаДвижений.БанковскийСчетКасса = Касса;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.ДокументСписания    = Ссылка;
	
	Движения.ДенежныеСредстваКСписанию.мПериод          = Дата;
	Движения.ДенежныеСредстваКСписанию.мТаблицаДвижений = ТаблицаДенежныеСредстваКСписанию;
	Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
							
	Если Оплачено Тогда
		
		// По регистру "Денежные средства"
		
		ТаблицаДенежныеСредства = Движения.ДенежныеСредства.ВыгрузитьКолонки();

		СтрокаДвижений = ТаблицаДенежныеСредства.Добавить();
		
		СтрокаДвижений.Организация         = ОрганизацияОтправитель;
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Расход;
		СтрокаДвижений.Период              = Дата;
		
		СтрокаДвижений = ТаблицаДенежныеСредства.Добавить();
		
		СтрокаДвижений.Организация         = ОрганизацияПолучатель;
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Приход;
		СтрокаДвижений.Период              = Дата;

		Движения.ДенежныеСредства.мТаблицаДвижений = ТаблицаДенежныеСредства;
		Движения.ДенежныеСредства.ВыполнитьДвижения();
		
		// По регистру "Денежные средства к получению"
		
		ТаблицаДенежныеСредстваКПолучению = Движения.ДенежныеСредстваКПолучению.ВыгрузитьКолонки();

		СтрокаДвижений = ТаблицаДенежныеСредстваКПолучению.Добавить();
		
		СтрокаДвижений.Организация         = ОрганизацияПолучатель;
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр            = СуммаУпр;
        СтрокаДвижений.ДокументПолучения   = Ссылка;
		
		Движения.ДенежныеСредстваКПолучению.мПериод          = Дата;
		Движения.ДенежныеСредстваКПолучению.мТаблицаДвижений = ТаблицаДенежныеСредстваКПолучению;
		Движения.ДенежныеСредстваКПолучению.ВыполнитьРасход();
		
		// По регистру "Денежные средства к списанию"
		
		ТаблицаДенежныеСредстваКСписанию = Движения.ДенежныеСредстваКСписанию.ВыгрузитьКолонки();

		СтрокаДвижений = ТаблицаДенежныеСредстваКСписанию.Добавить();
		
		СтрокаДвижений.Организация         = ОрганизацияОтправитель;
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
        СтрокаДвижений.ДокументСписания    = Ссылка;
		
		Движения.ДенежныеСредстваКСписанию.мПериод          = Дата;
		Движения.ДенежныеСредстваКСписанию.мТаблицаДвижений = ТаблицаДенежныеСредстваКСписанию;
		Движения.ДенежныеСредстваКСписанию.ВыполнитьРасход();
		
		// По регистру "Движения денежных средств"
		
		ТаблицаДвиженияДенежныхСредств = Движения.ДвиженияДенежныхСредств.ВыгрузитьКолонки();
		
		СтрокаДвижение = ТаблицаДвиженияДенежныхСредств.Добавить();
		
		СтрокаДвижение.ВидДенежныхСредств            = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижение.ПриходРасход                  = Перечисления.ВидыДвиженийПриходРасход.Расход;
		СтрокаДвижение.БанковскийСчетКасса           = Касса;
		СтрокаДвижение.Организация                   = Касса.Владелец;
		СтрокаДвижение.ДокументДвижения              = Ссылка;
		СтрокаДвижение.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		СтрокаДвижение.Сумма                         = СуммаДокумента;
		СтрокаДвижение.СуммаУпр                      = СуммаУпр;
		
		СтрокаДвижение = ТаблицаДвиженияДенежныхСредств.Добавить();
		
		СтрокаДвижение.ВидДенежныхСредств            = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижение.ПриходРасход                  = Перечисления.ВидыДвиженийПриходРасход.Приход;
		СтрокаДвижение.БанковскийСчетКасса           = КассаПолучатель;
		СтрокаДвижение.Организация 	                 = КассаПолучатель.Владелец;
		СтрокаДвижение.ДокументДвижения              = Ссылка;
		СтрокаДвижение.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		СтрокаДвижение.Сумма                         = СуммаДокумента;
		СтрокаДвижение.СуммаУпр                      = СуммаУпр;
		
		Движения.ДвиженияДенежныхСредств.мПериод          = КонецДня(Дата);
		Движения.ДвиженияДенежныхСредств.мТаблицаДвижений = ТаблицаДвиженияДенежныхСредств;
		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
		
	КонецЕсли;
			
КонецПроцедуры// ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);
	
	СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей(), Отказ, Заголовок);
	
	// Проверяем соответствие организаций - отправителя и получателя,
	// если хотя бы одна организация отражается в регл.учете
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеремещениеДенег.Ссылка
	|ИЗ
	|	Документ.ВнутреннееПеремещениеНаличныхДенежныхСредств КАК ПеремещениеДенег
	|ГДЕ
	|	ПеремещениеДенег.Ссылка = &Ссылка
	|	И (ПеремещениеДенег.ОрганизацияОтправитель.ОтражатьВРегламентированномУчете
	|			ИЛИ ПеремещениеДенег.ОрганизацияПолучатель.ОтражатьВРегламентированномУчете)
	|	И ПеремещениеДенег.ОрганизацияОтправитель <> ПеремещениеДенег.ОрганизацияПолучатель";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ОрганизацииНеСовпадают = НЕ Запрос.Выполнить().Пустой();
	
	Если ОрганизацииНеСовпадают Тогда
		ТекстСообщения = "Перемещения наличных между разными организациями, если хотя бы одна из них отражается в регламентированном учете,
		|	следует оформлять парой документов ""Приходный кассовый ордер"" и ""Расходный кассовый ордер""";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
	КонецЕсли;
		
	Если НЕ Отказ И НЕ Оплачено И РежимПроведения=РежимПроведенияДокумента.Оперативный Тогда
		
		// Проверяем остаток доступных денежных средств
		СвободныйОстаток = УправлениеДенежнымиСредствами.ПолучитьСвободныйОстатокДС(Касса,Дата,);
		
		Если СвободныйОстаток < СуммаДокумента Тогда
			
			Сообщить(Заголовок+"
			|Сумма документа превышает возможный к использованию остаток денежных средств
			|по " + Касса.Наименование + ".
			|Возможный к использованию остаток: " + Формат(СвободныйОстаток,"ЧЦ=15; ЧДЦ=2")+" "+ВалютаДокумента+"
			|Сумма документа = "+Формат(СуммаДокумента,"ЧЦ=15; ЧДЦ=2")+" "+ВалютаДокумента);
			
			Если НЕ УправлениеДенежнымиСредствами.ЕстьРазрешениеПревышатьСвободныйОстатокДС() Тогда
				Отказ = Истина;
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		СтруктураГруппаВалют = Новый Структура;
		СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",глЗначениеПеременной("ВалютаУправленческогоУчета").Код);
		СтруктураГруппаВалют.Вставить("ВалютаДокумента",ВалютаДокумента.Код);
		СтруктураКурсыВалют=УправлениеДенежнымиСредствами.ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,Дата);
		
		ДвиженияПоРегистрам(СтруктураКурсыВалют);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	
КонецПроцедуры

