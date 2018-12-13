﻿
#Область  СостояниеЗаявокЗаказов

Функция СтрокаЗаявкиЗакрыта(СтрокаЗаявки,МоментВремемени = Неопределено) Экспорт 
	Остаток = РегистрыНакопления.ЗаявкиПокупателей.Остатки(МоментВремемени,Новый Структура("СтрокаЗаявки",СтрокаЗаявки),"СтрокаЗаявки","Количество");
	Если Остаток.Количество() тогда 
		Возврат Ложь;
	иначе 
		Возврат Истина;
	КонецЕсли;
	
КонецФункции	

Функция ТекущийСтатусЗаявкиЗаказа(ДокументСсылка,ДатаОтбора = Неопределено) Экспорт 
	Если ДатаОтбора = Неопределено тогда 
		ДатаОтбора = ТекущаяДата();
	КонецЕсли;	
	
	ТабСреза = РегистрыСведений.ДокументыКорректировок.СрезПоследних(ДатаОтбора,новый Структура("Документ",ДокументСсылка));	
	Если ТабСреза.Количество() тогда 
		Возврат  ТабСреза[0].СтатусДокумента;
	иначе 
		Возврат  ДокументСсылка.СтатусДокумента;
	КонецЕсли;
	
Конецфункции 	

Функция ЗаявкаЗакрыта(ДокументСсылка)  Экспорт
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

#КонецОбласти

#Область Прочее
Функция РегионФилиала(Филиал) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регионы.Ссылка
		|ИЗ
		|	Справочник.Регионы КАК Регионы
		|ГДЕ
		|	Регионы.Филиал = &Филиал";
	
	Запрос.УстановитьПараметр("Филиал", Филиал);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() тогда 
		возврат Справочники.Регионы.ПустаяСсылка();
	Конецесли;	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();	
	Возврат ВыборкаДетальныеЗаписи.Ссылка
КонецФункции	

Функция КонтрагентЗакрываетсяБезРазмещения(Контрагент) Экспорт 
	   Наб  = РегистрыСведений._Временно_КонтрагентыЗакрытияПополненияБезРазмещения.Получить(новый Структура("Контрагент",Контрагент));
	   Если наб.Количество() тогда 
		   Возврат Истина;
	   Иначе 
		   Возврат Ложь;
		КонецЕсли;	   
	
КонецФункции	

Функция ЭтоСкладПриемки(Склад) Экспорт
ЗапросСклада = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
                            |	Склады.Ссылка
                            |ИЗ
                            |	Справочник.Склады КАК Склады
                            |ГДЕ
                            |	Склады.СкладПриемки = &Склад");
ЗапросСклада.УстановитьПараметр("Склад",Склад);
Результат = ЗапросСклада.Выполнить();
Возврат Не Результат.Пустой();
	
Конецфункции	
	
Функция ДокументВыгруженВТоплог(ДокументСсылка) Экспорт
УстановитьПривилегированныйРежим(Истина);

Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсторияОбменаСТопЛогПоОбъектам.Объект
		|ИЗ
		|	РегистрСведений.ИсторияОбменаСТопЛогПоОбъектам КАК ИсторияОбменаСТопЛогПоОбъектам
		|ГДЕ
		|	ИсторияОбменаСТопЛогПоОбъектам.Объект = &ДокументСсылка
		|	И ИсторияОбменаСТопЛогПоОбъектам.Исходящее = ИСТИНА";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
Возврат не РезультатЗапроса.Пустой();	

КонецФункции

#КонецОбласти
