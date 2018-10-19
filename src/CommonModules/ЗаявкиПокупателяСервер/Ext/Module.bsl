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
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСостояниеСтрокПоДокументу(ДокументСсылка) Экспорт 
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") или 
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
Функция ДоступноеКоличествоПоЗаявкеКОтказу(СтрокаЗаявки,МоментВремениДокумента) Экспорт
СтрокаЗаявки = Справочники.ИдентификаторыСтрокЗаявок.СоздатьЭлемент();	
Если СтрокаЗаявки.ТипПоставки = Перечисления.ТипПоставки.ПополнениеСклада тогда 
Возврат ДоступноеКоличествоПоЗаявкеКОтказу_ПополнениеСклада(СтрокаЗаявки,МоментВремениДокумента);	
Иначеесли  СтрокаЗаявки.ТипПоставки = Перечисления.ТипПоставки.Сток тогда	
Возврат ДоступноеКоличествоПоЗаявкеКОтказу_Сток(СтрокаЗаявки,МоментВремениДокумента);		
КонецЕсли;	
КонецФункции	

Функция ДоступноеКоличествоПоЗаявкеКОтказу_ПополнениеСклада(СтрокаЗаявки,МоментВремениДокумента)
ЗапросКОтказу = новый Запрос;
ЗапросКОтказу.Текст = "ВЫБРАТЬ
                      |	ЗаявкиПокупателейОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОбороты.КоличествоПриход, 0) - ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) КАК ДоступныйОтказ
                      |ИЗ
                      |	РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов.Обороты(&МоментВремени, , , СтрокаЗаявки = &СтрокаЗаявки) КАК РазмещенияСтрокЗаказовОбороты
                      |		ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказовОбороты.СтрокаЗаявки
                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&МоментВремени, ) КАК ЗаказыПоставщикамОстатки
                      |		ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ЗаказыПоставщикамОстатки.СтрокаЗаявки
                      |			И (ЗаказыПоставщикамОстатки.КоличествоОстаток > 0)
                      |ГДЕ
                      |	ЗаявкиПокупателейОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОбороты.КоличествоПриход, 0) - ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) > 0";
ЗапросКОтказу.УстановитьПараметр("СтрокаЗаявки",СтрокаЗаявки);
ЗапросКОтказу.УстановитьПараметр("МоментВремени",новый Граница(МоментВремениДокумента,ВидГраницы.Исключая));
Результат = ЗапросКОтказу.Выполнить();
если Результат.Пустой() тогда 
	Возврат 0 
Иначе 
	Выбор = Результат.Выбрать();
	выбор.Следующий();
	возврат выбор.ДоступныйОтказ
КонецЕсли;	
	
	
КонецФункции	

Функция ДоступноеКоличествоПоЗаявкеКОтказу_Сток(СтрокаЗаявки,МоментВремениДокумента)
ЗапросКОтказу = новый Запрос;
ЗапросКОтказу.Текст = "ВЫБРАТЬ
                      |	ЗаявкиПокупателейОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОбороты.КоличествоПриход, 0) - ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) КАК ДоступныйОтказ
                      |ИЗ
                      |	РегистрНакопления.ЗаявкиПокупателей.Остатки(&МоментВремени, СтрокаЗаявки = &СтрокаЗаявки) КАК ЗаявкиПокупателейОстатки
                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов.Обороты(&МоментВремени, , , СтрокаЗаявки = &СтрокаЗаявки) КАК РазмещенияСтрокЗаказовОбороты
                      |		ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказовОбороты.СтрокаЗаявки
                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&МоментВремени, ) КАК ЗаказыПоставщикамОстатки
                      |		ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ЗаказыПоставщикамОстатки.СтрокаЗаявки
                      |			И (ЗаказыПоставщикамОстатки.КоличествоОстаток > 0)
                      |ГДЕ
                      |	ЗаявкиПокупателейОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОбороты.КоличествоПриход, 0) - ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) > 0";
ЗапросКОтказу.УстановитьПараметр("СтрокаЗаявки",СтрокаЗаявки);
ЗапросКОтказу.УстановитьПараметр("МоментВремени",новый Граница(МоментВремениДокумента,ВидГраницы.Исключая));
Результат = ЗапросКОтказу.Выполнить();
если Результат.Пустой() тогда 
	Возврат 0 
Иначе 
	Выбор = Результат.Выбрать();
	выбор.Следующий();
	возврат выбор.ДоступныйОтказ
КонецЕсли;	
	
	
КонецФункции	


Функция СтрокаЗаявкиЗакрыта(СтрокаЗаявки) Экспорт
	 Возврат   СтрокаЗаявки.СостояниеЗаявки = Справочники.СтатусыДокументов.ЗаявкаПокупателяЗакрыт;
	
КонецФункции	

#КонецОбласти