﻿Функция ПолучитьВидДня(Дата, Календарь = Неопределено) Экспорт
	
	Если Календарь = Неопределено Тогда
		Календарь = Справочники.Календари.Регламентированный
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДатыКалендарей.ВидДня
	                      |ИЗ
	                      |	РегистрСведений.ДатыКалендарей КАК ДатыКалендарей
	                      |ГДЕ
	                      |	ДатыКалендарей.Календарь = &Календарь
	                      |	И ДатыКалендарей.ДатаКалендаря = &ДатаКалендаря");
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("ДатаКалендаря", Дата);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ВидДня;
	КонецЕсли;
	
КонецФункции

Функция ДатаБлижайшегоРабочегоДня(График, НачальнаяДата, ПолучатьПредшествующие = Ложь) Экспорт
	
	БлижайшаяДата = Неопределено;
	
	НачальныеДаты = Новый Массив;
	НачальныеДаты.Добавить(НачальнаяДата);
	
	ВызыватьИсключение = Ложь;
	ИгнорироватьНезаполненностьГрафика = Истина;
	
	ДатыБлижайшихРабочихДней =  ДатыБлижайшихРабочихДней(График, НачальныеДаты, ПолучатьПредшествующие, ВызыватьИсключение,	ИгнорироватьНезаполненностьГрафика);
	
	Если ДатыБлижайшихРабочихДней <> Неопределено Тогда
		тек = Новый Соответствие;
		БлижайшаяДата = тек.Получить(НачальнаяДата);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(БлижайшаяДата) Тогда
		Возврат НачальнаяДата;
	Иначе
		Возврат БлижайшаяДата;
	КонецЕсли;	 
	
КонецФункции

// Определяет для каждой даты дату ближайшего к ней рабочего дня.
//
//	Параметры:
//	  График	- СправочникСсылка.Календари, СправочникСсылка.ПроизводственныеКалендари - график или 
//                    производственный календарь, который необходимо использовать для расчета.
//	  НачальныеДаты 				- Массив - массив дат (Дата).
//	  ПолучатьПредшествующие		- Булево - способ получения ближайшей даты:
//										если Истина - определяются рабочие даты, предшествующие переданным в параметре НачальныеДаты, 
//										если Ложь - получаются даты не ранее начальной даты.
//	  ВызыватьИсключение - Булево - если Истина, вызвать исключение в случае незаполненного графика.
//	  ИгнорироватьНезаполненностьГрафика - Булево - если Истина, то в любом случае будет возвращено соответствие. 
//										Начальные даты, для которых не будет значений из-за незаполненности графика, включены не будут.
//
//	Возвращаемое значение:
//	  Соответствие, Неопределено - соответствие, где ключ - дата из переданного массива, 
//									значение - ближайшая к ней рабочая дата (если передана рабочая дата, то она же и возвращается).
//									Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ДатыБлижайшихРабочихДней(График, НачальныеДаты, ПолучатьПредшествующие = Ложь, ВызыватьИсключение = Истина, 
	ИгнорироватьНезаполненностьГрафика = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(График) Тогда
		Если ВызыватьИсключение Тогда
			ВызватьИсключение НСтр("ru = 'Не указан график работы или производственный календарь.'");
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстЗапросаВТ = "";
	ПерваяЧасть = Истина;
	Для Каждого НачальнаяДата Из НачальныеДаты Цикл
		Если Не ЗначениеЗаполнено(НачальнаяДата) Тогда
			Продолжить;
		КонецЕсли;
		Если Не ПерваяЧасть Тогда
			ТекстЗапросаВТ = ТекстЗапросаВТ + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		ТекстЗапросаВТ = ТекстЗапросаВТ + "
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ(" + Формат(НачальнаяДата, "ДФ=гггг,ММ,дд") + ")";
		Если ПерваяЧасть Тогда
			ТекстЗапросаВТ = ТекстЗапросаВТ + " КАК Дата 
			|ПОМЕСТИТЬ НачальныеДаты
			|";
		КонецЕсли;
		ПерваяЧасть = Ложь;
	КонецЦикла;

	Если ПустаяСтрока(ТекстЗапросаВТ) Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапросаВТ);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НачальныеДаты.Дата,
	|	%Функция%(ДатыКалендаря.Дата) КАК БлижайшаяДата
	|ИЗ
	|	НачальныеДаты КАК НачальныеДаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыКалендарей КАК ДатыКалендаря
	|		ПО (ДатыКалендаря.ДатаКалендаря %ЗнакУсловия% НачальныеДаты.Дата)
	|			И (ДатыКалендаря.Календарь = &График)
	|			И (ДатыКалендаря.ВидДня В (
	|			ЗНАЧЕНИЕ(Перечисление.ВидыДнейКалендаря.Рабочий), 
	|			ЗНАЧЕНИЕ(Перечисление.ВидыДнейКалендаря.Предпраздничный)
	|			))
	|
	|СГРУППИРОВАТЬ ПО
	|	НачальныеДаты.Дата";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Функция%", 				?(ПолучатьПредшествующие, "МАКСИМУМ", "МИНИМУМ"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЗнакУсловия%", 			?(ПолучатьПредшествующие, "<=", ">="));
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("График", График);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДатыРабочихДней = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.БлижайшаяДата) Тогда
			ДатыРабочихДней.Вставить(Выборка.Дата, Выборка.БлижайшаяДата);
		Иначе 
			Если ИгнорироватьНезаполненностьГрафика Тогда
				Продолжить;
			КонецЕсли;
			Если ВызыватьИсключение Тогда
				ТекстСообщения = НСтр("ru = 'Невозможно определить ближайшую рабочую дату для даты %1, возможно, график работы не заполнен.'");
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Выборка.Дата, "ДЛФ=D"));
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДатыРабочихДней;
	
КонецФункции

