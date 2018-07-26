﻿
Функция ПолучитьМетаданные()
	Возврат Метаданные.ПланыОбмена.ОбменПартКом83_Сайт_остатки_на_складах;
КонецФункции

Функция URIПространстваИмен() 
	//Возврат "http://ws-02.part-kom.ru/partkom83/hs/SiteExchange/XMLSchema";	
	Возврат ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
КонецФункции

Функция ВыгрузитьСообщениеОбмена_ОстаткиНоменклатуры(вхИдентификаторУзлаОбмена, вхНомерПринятого) Экспорт
	
	лОтправитель = ЭтотУзел();
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(лИсходящий) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	// фиксируем номер принятого
	Если НЕ лИсходящий.НомерПринятого = вхНомерПринятого Тогда
		
		//ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, вхНомерПринятого);
		
		Попытка
			ОбъектУзла = лИсходящий.ПолучитьОбъект();
			ОбъектУзла.НомерПринятого = вхНомерПринятого;
			ОбъектУзла.Записать();
			
			ДтВрмПодтверждения = ТекущаяДата();
			
			НаборЗаписи  = РегистрыСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом.СоздатьНаборЗаписей();
			НаборЗаписи.Отбор.ReceivedNo.Установить(вхНомерПринятого);
			НаборЗаписи.Прочитать();
			Для каждого Запись Из НаборЗаписи Цикл
				Запись.Подтвержден = Истина;
				Запись.ДтВрм_Подтверждения = ДтВрмПодтверждения;	
			КонецЦикла;		
			НаборЗаписи.Записать();
			
		Исключение
			ВызватьИсключение "Возникла ошибка при изменении номеров сообщений обмена: ";
		Конецпопытки;
	КонецЕсли;
	
	
	
	лТипОбъектаXDTO = ФабрикаXDTO.Тип(URIПространстваИмен(), "РегистрыНакопления.ТоварныеОстатки");
	лТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	лПустышка = Новый ЗаписьXML;
	лПустышка.УстановитьСтроку("utf-8");
	лЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	лЗаписьСообщения.НачатьЗапись(лПустышка, лИсходящий);
	лНомерСообщения = лЗаписьСообщения.НомерСообщения;
	
	Попытка
		
		// сформируем посылку
		лСообщениеОбмена = ФабрикаXDTO.Создать(лТипСообщениеОбмена);
		лСообщениеОбмена.ПланОбмена = "ОбменПартКом83_Сайт_остатки_на_складах";
		лСообщениеОбмена.Отправитель = лОтправитель.ИдентификаторУзла;
		лСообщениеОбмена.Получатель = вхИдентификаторУзлаОбмена;
		лСообщениеОбмена.НомерСообщения = лНомерСообщения;
		лСообщениеОбмена.НомерПринятого = вхНомерПринятого;
		
		лОбъекты = ФабрикаXDTO.Создать(лТипОбъекты);
		лСписокОбъектов = лОбъекты.ПолучитьСписок("Объект");
		
		// передадим справочные данные, зарегистрированные к обмену
		////////////лВыгружаемыеОбъекты = ОбменДаннымиКлиентСервер.ВыбратьПакетИзмененийДляУзлаОбмена(лИсходящий, лСообщениеОбмена.НомерСообщения, 1000);
		////////////Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты цикл
		////////////	лМенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лЭлементСоответствия.Ключ);
		////////////	лВыгруженныеОбъекты = лМенеджерОбъекта.ВыгрузитьЭлементы(лЭлементСоответствия.Значение, ПолучитьМетаданные());
		////////////	Для Каждого лВыгруженныйОбъект Из лВыгруженныеОбъекты цикл
		////////////		лСписокОбъектов.Добавить(лВыгруженныйОбъект);
		////////////	КонецЦикла;
		////////////КонецЦикла;
		
		// передадим расчетные данные, в данном случае это изменения по товарным остаткам, включая VMI
		ДтВрм = ТекущаяДата();
		РезультатАнализа = РассчитатьПакетИзмененийДляУзлаОбмена_ТоварныеОстатки(вхНомерПринятого, ДтВрм);
		КоличествоПакетов = РезультатАнализа.Количество();
		ТаблицаОстатков = РезультатАнализа[КоличествоПакетов - 2].Выгрузить();
		ТаблицаЗаписейНаУдаление = РезультатАнализа[КоличествоПакетов - 1].Выгрузить();
		///////////ТаблицаОшибокVMI = РезультатАнализа[КоличествоПакетов - 1].Выгрузить();
		
		Если ТаблицаОстатков.Количество() > 0 тогда
			
			НаборЗаписи  = РегистрыСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом.СоздатьНаборЗаписей();
			НаборЗаписи.Отбор.ReceivedNo.Установить(лНомерСообщения);
			НаборЗаписи.Прочитать();
			НаборЗаписи.Очистить(); 
			
			Для Каждого лЭлементСоответствия Из ТаблицаОстатков цикл
				лНоменклатура = лЭлементСоответствия.Номенклатура;
				лПрайс = лЭлементСоответствия.ПрайсПоставщика;
				
				// уложим результат запроса согласно структуре пакета
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				лОбъект.Номенклатура = лНоменклатура.УникальныйИдентификатор();
				лОбъект.ПрайсПоставщика = лПрайс.УникальныйИдентификатор();
				//PaSe - отрицательные остатки сайт некорректно воспринимает//
				лОбъект.СвободныйОстатокКоличество = ?(лЭлементСоответствия.СвободныйОстатокКоличество > 0, лЭлементСоответствия.СвободныйОстатокКоличество, 0);
				лОбъект.МинимальнаяПартияКоличество = 1;
				лОбъект.Цена = лЭлементСоответствия.Цена;
				
				лСписокОбъектов.Добавить(лОбъект);
				
				// запомним содержимое посылки
				Наб = НаборЗаписи.Добавить();
				Наб.ReceivedNo = лНомерСообщения;
				Наб.Номенклатура = лНоменклатура;
				Наб.ПрайсПоставщика = лПрайс;
				Наб.СвободныйОстатокКоличество = лЭлементСоответствия.СвободныйОстатокКоличество;
				Наб.МинимальнаяПартияКоличество = 1;
				Наб.Цена = лЭлементСоответствия.Цена;
				Наб.ДтВрм_Расчета = ДтВрм;
				Наб.ДтВрм_Посылки = ТекущаяДата();
				
			КонецЦикла;
			
			НаборЗаписи.Записать();
		КонецЕсли;
		
		// очистим историю по содержимому предыдущих посылок
		Если ТаблицаЗаписейНаУдаление.Количество() > 0 тогда
			Рег = РегистрыСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом;
			НЗ = Рег.СоздатьНаборЗаписей();
			Для каждого стрт из ТаблицаЗаписейНаУдаление цикл
				НЗ.Отбор.ReceivedNo.Установить(стрт.ReceivedNo);
				НЗ.Отбор.Номенклатура.Установить(стрт.Номенклатура);
				НЗ.Отбор.ПрайсПоставщика.Установить(стрт.ПрайсПоставщика);
				НЗ.Очистить();
				НЗ.Записать();
			КонецЦикла;
		КонецЕсли;
		
		
		////////Если ТаблицаОшибокVMI.Количество() > 0 тогда
		////////	ТекстОшибокVMI = "";
		////////	
		////////	cxcxcxcx = 0;
		////////	Для каждого стро из ТаблицаОшибокVMI цикл
		////////		cxcxcxcx = cxcxcxcx + 1;
		////////		
		////////		ТекстОшибокVMI = ТекстОшибокVMI + Символы.ПС  
		////////		+ СокрлП(cxcxcxcx)
		////////		//+ ". Описание: " + стро.ДляОтправкиПоEmail
		////////		+ ", ТТ: [" + СокрЛП(стро.ТорговаяТочка.Код) + "]" + СокрЛП(стро.ТорговаяТочка.Наименование) + Символы.ПС
		////////		+ ", Склад: ["  + СокрЛП(стро.Склад.Код) + "]" + СокрЛП(стро.Склад.Наименование) + Символы.ПС
		////////		+ ", Номенклатура: ["  + СокрЛП(стро.Номенклатура.Код) + "]" + СокрЛП(стро.Номенклатура.Наименование)  + Символы.ПС
		////////		+ ", Количество: [" + СокрЛП(стро.КоличествоОстаток) + "]" + Символы.ПС
		////////		;
		////////	КонецЦикла;
		////////	
		////////	Если НЕ ПустаяСтрока(ТекстОшибокVMI) Тогда
		////////		ТекстОшибокУИД = "Описание: при выгрузке данных по товарным остаткам на сайт Не найдена запись в спр.Прайсы Поставщиков."  
		////////					   + Символы.ПС 
		////////					   + Символы.ПС 
		////////					   + ТекстОшибокУИД;
		////////		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаVMI,ТекстОшибокVMI, "Ошибки VMI");
		////////	КонецЕсли;
		////////КонецЕсли;
		
		// все объекты добавлены, заканчиваем формировать сообщение
		лСообщениеОбмена.Объекты = лОбъекты;
		лЗаписьСообщения.ЗакончитьЗапись();
		
	Исключение
		лЗаписьСообщения.ПрерватьЗапись();
		ВызватьИсключение ;
	КонецПопытки;
	
	// уложим данные в хml
	Тест = Ложь;
	лЗаписьХМЛ = Новый ЗаписьXML;
	Если Тест тогда
		Файл = ПолучитьИмяВременногоФайла("xml"); 
		лЗаписьХМЛ.ОткрытьФайл(Файл);
		ФабрикаXDTO.ЗаписатьXML(лЗаписьХМЛ, лСообщениеОбмена, "ost");
		Сообщить(Файл);
	Иначе
		лЗаписьХМЛ.УстановитьСтроку("utf-8");
		лЗаписьХМЛ.ЗаписатьОбъявлениеXML();
		ФабрикаXDTO.ЗаписатьXML(лЗаписьХМЛ, лСообщениеОбмена);
	КонецЕсли;
	
	Возврат лЗаписьХМЛ.Закрыть();	
КонецФункции

Функция РассчитатьПакетИзмененийДляУзлаОбмена_ТоварныеОстатки(лНомерПринятого, ДтВрм) Экспорт
	
Запрос = Новый Запрос;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.Номенклатура,
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.ПрайсПоставщика,
	|	МАКСИМУМ(ОстаткиНоменклатурыДляПланаОбменаССайтом.ReceivedNo) КАК ReceivedNo
	|ПОМЕСТИТЬ СрезПоследнихПоНомеруПосылки
	|ИЗ
	|	РегистрСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом КАК ОстаткиНоменклатурыДляПланаОбменаССайтом
	|ГДЕ
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.Подтвержден = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.Номенклатура,
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.ПрайсПоставщика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СрезПоследнихПоНомеруПосылки.Номенклатура,
	|	СрезПоследнихПоНомеруПосылки.ПрайсПоставщика,
	|	СрезПоследнихПоНомеруПосылки.ReceivedNo,
	|	ЕСТЬNULL(ОстаткиНоменклатурыДляПланаОбменаССайтом.СвободныйОстатокКоличество, 0) КАК СвободныйОстатокКоличество,
	|	ЕСТЬNULL(ОстаткиНоменклатурыДляПланаОбменаССайтом.Цена, 0) КАК Цена
	|ПОМЕСТИТЬ ДанныеСайта
	|ИЗ
	|	СрезПоследнихПоНомеруПосылки КАК СрезПоследнихПоНомеруПосылки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом КАК ОстаткиНоменклатурыДляПланаОбменаССайтом
	|		ПО СрезПоследнихПоНомеруПосылки.ReceivedNo = ОстаткиНоменклатурыДляПланаОбменаССайтом.ReceivedNo
	|			И СрезПоследнихПоНомеруПосылки.Номенклатура = ОстаткиНоменклатурыДляПланаОбменаССайтом.Номенклатура
	|			И СрезПоследнихПоНомеруПосылки.ПрайсПоставщика = ОстаткиНоменклатурыДляПланаОбменаССайтом.ПрайсПоставщика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СрезПоследнихПоНомеруПосылки.ПрайсПоставщика,
	|	СрезПоследнихПоНомеруПосылки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.ReceivedNo,
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.Номенклатура,
	|	ОстаткиНоменклатурыДляПланаОбменаССайтом.ПрайсПоставщика
	|ПОМЕСТИТЬ НаборЗаписейНаУдалениеВИсторииПосылок
	|ИЗ
	|	РегистрСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом КАК ОстаткиНоменклатурыДляПланаОбменаССайтом
	|		ЛЕВОЕ СОЕДИНЕНИЕ СрезПоследнихПоНомеруПосылки КАК СрезПоследнихПоНомеруПосылки
	|		ПО ОстаткиНоменклатурыДляПланаОбменаССайтом.ReceivedNo = СрезПоследнихПоНомеруПосылки.ReceivedNo
	|			И ОстаткиНоменклатурыДляПланаОбменаССайтом.Номенклатура = СрезПоследнихПоНомеруПосылки.Номенклатура
	|			И ОстаткиНоменклатурыДляПланаОбменаССайтом.ПрайсПоставщика = СрезПоследнихПоНомеруПосылки.ПрайсПоставщика
	|ГДЕ
	|	(СрезПоследнихПоНомеруПосылки.ReceivedNo ЕСТЬ NULL
	|			ИЛИ СрезПоследнихПоНомеруПосылки.Номенклатура ЕСТЬ NULL
	|			ИЛИ СрезПоследнихПоНомеруПосылки.ПрайсПоставщика ЕСТЬ NULL)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрайсыПоставщиков.Ссылка,
	|	ПрайсыПоставщиков.Владелец,
	|	ПрайсыПоставщиков.Склад
	|ПОМЕСТИТЬ Прайсы
	|ИЗ
	|	Справочник.ПрайсыПоставщиков КАК ПрайсыПоставщиков
	|ГДЕ
	|	НЕ ПрайсыПоставщиков.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	И ПрайсыПоставщиков.Склад.ВыгружатьНаСайт = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартииТоваровОстатки.Номенклатура,
	|	ПартииТоваровОстатки.Склад,
	|	ПартииТоваровОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ПОМЕСТИТЬ ТоварныеОстаткиСвои
	|ИЗ
	|	РегистрНакопления.ПартииТоваров.Остатки(
	|			&ДтВрм,
	|			НЕ Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				И Склад В
	|					(ВЫБРАТЬ
	|						Прайсы.Склад
	|					ИЗ
	|						Прайсы
	|					ГДЕ
	|						НЕ Прайсы.Склад.СкладVMI)
	|				И НЕ СтрокаПрихода = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка)) КАК ПартииТоваровОстатки
	|ГДЕ
	|	ПартииТоваровОстатки.КоличествоОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартииТоваровОстатки.Номенклатура,
	|	ПартииТоваровОстатки.Склад,
	|	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка.Владелец КАК Поставщик,
	|	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка КАК ТТпоставщика,
	|	СУММА(ПартииТоваровОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ТоварныеОстаткиVMI
	|ИЗ
	|	РегистрНакопления.ПартииТоваров.Остатки(
	|			&ДтВрм,
	|			НЕ Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				И Склад В
	|					(ВЫБРАТЬ
	|						Прайсы.Склад
	|					ИЗ
	|						Прайсы
	|					ГДЕ
	|						Прайсы.Склад.СкладVMI)
	|				И НЕ СтрокаПрихода = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокПриходов.ПустаяСсылка)
	|				И НЕ ЕСТЬNULL(СтрокаПрихода.ТорговаяТочка.Владелец, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК ПартииТоваровОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ПартииТоваровОстатки.Номенклатура,
	|	ПартииТоваровОстатки.Склад,
	|	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка.Владелец,
	|	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка
	|
	|ИМЕЮЩИЕ
	|	СУММА(ПартииТоваровОстатки.КоличествоОстаток) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПартииТоваровОстатки.Номенклатура,
	|	ПартииТоваровОстатки.Склад,
	|	ПартииТоваровОстатки.СтрокаПрихода.ТорговаяТочка.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезервыТоваровОстатки.Номенклатура,
	|	РезервыТоваровОстатки.Склад,
	|	РезервыТоваровОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ПОМЕСТИТЬ РезервыCвои
	|ИЗ
	|	РегистрНакопления.РезервыТоваров.Остатки(
	|			&ДтВрм,
	|			НЕ Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				И Склад В
	|					(ВЫБРАТЬ
	|						Прайсы.Склад
	|					ИЗ
	|						Прайсы
	|					ГДЕ
	|						НЕ Прайсы.Склад.СкладVMI)) КАК РезервыТоваровОстатки
	|ГДЕ
	|	РезервыТоваровОстатки.КоличествоОстаток > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	РезервыТоваровОстатки.Номенклатура,
	|	РезервыТоваровОстатки.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезервыТоваровОстатки.Номенклатура,
	|	РезервыТоваровОстатки.Склад,
	|	РезервыТоваровОстатки.СтрокаЗаявки.Поставщик КАК Поставщик,
	|	СУММА(РезервыТоваровОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ РезервыVMI
	|ИЗ
	|	РегистрНакопления.РезервыТоваров.Остатки(
	|			&ДтВрм,
	|			НЕ Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|				И Склад В
	|					(ВЫБРАТЬ
	|						Прайсы.Склад
	|					ИЗ
	|						Прайсы
	|					ГДЕ
	|						Прайсы.Склад.СкладVMI)
	|				И НЕ СтрокаЗаявки = ЗНАЧЕНИЕ(Справочник.ИдентификаторыСтрокЗаявок.ПустаяСсылка)
	|				И НЕ ЕСТЬNULL(СтрокаЗаявки.Поставщик, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК РезервыТоваровОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РезервыТоваровОстатки.Номенклатура,
	|	РезервыТоваровОстатки.Склад,
	|	РезервыТоваровОстатки.СтрокаЗаявки.Поставщик
	|
	|ИМЕЮЩИЕ
	|	СУММА(РезервыТоваровОстатки.КоличествоОстаток) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	РезервыТоваровОстатки.Номенклатура,
	|	РезервыТоваровОстатки.Склад,
	|	РезервыТоваровОстатки.СтрокаЗаявки.Поставщик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварныеОстаткиСвои.Номенклатура,
	|	ТоварныеОстаткиСвои.Склад,
	|	ТоварныеОстаткиСвои.КоличествоОстаток - ЕСТЬNULL(РезервыCвои.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ПОМЕСТИТЬ СвойТовар
	|ИЗ
	|	ТоварныеОстаткиСвои КАК ТоварныеОстаткиСвои
	|		ЛЕВОЕ СОЕДИНЕНИЕ РезервыCвои КАК РезервыCвои
	|		ПО ТоварныеОстаткиСвои.Склад = РезервыCвои.Склад
	|			И ТоварныеОстаткиСвои.Номенклатура = РезервыCвои.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТоварныеОстаткиСвои.Номенклатура,
	|	ТоварныеОстаткиСвои.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СвободныйОстаток.Номенклатура,
	|	СвободныйОстаток.Склад,
	|	СвободныйОстаток.ТТпоставщика,
	|	СвободныйОстаток.Поставщик,
	|	СвободныйОстаток.КоличествоОстаток - ЕСТЬNULL(РезервыVMI.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ТоварVMI
	|ИЗ
	|	ТоварныеОстаткиVMI КАК СвободныйОстаток
	|		ЛЕВОЕ СОЕДИНЕНИЕ РезервыVMI КАК РезервыVMI
	|		ПО СвободныйОстаток.Склад = РезервыVMI.Склад
	|			И СвободныйОстаток.Номенклатура = РезервыVMI.Номенклатура
	|			И СвободныйОстаток.Поставщик = РезервыVMI.Поставщик
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СвободныйОстаток.Номенклатура,
	|	СвободныйОстаток.Склад,
	|	СвободныйОстаток.ТТпоставщика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена
	|ПОМЕСТИТЬ Цены
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&ДтВрм,
	|			Номенклатура В
	|					(ВЫБРАТЬ
	|						СвойТовар.Номенклатура
	|					ИЗ
	|						СвойТовар)
	|				И ТипЦен = &ТипЦенДляСайта) КАК ЦеныНоменклатурыСрезПоследних
	|ГДЕ
	|	ЦеныНоменклатурыСрезПоследних.Цена > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(ЦеныНоменклатурыКонтрагентовСрезПоследних.Цена) КАК Цена,
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура.Владелец
	|ПОМЕСТИТЬ ЦеныКА
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(
	|			&ДтВрм,
	|			Номенклатура.Номенклатура В
	|					(ВЫБРАТЬ
	|						ТоварVMI.Номенклатура
	|					ИЗ
	|						ТоварVMI)
	|				И  Номенклатура.Владелец В
	|					(ВЫБРАТЬ
	|						ТоварVMI.Поставщик
	|					ИЗ
	|						ТоварVMI)		
	|				И Номенклатура.Владелец В
	|					(ВЫБРАТЬ
	|						ВЫРАЗИТЬ(Прайсы.Владелец КАК Справочник.ТорговыеТочки).Владелец
	|					ИЗ
	|						Прайсы)) КАК ЦеныНоменклатурыКонтрагентовСрезПоследних
	|ГДЕ
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Цена > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура.Номенклатура,
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура.Владелец
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЦеныНоменклатурыКонтрагентовСрезПоследних.Номенклатура.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СвойТовар.Номенклатура,
	|	СвойТовар.Склад,
	|	СвойТовар.КоличествоОстаток,
	|	ПрайсыПоставщиков1.ссылка КАК ПрайсПоставщика,
	|	ЕСТЬNULL(Цены.Цена, 0) КАК Цена
	|ПОМЕСТИТЬ ВсеОстатки
	|ИЗ
	|	СвойТовар КАК СвойТовар
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Прайсы.Склад КАК Склад,
	|			МАКСИМУМ(Прайсы.Ссылка) КАК ссылка
	|		ИЗ
	|			Прайсы КАК Прайсы
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Прайсы.Склад) КАК ПрайсыПоставщиков1
	|		ПО СвойТовар.Склад = ПрайсыПоставщиков1.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ Цены КАК Цены
	|		ПО СвойТовар.Номенклатура = Цены.Номенклатура
	|ГДЕ
	|	НЕ ПрайсыПоставщиков1.ссылка ЕСТЬ NULL
	|	И НЕ ПрайсыПоставщиков1.ссылка = ЗНАЧЕНИЕ(Справочник.ПрайсыПоставщиков.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварVMI.Номенклатура,
	|	ТоварVMI.Склад,
	|	ТоварVMI.КоличествоОстаток,
	|	ПрайсыПоставщиков2.Ссылка,
	|	ЕСТЬNULL(ЦеныКА.Цена, 0)
	|ИЗ
	|	ТоварVMI КАК ТоварVMI
	|		ЛЕВОЕ СОЕДИНЕНИЕ Прайсы КАК ПрайсыПоставщиков2
	|		ПО ТоварVMI.Склад = ПрайсыПоставщиков2.Склад
	|			И ТоварVMI.ТТпоставщика = ПрайсыПоставщиков2.Владелец
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныКА КАК ЦеныКА
	|		ПО ТоварVMI.Номенклатура = ЦеныКА.Номенклатура
	|			И (ВЫРАЗИТЬ(ПрайсыПоставщиков2.Владелец КАК Справочник.ТорговыеТочки).Владелец = ЦеныКА.НоменклатураВладелец)
	|ГДЕ
	|	НЕ ПрайсыПоставщиков2.Ссылка ЕСТЬ NULL
	|	И НЕ ПрайсыПоставщиков2.Ссылка = ЗНАЧЕНИЕ(Справочник.ПрайсыПоставщиков.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеОстатки.ПрайсПоставщика,
	|	ВсеОстатки.Номенклатура,
	|	СУММА(ВсеОстатки.КоличествоОстаток) КАК КоличествоОстаток,
	|	МАКСИМУМ(ВсеОстатки.Цена) КАК Цена
	|ПОМЕСТИТЬ ОстаткиСгруппированные
	|ИЗ
	|	ВсеОстатки КАК ВсеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВсеОстатки.Номенклатура,
	|	ВсеОстатки.ПрайсПоставщика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВсеОстатки.ПрайсПоставщика,
	|	ВсеОстатки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВсеОстатки.ПрайсПоставщика, Сайт.ПрайсПоставщика) КАК ПрайсПоставщика,
	|	ЕСТЬNULL(ВсеОстатки.Номенклатура, Сайт.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(ВсеОстатки.КоличествоОстаток, 0) КАК СвободныйОстатокКоличество,
	|	ЕСТЬNULL(ВсеОстатки.Цена, 0) КАК Цена,
	|	1 КАК Сч
	|ИЗ
	|	ОстаткиСгруппированные КАК ВсеОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ ДанныеСайта КАК Сайт
	|		ПО ВсеОстатки.ПрайсПоставщика = Сайт.ПрайсПоставщика
	|			И ВсеОстатки.Номенклатура = Сайт.Номенклатура
	|ГДЕ
	|	(НЕ ЕСТЬNULL(ВсеОстатки.КоличествоОстаток, 0) = ЕСТЬNULL(Сайт.СвободныйОстатокКоличество, 0)
	|			ИЛИ НЕ ЕСТЬNULL(ВсеОстатки.Цена, 0) = ЕСТЬNULL(Сайт.Цена, 0))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаборЗаписейНаУдалениеВИсторииПосылок.ReceivedNo,
	|	НаборЗаписейНаУдалениеВИсторииПосылок.Номенклатура,
	|	НаборЗаписейНаУдалениеВИсторииПосылок.ПрайсПоставщика
	|ИЗ
	|	НаборЗаписейНаУдалениеВИсторииПосылок КАК НаборЗаписейНаУдалениеВИсторииПосылок";
	
	Запрос.УстановитьПараметр("ДтВрм", ДтВрм);
	Запрос.УстановитьПараметр("ТипЦенДляСайта", Константы.ТипЦен_дляСайта.Получить());
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый); // read committed
	лРезультатыЗапросов = Запрос.ВыполнитьПакет();
	ЗафиксироватьТранзакцию();
	
	Возврат лРезультатыЗапросов;
КонецФункции


