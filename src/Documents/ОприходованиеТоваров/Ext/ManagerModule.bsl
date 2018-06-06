﻿
//// ОБРАБОТЧИКИ МОДУЛЯ ОБЪЕКТА

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	лКонтроль = Неопределено;
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДанныеОбъекта.Контроль", лКонтроль);
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	

	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ТоварыНаСкладах") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ТоварыНаСкладах",
		РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ЦеныНоменклатуры") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ЦеныНоменклатуры",
		РегистрыСведений_ЦеныНоменклатуры(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
	//Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") тогда
	//	ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ПартииТоваров",
	//	РегистрыНакопления_ПартииТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	//КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") тогда
		// регистр накопления "ПартииТоваров"
		
		НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
		
		лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
		
		лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
		лИсходная = лРазделенныеБазовая.Включенные;
								
		лТребуемая = РегистрыНакопления_ПартииТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры, лФильтр);
				
		лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
		ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров,
		лРазностныеДанные, лРазделенныеБазовая.Исключенные);
		
		ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
		Если лФильтр = Неопределено Тогда 
			РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Истина);
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

Функция СформироватьТаблицуТоваровДокумента(вхСсылкаНаДокумент, вхПараметры)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ВидДвижения,
	|	ОприходованиеТоваровТовары.Ссылка КАК Регистратор,
	|	ОприходованиеТоваровТовары.Ссылка.Дата КАК Период,
	|	ОприходованиеТоваровТовары.Ссылка.Склад КАК Склад,
	|	ОприходованиеТоваровТовары.Номенклатура,
	|	ОприходованиеТоваровТовары.Качество,
	|	ОприходованиеТоваровТовары.СтрокаПрихода КАК СтрокаПрихода,
	|	ОприходованиеТоваровТовары.Количество,
	|	ОприходованиеТоваровТовары.СтрокаПрихода.ТорговаяТочка КАК ТорговаяТочка,
	|	&СостояниеПартии,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаРубль
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРубли,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаДоллар
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДоллары,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаЕвро
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаЕвро,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.Склад.СкладVMI
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.ПринятыйНаОтветХранение)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.Собственный)
	|	КОНЕЦ КАК СтатусПартии,
	|	ОприходованиеТоваровТовары.Ссылка.Организация КАК Организация,
	|	ОприходованиеТоваровТовары.ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.УчитыватьНДС
	|				И ОприходованиеТоваровТовары.Ссылка.СуммаВключаетНДС
	|			ТОГДА ОприходованиеТоваровТовары.Сумма - ОприходованиеТоваровТовары.СуммаНДС
	|		ИНАЧЕ ОприходованиеТоваровТовары.Сумма
	|	КОНЕЦ КАК СуммаБезНДС
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
	|ГДЕ
	|	ОприходованиеТоваровТовары.Ссылка = &Ссылка";
		
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);         
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("СостояниеПартии", Перечисления.СостоянияПартииТовараVMI.Поступил);
	Запрос.УстановитьПараметр("ВалютаРубль", ПараметрыСеанса.ВалютаРубль);
	Запрос.УстановитьПараметр("ВалютаДоллар", ПараметрыСеанса.ВалютаДоллар);
	Запрос.УстановитьПараметр("ВалютаЕвро", ПараметрыСеанса.ВалютаЕвро);
	
	ТабТоваров = Запрос.Выполнить().Выгрузить();
	
	Если ТабТоваров.Количество() > 0 Тогда
		ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
		ВалютаДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ВалютаДокумента");
		КурсДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "КурсВзаиморасчетов");
		КратностьДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "КратностьВзаиморасчетов");
		КурсДоллара = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаДоллар, ДатаДокумента);
		КурсЕвро = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаЕвро, ДатаДокумента);
		Если ВалютаДокумента = ПараметрыСеанса.ВалютаРубль Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
				ПараметрыСеанса.ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
				Товар.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
				ПараметрыСеанса.ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
			КонецЦикла;
			
		ИначеЕсли ВалютаДокумента = ПараметрыСеанса.ВалютаДоллар Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаДоллары, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
				Товар.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаДоллары, ПараметрыСеанса.ВалютаЕвро,
				ПараметрыСеанса.ВалютаЕвро, КурсДоллара.Курс, КурсЕвро.Курс, КурсДоллара.Кратность, КурсЕвро.Кратность);
				Товар.СуммаБезНДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаБезНДС, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
			КонецЦикла;
			
		ИначеЕсли ВалютаДокумента = ПараметрыСеанса.ВалютаЕвро Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаЕвро, ПараметрыСеанса.ВалютаЕвро,
				ПараметрыСеанса.ВалютаДоллар, КурсЕвро.Курс, КурсДоллара.Курс, КурсЕвро.Кратность, КурсДоллара.Кратность);
				Товар.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаЕвро, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
				Товар.СуммаБезНДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаБезНДС, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПроведениеДокументовКлиентСервер.ЗаписатьЗначение(вхПараметры, "ТаблицаТоваров", ТабТоваров);
	
	Возврат ТабТоваров;
	
КонецФункции

Функция РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	ТабТоваров = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ТоварыНаСкладах", ТабТоваров);
	
	лВидОперации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ВидОперации");
	ДатаДокумента =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	
	Если ДатаДокумента < ПараметрыСеанса.ДатаНачалаРаботыТовары
		//И (лВидОперации <> Перечисления.ВидыОперацийОприходованиеТоваров.ВводНачальныхОстатков) 
		Тогда
		Возврат ТабТоваров
	КонецЕсли;
	
	Если ДатаДокумента < глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СформироватьТаблицуТоваровДокумента(вхСсылкаНаДокумент, вхПараметры), ТабТоваров);
	
	Возврат ТабТоваров;
	
КонецФункции

Функция РегистрыНакопления_ПартииТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено, вхФильтр = Неопределено) Экспорт
	ТаблицаДвижений = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ПартииТоваров", ТаблицаДвижений);
	
	ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	
	Если ДатаДокумента < глЗначениеПеременной("ДатаЗапускаПроведенияПоПартиямРезервам") Тогда
		Возврат ТаблицаДвижений;
	КонецЕсли;
	
	Если ДатаДокумента < ПараметрыСеанса.ДатаНачалаРаботыТовары Тогда
		Возврат ТаблицаДвижений;
	КонецЕсли;
	
	//ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СформироватьТаблицуТоваровДокумента(вхСсылкаНаДокумент, вхПараметры), ТаблицаДвижений);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ВидДвижения,
	|	ОприходованиеТоваровТовары.Ссылка.Дата КАК Период,
	|	ОприходованиеТоваровТовары.Ссылка КАК Регистратор,
	|	ОприходованиеТоваровТовары.Номенклатура,
	|	ОприходованиеТоваровТовары.Ссылка.Склад КАК Склад,
	|	ОприходованиеТоваровТовары.Качество,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.Склад.СкладVMI
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.ПринятыйНаОтветХранение)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.Собственный)
	|	КОНЕЦ КАК СтатусПартии,
	|	ОприходованиеТоваровТовары.СтрокаПрихода КАК СтрокаПрихода,
	|	ОприходованиеТоваровТовары.Ссылка.Организация КАК Организация,
	|	ОприходованиеТоваровТовары.Количество,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаРубль
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРубли,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаДоллар
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДоллары,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.ВалютаДокумента = &ВалютаЕвро
	|			ТОГДА ОприходованиеТоваровТовары.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаЕвро,
	|	ВЫБОР
	|		КОГДА ОприходованиеТоваровТовары.Ссылка.УчитыватьНДС
	|				И ОприходованиеТоваровТовары.Ссылка.СуммаВключаетНДС
	|			ТОГДА ОприходованиеТоваровТовары.Сумма - ОприходованиеТоваровТовары.СуммаНДС
	|		ИНАЧЕ ОприходованиеТоваровТовары.Сумма
	|	КОНЕЦ КАК СуммаБезНДС,
	|	ОприходованиеТоваровТовары.НомерСтроки КАК НомерСтрокиВДокументе
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
	|ГДЕ
	|	ОприходованиеТоваровТовары.Ссылка = &Ссылка";
		
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);         
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВалютаРубль", ПараметрыСеанса.ВалютаРубль);
	Запрос.УстановитьПараметр("ВалютаДоллар", ПараметрыСеанса.ВалютаДоллар);
	Запрос.УстановитьПараметр("ВалютаЕвро", ПараметрыСеанса.ВалютаЕвро);
	Если ТипЗнч(вхФильтр) = Тип("Структура") И вхФильтр.Свойство("Номенклатура") Тогда 
		Запрос.Текст = Запрос.Текст + " И ОприходованиеТоваровТовары.Номенклатура = &Номенклатура";
		Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
	КонецЕсли;
	
	ТабТоваров = Запрос.Выполнить().Выгрузить();
	Если ТабТоваров.Количество() > 0 Тогда
		ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
		ВалютаДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ВалютаДокумента");
		КурсДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "КурсВзаиморасчетов");
		КратностьДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "КратностьВзаиморасчетов");
		КурсДоллара = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаДоллар, ДатаДокумента);
		КурсЕвро = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаЕвро, ДатаДокумента);
		Если ВалютаДокумента = ПараметрыСеанса.ВалютаРубль Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
				ПараметрыСеанса.ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
				Товар.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
				ПараметрыСеанса.ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
			КонецЦикла;
			
		ИначеЕсли ВалютаДокумента = ПараметрыСеанса.ВалютаДоллар Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаДоллары, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
				Товар.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаДоллары, ПараметрыСеанса.ВалютаЕвро,
				ПараметрыСеанса.ВалютаЕвро, КурсДоллара.Курс, КурсЕвро.Курс, КурсДоллара.Кратность, КурсЕвро.Кратность);
				Товар.СуммаБезНДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаБезНДС, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
			КонецЦикла;
			
		ИначеЕсли ВалютаДокумента = ПараметрыСеанса.ВалютаЕвро Тогда
			Для Каждого Товар Из ТабТоваров Цикл
				Товар.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаЕвро, ПараметрыСеанса.ВалютаЕвро,
				ПараметрыСеанса.ВалютаДоллар, КурсЕвро.Курс, КурсДоллара.Курс, КурсЕвро.Кратность, КурсДоллара.Кратность);
				Товар.СуммаРубли = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаЕвро, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
				Товар.СуммаБезНДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Товар.СуммаБезНДС, ПараметрыСеанса.ВалютаДоллар,
				ПараметрыСеанса.ВалютаРубль, КурсДокумента, 1, КратностьДокумента, 1);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТабТоваров, ТаблицаДвижений);
	
	Возврат ТаблицаДвижений;
	
КонецФункции

Функция РегистрыСведений_ЦеныНоменклатуры(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	ТабТоваров = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраСведений("ЦеныНоменклатуры", ТабТоваров);
	
	ПараметрыДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(вхСсылкаНаДокумент, "Дата,флОбновлятьЦены");
	
	Если НЕ ПараметрыДокумента.флОбновлятьЦены Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Если ПараметрыДокумента.Дата < ПараметрыСеанса.ДатаНачалаРаботыТовары Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Регистратор,
	|	Товары.Ссылка.Дата КАК Период,
	|	Товары.Ссылка.ТипЦен,
	|	Товары.Номенклатура,
	|	Товары.Ссылка.ВалютаДокумента КАК Валюта,
	|	Товары.Цена,
	|	Товары.ЕдиницаИзмерения,
	|	Товары.Ссылка.ТипЦен.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|	Товары.Ссылка.ТипЦен.СпособРасчетаЦены КАК СпособРасчетаЦены
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабТоваров);
	
	Возврат ТабТоваров;
	
КонецФункции

//// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.ОприходованиеТоваров;
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Шапка", "Дата,Проведен");
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
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) Тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.ПартииТоваров, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
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
	
	//лЭтоОтменаПроведения = Ложь;
	//лРежимЗаписи = Неопределено;
	//Если ЭтотОбъект.ДополнительныеСвойства.Свойство("РежимЗаписи", лРежимЗаписи) тогда
	//	лЭтоОтменаПроведения = (лРежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения);
	//КонецЕсли;
	Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Если Проведение 
			И Дата >= ПараметрыСеанса.ДатаНачалаРаботыТовары 
			И Дата >= глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
			//лВремТаблица = ЭтотОбъект.Товары.Выгрузить(,"Номенклатура");
			//лВремТаблица.Свернуть("Номенклатура");
			//Для Каждого лСтрокаТЧ Из лВремТаблица Цикл 
			//	лСтрокаРезультат = лРезультат.Добавить();
			//	лСтрокаРезультат.Номенклатура = лСтрокаТЧ.Номенклатура;
			//	лСтрокаРезультат.Период = ЭтотОбъект.Дата;
			//	лСтрокаРезультат.Регистратор = ЭтотОбъект.Ссылка;
			//КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	ОприходованиеТоваровТовары.Ссылка.Дата КАК Период,
			               |	ОприходованиеТоваровТовары.Ссылка КАК Регистратор,
			               |	ОприходованиеТоваровТовары.Номенклатура КАК Номенклатура
			               |ИЗ
			               |	Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
			               |ГДЕ
			               |	ОприходованиеТоваровТовары.Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(лРезультат.Добавить(), Выборка); 
			КонецЦикла;
		КонецЕсли;
		
		Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
		
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции