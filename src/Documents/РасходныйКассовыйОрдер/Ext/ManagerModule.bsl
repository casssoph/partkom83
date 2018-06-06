﻿
Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.РасходныйКассовыйОрдер;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	Результат = Новый Структура;
	Если (вхПараметр = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		Результат.Вставить("Шапка", "Дата,Проведен");
	ИначеЕсли (вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом77_83) тогда
		Результат.Вставить("Шапка", "Номер,Дата,Проведен,ПометкаУдаления,"
		"ВидОперации,Организация,Касса,Контрагент,ВалютаДокумента,Комментарий,"
		"ВалютаВзаиморасчетовРаботника,ПоДокументу,СчетОрганизации,"
		"Выдать,Основание,Приложение,СуммаДокумента,ВидДенежныхСредств,ЦФОДляБюджета,РегионДляБюджета");
		Результат.Вставить("ТабличныеЧасти", Новый Структура("РасшифровкаПлатежа", "ДоговорКонтрагента,КурсВзаиморасчетов,СуммаПлатежа,КратностьВзаиморасчетов,"
		"СуммаВзаиморасчетов,СтавкаНДС,СуммаНДС,СтатьяДвиженияДенежныхСредств,ДокументРасчетовСКонтрагентом,ЦФОДляБюджета,РегионДляБюджета"));
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр);
КонецФункции

Функция ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхФильтр = Неопределено) Экспорт
	
	Результат = Неопределено;
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.Взаиморасчеты, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	лКонтроль = Неопределено;
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДанныеОбъекта.Контроль", лКонтроль);
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ДенежныеСредства") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ДенежныеСредства,
		РегистрыНакопления_ДенежныеСредства(вхСсылкаНаДокумент, вхОтказ, вхПараметры), Истина);
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "БюджетыЦФО") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.БюджетыЦФО,
		РегистрыНакопления_БюджетыЦФО(вхСсылкаНаДокумент, вхОтказ, вхПараметры), Истина);
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ДепозитыКонтрагентов") Тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ДепозитыКонтрагентов,
		РегистрыНакопления_ДепозитыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры), Истина);
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ВзаиморасчетыСПодотчетнымиЛицами") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ВзаиморасчетыСПодотчетнымиЛицами,
		РегистрыНакопления_ВзаиморасчетыСПодотчетнымиЛицами(вхСсылкаНаДокумент, вхОтказ, вхПараметры), Истина);
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "Взаиморасчеты") тогда
		
		// регистр накопления "Взаиморасчеты"
		//Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата") >= ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты 
		//	И ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ВидОперации") <> Перечисления.ВидыОперацийРКО.СнятиеСДепозита Тогда
		//	
		//	ТаблицаДоговоров = ОпределитьДоговорДляБлокировки(вхСсылкаНаДокумент, лФильтр);
		//	БлокировкаДанных = Новый БлокировкаДанных;
		//	
		//	ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрНакопления.Взаиморасчеты");
		//	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		//	ЭлементБлокировки.ИсточникДанных = ТаблицаДоговоров;
		//	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ДоговорКонтрагента", "ДоговорКонтрагента");
		//	
		//	ЭлементБлокировки = БлокировкаДанных.Добавить("Последовательность.ПоРасчетамСКонтрагентами");
		//	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		//	ЭлементБлокировки.ИсточникДанных = ТаблицаДоговоров;
		//	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ДоговорКонтрагента", "ДоговорКонтрагента");
		//	БлокировкаДанных.Заблокировать();
		//КонецЕсли;	
		
		НовоеПроведениеПоВзаиморасчетам = глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам"); 
		
		лОчищать = Ложь;
		Если НовоеПроведениеПоВзаиморасчетам Тогда 
			лОчищать = ПроведениеДокументовКлиентСервер.НеобходимоОчиститьДвиженияВзаиморасчеты(вхСсылкаНаДокумент);
		Иначе	
			Если (лКонтроль <> Неопределено) тогда
				Если лКонтроль.Свойство("СтарыеЗначения") Тогда
					лСтарыеЗначения = лКонтроль.СтарыеЗначения.Получить(Метаданные.Последовательности.ПоРасчетамСКонтрагентами);
					лНовыеЗначения = лКонтроль.НовыеЗначения.Получить(Метаданные.Последовательности.ПоРасчетамСКонтрагентами);
					Если (лСтарыеЗначения <> Неопределено) И (лНовыеЗначения <> Неопределено) тогда
						лОчищать = (лСтарыеЗначения.Шапка.Дата < лНовыеЗначения.Шапка.Дата)
						И лСтарыеЗначения.Шапка.Проведен;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
		
		Если лОчищать тогда
			ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты);
			лБазовая = Неопределено;
			ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", лБазовая);
			лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
		Иначе
			лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
			лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты);	
		КонецЕсли;
		
		лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
		лИсходная = лРазделенныеБазовая.Включенные;
		//лТребуемая = РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
		лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
		ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.Взаиморасчеты,
		лРазностныеДанные, лРазделенныеБазовая.Исключенные);
		
		ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
		Если НовоеПроведениеПоВзаиморасчетам и лФильтр = Неопределено Тогда 
			РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПоРасчетамСКонтрагентами", Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция РегистрыНакопления_Взаиморасчеты(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	табВзаиморасчеты = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", табВзаиморасчеты);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата") < ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты Тогда
		Возврат табВзаиморасчеты
	КонецЕсли;
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ВидОперации") <> Перечисления.ВидыОперацийРКО.СнятиеСДепозита Тогда
		лФильтр = Неопределено;
		ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(УправлениеВзаиморасчетами.ПроведениеПоВзаиморасчетамБанковскиеКассовыеДокументы(вхСсылкаНаДокумент, лФильтр),табВзаиморасчеты);
	КонецЕсли;
	Возврат табВзаиморасчеты;
	
КонецФункции

Функция РегистрыНакопления_ВзаиморасчетыСПодотчетнымиЛицами(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	лДоговорКонтрагента = Неопределено;
	лДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДенежныхСредств", Перечисления.ВидыДенежныхСредств.Наличные);
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийРКО.ВыдачаДенежныхСредствПодотчетнику);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ВидДвижения,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата КАК Период,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента КАК Валюта,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Организация,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Контрагент КАК ФизЛицо,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК РасчетныйДокумент,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов,
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов * РасходныйКассовыйОрдерРасшифровкаПлатежа.КурсВзаиморасчетов / РасходныйКассовыйОрдерРасшифровкаПлатежа.КратностьВзаиморасчетов КАК СуммаУпр
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
		|ГДЕ
		|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка
		|	И РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВидОперации = &ВидОперации";
		
		Возврат Запрос.Выполнить().Выгрузить();
	
	
КонецФункции

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент);
	ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПоРасчетамСКонтрагентами, вхПараметры);
	
	Если глЗначениеПеременной("НовоеПроведениеПоВзаиморасчетам")Тогда 
		РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПоРасчетамСКонтрагентами", Ложь);
	КонецЕсли;
КонецПроцедуры

Функция РегистрыНакопления_ДенежныеСредства(вхСсылкаНаДокумент, вхОтказ,вхПараметры) 
	ВидДенежныхСредств = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ВидДенежныхСредств");
	Если ВидДенежныхСредств = Перечисления.ВидыДенежныхСредств.Безналичные Тогда
		ТабДвижений = Неопределено;
		ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ДенежныеСредства", ТабДвижений);
		Возврат ТабДвижений;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ВидДенежныхСредств", Перечисления.ВидыДенежныхСредств.Наличные);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&ВидДвижения,
	               |	&ВидДенежныхСредств,
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК Регистратор,
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата КАК Период,
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Касса КАК БанковскийСчетКасса,
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов КАК Сумма,
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов * РасходныйКассовыйОрдерРасшифровкаПлатежа.КурсВзаиморасчетов / РасходныйКассовыйОрдерРасшифровкаПлатежа.КратностьВзаиморасчетов КАК СуммаУпр
	               |ИЗ
	               |	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
	               |ГДЕ
	               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка
	               |	
	               |			";

	
Возврат  Запрос.Выполнить().Выгрузить();

	
КонецФункции

Функция РегистрыНакопления_ДепозитыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	
	ТабПоДепозитам = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ДепозитыКонтрагентов", ТабПоДепозитам);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата") < ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты Тогда
		Возврат ТабПоДепозитам
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ВидДвижения,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК Регистратор,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата КАК Период,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов * РасходныйКассовыйОрдерРасшифровкаПлатежа.КурсВзаиморасчетов / РасходныйКассовыйОрдерРасшифровкаПлатежа.КратностьВзаиморасчетов КАК СуммаРегл,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов КАК СуммаУпр,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.КурсВзаиморасчетов,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.КратностьВзаиморасчетов,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.ВалютаДокумента КАК ВалютаВзаиморасчетов
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
	|ГДЕ
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка";
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНадокумент, "ВидОперации") = Перечисления.ВидыОперацийРКО.СнятиеСДепозита Тогда
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабПоДепозитам);
		
	КонецЕсли;
	
	Возврат ТабПоДепозитам;
	
КонецФункции

Функция РегистрыНакопления_БюджетыЦФО(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);
		
	Запрос.Текст = "ВЫБРАТЬ
	|	&ВидДвижения,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК Регистратор,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата КАК Период,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.ЦФОДляБюджета КАК ЦФОДляБюджета,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.РегионДляБюджета КАК РегионДляБюджета,
	|	0 КАК СуммаПриход,
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.СуммаВзаиморасчетов КАК СуммаРасход
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
	|ГДЕ
	|	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка
	|	";
	
	Возврат Запрос.Выполнить().Выгрузить();	
	
КонецФункции

Функция ПолучитьЗаписиПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, Проведение) Экспорт
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лМетаданныеДокумента = вхСсылкаНаДокумент.Метаданные();
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "Дата,ВидОперации");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПоРасчетамСКонтрагентами) тогда
		лМассивВидовОпераций = Новый Массив;
		лМассивВидовОпераций.Добавить(Перечисления.ВидыОперацийРКО.ОплатаПоставщику);
		лМассивВидовОпераций.Добавить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю);
		лМассивВидовОпераций.Добавить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами);
		лМассивВидовОпераций.Добавить(Перечисления.ВидыОперацийРКО.ПрочиеРасчетыСКонтрагентами);
		
		Если Проведение			
			И (лМассивВидовОпераций.Найти(Реквизиты.ВидОперации) <> Неопределено)
			И (Реквизиты.Дата >= ПараметрыСеанса.ДатаНачалаРаботыВзаиморасчеты) тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка.Дата КАК Период,
			               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка КАК Регистратор,
			               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.ДоговорКонтрагента
			               |ИЗ
			               |	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдерРасшифровкаПлатежа
			               |ГДЕ
			               |	РасходныйКассовыйОрдерРасшифровкаПлатежа.Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			РасшифровкаПлатежа = Запрос.Выполнить().Выгрузить();
			Для Каждого лСтрокаРасшифровкаПлатежа Из РасшифровкаПлатежа цикл
				
				Если НЕ ОбщегоНазначения.ИспользоватьПогашениеПоРасчетнымДокументам(лСтрокаРасшифровкаПлатежа.ДоговорКонтрагента) тогда
					Продолжить;
				КонецЕсли;
								
				лСтрокаРезультат = лРезультат.Добавить();
				ЗаполнитьЗначенияСвойств(лСтрокаРезультат, лСтрокаРасшифровкаПлатежа);
			КонецЦикла;
		КонецЕсли;
				
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
	Возврат Результат;
	
КонецФункции

Функция ОпределитьДоговорДляБлокировки(вхСсылкаНаДокумент, вхФильтр = Неопределено)

	
	лМетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(вхСсылкаНаДокумент));
	Если (лМетаданныеДокумента = Неопределено) тогда
		ВызватьИсключение "[ПроведениеПоВзаиморасчетамБанковскиеКассовыеДокументы]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лРеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхСсылкаНаДокумент, "МоментВремени,СуммаДокумента,ВалютаДокумента,ВидОперации");
	лЗнакСуммы = 0;
	лЗнакДвижения = 0;
	Если (лМетаданныеДокумента = Метаданные.Документы.ПриходныйКассовыйОрдер) тогда
		
		лДопустимыеОперации = Новый Массив;
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПКО.ОплатаПокупателя);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСКонтрагентами);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПКО.ПрочиеРасчетыСКонтрагентами);
		
		лВозвратныеОперации = Новый Массив;
		лВозвратныеОперации.Добавить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПодотчетником);
		лВозвратныеОперации.Добавить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком);
		
		лЗнакСуммы = -1;
		лЗнакДвижения = ?(лВозвратныеОперации.Найти(лРеквизитыДокумента.ВидОперации) = Неопределено, 1, -1);
		
	ИначеЕсли (лМетаданныеДокумента = Метаданные.Документы.РасходныйКассовыйОрдер) тогда
		
		лДопустимыеОперации = Новый Массив;
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийРКО.ОплатаПоставщику);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймамСКонтрагентами);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийРКО.ПрочиеРасчетыСКонтрагентами);
		
		лВозвратныеОперации = Новый Массив;
		лВозвратныеОперации.Добавить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю);
		
		лЗнакСуммы = 1;
		лЗнакДвижения = ?(лВозвратныеОперации.Найти(лРеквизитыДокумента.ВидОперации) = Неопределено, 1, -1);
		
	ИначеЕсли (лМетаданныеДокумента = Метаданные.Документы.ПлатежноеПоручениеВходящее) тогда
		
		лДопустимыеОперации = Новый Массив;
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами);
		
		лВозвратныеОперации = Новый Массив;
		лВозвратныеОперации.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком);
		
		лЗнакСуммы = -1;
		лЗнакДвижения = ?(лВозвратныеОперации.Найти(лРеквизитыДокумента.ВидОперации) = Неопределено, 1, -1);
		
	ИначеЕсли (лМетаданныеДокумента = Метаданные.Документы.ПлатежноеПоручениеИсходящее) тогда
		
		лДопустимыеОперации = Новый Массив;
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймамСКонтрагентами);
		лДопустимыеОперации.Добавить(Перечисления.ВидыОперацийППИсходящее.ПрочиеРасчетыСКонтрагентами);
		
		лВозвратныеОперации = Новый Массив;
		лВозвратныеОперации.Добавить(Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю);
		
		лЗнакСуммы = 1;
		лЗнакДвижения = ?(лВозвратныеОперации.Найти(лРеквизитыДокумента.ВидОперации) = Неопределено, 1, -1);
		
	КонецЕсли;
	
	Если (лЗнакСуммы = 0) ИЛИ (лЗнакДвижения = 0) тогда
		ВызватьИсключение "[ПроведениеПоВзаиморасчетамБанковскиеКассовыеДокументы]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Результат = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("Взаиморасчеты", Результат);
	Если (лДопустимыеОперации.Найти(лРеквизитыДокумента.ВидОперации) = Неопределено) тогда
		Возврат Результат;
	КонецЕсли;
	
	лТаблицаДокумента = Новый ТаблицаЗначений;
	лТаблицаДокумента.Колонки.Добавить("ДоговорКонтрагента");
	лТаблицаДокумента.Колонки.Добавить("ДокументРасчетов");
	лТаблицаДокумента.Колонки.Добавить("КурсВзаиморасчетов", Новый ОписаниеТипов("Число"));
	лТаблицаДокумента.Колонки.Добавить("КратностьВзаиморасчетов", Новый ОписаниеТипов("Число"));
	лТаблицаДокумента.Колонки.Добавить("СуммаВзаиморасчетов", Новый ОписаниеТипов("Число"));
	
	лЗапрос = Новый Запрос;
	лЗапрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	лЕстьФильтр = Ложь;
	лДоговорКонтрагента = Неопределено;
	Если (ТипЗнч(вхФильтр) = Тип("Структура")) тогда
		лЕстьФильтр = вхФильтр.Свойство("ДоговорКонтрагента", лДоговорКонтрагента);
	КонецЕсли;	
	
	лЗапрос.УстановитьПараметр("ЕстьФильтр", лЕстьФильтр);
	лЗапрос.УстановитьПараметр("ДоговорКонтрагента", лДоговорКонтрагента);
	
	лЗапрос.Текст = 
	"ВЫБРАТЬ
	|	Т.ДоговорКонтрагента,
	|	Т.КурсВзаиморасчетов,
	|	Т.КратностьВзаиморасчетов,
	|	Т.ДокументРасчетовСКонтрагентом КАК ДокументРасчетов,
	|	Т.СуммаВзаиморасчетов
	|ИЗ
	|	Документ." + лМетаданныеДокумента.Имя + ".РасшифровкаПлатежа КАК Т
	|ГДЕ
	|	Т.Ссылка = &Ссылка
	|	И Т.СуммаВзаиморасчетов > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.НомерСтроки";
	
	// корректировка таблицы документа (учитываем сумму в шапке)
	лДоговорКонтрагентаПоУмолчанию = Неопределено;
	лКурсВзаиморасчетовПоУмолчанию = 0;
	лКратностьВзаиморасчетовПоУмолчанию = 0;
	
	лСуммаДокумента = лРеквизитыДокумента.СуммаДокумента;
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() цикл
		
		Если НЕ ЗначениеЗаполнено(лДоговорКонтрагентаПоУмолчанию) тогда
			лДоговорКонтрагентаПоУмолчанию = лВыборка.ДоговорКонтрагента;
			лКурсВзаиморасчетовПоУмолчанию = лВыборка.КурсВзаиморасчетов;
			лКратностьВзаиморасчетовПоУмолчанию = лВыборка.КратностьВзаиморасчетов;
		КонецЕсли;
		
		Если (лСуммаДокумента = 0) тогда
			Прервать;
		КонецЕсли;
		
		лСуммаВзаиморасчетов = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(лВыборка.СуммаВзаиморасчетов, лРеквизитыДокумента.ВалютаДокумента, Неопределено,
		лВыборка.КурсВзаиморасчетов, 1, лВыборка.КратностьВзаиморасчетов, 1);
		лПогашСумма = Мин(лСуммаДокумента, лСуммаВзаиморасчетов);
		Если (лПогашСумма > 0) тогда
			лСтрокаТаблицаДокумента = лТаблицаДокумента.Добавить();
			лСтрокаТаблицаДокумента.ДоговорКонтрагента = лВыборка.ДоговорКонтрагента;
			лСтрокаТаблицаДокумента.ДокументРасчетов = лВыборка.ДокументРасчетов;
			лСтрокаТаблицаДокумента.СуммаВзаиморасчетов = лПогашСумма;
			лСтрокаТаблицаДокумента.КурсВзаиморасчетов = лВыборка.КурсВзаиморасчетов;
			лСтрокаТаблицаДокумента.КратностьВзаиморасчетов = лВыборка.КратностьВзаиморасчетов;
			
			лСуммаДокумента = лСуммаДокумента - лПогашСумма;
			
		КонецЕсли;		
		
	КонецЦикла;
	
	Если (лСуммаДокумента > 0) тогда
		лСтрокаТаблицаДокумента = лТаблицаДокумента.Добавить();
		лСтрокаТаблицаДокумента.ДоговорКонтрагента = лДоговорКонтрагентаПоУмолчанию;
		лСтрокаТаблицаДокумента.ДокументРасчетов = Неопределено;
		лСтрокаТаблицаДокумента.СуммаВзаиморасчетов = лСуммаДокумента;
		лСтрокаТаблицаДокумента.КурсВзаиморасчетов = лКурсВзаиморасчетовПоУмолчанию;
		лСтрокаТаблицаДокумента.КратностьВзаиморасчетов = лКратностьВзаиморасчетовПоУмолчанию;
	КонецЕсли;
	
	
	Возврат лТаблицаДокумента.Скопировать(,"ДоговорКонтрагента");

КонецФункции