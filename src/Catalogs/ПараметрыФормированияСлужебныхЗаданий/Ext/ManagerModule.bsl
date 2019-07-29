﻿Функция ЗапроситьИсториюПоПараметру(пар_Ссылка) экспорт
	
	ДтВрмФСЗ = Неопределено;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДатыФормированияЗаказовПоставщикам.ДатаФормирования
	                      |ИЗ
	                      |	РегистрСведений.ДатыФормированияСлужебныхЗаданий КАК ДатыФормированияЗаказовПоставщикам
	                      |ГДЕ
	                      |	ДатыФормированияЗаказовПоставщикам.ПараметрФормированияСЗ = &ПараметрФормированияЗаказовПоставщикам");
	Запрос.УстановитьПараметр("ПараметрФормированияЗаказовПоставщикам", пар_Ссылка);
	Выборка = Запрос.Выполнить().Выгрузить();
	Если Выборка.Количество() > 0 тогда
		ДтВрмФСЗ = Выборка[0].ДатаФормирования;
	КонецЕсли;
	
	Возврат ?( НЕ ДтВрмФСЗ = Неопределено, ?(ДтВрмФСЗ = ДАТА(1,1,1),"Не запускалось",СокрлП(ДтВрмФСЗ)), "ошибка записи");
КонецФункции
	
Процедура ОбновитьВремяОтгрузки_Региональное() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПараметрыФормированияСлужебныхЗаданий.Ссылка
	|ИЗ
	|	Справочник.ПараметрыФормированияСлужебныхЗаданий КАК ПараметрыФормированияСлужебныхЗаданий";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Об = Выборка.Ссылка.ПолучитьОбъект();
		Об.ОбменДанными.Загрузка = Истина;
		
		Для Инд = 1 По 7 Цикл 
			Выполнить("Об.ВремОтгрузки_Региональное" + Инд + " = ПроверкаРазницыВремени.ПолучитьРегиональноеВремя(Об.ВремОтгрузки" + Инд + ", Об.Склад)");
		КонецЦикла;
		Попытка
			Об.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

//+ Валиахметов http://jira.part-kom.ru/browse/XX-2716 20.06.2019
Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	лКлючАлгоритма = "Справочник_ПараметрыФормированияСлужебныхЗаданий_МодульМенеджера_ВыгрузитьЭлементы";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Результат = Новый Массив;
		
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт И ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2624) Тогда 	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТаблицаСсылокНаОбъекты", ТаблицаСсылокНаОбъекты);
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВнешняяТаблица.Ссылка
		               |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
		               |ИЗ
		               |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Т.Ссылка,
		               |	ВЫБОР
		               |		КОГДА Т.Ссылка В
		               |				(ВЫБРАТЬ
		               |					Справочник.ПараметрыФормированияСлужебныхЗаданий.Ссылка
		               |				ИЗ
		               |					Справочник.ПараметрыФормированияСлужебныхЗаданий)
		               |			ТОГДА ЛОЖЬ
		               |		ИНАЧЕ ИСТИНА
		               |	КОНЕЦ КАК ЭтоУдаление
		               |ПОМЕСТИТЬ Объекты
		               |ИЗ
		               |	ЗарегистрированныеОбъекты КАК Т
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ПараметрыФормированияСлужебныхЗаданий.Ссылка,
		               |	ПараметрыФормированияСлужебныхЗаданий.АвтоСозданиеЗаданий
		               |		И НЕ ПараметрыФормированияСлужебныхЗаданий.ПометкаУдаления КАК Включено,
		               |	ПараметрыФормированияСлужебныхЗаданий.Наименование КАК Наименование,
		               |	ПараметрыФормированияСлужебныхЗаданий.Склад КАК Склад,
		               |	ПараметрыФормированияСлужебныхЗаданий.МаршрутДоставки КАК МаршрутДоставки,
		               |	ЕСТЬNULL(ПараметрыФормированияСлужебныхЗаданий.МаршрутДоставки.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК СкладКонечнойРазгрузки,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели1 КАК Включено1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели2 КАК Включено2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели3 КАК Включено3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели4 КАК Включено4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели5 КАК Включено5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели6 КАК Включено6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДниНедели7 КАК Включено7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяЗапуска7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремяНачалаУпаковки7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремОтгрузки_Региональное7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ВремДоставки_Региональное7,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень1,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень2,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень3,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень4,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень5,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень6,
		               |	ПараметрыФормированияСлужебныхЗаданий.ДоставкаНаСледДень7
		               |ИЗ
		               |	Объекты КАК Объекты
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПараметрыФормированияСлужебныхЗаданий КАК ПараметрыФормированияСлужебныхЗаданий
		               |		ПО Объекты.Ссылка = ПараметрыФормированияСлужебныхЗаданий.Ссылка
		               |ГДЕ
		               |	НЕ Объекты.ЭтоУдаление
		               |	И ЕСТЬNULL(ПараметрыФормированияСлужебныхЗаданий.МаршрутДоставки.ЭтоСамовывоз, ЛОЖЬ)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Объекты.Ссылка
		               |ИЗ
		               |	Объекты КАК Объекты
		               |ГДЕ
		               |	Объекты.ЭтоУдаление";
		РезультатЗапроса = Запрос.ВыполнитьПакет();
			
		URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
		ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.ПараметрыФормированияСлужебныхЗаданий");
		ТипОбъектаXDTOРасписание = ФабрикаXDTO.Тип(URI, "Справочники.ПараметрыФормированияСлужебныхЗаданий.Расписание");
		
		ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
		Выборка = РезультатЗапроса.Получить(РезультатЗапроса.ВГраница() - 1).Выбрать();
		Пока Выборка.Следующий() Цикл 
			ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
	        ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
	        ОбъектXDTO.Наименование = Выборка.Наименование;
			ОбъектXDTO.Включено = Выборка.Включено;
			ОбъектXDTO.МаршрутДоставки = XMLСтрока(Выборка.МаршрутДоставки);
	        ОбъектXDTO.Склад = XMLСтрока(Выборка.Склад);
			ОбъектXDTO.СкладКонечнойРазгрузки = XMLСтрока(Выборка.СкладКонечнойРазгрузки);
			
			Расписание = ФабрикаXDTO.Создать(ТипОбъектаXDTOРасписание);
			РасписаниеСписок = Расписание.ПолучитьСписок("ДеньНедели");
			МассивРеквизитов = Новый Массив;
			МассивРеквизитов.Добавить("Включено");
			МассивРеквизитов.Добавить("ВремяЗапуска");
			МассивРеквизитов.Добавить("ВремяНачалаУпаковки");
			МассивРеквизитов.Добавить("ВремОкончанияДовыписки");
			МассивРеквизитов.Добавить("ВремОтгрузки");
			МассивРеквизитов.Добавить("ВремОтгрузки_Региональное");
			МассивРеквизитов.Добавить("ВремДоставки_Региональное");
			МассивРеквизитов.Добавить("ДоставкаНаСледДень");
			Для НомерДняНедели = 1 По 7 Цикл
				НоваяСтрока = ФабрикаXDTO.Создать(URI, РасписаниеСписок.ВладеющееСвойство.Тип.Имя);
								РасписаниеСписок.Добавить(НоваяСтрока);
				НоваяСтрока.НомерДняНедели = НомерДняНедели;
				Для Каждого Реквизит Из МассивРеквизитов Цикл 
					НоваяСтрока[Реквизит] = Выборка[Реквизит + Строка(НомерДняНедели)];
				КонецЦикла;
			КонецЦикла;	
			
			ОбъектXDTO.Расписание = Расписание;
			ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
			Результат.Добавить(ОбъектXDTO);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	лКлючАлгоритма = "Справочник_ПараметрыФормированияСлужебныхЗаданий_МодульМенеджера_ПолучитьРеквизитыКонтроля";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	

	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные() Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", 
		               "	АвтоСозданиеЗаданий,
		               |	ПометкаУдаления,
		               |	Склад,
		               |	МаршрутДоставки,
		               |	ДниНедели1,
		               |	ДниНедели2,
		               |	ДниНедели3,
		               |	ДниНедели4,
		               |	ДниНедели5,
		               |	ДниНедели6,
		               |	ДниНедели7,
		               |	ВремяЗапуска1,
		               |	ВремяЗапуска2,
		               |	ВремяЗапуска3,
		               |	ВремяЗапуска4,
		               |	ВремяЗапуска5,
		               |	ВремяЗапуска6,
		               |	ВремяЗапуска7,
		               |	ВремяНачалаУпаковки1,
		               |	ВремяНачалаУпаковки2,
		               |	ВремяНачалаУпаковки3,
		               |	ВремяНачалаУпаковки4,
		               |	ВремяНачалаУпаковки5,
		               |	ВремяНачалаУпаковки6,
		               |	ВремяНачалаУпаковки7,
		               |	ВремОкончанияДовыписки1,
		               |	ВремОкончанияДовыписки2,
		               |	ВремОкончанияДовыписки3,
		               |	ВремОкончанияДовыписки4,
		               |	ВремОкончанияДовыписки5,
		               |	ВремОкончанияДовыписки6,
		               |	ВремОкончанияДовыписки7,
		               |	ВремОтгрузки1,
		               |	ВремОтгрузки2,
		               |	ВремОтгрузки3,
		               |	ВремОтгрузки4,
		               |	ВремОтгрузки5,
		               |	ВремОтгрузки6,
		               |	ВремОтгрузки7,
		               |	ВремОтгрузки_Региональное1,
		               |	ВремОтгрузки_Региональное2,
		               |	ВремОтгрузки_Региональное3,
		               |	ВремОтгрузки_Региональное4,
		               |	ВремОтгрузки_Региональное5,
		               |	ВремОтгрузки_Региональное6,
		               |	ВремОтгрузки_Региональное7,
		               |	ВремДоставки_Региональное1,
		               |	ВремДоставки_Региональное2,
		               |	ВремДоставки_Региональное3,
		               |	ВремДоставки_Региональное4,
		               |	ВремДоставки_Региональное5,
		               |	ВремДоставки_Региональное6,
		               |	ВремДоставки_Региональное7,
		               |	ДоставкаНаСледДень1,
		               |	ДоставкаНаСледДень2,
		               |	ДоставкаНаСледДень3,
		               |	ДоставкаНаСледДень4,
		               |	ДоставкаНаСледДень5,
		               |	ДоставкаНаСледДень6,
		               |	ДоставкаНаСледДень7");
					   
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
	
КонецФункции
//- Валиахметов http://jira.part-kom.ru/browse/XX-2716 20.06.2019

//ХудинВВ XX-3015 26072019
Функция МаршрутДоставкиСоответствуетСкладуОтправленияДляТипаДоставки(ТипДоставки, СкладОтправления, МаршрутДоставки, ТекстОшибки = "", СообщатьОбОшибке = Истина, Отказ = Неопределено) Экспорт
	
	лКлючАлгоритма = "Справочник_ПараметрыФормированияСлужебныхЗаданий_МодульМенеджера_МаршрутДоставкиСоответствуетСкладуОтправленияДляТипаДоставки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////

	ВозвращаемоеЗначение = Истина;
	
	Если СкладОтправления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МаршрутДоставки, "Склад")
		И (ТипДоставки <> Справочники.ТипыДоставки.МежскладскаяДоставка
		ИЛИ ТипДоставки <> Справочники.ТипыДоставки.ДоставкаТК) Тогда
		ТекстОшибки = "Тип доставки не соответствует заданным параметрам.
		|Для различных складов отправления и назначения тип доставки должен быть ""Межскладская доставка"" или ""Доставка через ТК""";
		
		Если СообщатьОбОшибке Тогда
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
		КонецЕсли;
		
		Отказ = Истина;
		
		ВозвращаемоеЗначение = Ложь;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции