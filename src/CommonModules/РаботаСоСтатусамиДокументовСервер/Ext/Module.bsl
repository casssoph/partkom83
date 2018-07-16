﻿#Область ФормированиеИсторииЗаявок
Процедура ЗарегистрироватьИзменениеЗаявкиКлиента(ДокументСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаявкаПокупателя") или 
		 ТипЗнч(ДокументСсылка) =Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") тогда 
		ЗапросСостояния =ЗапросСостояние_ЗаявкаПокупателя();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаказПоставщику")  тогда 
	    ЗапросСостояния =ЗапросСостояние_ЗаказПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику")  тогда 
	    ЗапросСостояния =ЗапросСостояние_КорректировкаЗаказаПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")  тогда 
	    ЗапросСостояния =ЗапросСостояние_ПоступлениеТоваровУслуг();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг")  тогда 
	    ЗапросСостояния =ЗапросСостояние_РеализацияТоваровУслуг();            
	КонецЕсли;
	
	ЗапросСостояния.УстановитьПараметр("ДокументСсылка",ДокументСсылка);
	ЗапросСостояния.УстановитьПараметр("Период",ТекущаяУниверсальнаяДата());
	
	РезультатСостояние = ЗапросСостояния.Выполнить();
	
	Если РезультатСостояние.Пустой() тогда
		 Возврат;		
	КонецЕсли;
	
	ЗаписатьИзмененияЗаявки(РезультатСостояние)
	
КонецПроцедуры	


// <Описание процедуры>
//
Процедура ЗаписатьИзмененияЗаявки(РезультатСостояние)
	
	МенеджерРегистра = РегистрыСведений.ИсторияЗаявокПокупателя;
	
	ВыборкаДанных = РезультатСостояние.Выбрать();

	Пока ВыборкаДанных.Следующий() Цикл 
		  Если Не ЗначениеЗаполнено(ВыборкаДанных.СтрокаЗаявки) тогда Продолжить; КонецЕсли;
		ЗаписьСостояния = МенеджерРегистра.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(ЗаписьСостояния,ВыборкаДанных);
			ЗаписьСостояния.Записать();
			//ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЗаписьСостояния,Ложь,ложь);
		
	КонецЦикла;	
	
КонецПроцедуры 


	
#КонецОбласти


#Область ЗапросыКДанным
Функция ЗапросСостояние_ЗаявкаПокупателя() 
	Возврат новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                     |	&Период КАК Период,
	                     |	ЗаявкиПокупателей.СтрокаЗаявки КАК СтрокаЗаявки,
	                     |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	                     |	ЛОЖЬ КАК Отказ,
	                     |	1 КАК Порядок,
	                     |	ВЫБОР
	                     |		КОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	                     |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.НовыйНеподтвержден)
	                     |	КОНЕЦ КАК Состояние,
	                     |	ЗаявкиПокупателей.Период КАК ДатаСобытия,
	                     |	ЗаявкиПокупателей.Количество,
	                     |	ИСТИНА КАК Изменена,
	                     |	ЗаявкиПокупателей.Количество КАК КоличествоПлан,
	                     |	0 КАК КоличествоОтказ,
	                     |	0 КАК КоличествоФакт
	                     |ИЗ
	                     |	РегистрНакопления.ЗаявкиПокупателей КАК ЗаявкиПокупателей
	                     |ГДЕ
	                     |	ЗаявкиПокупателей.Регистратор = &ДокументСсылка
	                     |
	                     |СГРУППИРОВАТЬ ПО
	                     |	ЗаявкиПокупателей.СтрокаЗаявки,
	                     |	ЗаявкиПокупателей.Период,
	                     |	ЗаявкиПокупателей.Количество,
	                     |	ВЫБОР
	                     |		КОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	                     |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.НовыйНеподтвержден)
	                     |	КОНЕЦ,
	                     |	ЗаявкиПокупателей.Количество
	                     |
	                     |ОБЪЕДИНИТЬ ВСЕ
	                     |
	                     |ВЫБРАТЬ
	                     |	&Период,
	                     |	РезервыТоваров.СтрокаЗаявки,
	                     |	РезервыТоваров.СтрокаПрихода,
	                     |	ЛОЖЬ,
	                     |	2,
	                     |	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВРезерве),
	                     |	РезервыТоваров.Период,
	                     |	РезервыТоваров.Количество,
	                     |	ИСТИНА,
	                     |	NULL,
	                     |	0,
	                     |	0
	                     |ИЗ
	                     |	РегистрНакопления.РезервыТоваров КАК РезервыТоваров
	                     |ГДЕ
	                     |	РезервыТоваров.Регистратор = &ДокументСсылка
	                     |
	                     |УПОРЯДОЧИТЬ ПО
	                     |	Порядок" );
	 	
КонецФункции	

Функция ЗапросСостояние_ЗаказПоставщику() 
	Возврат новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                     |	&Период КАК Период,
	                     |	ЗаказыПоставщикам.СтрокаЗаявки КАК СтрокаЗаявки,
	                     |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	                     |	ЛОЖЬ КАК Отказ,
	                     |	3 КАК Порядок,
	                     |	ИСТИНА КАК Изменена,
	                     |	ЗаказыПоставщикам.Период КАК ДатаСобытия,
	                     |	ЗаказыПоставщикам.Количество,
	                     |	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Заказано) КАК Состояние
	                     |ИЗ
	                     |	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	                     |ГДЕ
	                     |	ЗаказыПоставщикам.Регистратор = &ДокументСсылка
	                     |
	                     |УПОРЯДОЧИТЬ ПО
	                     |	Порядок");
КонецФункции

Функция ЗапросСостояние_КорректировкаЗаказаПоставщику() 
	Возврат новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                     |	&Период КАК Период,
	                     |	ДокументТовары.СтрокаЗаявки КАК СтрокаЗаявки,
	                     |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	                     |	3 КАК Порядок,
	                     |	ЛОЖЬ КАК Отказ,
	                     |	ВЫБОР
	                     |		КОГДА ДокументТовары.Ссылка.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПроведенЗаказПоставщику)
	                     |				ИЛИ ДокументТовары.Ссылка.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ОтправленПоставщику)
	                     |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Заказано)
	                     |		ИНАЧЕ ВЫБОР
	                     |				КОГДА ДокументТовары.СостояниеСтрокиЗаказа = ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПустаяСсылка)
	                     |					ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Выкуплено)
	                     |				ИНАЧЕ ДокументТовары.СостояниеСтрокиЗаказа
	                     |			КОНЕЦ
	                     |	КОНЕЦ КАК Состояние,
	                     |	ДокументТовары.Количество,
	                     |	ДокументТовары.Ссылка.Дата КАК ДатаСобытия,
	                     |	ИСТИНА КАК Изменена
	                     |ИЗ
	                     |	Документ.КорректировкаЗаказаПоставщику.Товары КАК ДокументТовары
	                     |ГДЕ
	                     |	ДокументТовары.Ссылка = &ДокументСсылка
	                     |	И ДокументТовары.Ссылка.Проведен
	                     |
	                     |ОБЪЕДИНИТЬ ВСЕ
	                     |
	                     |ВЫБРАТЬ
	                     |	&Период,
	                     |	ОтказыПоЗаявкам.СтрокаЗаявки,
	                     |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка),
	                     |	6,
	                     |	ИСТИНА,
	                     |	ОтказыПоЗаявкам.ПричинаОтказа,
	                     |	ОтказыПоЗаявкам.Количество,
	                     |	ОтказыПоЗаявкам.Период,
	                     |	ИСТИНА
	                     |ИЗ
	                     |	РегистрНакопления.ОтказыПоЗаявкам КАК ОтказыПоЗаявкам
	                     |ГДЕ
	                     |	ОтказыПоЗаявкам.Регистратор = &Регистратор");
	
	
КонецФункции

Функция ЗапросСостояние_ПоступлениеТоваровУслуг() 
	Возврат новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                     |	&Период КАК Период,
	                     |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	                     |	РазмещенияСтрокЗаказов.СтрокаПрихода КАК СтрокаПрихода,
	                     |	4 КАК Порядок,
	                     |	ЛОЖЬ КАК Отказ,
	                     |	РазмещенияСтрокЗаказов.Период КАК ДатаСобытия,
	                     |	СУММА(РазмещенияСтрокЗаказов.Количество) КАК Количество,
	                     |	ИСТИНА КАК Изменена,
	                     |	ВЫБОР
	                     |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровНовый)
	                     |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровОтгружен)
	                     |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ОтгруженПоставщиком)
	                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	                     |	КОНЕЦ КАК Состояние
	                     |ИЗ
	                     |	РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
	                     |ГДЕ
	                     |	РазмещенияСтрокЗаказов.Регистратор = &ДокументСсылка
	                     |	И РазмещенияСтрокЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	                     |
	                     |СГРУППИРОВАТЬ ПО
	                     |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	                     |	РазмещенияСтрокЗаказов.СтрокаПрихода,
	                     |	РазмещенияСтрокЗаказов.Период,
	                     |	ВЫБОР
	                     |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровНовый)
	                     |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровОтгружен)
	                     |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ОтгруженПоставщиком)
	                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	                     |	КОНЕЦ");
	
	
КонецФункции

Функция ЗапросСостояние_РеализацияТоваровУслуг() 
	Возврат новый Запрос("ВЫБРАТЬ
	                     |	ПартииТоваров.Регистратор,
	                     |	ПартииТоваров.Номенклатура,
	                     |	ПартииТоваров.Склад,
	                     |	МИНИМУМ(ПартииТоваров.СтрокаПрихода) КАК СтрокаПрихода,
	                     |	ПартииТоваров.Качество
	                     |ПОМЕСТИТЬ ВТПартии
	                     |ИЗ
	                     |	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	                     |ГДЕ
	                     |	ПартииТоваров.Регистратор = &ДокументСсылка
	                     |
	                     |СГРУППИРОВАТЬ ПО
	                     |	ПартииТоваров.Регистратор,
	                     |	ПартииТоваров.Номенклатура,
	                     |	ПартииТоваров.Склад,
	                     |	ПартииТоваров.Качество
	                     |;
	                     |
	                     |////////////////////////////////////////////////////////////////////////////////
	                     |ВЫБРАТЬ
	                     |	&Период,
	                     |	Продажи.СтрокаЗаявки,
	                     |	ВТПартии.СтрокаПрихода,
	                     |	ЛОЖЬ КАК Отказ,
	                     |	5 КАК Порядок,
	                     |	ВЫБОР
	                     |		КОГДА ВЫРАЗИТЬ(Продажи.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	                     |			ТОГДА ВЫБОР
	                     |					КОГДА ВЫРАЗИТЬ(Продажи.Регистратор КАК Документ.РеализацияТоваровУслуг).ТипДоставки = ЗНАЧЕНИЕ(Справочник.ТипыДоставки.ЭкспрессДоставка)
	                     |						ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ИдетСборкаПКЭкспресс)
	                     |					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.СборкаПК)
	                     |				КОНЕЦ
	                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Выдано)
	                     |	КОНЕЦ КАК Состояние,
	                     |	Продажи.Период КАК ДатаСобытия,
	                     |	Продажи.Количество,
	                     |	ИСТИНА КАК Изменена
	                     |ПОМЕСТИТЬ ВТПродажи
	                     |ИЗ
	                     |	РегистрНакопления.Продажи КАК Продажи
	                     |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПартии КАК ВТПартии
	                     |		ПО Продажи.Регистратор = ВТПартии.Регистратор
	                     |			И Продажи.Номенклатура = ВТПартии.Номенклатура
	                     |			И Продажи.Склад = ВТПартии.Склад
	                     |			И Продажи.Качество = ВТПартии.Качество
	                     |			И (Продажи.Регистратор = &ДокументСсылка)
	                     |			И (НЕ Продажи.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.ПустаяСсылка))
	                     |;
	                     |
	                     |////////////////////////////////////////////////////////////////////////////////
	                     |ВЫБРАТЬ
	                     |	ОтказыПоЗаявкам.СтрокаЗаявки,
	                     |	ОтказыПоЗаявкам.ПричинаОтказа,
	                     |	ОтказыПоЗаявкам.Регистратор,
	                     |	РеализацияТоваровУслугТовары.Номенклатура,
	                     |	РеализацияТоваровУслугТовары.Ссылка.Склад,
	                     |	ОтказыПоЗаявкам.Период,
	                     |	ОтказыПоЗаявкам.Количество
	                     |ПОМЕСТИТЬ ВТОтказы
	                     |ИЗ
	                     |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	                     |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ОтказыПоЗаявкам КАК ОтказыПоЗаявкам
	                     |		ПО (ОтказыПоЗаявкам.Регистратор = РеализацияТоваровУслугТовары.Ссылка)
	                     |			И (ОтказыПоЗаявкам.СтрокаЗаявки = РеализацияТоваровУслугТовары.СтрокаЗаявки)
	                     |ГДЕ
	                     |	РеализацияТоваровУслугТовары.Ссылка = &ДокументСсылка
	                     |;
	                     |
	                     |////////////////////////////////////////////////////////////////////////////////
	                     |ВЫБРАТЬ
	                     |	ВТПродажи.Период,
	                     |	ВТПродажи.СтрокаЗаявки,
	                     |	ВТПродажи.СтрокаПрихода,
	                     |	ВТПродажи.Отказ,
	                     |	ВТПродажи.Порядок,
	                     |	ВТПродажи.Состояние,
	                     |	ВТПродажи.ДатаСобытия,
	                     |	ВТПродажи.Количество,
	                     |	ВТПродажи.Изменена
	                     |ИЗ
	                     |	ВТПродажи КАК ВТПродажи
	                     |
	                     |ОБЪЕДИНИТЬ ВСЕ
	                     |
	                     |ВЫБРАТЬ
	                     |	&Период,
	                     |	ВТОтказы.СтрокаЗаявки,
	                     |	ВТПартии.СтрокаПрихода,
	                     |	ИСТИНА,
	                     |	6,
	                     |	ВТОтказы.ПричинаОтказа,
	                     |	ВТОтказы.Период,
	                     |	ВТОтказы.Количество,
	                     |	ИСТИНА
	                     |ИЗ
	                     |	ВТОтказы КАК ВТОтказы
	                     |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПартии КАК ВТПартии
	                     |		ПО ВТОтказы.Номенклатура = ВТПартии.Номенклатура
	                     |			И ВТОтказы.Склад = ВТПартии.Склад" );
	
	
	
КонецФункции

#КонецОбласти 



