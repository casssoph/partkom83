﻿

Процедура КонтрольВыгрузкиРТУВТоплог(Период,Событие)   Экспорт
	//Период - число дней от текущей даты	
	Если НЕ  Типзнч(Период) = Тип("Число") или не ЗначениеЗаполнено(Период) тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю("Не корректно заполнен период");
	КонецЕсли;	
	
	ВыборкаДанных  = ПолучитьОшибкиВыгрузкиРТУ(Период,Событие);
	Пока ВыборкаДанных.Следующий() цикл 
	КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(ВыборкаДанных.Документ,Событие,ВыборкаДанных.ОписаниеОшибки +"("+ВыборкаДанных.ТипДоставки+")");		
	КонецЦикла;	
	
КонецПроцедуры	


Функция ПолучитьОшибкиВыгрузкиРТУ(Период,Событие)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияТоваровУслуг.Ссылка КАК Документ,
		|	ВЫБОР
		|		КОГДА ИсторияОбменовПоОбъектам.Ошибка
		|			ТОГДА ""При выгрузке произошли Ошибки"" + ИсторияОбменовПоОбъектам.ТекстОшибки
		|		ИНАЧЕ ""Документ не выгружен""
		|	КОНЕЦ КАК ОписаниеОшибки,
		|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.ТипДоставки) КАК ТипДоставки
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияОбменовПоОбъектам КАК ИсторияОбменовПоОбъектам
		|		ПО РеализацияТоваровУслуг.Ссылка = ИсторияОбменовПоОбъектам.Объект
		|			И (ИсторияОбменовПоОбъектам.Узел = &УзелТоплог)
		|			И (ИсторияОбменовПоОбъектам.Исходящее = ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|		ПО РеализацияТоваровУслуг.Ссылка = РеализацияТоваровУслугТовары.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КритическиеСобытияСистемы КАК КритическиеСобытияСистемы
		|		ПО РеализацияТоваровУслуг.Ссылка = КритическиеСобытияСистемы.ИсточникКритическогоСобытия
		|			И (КритическиеСобытияСистемы.Событие = &Событие)
		|ГДЕ
		|	(ИсторияОбменовПоОбъектам.Объект ЕСТЬ NULL
		|			ИЛИ ИсторияОбменовПоОбъектам.Ошибка)
		|	И РеализацияТоваровУслуг.Проведен = ИСТИНА
		|	И РеализацияТоваровУслуг.ЭтоМФП = ЛОЖЬ
		|	И РеализацияТоваровУслуг.флНеВыгружатьВТопЛог = ЛОЖЬ
		|	И РеализацияТоваровУслуг.Дата >= &НачалоПериода
		|	И НЕ РеализацияТоваровУслуг.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугНовый)
		|	И РеализацияТоваровУслуг.Дата <= &КонецПериода
		|	И РеализацияТоваровУслуг.Склад.ОбменСTopLog = ИСТИНА
		|	И КритическиеСобытияСистемы.ИсточникКритическогоСобытия ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДата() - 600);  //10 минут временой лаг на выгрузку в топлог
	Запрос.УстановитьПараметр("НачалоПериода", ТекущаяДата() - Период * 24*60*60);
	Запрос.УстановитьПараметр("УзелТоплог",    ОбменССайтомСервер.УзелПланаОбмена("ОбменПартКом83_TopLog_РТУ",Ложь));
	Запрос.УстановитьПараметр("Событие", Событие);

	РезультатЗапроса = Запрос.Выполнить();
	
	
 Возврат РезультатЗапроса.Выбрать();
		
КонецФункции	

Процедура КонтрольСтатусовРТУ(Период,Событие) Экспорт
	 Если Типзнч(Период) = Тип("Число") или не ЗначениеЗаполнено(Период) тогда 
		  ПериодОбработки = НачалоГода(ТекущаяДата());
	иначе
		ПериодОбработки  = Период.ДатаНачала;
	 КонецЕсли;	
	
	ВыборкаДанных  = ПолучитьОшибкиСтатусовРТУ(ПериодОбработки,Событие);
	Пока ВыборкаДанных.Следующий() цикл 
	СообщениеОшибки = "Не обработан статус у РТУ "+ СокрЛП(ВыборкаДанных.Документ) +"("+ВыборкаДанных.Контрагент +")" + ", тек.стататус: " + ВыборкаДанных.СтатусДокумента;  
	КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(ВыборкаДанных.Документ,Событие,СообщениеОшибки);		
	КонецЦикла;	
	

КонецПроцедуры	

Функция ПолучитьОшибкиСтатусовРТУ(Период,Событие)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеализацияТоваровУслуг.Ссылка КАК Документ,
		|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.СтатусДокумента) КАК СтатусДокумента,
		|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Контрагент) КАК Контрагент
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
		|		ПО РеализацияТоваровУслуг.ТорговаяТочка = УчетныеЗаписиСайта.Владелец
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КритическиеСобытияСистемы КАК КритическиеСобытияСистемы
		|		ПО РеализацияТоваровУслуг.Ссылка = КритическиеСобытияСистемы.ИсточникКритическогоСобытия
		|			И (КритическиеСобытияСистемы.Событие = &Событие)
		|ГДЕ
		|	РеализацияТоваровУслуг.Проведен = ИСТИНА
		|	И НЕ РеализацияТоваровУслуг.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугОтгружен)
		|	И РеализацияТоваровУслуг.ЭтоМФП = ЛОЖЬ
		|	И РеализацияТоваровУслуг.Дата > &Период
		|	И ВЫБОР
		|			КОГДА УчетныеЗаписиСайта.Ссылка ЕСТЬ NULL
		|				ТОГДА РеализацияТоваровУслуг.Дата <= ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВЫРАЗИТЬ(&ТекущаяДата КАК ДАТА), ДЕНЬ), ДЕНЬ, -7)
		|			ИНАЧЕ РеализацияТоваровУслуг.Дата <= ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВЫРАЗИТЬ(&ТекущаяДата КАК ДАТА), ДЕНЬ), ДЕНЬ, -1)
		|		КОНЕЦ
		|	И РеализацияТоваровУслуг.флНеВыгружатьВТопЛог = ЛОЖЬ
		|	И КритическиеСобытияСистемы.ИсточникКритическогоСобытия ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Период",Период);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("Событие", Событие);

	РезультатЗапроса = Запрос.Выполнить();
	
 Возврат РезультатЗапроса.Выбрать();
		

	
КонецФункции	

Процедура КонтрольВыпискиVMIбезРасписания(Период,Событие) Экспорт
	Если Типзнч(Период) = Тип("Число") или не ЗначениеЗаполнено(Период) тогда 
		 Период = новый СтандартныйПериод(ВариантСтандартногоПериода.Вчера);
	КонецЕсли;
	
	ВыборкаДанных  = ПолучитьОшибкиВыпискиVMIбезРасписания(Период.ДатаНачала,Период.ДатаОкончания,Событие);
	Пока ВыборкаДанных.Следующий() цикл 
	СообщениеОшибки = "Не сформировано расписание для отчетов VMI "+ СокрЛП(ВыборкаДанных.Документ) +"("+ВыборкаДанных.Контрагент +")" + ", по орг.: " + ВыборкаДанных.Организация +" и скл.:" + ВыборкаДанных.Склад  ;  
	КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(ВыборкаДанных.Документ,Событие,СообщениеОшибки);		
	КонецЦикла;	
	

 КонецПроцедуры
 
 
 Функция ПолучитьОшибкиВыпискиVMIбезРасписания(ДатаНачала,ДатаОкончания,Событие)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПартииТоваровVMI.Регистратор КАК Документ,
		|	ПРЕДСТАВЛЕНИЕ(ПартииТоваровVMI.Склад),
		|	ПРЕДСТАВЛЕНИЕ(ПартииТоваровVMI.ДоговорКонтрагента.Организация) КАК Организация,
		|	ПРЕДСТАВЛЕНИЕ(ПартииТоваровVMI.ДоговорКонтрагента.Владелец) КАК Контрагент
		|ИЗ
		|	РегистрНакопления.ПартииТоваровVMI КАК ПартииТоваровVMI
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасписанияОтчетовПоставщикамVMI КАК РасписанияОтчетовПоставщикамVMI
		|		ПО ПартииТоваровVMI.ДоговорКонтрагента.Организация = РасписанияОтчетовПоставщикамVMI.Организация
		|			И ПартииТоваровVMI.Склад = РасписанияОтчетовПоставщикамVMI.Склад
		|			И ПартииТоваровVMI.ДоговорКонтрагента.Владелец = РасписанияОтчетовПоставщикамVMI.ПрайсПоставщика.Владелец
		|			И (РасписанияОтчетовПоставщикамVMI.Используется = ИСТИНА)
		|			И (РасписанияОтчетовПоставщикамVMI.НачальнаяДата < &НачалоПериода)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КритическиеСобытияСистемы КАК КритическиеСобытияСистемы
		|		ПО ПартииТоваровVMI.Регистратор = КритическиеСобытияСистемы.ИсточникКритическогоСобытия
		|			И (КритическиеСобытияСистемы.Событие = &Событие)
		|ГДЕ
		|	ПартииТоваровVMI.Период >= &НачалоПериода
		|	И ПартииТоваровVMI.Период <= &КонецПериода
		|	И ПартииТоваровVMI.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И ПартииТоваровVMI.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
		|	И РасписанияОтчетовПоставщикамVMI.ПрайсПоставщика ЕСТЬ NULL
		|	И ПартииТоваровVMI.ДоговорКонтрагента.СлужебныйДоговор = ЛОЖЬ
		|	И ПартииТоваровVMI.ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ОтветХранение)
		|	И ПартииТоваровVMI.ДоговорКонтрагента.ПометкаУдаления = ЛОЖЬ
		|	И КритическиеСобытияСистемы.ИсточникКритическогоСобытия ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("КонецПериода", ДатаОкончания);
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("Событие", Событие);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	возврат РезультатЗапроса.Выбрать();

КонецФункции	 
	