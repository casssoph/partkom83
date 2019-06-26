﻿Перем СоединениеSQL_2;
Перем КомандаSQL_2;
Перем ВыборкаSQL_2;
Перем ВсегоНаВходе;
Перем ВсегоНаВыходе;
Перем ВсегоОшибокЗаписи;
Перем ИтогоЛог;

Функция Подключение_к_SQL_серверу_2() экспорт
	
	Успех = Истина;
	ОписаниеОшибки = "";
	
	Попытка
        СоединениеSQL_2  = Новый COMОбъект("ADODB.Connection");
        КомандаSQL_2     = Новый COMОбъект("ADODB.Command");
        ВыборкаSQL_2     = Новый COMОбъект("ADODB.RecordSet");
		
        //Provider=SQLOLEDB;Data Source=ndc2-v-sq-10;User Id=nsi2user;Password=[eq123;Initial Catalog=partkom83_nsi2;App=adonsi2      
		Пользователь = ?(ЗначениеЗаполнено(Пользователь),СокрЛП(Пользователь),"nsi2user");
		Пароль = ?(ЗначениеЗаполнено(Пароль),СокрЛП(Пароль),"[eq123");
		База = ?(ЗначениеЗаполнено(База),СокрЛП(База),"partkom83_nsi2");
		Сервер = ?(ЗначениеЗаполнено(Сервер),СокрЛП(Сервер),"NDC2-V-SQ-10");
		
        СоединениеSQL_ConnectionString =
							            "driver={SQL Server};" +
							            "server="+Сервер+";"+
							            "uid="+Пользователь+";"+
							            "pwd="+Пароль+";"+
							            "database="+База+";";
										
        СоединениеSQL_2.ConnectionString = СоединениеSQL_ConnectionString;
		СоединениеSQL_2.ConnectionTimeout = 30;
        СоединениеSQL_2.CommandTimeout = 6000;
		
		СоединениеSQL_2.Open();
		КомандаSQL_2.ActiveConnection   = СоединениеSQL_2;
		
	Исключение
		Успех = Ложь;
		ОписаниеОшибки = "";
	КонецПопытки;
	
	//Файл = Новый ЗаписьТекста("\\Srv1c-nn\1C_exch\ASTOR_1C\push\Log\ADODB_log.txt");
	//Файл.ЗаписатьСтроку(СокрЛП(Успех));
	//Файл.ЗаписатьСтроку("Как дела?");
	//Файл.Закрыть();

	Возврат Успех;
КонецФункции	

Функция ЗакрытьСеансПодключенияКSQL_2() экспорт
	Успех = Истина;	
	
	Попытка 
		СоединениеSQL_2.Close();
	Исключение
		СоединениеSQL_2 = Неопределено;
	КонецПопытки;
	
	Возврат Успех;
КонецФункции

Процедура ПолучитьДанныеВГХ() экспорт
	
	т_Массив = Номенклатура.ВыгрузитьЗначения();
	
	Если т_Массив.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Подключение_к_SQL_серверу_2() Тогда
		Возврат;
	КонецЕсли;
	
	Если МаксимальныйРазмерПакета = 0 Тогда
		МаксимальныйРазмерПакета = 100;
	КонецЕсли;
	
	Если МаксимальныйРазмерВыборки = 0 Тогда
		МаксимальныйРазмерВыборки = 100;
	КонецЕсли;
	
	т_счк = 0;
	в_счк = 0;
	г_счк = 0;
	с_uid = "";
	т_связки = Новый Соответствие;
	ВсегоНаВходе = т_Массив.Количество();
	ВсегоНаВыходе = 0;
	ВсегоОшибокЗаписи = 0;
	ИтогоЛог = "";
	
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". Всего элементов в списке = " + ВсегоНаВходе);
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". МаксимальныйРазмерВыборки = " + МаксимальныйРазмерВыборки);
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". МаксимальныйРазмерПакета = " + МаксимальныйРазмерПакета);
	
	Для каждого элемент из т_Массив цикл
		
		т_счк = т_счк + 1;
		
		Если т_счк > МаксимальныйРазмерВыборки Тогда
			Прервать;
		КонецЕсли;
		
		г_счк = г_счк + 1;
		
		uid = СокрЛП(элемент.УникальныйИдентификатор());
		т_связки.Вставить(ВРЕГ(uid),элемент);
		
		с_uid = с_uid + "'" + uid + "',";
		СообщитьЛог(Символы.Таб + "input. " + СокрЛП(т_счк) + ". " + СокрЛП(в_счк + 1) + ". " + СокрЛП(г_счк) + ". " + СокрЛП(uid)+ ". " + СокрЛП(элемент));
		
		Если Цел(т_счк / МаксимальныйРазмерПакета) = т_счк / МаксимальныйРазмерПакета Тогда
			
			ЗапроситьПоСписку(с_uid,т_связки);	
			
			т_связки.Очистить();
			в_счк = в_счк + 1;
			с_uid = "";
			г_счк = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(с_uid) Тогда
		ЗапроситьПоСписку(с_uid,т_связки);
	КонецЕсли;
	
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". Всего обработано из списка = " + ВсегоНаВыходе);
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". Разница = " + СокрЛП(ВсегоНаВходе - ВсегоНаВыходе) );
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". Всего Ошибок Записи = " + СокрЛП(ВсегоОшибокЗаписи), Ложь );
	
	ЗакрытьСеансПодключенияКSQL_2();
	
КонецПРоцедуры

Процедура ЗапроситьПоСписку(знач с_uid, знач т_связки)
	
	Если Прав(с_uid,1) = "," Тогда
		с_uid = Лев(с_uid,СтрДлина(с_uid) - 1);
	КонецЕсли;
	
	лДтВрм = ТекущаяДата();
	СообщитьЛог("inf. " + СокрлП(лДтВрм) + ". " + с_uid);
	
	тчРез = ВыполнитьЗапросВГХ(с_uid);
	тчРез_Количество = тчРез.Количество();
	СообщитьЛог("inf. " + СокрлП(ТекущаяДата()) + ". тчРез.Количество = " + СокрЛП(тчРез_Количество));
	
	ВсегоНаВыходе = ВсегоНаВыходе + тчРез_Количество;
	
	пп = 0;
	Для каждого стрез из тчРез Цикл
		пп = пп + 1 ;
		
		л_тов = т_связки.Получить(стрез.p0);
		
		л_Длина = стрез.p1;
		л_Ширина= стрез.p2; 
		л_Высота= стрез.p3;
		л_Вес   = стрез.p4;
		л_Объем = стрез.p5;
		
		c_Длина = Формат(л_Длина, "ЧЦ=15; ЧДЦ=0; ЧГ=0");
		c_Ширина= Формат(л_Ширина, "ЧЦ=15; ЧДЦ=0; ЧГ=0"); 
		c_Высота= Формат(л_Высота, "ЧЦ=15; ЧДЦ=0; ЧГ=0");
		c_Вес   = Формат(л_Вес, "ЧЦ=15; ЧДЦ=0; ЧГ=0");
		c_Объем = Формат(л_Объем, "ЧЦ=15; ЧДЦ=0; ЧГ=0");
		
		л_отказ = ЗаписатьВГХ(л_тов,л_Длина,л_Ширина,л_Высота,л_Вес,л_Объем);
		
		л_рез = Истина;
		Если ЗначениеЗаполнено(л_отказ) Тогда
			ВсегоОшибокЗаписи = ВсегоОшибокЗаписи + 1;
			л_рез = Ложь;
		КонецЕсли;
		
		СообщитьЛог(Символы.Таб + "output. " + СокрЛП(пп) + ". " + СокрЛП(стрез.p0)+ ". Длина =" + СокрЛП(c_Длина)+ ". Ширина =" + СокрЛП(c_Ширина)+ ". Высота =" + СокрЛП(c_Высота)+ ". Вес =" + СокрЛП(c_Вес)+ ". Объем =" + СокрЛП(c_Объем)+ ". Записано =" + СокрЛП(л_рез) + ?(л_рез,"",". err: " + л_отказ)  );
		
	КонецЦикла;
	
	Если тчРез.Количество() < т_связки.Количество() Тогда
		
		пп = 0;
		Для Каждого Элемент Из т_связки Цикл
			
			НайденнаяСтрока = тчРез.Найти(Элемент.Ключ, "p0");
			
			Если НайденнаяСтрока = Неопределено Тогда
				пп = пп + 1 ;
				
				л_рез = Истина;
				л_отказ = "";
				Попытка 
					МенеджерЗаписи = РегистрыСведений.ОшибкиЗагрузкиВГХ.СоздатьМенеджерЗаписи();
					МенеджерЗаписи.Период = лДтВрм;
					МенеджерЗаписи.Номенклатура = Элемент.Значение;
					МенеджерЗаписи.Записать();
				Исключение
					л_отказ = ОписаниеОшибки();
					л_рез = Ложь;
				КонецПопытки;
				
				СообщитьЛог(Символы.Таб + "unknown. " + СокрЛП(пп) + ". " + СокрЛП(Элемент.Ключ)+ ". Записано =" + СокрЛП(л_рез) + ?(л_рез,"",". err: " + л_отказ)  );
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
		
КонецПроцедуры

Функция ЗаписатьВГХ(л_тов,л_Длина,л_Ширина,л_Высота,л_Вес,л_Объем)
	
	отказ = "";
	
	еи_ссылка = ОбщегоНазначения.ПолучитьЗначениеРеквизита(л_тов,"ЕдиницаХраненияОстатков");
	
	Если ЗначениеЗаполнено(еи_ссылка) Тогда
		
		еи_параметры = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(еи_ссылка,"Вес,Объем,Длина,Ширина,Высота");
		
		з_Вес = СравнитьПараметры(еи_параметры.Вес, л_Вес);
		з_Объем = СравнитьПараметры(еи_параметры.Вес, л_Объем);
		
		з_Длина = СравнитьПараметры(еи_параметры.Длина, л_Длина);
		з_Ширина = СравнитьПараметры(еи_параметры.Ширина, л_Ширина);
		з_Высота = СравнитьПараметры(еи_параметры.Высота, л_Высота);
		
		Если з_Вес + з_Объем + з_Длина + з_Ширина + з_Высота > 0 Тогда
		
			Попытка
				
				еи_объект = еи_ссылка.ПолучитьОбъект();
				
				Если з_Вес > 0 Тогда
					еи_объект.Вес = л_Вес;
				КонецЕсли;
				 
				Если з_Объем > 0 Тогда
					еи_объект.Объем = л_Объем;
				КонецЕсли;
				
				Если з_Длина > 0 Тогда
					еи_объект.Длина = л_Длина;
				КонецЕсли;
				
				Если з_Ширина > 0 Тогда
					еи_объект.Ширина = л_Ширина;
				КонецЕсли;
				
				Если з_Высота > 0 Тогда
					еи_объект.Высота = л_Высота;
				КонецЕсли;
				
				еи_объект.ОбменДанными.Загрузка = Истина;
				еи_объект.Записать();
				
				Если з_Вес > 0 Тогда
					о_тов = л_тов.ПолучитьОбъект();
					о_тов.Вес = л_Вес;
					о_тов.ОбменДанными.Загрузка = Истина;
					о_тов.Записать();
				КонецЕсли;
				
			Исключение
				
				отказ = ОписаниеОшибки();
				
			КонецПопытки;
		
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат отказ;
	
КонецФункции

Функция СравнитьПараметры(пар_ТекущееЗначение, пар_НовоеЗначение)
	
	обновить = 1;
	
	Если пар_НовоеЗначение = 0 Тогда
		обновить = 0;
	Иначе
		Если пар_ТекущееЗначение > 0 Тогда
			Если пар_ТекущееЗначение = пар_НовоеЗначение Тогда
				обновить = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат обновить;
КонецФункции

Функция ВыполнитьЗапросВГХ(с_uid) экспорт
	
	тчРез =  Новый ТаблицаЗначений;
	
	CommandText = "
	|SELECT --top 100
	|	  
	|        ltrim(_adoGoods._UUID) as g_UUID
	|      --,_adoGoods._Description as g_Наименование

	|      --,_adoGoods._Manufacturer as g_Изготовитель
	|	   --,_adoManufacturers._Description as g_Изготовитель_Наименование
	|      --,_adoGoods._Article as g_Артикул
	|      
	|      --,_adoGoods._CreationDate as ДатаСоздания
	|      --,_adoGoods._IsActiveSales as ЕстьПродажи
	|      --,_adoGoods._IsActiveWarehouse as ЕстьОстатки
	|      --,_adoGoods._OriginalArticle as g_ОригинальныйАртикул
	|      --,_adoGoods._Comment as g_Комментарий
	|      --,_adoGoods._Multiplicity as g_Кратность
	|      --,_adoGoods._PackageType as g_ТипУпаковки
	|      --,_adoGoods._Reliability as g_Достоверность

	|      --,_Reference64._Description as gg_Наименование
	|      --,_Reference64._Fld93 as gg_Длина
	|      --,_Reference64._Fld94 as gg_Ширина
	|      --,_Reference64._Fld95 as gg_Высота
	|      --,_Reference64._Fld96 as gg_Вес
	|      --,_Reference64._Fld97 as gg_Объем
	|  	--,_Reference64._IDRRef as gg_UUID
	|    --,_Reference64._Version
	|    --,_Reference64._Marked
	|    --,_Reference64._PredefinedID
	|    --,_Reference64._ParentIDRRef as Родитель
	|    --,_Reference64._Code
	|    --,_Reference64._Fld196

	|      --,_adoUnits._Description as u_Наименование
	|    --,_adoUnits._Rate as u_Коэффициент
	|    --,_adoUnits._UUID as u_UUID
	|      --,_adoUnits._Length as u_Длина
	|      --,_adoUnits._Width as u_Ширина
	|      --,_adoUnits._Height as u_Высота
	|      --,_adoUnits._Weight as u_Вес
	|      --,_adoUnits._Volume as u_Объем
	|      --,_adoMeasureSources._Ident as u_ИсточникДанных
	|    --,_adoUnitsClassifier._Description as u_ЕдиницаПоКлассификатору
	| 
	|	  , CASE 
	|		 WHEN ISNULL(_adoUnits._Length,0) = 0 
	|		 THEN ISNULL(_Reference64._Fld93,0) 
	|		 ELSE ISNULL(_adoUnits._Length,0)
	|		END Длина  

	|	  , CASE 
	|		 WHEN ISNULL(_adoUnits._Width,0) = 0 
	|		 THEN ISNULL(_Reference64._Fld94,0) 
	|		 ELSE ISNULL(_adoUnits._Width,0)
	|		END Ширина  

	|	  , CASE 
	|		 WHEN ISNULL(_adoUnits._Height,0) = 0 
	|		 THEN ISNULL(_Reference64._Fld95,0) 
	|		 ELSE ISNULL(_adoUnits._Height,0)
	|		END Высота  

	|	  , CASE 
	|		 WHEN ISNULL(_adoUnits._Weight,0) = 0 
	|		 THEN ISNULL(_Reference64._Fld96,0) 
	|		 ELSE ISNULL(_adoUnits._Weight,0)
	|		END Вес  

	|	  , CASE 
	|		 WHEN ISNULL(_adoUnits._Volume,0) = 0 
	|		 THEN ISNULL(_Reference64._Fld97,0) 
	|		 ELSE ISNULL(_adoUnits._Volume,0)
	|		END Объем  
	| 
	|  FROM dbo._adoGoods _adoGoods WITH(NOLOCK)
	|	
	|	left join dbo._Reference64 _Reference64 WITH(NOLOCK)
	|	on _adoGoods._GoodsGroup = _Reference64._code

	|	left join dbo._adoUnits _adoUnits WITH(NOLOCK)
	|	on _adoGoods._Unit = _adoUnits._Key
	|	and _adoGoods._Key = _adoUnits._Owner

	|	left join dbo._adoMeasureSources _adoMeasureSources WITH(NOLOCK)
	|	on _adoUnits._MeasureSource = _adoMeasureSources._Key

	|	--left join dbo._adoUnitsClassifier _adoUnitsClassifier WITH(NOLOCK)
	|	--on _adoUnits._UnitByClassifier = _adoUnitsClassifier._Key

	|	--left join dbo._adoManufacturers _adoManufacturers WITH(NOLOCK)
	|	--on _adoGoods._Manufacturer = _adoManufacturers._Key

	|  WHERE
	|	_adoGoods._UUID in (" + СокрЛП(с_uid) + ")
	
		|and 
		|(
		|   CASE 
		|	 WHEN ISNULL(_adoUnits._Length,0) = 0 
		|	 THEN ISNULL(_Reference64._Fld93,0) 
		|	 ELSE ISNULL(_adoUnits._Length,0)
		|	END > 0  
		|	or
		|   CASE 
		|	 WHEN ISNULL(_adoUnits._Width,0) = 0 
		|	 THEN ISNULL(_Reference64._Fld94,0) 
		|	 ELSE ISNULL(_adoUnits._Width,0)
		|	END > 0  
		|	or
		|   CASE 
		|	 WHEN ISNULL(_adoUnits._Height,0) = 0 
		|	 THEN ISNULL(_Reference64._Fld95,0) 
		|	 ELSE ISNULL(_adoUnits._Height,0)
		|	END > 0
		|	or
		|   CASE 
		|	 WHEN ISNULL(_adoUnits._Weight,0) = 0 
		|	 THEN ISNULL(_Reference64._Fld96,0) 
		|	 ELSE ISNULL(_adoUnits._Weight,0)
		|	END > 0  
		|	or
		|   CASE 
		|	 WHEN ISNULL(_adoUnits._Volume,0) = 0 
		|	 THEN ISNULL(_Reference64._Fld97,0) 
		|	 ELSE ISNULL(_adoUnits._Volume,0)
		|	END > 0  
		|)
	
	|";
	
	Попытка
//	    Подключение_к_SQL_серверу_2();
		ВыборкаSQL_2.Open(CommandText, СоединениеSQL_2);
		
		Если тчРез.Колонки.Количество() = 0 тогда
			Для ii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				инд_К = "p"+СокрЛП(ii);
				имя_К = инд_К;
				Если ii > 0 тогда
					тчРез.Колонки.Добавить(инд_К,Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
				Иначе
					тчРез.Колонки.Добавить(инд_К,Новый ОписаниеТипов("Строка"	, Новый КвалификаторыСтроки(36, ДопустимаяДлина.Переменная)));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Счр = 0;
		Пока не ВыборкаSQL_2.eof() Цикл
			Счр = Счр + 1;
			
			НоваяСтрока = тчРез.Добавить();
			Для iii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				Если iii > 0 тогда
					НоваяСтрока.Установить(iii,Число(ВыборкаSQL_2.Fields(iii).Value));
				Иначе
					НоваяСтрока.Установить(iii,Строка(ВыборкаSQL_2.Fields(iii).Value));
				КонецЕсли;
			КонецЦикла;
			
			ВыборкаSQL_2.MoveNext();
		КонецЦикла;
		
		ВыборкаSQL_2.Close();
//		ЗакрытьСеансПодключенияКSQL_2();
	Исключение
		СообщитьЛог("err: Ошибка запроса "+ Символы.ПС +СокрЛП(CommandText) + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат тчРез;
КонецФункции

Процедура СообщитьЛог(пар_стр, промежуточная = Истина)
	
	Если ЭтоФон Тогда
		
		ПравилаИгры_ИмяЛогФайлаПолное = ПолучитьИмяФайлаДляЛогирования(ИмяЛогФайлаПолное);
		
		Если ЗначениеЗаполнено(ИтогоЛог) Тогда
			ИтогоЛог = ИтогоЛог + Символы.ПС + пар_стр;
		Иначе
			ИтогоЛог = пар_стр;
		КонецЕсли;
		
		записатьвфайл = Ложь;
		Если промежуточная Тогда
			Если СтрЧислоСтрок(ИтогоЛог) > 300 Тогда
				записатьвфайл = Истина;
			КонецЕсли;
		Иначе
			записатьвфайл = Истина;
		КонецЕсли;
		
		Если записатьвфайл Тогда
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
		    кодировка = "UTF8";
			
		    МассивФайлов = НайтиФайлы(ПравилаИгры_ИмяЛогФайлаПолное);        
		    Если МассивФайлов.Количество() > 0 тогда        
		        ТекстовыйДокумент.Прочитать(ПравилаИгры_ИмяЛогФайлаПолное,кодировка);            
				
				УдалитьФайлы(ПравилаИгры_ИмяЛогФайлаПолное);
			КонецЕсли;
		    ТекстовыйДокумент.ДобавитьСтроку(ИтогоЛог);
		    ТекстовыйДокумент.Записать(ПравилаИгры_ИмяЛогФайлаПолное,кодировка);

			ИтогоЛог = "";
		КонецЕсли;
		
		Если Найти(пар_стр,"err") > 0 тогда
			
			ПравилаИгры_РеглЗаданиеНаИсполнение = Справочники.РегламентныеЗадания.НайтиПоКоду("000000458");
			ПравилаИгры_Аларм_Источник = Справочники.СобытияДляОтправкиЭлектронныхПисем.ЗагрузкаВГХ;
			ПравилаИгры_Аларм_Заголовок = "Загрузка данных ВГХ из НСИ";
			ПравилаИгры_Аларм_Содержимое = пар_стр;
			
			Попытка
				КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(
				ПравилаИгры_РеглЗаданиеНаИсполнение, 
				ПравилаИгры_Аларм_Источник,
				ПравилаИгры_Аларм_Заголовок,
				,
				Истина,
				ПравилаИгры_Аларм_Содержимое,
				"Обработки.ПолучитьВГХ");
			Исключение
				РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(ПравилаИгры_Аларм_Источник,ПравилаИгры_Аларм_Содержимое,ПравилаИгры_Аларм_Заголовок);	
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		Сообщить(пар_стр);		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИмяФайлаДляЛогирования(пар_Имя) Экспорт
	
	л_Имя = пар_Имя;
	
	Если НЕ ЗначениеЗаполнено(л_Имя) Тогда
		
		лДтВрм = ТекущаяДата();
		
		ПравилаИгры_метка = СокрЛП( Формат( ДеньГода(лДтВрм) , "ЧЦ=3; ЧДЦ=; ЧВН=")) + "_" +
								 РазвернутьДатуВстроку(лДтВрм) + "_" + 
								 СокрЛП(Формат(Час(лДтВрм),"ЧЦ=2; ЧДЦ=; ЧВН=; ЧГ=0")) + 
								 СокрЛП(Формат(Минута(лДтВрм),"ЧЦ=2; ЧДЦ=; ЧВН=; ЧГ=0")) + 
								 СокрЛП(Формат(Секунда(лДтВрм),"ЧЦ=2; ЧДЦ=; ЧВН=; ЧГ=0")) + "_" + 
								 СокрЛП(УбратьТОчкиИПробелы(СтрокаСоединенияИнформационнойБазы())) + "_" +
								 СокрЛП(УбратьТОчкиИПробелы(Строка(ПараметрыСеанса.ТекущийПользователь.Код)));		
		
		л_Имя = "\\Srv1c-nn\1C_exch\ASTOR_1C\push\Log\"+ "1с83_ЗагрузкаВГХ_" + ПравилаИгры_метка + ".txt";	
		
		ИмяЛогФайлаПолное = л_Имя;
	КонецЕсли;
	
	Возврат л_Имя;
	
КонецФункции

Функция УбратьТОчкиИПробелы(пстр)
	
	пстр = СтрЗаменить(пстр,".","");
	пстр = СтрЗаменить(пстр," ","");
	
	пстр = СтрЗаменить(пстр,";","_");
	пстр = СтрЗаменить(пстр,"""","");
	
	пстр = СтрЗаменить(пстр,"(","");
	пстр = СтрЗаменить(пстр,")","");
	
	Возврат пстр;
КонецФункции

Функция РазвернутьДатуВстроку(выбД,Разд="") 
	СД = "";
	ГД = Год(выбД);
	МД = Месяц(выбД);
	ДД = День(выбД);
	СД = СокрЛП(Формат(ГД, "ЧЦ=4; ЧН=; ЧВН=; ЧГ="))+Разд+СокрЛП(Формат(МД, "ЧЦ=2; ЧН=; ЧВН="))+Разд+СокрЛП(Формат(ДД, "ЧЦ=2; ЧН=; ЧВН="));
	
	Возврат СД;
КонецФункции

Процедура ВыполнитьРегламентноеЗадание() Экспорт
	
	//ЭтоФон = Истина;
	
	Если Номенклатура.Количество() = 0 Тогда
		ЗаполнитьСписокНоменклатуры();
	КонецЕсли;
		
	ПолучитьДанныеВГХ();
	
КонецПроцедуры

Процедура ЗаполнитьСписокНоменклатуры()
	
	Если НомерСценария = 1 Тогда
		ОпроситьОстаткиПоЗаявкам();
		
	ИначеЕсли НомерСценария = 2 Тогда
		ОпроситьОборотыПоЗаявкам();
		
	ИначеЕсли НомерСценария = 3 Тогда
		ОпроситьТаблицуЛогов();
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ОпроситьОстаткиПоЗаявкам() Экспорт       
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ различные ПЕРВЫЕ " + МаксимальныйРазмерВыборки + "
	|	ЗаявкиПокупателейОстатки.Номенклатура
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Остатки КАК ЗаявкиПокупателейОстатки
	|ГДЕ
	|	
	|	ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Вес + ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Объем + ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Длина + ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Ширина + ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Высота = 0
	|	
	|	И НЕ ЗаявкиПокупателейОстатки.Номенклатура В
	|				(ВЫБРАТЬ
	|					ОшибкиЗагрузкиВГХСрезПоследних.Номенклатура
	|				ИЗ
	|					РегистрСведений.ОшибкиЗагрузкиВГХ.СрезПоследних КАК ОшибкиЗагрузкиВГХСрезПоследних)
	|	И НЕ ЗаявкиПокупателейОстатки.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ЗаявкиПокупателейОстатки.КоличествоОстаток > 0";

	Номенклатура.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура"));	
	
КонецПроцедуры

Процедура ОпроситьОборотыПоЗаявкам() Экспорт       
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ " + МаксимальныйРазмерВыборки + "
	|	ЗаявкиПокупателейОбороты.Номенклатура
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Обороты(&ДтН, &ДтК, , ) КАК ЗаявкиПокупателейОбороты
	|ГДЕ	
	|	ЗаявкиПокупателейОбороты.Номенклатура.ЕдиницаХраненияОстатков.Вес + ЗаявкиПокупателейОбороты.Номенклатура.ЕдиницаХраненияОстатков.Объем + ЗаявкиПокупателейОбороты.Номенклатура.ЕдиницаХраненияОстатков.Длина + ЗаявкиПокупателейОбороты.Номенклатура.ЕдиницаХраненияОстатков.Ширина + ЗаявкиПокупателейОбороты.Номенклатура.ЕдиницаХраненияОстатков.Высота = 0
	|	И НЕ ЗаявкиПокупателейОбороты.Номенклатура В
	|				(ВЫБРАТЬ
	|					ОшибкиЗагрузкиВГХСрезПоследних.Номенклатура
	|				ИЗ
	|					РегистрСведений.ОшибкиЗагрузкиВГХ.СрезПоследних КАК ОшибкиЗагрузкиВГХСрезПоследних)
	|	И НЕ ЗаявкиПокупателейОбороты.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)";

	Запрос.УстановитьПараметр("ДтК", ТекущаяДата());
	Запрос.УстановитьПараметр("ДтН", НачалоДня(ТекущаяДата()));
	Результат = Запрос.Выполнить();

	Номенклатура.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура"));	
	
КонецПроцедуры

Процедура ОпроситьТаблицуЛогов() Экспорт
	
	Если НЕ Подключение_к_SQL_серверу_2() Тогда
		Возврат;
	КонецЕсли;
	
	Если МаксимальныйРазмерВыборки = 0 Тогда
		МаксимальныйРазмерВыборки = 100;
	КонецЕсли;
	
	тчСвязки = ПолучитьСвязкиЛогиЕИ();
	
	тчТовары = ПолучитьВладельцевЕИ(тчСвязки);
	
	идТовары = "";
	мсТовары = новый Массив;
	Для каждого стр из тчТовары Цикл
		Если ЗначениеЗаполнено(ОбщегоНазначения.ПолучитьЗначениеРеквизита(стр.Номенклатура,"Код")) = Истина Тогда
			мсТовары.Добавить(стр.Номенклатура);
			идТовары = идТовары + "'" + СокрЛП(стр.p0) + "',";
		КонецЕсли;
	КонецЦикла;
	Номенклатура.ЗагрузитьЗначения(мсТовары);	
	
	ЗапомнитьНайденнуюНоменклатуру(идТовары);
	
	ЗапомнитьОбработанныеЛоги(тчСвязки);
	
	ЗакрытьСеансПодключенияКSQL_2();
	
КонецПроцедуры

Функция  ПолучитьСвязкиЛогиЕИ()
	
	тчРез =  Новый ТаблицаЗначений;
	
	CommandText =
			 "
			|  SELECT top " + Формат(МаксимальныйРазмерВыборки,"ЧЦ=15; ЧДЦ=0; ЧГ=0") + "
			|	  l._Key,
			|	  l._Object
			|  FROM dbo._adoLog l
			|  left join _adoLog_Ext e on l._Key = e._Object
			|  where l._TableId = 6443928 -- _adoUnits
			|  and l._DateTime >  DATEADD(day, -1, GETDATE())
			|  and isnull(e._Object,0) = 0
			|  order by l._DateTime
			|";
	
	Попытка
		ВыборкаSQL_2.Open(CommandText, СоединениеSQL_2);
		
		Если тчРез.Колонки.Количество() = 0 тогда
			Для ii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				инд_К = "p"+СокрЛП(ii);
				имя_К = инд_К;
				тчРез.Колонки.Добавить(инд_К,Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,0)));
			КонецЦикла;
		КонецЕсли;
		
		Счр = 0;
		Пока не ВыборкаSQL_2.eof() Цикл
			Счр = Счр + 1;
			
			НоваяСтрока = тчРез.Добавить();
			Для iii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				НоваяСтрока.Установить(iii,Число(ВыборкаSQL_2.Fields(iii).Value));
			КонецЦикла;
			
			ВыборкаSQL_2.MoveNext();
		КонецЦикла;
		
		ВыборкаSQL_2.Close();
	Исключение
		СообщитьЛог("err: Ошибка запроса "+ Символы.ПС +СокрЛП(CommandText) + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат тчРез;
КонецФункции

Функция ПолучитьВладельцевЕИ(тчСвязки)
	
	тчРез =  Новый ТаблицаЗначений;
	
	стр_ключи_ЕИ = "";
	Для каждого стр из тчСвязки Цикл
		стр_ключи_ЕИ = стр_ключи_ЕИ + Формат(стр.p1,"ЧЦ=15; ЧДЦ=0; ЧГ=0") + ",";
	КонецЦикла;
	стр_ключи_ЕИ = Лев(стр_ключи_ЕИ,СтрДлина(стр_ключи_ЕИ)-1);
	
	CommandText =
	"select
	|    UPPER(t._UUID) as Goods_UUID
	|from
	|	_adoGoods t
	|inner join
	|	 (	
	|		SELECT distinct 
	|		    u._Owner as Goods_Key
	|		FROM _adoUnits u
	|		where u._Key in (" + стр_ключи_ЕИ + ") 
	//|			and  (u._Length +  u._Width +  u._Height +  u._Weight + u._Volume) > 0
	|    ) as o
	|on t._Key = o.Goods_Key";
	
	Попытка
		ВыборкаSQL_2.Open(CommandText, СоединениеSQL_2);
		
		Если тчРез.Колонки.Количество() = 0 тогда
			Для ii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				инд_К = "p"+СокрЛП(ii);
				имя_К = инд_К;
				Если ii > 0 тогда
					тчРез.Колонки.Добавить(инд_К,Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,3)));
				Иначе
					тчРез.Колонки.Добавить(инд_К,Новый ОписаниеТипов("Строка"	, Новый КвалификаторыСтроки(36, ДопустимаяДлина.Переменная)));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Счр = 0;
		Пока не ВыборкаSQL_2.eof() Цикл
			Счр = Счр + 1;
			
			НоваяСтрока = тчРез.Добавить();
			Для iii = 0 ПО ВыборкаSQL_2.Fields.Count-1 Цикл
				Если iii > 0 тогда
					НоваяСтрока.Установить(iii,Число(ВыборкаSQL_2.Fields(iii).Value));
				Иначе
					НоваяСтрока.Установить(iii,Строка(ВыборкаSQL_2.Fields(iii).Value));
				КонецЕсли;
			КонецЦикла;
			
			ВыборкаSQL_2.MoveNext();
		КонецЦикла;
		
		ВыборкаSQL_2.Close();
	Исключение
		СообщитьЛог("err: Ошибка запроса "+ Символы.ПС +СокрЛП(CommandText) + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
	тчРез.Колонки.Добавить("Номенклатура",	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	
	Для каждого стр из тчРез Цикл
		стр.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(новый УникальныйИдентификатор(стр.p0));
	КонецЦикла;
	
	//сообщить(CommandText);
	//тчРез.ВыбратьСтроку();
	
	Возврат тчРез;
КонецФункции

Процедура ЗапомнитьОбработанныеЛоги(тчСвязки)
	
	Отказ = "";
	
	стр_ключи_логов = "";
	Для каждого стр из тчСвязки Цикл
		стр_ключи_логов = стр_ключи_логов + Формат(стр.p0,"ЧЦ=15; ЧДЦ=0; ЧГ=0") + ",";
	КонецЦикла;
	стр_ключи_логов = Лев(стр_ключи_логов,СтрДлина(стр_ключи_логов)-1);
	
	КомандаSQL_2_CommandText = "	
								|insert into
								|	dbo._adoLog_Ext
								|select
								|	_Key _Object,
								|	GETDATE() _DateTime
								|from
								|	_adoLog
								|where
								|	_Key IN (" + стр_ключи_логов + ")
							  |";	
	
	Попытка
		КомандаSQL_2.CommandText = КомандаSQL_2_CommandText;
		КомандаSQL_2.Execute();	
	Исключение
		Отказ = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗапомнитьНайденнуюНоменклатуру(идТовары)
	
	Отказ = "";
	
	Если НЕ ЗначениеЗаполнено(идТовары) Тогда
		Возврат;
	КонецЕсли;
	
	КомандаSQL_2_CommandText = "	
								|insert into
								|	dbo._adoLog_Ext2
								|select
								|	_Key _Object,
								|	GETDATE() _DateTime
								|from
								|	_adoGoods
								|where
								|	_UUID IN (" + Лев(идТовары,СтрДлина(идТовары)-1) + ")
							  |";	
	
	Попытка
		КомандаSQL_2.CommandText = КомандаSQL_2_CommandText;
		КомандаSQL_2.Execute();	
	Исключение
		Отказ = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры