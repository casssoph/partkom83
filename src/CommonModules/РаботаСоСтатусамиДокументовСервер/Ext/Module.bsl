﻿#Область ФормированиеИсторииЗаявок

Процедура ЗарегистрироватьИзменениеЗаявкиКлиента(ДокументСсылка,Оперативно = истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросСостояния = новый Запрос;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаявкаПокупателя") или 
		ТипЗнч(ДокументСсылка) =Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") тогда 
		ТекстЗапроса =ЗапросСостояние_ЗаявкаПокупателя();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаказПоставщику")  тогда 
		ТекстЗапроса  =ЗапросСостояние_ЗаказПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику")  тогда 
		ТекстЗапроса  =ЗапросСостояние_КорректировкаЗаказаПоставщику();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")  тогда 
		ТекстЗапроса  =ЗапросСостояние_ПоступлениеТоваровУслуг();
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг")  тогда 
		ТекстЗапроса  =ЗапросСостояние_РеализацияТоваровУслуг();  
	ИначеЕсли   ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПеремещениеТоваров")  тогда 
		ТекстЗапроса  =ЗапросСостояние_ПеремещениеТоваров();  	
	иначе 
		Возврат;
	КонецЕсли;
	
	ЗапросСостояния.Текст = ТекстЗапроса + "
	| ; "+ ЗапросСостояние_ТекщиеДвижения()+ СтрокаИтогов();
	ЗапросСостояния.УстановитьПараметр("ДокументСсылка",ДокументСсылка);
	ЗапросСостояния.УстановитьПараметр("Период",ТекущаяДата());
	
	РезультатСостояние = ЗапросСостояния.Выполнить();
	
	Если РезультатСостояние.Пустой() тогда
		Возврат;		
	КонецЕсли;
	
	ЗаписатьИзмененияЗаявки(РезультатСостояние,Оперативно)
	
КонецПроцедуры	

Процедура ЗаписатьИзмененияЗаявки(РезультатСостояние,Оперативно = Истина ) экспорт 
	
	МенеджерРегистра = РегистрыСведений.ИсторияЗаявокПокупателя;
	
	ВыборкаРегистратора = РезультатСостояние.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока  ВыборкаРегистратора.Следующий() цикл
	  
		НаборЗаписей =  МенеджерРегистра.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистратора.Регистратор);
		ВыборкаДанных =ВыборкаРегистратора.Выбрать();
		Пока ВыборкаДанных.Следующий() Цикл 
			//если не НужноЗаписывать(ВыборкаДанных) тогда 
			//	Продолжить;
			//КонецЕсли;	
			Если Не ЗначениеЗаполнено(ВыборкаДанных.СтрокаЗаявки) тогда Продолжить; КонецЕсли;
			ЗаписьСостояния = НаборЗаписей.Добавить(); 
			ЗаполнитьЗначенияСвойств(ЗаписьСостояния,ВыборкаДанных);
			Если Не Оперативно тогда 
				ЗаписьСостояния.Период = ВыборкаДанных.Регистратор.Дата; 		
			КонецЕсли;		
		КонецЦикла;	
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры 

Функция НужноЗаписывать(ВыборкаДанных) 
	
	запрос = новый запрос (   "ВЫБРАТЬ
	                        |	ИсторияЗаявокПокупателя.Регистратор
	                        |ИЗ
	                        |	РегистрСведений.ИсторияЗаявокПокупателя КАК ИсторияЗаявокПокупателя
	                        |ГДЕ
	                        |	ИсторияЗаявокПокупателя.СтрокаЗаявки = &СтрокаЗаявки
	                        |	И ИсторияЗаявокПокупателя.СтрокаПрихода = &СтрокаПрихода
	                        |	И ИсторияЗаявокПокупателя.Отказ = &Отказ
	                        |	И ИсторияЗаявокПокупателя.Порядок = &Порядок" );
	Запрос.УстановитьПараметр("СтрокаЗаявки",ВыборкаДанных.СтрокаЗаявки);
	Запрос.УстановитьПараметр("СтрокаПрихода",ВыборкаДанных.СтрокаПрихода);
	Запрос.УстановитьПараметр("Отказ",ВыборкаДанных.Отказ);
	Запрос.УстановитьПараметр("Порядок",ВыборкаДанных.Порядок);

Рез = запрос.Выполнить();
возврат Рез.Пустой();
	
КонецФункции

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
	
	ЗапросСостояния.Текст = ТекстЗапроса + СтрокаИтогов();
	
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
	        |		КОГДА ВЫБОР
	        |				КОГДА ЗаявкиПокупателей.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |					ТОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	        |				ИНАЧЕ ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.КорректировкаЗаявкиПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	        |			КОНЕЦ
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.НовыйНеподтвержден)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК Период,
	        |	СУММА(ЗаявкиПокупателей.Количество) КАК Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ЗаявкиПокупателей.Регистратор КАК Регистратор,
	        |	ВЫБОР
	        |		КОГДА ЗаявкиПокупателей.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |			ТОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).Склад
	        |		ИНАЧЕ ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.КорректировкаЗаявкиПокупателя).Склад
	        |	КОНЕЦ КАК Склад,
	        |	МАКСИМУМ(ЗаявкиПокупателей.Номенклатура) КАК Номенклатура,
	        |	ЗаявкиПокупателей.СтрокаЗаявки.IDSite КАК IDSite
	        |ПОМЕСТИТЬ ВтДвижения
	        |ИЗ
	        |	РегистрНакопления.ЗаявкиПокупателей КАК ЗаявкиПокупателей
	        |ГДЕ
	        |	ЗаявкиПокупателей.Регистратор = &ДокументСсылка
	        |	И ЗаявкиПокупателей.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ЗаявкиПокупателей.ВидДвижения = ЗНАЧЕНИЕ(вИдДвиженияНакопления.Приход)
	        |	И (ЗаявкиПокупателей.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |			ИЛИ ЗаявкиПокупателей.Регистратор ССЫЛКА Документ.КорректировкаЗаявкиПокупателя)
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ЗаявкиПокупателей.СтрокаЗаявки,
	        |	ЗаявкиПокупателей.Период,
	        |	ЗаявкиПокупателей.Регистратор,
	        |	ЗаявкиПокупателей.СтрокаЗаявки.IDSite,
	        |	ВЫБОР
	        |		КОГДА ВЫБОР
	        |				КОГДА ЗаявкиПокупателей.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |					ТОГДА ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.ЗаявкаПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	        |				ИНАЧЕ ВЫРАЗИТЬ(ЗаявкиПокупателей.Регистратор КАК Документ.КорректировкаЗаявкиПокупателя).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	        |			КОНЕЦ
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.НовыйНеподтвержден)
	        |	КОНЕЦ
	        |
	        |ИМЕЮЩИЕ
	        |	СУММА(ЗаявкиПокупателей.Количество) > 0
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	РезервыТоваров.СтрокаЗаявки,
	        |	РезервыТоваров.СтрокаПрихода,
	        |	ЛОЖЬ,
	        |	5,
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
	        |	И (РезервыТоваров.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |			ИЛИ РезервыТоваров.Регистратор ССЫЛКА Документ.КорректировкаЗаявкиПокупателя)
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
	        |	И ОтказыПоЗаявкам.Количество > 0
	        |	И (ОтказыПоЗаявкам.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	        |			ИЛИ ОтказыПоЗаявкам.Регистратор ССЫЛКА Документ.КорректировкаЗаявкиПокупателя)";
	
КонецФункции	

Функция ЗапросСостояние_ЗаказПоставщику() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ЗаказыПоставщикам.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	2 КАК Порядок,
	        |	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Заказано) КАК Состояние,
	        |	ЗаказыПоставщикам.Период КАК Период,
	        |	СУММА(ЗаказыПоставщикам.Количество) КАК Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ЗаказыПоставщикам.Регистратор КАК Регистратор,
	        |	МАКСИМУМ(ЗаказыПоставщикам.Склад) КАК Склад,
	        |	МАКСИМУМ(ЗаказыПоставщикам.Номенклатура) КАК Номенклатура,
	        |	ЗаказыПоставщикам.СтрокаЗаявки.IDSite КАК IDSite
	        |ПОМЕСТИТЬ ВтДвижения
	        |ИЗ
	        |	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	        |ГДЕ
	        |	ЗаказыПоставщикам.Регистратор = &ДокументСсылка
	        |	И ЗаказыПоставщикам.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ЗаказыПоставщикам.Регистратор ССЫЛКА Документ.ЗаказПоставщику
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ЗаказыПоставщикам.СтрокаЗаявки,
	        |	ЗаказыПоставщикам.Регистратор,
	        |	ЗаказыПоставщикам.Период,
	        |	ЗаказыПоставщикам.СтрокаЗаявки.IDSite";
КонецФункции

Функция ЗапросСостояние_КорректировкаЗаказаПоставщику() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ДокументТовары.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка) КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	2 КАК Порядок,
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
	        |	&Период КАК Период,
	        |	СУММА(ДокументТовары.Количество) КАК Количество,
	        |	ИСТИНА КАК Изменена,
	        |	ДокументТовары.Ссылка КАК Регистратор,
	        |	МАКСИМУМ(ДокументТовары.Ссылка.Склад) КАК Склад,
	        |	МАКСИМУМ(ДокументТовары.Номенклатура) КАК Номенклатура,
	        |	ДокументТовары.СтрокаЗаявки.IDSite КАК IDSite
	        |ПОМЕСТИТЬ ВтДвижения
	        |ИЗ
	        |	Документ.КорректировкаЗаказаПоставщику.Товары КАК ДокументТовары
	        |ГДЕ
	        |	ДокументТовары.Ссылка = &ДокументСсылка
	        |	И ДокументТовары.Ссылка.Проведен
	        |	И ДокументТовары.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ДокументТовары.Количество > ДокументТовары.КоличествоОтказ
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ВЫБОР
	        |		КОГДА ДокументТовары.Ссылка.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПроведенЗаказПоставщику)
	        |				ИЛИ ДокументТовары.Ссылка.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ОтправленПоставщику)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Заказано)
	        |		ИНАЧЕ ВЫБОР
	        |				КОГДА ДокументТовары.СостояниеСтрокиЗаказа = ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПустаяСсылка)
	        |					ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Выкуплено)
	        |				ИНАЧЕ ДокументТовары.СостояниеСтрокиЗаказа
	        |			КОНЕЦ
	        |	КОНЕЦ,
	        |	ДокументТовары.СтрокаЗаявки.IDSite,
	        |	ДокументТовары.СтрокаЗаявки,
	        |	ДокументТовары.Ссылка
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка),
	        |	ИСТИНА,
	        |	0,
	        |	МАКСИМУМ(ОтказыПоЗаявкам.ПричинаОтказа),
	        |	&Период,
	        |	СУММА(ОтказыПоЗаявкам.Количество),
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
	        |	И ОтказыПоЗаявкам.Количество > 0
	        |	И ОтказыПоЗаявкам.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПоставщику
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ОтказыПоЗаявкам.Регистратор,
	        |	ОтказыПоЗаявкам.СтрокаЗаявки.IDSite";
	
	
КонецФункции

Функция ЗапросСостояние_ПоступлениеТоваровУслуг() 
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	        |	РазмещенияСтрокЗаказов.СтрокаПрихода КАК СтрокаПрихода,
	        |	ЛОЖЬ КАК Отказ,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА 4
	        |		ИНАЧЕ 3
	        |	КОНЕЦ КАК Порядок,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК Период,
	        |	СУММА(РазмещенияСтрокЗаказов.Количество) КАК Количество,
	        |	ИСТИНА КАК Изменена,
	        |	РазмещенияСтрокЗаказов.Регистратор КАК Регистратор,
	        |	ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Склад КАК Склад,
	        |	NULL КАК Номенклатура,
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки.IDSite КАК IDSite
	        |ПОМЕСТИТЬ ВтДвижения
	        |ИЗ
	        |	РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
	        |ГДЕ
	        |	РазмещенияСтрокЗаказов.Регистратор = &ДокументСсылка
	        |	И РазмещенияСтрокЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	        |	И РазмещенияСтрокЗаказов.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И РазмещенияСтрокЗаказов.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки,
	        |	РазмещенияСтрокЗаказов.СтрокаПрихода,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА 4
	        |		ИНАЧЕ 3
	        |	КОНЕЦ,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровПринят)
	        |				ИЛИ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.статусыДокументов.ПоступлениеТоваровРазмещен)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВПутиПК)
	        |	КОНЕЦ,
	        |	РазмещенияСтрокЗаказов.Регистратор,
	        |	РазмещенияСтрокЗаказов.СтрокаЗаявки.IDSite,
	        |	ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).Склад";
	
	
КонецФункции

Функция ЗапросСостояние_РеализацияТоваровУслуг() 
	Возврат "ВЫБРАТЬ
	        |	ПартииТоваров.Регистратор,
	        |	ПартииТоваров.Номенклатура,
	        |	ПартииТоваров.Склад,
	        |	МИНИМУМ(ПартииТоваров.СтрокаПрихода) КАК СтрокаПрихода,
	        |	ПартииТоваров.Качество,
	        |	РеализацияТоваровУслугТовары.СтрокаЗаявки,
	        |	РеализацияТоваровУслугТовары.Количество
	        |ПОМЕСТИТЬ ВТПартии
	        |ИЗ
	        |	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	        |		ПО ПартииТоваров.Регистратор = РеализацияТоваровУслугТовары.Ссылка
	        |			И ПартииТоваров.Номенклатура = РеализацияТоваровУслугТовары.Номенклатура
	        |			И (РеализацияТоваровУслугТовары.Ссылка = &ДокументСсылка)
	        |			И (ПартииТоваров.Регистратор = &ДокументСсылка)
	        |			И ПартииТоваров.НомерСтрокиВДокументе = РеализацияТоваровУслугТовары.НомерСтроки
	        |			И ПартииТоваров.Склад = РеализацияТоваровУслугТовары.Ссылка.Склад
	        |ГДЕ
	        |	ПартииТоваров.Регистратор = &ДокументСсылка
	        |	И РеализацияТоваровУслугТовары.Ссылка.ЭтоМФП = ЛОЖЬ
	        |	И ПартииТоваров.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ПартииТоваров.Регистратор,
	        |	ПартииТоваров.Номенклатура,
	        |	ПартииТоваров.Склад,
	        |	ПартииТоваров.Качество,
	        |	РеализацияТоваровУслугТовары.СтрокаЗаявки,
	        |	РеализацияТоваровУслугТовары.Количество
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
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугУпакован)
	        |				ИЛИ ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче)
	        |			ТОГДА 7
	        |		ИНАЧЕ 8
	        |	КОНЕЦ КАК Порядок,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	        |			ТОГДА ВЫБОР
	        |					КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).ТипДоставки = ЗНАЧЕНИЕ(Справочник.ТипыДоставки.ЭкспрессДоставка)
	        |						ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ИдетСборкаПКЭкспресс)
	        |					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.СборкаПК)
	        |				КОНЕЦ
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугУпакован)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Упаковано)
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче)
	        |			ТОГДА ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ГотовкВыдачи)
	        |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Выдано)
	        |	КОНЕЦ КАК Состояние,
	        |	&Период КАК Период,
	        |	ВЫБОР
	        |		КОГДА ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	        |				ИЛИ ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугУпакован)
	        |				ИЛИ ВЫРАЗИТЬ(ВТПартии.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче)
	        |			ТОГДА ВТПартии.Количество
	        |		ИНАЧЕ Продажи.Количество
	        |	КОНЕЦ КАК Количество,
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
	        |			И ВТПартии.СтрокаЗаявки = Продажи.СтрокаЗаявки
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ОтказыПоЗаявкам.ПричинаОтказа,
	        |	ОтказыПоЗаявкам.Регистратор,
	        |	ОтказыПоЗаявкам.Период,
	        |	МАКСИМУМ(ОтказыПоЗаявкам.Количество) КАК Количество
	        |ПОМЕСТИТЬ ВТОтказы
	        |ИЗ
	        |	РегистрНакопления.ОтказыПоЗаявкам КАК ОтказыПоЗаявкам
	        |ГДЕ
	        |	ОтказыПоЗаявкам.СтрокаЗаявки.Виртуальная = ЛОЖЬ
	        |	И ОтказыПоЗаявкам.Количество > 0
	        |	И ОтказыПоЗаявкам.Регистратор = &ДокументСсылка
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ОтказыПоЗаявкам.СтрокаЗаявки,
	        |	ОтказыПоЗаявкам.ПричинаОтказа,
	        |	ОтказыПоЗаявкам.Регистратор,
	        |	ОтказыПоЗаявкам.Период
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |	ВТПродажи.СтрокаЗаявки КАК СтрокаЗаявки,
	        |	ВТПродажи.СтрокаПрихода,
	        |	ВТПродажи.Отказ,
	        |	ВТПродажи.Порядок,
	        |	МАКСИМУМ(ВТПродажи.Состояние) КАК Состояние,
	        |	ВТПродажи.Период,
	        |	СУММА(ВТПродажи.Количество) КАК Количество,
	        |	ВТПродажи.Изменена,
	        |	ВТПродажи.Документ КАК Регистратор,
	        |	МАКСИМУМ(ВТПродажи.Склад) КАК Склад,
	        |	МАКСИМУМ(ВТПродажи.Номенклатура) КАК Номенклатура,
	        |	ВТПродажи.СтрокаЗаявки.IDSite КАК IDSite
	        |ПОМЕСТИТЬ ВтДвижения
	        |ИЗ
	        |	ВТПродажи КАК ВТПродажи
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ВТПродажи.СтрокаЗаявки,
	        |	ВТПродажи.СтрокаПрихода,
	        |	ВТПродажи.Отказ,
	        |	ВТПродажи.Порядок,
	        |	ВТПродажи.Документ,
	        |	ВТПродажи.СтрокаЗаявки.IDSite,
	        |	ВТПродажи.Период,
	        |	ВТПродажи.Изменена
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
	        |	СУММА(ВТОтказы.Количество),
	        |	ИСТИНА,
	        |	ВТОтказы.Регистратор,
	        |	МАКСИМУМ(ВТПартии.Склад),
	        |	МАКСИМУМ(ВТПартии.Номенклатура),
	        |	ВТОтказы.СтрокаЗаявки.IDSite
	        |ИЗ
	        |	ВТОтказы КАК ВТОтказы
	        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПартии КАК ВТПартии
	        |		ПО ВТОтказы.Регистратор = ВТПартии.Регистратор
	        |			И ВТОтказы.СтрокаЗаявки = ВТПартии.СтрокаЗаявки
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ВТОтказы.Регистратор,
	        |	ВТОтказы.СтрокаЗаявки,
	        |	ВТПартии.СтрокаПрихода,
	        |	ВТОтказы.ПричинаОтказа,
	        |	ВТОтказы.СтрокаЗаявки.IDSite" ;
	
	
	
КонецФункции

Функция ЗапросСостояние_ПеремещениеТоваров()
	Возврат 	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки КАК СтрокаЗаявки,
	        	|	ПартииТоваров.СтрокаПрихода КАК СтрокаПрихода,
	        	|	ЛОЖЬ КАК Отказ,
	        	|	4 КАК Порядок,
	        	|	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ПринятНаСкладе) КАК Состояние,
	        	|	&Период КАК Период,
	        	|	СУММА(ПартииТоваров.Количество) КАК Количество,
	        	|	ИСТИНА КАК Изменена,
	        	|	ПеремещениеТоваровТовары.Ссылка КАК Регистратор,
	        	|	ПартииТоваров.Склад,
	        	|	ПартииТоваров.Номенклатура,
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки.IDSite КАК IDSite
	        	|ИЗ
	        	|	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	        	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	        	|		ПО (ВЫРАЗИТЬ(ПартииТоваров.Регистратор КАК Документ.ПеремещениеТоваров).ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещенияТоваров.ПриемкаТопЛог))
	        	|			И (ПеремещениеТоваровТовары.Ссылка = &ДокументСсылка)
	        	|			И (ПартииТоваров.Регистратор = &ДокументСсылка)
	        	|			И ПеремещениеТоваровТовары.Номенклатура = ПартииТоваров.Номенклатура
	        	|			И (ПартииТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	        	|			И (ПеремещениеТоваровТовары.СтрокаЗаявки.Виртуальная = ЛОЖЬ)
	        	|			И ПеремещениеТоваровТовары.НомерСтроки = ПартииТоваров.НомерСтрокиВДокументе
	        	|
	        	|СГРУППИРОВАТЬ ПО
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки,
	        	|	ПартииТоваров.СтрокаПрихода,
	        	|	ПартииТоваров.Склад,
	        	|	ПартииТоваров.Номенклатура,
	        	|	ПеремещениеТоваровТовары.Ссылка,
	        	|	ПеремещениеТоваровТовары.СтрокаЗаявки.IDSite
	        	|
	        	|ОБЪЕДИНИТЬ ВСЕ
	        	|
	        	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	        	|	РезервыТоваров.СтрокаЗаявки,
	        	|	РезервыТоваров.СтрокаПрихода,
	        	|	ЛОЖЬ,
	        	|	5,
	        	|	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВРезерве),
	        	|	&Период,
	        	|	СУММА(РезервыТоваров.Количество),
	        	|	ИСТИНА,
	        	|	РезервыТоваров.Регистратор,
	        	|	РезервыТоваров.Склад,
	        	|	МАКСИМУМ(РезервыТоваров.Номенклатура),
	        	|	РезервыТоваров.СтрокаЗаявки.IDSite
	        	|ИЗ
	        	|	РегистрНакопления.РезервыТоваров КАК РезервыТоваров
	        	|ГДЕ
	        	|	РезервыТоваров.Регистратор = &ДокументСсылка
	        	|	И РезервыТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	        	|
	        	|СГРУППИРОВАТЬ ПО
	        	|	РезервыТоваров.Регистратор,
	        	|	РезервыТоваров.Склад,
	        	|	РезервыТоваров.СтрокаЗаявки,
	        	|	РезервыТоваров.СтрокаПрихода,
	        	|	РезервыТоваров.СтрокаЗаявки.IDSite"
	
КонецФункции	

Функция ЗапросСостояние_ТекщиеДвижения()
Возврат 	"ВЫБРАТЬ
        	|	ИсторияЗаявокПокупателя.Период,
        	|	ИсторияЗаявокПокупателя.Регистратор КАК Регистратор,
        	|	ИсторияЗаявокПокупателя.СтрокаЗаявки,
        	|	ИсторияЗаявокПокупателя.СтрокаПрихода,
        	|	ИсторияЗаявокПокупателя.Отказ,
        	|	ИсторияЗаявокПокупателя.Порядок,
        	|	ИсторияЗаявокПокупателя.Состояние,
        	|	ИсторияЗаявокПокупателя.ДатаСобытия,
        	|	ИсторияЗаявокПокупателя.Количество,
        	|	ИсторияЗаявокПокупателя.Изменена,
        	|	ИсторияЗаявокПокупателя.Склад,
        	|	ИсторияЗаявокПокупателя.Номенклатура,
        	|	ИсторияЗаявокПокупателя.IDSite
        	|ИЗ
        	|	РегистрСведений.ИсторияЗаявокПокупателя КАК ИсторияЗаявокПокупателя
        	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтДвижения КАК ВтДвижения
        	|		ПО ИсторияЗаявокПокупателя.СтрокаЗаявки = ВтДвижения.СтрокаЗаявки
        	|			И ИсторияЗаявокПокупателя.Порядок = ВтДвижения.Порядок
        	|ГДЕ
        	|	ВтДвижения.СтрокаЗаявки ЕСТЬ NULL
        	|	И ИсторияЗаявокПокупателя.Регистратор = &ДокументСсылка
        	|
        	|ОБЪЕДИНИТЬ ВСЕ
        	|
        	|ВЫБРАТЬ
        	|	ВтДвижения.Период,
        	|	ВтДвижения.Регистратор,
        	|	ВтДвижения.СтрокаЗаявки,
        	|	ВтДвижения.СтрокаПрихода,
        	|	ВтДвижения.Отказ,
        	|	ВтДвижения.Порядок,
        	|	ВтДвижения.Состояние,
        	|	NULL,
        	|	ВтДвижения.Количество,
        	|	ВтДвижения.Изменена,
        	|	ВтДвижения.Склад,
        	|	ВтДвижения.Номенклатура,
        	|	ВтДвижения.IDSite
        	|ИЗ
        	|	ВтДвижения КАК ВтДвижения"
	
КонецФункции	

Функция СтрокаИтогов()
Возврат " ИТОГИ ПО
	| Регистратор	" ;
	
КонецФункции	

Функция ЗапросСтатуса_ЗаказыЗаявки()
	Запрос = новый запрос( "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыКорректировокСрезПоследних.СтатусДокумента,
	|	1 КАК Приоритет
	|ИЗ
	|	РегистрСведений.ДокументыКорректировок.СрезПоследних(, Документ = &ДокументСсылка) КАК ДокументыКорректировокСрезПоследних
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказПоставщику.СтатусДокумента,
	|	0
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка = &ДокументСсылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаявкаПокупателя.СтатусДокумента,
	|	0
	|ИЗ
	|	Документ.ЗаявкаПокупателя КАК ЗаявкаПокупателя
	|ГДЕ
	|	ЗаявкаПокупателя.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет УБЫВ" );
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() тогда 
		возврат Справочники.СтатусыДокументов.ПустаяСсылка();
	иначе 
		Выборка = Результат.Выбрать();
		выборка.Следующий();
		Возврат Выборка.СтатусДокумента;
	КонецЕсли;
	
КонецФункции	
#КонецОбласти 


#Область СтатусыДокументов

Функция НоваяСхемаЗакрытияЗаявок(Дата) Экспорт 
	 Возврат Дата> Константы.ДатаНовойСхемыЗакрытияЗаявок.Получить();	
КонецФункции	

Процедура ИзменитьКорректировкуЗаказаЗаявки(знач Документ,СтруктураЗаполнения,ПровестиИзменения = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику") 
		или  ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаказПоставщику")  
		или  ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявкаПокупателя")
		или   ТипЗнч(Документ) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") тогда
		Документ = Документ.ПолучитьОбъект();
	КонецЕсли;	
		
	МетаданныеДокумента = Документ.метаданные();
	
	Модифицированость = Ложь;
	
	Для каждого ЭлементаСтруктуры  из СтруктураЗаполнения цикл 
		Если НЕ МетаданныеДокумента.Реквизиты.Найти(ЭлементаСтруктуры.ключ) = Неопределено
			 и Не Документ[ЭлементаСтруктуры.ключ] = ЭлементаСтруктуры.Значение тогда 
				 Документ[ЭлементаСтруктуры.ключ] = ЭлементаСтруктуры.Значение;
		Иначеесли  НЕ МетаданныеДокумента.ТабличныеЧасти.Найти(ЭлементаСтруктуры.ключ) = Неопределено тогда 
			Документ[ЭлементаСтруктуры.ключ].Загрузить(ЭлементаСтруктуры.Значение);
		ИначеЕсли  ЭлементаСтруктуры.ключ = "Дата" тогда
			Документ.Дата =  ЭлементаСтруктуры.Значение;
		иначе 	
			Продолжить;
		КонецЕсли;	
		
		Модифицированость = Истина
	КонецЦикла;	
	
	Если не Модифицированость тогда 
		Возврат;
	КонецЕсли;
	Документ.ДополнительныеСвойства.Вставить("СнятьОграничениеПоДатеЗапрета");
	Документ.Записать(?(ПровестиИзменения,РежимЗаписиДокумента.Проведение,РежимЗаписиДокумента.Запись));
	
	
КонецПроцедуры	


Функция ПоЗаявкеЕстьАктивныйЗаказ(ДокументЗаявка,Период = Неопределено) Экспорт 
	
	ПоследняяКорректировка = ПолучитьПоследниюКорректировкуЗаявкиЗаказа(ДокументЗаявка);
	Если Период = Неопределено тогда 
		Период = ТекущаяДата();
	КонецЕсли;		
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказыПоставщикамОстатки.СтрокаЗаявки,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|			&Период,
	|			СтрокаЗаявки В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ВложенныйЗапрос.СтрокаЗаявки
	|				ИЗ
	|					(ВЫБРАТЬ
	|						ЗаявкаПокупателяТовары.СтрокаЗаявки КАК СтрокаЗаявки
	|					ИЗ
	|						Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
	|					ГДЕ
	|						ЗаявкаПокупателяТовары.Ссылка = &ДокументЗаявка
	|			
	|					ОБЪЕДИНИТЬ ВСЕ
	|			
	|					ВЫБРАТЬ
	|						КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки
	|					ИЗ
	|						Документ.КорректировкаЗаявкиПокупателя.Товары КАК КорректировкаЗаявкиПокупателяТовары
	|					ГДЕ
	|						КорректировкаЗаявкиПокупателяТовары.Ссылка = &ДокументЗаявка) КАК ВложенныйЗапрос)) КАК ЗаказыПоставщикамОстатки
	|ГДЕ
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("ДокументЗаявка", ДокументЗаявка);
	Запрос.УстановитьПараметр("Период", Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат не РезультатЗапроса.Пустой();
КонецФункции	


#КонецОбласти


#Область ВызовСервера
// т.к у нас в толстом клиенте 90% кода идет на клиенте , не стал делать отдельный модуль вызова сервера , а все включил сюда 
Функция СтрокаЗаявкиЗакрыта(СтрокаЗаявки) Экспорт 
	возврат РаботаСоСтатусамиДокументовПовтИсп.СтрокаЗаявкиЗакрыта(СтрокаЗаявки);
КонецФункции	



Функция ТекущийСтатусДокумента(ДокументСсылка) экспорт 
	
	Если ТипЗнч(ДокументСсылка)  =  тип("ДокументСсылка.ЗаказПоставщику") 
		или ТипЗнч(ДокументСсылка)  =  тип("ДокументСсылка.ЗаявкаПокупателя") тогда 
		 возврат РаботаСоСтатусамиДокументовПовтИсп.ТекущийСтатусЗаявкиЗаказа(ДокументСсылка);
	КонецЕсли;

КонецФункции

Функция ЗаявкаЗакрыта(ДокументСсылка,НеИспользоватьКэш = Ложь) Экспорт
	Если НеИспользоватьКэш  тогда 
		Возврат ЗаявкаЗакрытаБезКэша(ДокументСсылка);
	иначе 	
		Возврат РаботаСоСтатусамиДокументовПовтИсп.ЗаявкаЗакрыта(ДокументСсылка);
	КонецЕсли;
КонецФункции

Функция ЗаявкаЗакрытаБезКэша(ДокументСсылка)  Экспорт
	ЗапросОстатков = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаявкиПокупателейОстатки.СтрокаЗаявки
	|ИЗ
	|	Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаявкиПокупателей.Остатки КАК ЗаявкиПокупателейОстатки
	|		ПО ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗаявкиПокупателейОстатки.СтрокаЗаявки
	|			И (ЗаявкиПокупателейОстатки.КоличествоОстаток > 0)
	|ГДЕ
	|	ЗаявкаПокупателяТовары.Ссылка = &ДокументСсылка");
	ЗапросОстатков.УстановитьПараметр("ДокументСсылка",ДокументСсылка);
	Результат = ЗапросОстатков.Выполнить();
	Возврат Результат.Пустой() 	
КонецФункции	

Функция ПолучитьПоследниюКорректировкуЗаявкиЗаказа(ДокументСсылка,ДатаОтбора = Неопределено) Экспорт 
	Если ДатаОтбора = Неопределено тогда 
		ДатаОтбора = ТекущаяДата();
	КонецЕсли;	
	
	ТабСреза = РегистрыСведений.ДокументыКорректировок.СрезПоследних(ДатаОтбора,новый Структура("Документ",ДокументСсылка));	
	Если ТабСреза.Количество() тогда 
		Возврат  ТабСреза[0].ДокументКорректировки;
	иначе 
		Возврат ДокументСсылка ;
	КонецЕсли;	
КонецФункции

Процедура ОбработатьОтменуПроведенияДокумента(Источник, Отказ) Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры
#КонецОбласти

