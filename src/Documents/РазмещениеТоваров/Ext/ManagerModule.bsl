﻿
Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "РазмещениеТоваров") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "РазмещениеТоваров",
		РегистрыНакопления_РазмещениеТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
		
		ДобавитьВОчередьПересчетаКоличестваРазмещения(вхСсылкаНаДокумент);
	КонецЕсли;
	
	
	
КонецПроцедуры

Процедура ДобавитьВОчередьПересчетаКоличестваРазмещения(вхСсылкаНаДокумент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РазмещениеТоваровТовары.ДокументОснование.АктРассмотренияВозврата КАК АктРассмотренияВозврата,
		|	РазмещениеТоваровТовары.ДокументОснование
		|ИЗ
		|	Документ.РазмещениеТоваров.Товары КАК РазмещениеТоваровТовары
		|ГДЕ
		|	РазмещениеТоваровТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.СобытияКОбработкеАктовРассмотренияВозврата.Добавить(
		Выборка.АктРассмотренияВозврата, 
		Перечисления.ВидыСобытийКОбработкеПроцессаВозвратов.ЗагрузкаРазмещенияИзТопЛог, 
		Выборка.ДокументОснование);
	КонецЦикла;
	
КонецПроцедуры

Функция РегистрыНакопления_РазмещениеТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено)
	
	ТабТоваров = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("РазмещениеТоваров", ТабТоваров);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РазмещениеТоваровТовары.Ссылка КАК Регистратор,
		|	РазмещениеТоваровТовары.Ссылка КАК ДокументРазмещения,
		|	РазмещениеТоваровТовары.Ссылка.Дата КАК Период,
		|	РазмещениеТоваровТовары.Склад КАК Склад,
		|	РазмещениеТоваровТовары.ДокументОснование,
		|	РазмещениеТоваровТовары.Номенклатура,
		|	РазмещениеТоваровТовары.Качество,
		|	СУММА(РазмещениеТоваровТовары.Количество) КАК Количество,
		|	РазмещениеТоваровТовары.ДатаРазмещения,
		|	РазмещениеТоваровТовары.СтрокаЗаявки
		|ИЗ
		|	Документ.РазмещениеТоваров.Товары КАК РазмещениеТоваровТовары
		|ГДЕ
		|	РазмещениеТоваровТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РазмещениеТоваровТовары.Склад,
		|	РазмещениеТоваровТовары.Ссылка,
		|	РазмещениеТоваровТовары.СтрокаЗаявки,
		|	РазмещениеТоваровТовары.Качество,
		|	РазмещениеТоваровТовары.Номенклатура,
		|	РазмещениеТоваровТовары.ДокументОснование,
		|	РазмещениеТоваровТовары.ДатаРазмещения,
		|	РазмещениеТоваровТовары.Ссылка.Дата,
		|	РазмещениеТоваровТовары.Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаДокумента = РезультатЗапроса.Выгрузить();
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДокумента, ТабТоваров);
			
	Возврат ТабТоваров;
	
КонецФункции



//Загрузка
Процедура ЗагрузитьЭлемент(ОбъектXDTO, вхОтправитель, Отказ, вхПараметры = Неопределено, НомерСообщения = 0) Экспорт
	
	лМетаданныеПланаОбмена = Метаданные.НайтиПоТипу(ТипЗнч(вхОтправитель));
	
	Если лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда 
		НомерПотока = ?(лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1);
		Попытка
			ЗагрузитьРезультатРазмещения(ОбъектXDTO, вхПараметры);
		Исключение
			СтруктураОшибки = Новый Структура;
			СтруктураОшибки.Вставить("ОбъектXDTO", ОбъектXDTO.Тип().Имя);
			СтруктураОшибки.Вставить("GUID", ОбъектXDTO.РазмещениеСсылка);
			СтруктураОшибки.Вставить("ИмяОбъектаМетаданных", "РазмещениеТоваров");
			СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
			СтруктураОшибки.Вставить("НомерСообщения", вхПараметры.НомерСообщения);
			СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
			СтруктураОшибки.Вставить("НомерПотока", ?(лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1));
			ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
			
			ДокСсылка = Документы.РазмещениеТоваров.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.РазмещениеСсылка));
			Если НЕ ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ДокСсылка) Тогда 
				РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ДокСсылка, вхПараметры.НомерСообщения, Истина, "Ошибка загрузки: "+ОписаниеОшибки(), , Ложь, НомерПотока); 
			КонецЕсли;

		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьРезультатРазмещения(ОбъектXDTO, ДопПараметры = Неопределено)
	
	лКлючАлгоритма = "Документ_РазмещениеТоваров_МодульМенеджера_ЗагрузитьРезультатРазмещения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////
	
	
	//Если в списке заказов нет возврата от покупателя, то загружать не нужно
	Загружать = Ложь;
	Заказы = ОбъектXDTO.Заказы.ПолучитьСписок("СтрокаЗаказы");
	Для каждого ЗаказНаПриемкуXDTO Из Заказы Цикл
		Если ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "ВозвратТоваровОтПокупателя"
			ИЛИ ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "ВозвратВПродажу"
			ИЛИ ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "Перестикеровка"
			ИЛИ ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "Уценка" Тогда
			Загружать = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Загружать Тогда
		Возврат;
	КонецЕсли;
	
	//Загружаем
	Если ЗначениеЗаполнено(ОбъектXDTO.РазмещениеСсылка) Тогда
		
		УИДРазмещения = Новый УникальныйИдентификатор(ОбъектXDTO.РазмещениеСсылка);
		ДокСсылка = Документы.РазмещениеТоваров.ПолучитьСсылку(УИДРазмещения);
		
		Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ДокСсылка) Тогда 
			ДокументОбъект = Документы.РазмещениеТоваров.СоздатьДокумент();
			ДокументОбъект.УстановитьСсылкуНового(ДокСсылка);
			//Запишем, чтобы было по какому объекту фиксировать ошибку
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.Дата = ТекущаяДата();
			ДокументОбъект.Записать();
		Иначе	
			ДокументОбъект = ДокСсылка.ПолучитьОбъект();
		КонецЕсли;
		
	Иначе
		ВызватьИсключение "Не указана ссылка размещения";
	КонецЕсли;
	
	ДокументОбъект.ОбменДанными.Загрузка = Ложь;
	
	//Шапка
	ДокументОбъект.ПометкаУдаления = Ложь;
	ДокументОбъект.Склад  =  Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.РазмещениеСкладСсылка));
	ДокументОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Если Не ЗначениеЗаполнено(ДокументОбъект.ДатаЗагрузкиИзТопЛог) Тогда
		ДокументОбъект.ДатаЗагрузкиИзТопЛог = ТекущаяДата();
	КонецЕсли;
	ДокументОбъект.ДатаОбновленияИзТопЛог = ТекущаяДата();
	ДокументОбъект.НомерWMS = ОбъектXDTO.РазмещениеНомерWMS;
	ДокументОбъект.ДатаWMS = ОбъектXDTO.РазмещениеДатаWMS;
	ДокументОбъект.Дата = ОбъектXDTO.РазмещениеДатаWMS;
	ДокументОбъект.Товары.Очистить();
	
	КачествоНовый = Справочники.Качество.Новый;
	Для каждого ЗаказНаПриемкуXDTO Из Заказы Цикл
		
		Если ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "ВозвратТоваровОтПокупателя" Тогда
			ИмяТаблицыОснования = "ВозвратТоваровОтПокупателя";
		ИначеЕсли ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "ВозвратВПродажу" Тогда
			ИмяТаблицыОснования = "ПеремещениеТоваров";
		ИначеЕсли ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "Перестикеровка" ИЛИ  ЗаказНаПриемкуXDTO.ЗаказВидДокумента = "Уценка" Тогда
			ИмяТаблицыОснования = "ПерестикеровкаПереоценка";
		Иначе
			Продолжить;
		КонецЕсли;
		
		УИДВозврата = Новый УникальныйИдентификатор(ЗаказНаПриемкуXDTO.ЗаказСсылка);
		ВозвратОтПокупателяСсылка = Документы[ИмяТаблицыОснования].ПолучитьСсылку(УИДВозврата);
		Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ВозвратОтПокупателяСсылка) Тогда 
			ВызватьИсключение "Не найден документ """+ИмяТаблицыОснования+""" с ссылкой " + ЗаказНаПриемкуXDTO.ЗаказСсылка+", номер: "+ЗаказНаПриемкуXDTO.ЗаказНомер;
		КонецЕсли;
		
		ТоварыXDTO = ЗаказНаПриемкуXDTO.Товары.ПолучитьСписок("СтрокаТовары");
		СоотвSSID = ОбменДаннымиКлиентСервер.СоответствиеСтрокЗаявокИSSID(ТоварыXDTO, ВозвратОтПокупателяСсылка);
		Для Каждого СтрокаТовары Из ТоварыXDTO Цикл 
			
			СтрокаЗаявки = ОбменДаннымиКлиентСервер.НайтиСтрокуЗаявкиВСоответствии(СоотвSSID, СтрокаТовары.SSID);
			
			Если ИмяТаблицыОснования = "ВозвратТоваровОтПокупателя" И Не ЗначениеЗаполнено(СтрокаЗаявки) Тогда 
				ВызватьИсключение "Не найдена строка заявки с IDSite = " + СтрокаТовары.SSID;
				//Для возврата в продажу топлог IDSite не присылает
			КонецЕсли;
			
			НоваяСтрока = ДокументОбъект.Товары.Добавить();
			НоваяСтрока.ДокументОснование 		= ВозвратОтПокупателяСсылка;
			НоваяСтрока.Номенклатура 			= Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаТовары.НоменклатураСсылка));
			НоваяСтрока.Качество 				= КачествоНовый;
			НоваяСтрока.Количество 				= СтрокаТовары.КоличествоРазмещено;
			НоваяСтрока.СтрокаЗаявки 			= СтрокаЗаявки ;
			НоваяСтрока.ДатаРазмещения 			= СтрокаТовары.ДатаРазмещения;
			НоваяСтрока.Склад 					= Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаТовары.РазмещениеЯчейкаСкладСсылка));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Попытка
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		НомерСообщения = ?(ДопПараметры = Неопределено, 0, ДопПараметры.НомерСообщения);
		НомерПотока = ?(ДопПараметры = Неопределено, 0, ДопПараметры.НомерПотока);
		РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ДокументОбъект.Ссылка, НомерСообщения, , , , Ложь, НомерПотока); 
		//Семенов И.П. 12.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(ДокументОбъект.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
	Исключение
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		Набор = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
		Набор.Отбор.СсылкаНаДокумент.Установить(ДокументОбъект.Ссылка);
		Стр = Набор.Добавить();
		Стр.СсылкаНаДокумент = ДокументОбъект.Ссылка;
		Набор.Записать(Истина);
		
		//Семенов И.П. 12.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(ДокументОбъект.Ссылка, ОбъектXDTO,,Истина,ОписаниеОшибки());
		//)Семенов И.П.
		ВызватьИсключение ОписаниеОшибки();

	КонецПопытки;
	
	
КонецПроцедуры

