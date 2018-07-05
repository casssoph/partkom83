﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "ГоловнойКонтрагент,Наименование,НаименованиеПолное,Код,ДатаСоздания,ИНН,РаботатьСОкномПоставщика,
												|ОсновнаяТорговаяТочка,ОсновнойБанковскийСчет,ПроцентОтклоненияЦенПрихода,СегментКонтрагента,КоэффициентДоставки,
												|Блокировка,Блокировка_Отгрузок_Дата,Блокировка_Заказов_Дата,КлючевойКлиент,СайтГруппаКонтрагента,СайтГруппаКонтрагентаЗаблокировано,СайтГруппаКонтрагентаЗаблокированоДо");
		
	ИначеЕсли МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_77 Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "ГоловнойКонтрагент,Наименование,НаименованиеПолное,Код,ДатаСоздания,ИНН,РаботатьСОкномПоставщика,
												|ОсновнаяТорговаяТочка,ОсновнойБанковскийСчет,ПроцентОтклоненияЦенПрихода,СегментКонтрагента,КоэффициентДоставки,
												|Блокировка,Блокировка_Отгрузок_Дата,Блокировка_Заказов_Дата,КлючевойКлиент,СайтГруппаКонтрагента,СайтГруппаКонтрагентаЗаблокировано,СайтГруппаКонтрагентаЗаблокированоДо");
		
	ИначеЕсли МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_БитФинанс Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Код,Наименование,ИНН,КПП,Комментарий,НаименованиеПолное,Покупатель,Поставщик,ЮрФизЛицо");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции
Функция ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора);
	
КонецФункции

Функция ДанныеБлокировкиКонтрагента(Контрагент) Экспорт
	
	Если ЗначениеЗаполнено(Контрагент.ГоловнойКонтрагент) Тогда
		Структура = Новый Структура("Заблокирован,ПоГоловномуКонтрагенту", Контрагент.ГоловнойКонтрагент.Блокировка, Истина);
	Иначе
		Структура = Новый Структура("Заблокирован,ПоГоловномуКонтрагенту", Контрагент.Блокировка, Ложь);
	КонецЕсли;

	Возврат Структура;
	
КонецФункции
Функция ЗадолженностьКонтрагента(Контрагент, Период = Неопределено, ПоГоловномуКонтрагенту = Неопределено) Экспорт
	
	Если ПоГоловномуКонтрагенту = Неопределено Тогда
		ПоГоловномуКонтрагенту = ЗначениеЗаполнено(Контрагент.ГоловнойКонтрагент);
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Если ПоГоловномуКонтрагенту Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	СУММА(ВзаиморасчетыОстатки.СуммаРеглОстаток) КАК Сумма
		               |ИЗ
		               |	РегистрНакопления.Взаиморасчеты.Остатки(&Период, ДоговорКонтрагента.Владелец.ГоловнойКонтрагент = &ГоловнойКонтрагент) КАК ВзаиморасчетыОстатки";
		Запрос.УстановитьПараметр("ГоловнойКонтрагент", Контрагент.ГоловнойКонтрагент);
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		               |	СУММА(ВзаиморасчетыОстатки.СуммаРеглОстаток) КАК Сумма
		               |ИЗ
		               |	РегистрНакопления.Взаиморасчеты.Остатки(&Период, ДоговорКонтрагента.Владелец = &Контрагент) КАК ВзаиморасчетыОстатки";
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
	КонецЕсли;
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Период), Период, ТекущаяДата()));
	Результат = Запрос.Выполнить().Выбрать();

	Возврат ?(Результат.Следующий(), Результат.Сумма, 0);
	
КонецФункции

Функция ПросроченнаяЗадолженностьКонтрагента(Контрагент, ДатаМоментВремени = Неопределено, ПоГоловномуКонтрагенту = Неопределено) Экспорт
	
	Если ПоГоловномуКонтрагенту = Неопределено Тогда
		ПоГоловномуКонтрагенту = Контрагент <> Контрагент.ГоловнойКонтрагент;
	КонецЕсли;
	
	Если ПоГоловномуКонтрагенту Тогда
		
		ТекстЗапроса = "ВЫБРАТЬ
		               |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец.ГоловнойКонтрагент КАК Контрагент,
		               |	СУММА(ВзаиморасчетыОстатки.СуммаРеглОстаток) КАК Задолженность
		               |ПОМЕСТИТЬ ОбщаяЗадолженность
		               |ИЗ
		               |	РегистрНакопления.Взаиморасчеты.Остатки(
		               |			&ДатаМоментВремени,
		               |			ДоговорКонтрагента.Владелец.ГоловнойКонтрагент = &ГоловнойКонтрагент
		               |				И ДоговорКонтрагента.ВидДоговора = &ВидСПокупателем
		               |				И НЕ ДоговорКонтрагента.ДоговорИнвестКонтракт) КАК ВзаиморасчетыОстатки
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец.ГоловнойКонтрагент
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслуг.Контрагент.ГоловнойКонтрагент КАК Контрагент,
		               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
		               |	РеализацияТоваровУслуг.ДатаОплаты КАК ДатаОплаты,
		               |	РеализацияТоваровУслуг.ДоговорКонтрагента.ДопустимоеЧислоДнейЗадолженности КАК ДопустимоеЧислоДнейЗадолженности,
		               |	РеализацияТоваровУслуг.СуммаДокумента
		               |ПОМЕСТИТЬ РеализацияТоваровУслуг
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |ГДЕ
		               |	РеализацияТоваровУслуг.Контрагент.ГоловнойКонтрагент = &ГоловнойКонтрагент
		               |	И РеализацияТоваровУслуг.Проведен
		               |	И РеализацияТоваровУслуг.ДоговорКонтрагента.ВидДоговора = &ВидСПокупателем
		               |	И НЕ РеализацияТоваровУслуг.ДоговорКонтрагента.ДоговорИнвестКонтракт
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		               |	СУММА(РеализацияТоваровУслуг.СуммаДокумента) КАК Сумма
		               |ПОМЕСТИТЬ НеПросроченнаяЗадолженность
		               |ИЗ
		               |	РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |ГДЕ
		               |	ДОБАВИТЬКДАТЕ(РеализацияТоваровУслуг.ДатаОплаты, ДЕНЬ, &ЛимитДнейЗадолженности) >= &Дата
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	РеализацияТоваровУслуг.Контрагент
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ОбщаяЗадолженность.Контрагент,
		               |	ОбщаяЗадолженность.Задолженность - ЕСТЬNULL(НеПросроченнаяЗадолженность.Сумма, 0) КАК Сумма
		               |ИЗ
		               |	ОбщаяЗадолженность КАК ОбщаяЗадолженность
		               |		ЛЕВОЕ СОЕДИНЕНИЕ НеПросроченнаяЗадолженность КАК НеПросроченнаяЗадолженность
		               |		ПО ОбщаяЗадолженность.Контрагент = НеПросроченнаяЗадолженность.Контрагент
		               |ГДЕ
		               |	ОбщаяЗадолженность.Задолженность - ЕСТЬNULL(НеПросроченнаяЗадолженность.Сумма, 0) > 0";	
		
	Иначе
		
		ТекстЗапроса = "ВЫБРАТЬ
		               |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
		               |	СУММА(ВзаиморасчетыОстатки.СуммаРеглОстаток) КАК Задолженность
		               |ПОМЕСТИТЬ ОбщаяЗадолженность
		               |ИЗ
		               |	РегистрНакопления.Взаиморасчеты.Остатки(
		               |			&ДатаМоментВремени,
		               |			ДоговорКонтрагента.Владелец = &Контрагент
		               |				И ДоговорКонтрагента.ВидДоговора = &ВидСПокупателем
		               |				И НЕ ДоговорКонтрагента.ДоговорИнвестКонтракт) КАК ВзаиморасчетыОстатки
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
		               |	РеализацияТоваровУслуг.ДатаОплаты КАК ДатаОплаты,
		               |	РеализацияТоваровУслуг.ДоговорКонтрагента.ДопустимоеЧислоДнейЗадолженности КАК ДопустимоеЧислоДнейЗадолженности,
		               |	РеализацияТоваровУслуг.СуммаДокумента
		               |ПОМЕСТИТЬ РеализацияТоваровУслуг
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |ГДЕ
		               |	РеализацияТоваровУслуг.Контрагент = &Контрагент
		               |	И РеализацияТоваровУслуг.Проведен
		               |	И РеализацияТоваровУслуг.ДоговорКонтрагента.ВидДоговора = &ВидСПокупателем
		               |	И НЕ РеализацияТоваровУслуг.ДоговорКонтрагента.ДоговорИнвестКонтракт
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		               |	СУММА(РеализацияТоваровУслуг.СуммаДокумента) КАК Сумма
		               |ПОМЕСТИТЬ НеПросроченнаяЗадолженность
		               |ИЗ
		               |	РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |ГДЕ
		               |	ДОБАВИТЬКДАТЕ(РеализацияТоваровУслуг.ДатаОплаты, ДЕНЬ, &ЛимитДнейЗадолженности) >= &Дата
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	РеализацияТоваровУслуг.Контрагент
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ОбщаяЗадолженность.Контрагент,
		               |	ОбщаяЗадолженность.Задолженность - ЕСТЬNULL(НеПросроченнаяЗадолженность.Сумма, 0) КАК Сумма
		               |ИЗ
		               |	ОбщаяЗадолженность КАК ОбщаяЗадолженность
		               |		ЛЕВОЕ СОЕДИНЕНИЕ НеПросроченнаяЗадолженность КАК НеПросроченнаяЗадолженность
		               |		ПО ОбщаяЗадолженность.Контрагент = НеПросроченнаяЗадолженность.Контрагент
		               |ГДЕ
		               |	ОбщаяЗадолженность.Задолженность - ЕСТЬNULL(НеПросроченнаяЗадолженность.Сумма, 0) > 0";
		
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ГоловнойКонтрагент", Контрагент.ГоловнойКонтрагент);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Если ДатаМоментВремени = Неопределено ИЛИ ТипЗнч(ДатаМоментВремени) = Тип("Дата") Тогда
		Запрос.УстановитьПараметр("ДатаМоментВремени", ?(ЗначениеЗаполнено(ДатаМоментВремени), ДатаМоментВремени, ТекущаяДата()));
		Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(ДатаМоментВремени), ДатаМоментВремени, ТекущаяДата()));
	Иначе //МоментВремени
		Запрос.УстановитьПараметр("ДатаМоментВремени", Новый Граница(ДатаМоментВремени, ВидГраницы.Исключая));
		Запрос.УстановитьПараметр("Дата", ДатаМоментВремени.Дата);
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидСПокупателем", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	Запрос.УстановитьПараметр("ЛимитДнейЗадолженности", Константы.ЛимитДнейЗадолженности.Получить());
	
	Результат = Запрос.Выполнить().Выбрать();

	Возврат ?(Результат.Следующий(), Результат.Сумма, 0);
	
КонецФункции


Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена) Экспорт
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ПокупателиТипОбъектаXDTO			= ФабрикаXDTO.Тип(URI, "Справочник.Покупатели");
	ПоставщикиТипОбъектаXDTO			= ФабрикаXDTO.Тип(URI, "Справочник.Поставщики");
	СписокКонтактныхЛицТипОбъектаXDTO	= ФабрикаXDTO.Тип(URI, "Справочник.Покупатели.КонтактныеЛица");
	ДанныеКонтактныхЛицТипОбъектаXDTO	= ФабрикаXDTO.Тип(URI, "Справочник.Покупатели.КонтактноеЛицо");
	ГруппыТипОбъектаXDTO				= ФабрикаXDTO.Тип(URI, "Справочники.ГруппыПокупателей");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	
	МассивОбъектов = Новый Массив;
	
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		
		ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты);
		КонтактныеЛица = ОбъектыОбмена[12].Выгрузить();
		
		Выборка = ОбъектыОбмена[9].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ЯвляетсяГруппой Тогда
				ОбъектXDTO = ФабрикаXDTO.Создать(ГруппыТипОбъектаXDTO);
				ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
				ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,"Код,Наименование");
				
				МассивОбъектов.Добавить(ОбъектXDTO);
			Иначе
				//Добавляем контрагентов, как покупателей
				Если Выборка.ЯвляетсяПокупателем Тогда
					ОбъектXDTO = ФабрикаXDTO.Создать(ПокупателиТипОбъектаXDTO);
					ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
					ОбъектXDTO.Менеджер = Выборка.МенеджерПродаж.УникальныйИдентификатор();
					ОбъектXDTO.Логин = СокрЛП(Выборка.Логин);
					ОбъектXDTO.Пароль = СокрЛП(Выборка.Пароль);
					ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,,"Ссылка,Логин,Пароль");

					//Заполняем контактные лица
					СписокКонтактовГруппа = ФабрикаXDTO.Создать(СписокКонтактныхЛицТипОбъектаXDTO);
					СписокКонтактов = СписокКонтактовГруппа.ПолучитьСписок("КонтактноеЛицо");
					Для Каждого ДанныеКонтактногоЛица Из КонтактныеЛица.НайтиСтроки(Новый Структура("Контрагент", Выборка.Ссылка)) Цикл
						СтрокаКонтактовКонтрагента = ФабрикаXDTO.Создать(ДанныеКонтактныхЛицТипОбъектаXDTO);
						ЗаполнитьЗначенияСвойств(СтрокаКонтактовКонтрагента, ДанныеКонтактногоЛица);
						СписокКонтактов.Добавить(СтрокаКонтактовКонтрагента);
					КонецЦикла;
					ОбъектXDTO.КонтактныеЛица = СписокКонтактовГруппа;
					
					МассивОбъектов.Добавить(ОбъектXDTO);
				КонецЕсли;
				
				//Добавляем контрагентов, как поставщиков
				Если Выборка.ЯвляетсяПоставщиком Тогда
					ОбъектXDTO = ФабрикаXDTO.Создать(ПоставщикиТипОбъектаXDTO);
					ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
					ОбъектXDTO.МенеджерСнабжения = Выборка.МенеджерСнабжения.УникальныйИдентификатор();
					ОбъектXDTO.ЗамМенеджераСнабжения = Выборка.ЗамМенеджераСнабжения.УникальныйИдентификатор();
					ОбъектXDTO.СкладVMI = Выборка.СкладVMI.УникальныйИдентификатор();
					ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,,"Ссылка,МенеджерСнабжения,ЗамМенеджераСнабжения,СкладVMI");

					МассивОбъектов.Добавить(ОбъектXDTO);
				КонецЕсли;
			КонецЕсли;
			
			
		КонецЦикла;			
		
		Выборка = ОбъектыОбмена[10].Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
			ОбъектXDTO.ТипОбъекта = "Справочники.Контрагенты";
			ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
			
			МассивОбъектов.Добавить(ОбъектXDTO);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

Функция ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Контрагенты) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Контрагенты).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Контрагенты)) <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ЭтоУдаление
	                      |ПОМЕСТИТЬ Объекты
	                      |ИЗ
	                      |	ЗарегистрированныеОбъекты КАК ЗарегистрированныеОбъекты
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка,
	                      |	Объекты.Ссылка.ОсновнаяТорговаяТочка КАК ОсновнаяТорговаяТочка
	                      |ПОМЕСТИТЬ ИзмененныеОбъекты
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	НЕ Объекты.ЭтоУдаление
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	МенеджерыТорговыхТочекСрезПоследних.ТорговаяТочка.Владелец КАК Контрагент,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА МенеджерыТорговыхТочекСрезПоследних.ВидМенеджера = ЗНАЧЕНИЕ(Перечисление.ВидыМенеджеров.Снабжения)
	                      |				ТОГДА МенеджерыТорговыхТочекСрезПоследних.Менеджер
	                      |			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)
	                      |		КОНЕЦ) КАК МенеджерСнабжения,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА МенеджерыТорговыхТочекСрезПоследних.ВидМенеджера = ЗНАЧЕНИЕ(Перечисление.ВидыМенеджеров.ЗамМенеджераСнабжения)
	                      |				ТОГДА МенеджерыТорговыхТочекСрезПоследних.Менеджер
	                      |			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)
	                      |		КОНЕЦ) КАК ЗамМенеджераСнабжения,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА МенеджерыТорговыхТочекСрезПоследних.ВидМенеджера = ЗНАЧЕНИЕ(Перечисление.ВидыМенеджеров.Продажи)
	                      |				ТОГДА МенеджерыТорговыхТочекСрезПоследних.Менеджер
	                      |			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)
	                      |		КОНЕЦ) КАК МенеджерПродаж
	                      |ПОМЕСТИТЬ МенеджерыТорговыхТочек
	                      |ИЗ
	                      |	РегистрСведений.МенеджерыТорговыхТочек.СрезПоследних(
	                      |			,
	                      |			ТорговаяТочка В
	                      |				(ВЫБРАТЬ
	                      |					ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка
	                      |				ИЗ
	                      |					ИзмененныеОбъекты КАК ИзмененныеОбъекты)) КАК МенеджерыТорговыхТочекСрезПоследних
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	МенеджерыТорговыхТочекСрезПоследних.ТорговаяТочка.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ПрайсыПоставщиков.Владелец.Владелец КАК Контрагент
	                      |ПОМЕСТИТЬ Поставщики
	                      |ИЗ
	                      |	Справочник.ПрайсыПоставщиков КАК ПрайсыПоставщиков
	                      |ГДЕ
	                      |	ПрайсыПоставщиков.Владелец.Владелец В
	                      |			(ВЫБРАТЬ
	                      |				ИзмененныеОбъекты.Ссылка
	                      |			ИЗ
	                      |				Объекты КАК ИзмененныеОбъекты)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ПрайсыПоставщиков.Владелец.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КонтактнаяИнформация.Объект,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК ЭлектроннаяПочта,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК ФактическийАдрес,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК ЮридическийАдрес,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК АдресДоставки
	                      |ПОМЕСТИТЬ КонтактнаяИнформацияКонтрагента
	                      |ИЗ
	                      |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                      |ГДЕ
	                      |	КонтактнаяИнформация.Объект В
	                      |			(ВЫБРАТЬ
	                      |				ИзмененныеОбъекты.Ссылка
	                      |			ИЗ
	                      |				ИзмененныеОбъекты КАК ИзмененныеОбъекты)
	                      |	И КонтактнаяИнформация.Вид В (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента))
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	КонтактнаяИнформация.Объект
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ПрайсыПоставщиков.Владелец.Владелец КАК Контрагент,
	                      |	МАКСИМУМ(ПрайсыПоставщиков.Ссылка) КАК ПрайсVMI
	                      |ПОМЕСТИТЬ ДанныеПрайсовVMI
	                      |ИЗ
	                      |	Справочник.ПрайсыПоставщиков КАК ПрайсыПоставщиков
	                      |ГДЕ
	                      |	ПрайсыПоставщиков.Владелец В
	                      |			(ВЫБРАТЬ
	                      |				ИзмененныеОбъекты.ОсновнаяТорговаяТочка
	                      |			ИЗ
	                      |				ИзмененныеОбъекты КАК ИзмененныеОбъекты)
	                      |	И ПрайсыПоставщиков.Склад.СкладVMI
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ПрайсыПоставщиков.Владелец.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ДоговорыКонтрагентов.Владелец КАК Контрагент,
	                      |	МАКСИМУМ(ДоговорыКонтрагентов.Ссылка) КАК Договор
	                      |ПОМЕСТИТЬ ДоговорыСПоставщиком
	                      |ИЗ
	                      |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	                      |ГДЕ
	                      |	ДоговорыКонтрагентов.Владелец В
	                      |			(ВЫБРАТЬ
	                      |				ИзмененныеОбъекты.Ссылка
	                      |			ИЗ
	                      |				ИзмененныеОбъекты КАК ИзмененныеОбъекты)
	                      |	И НЕ ДоговорыКонтрагентов.ПометкаУдаления
	                      |	И ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком)
	                      |	И ДоговорыКонтрагентов.ДоговорПодписан
	                      |	И НЕ ДоговорыКонтрагентов.СлужебныйДоговор
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ДоговорыКонтрагентов.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	УчетныеЗаписиСайта.Владелец.Владелец КАК Контрагент,
	                      |	МАКСИМУМ(УчетныеЗаписиСайта.Ссылка) КАК УчетнаяЗапись
	                      |ПОМЕСТИТЬ УчетныеЗаписиТорговыхТочек
	                      |ИЗ
	                      |	Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	УчетныеЗаписиСайта.Владелец.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ИзмененныеОбъекты.Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА Поставщики.Контрагент ЕСТЬ NULL
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК ЯвляетсяПоставщиком,
	                      |	ВЫБОР
	                      |		КОГДА УчетныеЗаписиТорговыхТочек.УчетнаяЗапись ЕСТЬ NULL
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
	                      |	КОНЕЦ КАК ЯвляетсяПокупателем,
	                      |	ИзмененныеОбъекты.Ссылка.ЭтоГруппа КАК ЯвляетсяГруппой,
	                      |	ЕСТЬNULL(УчетныеЗаписиТорговыхТочек.УчетнаяЗапись.Код, """") КАК Логин,
	                      |	ЕСТЬNULL(УчетныеЗаписиТорговыхТочек.УчетнаяЗапись.Пароль, """") КАК Пароль,
	                      |	ИзмененныеОбъекты.Ссылка.Код КАК Код,
	                      |	ИзмененныеОбъекты.Ссылка.Наименование КАК Наименование,
	                      |	ИзмененныеОбъекты.Ссылка.НаименованиеПолное КАК НаименованиеПолное,
	                      |	ИзмененныеОбъекты.Ссылка.КоэффициентДоставки КАК КоэффициентДоставки,
	                      |	ВЫБОР
	                      |		КОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	                      |			ТОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент.Блокировка
	                      |		ИНАЧЕ ИзмененныеОбъекты.Ссылка.Блокировка
	                      |	КОНЕЦ КАК Заблокирован,
	                      |	ВЫБОР
	                      |		КОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	                      |			ТОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент.Блокировка_Отгрузок_Дата
	                      |		ИНАЧЕ ИзмененныеОбъекты.Ссылка.Блокировка_Отгрузок_Дата
	                      |	КОНЕЦ КАК ДатаБлокировкиОтгрузок,
	                      |	ВЫБОР
	                      |		КОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	                      |			ТОГДА ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент.Блокировка_Заказов_Дата
	                      |		ИНАЧЕ ИзмененныеОбъекты.Ссылка.Блокировка_Заказов_Дата
	                      |	КОНЕЦ КАК ДатаБлокировкиЗаказов,
	                      |	ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка КАК ОсновнаяТорговаяТочка,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.Регион.Код, 0) КАК РегионКод,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.Город.Код, 0) КАК ГородКод,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.МаршрутДоставки.Наименование, """") КАК МаршрутДоставкиНаименование,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.МаршрутДоставки.Код, """") КАК МаршрутДоставкиКод,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.ГородПоставки.Код, 0) КАК КодГородаРазгрузки1,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка.ГородПоставки2.Код, 0) КАК КодГородаРазгрузки2,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.Родитель.Код, """") КАК ХолдингКод,
	                      |	ИзмененныеОбъекты.Ссылка.ГоловнойКонтрагент.Ссылка КАК ХолдингСсылка,
	                      |	ИзмененныеОбъекты.Ссылка.ИНН КАК ИНН,
	                      |	ИзмененныеОбъекты.Ссылка.КПП КАК КПП,
	                      |	ИзмененныеОбъекты.Ссылка.ДатаСоздания КАК ДатаСоздания,
	                      |	ИзмененныеОбъекты.Ссылка.СегментКонтрагента КАК СегментКонтрагента,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.СегментКонтрагента.Код, 0) КАК СегментКонтрагентаКод,
	                      |	ИзмененныеОбъекты.Ссылка.КлючевойКлиент КАК КлючевойКлиент,
	                      |	ИзмененныеОбъекты.Ссылка.СайтГруппаКонтрагента КАК ГруппаКонтрагента,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.СайтГруппаКонтрагента.Код, 0) КАК ГруппаКонтрагентаКод,
	                      |	ИзмененныеОбъекты.Ссылка.СайтГруппаКонтрагентаЗаблокировано КАК ГруппаКонтрагентаЗаблокировано,
	                      |	ИзмененныеОбъекты.Ссылка.СайтГруппаКонтрагентаЗаблокированоДо КАК ГруппаКонтрагентаЗаблокированоДо,
	                      |	ЕСТЬNULL(КонтактнаяИнформацияКонтрагента.АдресДоставки, """") КАК АдресДоставки,
	                      |	ЕСТЬNULL(КонтактнаяИнформацияКонтрагента.ЭлектроннаяПочта, """") КАК ЭлектроннаяПочта,
	                      |	ЕСТЬNULL(МенеджерыТорговыхТочек.МенеджерСнабжения, ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)) КАК МенеджерСнабжения,
	                      |	ЕСТЬNULL(МенеджерыТорговыхТочек.ЗамМенеджераСнабжения, ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)) КАК ЗамМенеджераСнабжения,
	                      |	ЕСТЬNULL(МенеджерыТорговыхТочек.МенеджерПродаж, ЗНАЧЕНИЕ(Справочник.Менеджеры.ПустаяСсылка)) КАК МенеджерПродаж,
	                      |	ЕСТЬNULL(КонтактнаяИнформацияКонтрагента.ФактическийАдрес, """") КАК ФактическийАдрес,
	                      |	ЕСТЬNULL(КонтактнаяИнформацияКонтрагента.ЮридическийАдрес, """") КАК ЮридическийАдрес,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.НашРасчетныйСчет.Банк.Наименование, """") КАК БанкНаименование,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.НашРасчетныйСчет.Банк.Код, """") КАК БанкБИК,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.НашРасчетныйСчет.Банк.КоррСчет, """") КАК КоррСчет,
	                      |	ЕСТЬNULL(ИзмененныеОбъекты.Ссылка.НашРасчетныйСчет.НомерСчета, """") КАК БанковскийСчет,
	                      |	ИзмененныеОбъекты.Ссылка.РаботатьСОкномПоставщика КАК РаботаетСОкномПоставщика,
	                      |	ИзмененныеОбъекты.Ссылка.ПроцентОтклоненияЦенПрихода КАК ПроцентОтклоненияЦенПрихода,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ГлубинаКредита, 0) КАК ОтсрочкаПлатежа,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ОплатаВЛюбойДень, ЛОЖЬ) КАК ОплатаВЛюбойДень,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ДоговорНаОферту, ЛОЖЬ) КАК ПризнакОферты,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ДоговорНаКросс, ЛОЖЬ) КАК CROSS,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ДоговорНаСток, ЛОЖЬ) КАК STOCK,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.Организация.Код, 0) КАК Организация,
	                      |	ЕСТЬNULL(ДоговорыСПоставщиком.Договор.ГарантийноеПисьмо, ЛОЖЬ) КАК ГарантийноеПисьмо,
	                      |	ИзмененныеОбъекты.Ссылка.ПоставщикVMI КАК VMI,
	                      |	ЕСТЬNULL(ДанныеПрайсовVMI.ПрайсVMI.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК СкладVMI
	                      |ИЗ
	                      |	ИзмененныеОбъекты КАК ИзмененныеОбъекты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Поставщики КАК Поставщики
	                      |		ПО ИзмененныеОбъекты.Ссылка = Поставщики.Контрагент
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ МенеджерыТорговыхТочек КАК МенеджерыТорговыхТочек
	                      |		ПО ИзмененныеОбъекты.Ссылка = МенеджерыТорговыхТочек.Контрагент
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ КонтактнаяИнформацияКонтрагента КАК КонтактнаяИнформацияКонтрагента
	                      |		ПО ИзмененныеОбъекты.Ссылка = КонтактнаяИнформацияКонтрагента.Объект
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПрайсовVMI КАК ДанныеПрайсовVMI
	                      |		ПО ИзмененныеОбъекты.Ссылка = ДанныеПрайсовVMI.Контрагент
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ДоговорыСПоставщиком КАК ДоговорыСПоставщиком
	                      |		ПО ИзмененныеОбъекты.Ссылка = ДоговорыСПоставщиком.Контрагент
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ УчетныеЗаписиТорговыхТочек КАК УчетныеЗаписиТорговыхТочек
	                      |		ПО ИзмененныеОбъекты.Ссылка = УчетныеЗаписиТорговыхТочек.Контрагент
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	Объекты.ЭтоУдаление
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КонтактныеЛицаКонтрагентов.Владелец КАК ТорговаяТочка,
	                      |	КонтактныеЛицаКонтрагентов.Ссылка КАК КонтактноеЛицоКонтрагента,
	                      |	КонтактныеЛицаКонтрагентов.КонтактноеЛицо,
	                      |	КонтактныеЛицаКонтрагентов.Должность
	                      |ПОМЕСТИТЬ КонтактныеЛицаТорговыхТочек
	                      |ИЗ
	                      |	Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛицаКонтрагентов
	                      |ГДЕ
	                      |	КонтактныеЛицаКонтрагентов.Владелец В
	                      |			(ВЫБРАТЬ
	                      |				ИзмененныеОбъекты.Ссылка.ОсновнаяТорговаяТочка
	                      |			ИЗ
	                      |				ИзмененныеОбъекты КАК ИзмененныеОбъекты)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	КонтактныеЛицаТорговыхТочек.ТорговаяТочка.Владелец КАК Контрагент,
	                      |	КонтактныеЛицаТорговыхТочек.КонтактноеЛицо.Наименование КАК ФИО,
	                      |	КонтактныеЛицаТорговыхТочек.Должность,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.РабочийТелефонКонтактногоЛицаКонтрагента)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК ТелефонСотовый,
	                      |	МАКСИМУМ(ВЫБОР
	                      |			КОГДА КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛицаКонтрагента)
	                      |				ТОГДА КонтактнаяИнформация.Представление
	                      |			ИНАЧЕ """"
	                      |		КОНЕЦ) КАК ТелефонЛичногоКабинета
	                      |ИЗ
	                      |	КонтактныеЛицаТорговыхТочек КАК КонтактныеЛицаТорговыхТочек
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                      |		ПО КонтактныеЛицаТорговыхТочек.КонтактноеЛицоКонтрагента = КонтактнаяИнформация.Объект
	                      |			И (КонтактнаяИнформация.Вид В (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛицаКонтрагента), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.РабочийТелефонКонтактногоЛицаКонтрагента)))
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	КонтактныеЛицаТорговыхТочек.ТорговаяТочка.Владелец,
	                      |	КонтактныеЛицаТорговыхТочек.Должность,
	                      |	КонтактныеЛицаТорговыхТочек.КонтактноеЛицо.Наименование");	
						  
		Запрос.УстановитьПараметр("ТаблицаСсылокНаОбъекты", ТаблицаСсылокНаОбъекты);
		
		Возврат Запрос.ВыполнитьПакет();

КонецФункции
