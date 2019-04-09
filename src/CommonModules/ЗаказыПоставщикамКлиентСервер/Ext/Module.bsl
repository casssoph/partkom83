﻿#Область РАзмещение_ПТУ_По_Заказам


// Процедура - Разместить документ поступления по заказам . Размещает и проводит оперативно Документ поступления
// Параметры:
//  ДокументПоступление	 - ДокументСсылка.ПоступлениеТоваров,ДокументОбъект.ПоступлениеТоваров	 -  Документ размещения
//  ПараметрыВыолнения	 - Структура - Параметры выполнения, если не заполнено берутся параметры по умолчанию :
//  СоздаватьВиртуальныеСтроки     - Булево- Если Равно истина то на все не распределившееся число будут созданы вирт строки
//ЗаказРавенПриходу  			 - Булево- Если равно истине то все Позиции будутПроставлены к ОТказу
//ЗаказРаспределения            - ССылка - Заказ распределения, если заказ равен приходу, в остальных случаях не надо заполнять
//СписокЗаказовРаспределения    - Массив - Если заполнен, ПТУ будет распределена по данным заказам
//МассивОтбораНоменклатуры	      - Массив-  Если заполнено то будет произведен отбор
//  ДополнительныеПараметры		 - Структура - Дополнительные параметры выполнения	 
Процедура РазместитьДокументПоступленияПоЗаказам(ДокументПоступление,ПараметрыВыполнения = неопределено,ОшибкиРазмещения = неопределено) Экспорт 
	
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_РазместитьДокументПоступленияПоЗаказам";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Если ТипЗнч(ДокументПоступление) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") тогда 
		ДокументПоступление  = ДокументПоступление.ПолучитьОбъект();
	ИначеЕсли Не ТипЗнч(ДокументПоступление) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") тогда 
		Возврат ;
	КонецЕсли;	
	
	
	СтруктураТаблицДокумента = ПолучитьСтруктуруТаблицДокумента_ПоступлениеТоваровУслуг(ДокументПоступление);	
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровЗаполнения(ПараметрыВыполнения,ДокументПоступление);
	
	Попытка 
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);	
		
		ОчиститьДвиженияДокумента(ДокументПоступление,СтруктураПараметров);
		
		СтруктураТаблицРазмещения = ЗаказыПоставщикамСервер.ПолучитьСтруктуруТаблицРазмещения(СтруктураТаблицДокумента,СтруктураПараметров,ОшибкиРазмещения);
		
		ДокументПолностьюРазмещен = ДокументПолностьюРазмещен(ДокументПоступление,СтруктураТаблицРазмещения);
	
		Если не ДокументПолностьюРазмещен тогда 
			
			ЗаказыПоставщикамСервер.СоздатьВиртуальныеСтроки(СтруктураТаблицРазмещения,СтруктураПараметров);
			
			Если не ДокументПоступление.МожноПровести тогда 
				ДобавитьОшибкиРазмещения(СтруктураТаблицРазмещения.ТаблицаНеразмещенного,ОшибкиРазмещения);
			КонецЕсли;
		Иначе 
			ОшибкиРазмещения = неопределено;
		КонецЕсли;
		
		ОбновитьТаблицуРазмещения(ДокументПоступление,СтруктураТаблицРазмещения.ТаблицаРазмещения,СтруктураПараметров);
			
		Если ДокументПолностьюРазмещен или 
			ДокументПоступление.МожноПровести Тогда  
			ЗаписатьДокументПоступление(ДокументПоступление,СтруктураПараметров);
		КонецЕсли;
		
		ПроставитьОтказыПоНеразмещенному(СтруктураПараметров);	
		
		ЗафиксироватьТранзакцию();	
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ОшибкиРазмещения,,ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры	

Функция ЗаказПолностьюРазмещен(ЗаказПоставщику)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказыПоставщикамОстатки.СтрокаЗаявки,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОстатки.КоличествоОстаток, 0) КАК КоличествоНеРазмещено
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, СтрокаЗаявки.Заказ = &Заказ) КАК ЗаказыПоставщикамОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов.Остатки(, СтрокаЗаявки.Заказ = &Заказ) КАК РазмещенияСтрокЗаказовОстатки
	|		ПО ЗаказыПоставщикамОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказовОстатки.СтрокаЗаявки
	|ГДЕ
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОстатки.КоличествоОстаток, 0) > 0";
	
	Запрос.УстановитьПараметр("Заказ", ЗаказПоставщику);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции	

Процедура ДобавитьОшибкиРазмещения(ТаблицаНеразмещенного,ОшибкиРазмещения = неопределено)
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ДобавитьОшибкиРазмещения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаНеРазмещенного из ТаблицаНеразмещенного цикл 
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ОшибкиРазмещения,,
		"Не удалось разместить " + 
		УправлениеЗапасами.ПредставлениеНоменклатуры(СтрокаНеРазмещенного.Номенклатура,ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаНеРазмещенного.Номенклатура,"Артикул"),ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаНеРазмещенного.Номенклатура,"Изготовитель"))+
		". Количество не размещено :"+Строка(СтрокаНеРазмещенного.Количество)) ;
	КонецЦикла;	
КонецПроцедуры	


Функция ДокументПолностьюРазмещен(ДокументПоступление,СтруктураТаблицРазмещения=Неопределено) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ДокументПолностьюРазмещен";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	////////////////////////////////////////////////
	
	Если СтруктураТаблицРазмещения = Неопределено  тогда 
		
		Возврат ДокументПоступление.РазмещениеСтрокПрихода.Итог("Количество") = ДокументПоступление.Товары.Итог("Количество")
		
	Иначе 	
		ТаблицаНеразмещенного = СтруктураТаблицРазмещения.ТаблицаНеразмещенного;	
		
		Если ТаблицаНеразмещенного.КОличество() тогда 
			Возврат Ложь;
		Иначе 
			Возврат Истина;
		КонецЕсли;	
	КонецЕсли;
	
КонецФункции	

Функция ПоступлениеПолностьюРазмещено(ТаблицаТоваров,ТаблицаРазмещения)
	ЗапросНеРазмещенного  = новый запрос("ВЫБРАТЬ
	|	ПоступлениеТоваровУслугТовары.СтрокаПрихода,
	|	ПоступлениеТоваровУслугТовары.Количество
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&Товары КАК ПоступлениеТоваровУслугТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслугРазмещениеСтрокПрихода.СтрокаПрихода,
	|	ПоступлениеТоваровУслугРазмещениеСтрокПрихода.Количество
	|ПОМЕСТИТЬ ТаблицаРазмещения
	|ИЗ
	|	&РазмещениеСтрокПрихода КАК ПоступлениеТоваровУслугРазмещениеСтрокПрихода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслугТовары.СтрокаПрихода,
	|	ПоступлениеТоваровУслугТовары.Количество КАК КоличествоПришло,
	|	СУММА(ЕСТЬNULL(ПоступлениеТоваровУслугРазмещениеСтрокПрихода.Количество, 0)) КАК КоличествоРазмещено
	|ИЗ
	|	ТаблицаТоваров КАК ПоступлениеТоваровУслугТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаРазмещения КАК ПоступлениеТоваровУслугРазмещениеСтрокПрихода
	|		ПО (ПоступлениеТоваровУслугРазмещениеСтрокПрихода.СтрокаПрихода = ПоступлениеТоваровУслугТовары.СтрокаПрихода)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровУслугТовары.СтрокаПрихода,
	|	ПоступлениеТоваровУслугТовары.Количество
	|
	|ИМЕЮЩИЕ
	|	ПоступлениеТоваровУслугТовары.Количество > СУММА(ЕСТЬNULL(ПоступлениеТоваровУслугРазмещениеСтрокПрихода.Количество, 0))");
	ЗапросНеРазмещенного.УстановитьПараметр("Товары",ТаблицаТоваров);
	ЗапросНеРазмещенного.УстановитьПараметр("Товары",ТаблицаРазмещения);
	
	Результат  = ЗапросНеРазмещенного.Выполнить();
	
	Возврат Результат.Пустой() 
	
КонецФункции	


Процедура ОчиститьДвиженияДокумента(ДокументПоступление,СтруктураПараметров)
	Если ДокументПоступление.ЭтоНовый() тогда 
		Возврат;
	КонецЕсли;	
	
	Если СтруктураПараметров.ОтборНоменклатуры тогда 
		МассивНоменклатуры = СтруктураПараметров.МассивОтбораНоменклатуры;
		
		ЗапросСтрокЗаявок = новый ПостроительЗапроса;
		СписокНоменклатуры = Новый  СписокЗначений;
		СписокНоменклатуры.ЗагрузитьЗначения(МассивНоменклатуры);
		ЗапросСтрокЗаявок.ИсточникДанных = новый ОписаниеИсточникаДанных(ДокументПоступление.РазмещениеСтрокПрихода.Выгрузить());
		Отбор = ЗапросСтрокЗаявок.Отбор;
		Отбор.Добавить("Номенклатура");
		Отбор["Номенклатура"].Использование = Истина;
		Отбор["Номенклатура"].ВидСравнения = ВидСравнения.ВСписке;
		Отбор["Номенклатура"].Значение = СписокНоменклатуры;
		
		ЗапросСтрокЗаявок.Выполнить();
		Результат = ЗапросСтрокЗаявок.Результат;
		
		МассивСтрокЗаявок = Результат.Выгрузить().ВыгрузитьКолонку("СтрокаЗаявки");
		
		УбратьОтборНоменклатурыИзДвиженийДокумента("ЗаказыПоставщикам",ДокументПоступление,МассивСтрокЗаявок);
		УбратьОтборНоменклатурыИзДвиженийДокумента("РазмещенияСтрокЗаказов",ДокументПоступление,МассивСтрокЗаявок);
	Иначе 
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ДокументПоступление,Ложь);
	КонецЕсли;	
КонецПроцедуры	

Процедура УбратьОтборНоменклатурыИзДвиженийДокумента(ИмяРегистра,ДокументПоступление,МассивСтрокЗаявок)
	
	Набор = ДокументПоступление.Движения[ИмяРегистра];
	Набор.Прочитать();
	Для каждого СтрокаДвижения из Набор цикл
		Если не  МассивСтрокЗаявок.Найти(СтрокаДвижения.СтрокаЗаявки) = Неопределено тогда 
			Набор.Удалить(СтрокаДвижения);
		КонецЕсли;	 	
	КонецЦикла;
	набор.Записать();	
	
КонецПроцедуры	

Процедура ЗаписатьДокументПоступление(ДокументПоступление,СтруктураПараметров,ОшибкиРазмещения = неопределено)
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ЗаписатьДокументПоступление";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	Если Не СтруктураПараметров.ЗаписатьДокумент тогда 
		Возврат;
	КонецЕсли;	
	
	Если СтруктураПараметров.ОперативноеПроведение	 тогда 
		ДокументПоступление.Дата = ТекущаяДата();
		РежимПроведения = РежимПроведенияДокумента.Оперативный;
	иначе 
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;
	
	Если ДокументПоступление.МожноПровести и ДокументПоступление.СтатусДокумента  = Справочники.СтатусыДокументов.ПоступлениеТоваровНовый тогда 
		ДокументПоступление.СтатусДокумента  = Справочники.СтатусыДокументов.ПоступлениеТоваровОтгружен;
	Конецесли;	
	
	ДокументПоступление.ДатаАвторазмещения = ТекущаяДата();
	
	ДокументПоступление.Записать(РежимЗаписиДокумента.Проведение,РежимПроведения);
	
КонецПроцедуры	

Функция ПолучитьСтруктуруПараметровЗаполнения(Знач СтруктураПараметров,ДокументПоступление) экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ПолучитьСтруктуруПараметровЗаполнения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	////////////////////////////////////////////////
	
	
	СтруктураПараметровПоУмолчанию =    ЗаказыПоставщикамСервер.ПараметрыРазмещенияПоУмолчанию();
	
	Если СтруктураПараметров = Неопределено тогда 
		СтруктураПараметров = СтруктураПараметровПоУмолчанию;
	иначе 
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметров,СтруктураПараметровПоУмолчанию,Ложь);
	КонецЕсли;	
	
	СтрокаРеквизитовДокумента = "Контрагент,Склад,ДоговорКонтрагента,ПоставщикЗаказовДругой,ТорговаяТочка,МожноПровести";
	СтруктураРеквизитовДокумента = новый Структура(СтрокаРеквизитовДокумента); 	
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитовДокумента,ДокументПоступление,СтрокаРеквизитовДокумента);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметров,СтруктураРеквизитовДокумента,Ложь);	
	
	ЗаполнитьСтркутуруПараметровЗаполненияПоКонтрагенту(СтруктураПараметров,ДокументПоступление);	
	
	СтруктураПараметров.Вставить("ОтборНоменклатуры",?(СтруктураПараметров.МассивОтбораНоменклатуры.Количество()>0,Истина,Ложь));
	
	
	Возврат СтруктураПараметров
	
КонецФункции	


Процедура ЗаполнитьСтркутуруПараметровЗаполненияПоКонтрагенту(СтруктураПараметров,ДокументПоступление);
 	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ЗаполнитьСтркутуруПараметровЗаполненияПоКонтрагенту";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	
	Контрагент =ДокументПоступление.Контрагент;
	ЗаказПоставщику = ДокументПоступление.ДокументОснование;	
	РеквизитыКонтрагента  = 	ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент,"ЗаказРавенПриходу,ОсновнаяТорговаяТочка,ПроцентОтклоненияЦенПрихода");
	
	Если РеквизитыКонтрагента.ЗаказРавенПриходу
		и ЗначениеЗаполнено(ЗаказПоставщику)  и ТипЗнч(ЗаказПоставщику) = Тип("ДокументСсылка.ЗаказПоставщику")тогда 
		СтруктураПараметров.Вставить("ЗаказРавенПриходу",Истина);
		СтруктураПараметров.Вставить("ЗаказРаспределения",ЗаказПоставщику);
	Иначе  
		СтруктураПараметров.Вставить("ЗаказРавенПриходу",Ложь);
	КонецЕсли; 
	
	Если не ЗначениеЗаполнено(СтруктураПараметров.ТорговаяТочка) тогда 
		СтруктураПараметров.ТорговаяТочка =РеквизитыКонтрагента.ОсновнаяТорговаяТочка;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ПроцентОтклоненияЦенПрихода) тогда 
	СтруктураПараметров.ПроцентОтклоненияЦенПрихода = РеквизитыКонтрагента.ПроцентОтклоненияЦенПрихода;
	КонецЕсли;

	СтруктураПараметров.Вставить("КонтролироватьДоговор",?(ЗначениеЗаполнено(ДокументПоступление.ПоставщикЗаказовДругой),Ложь,Истина));
	
КонецПроцедуры	

Процедура ПроставитьОтказыПоНеразмещенному(СтруктураПараметров)
	
	ЗаказРаспределения = СтруктураПараметров.ЗаказРаспределения;
	Если СтруктураПараметров.ЗаказРавенПриходу 
		и ЗначениеЗаполнено(ЗаказРаспределения) 
		и не ЗаказПолностьюРазмещен(ЗаказРаспределения) тогда 
		Документы.ЗаказПоставщику.ПроставитьПолныйОтказНаДокумент(ЗаказРаспределения,Справочники.СостоянияСтрокДокументов.НетНаСкладе,"Отказ проставлен на основании загрузки из ОП")
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьСтруктуруТаблицДокумента_ПоступлениеТоваровУслуг(ДокументПоступление)
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("Товары",ДокументПоступление.Товары.Выгрузить());
	Возврат СтруктураТаблиц;
	
КонецФункции	

Процедура ОбновитьТаблицуРазмещения(ДокументПоступление,ТаблицаРазмещения,СтруктураПараметров)
	
	Если Не ДокументПоступление.МожноПровести тогда 
		Возврат;
	КонецЕсли;	
	
	ТаблицаДокумента = ДокументПоступление.РазмещениеСтрокПрихода;
	Если СтруктураПараметров.ОтборНоменклатуры тогда 
		МассивНоменклатуры = СтруктураПараметров.МассивОтбораНоменклатуры;
		Для каждого ЭлементНоменклатуры из МассивНоменклатуры цикл 
			
			НайдСтроки = ТаблицаДокумента.НайтиСтроки(Новый Структура("Номенклатура",ЭлементНоменклатуры));
			Для каждого НайденаяСтрока из НайдСтроки цикл 
				ТаблицаДокумента.Удалить(НайденаяСтрока);
			КонецЦикла;	
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаРазмещения,ТаблицаДокумента);
	Иначе 
		ТаблицаДокумента.Очистить();
		ТаблицаДокумента.загрузить(ТаблицаРазмещения);	
	КонецЕсли;	
	
КонецПроцедуры	




#КонецОбласти
