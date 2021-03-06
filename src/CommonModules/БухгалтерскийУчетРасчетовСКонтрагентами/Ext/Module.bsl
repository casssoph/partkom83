﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ПРОВЕДЕНИЯ ДОКУМЕНТОВ ПО РЕГЛ. ВЗАИМОРАСЧЕТАМ (НДС)

//Функция возвращает вид расчетов по договору
// Параметры
//		ДоговорКонтрагента 				- СправочникСсылка.ДоговорыКонтраентов
//		ВалютаРегламентированногоУчета 	- СправочникСсылка.Валюты
//
// Возвращаемое значение
//      ПеречилениеСсылка.ВидыРасчетовПоДоговорам
//
Функция ОпределениеВидаРасчетовПоПараметрамДоговора(ДоговорКонтрагента,ВалютаРегламентированногоУчета) Экспорт
	Если ДоговорКонтрагента.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета тогда
		ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВВалютеРегламентированногоУчета;
	ИначеЕсли ДоговорКонтрагента.РасчетыВУсловныхЕдиницах тогда
		ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВУсловныхЕдиницах;
	Иначе
		ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВИностраннойВалюте;
	Конецесли;
	Возврат ВидРасчетовПоДоговору;
КонецФункции

// Процедура подготовки таблицы значений для целей приобретения и реализации.
//
Процедура ПодготовкаТаблицыЗначенийДляЦелейПриобретенияИРеализации(ТаблицаЗначений, СтруктураШапкиДокумента, ВключитьНДСВОсновнуюСумму, ВалютаРегламентированногоУчета = "") Экспорт

	Перем СуммаВключаетНДС,ВидРасчетовПоДоговору;

	Если СтруктураШапкиДокумента.Свойство("ВалютаРегламентированногоУчета") тогда
		ВалютаРегламентированногоУчета = СтруктураШапкиДокумента.ВалютаРегламентированногоУчета;
	Иначе
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	ЕстьНДС    = Не(ТаблицаЗначений.Колонки.Найти("НДС")=Неопределено);
	ЕстьВалюта = СтруктураШапкиДокумента.Свойство("ВалютаДокумента");

	СтруктураШапкиДокумента.Свойство("СуммаВключаетНДС", СуммаВключаетНДС);
	СуммаВключаетНДС = (СуммаВключаетНДС = Истина);

	Если СтруктураШапкиДокумента.Свойство("ДоговорКонтрагента") тогда
		ВидРасчетовПоДоговору = ОпределениеВидаРасчетовПоПараметрамДоговора(СтруктураШапкиДокумента.ДоговорКонтрагента,ВалютаРегламентированногоУчета);
	КонецЕсли;

	//Дополним колонки ТЗ при необходимости
	СтруктураОбязательныхКолонок = Новый Структура("Сумма"+?(ЕстьНДС,",НДС,СуммаБезНДС","")+?(ЕстьВалюта,",СуммаВал"+?(ЕстьНДС,",НДСВал,СуммаБезНДСВал",""),""));

	Для каждого Колонка Из СтруктураОбязательныхКолонок Цикл

		Если ТаблицаЗначений.Колонки.Найти(Колонка.Ключ) = Неопределено тогда
			ТаблицаЗначений.Колонки.Добавить(Колонка.Ключ, ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15, 2));
		КонецЕсли;

	КонецЦикла;

	//Дополним колонки ТЗ при необходимости нечисловыми полями

	Если ТаблицаЗначений.Колонки.Найти("ВидЦенности") = Неопределено тогда
		ТаблицаЗначений.Колонки.Добавить("ВидЦенности");
	КонецЕсли;

	Если ТаблицаЗначений.Колонки.Найти("Ценность") = Неопределено тогда
		ТаблицаЗначений.Колонки.Добавить("Ценность");
	КонецЕсли;

	//Определим суммы по документу (Сумму без НДС и корректную основную сумму)
	Если ЕстьНДС тогда

		Для каждого СтрокаТаблицы из ТаблицаЗначений цикл
			СтрокаТаблицы.СуммаБезНДС = СтрокаТаблицы.Сумма       - ?(СуммаВключаетНДС, СтрокаТаблицы.НДС, 0);
			СтрокаТаблицы.Сумма       = СтрокаТаблицы.СуммаБезНДС + ?(ВключитьНДСВОсновнуюСумму, СтрокаТаблицы.НДС, 0);
		КонецЦикла;

	КонецЕсли;

	Если ЕстьВалюта тогда

		// Заполним валютные колонки суммами документа
		Для каждого Колонка Из СтруктураОбязательныхКолонок Цикл

			Если Прав(Колонка.Ключ, 3) = "Вал" Тогда
				ТаблицаЗначений.ЗагрузитьКолонку(ТаблицаЗначений.ВыгрузитьКолонку(Лев(Колонка.Ключ, СтрДлина(Колонка.Ключ) - 3)), Колонка.Ключ);
			КонецЕсли;

		КонецЦикла;
		
			Если Не(СтруктураШапкиДокумента.ВалютаДокумента = ВалютаРегламентированногоУчета) Тогда

				Если не СтруктураШапкиДокумента.Свойство("КурсДокумента") или не СтруктураШапкиДокумента.Свойство("КратностьДокумента") тогда
					КоэффициентПересчета=1;
				ИначеЕсли Число(СтруктураШапкиДокумента.КурсДокумента) = 0 или Число(СтруктураШапкиДокумента.КратностьДокумента)=0 тогда
					КоэффициентПересчета=1;
				Иначе
					КоэффициентПересчета = СтруктураШапкиДокумента.КурсДокумента/СтруктураШапкиДокумента.КратностьДокумента;
				КонецЕсли;

				СуммаРег = Окр(ТаблицаЗначений.Итог("СуммаВал")* КоэффициентПересчета,2);
				//Распределение суммы по таблице
				РаспределениеРег = ОбщегоНазначения.РаспределитьПропорционально(СуммаРег,ТаблицаЗначений.выгрузитьКолонку("Сумма"));
				Если Не РаспределениеРег = Неопределено Тогда
					ТаблицаЗначений.ЗагрузитьКолонку(РаспределениеРег,"Сумма");
				КонецЕсли; 
				
				
				Если ЕстьНДС тогда
					
					НДСРег			 = Окр(ТаблицаЗначений.Итог("НДСВал") * КоэффициентПересчета,2);
					//Распределение суммы по таблице
					РаспределениеРег = ОбщегоНазначения.РаспределитьПропорционально(НДСРег,ТаблицаЗначений.выгрузитьКолонку("НДС"));
					Если Не РаспределениеРег = Неопределено Тогда
						ТаблицаЗначений.ЗагрузитьКолонку(РаспределениеРег,"НДС");
					КонецЕсли; 
					
					//Расчет суммы без НДС
					Для каждого СтрокаТаблицы из ТаблицаЗначений Цикл
						СтрокаТаблицы.СуммаБезНДС = СтрокаТаблицы.Сумма - ?(ВключитьНДСВОсновнуюСумму, СтрокаТаблицы.НДС, 0);
					КонецЦикла;

				КонецЕсли;
				
			Иначе

				//Документ в национальной валюте
				Если ВидРасчетовПоДоговору = Перечисления.ВидыРасчетовПоДоговорам.РасчетыВУсловныхЕдиницах тогда

					//Необходимо определить сумму расчетов с контрагентом в валюте договора
					Если не СтруктураШапкиДокумента.Свойство("КурсВзаиморасчетов") или не СтруктураШапкиДокумента.Свойство("КратностьВзаиморасчетов") тогда
						КоэффициентПересчета=1;
					ИначеЕсли Число(СтруктураШапкиДокумента.КурсВзаиморасчетов) = 0 или Число(СтруктураШапкиДокумента.КратностьВзаиморасчетов) = 0 тогда
						КоэффициентПересчета = 1;
					Иначе
						КоэффициентПересчета = СтруктураШапкиДокумента.КратностьВзаиморасчетов / СтруктураШапкиДокумента.КурсВзаиморасчетов;
					КонецЕсли;

					СуммаВал = Окр(ТаблицаЗначений.Итог("Сумма")* КоэффициентПересчета,2);
					//Распределение суммы по таблице
					РаспределениеВал = ОбщегоНазначения.РаспределитьПропорционально(СуммаВал,ТаблицаЗначений.ВыгрузитьКолонку("СуммаВал"));
					Если Не РаспределениеВал = Неопределено Тогда
						ТаблицаЗначений.ЗагрузитьКолонку(РаспределениеВал,"СуммаВал");
					КонецЕсли; 
					
					
					Если ЕстьНДС тогда
						
						НДСВал			 = Окр(ТаблицаЗначений.Итог("НДС") * КоэффициентПересчета,2);
						//Распределение суммы по таблице
						РаспределениеВал = ОбщегоНазначения.РаспределитьПропорционально(НДСВал,ТаблицаЗначений.выгрузитьКолонку("НДСВал"));
						Если Не РаспределениеВал = Неопределено Тогда
							ТаблицаЗначений.ЗагрузитьКолонку(РаспределениеВал,"НДСВал");
						КонецЕсли; 
						
						//Расчет суммы без НДС
						Для каждого СтрокаТаблицы из ТаблицаЗначений Цикл
							СтрокаТаблицы.СуммаБезНДСВал = СтрокаТаблицы.СуммаВал - ?(ВключитьНДСВОсновнуюСумму, СтрокаТаблицы.НДСВал, 0);
						КонецЦикла;


					КонецЕсли;

				КонецЕсли

			КонецЕсли;

	КонецЕсли;

	УчетНДС.ОпределениеДополнительныхПараметровТаблицыПартийДляПодсистемыУчетаНДС(СтруктураШапкиДокумента, ТаблицаЗначений);

КонецПроцедуры // ПодготовкаТаблицыЗначенийДляЦелейПриобретенияИРеализации()



//Формирует структуру параметров для передачи в процедуры движения денежных средств по ссылке на документ
Функция ПодготовкаСтруктурыПараметровДляДвиженияДенег(Ссылка, ВалютаРегламентированногоУчета, Заголовок = Неопределено,КоррСчет=Неопределено, ТаблицаДокумента = Неопределено, СтруктураШапкиДокумента = Неопределено) Экспорт
	
	Отказ = Ложь;
	СтруктураПараметров = УчетНДС.СформироватьСокращеннуюСтруктуруШапкиДокументаДляДвиженияДенег(Ссылка, ВалютаРегламентированногоУчета, Отказ);
	
	Если Отказ Тогда
	    Возврат Ложь;
	КонецЕсли; 
	
	УчетНДС.ПодготовитьТаблицуОплатДляДвиженияДенег(СтруктураПараметров);
	
	Возврат СтруктураПараметров;

КонецФункции

// Выполняет приход/расход (возврат) денег по платежному документу
//
// Параметры
// ОбъектСсылка    - ДокументОбъект или ДокументСсылка - Документ для которого выполяентся операция.
// РежимПроведения - РежимПроведенияДокумента- Режим проведения документа, для регламентной процедуры - неопределено
// РасчетыВВалюте  - Булево                  - Признак расчетов в валюте
// СчетКт          - ПланСчетов.Хозрасчетный - корреспондирующий счет
//
Функция ДвижениеДенег(СтруктураПараметров, Объект) Экспорт

	//Получение основных данных документа
	РеестрПлатежей      = СтруктураПараметров.Таблица;
	РеестрПлатежей.Колонки.Добавить("РезультатРаспределения",Новый ОписаниеТипов("Булево"));
	
	НаправлениеДвижения	= СтруктураПараметров.НаправлениеДвижения;
	ЭтоВозврат			= ( СтруктураПараметров.РасчетыВозврат = Перечисления.РасчетыВозврат.Возврат);

	Движения = Объект.Движения;
	
	// Регистрируем оплату в регистре расчетов для НДС 
	Если не (НаправлениеДвижения = "Поступление") = ЭтоВозврат тогда 
		УчетНДСФормированиеДвижений.РегистрацияОплаты_НДСРасчетыСПокупателями(СтруктураПараметров, РеестрПлатежей, Движения, ЭтоВозврат);
	Иначе
		УчетНДСФормированиеДвижений.РегистрацияОплаты_НДСРасчетыСПоставщиками(СтруктураПараметров, РеестрПлатежей, Движения, ЭтоВозврат);
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ДвижениеДенег()

//Определяет направление движения денежных средств в зависимости от вида документа и вида операции документа
Функция ОпределениеНаправленияДвиженияДляДокументаДвиженияДенежныхСредств(ВидДокумента,ВидОперации = неопределено)Экспорт

	ВидДействийДокумента = Новый Структура("Направление,РасчетыВозврат");
	ВидыДокументовДДС    = Новый Соответствие();

	ВидыДокументовДДС.Вставить("АккредитивПереданный","Выбытие");
	ВидыДокументовДДС.Вставить("ИнкассовоеПоручениеПолученное","Выбытие");
	ВидыДокументовДДС.Вставить("ПлатежноеПоручениеИсходящее","Выбытие");
	ВидыДокументовДДС.Вставить("ПлатежноеТребованиеПолученное","Выбытие");
	ВидыДокументовДДС.Вставить("ПлатежныйОрдерСписаниеДенежныхСредств","Выбытие");
	ВидыДокументовДДС.Вставить("РасходныйКассовыйОрдер","Выбытие");
	ВидыДокументовДДС.Вставить("АвансовыйОтчет","Выбытие");
	ВидыДокументовДДС.Вставить("АккредитивПолученный","Поступление");
	ВидыДокументовДДС.Вставить("ИнкассовоеПоручениеПереданное","Поступление");
	ВидыДокументовДДС.Вставить("ПлатежноеПоручениеВходящее","Поступление");
	ВидыДокументовДДС.Вставить("ПлатежноеТребованиеВыставленное","Поступление");
	ВидыДокументовДДС.Вставить("ПлатежныйОрдерПоступлениеДенежныхСредств","Поступление");
	ВидыДокументовДДС.Вставить("ПриходныйКассовыйОрдер","Поступление");
	ВидыДокументовДДС.Вставить("ОплатаОтПокупателяПлатежнойКартой","Поступление");

	ВидДействийДокумента.Вставить("Направление",ВидыДокументовДДС[ВидДокумента]);

	ВидОперацииРасчет  = Перечисления.РасчетыВозврат.Расчеты;
	ВидОперацииВозврат = Перечисления.РасчетыВозврат.Возврат;
	
	Если ЗначениеЗаполнено(ВидОперации) тогда

		//Определение вида операции

		РасчетВозвратПоВидуОпераций = Новый Соответствие();

		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ОплатаПоставщику,ВидОперацииРасчет);
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ВозвратДенежныхСредствПокупателю,ВидОперацииВозврат);
		
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ОплатаПокупателя,ВидОперацииРасчет);
        РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствПоставщиком,ВидОперацииВозврат);
		
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику,ВидОперацииРасчет);
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю,ВидОперацииВозврат);
		
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя,ВидОперацииРасчет);
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком,ВидОперацииВозврат);
		
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику,ВидОперацииРасчет);
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю,ВидОперацииВозврат);
		
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ОплатаПокупателя,ВидОперацииРасчет);
		РасчетВозвратПоВидуОпераций.Вставить(Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю,ВидОперацииВозврат);
		
		Если ВидОперации = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю Тогда
			ВидДействийДокумента.Вставить("Направление","Выбытие");
		КонецЕсли; 
			
		ВидДействийДокумента.Вставить("РасчетыВозврат",РасчетВозвратПоВидуОпераций[ВидОперации]);
	ИначеЕсли ВидДокумента="АвансовыйОтчет" тогда
		ВидДействийДокумента.Вставить("РасчетыВозврат", ВидОперацииРасчет);
	Конецесли;

	Возврат ВидДействийДокумента;

КонецФункции

