﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЕСПЕЧЕНИЯ ТАЙПИНГА В ПОЛЕ ВВОДА


// Функция формирует список выбора значений, для события ОкончаниеВводаТекста.
//
// Параметры
//  РезультатЗапроса - РезультатЗапроса при поиске по строке
//  Текст - Строка, текст поиска по строке
//  ТипСправочника - Тип, тип справочника автоподбора текста
//  ОсновноеПредставлениеВВидеКода - Булево, является ли представление в виде кода основным для справочника
//
// Возвращаемое значение:
//   Список значений
//
Функция СформироватьСписокВыбораЗначенийПоискаПоСтроке(ТаблицаЗапроса, Знач Текст, ПоляПоиска, ОсновноеПредставлениеВВидеКода)

	СписокВозврата = Новый СписокЗначений;
	
	Текст = ВРег(Текст);
	ДлинаТекста = СтрДлина(Текст);
	
	ЕстьНаименование = (ТаблицаЗапроса.Колонки.Найти("Наименование") <> Неопределено);
	ЕстьКод          = (ТаблицаЗапроса.Колонки.Найти("Код") <> Неопределено);
	
	НужноИскатьПоКоду 		  = (ОбщегоНазначения.ВернутьИндексВМассиве(ПоляПоиска, "Код") <> -1);
	НужноИскатьПоНаименованию = (ОбщегоНазначения.ВернутьИндексВМассиве(ПоляПоиска, "Наименование") <> -1);

	Для Каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
		
		Если ЕстьНаименование И НужноИскатьПоНаименованию И ВРег(Лев(СтрокаТаблицы.Наименование, ДлинаТекста)) = Текст Тогда
			Если ОсновноеПредставлениеВВидеКода И ЕстьКод Тогда
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, СтрокаТаблицы.Код + " (" + Строка(СтрокаТаблицы.Наименование) + ")");
			Иначе
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, (СтрокаТаблицы.Наименование + ?(ЕстьКод, (" (" + Строка(СтрокаТаблицы.Код) + ")"), "")));
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Если ЕстьКод И НужноИскатьПоКоду И ВРег(Лев(СтрокаТаблицы.Код, ДлинаТекста)) = Текст Тогда
			Если ЕстьНаименование Тогда
				Если ОсновноеПредставлениеВВидеКода И ЕстьКод Тогда
					СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, СтрокаТаблицы.Код + " (" + Строка(СтрокаТаблицы.Наименование) + ")");
				Иначе
					СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, (СтрокаТаблицы.Наименование + " (" + Строка(СтрокаТаблицы.Код) + ")"));
				КонецЕсли;
			Иначе
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, Строка(СтрокаТаблицы.Код));
			КонецЕсли; 
			Продолжить;
		КонецЕсли;
		
		Для Каждого Колонка Из ТаблицаЗапроса.Колонки Цикл
		
			Если Колонка.Имя = "Наименование" ИЛИ Колонка.Имя = "Код" ИЛИ Колонка.Имя = "Ссылка" Тогда
				Продолжить;
			КонецЕсли; 
		
			Если ВРег(Лев(СтрокаТаблицы[Колонка.Имя], ДлинаТекста)) = Текст Тогда
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, ("" + СтрокаТаблицы[Колонка.Имя] + ?(ЕстьНаименование, (" (" + Строка(СтрокаТаблицы.Наименование) + ")"), "")));
				Прервать;
			КонецЕсли
			
		КонецЦикла; 
	
	КонецЦикла;	 

	Возврат СписокВозврата;
	
КонецФункции

// функция по типу возвращает наименование ветки метаданных
Функция ПолучитьВеткуМетаданныхПоТипу(ТипДанных)
	
	ВеткаМетаданных = "";
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "Справочник"
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланВидовРасчета"
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланВидовХарактеристик"
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланСчетов"
	КонецЕсли;
	
	Возврат ВеткаМетаданных;

КонецФункции

// Функция выполняет запрос при автоподборе текста  и при окончании ввода текста в поле ввода.
//
// Параметры
//  Текст - Строка, текст введенный в поле ввода видв контактной информации, по которому необходимо строить поиск
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - Тип, тип справочника автоподбора текста
//  КоличествоЭлементов - Число, количество элементов в результирующей таблице запроса
//
// Возвращаемое значение
//  РезультатЗапроса
//
Функция ПолучитьРезультатЗапросаАвтоподбора(Знач Текст, СтруктураПараметров, ТипСправочника, КоличествоЭлементов) Экспорт

	ВеткаМетаданных = ПолучитьВеткуМетаданныхПоТипу(ТипСправочника);
	Если ВеткаМетаданных = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПустаяСсылкаТипа = Новый(ТипСправочника);
	
	МетаданныеОбъекта = ПустаяСсылкаТипа.Метаданные();
	
	КоллекцияПоискаПоПодстроке = МетаданныеОбъекта.ВводПоСтроке;
	Если КоллекцияПоискаПоПодстроке.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ИмяТаблицыСправочника = МетаданныеОбъекта.Имя;
	ИмяТаблицыОграничений = ?(КоллекцияПоискаПоПодстроке.Количество() = 1, "ТаблицаВложенногоЗапроса", "ТаблицаСправочника");
	
	СтрокаОтборовПоСтруктуре = "";
	
	Запрос = СоздатьЗапросДляСпискаАвтоподбора(Текст, СтрокаОтборовПоСтруктуре, СтруктураПараметров, ИмяТаблицыОграничений);
	
	СтрокаПолей = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ " + Строка(КоличествоЭлементов) + "
	|	ТаблицаВложенногоЗапроса.Ссылка КАК Ссылка,
	|";
	
	Если МетаданныеОбъекта.ДлинаНаименования > 0 Тогда
		СтрокаПолей = СтрокаПолей + "
		|	ТаблицаВложенногоЗапроса.Ссылка.Наименование КАК Наименование,";
	КонецЕсли;
	
	Если МетаданныеОбъекта.ДлинаКода > 0 Тогда
		СтрокаПолей = СтрокаПолей + "
		|	ТаблицаВложенногоЗапроса.Ссылка.Код КАК Код,";
	КонецЕсли; 
	
	Если КоллекцияПоискаПоПодстроке.Количество() = 1 Тогда
		
		ЭлементКоллекции = КоллекцияПоискаПоПодстроке[0];
		ТипЗначенияПоиска = ОпределитьТипОграниченийПоПолю(ЭлементКоллекции.Имя, МетаданныеОбъекта);
		
		Если ЭлементКоллекции.Имя <> "Наименование" И ЭлементКоллекции.Имя <> "Код" Тогда
			СтрокаПолей = СтрокаПолей + "
			|	ТаблицаВложенногоЗапроса.Ссылка." + ЭлементКоллекции.Имя + " КАК " + ЭлементКоллекции.Имя;
		КонецЕсли;
		
		Запрос.Текст = Лев(СтрокаПолей, (СтрДлина(СтрокаПолей) - 1)) + "
		|ИЗ
		|	" + ВеткаМетаданных + "." + ИмяТаблицыСправочника + " КАК ТаблицаВложенногоЗапроса
		|ГДЕ ";
		
		ОграничениеПоПолю = СформироватьОграничениеПоПолюВхождениеВНачало("ТаблицаВложенногоЗапроса." + ЭлементКоллекции.Имя, ТипЗначенияПоиска);
		
		ОграничениеПоПолю = ОграничениеПоПолю + "
		|	И НЕ ТаблицаВложенногоЗапроса.ПометкаУдаления ";
		
		Запрос.Текст = Запрос.Текст +"
		|	" + ОграничениеПоПолю + СтрокаОтборовПоСтруктуре;
	
	Иначе
		
		ПервыйЭлемент = Истина;
		СтрокаТаблиц = "";
		Для каждого ЭлементКоллекции Из КоллекцияПоискаПоПодстроке Цикл
			
			ТипЗначенияПоиска = ОпределитьТипОграниченийПоПолю(ЭлементКоллекции.Имя, МетаданныеОбъекта);
			
			Если ЭлементКоллекции.Имя <> "Наименование" И ЭлементКоллекции.Имя <> "Код" Тогда
				СтрокаПолей = СтрокаПолей + "
				|	ТаблицаВложенногоЗапроса.Ссылка." + ЭлементКоллекции.Имя + " КАК " + ЭлементКоллекции.Имя + ",";
			КонецЕсли;
			
			Если НЕ ПервыйЭлемент Тогда
				СтрокаТаблиц = СтрокаТаблиц + "
				|
				|	ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли; 
			ПервыйЭлемент = Ложь;
			
			СтрокаТаблиц = СтрокаТаблиц + "
			|	ВЫБРАТЬ  ПЕРВЫЕ " + Строка(КоличествоЭлементов) + "
			|		ТаблицаСправочника.Ссылка КАК Ссылка
			|	ИЗ
			|		" + ВеткаМетаданных + "." + ИмяТаблицыСправочника + " КАК ТаблицаСправочника
			|	ГДЕ ";
			
			
			ОграничениеПоПолю = СформироватьОграничениеПоПолюВхождениеВНачало("ТаблицаСправочника." + ЭлементКоллекции.Имя, ТипЗначенияПоиска);
			
			ОграничениеПоПолю = ОграничениеПоПолю + "
			|	И НЕ ТаблицаСправочника.ПометкаУдаления ";
		
			СтрокаТаблиц = СтрокаТаблиц +"
			|	" + ОграничениеПоПолю + СтрокаОтборовПоСтруктуре;		
		КонецЦикла; 
		
		Запрос.Текст = Лев(СтрокаПолей, (СтрДлина(СтрокаПолей) - 1)) + "
		|ИЗ
		|
		|	(
		|" + СтрокаТаблиц + "
		|	) КАК ТаблицаВложенногоЗапроса";
	
	КонецЕсли; 
	
	Возврат Запрос.Выполнить();

КонецФункции

// Процедура обслуживает событие ОбновлениеОтображения в форме, где расположен ЭУ поиска по строке.
//
// Параметры
//  ЭтаФорма - Форма записи регистра сведений КонтактнаяИнформация
//  Элемент - элемент управления в котором происводится поиск по строке
//
Процедура ОбновлениеОтображенияВФормеПриПоискеПоСтроке(ЭтаФорма, Элемент, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке) Экспорт

	Если ОбработкаПоискаПоСтроке Тогда
		ЭтаФорма.ТекущийЭлемент = Элемент;
		Элемент.ВыделенныйТекст = ТекстПоискаПоСтроке;
		ОбработкаПоискаПоСтроке = Ложь;
		ТекстПоискаПоСтроке = "";
	КонецЕсли; 
	
	Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда
		Элемент.ЦветТекстаПоля = ЦветаСтиля.ТекстИнформационнойНадписи;
	Иначе
		Элемент.ЦветТекстаПоля = Новый Цвет;
	КонецЕсли;

КонецПроцедуры

// Функция формирует массив имен полей по которым организованн ввод по строке
Функция СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника) Экспорт
	
	ПоляПоиска = Новый Массив();
	ПустаяСсылка = Новый(ТипСправочника);
	КоллекцияЭлементовПоиска = ПустаяСсылка.Метаданные().ВводПоСтроке;
	Для Каждого ЭлементКоллекции Из КоллекцияЭлементовПоиска Цикл
		ПоляПоиска.Добавить(ЭлементКоллекции.Имя)
	КонецЦикла;
	
	Возврат ПоляПоиска;
	
КонецФункции

// Процедура обслуживает событие АвтоПодборТекста элемента управления ПолеВвода для подмены автопоиска по тексту.
//
// Параметры
//  Элемент - поле ввода
//  Текст - текст введенный в поле ввода Вид
//  ТекстАвтоПодбора - текст автоподбора в поле Вид
//  СтандартнаяОбработка - булево, флаг стандартной обработки события автоподбора
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - Тип, тип справочника автоподбора текста
//
Процедура АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, СтруктураПараметров, ТипСправочника) Экспорт

	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбора(Текст, СтруктураПараметров, ТипСправочника, 2);
	ПоляПоиска = СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника);
	ПолучитьАвтоподборПоВыборке(РезультатЗапроса, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПоляПоиска);

КонецПроцедуры

// Процедура организует выбор элементов по результату запроса
Процедура ВыбратьЭлементОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено, 
											ПриОтсутствииЗначенияОставлятьТекст = Истина, ПоляПоиска, ПолеВыбора, 
											СтруктураВыбранногоЭлемента = Неопределено, ОсновноеПредставлениеВВидеКода = Ложь,
											Знач СообщатьПользователюОбОшибкеВводаДанных = Истина)
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	Если РезультатЗапроса.Пустой() И ПриОтсутствииЗначенияОставлятьТекст Тогда
		Значение = Текст;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	ТаблицаВыборки = РезультатЗапроса.Выгрузить();
	Значение = СформироватьСписокВыбораЗначенийПоискаПоСтроке(ТаблицаВыборки, Текст, ПоляПоиска, ОсновноеПредставлениеВВидеКода);
	
КонецПроцедуры

// Процедура обслуживает событие ОкончаниеВводаТекста элемента управления Вид в форме записи регистра
// сведений Контактная информация.
//
// Параметры
//  Элемент - поле ввода
//  Текст - текст введенный в поле ввода Вид
//  Значение - данные элемента управления поле ввода
//  СтандартнаяОбработка - булево, флаг стандартной обработки события автоподбора
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ЭтаФорма - форма записи регистра сведений контактная информация
//  ТипСправочника - Тип, тип справочника автоподбора текста
//
Процедура ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, СтруктураПараметров, ЭтаФорма, ТипСправочника, 
	ОбработкаПоискаПоСтроке = Неопределено, ТекстПоискаПоСтроке = Неопределено, ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено, 
	ПриОтсутствииЗначенияОставлятьТекст = Истина, Знач СообщатьПользователюОбОшибкеВводаДанных = Истина) Экспорт

	Если ПустаяСтрока(Текст) Тогда
		Значение = Новый(ТипСправочника);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли; 
	
	ПоляПоиска = СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника);

	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбора(Текст, СтруктураПараметров, ТипСправочника, 51);
	
	// определим способ основного представления справочника
	ОсновноеПредставлениеВВидеКода = Ложь;
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипСправочника);
	Если ОбъектМетаданных <> Неопределено Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСправочника.ВВидеКода Тогда
			ОсновноеПредставлениеВВидеКода = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВыбратьЭлементОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке, 
										ПриОтсутствииЗначенияОставлятьТекст, ПоляПоиска, "Ссылка", , ОсновноеПредставлениеВВидеКода,
										СообщатьПользователюОбОшибкеВводаДанных);
	
КонецПроцедуры

//Функция Определяет тип ограничений по полю
Функция ОпределитьТипОграниченийПоПолю(ИмяЭлемента, МетаданныеОбъекта, ДляСправочника = Истина)
	
	Если ДляСправочника Тогда
		
		Если ИмяЭлемента <> "Наименование" И ИмяЭлемента <> "Код" Тогда
	    	ТипЗначенияПоиска = МетаданныеОбъекта.Реквизиты[ИмяЭлемента].Тип.Типы()[0];
		Иначе
			Если ИмяЭлемента = "Наименование" Тогда
				ТипЗначенияПоиска = Тип("Строка");
			Иначе
				Если МетаданныеОбъекта.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
					ТипЗначенияПоиска = Тип("Строка");
				Иначе
					ТипЗначенияПоиска = Тип("Число");
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
		
	Иначе
		// тип определяем для регистра сведений
		Объект = МетаданныеОбъекта.Измерения.Найти(ИмяЭлемента);
		Если Объект = Неопределено Тогда
			Объект = МетаданныеОбъекта.Ресурсы.Найти(ИмяЭлемента);
		КонецЕсли;
		Если Объект = Неопределено Тогда
			Объект = МетаданныеОбъекта.Реквизиты.Найти(ИмяЭлемента);
			Если Объект = Неопределено Тогда
				ТипЗначенияПоиска = Тип("Строка");
			КонецЕсли;	
		КонецЕсли;
		ТипЗначенияПоиска = Объект.Тип.Типы()[0];
		
	КонецЕсли;
	
	Возврат  ТипЗначенияПоиска;
	
КонецФункции

// Функция создает объект запрос и устанавливает у него параметры ТекстАвтоПодбора и ТекстАвтоПодбораЧисло
// убирает лишние символы в строке поиска
Функция  СоздатьЗапросДляСпискаАвтоподбора(СтрокаПоиска, СтрокаОтборовПоСтруктуре, СтруктураПараметров, ИмяТаблицыОграничений)
	
	Запрос = Новый Запрос;
	
	СтрокаПоиска = ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(СтрокаПоиска);
		
	Запрос.УстановитьПараметр("ТекстАвтоПодбора"     , (СтрокаПоиска + "%"));
	Запрос.УстановитьПараметр("ТекстАвтоПодбораЧисло", ОбщегоНазначения.ПривестиСтрокуКЧислу(СтрокаПоиска, Истина));
	
	// Устанавливает ограничения
	СтрокаОтборовПоСтруктуре = "";
	Для Каждого ЭлементСтруктуры Из СтруктураПараметров Цикл
		Ключ 	 = ЭлементСтруктуры.Ключ;
        Значение = ЭлементСтруктуры.Значение;

		Запрос.УстановитьПараметр(Ключ, Значение);
		СтрокаОтборовПоСтруктуре = СтрокаОтборовПоСтруктуре + "
		|		И
		|		" + ИмяТаблицыОграничений + "." + Ключ + " В (&"+ Ключ + ")";
	КонецЦикла; 
	
	Возврат Запрос;
	
КонецФункции

// Функция формирует ограничение для запроса по полю 
Функция СформироватьОграничениеПоПолюВхождениеВНачало(ИмяПоля, ТипЗначенияПоиска) Экспорт
	
	Ограничение = ИмяПоля + ?(ТипЗначенияПоиска = Тип("Строка"), (" ПОДОБНО &ТекстАвтоПодбора СПЕЦСИМВОЛ ""~"""), (" =  &ТекстАвтоПодбораЧисло"));
	Возврат "(" + Ограничение + ") ";
	
КонецФункции

// Функция подбирает значения по выборке
Функция ПолучитьАвтоподборПоВыборке(РезультатЗапроса, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПоляПоиска, Знач ПолеВыбора = "") Экспорт
	
	СтруктураНайденногоЭлемента = Новый Структура;
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли;
	
	ВрегТекст =	ВРег(Текст);
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество() <> 1 Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли;

	// выбран только один элемент - его и подставляем
	Выборка.Следующий();
	Для Каждого ИмяПоляПоиска Из ПоляПоиска Цикл
		ВрегЗначение = Врег(Выборка[ИмяПоляПоиска]);
		
		Если Лев(ВрегЗначение, СтрДлина(ВрегТекст)) = ВрегТекст Тогда
			Если ВрегТекст <> ВрегЗначение Тогда
				
				Если ПустаяСтрока(ПолеВыбора) Тогда			
					ТекстАвтоподбора = Выборка[ИмяПоляПоиска];
				Иначе
					ТекстАвтоподбора = Выборка[ПолеВыбора];
				КонецЕсли;
				
				УправлениеКонтактнойИнформацией.ПеренестиСтрокуВыборкиВСтруктуру(РезультатЗапроса, Выборка, СтруктураНайденногоЭлемента);
			КонецЕсли;
			
			Возврат СтруктураНайденногоЭлемента;
		КонецЕсли; 
		
	КонецЦикла;  
		
КонецФункции


