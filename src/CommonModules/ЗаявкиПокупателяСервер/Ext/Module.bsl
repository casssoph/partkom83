﻿#Область СостоянияСтрокЗаявок

Процедура ОбновитьСостоянияВСтрокеЗаявки(МасивСтрокЗаявок)
	ЗапросСостояний  = Новый Запрос;
	ЗапросСостояний.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИдентификаторыСтрокЗаявок.Ссылка
	|ИЗ
	|	Справочник.ИдентификаторыСтрокЗаявок КАК ИдентификаторыСтрокЗаявок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаявкиПокупателей.Остатки(, СтрокаЗаявки В (&МассивСтрокЗаявок)) КАК ЗаявкиПокупателейОстатки
	|		ПО (ЗаявкиПокупателейОстатки.СтрокаЗаявки = ИдентификаторыСтрокЗаявок.Ссылка)
	|			И (ЗаявкиПокупателейОстатки.КоличествоОстаток > 0)
	|ГДЕ
	|	ИдентификаторыСтрокЗаявок.СостояниеЗаявки = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ЗаявкаПокупателяПодтвержден)
	|	И ЗаявкиПокупателейОстатки.СтрокаЗаявки ЕСТЬ NULL
	|	И ИдентификаторыСтрокЗаявок.Виртуальная = ЛОЖЬ
	|	И ИдентификаторыСтрокЗаявок.Ссылка В(&МассивСтрокЗаявок)";
	ЗапросСостояний.УстановитьПараметр("МассивСтрокЗаявок",МасивСтрокЗаявок);				
	
	РезультатЗапроса = ЗапросСостояний.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ИдентСтрокЗаявки = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ИдентСтрокЗаявки.СостояниеЗаявки = Справочники.СтатусыДокументов.ЗаявкаПокупателяЗакрыт;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ИдентСтрокЗаявки);
		
		РегистрыСведений.ДатыЗакрытияЗаявокОчередьОбработки.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСостояниеСтрокПоДокументу(ДокументСсылка) Экспорт 
	Если //ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаявкаПокупателя") или // ЛНА, убрал из-за проблем с производительностью
		//ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЗаказПоставщику") или // ЛНА 
		ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") или 
		ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику")  или 
		ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПеремещениеТоваров")  тогда 
		ТабСтрокДокумента = ОбщегоНазначения.ЗначенияРеквизитовТабличнойЧастиОбъекта(ДокументСсылка,"Товары","СтрокаЗаявки");
		Если ТабСтрокДокумента.Количество() тогда 
			МасивСтрокЗаявок = ТабСтрокДокумента.ВыгрузитьКолонку("СтрокаЗаявки");
			ОбновитьСостоянияВСтрокеЗаявки(МасивСтрокЗаявок);
		Конецесли;
	Конецесли;
	
КонецПроцедуры	

#КонецОбласти


#Область Отказы
Функция ДоступноеКоличествоПоЗаявкеКОтказу(СтрокаЗаявки,МоментВремениДокумента,ПроверятьОстатокПоЗаказу) Экспорт
	ЗапросКОтказу = новый Запрос;
	ЗапросКОтказу.УстановитьПараметр("СтрокаЗаявки",СтрокаЗаявки);
	ЗапросКОтказу.УстановитьПараметр("МоментВремени",новый Граница(МоментВремениДокумента,ВидГраницы.Исключая));
	ЗапросКотказу.УстановитьПараметр("ПроверятьОстатокПоЗаказу",ПроверятьОстатокПоЗаказу);
	
	Если СтрокаЗаявки.ТипПоставки = Перечисления.ТипПоставки.ПополнениеСклада тогда 
		ЗапросКОтказу.Текст = ДоступноеКоличествоПоЗаявкеКОтказу_ПополнениеСклада();	
	Иначеесли  СтрокаЗаявки.ТипПоставки = Перечисления.ТипПоставки.Сток тогда	
		ЗапросКОтказу.Текст =  ДоступноеКоличествоПоЗаявкеКОтказу_Сток();
	иначеесли   СтрокаЗаявки.ТипПоставки = Перечисления.ТипПоставки.Кросс тогда
		ЗапросКОтказу.Текст =  ДоступноеКоличествоПоЗаявкеКОтказу_Кросс();
	Иначе 
		ЗапросКОтказу.Текст = ДоступноеКоличествоПоЗаявкеКОтказу_Прочее();
	КонецЕсли;	
	
	ЗапросКОтказу.УстановитьПараметр("СтрокаЗаявки",СтрокаЗаявки);
	ЗапросКОтказу.УстановитьПараметр("МоментВремени",новый Граница(МоментВремениДокумента,ВидГраницы.Исключая));
	ЗапросКотказу.УстановитьПараметр("ПроверятьОстатокПоЗаказу",ПроверятьОстатокПоЗаказу);
	Результат = ЗапросКОтказу.Выполнить();
	если Результат.Пустой() тогда 
		Возврат 0 
	Иначе 
		Выбор = Результат.Выбрать();
		Выбор.Следующий();
		возврат Выбор.ДоступныйОтказ
	КонецЕсли;	
	
	
КонецФункции



Функция ДоступноеКоличествоПоЗаявкеКОтказу_ПополнениеСклада()
Возврат  "ВЫБРАТЬ ПЕРВЫЕ 1
         |	ВложенныйЗапрос.КоличествоВЗаявке - ВложенныйЗапрос.КоличествоВЗаказе - ВложенныйЗапрос.КоличествоКРазмещению КАК ДоступныйОтказ
         |ИЗ
         |	(ВЫБРАТЬ ПЕРВЫЕ 1
         |		ЗаявкиПокупателейОстатки.КоличествоОстаток КАК КоличествоВЗаявке,
         |		СУММА(ЕСТЬNULL(РазмещенияСтрокЗаказов.Количество, 0)) КАК КоличествоКРазмещению,
         |		ВЫБОР
         |			КОГДА &ПроверятьОстатокПоЗаказу
         |				ТОГДА ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0)
         |			ИНАЧЕ 0
         |		КОНЕЦ КАК КоличествоВЗаказе
         |	ИЗ
         |		РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
         |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&МоментВремени, ) КАК ЗаказыПоставщикамОстатки
         |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ЗаказыПоставщикамОстатки.СтрокаЗаявки
         |				И (ЗаказыПоставщикамОстатки.КоличествоОстаток > 0)
         |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
         |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказов.СтрокаЗаявки
         |				И (РазмещенияСтрокЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
         |				И (РазмещенияСтрокЗаказов.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг)
         |				И (НЕ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента В (ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровПринят), ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровРазмещен)))
         |	
         |	СГРУППИРОВАТЬ ПО
         |		ЗаявкиПокупателейОстатки.КоличествоОстаток,
         |		ВЫБОР
         |			КОГДА &ПроверятьОстатокПоЗаказу
         |				ТОГДА ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0)
         |			ИНАЧЕ 0
         |		КОНЕЦ) КАК ВложенныйЗапрос";
	
КонецФункции	

Функция ДоступноеКоличествоПоЗаявкеКОтказу_Кросс()
	Возврат "ВЫБРАТЬ ПЕРВЫЕ 1
	        |	ВложенныйЗапрос.КоличествоВЗаявке - ВложенныйЗапрос.КоличествоВЗаказе - ВложенныйЗапрос.КоличествоКРазмещению - ВложенныйЗапрос.КоличествоКОтгрузке КАК ДоступныйОтказ
	        |ИЗ
	        |	(ВЫБРАТЬ ПЕРВЫЕ 1
	        |		ЗаявкиПокупателейОстатки.КоличествоОстаток КАК КоличествоВЗаявке,
	        |		СУММА(ЕСТЬNULL(РазмещенияСтрокЗаказов.Количество, 0)) КАК КоличествоКРазмещению,
	        |		СУММА(ЕСТЬNULL(ТоварыКОтгрузке.Количество, 0)) КАК КоличествоКОтгрузке,
	        |		ВЫБОР
	        |			КОГДА &ПроверятьОстатокПоЗаказу
	        |				ТОГДА ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ КАК КоличествоВЗаказе
	        |	ИЗ
	        |		РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
	        |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&МоментВремени, ) КАК ЗаказыПоставщикамОстатки
	        |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ЗаказыПоставщикамОстатки.СтрокаЗаявки
	        |				И (ЗаказыПоставщикамОстатки.КоличествоОстаток > 0)
	        |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
	        |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ТоварыКОтгрузке.СтрокаЗаявки
	        |				И (ТоварыКОтгрузке.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг)
	        |				И (ВЫРАЗИТЬ(ТоварыКОтгрузке.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка))
	        |				И (ВЫРАЗИТЬ(ТоварыКОтгрузке.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка))
	        |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
	        |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказов.СтрокаЗаявки
	        |				И (РазмещенияСтрокЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	        |				И (РазмещенияСтрокЗаказов.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг)
	        |				И (НЕ ВЫРАЗИТЬ(РазмещенияСтрокЗаказов.Регистратор КАК Документ.ПоступлениеТоваровУслуг).СтатусДокумента В (ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровПринят), ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПоступлениеТоваровРазмещен)))
	        |	
	        |	СГРУППИРОВАТЬ ПО
	        |		ЗаявкиПокупателейОстатки.КоличествоОстаток,
	        |		ВЫБОР
	        |			КОГДА &ПроверятьОстатокПоЗаказу
	        |				ТОГДА ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК ВложенныйЗапрос";
	
КонецФункции	

Функция ДоступноеКоличествоПоЗаявкеКОтказу_Сток()
	 //#XX-2781 Kalinin V.A. ( 2019-06-26 )  /* добавил статусы
	Возврат "ВЫБРАТЬ ПЕРВЫЕ 1
	        |	ЗаявкиПокупателейОстатки.КоличествоОстаток - ЕСТЬNULL(ТоварыКОтгрузке.Количество, 0) КАК ДоступныйОтказ
	        |ИЗ
	        |	РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке КАК ТоварыКОтгрузке
	        |		ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ТоварыКОтгрузке.СтрокаЗаявки
	        |			И (ТоварыКОтгрузке.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг)
	        |			И (ВЫРАЗИТЬ(ТоварыКОтгрузке.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка)
	        |				ИЛИ ВЫРАЗИТЬ(ТоварыКОтгрузке.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугУпакован)
	        |				ИЛИ ВЫРАЗИТЬ(ТоварыКОтгрузке.Регистратор КАК Документ.РеализацияТоваровУслуг).СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче))";
	
КонецФункции	



Функция ДоступноеКоличествоПоЗаявкеКОтказу_Прочее()
	
	Возврат  "ВЫБРАТЬ ПЕРВЫЕ 1
	         |	ЗаявкиПокупателейОстатки.КоличествоОстаток КАК ДоступныйОтказ
	         |ИЗ
	         |	РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
	         |ГДЕ
	         |	ЗаявкиПокупателейОстатки.КоличествоОстаток > 0"	
	
	
КонецФункции	

Функция СтрокаЗаявкиЗакрыта(СтрокаЗаявки) Экспорт
	Возврат   СтрокаЗаявки.СостояниеЗаявки = Справочники.СтатусыДокументов.ЗаявкаПокупателяЗакрыт;
	
КонецФункции	


#КонецОбласти

#Область  Контроль_документов
//Процедура ПроверитьНаЗакрытыеСтрокиЗаявок()
//	
//	
//	
//КонецПроцедуры	
Функция ВсеСтрокиЗаявокЗакрыты(МассивСтрокЗаявок)  экспорт
	
КонецФункции	


Функция ПоСтрокеЗаявкиЕстьАктивныйЗаказ(СтрокаЗаявки) Экспорт
Остатки = РегистрыНакопления.ЗаказыПоставщикам.Остатки(,Новый Структура("СтрокаЗаявки",СтрокаЗаявки),"СтрокаЗаявки","Количество");
Если Остатки.Количество() тогда 
	 Возврат ?(Остатки[0].Количество>0,Истина,Ложь);
иначе 
	Возврат Ложь;
КонецЕсли;	
	
	
	
Конецфункции 	

Функция ПоСтрокеЗаявкиЕстьАктивныйРезерв(СтрокаЗаявки) Экспорт
Остатки = РегистрыНакопления.РезервыТоваров.Остатки(,Новый Структура("СтрокаЗаявки",СтрокаЗаявки),"СтрокаЗаявки","Количество");
Если Остатки.Количество() тогда 
	 Возврат ?(Остатки[0].Количество>0,Истина,Ложь);
иначе 
	Возврат Ложь;
КонецЕсли;	
		
КонецФункции
#КонецОбласти


#Область Работа_со_Строками_заявки
Процедура  СоздатьОбновитьСтрокиЗаявки(Документ)Экспорт
	Если ЭтоРозничнаяЗаявка(документ) тогда 
		СоздатьОбновитьСтрокиЗаявки_Розница(Документ);			
	иначе 
		Возврат ///Нехватило духа переписать весь механизм созданиязаявки. если у кого хватит духа, напишите
	КонецЕсли;
КонецПроцедуры


Процедура СоздатьОбновитьСтрокиЗаявки_Розница(Документ)
ВыборкаИзмененийСтрок = ПолучитьВыборкуДанныхПоДокументу(Документ);

Пока ВыборкаИзмененийСтрок.Следующий() цикл 
	
	Если ВыборкаИзмененийСтрок.КСозданию тогда 
		СтрокаЗаявки = Справочники.ИдентификаторыСтрокЗаявок.СоздатьЭлемент();
		СтрокаЗаявки.Наименование =  ПолучитьНаименованиеНовойЗаявки(Документ.Номер,ВыборкаИзмененийСтрок.ТипПоставки,ВыборкаИзмененийСтрок.Номенклатура,ВыборкаИзмененийСтрок.цена);
		
	КонецЕсли;	
	
	
	
	
КонецЦикла;	

КонецПроцедуры	


Функция ПолучитьВыборкуДанныхПоДокументу(Документ)
ЗапросДанных = Новый Запрос;	
ЗапросДанных.Текст = "ВЫБРАТЬ
                     |	ВЫБОР
                     |		КОГДА &Ссылка ССЫЛКА Документ.ЗаявкаПокупателя
                     |			ТОГДА &Ссылка
                     |		ИНАЧЕ ВЫРАЗИТЬ(&Ссылка КАК Документ.КорректировкаЗаявкиПокупателя).ДокументОснование
                     |	КОНЕЦ КАК Заявка,
                     |	ЗаявкаПокупателяТовары.IDSite,
                     |	ВЫРАЗИТЬ(ЗаявкаПокупателяТовары.ПрайсПоставщика КАК Справочник.ПрайсыПоставщиков) КАК ПрайсПоставщика,
                     |	ЗаявкаПокупателяТовары.Номенклатура,
                     |	ЗаявкаПокупателяТовары.СтрокаЗаявки,
                     |	ЗаявкаПокупателяТовары.Количество,
                     |	ЗаявкаПокупателяТовары.Ссылка,
                     |	ВЫБОР
                     |		КОГДА ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.пустаяссылка)
                     |			ТОГДА ИСТИНА
                     |		ИНАЧЕ ЛОЖЬ
                     |	КОНЕЦ КАК КСозданию,
                     |	ВЫБОР
                     |		КОГДА НЕ ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.пустаяссылка)
                     |			ТОГДА ВЫБОР
                     |					КОГДА НЕ ЗаявкаПокупателяТовары.Номенклатура = ЗаявкаПокупателяТовары.СтрокаЗаявки.Номенклатура
                     |							ИЛИ НЕ ЗаявкаПокупателяТовары.ПрайсПоставщика = ЗаявкаПокупателяТовары.СтрокаЗаявки.ПрайсПоставщика
                     |						ТОГДА ИСТИНА
                     |					ИНАЧЕ ЛОЖЬ
                     |				КОНЕЦ
                     |		ИНАЧЕ ЛОЖЬ
                     |	КОНЕЦ КАК КОбновлению,
                     |	&МаршрутДоставки,
                     |	ВЫБОР
                     |		КОГДА НЕ ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.пустаяссылка)
                     |			ТОГДА ЗаявкаПокупателяТовары.СтрокаЗаявки.СрокГарантированый
                     |		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
                     |	КОНЕЦ КАК СрокГарантированый,
                     |	ВЫБОР
                     |		КОГДА НЕ ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.пустаяссылка)
                     |			ТОГДА ЗаявкаПокупателяТовары.СтрокаЗаявки.СрокОжидаемый
                     |		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
                     |	КОНЕЦ КАК СрокОжидаемый,
                     |	ВЫБОР
                     |		КОГДА НЕ ЗаявкаПокупателяТовары.СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.пустаяссылка)
                     |			ТОГДА ЗаявкаПокупателяТовары.СтрокаЗаявки.СрокГарантированыйЗаказа
                     |		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
                     |	КОНЕЦ КАК СрокГарантированыйЗаказа,
                     |	&Склад
                     |ПОМЕСТИТЬ ВТТоваров
                     |ИЗ
                     |	&ТЧТовары КАК ЗаявкаПокупателяТовары
                     |;
                     |
                     |////////////////////////////////////////////////////////////////////////////////
                     |ВЫБРАТЬ
                     |	ТоварыНаСкладахОстатки.Номенклатура,
                     |	СУММА(ТоварыНаСкладахОстатки.КоличествоОстаток) КАК КоличествоСток,
                     |	NULL КАК КоличествоVMI,
                     |	1 КАК Приоритет,
                     |	ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Сток) КАК ТипПоставки
                     |ПОМЕСТИТЬ ВТОстаткиНоменклатуры
                     |ИЗ
                     |	РегистрНакопления.ТоварыНаСкладах.Остатки(
                     |			&Период,
                     |			(Номенклатура, Склад) В
                     |				(ВЫБРАТЬ
                     |					ВТТоваров.Номенклатура КАК Номенклатура,
                     |					ВТТоваров.Склад КАК Склад
                     |				ИЗ
                     |					ВТТоваров КАК ВТТоваров
                     |				ГДЕ
                     |					ВТТоваров.КСозданию = ИСТИНА)) КАК ТоварыНаСкладахОстатки
                     |ГДЕ
                     |	ТоварыНаСкладахОстатки.КоличествоОстаток > 0
                     |
                     |СГРУППИРОВАТЬ ПО
                     |	ТоварыНаСкладахОстатки.Номенклатура
                     |
                     |ОБЪЕДИНИТЬ ВСЕ
                     |
                     |ВЫБРАТЬ
                     |	ПартииТоваровОстатки.Номенклатура,
                     |	NULL,
                     |	СУММА(ПартииТоваровОстатки.КоличествоОстаток),
                     |	2,
                     |	ЗНАЧЕНИЕ(Перечисление.ТипПоставки.VMI)
                     |ИЗ
                     |	РегистрНакопления.ПартииТоваров.Остатки(
                     |			&Период,
                     |			Номенклатура В
                     |					(ВЫБРАТЬ
                     |						ВТТоваров.Номенклатура КАК Номенклатура
                     |					ИЗ
                     |						ВТТоваров КАК ВТТоваров
                     |					ГДЕ
                     |						ВТТоваров.КСозданию = ИСТИНА)
                     |				И Склад В
                     |					(ВЫБРАТЬ
                     |						Склады.Ссылка КАК Ссылка
                     |					ИЗ
                     |						Справочник.Склады КАК Склады
                     |					ГДЕ
                     |						Склады.СкладVMI = ИСТИНА
                     |						И Склады.ФизическийСклад = &Склад)
                     |				И СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.ПринятыйНаОтветХранение)) КАК ПартииТоваровОстатки
                     |ГДЕ
                     |	ПартииТоваровОстатки.КоличествоОстаток > 0
                     |
                     |СГРУППИРОВАТЬ ПО
                     |	ПартииТоваровОстатки.Номенклатура
                     |
                     |ОБЪЕДИНИТЬ ВСЕ
                     |
                     |ВЫБРАТЬ РАЗЛИЧНЫЕ
                     |	ВТТоваров.Номенклатура,
                     |	NULL,
                     |	NULL,
                     |	3,
                     |	ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Кросс)
                     |ИЗ
                     |	ВТТоваров КАК ВТТоваров
                     |;
                     |
                     |////////////////////////////////////////////////////////////////////////////////
                     |ВЫБРАТЬ
                     |	ВТТоваров.Заявка,
                     |	ВТТоваров.IDSite,
                     |	ВТТоваров.Номенклатура,
                     |	ВТТоваров.СтрокаЗаявки,
                     |	ВТТоваров.Количество,
                     |	ВТТоваров.Ссылка,
                     |	ВТТоваров.ПрайсПоставщика,
                     |	ВЫБОР
                     |		КОГДА &ЭтоКонтрагентПополнения
                     |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипПоставки.ПополнениеСклада)
                     |		КОГДА ВТТоваров.ПрайсПоставщика ЕСТЬ NULL
                     |				ИЛИ ВТТоваров.ПрайсПоставщика = ЗНАЧЕНИЕ(Справочник.ПрайсыПоставщиков.Пустаяссылка)
                     |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Сток)
                     |		КОГДА ВЫРАЗИТЬ(ВТТоваров.ПрайсПоставщика КАК Справочник.ПрайсыПоставщиков).Склад = ЗНАЧЕНИЕ(Справочник.Склады.Пустаяссылка)
                     |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Кросс)
                     |		КОГДА ВЫРАЗИТЬ(ВТТоваров.ПрайсПоставщика КАК Справочник.ПрайсыПоставщиков).Склад.СкладVMI
                     |			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипПоставки.VMI)
                     |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Сток)
                     |	КОНЕЦ КАК ТипПоставки,
                     |	ВЫБОР
                     |		КОГДА ВТТоваров.ПрайсПоставщика <> ЗНАЧЕНИЕ(справочник.ПрайсыПоставщиков.ПустаяСсылка)
                     |				И ВТТоваров.ПрайсПоставщика.Владелец ССЫЛКА Справочник.ТорговыеТочки
                     |			ТОГДА ВЫРАЗИТЬ(ВТТоваров.ПрайсПоставщика.Владелец КАК Справочник.ТорговыеТочки).Владелец
                     |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.Пустаяссылка)
                     |	КОНЕЦ КАК Поставщик,
                     |	ВТТоваров.МаршрутДоставки,
                     |	ВЫБОР
                     |		КОГДА ДокументыКорректировокСрезПоследних.ДокументКорректировки ЕСТЬ NULL
                     |			ТОГДА ВЫБОР
                     |					КОГДА &Ссылка ССЫЛКА Документ.КорректировкаЗаявкиПокупателя
                     |						ТОГДА &Ссылка
                     |					ИНАЧЕ ЗНАЧЕНИЕ(Документ.КорректировкаЗаявкиПокупателя.пУСТАЯССЫЛКА)
                     |				КОНЕЦ
                     |	КОНЕЦ КАК ПоследняяКорректировка,
                     |	ВТТоваров.КСозданию,
                     |	ВТТоваров.КОбновлению
                     |ПОМЕСТИТЬ ВТСтрокаЗаявкиБезРазбития
                     |ИЗ
                     |	ВТТоваров КАК ВТТоваров
                     |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыКорректировок.СрезПоследних КАК ДокументыКорректировокСрезПоследних
                     |		ПО ВТТоваров.Заявка = ДокументыКорректировокСрезПоследних.Документ
                     |ГДЕ
                     |	(ВТТоваров.КСозданию = ИСТИНА
                     |			ИЛИ ВТТоваров.КОбновлению = ИСТИНА)
                     |;
                     |
                     |////////////////////////////////////////////////////////////////////////////////
                     |ВЫБРАТЬ
                     |	ВТСтрокаЗаявкиБезРазбития.Заявка,
                     |	ВТСтрокаЗаявкиБезРазбития.IDSite,
                     |	ВТСтрокаЗаявкиБезРазбития.Номенклатура,
                     |	ВТСтрокаЗаявкиБезРазбития.СтрокаЗаявки,
                     |	ВТСтрокаЗаявкиБезРазбития.Количество,
                     |	ВТСтрокаЗаявкиБезРазбития.Ссылка,
                     |	ВТСтрокаЗаявкиБезРазбития.ПрайсПоставщика,
                     |	ВТСтрокаЗаявкиБезРазбития.ТипПоставки,
                     |	ВТСтрокаЗаявкиБезРазбития.Поставщик,
                     |	ВТСтрокаЗаявкиБезРазбития.МаршрутДоставки,
                     |	ВТСтрокаЗаявкиБезРазбития.ПоследняяКорректировка,
                     |	ВТСтрокаЗаявкиБезРазбития.КСозданию,
                     |	ВТСтрокаЗаявкиБезРазбития.КОбновлению
                     |ИЗ
                     |	ВТСтрокаЗаявкиБезРазбития КАК ВТСтрокаЗаявкиБезРазбития
                     |		ЛЕВОЕ СОЕДИНЕНИЕ ВТОстаткиНоменклатуры КАК ВТОстаткиНоменклатуры
                     |		ПО ВТСтрокаЗаявкиБезРазбития.Номенклатура = ВТОстаткиНоменклатуры.Номенклатура
                     |			И (ВЫБОР
                     |				КОГДА ВТОстаткиНоменклатуры.КоличествоСток >= ВТСтрокаЗаявкиБезРазбития.Количество
                     |					ТОГДА ВТОстаткиНоменклатуры.Приоритет = 1
                     |				КОГДА ВТОстаткиНоменклатуры.КоличествоСток + ВТОстаткиНоменклатуры.КоличествоVMI >= ВТСтрокаЗаявкиБезРазбития.Количество
                     |					ТОГДА ВТОстаткиНоменклатуры.Приоритет = 1
                     |							ИЛИ ВТОстаткиНоменклатуры.Приоритет = 2
                     |				ИНАЧЕ ВТОстаткиНоменклатуры.Приоритет = 3
                     |			КОНЕЦ)"   ;

Для каждого Параметр из ЗапросДанных.Параметры цикл 
 	  Параметр.Значение = Документ[параметр.Ключ];
 КонецЦикла;	
  
РезультатЗапроса = ЗапросДанных.выполнить();
Возврат РезультатЗапроса.выбрать();
	
КонецФункции

Функция  ПолучитьНаименованиеНовойЗаявки(НомерЗаявки = Неопределено ,ТипПоставки  = Неопределено ,Номенклатура = Неопределено,Цена = Неопределено ) Экспорт 
	МассивПолей = Новый массив;
	Если  не НомерЗаявки = Неопределено тогда 
	МассивПолей.Вставить(СокрЛП(НомерЗаявки));
	КонецЕсли;
	
	Если  не ТипПоставки = Неопределено тогда 
	МассивПолей.Вставить(СокрЛП(ТипПоставки));
	КонецЕсли;

	Если  не Номенклатура = Неопределено тогда 
	МассивПолей.Вставить(Сокрлп(Номенклатура.Наименование));
	КонецЕсли;

	Если  не Цена = Неопределено тогда 
	МассивПолей.Вставить(Сокрлп(Номенклатура.Наименование));
	КонецЕсли;

	Возврат СтрСоединить(МассивПолей,";")
	
КонецФункции

Функция ЭтоРозничнаяЗаявка(ДокументЗаявка) Экспорт
	Возврат ДокументЗаявка.ИсточникЗаявки =ПредопределенноеЗначение("Перечисление.ИсточникиЗаявок.СайтРозница"); 	
	
КонецФункции	

Функция ПолучитьСтруктуруСтрокуЗаявки()
	
	СтруктураЗаявки = новый Структура;
	СтруктураЗаявки.Вставить("Заявка");
	
Конецфункции

#КонецОбласти


#Область ЗагрузкаЗаявокССайта

Процедура ОбработатьТаблицуТоваровРозничнойЗаявки(ДанныеОбъекта,ТаблицаТоваров) Экспорт 
ТаблицаОстатков = ПолучитьТекущиеОстатки(ТаблицаТоваров,ДанныеОбъекта.Слкад);
//СтруктураТаблицЗаявок = 
	
	
	
КонецПроцедуры	

Функция ПолучитьТекущиеОстатки(ТаблицаТоваров,Склад) 
Запрос = новый Запрос("ВЫБРАТЬ
                      |	ДанныеСайта.Номенклатура,
                      |	ДанныеСайта.ЕдиницаИзмерения,
                      |	ДанныеСайта.Коэфицент,
                      |	ДанныеСайта.СтавкаНДС,
                      |	ДанныеСайта.Качество,
                      |	ДанныеСайта.Цена,
                      |	ДанныеСайта.Количество,
                      |	ДанныеСайта.Сумма,
                      |	ДанныеСайта.IDSite,
                      |	&Склад,
                      |	ДанныеСайта.КомментарийИзСайта
                      |ПОМЕСТИТЬ ВТТоваров
                      |ИЗ
                      |	&ТаблицаТоваров КАК ДанныеСайта
                      |;
                      |
                      |////////////////////////////////////////////////////////////////////////////////
                      |ВЫБРАТЬ
                      |	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
                      |	ТоварыНаСкладахОстатки.Склад,
                      |	СУММА(ТоварыНаСкладахОстатки.КоличествоОстаток) КАК КоличествоСток,
                      |	NULL КАК КоличествоVMI,
                      |	1 КАК Приоритет,
                      |	ЗНАЧЕНИЕ(Перечисление.ТипПоставки.Сток) КАК ТипПоставки,
                      |	ЗНАЧЕНИЕ(Справочник.ПрайсыПоставщиков.Пустаяссылка) КАК Прайс
                      |ИЗ
                      |	РегистрНакопления.ТоварыНаСкладах.Остатки(
                      |			&Период,
                      |			(Номенклатура, Склад) В
                      |				(ВЫБРАТЬ
                      |					ВТТоваров.Номенклатура КАК Номенклатура,
                      |					ВТТоваров.Склад КАК Склад
                      |				ИЗ
                      |					ВТТоваров КАК ВТТоваров)) КАК ТоварыНаСкладахОстатки
                      |ГДЕ
                      |	ТоварыНаСкладахОстатки.КоличествоОстаток > 0
                      |
                      |СГРУППИРОВАТЬ ПО
                      |	ТоварыНаСкладахОстатки.Номенклатура,
                      |	ТоварыНаСкладахОстатки.Склад
                      |
                      |ОБЪЕДИНИТЬ ВСЕ
                      |
                      |ВЫБРАТЬ
                      |	ПартииТоваровОстатки.Номенклатура,
                      |	ПартииТоваровОстатки.Склад,
                      |	NULL,
                      |	СУММА(ПартииТоваровОстатки.КоличествоОстаток),
                      |	2,
                      |	ЗНАЧЕНИЕ(Перечисление.ТипПоставки.VMI),
                      |	ПрайсыПоставщиков.Ссылка
                      |ИЗ
                      |	РегистрНакопления.ПартииТоваров.Остатки(
                      |			&Период,
                      |			Номенклатура В
                      |					(ВЫБРАТЬ
                      |						ВТТоваров.Номенклатура КАК Номенклатура
                      |					ИЗ
                      |						ВТТоваров КАК ВТТоваров)
                      |				И Склад В
                      |					(ВЫБРАТЬ
                      |						Склады.Ссылка КАК Ссылка
                      |					ИЗ
                      |						Справочник.Склады КАК Склады
                      |					ГДЕ
                      |						Склады.СкладVMI = ИСТИНА
                      |						И Склады.ФизическийСклад = &Склад)
                      |				И СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.ПринятыйНаОтветХранение)) КАК ПартииТоваровОстатки
                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрайсыПоставщиков КАК ПрайсыПоставщиков
                      |		ПО (ПрайсыПоставщиков.Склад = &Склад)
                      |			И ((ВЫРАЗИТЬ(ПрайсыПоставщиков.Владелец КАК Справочник.ТорговыеТочки)) = ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка)
                      |ГДЕ
                      |	ПартииТоваровОстатки.КоличествоОстаток > 0
                      |
                      |СГРУППИРОВАТЬ ПО
                      |	ПартииТоваровОстатки.Номенклатура,
                      |	ПрайсыПоставщиков.Ссылка,
                      |	ПартииТоваровОстатки.Склад
                      |
                      |УПОРЯДОЧИТЬ ПО
                      |	Номенклатура,
                      |	Приоритет"	);

Запрос.УстановитьПараметр("ТаблицаТоваров",ТаблицаТоваров);
запрос.УстановитьПараметр("Склад",Склад);

Результат = запрос.Выполнить();
Возврат Результат.Выгрузить();
	
	
	
Конецфункции


Функция ПолучитьРаспределенныеТаблицыТоваровпоСкладам(ТаблицаТоваров,ТаблицаОстатков)
	ТаблицаСток = ПолучитьПустуюТаблицуТоваровЗаявки();
	ТаблицаVMI  = ПолучитьПустуюТаблицуТоваровЗаявки();
	
	//Для каждого СтрокаТоваров из ТаблицаТоваров цикл
	//	 СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(новый Структура("Номенклатура",СтрокаТоваров.Номенклатура));
	//	 КоличествоКРаспределению = СтрокаТоваров.Количество;		 
	//	 Для каждого СтрокаОстатка из СтрокиОстатков цикл 			 	 
	//		Если СтрокаОстатка.Количество > = КоличествоКРаспределению тогда 
	//			 
	//			 
	//		КонецЕсли;	 
	//		
	//	КонецЦикла;		
	//	
	//КонецЦикла;
	
	
КонецФункции	
	
	
#КонецОбласти


#Область Прочее
Функция ПолучитьПустуюТаблицуТоваровЗаявки()
	Возврат Документы.ЗаявкаПокупателя.ПустаяСсылка().Товары.ВыгрузитьКолонки();	
КонецФункции	

	
#КонецОбласти