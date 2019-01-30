﻿

#Область Размещение_заказов_поставщику_в_ПТУ

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
		ТаблицаДокумента.Очиствить();
		ТаблицаДокумента.загрузить(ТаблицаРазмещения);	
	КонецЕсли;	
	
КонецПроцедуры	

Процедура СоздатьВиртуальныеСтроки(СтруктураТаблицРазмещения,СтруктураПараметров)  Экспорт
	ТаблицаНеразмещенного = СтруктураТаблицРазмещения.ТаблицаНеразмещенного;	
	
	Если НЕ СтруктураПараметров.СоздаватьВиртуальныеСтроки 
		или ТаблицаНеразмещенного.количество() =0 тогда 
		Возврат;
	КонецЕсли;
	
	ТаблицаРазмещения   = СтруктураТаблицРазмещения.ТаблицаРазмещения;
	Для каждого СтрокаНеразмещенного из ТаблицаНеразмещенного цикл 
			//СтрокаВиртуальная = ДокументПоступление.РазмещениеСтрокПрихода.Добавить();
			//ЗаполнитьЗначенияСвойств(СтрокаВиртуальная,СтрокаНеразмещенного);
			СтрокаВиртуальная = ОбщегоНазначенияКлиентСервер.ВиртуальнаяСтрокаЗаявки();
			ДобавитьСтрокуРазмещениявТаблицу(ТаблицаРазмещения,СтрокаНеразмещенного.Номенклатура,СтрокаВиртуальная,СтрокаНеразмещенного.СтрокаПрихода,СтрокаНеразмещенного.Количество);
	КонецЦикла;			
		
КонецПроцедуры	

Процедура ПроставитьОтказыПоНеразмещенному(ДокументПоступление,ТаблицаНеразмещенного,СтруктураПараметров)
	
	Если СтруктураПараметров.ЗаказРавенПриходу и ТаблицаНеразмещенного.Количество() тогда 
		ДокументПоступление.ДополнительныеСвойства.Вставить("ПроставитьПолныйОтказВЗаказе",СтруктураПараметров.ЗаказРаспределения);		
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьСтруктуруПараметровЗаполнения(Знач СтруктураПараметров) экспорт
	
	Если СтруктураПараметров = Неопределено тогда 
		СтруктураПараметров = ПараметрыРазмещенияПоУмолчанию();
	иначе 
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметров,ПараметрыРазмещенияПоУмолчанию(),Ложь);
	КонецЕсли;			
	
	СтрокаРеквизитовДокумента = "Контрагент,Склад,ДоговорКонтрагента,ПоставщикЗаказовДругой,ТорговаяТочка";
	СтруктураРеквизитовДокумента = новый Структура(СтрокаРеквизитовДокумента); 	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров,Документы,СтрокаРеквизитовДокумента);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураПараметров,СтруктураРеквизитовДокумента,Ложь);
	
	СтруктураПараметров.вставить("ОтборНоменклатуры",?(СтруктураПараметров.МассивОтбораНоменклатуры.Количество()>0,Истина,Ложь));
	//
	//СтруктураПараметров.вставить("РаспределятьПоСпискуЗаказов",?(не СтруктураПараметров.ЗаказРавенПриходу 
	//и СтруктураПараметров.СписокЗаказовРаспределения>0,Истина,Ложь));
	
	СтруктураПараметров.Вставить("МоментВремени",ТекущаяДата());
	
	Возврат СтруктураПараметров
	
КонецФункции	



#КонецОбласти

#Область Формирование_заказов
Функция ПолучитьСкладЗаказаПоПрайсу(ПрайсПоставщика,СкладВЗаявке) Экспорт 	
	
	Если РаботаСоСтатусамиДокументовПовтИсп.ЭтоПрайсПополнениеVMI(ПрайсПоставщика) тогда 
		Возврат СкладВЗаявке		
	ИначеЕсли РаботаСоСтатусамиДокументовПовтИсп.ЭтоКроссИлиПрайсПополнениеСток(ПрайсПоставщика) тогда 	
		ВладелецПрайса =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрайсПоставщика,"Владелец");
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецПрайса,"ОтгружаетсяВНесколькихГородах") тогда 
			Возврат СкладВЗаявке
		иначе 
			СкладЗамена =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецПрайса, "ГородПоставки.СкладЗамена");
			
			Если ЗначениеЗаполнено(СкладЗамена) тогда 
				Возврат СкладЗамена
			Иначе
				Возврат СкладВЗаявке
			КонецЕсли;				
		КонецЕсли;					
	КонецЕсли;		
	
	Возврат СкладВЗаявке
	
	
КонецФункции	

#КонецОбласти



#Область Запросы_к_Данным_Размещения

Функция ПолучитьСтруктуруТаблицРазмещения(СтруктураТаблицДокумента,СтруктураПараметров)  Экспорт
	ТаблицаРазмещения = ПолучитьПустуюТаблицуРазмещения();
	таблицаНеРазмещенного = ПолучитьПустуюТаблицуРазмещения();
	
	ЗапросПоОстаткам = Новый Запрос;
	ЗапросПоОстаткам.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеТоваровУслугТовары.Номенклатура,
	|	ПоступлениеТоваровУслугТовары.Количество КАК Количество,
	|	ПоступлениеТоваровУслугТовары.СтрокаПрихода
	|ПОМЕСТИТЬ ВТТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ПоступлениеТоваровУслугТовары
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ОтборНоменклатуры
	|				ТОГДА ПоступлениеТоваровУслугТовары.Номенклатура В (&МассивОтбораНоменклатуры)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВозможныеЗаменыНоменклатурыСрезПоследних.Номенклатура,
	|	ИСТИНА КАК Замена,
	|	ВозможныеЗаменыНоменклатурыСрезПоследних.НоменклатураЗамена
	|ПОМЕСТИТЬ ВТТоварыСЗаменами
	|ИЗ
	|	РегистрСведений.ВозможныеЗаменыНоменклатуры.СрезПоследних(
	|			&МоментВремени,
	|			НоменклатураЗамена В
	|				(ВЫБРАТЬ
	|					ВТТоваров.Номенклатура КАК Номенклатура
	|				ИЗ
	|					ВТТоваров КАК ВТТоваров)) КАК ВозможныеЗаменыНоменклатурыСрезПоследних
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТТоваров.Номенклатура,
	|	ЛОЖЬ,
	|	ВТТоваров.Номенклатура
	|ИЗ
	|	ВТТоваров КАК ВТТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыПоставщикамОстатки.Номенклатура КАК НоменклатураЗаказа,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток - ЕСТЬNULL(РазмещенияСтрокЗаказовОстатки.КоличествоОстаток, 0) КАК Количество,
	|	ЗаказыПоставщикамОстатки.СтрокаЗаявки,
	|	ЕСТЬNULL(ВозможныеЗаменыНоменклатурыСрезПоследних.НоменклатураЗамена, ЗаказыПоставщикамОстатки.Номенклатура) КАК Номенклатура
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|			&МоментВремени,
	|			ТорговаяТочка = &ТорговаяТочка
	|				И Склад = &Склад
	|				И ВЫБОР
	|					КОГДА &КонтролироватьДоговор
	|						ТОГДА ДоговорКонтрагента = &ДоговорКонтрагента
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТТоварыСЗаменами.Номенклатура КАК Номенклатура
	|					ИЗ
	|						ВТТоварыСЗаменами КАК ВТТоварыСЗаменами)
	|				И ВЫБОР
	|					КОГДА &ЗаказРавенПриходу
	|						ТОГДА СтрокаЗаявки.Заказ = &ЗаказРаспределения
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ ) КАК ЗаказыПоставщикамОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТоварыСЗаменами КАК ВозможныеЗаменыНоменклатурыСрезПоследних
	|		ПО ЗаказыПоставщикамОстатки.Номенклатура = ВозможныеЗаменыНоменклатурыСрезПоследних.НоменклатураЗамена
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РазмещенияСтрокЗаказов.Остатки КАК РазмещенияСтрокЗаказовОстатки
	|		ПО ЗаказыПоставщикамОстатки.СтрокаЗаявки = РазмещенияСтрокЗаказовОстатки.СтрокаЗаявки
	|			И (РазмещенияСтрокЗаказовОстатки.КоличествоОстаток > 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказыПоставщикамОстатки.СтрокаЗаявки.СрокГарантированныйЗаказа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТоваров.Номенклатура,
	|	СУММА(ВТТоваров.Количество) КАК Количество,
	|	ВТТоваров.СтрокаПрихода
	|ИЗ
	|	ВТТоваров КАК ВТТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТТоваров.Номенклатура,
	|	ВТТоваров.СтрокаПрихода";
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ЗапросПоОстаткам.Параметры,СтруктураПараметров,Истина);
	//ЗаполнитьЗначенияСвойств(ЗапросПоОстаткам.Параметры,СтруктураПараметров);
	
	ЗапросПоОстаткам.установитьПараметр("ТаблицаТоваров",СтруктураТаблицДокумента.Товары);//ДокументПоступление.Выгрузить());	
	
	
	РезультатЗапроса = ЗапросПоОстаткам.ВыполнитьПакет();
	
	ВыборкаНоменклатуры = РезультатЗапроса[3].Выбрать();
	ТаблицаЗаказов = РезультатЗапроса[2].Выгрузить();	
	Пока ВыборкаНоменклатуры.Следующий() Цикл
		НоменклатураПоиска = ВыборкаНоменклатуры.Номенклатура;
		КоличествоКРазмещению  = ВыборкаНоменклатуры.Количество;
		НайдСтрокиЗаказов = ТаблицаЗаказов.найтиСтроки(Новый структура("Номенклатура",НоменклатураПоиска));
		
		Для каждого СтрокаЗаказа из  НайдСтрокиЗаказов цикл 
			Если КоличествоКРазмещению = 0 тогда 
				Прервать;
			КонецЕсли;	 
			
			Если  КоличествоКРазмещению >= СтрокаЗаказа.Количество тогда 
				ДобавитьСтрокуРазмещениявТаблицу(ТаблицаРазмещения,НоменклатураПоиска,СтрокаЗаказа.СтрокаЗаявки,ВыборкаНоменклатуры.СтрокаПрихода,СтрокаЗаказа.Количество);
				КоличествоКРазмещению = КоличествоКРазмещению - СтрокаЗаказа.Количество;	 
			Иначе 
				ДобавитьСтрокуРазмещениявТаблицу(ТаблицаРазмещения,НоменклатураПоиска,СтрокаЗаказа.СтрокаЗаявки,ВыборкаНоменклатуры.СтрокаПрихода,КоличествоКРазмещению);
				КоличествоКРазмещению = 0;	  	 
			КонецЕсли;	 
		КонецЦикла;
		
		
		Если КоличествоКРазмещению>0 тогда 
			ДобавитьСтрокуРазмещениявТаблицу(ТаблицаНеРазмещенного,НоменклатураПоиска,,ВыборкаНоменклатуры.СтрокаПрихода,КоличествоКРазмещению);
		КонецЕсли;	
		
		
		
	КонецЦикла;
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ТаблицаРазмещения",ТаблицаРазмещения);
	СтруктураТаблиц.Вставить("ТаблицаНеРазмещенного",ТаблицаНеРазмещенного);
	
	Возврат СтруктураТаблиц;
	
КонецФункции	

Процедура ДобавитьСтрокуРазмещениявТаблицу(Таблица,Номенклатура,СтрокаЗаявки,СтрокаПрихода,Количество)
	НовСтрока = Таблица.Добавить();
	НовСтрока.Номенклатура = Номенклатура;
	Новстрока.СтрокаЗаявки = СтрокаЗаявки;
	НовСтрока.Количество = Количество;	
	НовСтрока.СтрокаПрихода = СтрокаПрихода;
КонецПроцедуры	

#КонецОбласти


#Область Прочее

Функция ПолучитьПустуюТаблицуРазмещения()
	ТаблицаРазмещения = новый ТаблицаЗначений;
	ТаблицаРазмещения.Колонки.Добавить("Номенклатура");
	ТаблицаРазмещения.Колонки.Добавить("СтрокаПрихода");     
	ТаблицаРазмещения.Колонки.Добавить("СтрокаЗаявки");
	ТаблицаРазмещения.Колонки.Добавить("Количество",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,3));
	
	возврат   ТаблицаРазмещения;
	
КонецФункции	

Функция ПараметрыРазмещенияПоУмолчанию() Экспорт
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("СоздаватьВиртуальныеСтроки",Ложь);
	ПараметрыВыполнения.Вставить("ЗаказРавенПриходу",Ложь);
	ПараметрыВыполнения.Вставить("ЗаказРаспределения",Документы.ЗаказПоставщику.ПустаяСсылка());
	ПараметрыВыполнения.Вставить("ЗаписатьДокумент", Истина);
	ПараметрыВыполнения.Вставить("МассивОтбораНоменклатуры",новый Массив);
	//ПараметрыВыполнения.Вставить("РаспределятьПоСпискуЗаказов",Ложь);	
	//ПараметрыВыполнения.Вставить("ЗаказРаспределения", новый массив);

	ПараметрыВыполнения.Вставить("ОперативноеПроведение",Истина);		
	
	Возврат ПараметрыВыполнения
	
КонецФункции

Функция ДополнительныеПараметрыРазмещенияПоУмолчению()
	
	
КонецФункции

Функция ЭтоСкладНовойСхемы(Склад) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	_Временно_СкладыНовойСхемыЗакрытияЗаказов.Склад
	|ИЗ
	|	РегистрСведений._Временно_СкладыНовойСхемыЗакрытияЗаказов КАК _Временно_СкладыНовойСхемыЗакрытияЗаказов
	|ГДЕ
	|	_Временно_СкладыНовойСхемыЗакрытияЗаказов.Склад = &Склад";
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	
	Возврат Не РезультатЗапроса.Пустой();
	
	
КонецФункции

Функция ПоПоступлениюБылиРаспределения(ПоступлениеСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РазмещенияСтрокЗаказов.Регистратор
	|ИЗ
	|	РегистрНакопления.РазмещенияСтрокЗаказов КАК РазмещенияСтрокЗаказов
	|ГДЕ
	|	РазмещенияСтрокЗаказов.Регистратор = &ПоступлениеСсылка";
	
	Запрос.УстановитьПараметр("ПоступлениеСсылка", ПоступлениеСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	возврат не РезультатЗапроса.Пустой();
	
	
КонецФункции	


#КонецОбласти