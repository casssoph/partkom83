﻿#Область ФормированиеИсторииЗаявок
Процедура ЗарегистрироватьИзменениеЗаявкиКлиента(ДокументСсылка,Оперативно = истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросСостояния = новый Запрос;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаявкаПокупателя") или 
		ТипЗнч(ДокументСсылка) =Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") тогда 
		ЗапросСостояния.Текст =ЗапросСостояние_ЗаявкаПокупателя();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаказПоставщику")  тогда 
		ЗапросСостояния.Текст  =ЗапросСостояние_ЗаказПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику")  тогда 
		ЗапросСостояния.Текст  =ЗапросСостояние_КорректировкаЗаказаПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")  тогда 
		ЗапросСостояния.Текст  =ЗапросСостояние_ПоступлениеТоваровУслуг();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг")  тогда 
		ЗапросСостояния.Текст  =ЗапросСостояние_РеализацияТоваровУслуг();  
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПеремещениеТоваров")  тогда 
		ЗапросСостояния.Текст  =ЗапросСостояние_ПеремещениеТоваров();  	
	иначе 
		Возврат;
	КонецЕсли;
	
	ЗапросСостояния.УстановитьПараметр("ДокументСсылка",ДокументСсылка);
	ЗапросСостояния.УстановитьПараметр("Период",ТекущаяДата());
	
	РезультатСостояние = ЗапросСостояния.Выполнить();
	
	Если РезультатСостояние.Пустой() тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьИзмененияЗаявки(РезультатСостояние,Оперативно)
	
КонецПроцедуры	

Процедура ЗаписатьИзмененияЗаявки(РезультатСостояние,Оперативно = Истина )
	
	МенеджерРегистра = РегистрыСведений.ИсторияЗаявокПокупателя;
	
	ВыборкаДанных = РезультатСостояние.Выбрать();
	
	Пока ВыборкаДанных.Следующий() Цикл 
		Если Не ЗначениеЗаполнено(ВыборкаДанных.СтрокаЗаявки) тогда Продолжить; КонецЕсли;
		ЗаписьСостояния = МенеджерРегистра.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ЗаписьСостояния,ВыборкаДанных);
		Если Не Оперативно тогда 
			ЗаписьСостояния.ДатаСобытия = ВыборкаДанных.Документ.Дата; 		
		КонецЕсли;	
		ЗаписьСостояния.Записать();		
	КонецЦикла;	
	
КонецПроцедуры 

Процедура ПотоковаяРегитсрацияОбъектов(МассивДокументов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросСостояния = новый Запрос;
	
	СтрОбъединить  = " Объединить Все ";
	ТекстЗапроса = ЗапросСостояние_РеализацияТоваровУслуг()+СтрОбъединить + ЗапросСостояние_ЗаявкаПокупателя() + СтрОбъединить 
	+ ЗапросСостояние_ЗаказПоставщику() + СтрОбъединить
	+ ЗапросСостояние_КорректировкаЗаказаПоставщику() + СтрОбъединить
	+ ЗапросСостояние_ПоступлениеТоваровУслуг()+ СтрОбъединить
	+ ЗапросСостояние_ПеремещениеТоваров();
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"= &ДокументСсылка" , " в (&ДокументСсылка)" );
	
	ЗапросСостояния.Текст = ТекстЗапроса;
	
	ЗапросСостояния.УстановитьПараметр("ДокументСсылка",МассивДокументов);
	ЗапросСостояния.УстановитьПараметр("Период",ТекущаяДата());
	
	РезультатСостояние = ЗапросСостояния.Выполнить();
	
	Если РезультатСостояние.Пустой() тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьИзмененияЗаявки(РезультатСостояние,Ложь)
	
	
КонецПроцедуры	

#КонецОбласти


#Область ЗапросыКДанным
Функция ЗапросСостояние_ЗаявкаПокупателя() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ЗаявкиПокупателей.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	1 КАК Порядок,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.НовыйНеподтвержден)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК ДатаСобытия,
	        |	ЗаявкиПокупателей.Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ЗаявкиПокупателей.Регистратор КАК Документ,
	        |	ЗаявкиПокупателей.Склад КАК Склад,
	        |	ЗаявкиПокупателей.Номенклатура,
	        |	ЗаявкиПокупателей.СтрокаЗаявки.IDSite КАК IDSite
	        |ИЗ
	        |	РегистрНакопления.ЗаявкиПокупателей КАК ЗаявкиПокупателей
	        |ГДЕ
	        |	ЗаявкиПокупателей.Регистратор = &ДокументСсылка
	        |	И ЗаявкиПокупателей.СтрокаЗаявки.Виртуальная = ЛОЖЬ
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
	        |	ЗаявкиПокупателей.Номенклатура,
	        |	ЗаявкиПокупателей.Склад,
	        |	ЗаявкиПокупателей.Регистратор,
	        |	ЗаявкиПокупателей.СтрокаЗаявки.IDSite
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	РезервыТоваров.СтрокаЗаявки,
	        |	РезервыТоваров.СтрокаПрихода,
	        |	ЛОЖЬ,
	        |	2,
	        |	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВРезерве),
	        |	&Период,
	        |	РезервыТоваров.Количество,
	        |	ИСТИНА,
	        |	РезервыТоваров.Регистратор,
	        |	РезервыТоваров.Склад,
	        |	РезервыТоваров.Номенклатура,
	        |	РезервыТоваров.СтрокаЗаявки.IDSite
	        |ИЗ
	        |	РегистрНакопления.РезервыТоваров КАК РезервыТоваров
	        |ГДЕ
	        |	РезервыТоваров.Регистратор = &ДокументСсылка
	        |	И РезервыТоваров.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И РезервыТоваров.Количество > 0
	        |	И РезервыТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка),
	        |	ИСТИНА,
	        |	0,
	        |	ОтказыПоЗаявкам.ПричинаОтказа,
	        |	&Период,
	        |	ОтказыПоЗаявкам.Количество,
	        |	ИСТИНА,
	        |	ОтказыПоЗаявкам.Регистратор,
	        |	NULL,
	        |	NULL,
	        |	ОтказыПоЗаявкам.СтрокаЗаявки.IDSite
	        |ИЗ
	        |	РегистрНакопления.ОтказыПоЗаявкам КАК ОтказыПоЗаявкам
	        |ГДЕ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ОтказыПоЗаявкам.Регистратор = &ДокументСсылка
	        |	И ОтказыПоЗаявкам.Количество > 0";
	
КонецФункции	

Функция ЗапросСостояние_ЗаказПоставщику() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ЗаказыПоставщикам.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	3 КАК Порядок,
	        |	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Заказано) КАК Состояние,
	        |	ЗаказыПоставщикам.Период КАК ДатаСобытия,
	        |	ЗаказыПоставщикам.Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ЗаказыПоставщикам.Регистратор КАК Документ,
	        |	ЗаказыПоставщикам.Склад,
	        |	ЗаказыПоставщикам.Номенклатура,
	        |	ЗаказыПоставщикам.СтрокаЗаявки.IDSite КАК IDSite
	        |ИЗ
	        |	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	        |ГДЕ
	        |	ЗаказыПоставщикам.Регистратор = &ДокументСсылка
	        |	И ЗаказыПоставщикам.СтрокаЗаявки.Виртуальная = ЛОЖЬ";
КонецФункции

Функция ЗапросСостояние_КорректировкаЗаказаПоставщику() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ДокументТовары.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	3 КАК Порядок,
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
	        |	&Период КАК ДатаСобытия,
	        |	ДокументТовары.Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ДокументТовары.Ссылка КАК Документ,
	        |	ДокументТовары.Ссылка.Склад,
	        |	ДокументТовары.Номенклатура,
	        |	ДокументТовары.СтрокаЗаявки.IDSite КАК IDSite
	        |ИЗ
	        |	Документ.КорректировкаЗаказаПоставщику.Товары КАК ДокументТовары
	        |ГДЕ
	        |	ДокументТовары.Ссылка = &ДокументСсылка
	        |	И ДокументТовары.Ссылка.Проведен
	        |	И ДокументТовары.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка),
	        |	ИСТИНА,
	        |	0,
	        |	ОтказыПоЗаявкам.ПричинаОтказа,
	        |	&Период,
	        |	ОтказыПоЗаявкам.Количество,
	        |	ИСТИНА,
	        |	ОтказыПоЗаявкам.Регистратор,
	        |	NULL,
	        |	NULL,
	        |	ОтказыПоЗаявкам.СтрокаЗаявки.IDSite
	        |ИЗ
	        |	РегистрНакопления.ОтказыПоЗаявкам КАК ОтказыПоЗаявкам
	        |ГДЕ
	        |	ОтказыПоЗаявкам.Регистратор = &ДокументСсылка
	        |	И ОтказыПоЗаявкам.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ОтказыПоЗаявкам.Количество > 0";
	
	
КонецФункции

Функция ЗапросСостояние_ПоступлениеТоваровУслуг() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	        |	РазмещенияСтрокЗаказов.СтрокаПрихода КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА 5
	        |		ИНАЧЕ 4
	        |	КОНЕЦ КАК Порядок,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК ДатаСобытия,
	        |	СУММА(РазмещенияСтрокЗаказов.Количество) КАК Количество,
	        |	ИСТИНА КАК Изменена,
	        |	РазмещенияСтрокЗаказов.Регистратор КАК Документ,
	        |	ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Склад КАК Склад,
	        |	NULL КАК Номенклатура,
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки.IDSite КАК IDSite
	        |ИЗ
	        |	РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
	        |ГДЕ
	        |	РазмещенияСтрокЗаказов.Регистратор = &ДокументСсылка
	        |	И РазмещенияСтрокЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	        |	И РазмещенияСтрокЗаказов.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	        |	РазмещенияСтрокЗаказов.СтрокаПрихода,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА 5
	        |		ИНАЧЕ 4
	        |	КОНЕЦ,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	        |	КОНЕЦ,
	        |	ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Склад,
	        |	РазмещенияСтрокЗаказов.Регистратор";
	
	
КонецФункции

Функция ЗапросСостояние_РеализацияТоваровУслуг() 
	Возврат "ВЫБРАТЬ
	        |	ПартииТоваров.Регистратор,
	        |	ПартииТоваров.Номенклатура,
	        |	ПартииТоваров.Склад,
	        |	МИНИМУМ(ПартииТоваров.СтрокаПрихода) КАК СтрокаПрихода,
	        |	ПартииТоваров.Качество,
	        |	РеализацияТоваровУслугТовары.СтрокаЗаявки
	        |ПОМЕСТИТЬ ВТПартии
	        |ИЗ
	        |	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	        |		ПО ПартииТоваров.Регистратор = РеализацияТоваровУслугТовары.Ссылка
	        |			И ПартииТоваров.Номенклатура = РеализацияТоваровУслугТовары.Номенклатура
	        |			И (РеализацияТоваровУслугТовары.Ссылка = &ДокументСсылка)
	        |			И (ПартииТоваров.Регистратор = &ДокументСсылка)
	        |ГДЕ
	        |	ПартииТоваров.Регистратор = &ДокументСсылка
	        |	И РеализацияТоваровУслугТовары.Ссылка.ЭтоМФП = ЛОЖЬ
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ПартииТоваров.Регистратор,
	        |	ПартииТоваров.Номенклатура,
	        |	ПартииТоваров.Склад,
	        |	ПартииТоваров.Качество,
	        |	РеализацияТоваровУслугТовары.СтрокаЗаявки
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЕСТЬNULL(Продажи.СтрокаЗаявки, ВТПартии.СтрокаЗаявки) КАК СтрокаЗаявки,
	        |	ВТПартии.СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	        |			ТОГДА 6
	        |		ИНАЧЕ 7
	        |	КОНЕЦ КАК Порядок,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	        |			ТОГДА ВЫБОР
	        |					КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).ТипДоставки = ЗНАЧЕНИЕ(Справочник.ТипыДоставки.ЭкспрессДоставка)
	        |						ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ИдетСборкаПКЭкспресс)
	        |					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.СборкаПК)
	        |				КОНЕЦ
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Выдано)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК ДатаСобытия,
	        |	Продажи.Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ВТПартии.Регистратор КАК Документ,
	        |	ВТПартии.Склад,
	        |	ВТПартии.Номенклатура
	        |ПОМЕСТИТЬ ВТПродажи
	        |ИЗ
	        |	ВТПартии КАК ВТПартии
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи КАК Продажи
	        |		ПО (Продажи.Регистратор = ВТПартии.Регистратор)
	        |			И (Продажи.Номенклатура = ВТПартии.Номенклатура)
	        |			И (Продажи.Склад = ВТПартии.Склад)
	        |			И (Продажи.Качество = ВТПартии.Качество)
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
	        |	И ОтказыПоЗаявкам.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ОтказыПоЗаявкам.Количество > 0
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ВТПродажи.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ВТПродажи.СтрокаПрихода,
	        |	ВТПродажи.Отказ,
	        |	ВТПродажи.Порядок,
	        |	ВТПродажи.Состояние,
	        |	ВТПродажи.ДатаСобытия,
	        |	ВТПродажи.Количество,
	        |	ВТПродажи.Изменена,
	        |	ВТПродажи.Документ,
	        |	ВТПродажи.Склад КАК Склад,
	        |	ВТПродажи.Номенклатура КАК Номенклатура,
	        |	ВТПродажи.СтрокаЗаявки.IDSite КАК IDSite
	        |ИЗ
	        |	ВТПродажи КАК ВТПродажи
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	ВТОтказы.СтрокаЗаявки,
	        |	ВТПартии.СтрокаПрихода,
	        |	ИСТИНА,
	        |	0,
	        |	ВТОтказы.ПричинаОтказа,
	        |	&Период,
	        |	ВТОтказы.Количество,
	        |	ИСТИНА,
	        |	ВТОтказы.Регистратор,
	        |	ВТОтказы.Склад,
	        |	ВТОтказы.Номенклатура,
	        |	ВТОтказы.СтрокаЗаявки.IDSite
	        |ИЗ
	        |	ВТОтказы КАК ВТОтказы
	        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПартии КАК ВТПартии
	        |		ПО ВТОтказы.Номенклатура = ВТПартии.Номенклатура
	        |			И ВТОтказы.Склад = ВТПартии.Склад" ;
	
	
	
КонецФункции

Функция ЗапросСостояние_ПеремещениеТоваров()
	Возврат 	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки КАК СтрокаЗаявки,
	        	|	ПартииТоваров.СтрокаПрихода КАК СтрокаПрихода,
	        	|	ЛОЖЬ КАК Отказ,
	        	|	5 КАК Порядок,
	        	|	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе) КАК Состояние,
	        	|	&Период КАК ДатаСобытия,
	        	|	ПартииТоваров.Количество КАК Количество,
	        	|	ИСТИНА КАК Изменена,
	        	|	ПеремещениеТоваровТовары.Ссылка КАК Документ,
	        	|	ПартииТоваров.Склад,
	        	|	ПартииТоваров.Номенклатура,
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки.IDSite КАК IDSite
	        	|ИЗ
	        	|	РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов,
	        	|	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	        	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	        	|		ПО (ВЫРАЗИТЬ(ПартииТоваров.Регистратор КАК Документ.ПеремещениеТоваров).ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещенияТоваров.ПриемкаТопЛог))
	        	|			И (ПеремещениеТоваровТовары.Ссылка = &ДокументСсылка)
	        	|			И (ПартииТоваров.Регистратор = &ДокументСсылка)
	        	|			И ПеремещениеТоваровТовары.Номенклатура = ПартииТоваров.Номенклатура
	        	|			И (ПартииТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	        	|			И (ПеремещениеТоваровТовары.СтрокаЗаявки.Виртуальная = ЛОЖЬ)
	        	|
	        	|СГРУППИРОВАТЬ ПО
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки,
	        	|	ПартииТоваров.СтрокаПрихода,
	        	|	ПартииТоваров.Количество,
	        	|	ПартииТоваров.Склад,
	        	|	ПартииТоваров.Номенклатура,
	        	|	ПеремещениеТоваровТовары.Ссылка"
	
КонецФункции	

#КонецОбласти 



