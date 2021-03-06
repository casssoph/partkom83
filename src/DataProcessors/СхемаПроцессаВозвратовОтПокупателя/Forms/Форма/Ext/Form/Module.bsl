﻿#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриОткрытииНаСервере()
	ОбновитьСхему();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветВходящего = Новый Цвет(64, 94, 172);
	ЦветИсходящего = Новый Цвет(51, 153, 0);
	ЦветОшибки = Новый Цвет(255, 51, 0);
	
	Если Параметры.Свойство("АктРассмотренияВозврата") Тогда
		АктРассмотренияВозврата = Параметры.АктРассмотренияВозврата;
	КонецЕсли;
	
	Элементы.ТекстПодсказкиПоАРВ.Видимость = ЗначениеЗаполнено(АктРассмотренияВозврата);
	
	РазрешитьРучноеРедактированиеАРВ = ВозвратыОтПокупателяСервер.РазрешитьРучноеРедактированиеАРВ();
	
	Элементы.ГрафСхема.ТолькоПросмотр 			  	= НЕ РазрешитьРучноеРедактированиеАРВ;
	Элементы.ФормаСохранитьИзменения.Видимость  	= РазрешитьРучноеРедактированиеАРВ;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Возвраты(Команда)
	ВозвратыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВозвратыНаСервере()
	
	ОбновитьСхему();

КонецПроцедуры

&НаКлиенте
Процедура ГрафСхемаВыбор(Элемент)
	
	ГрафСхемаXDTO = СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
	
	Попытка
		ОбъектСхемы = РаботаСГС.НайтиОбъектСхемы(ГрафСхемаXDTO, Элемент.ТекущийЭлемент.Имя);
		
		Если ОбъектСхемы <> Неопределено Тогда
			
			Этап = Неопределено; 
			Если ИдентификаторыЭтапов.Свойство("_"+ОбъектСхемы.itemId, Этап) Тогда
				ОткрытьЗначение(Этап);
			КонецЕсли;
			
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура АктРассмотренияВозвратаПриИзменении(Элемент)
	АктРассмотренияВозвратаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура АктРассмотренияВозвратаПриИзмененииНаСервере()
	
	ОбновитьСхему();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафСхемаПриАктивизации(Элемент)

	Попытка
		ИмяЭлемента = Элемент.ТекущийЭлемент.Имя;
	Исключение
		ИмяЭлемента = "";
	КонецПопытки;
	ГрафСхемаПриАктивизацииНаСервере(ИмяЭлемента);
	
КонецПроцедуры

&НаСервере
Процедура ГрафСхемаПриАктивизацииНаСервере(ИмяЭлемента)
	
	Если Не ЗначениеЗаполнено(АктРассмотренияВозврата) Тогда
		
		ГрафСхемаXDTO = СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
		
		ОбъектСхемы = РаботаСГС.НайтиОбъектСхемы(ГрафСхемаXDTO, ИмяЭлемента);
		
		Если ИмяЭлемента  = "" Тогда
			ВозвратыНаСервере();
		Иначе
			ВыделитьЭтап(ГрафСхемаXDTO, ОбъектСхемы);
		КонецЕсли;
		
		ГрафСхема = СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ВыводСхемы

&НаСервере
Процедура ВывестиСхему()
	
	ТочечнаяЛиния = Новый Линия(ТипСоединительнойЛинии.Точечная,1);
	
	ГрафСхемаXDTO = СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
	
	ГрафСхемаXDTO.item.Очистить();
	
	Вершины = Вершины();
	Ребра 	= ВзаимосвязиЭтапа();	
	
	ИдентификаторыЭтапов = Новый Структура;
	
	Для Каждого Вершина Из Вершины Цикл
		
		//НовОбъект=РаботаСГС.НовыйОбъектОбработка(ГрафСхемаXDTO,Вершина.Имя,Вершина.Имя,Вершина.Лево,Вершина.Верх,100,60);
		
		Если  Вершина.Этап = Справочники.СтатусыДокументов.АРВ_Новый Тогда
			НовОбъект=РаботаСГС.НовыйОбъектСтарт(ГрафСхемаXDTO,Вершина.Имя, Вершина.Имя,Вершина.Лево,Вершина.Верх,100,60);
		ИначеЕсли Вершина.Этап = Справочники.СтатусыДокументов.АРВ_РаботаЗавершена Тогда
			НовОбъект=РаботаСГС.НовыйОбъектЗавершение(ГрафСхемаXDTO,Вершина.Имя, Вершина.Имя,Вершина.Лево,Вершина.Верх,100,60);
		Иначе
			НовОбъект=РаботаСГС.НовыйОбъектДействие(ГрафСхемаXDTO,Вершина.Имя, Вершина.Имя,Вершина.Лево,Вершина.Верх,100,60,,,Вершина.Ответственный);
		КонецЕсли;
		
		ГрафСхемаXDTO.item.Добавить(НовОбъект);
		
		ИдентификаторыЭтапов.Вставить("_"+НовОбъект.itemId, Вершина.Этап);
	КонецЦикла;
	
	Для Каждого Ребро Из Ребра Цикл
		
		ЗаголовокЛинии = ?(Ребро.Автоматически, "{А}", Неопределено);
		
		НовОбъект = РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,Ребро.Имя1,Ребро.Имя2,Ребро.Направление1,Ребро.Направление2,,,,,,ЗаголовокЛинии);
		ИдентификаторыЭтапов.Вставить("_"+НовОбъект.itemId, Ребро.Ссылка);
		
	КонецЦикла;
	
	ГрафСхема=СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
	
	ГрафСхема.ИспользоватьСетку = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСхему()
	
	ВывестиСхему();
	
	ВыделитьСхемуПоАкту();
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьЭтап(ГрафСхемаXDTO, ОбъектСхемыСтатус, ВыделятьВходящие = Истина, ВыделятьИсходящие = Истина)
	
	//ОбъектСхемыСтатус = статус документа, или объект схемы
	
	Если ТипЗнч(ОбъектСхемыСтатус) = Тип("СправочникСсылка.СтатусыДокументов") Тогда
		ИдентификаторЭтапа = ИдентификаторЭтапа(ОбъектСхемыСтатус);
		ОбъектСхемы = РаботаСГС.НайтиОбъектСхемы(ГрафСхемаXDTO, число(ИдентификаторЭтапа));  
		Этап = ОбъектСхемыСтатус;
	Иначе
		ОбъектСхемы = ОбъектСхемыСтатус;	
		Этап = ИдентификаторыЭтапов["_"+ОбъектСхемы.itemId];
	КонецЕсли;
	
	Если ТипЗнч(Этап) = Тип("СправочникСсылка.СтатусыДокументов") Тогда
		
		ОбъектСхемы.lineColor 	= ЦветВходящего;
		ОбъектСхемы.border		= СериализаторXDTO.ЗаписатьXDTO(новый линия(ТипСоединительнойЛинии.Сплошная,3));
		
		Если ВыделятьВходящие Тогда
			Ребра = ВзаимосвязиЭтапа(Этап, 1);
			ВыделитьРебраЦветом(ГрафСхемаXDTO, Ребра, ЦветВходящего);
		КонецЕсли;
		Если ВыделятьИсходящие Тогда
			Ребра = ВзаимосвязиЭтапа(Этап, 2);
			ВыделитьРебраЦветом(ГрафСхемаXDTO, Ребра, ЦветИсходящего);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьРебраЦветом(ГрафСхемаXDTO, Ребра, Цвет)
	
	Для каждого Ребро Из Ребра Цикл
		
		Для каждого КлючЗачение Из  ИдентификаторыЭтапов Цикл
			Если ТипЗнч(КлючЗачение.Значение) = Тип("СправочникСсылка.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя")
				И  КлючЗачение.Значение = Ребро.Ссылка Тогда
				
				ВыделитьРеброЦветом(ГрафСхемаXDTO, Ребро.Ссылка, Цвет);
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьРеброЦветом(ГрафСхемаXDTO, Ребро, Цвет)
	
	ИД = ИдентификаторЭтапа(Ребро);
	//ИД = СтрЗаменить(КлючЗачение.Ключ, "_", "");
	
	Если ИД <> Неопределено Тогда
		ОбъектСхемы = РаботаСГС.НайтиОбъектСхемы(ГрафСхемаXDTO, число(ИД));
		
		ОбъектСхемы.Border 		= СериализаторXDTO.ЗаписатьXDTO(новый линия(ТипСоединительнойЛинии.Сплошная,3));
		ОбъектСхемы.lineColor 	= Цвет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьСхемуПоАкту()
	
	Элементы.ТекстПодсказкиПоАРВ.Видимость = ЗначениеЗаполнено(АктРассмотренияВозврата);

	Если НЕ ЗначениеЗаполнено(АктРассмотренияВозврата) Тогда
		Возврат;
	КонецЕсли;
	
	Статус = АктРассмотренияВозврата.СтатусДокумента;
	ДокументОбъект = АктРассмотренияВозврата.ПолучитьОбъект();
	
	ГрафСхемаXDTO = СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
	
	ВыделитьЭтап(ГрафСхемаXDTO, Статус, Ложь, Ложь);
	
	СписокКВыполнению = Справочники.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ДоступныеВзаимосвязиТекущегоСтатуса(Статус);
	
	Элементы.ТекстПодсказкиПоАРВ.Заголовок = "";
	Для каждого ЭлСписка Из СписокКВыполнению Цикл
		
		ТекстОшибки = "";
		Если ВозвратыОтПокупателяСервер.УсловияКомандыВыполнены(ЭлСписка.Значение, ДокументОбъект, ТекстОшибки, Ложь,) Тогда
			ВыделитьРеброЦветом(ГрафСхемаXDTO, ЭлСписка.Значение, ЦветИсходящего);
			ТекстПодсказкиПоАРВ = ТекстПодсказкиПоАРВ + ЭлСписка.Значение+": Переход разрешен"+Символы.ПС+Символы.ПС
		Иначе
			ВыделитьРеброЦветом(ГрафСхемаXDTO, ЭлСписка.Значение, ЦветОшибки);
			ТекстПодсказкиПоАРВ = ТекстПодсказкиПоАРВ + ТекстОшибки+Символы.ПС+Символы.ПС;
		КонецЕсли;	
		
	КонецЦикла;

	Элементы.ТекстПодсказкиПоАРВ.Заголовок = ТекстПодсказкиПоАРВ;
	
	ГрафСхема = СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
	
КонецПроцедуры

Функция ИдентификаторЭтапа(Этап)
	
	Для каждого КлючЗачение Из  ИдентификаторыЭтапов Цикл
		Если ТипЗнч(Этап) = ТипЗнч(КлючЗачение.Значение) 
			И Этап = КлючЗачение.Значение Тогда
			ИД = СтрЗаменить(КлючЗачение.Ключ, "_", "");
			Возврат ИД;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ВзаимосвязиЭтапа(Этап = Неопределено, Тип = 0)
	
	//Тип 0 - все, 1 - входящие, 2 - исходящие
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка.Автоматически КАК Автоматически,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус.Код КАК Код1,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус КАК Этап1,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус.Наименование КАК Имя1,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Код КАК Код2,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус КАК Этап2,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Наименование КАК Имя2,
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Направление1, 4) КАК Направление1,
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Направление2, 2) КАК Направление2
	|ИЗ
	|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЭтаповСхемыПроцессаВозвратов КАК ПараметрыЭтаповСхемыПроцессаВозвратов
	|		ПО (ПараметрыЭтаповСхемыПроцессаВозвратов.Объект = ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка)
	|ГДЕ
	|	НЕ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ПометкаУдаления
	|				И ((ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = &ТекущийСтатус
	|					ИЛИ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус = &СледующийСтатус)
	|			ИЛИ &ВсеЭтапы)";
	
	Запрос.УстановитьПараметр("ТекущийСтатус", Этап);
	Запрос.УстановитьПараметр("СледующийСтатус", Этап);
	Если Тип = 1 Тогда
		Запрос.УстановитьПараметр("ТекущийСтатус", Неопределено);
	ИначеЕсли Тип = 2 Тогда
		Запрос.УстановитьПараметр("СледующийСтатус", Неопределено);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВсеЭтапы", Не ЗначениеЗаполнено(Этап));
	
	РезультатЗапроса = Запрос.Выполнить();
	Ребра = РезультатЗапроса.Выгрузить();
	
	Возврат Ребра; 	
	
КонецФункции

&НаСервере
Функция Вершины()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	isnull(ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус.Ответственный.Наименование, """") КАК Ответственный,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус.Код КАК Код,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус КАК Этап,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус.Наименование КАК Имя,
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Лево, 1) КАК Лево,
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Верх, 1) КАК Верх
	|ИЗ
	|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЭтаповСхемыПроцессаВозвратов КАК ПараметрыЭтаповСхемыПроцессаВозвратов
	|		ПО (ПараметрыЭтаповСхемыПроцессаВозвратов.Объект = ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус)
	|ГДЕ
	|	не ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ 
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	isnull(ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Ответственный.Наименование, """") КАК Ответственный,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Код,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус,
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Наименование,
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Лево, 1),
	|	ЕСТЬNULL(ПараметрыЭтаповСхемыПроцессаВозвратов.Верх, 1)
	|ИЗ
	|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЭтаповСхемыПроцессаВозвратов КАК ПараметрыЭтаповСхемыПроцессаВозвратов
	|		ПО (ПараметрыЭтаповСхемыПроцессаВозвратов.Объект = ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус)
	|ГДЕ
	|	не ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Родитель", Справочники.СтатусыДокументов.АктРассмотренияВозврата);
	РезультатЗапроса = Запрос.Выполнить();
	Вершины = РезультатЗапроса.Выгрузить();
	
	Возврат Вершины;
	
КонецФункции

#КонецОбласти

#Область Настройки

&НаСервере
Процедура СохранитьИзмененияНаСервере()
	
	ГрафСхемаXDTO = СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);

	Для каждого ЭЛГС ИЗ ГрафСхема.ЭлементыГрафическойСхемы Цикл
		
		ОбъектСхемы = РаботаСГС.НайтиОбъектСхемы(ГрафСхемаXDTO, ЭЛГС.Имя);
		
		Этап = Неопределено;
		Если ИдентификаторыЭтапов.Свойство("_"+ОбъектСхемы.itemId, Этап) Тогда
			
			Если ТипЗнч(ЭЛГС) = Тип("ЭлементГрафическойСхемыСоединительнаяЛиния") Тогда
				
				РегистрыСведений.ПараметрыЭтаповСхемыПроцессаВозвратов.Добавить(
				Этап,  Новый Структура("Направление1,Направление2",ОбъектСхемы.portIndexFrom, ОбъектСхемы.portIndexTo));	
				
			Иначе
				РегистрыСведений.ПараметрыЭтаповСхемыПроцессаВозвратов.Добавить(
				Этап,  Новый Структура("Лево,Верх",ЭЛГС.Лево, ЭЛГС.Верх));	
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	СохранитьИзмененияНаСервере();
КонецПроцедуры

#КонецОбласти

//Примеры  

&НаКлиенте
Процедура Удалить(Команда)
	
	
	Если Элементы.ГрафСхема.ТекущийЭлемент<>Неопределено  Тогда   
	    ГрафСхемаXDTO=СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
		
		Список=ГрафСхемаXDTO.item;
		Для каждого эл Из ГрафСхемаXDTO.item Цикл   
			
			Если Элементы.ГрафСхема.ТекущийЭлемент.Имя=эл.itemCode Тогда   
				РаботаСГС.УдалитьОбъектСхемы(ГрафСхемаXDTO,эл.itemCode);
			КонецЕсли; 
		КонецЦикла; 
		ГрафСхема=СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
		
	КонецЕсли; 


КонецПроцедуры

&НаКлиенте
Процедура Пример(Команда)
	
	ТочечнаяЛиния=новый Линия(ТипСоединительнойЛинии.Точечная,1);
	
	ГрафСхемаXDTO=СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
	
	ГрафСхемаXDTO.item.Очистить();
	
	НовОбъект=РаботаСГС.НовыйОбъектСтарт(ГрафСхемаXDTO,"Старт"," ",100,20,80,60,WebЦвета.Золотой);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	
	НовОбъект=РаботаСГС.НовыйОбъектУсловие(ГрафСхемаXDTO,"Шестиугольник",,100,120,80,40,,ТочечнаяЛиния);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Старт","Шестиугольник",4,2,,,ТочечнаяЛиния);
	
	НовОбъект=РаботаСГС.НовыйОбъектДействие(ГрафСхемаXDTO,"Действие1",,240,40,80,60,WebЦвета.БледноБирюзовый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Шестиугольник","Действие1",3,1,,,новый Линия(ТипСоединительнойЛинии.ПунктирТочкаТочка,1));
	
	НовОбъект=РаботаСГС.НовыйОбъектОбработка(ГрафСхемаXDTO,"Обработка1",,240,140,80,60);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Шестиугольник","Обработка1",4,1);
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация","Входящие",ФигурыГрафическойСхемы.Папка,10,60,80,40);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Декорация","Шестиугольник",4,1,,,ТочечнаяЛиния,,СтильСтрелки.Нет);
	
	НовОбъект=РаботаСГС.НовыйОбъектРазделение(ГрафСхемаXDTO,"Треугольник1","",200,240,20,60,WebЦвета.Древесный);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Обработка1","Треугольник1",4,2);
	
	НовОбъект=РаботаСГС.НовыйОбъектСлияние(ГрафСхемаXDTO,"Треугольник2","",200,300,20,60,WebЦвета.Древесный);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация2","Это фигуры слияния и разделения",ФигурыГрафическойСхемы.СтрелкаВправо,10,260,180,80,WebЦвета.СветлоЖелтый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	
	НовОбъект=РаботаСГС.НовыйОбъектВложенныйПроцесс(ГрафСхемаXDTO,"Процесс",,100,440,100,60);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Треугольник2","Процесс",4,1);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Шестиугольник","Процесс",4,2);
	
	
	НовОбъект=РаботаСГС.НовыйОбъектВыборВарианта(ГрафСхемаXDTO,"Светофор",,260,400,100,60,WebЦвета.СветлоСерый);
	РаботаСГС.ДобавитьВариант(НовОбъект,"Красный","",WebЦвета.Красный);
	РаботаСГС.ДобавитьВариант(НовОбъект,"Желтый","",WebЦвета.Желтый);
	РаботаСГС.ДобавитьВариант(НовОбъект,"Зеленый","",WebЦвета.Зеленый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Процесс","Светофор",3,1,,1);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Обработка1","Светофор",3,2,,,ТочечнаяЛиния,СтильСтрелки.Незаполненная,СтильСтрелки.Незаполненная);
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Светофор","Светофор",1,3,3,3);
	
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация3","Линия может входить и выходить с любой стороны варианта",ФигурыГрафическойСхемы.СтрелкаВлево,380,480,220,80,WebЦвета.СветлоЖелтый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация4","Соединительные линии и стрелки могут быть разных типов",ФигурыГрафическойСхемы.СтрелкаВлево,340,280,220,80,WebЦвета.СветлоЖелтый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);
	
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация5","В фигуру могут входить и выходить несколько линий с любой стороны",ФигурыГрафическойСхемы.СтрелкаВлево,340,80,220,80,WebЦвета.СветлоЖелтый);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	
	
	
	НовОбъект=РаботаСГС.НовыйОбъектДекорация(ГрафСхемаXDTO,"Декорация6","Пример работы с объектами графической схемы
	|
	|Схема может использоваться не только для построения маршрута бизнес-процесса, но и для иллюстрации схем, структур подчиненности, ER-диаграмм и т.п.
	|",ФигурыГрафическойСхемы.СкобкиГоризонтальные,600,80,200,200);
	ГрафСхемаXDTO.item.Добавить(НовОбъект);	

	
	РаботаСГС.СоединитьОбъектыЛинией(ГрафСхемаXDTO,"Светофор","Декорация6",3,4,2,0);
	
	
	ГрафСхема=СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);

	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьВариант(Команда)
Если Элементы.ГрафСхема.ТекущийЭлемент<>Неопределено  Тогда   
	    ГрафСхемаXDTO=СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
		
		Список=ГрафСхемаXDTO.item;
		Для каждого эл Из ГрафСхемаXDTO.item Цикл   
			
			Если Элементы.ГрафСхема.ТекущийЭлемент.Имя=эл.itemCode Тогда   
				Если эл.itemType=КонстантыГС.ТипОбъектаВыборВарианта() Тогда   
					РаботаСГС.ВставитьВариант(ГрафСхемаXDTO,эл,0,"Вариант");
				КонецЕсли; 
				
			КонецЕсли; 
		КонецЦикла; 
		ГрафСхема=СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВариант(Команда)
	Если Элементы.ГрафСхема.ТекущийЭлемент<>Неопределено  Тогда   
	    ГрафСхемаXDTO=СериализаторXDTO.ЗаписатьXDTO(ГрафСхема);
		
		Список=ГрафСхемаXDTO.item;
		Для каждого эл Из ГрафСхемаXDTO.item Цикл   
			
			Если Элементы.ГрафСхема.ТекущийЭлемент.Имя=эл.itemCode Тогда   
				Если эл.itemType=КонстантыГС.ТипОбъектаВыборВарианта() Тогда   
					РаботаСГС.УдалитьВариант(ГрафСхемаXDTO,эл,0);
				КонецЕсли; 
				
			КонецЕсли; 
		КонецЦикла; 
		ГрафСхема=СериализаторXDTO.ПрочитатьXDTO(ГрафСхемаXDTO);
		
	КонецЕсли; 

КонецПроцедуры


