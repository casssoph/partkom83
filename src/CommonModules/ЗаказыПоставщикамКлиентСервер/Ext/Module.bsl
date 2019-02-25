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
Процедура РазместитьДокументПоступленияПоЗаказам(ДокументПоступление,ПараметрыВыполнения = неопределено) Экспорт 
	
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
		
		СтруктураТаблицРазмещения = ЗаказыПоставщикамСервер.ПолучитьСтруктуруТаблицРазмещения(СтруктураТаблицДокумента,СтруктураПараметров);
		
		ДокументПолностьюРазмещен = ДокументПолностьюРазмещен(СтруктураТаблицРазмещения);
	
		ОбновитьТаблицуРазмещения(ДокументПоступление,СтруктураТаблицРазмещения.ТаблицаРазмещения,СтруктураПараметров);
		
		Если не ДокументПолностьюРазмещен тогда 
		ЗаказыПоставщикамСервер.СоздатьВиртуальныеСтроки(СтруктураТаблицРазмещения,СтруктураПараметров);
		ПроставитьОтказыПоНеразмещенному(ДокументПоступление,СтруктураТаблицРазмещения.ТаблицаНеразмещенного,СтруктураПараметров);	
		Иначе 
		   ДокументПоступление.МожноПровести = истина;
		КонецЕсли;
			
		Если СтруктураПараметров.ЗаписатьДокумент Тогда  
			ЗаписатьДокументПоступление(ДокументПоступление,СтруктураПараметров);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();	
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
КонецПроцедуры	


Функция ДокументПолностьюРазмещен(СтруктураТаблицРазмещения)
	ТаблицаНеразмещенного = СтруктураТаблицРазмещения.ТаблицаНеразмещенного;	

	Если ТаблицаНеразмещенного.КОличество() тогда 
		Возврат Ложь;
	Иначе 
		Возврат Истина;
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

Процедура ЗаписатьДокументПоступление(ДокументПоступление,СтруктураПараметров)
	лКлючАлгоритма = "ОбщийМодуль_ЗаказыПоставщикамКлиентСервер_ЗаписатьДокументПоступление";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Если СтруктураПараметров.ОперативноеПроведение	 тогда 
		ДокументПоступление.Дата = ТекущаяДата();
		РежимПроведения = РежимПроведенияДокумента.Оперативный;
	иначе 
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;
	
	Если ДокументПоступление.СтатусДокумента   = Справочники.СтатусыДокументов.ПоступлениеТоваровНовый тогда 
		ДокументПоступление.СтатусДокумента  = Справочники.СтатусыДокументов.ПоступлениеТоваровОтгружен;
	Конецесли;	
	
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
	
	СтрокаРеквизитовДокумента = "Контрагент,Склад,ДоговорКонтрагента,ПоставщикЗаказовДругой,ТорговаяТочка";
	СтруктураРеквизитовДокумента = новый Структура(СтрокаРеквизитовДокумента); 	
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитовДокумента,ДокументПоступление,СтрокаРеквизитовДокумента);
	
	ЗаполнитьСтркутуруПараметровЗаполненияПоКонтрагенту(СтруктураПараметров,ДокументПоступление);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметров,СтруктураРеквизитовДокумента,Ложь);	
	
	СтруктураПараметров.Вставить("ОтборНоменклатуры",?(СтруктураПараметров.МассивОтбораНоменклатуры.Количество()>0,Истина,Ложь));
	
	
	Возврат СтруктураПараметров
	
КонецФункции	


Процедура ЗаполнитьСтркутуруПараметровЗаполненияПоКонтрагенту(СтруктураПараметров,ДокументПоступление);
	Контрагент =ДокументПоступление.Контрагент;
	ЗаказПоставщику = ДокументПоступление.ДокументОснование;	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент,"ЗаказРавенПриходу")
		и ЗначениеЗаполнено(ЗаказПоставщику)  и ТипЗнч(ЗаказПоставщику) = Тип("ДокументСсылка.ЗаказПоставщику")тогда 
		СтруктураПараметров.Вставить("ЗаказРавенПриходу",Истина);
		СтруктураПараметров.Вставить("ЗаказРаспределения",ЗаказПоставщику);
	Иначе  
		СтруктураПараметров.Вставить("ЗаказРавенПриходу",Ложь);
	КонецЕсли; 
	
	СтруктураПараметров.Вставить("КонтролироватьДоговор",?(ЗначениеЗаполнено(ДокументПоступление.ПоставщикЗаказовДругой),Ложь,Истина));

КонецПроцедуры	

Процедура ПроставитьОтказыПоНеразмещенному(ДокументПоступление,ТаблицаНеразмещенного,СтруктураПараметров)
	
	Если СтруктураПараметров.ЗаказРавенПриходу и ТаблицаНеразмещенного.Количество() тогда 
		ДокументПоступление.ДополнительныеСвойства.Вставить("ПроставитьПолныйОтказВЗаказе",СтруктураПараметров.ЗаказРаспределения);		
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьСтруктуруТаблицДокумента_ПоступлениеТоваровУслуг(ДокументПоступление)
	
СтруктураТаблиц = Новый Структура;
СтруктураТаблиц.Вставить("Товары",ДокументПоступление.Товары.Выгрузить());
Возврат СтруктураТаблиц;
	
КонецФункции	

Процедура ОбновитьТаблицуРазмещения(ДокументПоступление,ТаблицаРазмещения,СтруктураПараметров)
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

//Процедура СоздатьВиртуальныеСтроки(ДокументПоступление,СтруктураТаблицРазмещения,СтруктураПараметров)	
//	Если НЕ СтруктураПараметров.СоздаватьВиртуальныеСтроки 
//		или ТаблицаНеразмещенного.количество() =0 тогда 
//		Возврат;
//	КонецЕсли;
//	
//	
//	ТаблицаНеразмещенного = СтруктураТаблицРазмещения.ТаблицаНеразмещенного;
//	
//	Для каждого СтрокаНеразмещенного из ТаблицаНеразмещенного цикл 
//			СтрокаВиртуальная = ДокументПоступление.РазмещениеСтрокПрихода.Добавить();
//			ЗаполнитьЗначенияСвойств(СтрокаВиртуальная,СтрокаНеразмещенного);
//			СтрокаВиртуальная = ОбщегоНазначенияКлиентСервер.ВиртуальнаяСтрокаЗаявки();
//			
//	КонецЦикла;			
//	КонецЕсли;	
//КонецПроцедуры	

#КонецОбласти
