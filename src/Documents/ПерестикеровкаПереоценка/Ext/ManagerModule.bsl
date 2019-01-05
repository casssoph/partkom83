﻿
//// ОБРАБОТЧИКИ МОДУЛЯ ОБЪЕКТА

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ТоварыНаСкладах") тогда
		ПроведениеДокументовКлиентСервер.КонтрольОстатков(вхСсылкаНаДокумент, вхОтказ,,вхПараметры);
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ТоварыНаСкладах",
		РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ЦеныНоменклатуры") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ЦеныНоменклатуры",
		РегистрыСведений_ЦеныНоменклатуры(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") Тогда
		
		БлокировкаДанных = Новый БлокировкаДанных;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПерестикеровкаПереоценкаТовары.Ссылка.Склад КАК Склад,
		               |	ПерестикеровкаПереоценкаТовары.Номенклатура,
		               |	ПерестикеровкаПереоценкаТовары.Качество
		               |ИЗ
		               |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
		               |ГДЕ
		               |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ПерестикеровкаПереоценкаТовары.Номенклатура
		               |ИЗ
		               |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
		               |ГДЕ
		               |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
		
		Результаты = Запрос.ВыполнитьПакет();
		
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрНакопления.ПартииТоваров");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = Результаты.Получить(0);
		
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад", "Склад");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Качество", "Качество");
		
		ЭлементБлокировки = БлокировкаДанных.Добавить("Последовательность.ПартионныйУчет");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = Результаты.Получить(1);
		
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
		
		БлокировкаДанных.Заблокировать();
		
		
		лОчищать = ПроведениеДокументовКлиентСервер.НеобходимоОчиститьДвиженияПартииТоваров(вхСсылкаНаДокумент, лФильтр);		
		
		НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
		
		Если лОчищать тогда
			Если лФильтр = Неопределено Тогда 
				ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);
				лБазовая = Неопределено;
				ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ПартииТоваров", лБазовая);
			Иначе
				// Очищаем только движения по фильтру
				лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
				лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
				ОбщегоНазначения.ЗаписатьДвиженияДокументаБезОбработки(вхСсылкаНаДокумент, РегистрыНакопления.ПартииТоваров, лРазделенныеБазовая.Исключенные, Истина); 
				лБазовая = лРазделенныеБазовая.Исключенные;
			КонецЕсли;
		Иначе
			лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
		КонецЕсли;
		
		лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
		лИсходная = лРазделенныеБазовая.Включенные;
				
		ТаблицаСписанияПартий = ПроведениеДокументовКлиентСервер.ПогашениеПартийТоваровНовое(вхСсылкаНаДокумент, вхОтказ, Истина, лФильтр);
		Если Не вхОтказ Тогда 
			Если лФильтр = Неопределено Тогда 
				лТребуемая = ДвиженияПартииТоваров(вхСсылкаНаДокумент, ТаблицаСписанияПартий.ПартииТоваров);
			Иначе
				лТребуемая = ТаблицаСписанияПартий.ПартииТоваров;
				ДополнитьТаблицуДвижений(лТребуемая, вхСсылкаНаДокумент, лФильтр);
			КонецЕсли;
			
			//Удалим служебные колонки 
			ОбщегоНазначения.УдалитьКолонки(лИсходная, лТребуемая);
			
			лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
			ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров,
			лРазностныеДанные, лРазделенныеБазовая.Исключенные);
			
			ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
			Если лФильтр = Неопределено Тогда 
				РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент);
	ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	
	РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Ложь);
	
КонецПроцедуры

//// ТАБЛИЦЫ ДВИЖЕНИЙ ДОКУМЕНТОВ

Функция РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт 
	
	ТабТоваров = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ТоварыНаСкладах", ТабТоваров);
	
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(вхСсылкаНаДокумент, "Дата,флОбновлятьЦены,ВидОперации, СтатусДокумента, АктРассмотренияВозврата");
	Если Реквизиты.Дата < глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Если Реквизиты.Дата < ПараметрыСеанса.ДатаНачалаРаботыТовары Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Реквизиты.АктРассмотренияВозврата) 
		И Реквизиты.СтатусДокумента <> Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаЗавершен Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ПерестикеровкаПереоценкаТовары.Ссылка КАК Регистратор,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.Дата КАК Период,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.Склад КАК Склад,
	|	ПерестикеровкаПереоценкаТовары.Номенклатура,
	|	ПерестикеровкаПереоценкаТовары.Качество,
	|	ПерестикеровкаПереоценкаТовары.Количество
	|ИЗ
	|	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
	|ГДЕ
	|	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ПерестикеровкаПереоценкаТовары.Ссылка,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.Дата,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.СкладОприходования,
	|	ПерестикеровкаПереоценкаТовары.НоменклатураНовая,
	|	ПерестикеровкаПереоценкаТовары.КачествоНовый,
	|	ПерестикеровкаПереоценкаТовары.Количество
	|ИЗ
	|	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
	|ГДЕ
	|	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка";
	
		
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабТоваров);
	
	Возврат ТабТоваров;
	
КонецФункции

Функция РегистрыСведений_ЦеныНоменклатуры(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	Таб = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраСведений("ЦеныНоменклатуры", Таб);
	
	ПараметрыДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(вхСсылкаНаДокумент, "СтатусДокумента,АктРассмотренияВозврата,Дата,флОбновлятьЦены,ВидОперации, ВалютаДокумента, КурсДокумента, КратностьДокумента");
	
	Если НЕ ПараметрыДокумента.флОбновлятьЦены Тогда
		Возврат Таб;
	КонецЕсли;
	
	Если ПараметрыДокумента.Дата < ПараметрыСеанса.ДатаНачалаРаботыТовары Тогда
		Возврат Таб;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыДокумента.АктРассмотренияВозврата) 
		И ПараметрыДокумента.СтатусДокумента <> Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаЗавершен Тогда
		Возврат Таб;
	КонецЕсли;

	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПерестикеровкаПереоценкаТовары.Ссылка.Ссылка КАК Регистратор,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.Дата КАК Период,
	|	ВЫБОР
	|		КОГДА ПерестикеровкаПереоценкаТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийУценки.УценкаПоКачеству)
	|			ТОГДА ПерестикеровкаПереоценкаТовары.Номенклатура
	|		ИНАЧЕ ПерестикеровкаПереоценкаТовары.НоменклатураНовая
	|	КОНЕЦ КАК Номенклатура,
	|	ПерестикеровкаПереоценкаТовары.Ссылка.ВалютаДокумента КАК Валюта,
	|	ПерестикеровкаПереоценкаТовары.ЦенаНовая КАК Цена,
	|	ВЫБОР
	|		КОГДА ПерестикеровкаПереоценкаТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийУценки.УценкаПоКачеству)
	|			ТОГДА ПерестикеровкаПереоценкаТовары.Номенклатура
	|		ИНАЧЕ ПерестикеровкаПереоценкаТовары.ЕдиницаИзмеренияНовая
	|	КОНЕЦ КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
	|ГДЕ
	|	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втТовары.Регистратор,
	|	втТовары.Период,
	|	втТовары.Номенклатура,
	|	втТовары.Валюта,
	|	втТовары.Цена,
	|	втТовары.ЕдиницаИзмерения
	|ИЗ
	|	втТовары КАК втТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|				&Дата,
	|				Номенклатура В
	|						(ВЫБРАТЬ
	|							втТовары.Номенклатура
	|						ИЗ
	|							втТовары)
	|					И ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.Номенклатура = втТовары.Номенклатура)
	|ГДЕ
	|	НЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) = втТовары.Цена"
	);
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("Дата", Новый Граница(вхСсылкаНаДокумент.МоментВремени(), ВидГраницы.Исключая));
	
	ЗакупочнаяРуб 	= Константы.ЗакупочныйТипЦенРуб.Получить();
	Запрос.УстановитьПараметр("ТипЦен", ЗакупочнаяРуб);
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВалютаРубль 	= ПараметрыСеанса.ВалютаРубль;
	ВалютаДоллар 	= ПараметрыСеанса.ВалютаДоллар;
	ВалютаЕвро 		= ПараметрыСеанса.ВалютаЕвро;
	
	ЗакупочнаяДолл 	= Константы.ЗакупочныйТипЦенДолл.Получить();
	ЗакупочнаяЕвро 	= Константы.ЗакупочныйТипЦенЕвро.Получить();
	
	КурсРуб 	= МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРубль, 	ПараметрыДокумента.Дата);
	КурсДолл 	= МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДоллар, ПараметрыДокумента.Дата);
	КурсЕвро 	= МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаЕвро, 	ПараметрыДокумента.Дата);
	
	текПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Пока Выборка.Следующий() Цикл
		
		//Рубли
		Движение = Таб.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.Обновил 	= текПользователь;
		Движение.Валюта 	= ВалютаРубль;
		Движение.ТипЦен 	= ЗакупочнаяРуб;
		Движение.Цена 		= МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена,
				ПараметрыДокумента.ВалютаДокумента, ВалютаРубль,
				ПараметрыДокумента.КурсДокумента, КурсРуб.Курс,
				ПараметрыДокумента.КратностьДокумента, КурсРуб.Кратность);
		
		//Доллары
		Движение = Таб.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.Обновил 	= текПользователь;
		Движение.Валюта 	= ВалютаДоллар;
		Движение.ТипЦен 	= ЗакупочнаяДолл;
		Движение.Цена 		= МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена,
				ПараметрыДокумента.ВалютаДокумента, ВалютаДоллар,
				ПараметрыДокумента.КурсДокумента, КурсДолл.Курс,
				ПараметрыДокумента.КратностьДокумента, КурсДолл.Кратность);
				
		//Евро
		Движение = Таб.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.Обновил 	= текПользователь;
		Движение.Валюта 	= ВалютаЕвро;
		Движение.ТипЦен 	= ЗакупочнаяЕвро;
		Движение.Цена 		= МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена,
				ПараметрыДокумента.ВалютаДокумента, ВалютаЕвро,
				ПараметрыДокумента.КурсДокумента, КурсЕвро.Курс,
				ПараметрыДокумента.КратностьДокумента, КурсЕвро.Кратность);
				
	КонецЦикла;
	
	Возврат Таб;
	
КонецФункции
//// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//Таблица для расчета партий для списания
Функция ТаблицыДляРасчетаСписанияПоПартиям(СсылкаНаДокумент, вхФильтр = Неопределено) Экспорт
	
	ВыполнятьДвижения = Истина;
	
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(СсылкаНаДокумент, "Дата,флОбновлятьЦены,ВидОперации, СтатусДокумента, АктРассмотренияВозврата");
	
	Если ЗначениеЗаполнено(Реквизиты.АктРассмотренияВозврата) 
		И Реквизиты.СтатусДокумента <> Справочники.СтатусыДокументов.ПерестикеровкаПереоценкаЗавершен Тогда
		ВыполнятьДвижения = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПерестикеровкаПереоценкаТовары.НомерСтроки,
	                      |	ПерестикеровкаПереоценкаТовары.Номенклатура,
	                      |	ПерестикеровкаПереоценкаТовары.Ссылка.Склад,
	                      |	ПерестикеровкаПереоценкаТовары.Качество,
	                      |	ПерестикеровкаПереоценкаТовары.Количество,
	                      |	ПерестикеровкаПереоценкаТовары.СтрокаПрихода,
	                      |	ВЫБОР
	                      |		КОГДА ПерестикеровкаПереоценкаТовары.СтрокаПрихода = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ПустаяСтрокаПрихода,
	                      |	ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.Собственный) КАК СтатусПартии,
	                      |	""Списание"" КАК ВидСписания,
	                      |	ЛОЖЬ КАК ОприходоватьПоVMI,
	                      |	ВЫБОР
	                      |		КОГДА ПерестикеровкаПереоценкаТовары.Организация = &ПустаяОрганизация
	                      |			ТОГДА ПерестикеровкаПереоценкаТовары.Ссылка.Организация
	                      |		ИНАЧЕ ПерестикеровкаПереоценкаТовары.Организация
	                      |	КОНЕЦ КАК Организация,
	                      |	ПерестикеровкаПереоценкаТовары.НомерСтроки КАК НомерСтрокиВДокументе
	                      |ИЗ
	                      |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
	                      |ГДЕ
	                      |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
	                      |	И &ВыполнятьДвижения");
	
	Запрос.УстановитьПараметр("ВыполнятьДвижения", ВыполнятьДвижения);
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("ПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
	Если ТипЗнч(вхФильтр) = Тип("Структура") и вхФильтр.Свойство("Номенклатура") Тогда 
		Запрос.Текст = Запрос.Текст + " И ПерестикеровкаПереоценкаТовары.Номенклатура = &Номенклатура";
		Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

//Формирование движений по регистру ПартииТоваров
Функция ДвиженияПартииТоваров(СсылкаНаДокумент, ТаблицаДвижений)
	
	ДанныеПоВалютам = ДанныеПоВалютам(СсылкаНаДокумент);
		
	НовыйТаблицаДвижений = ТаблицаДвижений.СкопироватьКолонки();
	СоотвСтрокиПрихода = Новый Соответствие;
	
	Для Каждого СтрокаРасхода Из ТаблицаДвижений Цикл
		СтрокаДокумента = СсылкаНаДокумент.Товары[СтрокаРасхода.НомерСтрокиВДокументе - 1];
		
		ДвижениеРасхода = НовыйТаблицаДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеРасхода, СтрокаРасхода);
		
		ДвижениеПрихода = НовыйТаблицаДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеПрихода, СтрокаРасхода,,"ВидДвижения");
		ДвижениеПрихода.ВидДвижения = ВидДвиженияНакопления.Приход;
		ДвижениеПрихода.СтрокаПрихода = СтрокаДокумента.СтрокаПриходаОприходованная;
		
		Если Не ЗначениеЗаполнено(СтрокаДокумента.СтрокаПрихода) И СоотвСтрокиПрихода[СтрокаДокумента.СтрокаПриходаОприходованная] = Неопределено Тогда 
			СоотвСтрокиПрихода.Вставить(СтрокаДокумента.СтрокаПриходаОприходованная, СтрокаРасхода.СтрокаПрихода); 	
		КонецЕсли;
		
		Если		СсылкаНаДокумент.ВидОперации = Перечисления.ВидыОперацийУценки.Перестикеровка Тогда
			ДвижениеПрихода.Номенклатура = СтрокаДокумента.НоменклатураНовая;
			ДвижениеПрихода.Качество = СтрокаДокумента.КачествоНовый;
			УстановитьСуммы(ДвижениеПрихода, ДанныеПоВалютам, СтрокаДокумента.СуммаНовая);
		ИначеЕсли	СсылкаНаДокумент.ВидОперации = Перечисления.ВидыОперацийУценки.Уценка Тогда
			ДвижениеПрихода.Номенклатура = СтрокаДокумента.НоменклатураНовая;
			ДвижениеПрихода.Качество = СтрокаДокумента.КачествоНовый;
			//УстановитьСуммы(ДвижениеПрихода, ДанныеПоВалютам, СтрокаДокумента.СуммаНовая);
		ИначеЕсли	СсылкаНаДокумент.ВидОперации = Перечисления.ВидыОперацийУценки.УценкаПоКачеству Тогда
			ДвижениеПрихода.Качество = СтрокаДокумента.КачествоНовый;
			//УстановитьСуммы(ДвижениеПрихода, ДанныеПоВалютам, СтрокаДокумента.СуммаНовая);
		КонецЕсли;
		ДвижениеПрихода.Склад = СсылкаНаДокумент.СкладОприходования;
	КонецЦикла;
	
	
	//Перенесем реквизиты из строки прихода списанной в оприходованную
	СтрокаРеквизитов = "НомерГТД,СтранаПроисхождения,ТорговаяТочка,ДоговорКонтрагента";
	МассивРеквизитов = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СтрокаРеквизитов);
	Для Каждого КлючЗначение Из СоотвСтрокиПрихода Цикл 
		РеквизитыОпр = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КлючЗначение.Ключ, СтрокаРеквизитов);	
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КлючЗначение.Значение, СтрокаРеквизитов);
		
		НужноИзменять = Ложь;
		Для Каждого Реквизит Из МассивРеквизитов Цикл 
			Если РеквизитыОпр[Реквизит] <> Реквизиты[Реквизит] Тогда 
				НужноИзменять = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НужноИзменять Тогда 
			Об = КлючЗначение.Ключ.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(Об, Реквизиты, СтрокаРеквизитов);
			Об.Записать();
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДвижений = НовыйТаблицаДвижений;
	
	Возврат ТаблицаДвижений;
	
КонецФункции

Функция ДанныеПоВалютам(СсылкаНаДокумент)
	
	Структура = Новый Структура;
	Структура.Вставить("ДатаДокумента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДокумент, "Дата"));
	Структура.Вставить("ВалютаДокумента", ОбщегоНазначения.ПолучитьЗначениеРеквизита(СсылкаНаДокумент, "ВалютаДокумента"));
	Структура.Вставить("КурсДокумента", ОбщегоНазначения.ПолучитьЗначениеРеквизита(СсылкаНаДокумент, "КурсДокумента"));
	Структура.Вставить("КратностьДокумента", ОбщегоНазначения.ПолучитьЗначениеРеквизита(СсылкаНаДокумент, "КратностьДокумента"));
	Структура.Вставить("КурсДоллара", МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаДоллар, Структура.ДатаДокумента));
	Структура.Вставить("КурсЕвро", МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаЕвро, Структура.ДатаДокумента));
	
	Возврат Структура;
	
КонецФункции

Процедура УстановитьСуммы(Движение, ДанныеПоВалютам, Сумма)
	
	Если ДанныеПоВалютам.ВалютаДокумента = ПараметрыСеанса.ВалютаРубль Тогда
		Движение.СуммаРубли = Сумма;
		Движение.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаРубль,
											ПараметрыСеанса.ВалютаДоллар, 1, ДанныеПоВалютам.КурсДоллара.Курс, 1, ДанныеПоВалютам.КурсДоллара.Кратность);
		Движение.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаРубль,
											ПараметрыСеанса.ВалютаЕвро, 1, ДанныеПоВалютам.КурсЕвро.Курс, 1, ДанныеПоВалютам.КурсЕвро.Кратность);
	ИначеЕсли ДанныеПоВалютам.ВалютаДокумента = ПараметрыСеанса.ВалютаДоллар Тогда
		Движение.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаДоллар,
											ПараметрыСеанса.ВалютаРубль, ДанныеПоВалютам.КурсДокумента, 1, ДанныеПоВалютам.КратностьДокумента, 1);
		Движение.СуммаДоллары = Сумма;
		Движение.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаДоллар,
											ПараметрыСеанса.ВалютаЕвро, ДанныеПоВалютам.КурсДоллара.Курс, ДанныеПоВалютам.КурсЕвро.Курс, ДанныеПоВалютам.КурсДоллара.Кратность, ДанныеПоВалютам.КурсЕвро.Кратность);
	ИначеЕсли ДанныеПоВалютам.ВалютаДокумента = ПараметрыСеанса.ВалютаЕвро Тогда
		Движение.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаЕвро,
											ПараметрыСеанса.ВалютаРубль, ДанныеПоВалютам.КурсДокумента, 1, ДанныеПоВалютам.КратностьДокумента, 1);
		Движение.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, ПараметрыСеанса.ВалютаЕвро,
											ПараметрыСеанса.ВалютаДоллар, ДанныеПоВалютам.КурсЕвро.Курс, ДанныеПоВалютам.КурсДоллара.Курс, ДанныеПоВалютам.КурсЕвро.Кратность, ДанныеПоВалютам.КурсДоллара.Кратность);
		Движение.СуммаЕвро = Сумма;
	КонецЕсли;
	
КонецПроцедуры

//Формирование движений по регистру ТоварыНаСкладах
Процедура ДополнитьТаблицуДвижений(вхТребуемая, вхСсылкаНаДокумент, вхФильтр)
	Если ТипЗнч(вхФильтр) = Тип("Структура")И вхФильтр.Свойство("Номенклатура") Тогда 
		//Отбор = Новый Структура("ВидДвижения,Номенклатура", ВидДвиженияНакопления.Приход, вхФильтр.Номенклатура);
		//Строки = вхИсходная.НайтиСтроки(Отбор);
		//Для Каждого СтрокаТЧ Из Строки Цикл 
		//	ЗаполнитьЗначенияСвойств(вхТребуемая.Добавить(), СтрокаТЧ);
		//КонецЦикла;
		ДанныеПоВалютам = ДанныеПоВалютам(вхСсылкаНаДокумент);
		Запрос = Новый Запрос;
		Запрос.Текст =  "ВЫБРАТЬ
		                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		                |	ПерестикеровкаПереоценкаТовары.Ссылка.Дата КАК Период,
		                |	ПерестикеровкаПереоценкаТовары.Ссылка КАК Регистратор,
		                |	ПерестикеровкаПереоценкаТовары.Ссылка.СкладОприходования КАК Склад,
		                |	ВЫБОР
		                |		КОГДА ПерестикеровкаПереоценкаТовары.Ссылка.ВидОперации = &ВидОперации
		                |			ТОГДА ПерестикеровкаПереоценкаТовары.Номенклатура
		                |		ИНАЧЕ ПерестикеровкаПереоценкаТовары.НоменклатураНовая
		                |	КОНЕЦ КАК Номенклатура,
		                |	ПерестикеровкаПереоценкаТовары.КачествоНовый КАК Качество,
		                |	ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.Собственный) КАК СтатусПартии,
		                |	ПерестикеровкаПереоценкаТовары.СтрокаПрихода,
		                |	ПерестикеровкаПереоценкаТовары.Ссылка.Организация,
		                |	ПерестикеровкаПереоценкаТовары.Количество,
		                |	ПерестикеровкаПереоценкаТовары.СуммаНовая,
		                |	ПерестикеровкаПереоценкаТовары.Ссылка.ВидОперации
		                |ИЗ
		                |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
		                |ГДЕ
		                |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
		                |	И ВЫБОР
		                |			КОГДА ПерестикеровкаПереоценкаТовары.Ссылка.ВидОперации = &ВидОперации
		                |				ТОГДА ПерестикеровкаПереоценкаТовары.Номенклатура = &Номенклатура
		                |			ИНАЧЕ ПерестикеровкаПереоценкаТовары.НоменклатураНовая = &Номенклатура
		                |		КОНЕЦ";
		Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийУценки.УценкаПоКачеству);				
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
		Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			НоваяСтрока = вхТребуемая.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если Выборка.ВидОперации = Перечисления.ВидыОперацийУценки.Уценка
				ИЛИ Выборка.ВидОперации = Перечисления.ВидыОперацийУценки.УценкаПоКачеству Тогда 
				УстановитьСуммы(НоваяСтрока, ДанныеПоВалютам, Выборка.СуммаНовая);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура УдалитьДвиженияТоварыНаСкладах(СсылкаНаДокумент, ТаблицаДвижений)
	
	НаборЗаписей = РегистрыНакопления.ТоварыНаСкладах.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(СсылкаНаДокумент);
	Для Каждого СтрокаРасхода Из ТаблицаДвижений Цикл
		СтрокаДокумента = СсылкаНаДокумент.Товары[СтрокаРасхода.НомерСтроки - 1];
		
		ДвижениеРасхода = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеРасхода, СтрокаРасхода);
		
		ДвижениеПрихода = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеПрихода, СтрокаРасхода,,"ВидДвижения");
		ДвижениеПрихода.ВидДвижения = ВидДвиженияНакопления.Приход;
		ДвижениеПрихода.Номенклатура = СтрокаДокумента.НоменклатураНовая;
		ДвижениеПрихода.Качество = СтрокаДокумента.КачествоНовый;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ТаблицаДляКонтроляОстатков(вхСсылкаНаДокумент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.Ссылка.Склад КАК Склад,
	               |	Док.Номенклатура КАК Номенклатура,
	               |	Док.Качество КАК Качество,
	               |	СУММА(Док.Количество) КАК Количество
	               |ИЗ
	               |	Документ.ПерестикеровкаПереоценка.Товары КАК Док
	               |ГДЕ
	               |	Док.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Док.Ссылка.Склад,
	               |	Док.Номенклатура,
	               |	Док.Качество";
				   
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

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
	
	Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Если Проведение 
			И Дата >= ПараметрыСеанса.ДатаНачалаРаботыТовары 
			И Дата >= глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	ПерестикеровкаПереоценкаТовары.Ссылка.Дата КАК Период,
			               |	ПерестикеровкаПереоценкаТовары.Ссылка КАК Регистратор,
			               |	ПерестикеровкаПереоценкаТовары.Номенклатура КАК Номенклатура
			               |ПОМЕСТИТЬ втЗаписи
			               |ИЗ
			               |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
			               |ГДЕ
			               |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
			               |	И ПерестикеровкаПереоценкаТовары.Номенклатура <> &ПустаяНоменклатура
			               |
			               |ОБЪЕДИНИТЬ ВСЕ
			               |
			               |ВЫБРАТЬ
			               |	ПерестикеровкаПереоценкаТовары.Ссылка.Дата,
			               |	ПерестикеровкаПереоценкаТовары.Ссылка,
			               |	ПерестикеровкаПереоценкаТовары.НоменклатураНовая
			               |ИЗ
			               |	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
			               |ГДЕ
			               |	ПерестикеровкаПереоценкаТовары.Ссылка = &Ссылка
			               |	И ПерестикеровкаПереоценкаТовары.НоменклатураНовая <> &ПустаяНоменклатура
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	втЗаписи.Период,
			               |	втЗаписи.Регистратор,
			               |	втЗаписи.Номенклатура
			               |ИЗ
			               |	втЗаписи КАК втЗаписи";
			Запрос.УстановитьПараметр("ПустаяНоменклатура", Справочники.Номенклатура.ПустаяСсылка());			   
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			Выборка = Запрос.Выполнить().Выгрузить();
			Для Каждого СтрокаТЧ Из Выборка Цикл 
				ЗаполнитьЗначенияСвойств(лРезультат.Добавить(), СтрокаТЧ); 
			КонецЦикла;
		КонецЕсли;
		
		Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
		
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Возврат Результат;

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
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.ПартииТоваров, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.ПерестикеровкаПереоценка;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхМетаданныеОтбора) Экспорт
	
	СтруктураВозврат = Новый Структура;
	
	Если (вхМетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика) тогда
		СтруктураВозврат = Новый Структура("Шапка, ТабличныеЧасти");
		СтруктураВозврат.Шапка = "Контрагент,ДоговорКонтрагента,Организация,Склад,ТорговаяТочка,СтатусДокумента";
		Соответствие = Новый Соответствие;
		Соответствие.Вставить("Товары", "Номенклатура, Количество, ЕдиницаИзмерения, КоличествоОтказ");
		Соответствие.Вставить("ПричиныОтказов", "ПричинаОтказа, Количество");
		СтруктураВозврат.ТабличныеЧасти = Соответствие;
	ИначеЕсли (вхМетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_77) тогда
		СтруктураВозврат = ОбменДаннымиКлиентСервер.РеквизитыКонтроляПоДокументу(ПолучитьМетаданные(), ИсключаемыеРеквизитыКонтроляРегистрации());
	КонецЕсли;
	
	Возврат СтруктураВозврат

КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
КонецФункции

Функция ИсключаемыеРеквизитыКонтроляРегистрации() Экспорт
	
	ИсключаемыеРеквизиты = ОбменДаннымиКлиентСервер.ИнициализироватьТаблицуИсключаемыхРеквизитовКонтроля();
	ОбменДаннымиКлиентСервер.ДобавитьВИсключаемыеРевизиты(ИсключаемыеРеквизиты, "Ссылка");
	
	Возврат ИсключаемыеРеквизиты;
	
КонецФункции

//ОБМЕН
Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена) Экспорт
	
	Результат = Новый Массив;
	
	лМетаданныеПланаОбмена = Неопределено;
	лТип = ТипЗнч(вхПланОбмена);
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.Найти(вхПланОбмена);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.ПланыОбмена.Содержит(вхПланОбмена) тогда
		лМетаданныеПланаОбмена = вхПланОбмена;
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = Неопределено) тогда
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда 
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		
		лЗапрос = Новый Запрос;
		лЗапрос.УстановитьПараметр("ТаблицаСсылок", вхТаблицаСсылокНаОбъекты);
		лЗапрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
		лЗапрос.УстановитьПараметр("ПустаяЗаявка", Документы.ЗаявкаПокупателя.ПустаяСсылка());
		лЗапрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Ссылка
		|ПОМЕСТИТЬ Объекты
		|ИЗ
		|	&ТаблицаСсылок КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПерестикеровкаПереоценка.Ссылка КАК Ссылка,
		|	ПерестикеровкаПереоценка.Ссылка.ВидОперации КАК ВидОперации,
		|	ПерестикеровкаПереоценка.Номер,
		|	ПерестикеровкаПереоценка.Дата,
		|	ПерестикеровкаПереоценка.Склад.ФизическийСклад КАК Склад,
		|	ЗНАЧЕНИЕ(Справочник.ТорговыеТочки.ПустаяСсылка) КАК Контрагент,
		|	ПерестикеровкаПереоценка.Организация КАК Организация,
		|	ПерестикеровкаПереоценкаТовары.Номенклатура КАК НоменклатураИсходнаяСсылка,
		|	ПерестикеровкаПереоценкаТовары.Номенклатура.Наименование КАК НоменклатураИсходнаяНаименование,
		|	ПерестикеровкаПереоценкаТовары.Номенклатура.Артикул КАК НоменклатураИсходнаяАртикул,
		|	ПерестикеровкаПереоценкаТовары.НоменклатураНовая КАК НоменклатураЗаменыСсылка,
		|	ПерестикеровкаПереоценкаТовары.НоменклатураНовая.Наименование КАК НоменклатураЗаменыНаименование,
		|	ПерестикеровкаПереоценкаТовары.НоменклатураНовая.Артикул КАК НоменклатураЗаменыАртикул,
		|	ЕСТЬNULL(ПерестикеровкаПереоценкаТовары.СтрокаЗаявки.IDSite, """") КАК Партия,
		|	ВЫБОР
		|		КОГДА ПерестикеровкаПереоценкаТовары.СтрокаЗаявки.ПрайсПоставщика.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК КроссСток,
		|	ПерестикеровкаПереоценкаТовары.КоличествоПлан КАК Количество,
		|	ЕСТЬNULL(ПерестикеровкаПереоценкаТовары.СтрокаЗаявки.Заявка.ТорговаяТочка, ЗНАЧЕНИЕ(Справочник.ТорговыеТочки.ПустаяСсылка)) КАК Клиент,
		|	ЕСТЬNULL(ПерестикеровкаПереоценкаТовары.СтрокаЗаявки.Заявка.ТорговаяТочка.Наименование, """") КАК КлиентНаименование,
		|	ЕСТЬNULL(ПерестикеровкаПереоценкаТовары.СтрокаЗаявки.Заявка.Контрагент.ЮрФизЛицо.Порядок, 0) = 0 КАК ЭтоЮридическоеЛицо,
		|	ЗНАЧЕНИЕ(Справочник.Города.ПустаяСсылка) КАК Город,
		|	"""" КАК ГородНаименование,
		|	"""" КАК МаршрутДоставкиКод,
		|	"""" КАК МаршрутДоставкиНаименование,
		|	КОНЕЦПЕРИОДА(&ТекущаяДата, ГОД) КАК ДатаОтгрузки,
		|	ПерестикеровкаПереоценка.СкладОприходования КАК СкладПолучатель,
		|	ЛОЖЬ КАК ВыгруженВТопЛог
		|ИЗ
		|	Документ.ПерестикеровкаПереоценка.Товары КАК ПерестикеровкаПереоценкаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПерестикеровкаПереоценка КАК ПерестикеровкаПереоценка
		|		ПО ПерестикеровкаПереоценкаТовары.Ссылка = ПерестикеровкаПереоценка.Ссылка
		|ГДЕ
		|	ПерестикеровкаПереоценка.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты)
		|	И ПерестикеровкаПереоценкаТовары.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты)
		|	И ПерестикеровкаПереоценка.Склад.ОбменСTopLog
		|	И НЕ ПерестикеровкаПереоценка.флНеВыгружатьВТопЛог
		|	И ПерестикеровкаПереоценкаТовары.КоличествоПлан > 0
		|ИТОГИ
		|	МАКСИМУМ(Контрагент),
		|	МАКСИМУМ(ГородНаименование),
		|	МАКСИМУМ(МаршрутДоставкиКод),
		|	МАКСИМУМ(ДатаОтгрузки)
		|ПО
		|	Ссылка";
		
		лРезультатЗапроса = лЗапрос.Выполнить();
		
		Если НЕ лРезультатЗапроса.Пустой() Тогда
			лТипОбъектаXDTO = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ЗаказНаОтгрузку");
			лВыборка = лРезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
			
			Пока лВыборка.Следующий() Цикл
				//ЗаполнитьСтрокиЗаявок(лВыборка.Ссылка);
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				
				ЗаполнитьЗначенияСвойств(лОбъект, лВыборка, "Номер,Дата,ДатаОтгрузки");
				лОбъект.СуммаДокумента = 0;
				Если лВыборка.ВидОперации = Перечисления.ВидыОперацийУценки.Перестикеровка Тогда
					лОбъект.ВидДокумента = "Перестикеровка";
				Иначе
					лОбъект.ВидДокумента = "Уценка";
				КонецЕсли;
				лОбъект.Ссылка = XMLСтрока(лВыборка.Ссылка);
				лОбъект.СкладСсылка = XMLСтрока(лВыборка.Склад);
				лОбъект.КонтрагентСсылка = XMLСтрока(лВыборка.Контрагент);
				лОбъект.ОрганизацияСсылка = XMLСтрока(лВыборка.Организация);
				лОбъект.ТипДоставки = "";
				лОбъект.СкладПолучательСсылка = XMLСтрока(лВыборка.СкладПолучатель);
				лОбъект.МаршрутДоставкиКод = лВыборка.МаршрутДоставкиКод;
				
				ОбменДаннымиКлиентСервер.ДополнитьДаннымиПоПечати(лОбъект, лВыборка.Ссылка);
				
				лТовары = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ЗаказНаОтгрузку.Перестикеровка"));
				лТоварыСписок = лТовары.ПолучитьСписок("СтрокаПерестикеровка");
				
				ВыборкаПоТоварам = лВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаПоТоварам.Следующий() Цикл
					НоваяСтрока = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), лТоварыСписок.ВладеющееСвойство.Тип.Имя)); 
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоТоварам, 
					"НоменклатураИсходнаяНаименование,НоменклатураИсходнаяАртикул,
					|НоменклатураЗаменыНаименование,НоменклатураЗаменыАртикул,
					|Партия,Количество");
					НоваяСтрока.НоменклатураИсходнаяСсылка = XMLСтрока(ВыборкаПоТоварам.НоменклатураИсходнаяСсылка);
					НоваяСтрока.НоменклатураЗаменыСсылка = XMLСтрока(ВыборкаПоТоварам.НоменклатураЗаменыСсылка);
					//НоваяСтрока.КлиентСсылка = XMLСтрока(ВыборкаПоТоварам.Клиент);
					//НоваяСтрока.ГородСсылка = XMLСтрока(ВыборкаПоТоварам.Город);
					//НоваяСтрока.МаршрутДоставкиСсылка = XMLСтрока(ВыборкаПоТоварам.МаршрутДоставки);
					//НоваяСтрока.Цена = 0;
					//НоваяСтрока.ГТД = "";
					//НоваяСтрока.СтранаКод = "";
					//НоваяСтрока.СтранаНаименование = "";
					лТоварыСписок.Добавить(НоваяСтрока);

				КонецЦикла;	
				
				лОбъект.Перестикеровка = лТовары;
				Результат.Добавить(лОбъект);
				
			КонецЦикла;
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

