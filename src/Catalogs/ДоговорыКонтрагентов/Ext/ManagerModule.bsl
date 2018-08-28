﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код,Владелец,Дата,Номер,Организация,СрокДействия,ДопустимаяСуммаЗадолженности,КоэффициентСуммыКредита,ДоговорПриостановлен,ПометкаУдаления,ДоговорПодписан,СлужебныйДоговор");
	КонецЕсли;
	
	Если МетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_77 Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код,Владелец,Дата,Номер,Организация,СрокДействия");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(СсылкаНаОбъект, МетаданныеОтбора);
	
КонецФункции

Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.ДоговорыКонтрагентов");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");	

	ОбъектыОбмена = ДанныеОбъектовПланаОбмена(ТаблицаСсылокНаОбъекты);

	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт тогда
		
		Выборка = ОбъектыОбмена[6].Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.Ссылка.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
				ВыгружаемыеОбъекты.Добавить(Выборка.Ссылка);
				ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
				ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,,"Ссылка,КонтрагентЛогин");
				ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
				ОбъектXDTO.КонтрагентUUID = Выборка.Контрагент.УникальныйИдентификатор();
				ОбъектXDTO.ОрганизацияUUID = Выборка.Организация.УникальныйИдентификатор();
				ОбъектXDTO.КонтрагентЛогин = СокрЛП(Выборка.КонтрагентЛогин);
				МассивОбъектов.Добавить(ОбъектXDTO);
			КонецЕсли;
		КонецЦикла;		
		
		Выборка = ОбъектыОбмена[7].Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
			ОбъектXDTO.ТипОбъекта = "Справочники.ДоговорыКонтрагентов";
			ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
			
			МассивОбъектов.Добавить(ОбъектXDTO);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

Функция ДанныеОбъектовПланаОбмена(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ДоговорыКонтрагентов) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ДоговорыКонтрагентов).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.ДоговорыКонтрагентов)) <> ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ЭтоУдаление
	                      |ПОМЕСТИТЬ Объекты
	                      |ИЗ
	                      |	ЗарегистрированныеОбъекты КАК ЗарегистрированныеОбъекты
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ДоговорыКонтрагентов.Ссылка
	                      |ПОМЕСТИТЬ СПодчиненнымиДоговорами
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	                      |		ПО (НЕ Объекты.ЭтоУдаление)
	                      |			И Объекты.Ссылка.Владелец = ДоговорыКонтрагентов.Владелец.ГоловнойКонтрагент
	                      |			И Объекты.Ссылка.Владелец <> ДоговорыКонтрагентов.Владелец
	                      |			И (ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем))
	                      |			И Объекты.Ссылка.Организация = ДоговорыКонтрагентов.Организация
	                      |			И Объекты.Ссылка.ДоговорНаОферту = ДоговорыКонтрагентов.ДоговорНаОферту
	                      |			И Объекты.Ссылка.ВидОплаты = ДоговорыКонтрагентов.ВидОплаты
	                      |			И (НЕ ДоговорыКонтрагентов.СлужебныйДоговор)
	                      |			И (НЕ ДоговорыКонтрагентов.Владелец.ПометкаУдаления)
	                      |			И (НЕ ДоговорыКонтрагентов.ДоговорПриостановлен)
	                      |
	                      |ОБЪЕДИНИТЬ
	                      |
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	НЕ Объекты.ЭтоУдаление
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	УчетныеЗаписиСайта.Владелец.Владелец КАК Контрагент,
	                      |	МАКСИМУМ(УчетныеЗаписиСайта.Код) КАК Логин
	                      |ПОМЕСТИТЬ ЛогиныКонтрагентов
	                      |ИЗ
	                      |	Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
	                      |ГДЕ
	                      |	УчетныеЗаписиСайта.Владелец.Владелец В
	                      |			(ВЫБРАТЬ
	                      |				Объекты.Ссылка.Владелец
	                      |			ИЗ
	                      |				СПодчиненнымиДоговорами КАК Объекты)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	УчетныеЗаписиСайта.Владелец.Владелец
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СПодчиненнымиДоговорами.Ссылка
	                      |ПОМЕСТИТЬ ДоговорыПодчиненныхКонтрагентов
	                      |ИЗ
	                      |	СПодчиненнымиДоговорами КАК СПодчиненнымиДоговорами
	                      |ГДЕ
	                      |	СПодчиненнымиДоговорами.Ссылка.Владелец <> СПодчиненнымиДоговорами.Ссылка.Владелец.ГоловнойКонтрагент
	                      |	И СПодчиненнымиДоговорами.Ссылка.Владелец.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ДоговорыПодчиненныхКонтрагентов.Ссылка КАК ПодчиненныйДоговор,
	                      |	ДоговорыКонтрагентов.Ссылка КАК ДоговорХолдинга,
	                      |	ДоговорыКонтрагентов.ДатаДоговораОферты,
	                      |	ДоговорыКонтрагентов.НомерЗаявкиОферты,
	                      |	ДоговорыКонтрагентов.ДатаДоговораОферты <> ДАТАВРЕМЯ(1, 1, 1)
	                      |		ИЛИ ДоговорыКонтрагентов.НомерЗаявкиОферты <> """"
	                      |		ИЛИ ДоговорыКонтрагентов.ДоговорПодписан КАК АксептОферты,
	                      |	ВЫБОР
	                      |		КОГДА ДоговорыКонтрагентов.Владелец.ОсновнойДоговорКонтрагента = ДоговорыКонтрагентов.Ссылка
	                      |			ТОГДА 0
	                      |		ИНАЧЕ 1
	                      |	КОНЕЦ КАК Приоритет
	                      |ПОМЕСТИТЬ ДоговораХолдингов
	                      |ИЗ
	                      |	ДоговорыПодчиненныхКонтрагентов КАК ДоговорыПодчиненныхКонтрагентов
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	                      |		ПО ДоговорыПодчиненныхКонтрагентов.Ссылка.Организация = ДоговорыКонтрагентов.Организация
	                      |			И ДоговорыПодчиненныхКонтрагентов.Ссылка.ВидОплаты = ДоговорыКонтрагентов.ВидОплаты
	                      |			И ДоговорыПодчиненныхКонтрагентов.Ссылка.ДоговорНаОферту = ДоговорыКонтрагентов.ДоговорНаОферту
	                      |			И (НЕ ДоговорыКонтрагентов.Ссылка.ПометкаУдаления)
	                      |			И (НЕ ДоговорыКонтрагентов.Ссылка.ДоговорПриостановлен)
	                      |			И (НЕ ДоговорыКонтрагентов.Ссылка.СлужебныйДоговор)
	                      |			И ДоговорыПодчиненныхКонтрагентов.Ссылка.Владелец.ГоловнойКонтрагент = ДоговорыКонтрагентов.Владелец
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Приоритет
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СПодчиненнымиДоговорами.Ссылка,
	                      |	СПодчиненнымиДоговорами.Ссылка = СПодчиненнымиДоговорами.Ссылка.Владелец.ОсновнойДоговорКонтрагента КАК ОсновнойДоговор,
	                      |	СПодчиненнымиДоговорами.Ссылка.Код КАК Код,
	                      |	СПодчиненнымиДоговорами.Ссылка.Организация КАК Организация,
	                      |	ЕСТЬNULL(СПодчиненнымиДоговорами.Ссылка.Организация.Код, """") КАК ОрганизацияКод,
	                      |	ЕСТЬNULL(ЛогиныКонтрагентов.Логин, """") КАК КонтрагентЛогин,
	                      |	СПодчиненнымиДоговорами.Ссылка.Владелец КАК Контрагент,
	                      |	ВЫБОР
	                      |		КОГДА СПодчиненнымиДоговорами.Ссылка.ДоговорНаОферту
	                      |			ТОГДА СПодчиненнымиДоговорами.Ссылка.ДатаДоговораОферты
	                      |		ИНАЧЕ СПодчиненнымиДоговорами.Ссылка.Дата
	                      |	КОНЕЦ КАК ДатаДоговора,
	                      |	СПодчиненнымиДоговорами.Ссылка.Номер КАК НомерДоговора,
	                      |	СПодчиненнымиДоговорами.Ссылка.ДоговорПриостановлен КАК Заблокирован,
	                      |	ЕСТЬNULL(ДоговораХолдингов.АксептОферты, СПодчиненнымиДоговорами.Ссылка.ДоговорПодписан
	                      |			ИЛИ СПодчиненнымиДоговорами.Ссылка.ДатаДоговораОферты <> ДАТАВРЕМЯ(1, 1, 1)
	                      |			ИЛИ СПодчиненнымиДоговорами.Ссылка.НомерЗаявкиОферты <> """") КАК Подписан,
	                      |	СПодчиненнымиДоговорами.Ссылка.СлужебныйДоговор
	                      |		ИЛИ СПодчиненнымиДоговорами.Ссылка.ПометкаУдаления КАК СлужебныйДоговор,
	                      |	ВЫБОР
	                      |		КОГДА СПодчиненнымиДоговорами.Ссылка.ВидОплаты = ЗНАЧЕНИЕ(Перечисление.ВидыДенежныхСредств.Наличные)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК НаличныйРасчет,
	                      |	СПодчиненнымиДоговорами.Ссылка.ДоговорНаОферту КАК Оферта,
	                      |	ВЫБОР
	                      |		КОГДА СПодчиненнымиДоговорами.Ссылка.ВидРасчетаДней = ЗНАЧЕНИЕ(Перечисление.ВидыРасчетаДней.ПоКалендарнымДням)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК РасчетПоКалендарнымДням,
	                      |	ЕСТЬNULL(ДоговораХолдингов.ДоговорХолдинга.ДопустимаяСуммаЗадолженности, СПодчиненнымиДоговорами.Ссылка.ДопустимаяСуммаЗадолженности) КАК СуммаКредита,
	                      |	ЕСТЬNULL(ДоговораХолдингов.ДоговорХолдинга.ДопустимоеЧислоДнейЗадолженности, СПодчиненнымиДоговорами.Ссылка.ДопустимоеЧислоДнейЗадолженности) КАК ДнейКредита,
	                      |	ЕСТЬNULL(ДоговораХолдингов.ДоговорХолдинга.КоэффициентСуммыКредита, СПодчиненнымиДоговорами.Ссылка.КоэффициентСуммыКредита) КАК КредитныйКоэффициент,
	                      |	ЕСТЬNULL(_ДляПереносаДанных.Строка77, ""00000000-0000-0000-0000-000000000000"") КАК UUID77,
	                      |	ВЫБОР
	                      |		КОГДА СПодчиненнымиДоговорами.Ссылка.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка)
	                      |			ТОГДА СПодчиненнымиДоговорами.Ссылка.БанковскийСчет.Код
	                      |		ИНАЧЕ ЕСТЬNULL(СПодчиненнымиДоговорами.Ссылка.Организация.ОсновнойБанковскийСчет.Код, """")
	                      |	КОНЕЦ КАК БанковскийСчетОрганизацииДляПлатежей
	                      |ИЗ
	                      |	СПодчиненнымиДоговорами КАК СПодчиненнымиДоговорами
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
	                      |		ПО СПодчиненнымиДоговорами.Ссылка = _ДляПереносаДанных.Объект
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ЛогиныКонтрагентов КАК ЛогиныКонтрагентов
	                      |		ПО СПодчиненнымиДоговорами.Ссылка.Владелец = ЛогиныКонтрагентов.Контрагент
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ДоговораХолдингов КАК ДоговораХолдингов
	                      |		ПО СПодчиненнымиДоговорами.Ссылка = ДоговораХолдингов.ПодчиненныйДоговор
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Объекты.Ссылка
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	Объекты.ЭтоУдаление");
	Запрос.УстановитьПараметр("ТаблицаСсылокНаОбъекты", ТаблицаСсылокНаОбъекты);
	
	Возврат Запрос.ВыполнитьПакет();
	
КонецФункции

Функция БанковскийСчетПоДоговору(ДоговорКонтрагента) Экспорт
	
	СчетОрганизации = Неопределено;
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		Возврат СчетОрганизации
	КонецЕсли;
	
	Реквизиты =  ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "БанковскийСчет, Организация");
	Если ЗначениеЗаполнено(Реквизиты.БанковскийСчет) Тогда
		СчетОрганизации = Реквизиты.БанковскийСчет;
	ИначеЕсли ЗначениеЗаполнено(Реквизиты.Организация) Тогда
		СчетОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Организация, "ОсновнойБанковскийСчет");
	КонецЕсли;
	
	Возврат СчетОрганизации;
	
КонецФункции

Функция ИспользоватьРегистрОсновныеДоговорыКонтрагентов() Экспорт
	
	Возврат Константы.ИспользоватьРегистрОсновныеДоговорыКонтрагентов.Получить();	
	
КонецФункции

Функция ДопустимоеЧислоДнейЗадолженности(ДоговорКонтрагента, ДатаПроверки = Неопределено) Экспорт
	
	ДопустимоеЧислоДнейЗадолженности = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ДоговорыКонтрагентов.ВременнаяОтсрочка_Использовать
	|					И (ДоговорыКонтрагентов.ВременнаяОтсрочка_СрокДействия >= &ДатаПроверки
	|				ИЛИ ДоговорыКонтрагентов.ВременнаяОтсрочка_СрокДействия = ДАТАВРЕМЯ(1, 1, 1))
	|			ТОГДА ДоговорыКонтрагентов.ВременнаяОтсрочка_ДопустимоеЧислоДнейЗадолженности
	|		ИНАЧЕ ДоговорыКонтрагентов.ДопустимоеЧислоДнейЗадолженности
	|	КОНЕЦ КАК ДопустимоеЧислоДнейЗадолженности
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &ДоговорКонтрагента";
	
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ДатаПроверки", ?(ЗначениеЗаполнено(ДатаПроверки), НачалоДня(ДатаПроверки), НачалоДня(ТекущаяДата())));
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДопустимоеЧислоДнейЗадолженности = Выборка.ДопустимоеЧислоДнейЗадолженности;
	КонецЕсли;
	
	Возврат ДопустимоеЧислоДнейЗадолженности;
	
КонецФункции

Функция ДопустимоеЧислоДнейЗадолженностиОсобыеУсловия(ДоговорКонтрагента, ТипПоставки, Номенклатура, ДатаПроверки = Неопределено) Экспорт
	
	ДопустимоеЧислоДнейЗадолженности = Новый Структура;
	ДопустимоеЧислоДнейЗадолженности.Вставить("ДопустимоеЧислоДнейЗадолженности", 0);
	ДопустимоеЧислоДнейЗадолженности.Вставить("ВидРасчетаДней", Неопределено);
	
	Если ТипЗнч(Номенклатура) = Тип("Массив") Тогда
		ТЗТовары = Новый ТаблицаЗначений;
		ТЗТовары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов(Тип("СправочникСсылка.Номенклатура")));
		Для каждого текНоменклатура Из Номенклатура Цикл
			ТЗТовары.Добавить().Номенклатура = текНоменклатура;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("ТаблицаЗначений") Тогда
		ТЗТовары = Номенклатура;
	Иначе
		Сообщить("Не удалось определить особые условия отсрочки, не задана номенклатура!");
		Возврат ДопустимоеЧислоДнейЗадолженности;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	табНоменклатура.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ втНоменклатура
		|ИЗ
		|	&Номенклатура КАК табНоменклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СпрНом.Изготовитель КАК Изготовитель
		|ПОМЕСТИТЬ Изготовители
		|ИЗ
		|	втНоменклатура КАК втНоменклатура
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНом
		|		ПО (СпрНом.Ссылка = втНоменклатура.Номенклатура)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ОсобыеУсловияОтсрочкиСрезПоследних.ДопустимоеЧислоДнейЗадолженности) КАК ДопустимоеЧислоДнейЗадолженности,
		|	ОсобыеУсловияОтсрочкиСрезПоследних.ВидРасчетаДней
		|ИЗ
		|	РегистрСведений.ОсобыеУсловияОтсрочки.СрезПоследних(
		|			&ДатаПроверки,
		|			ДоговорКонтрагента = &ДоговорКонтрагента
		|				И ТипПоставки = &ТипПоставки
		|				И Изготовитель В
		|					(ВЫБРАТЬ
		|						Изготовители.Изготовитель
		|					ИЗ
		|						Изготовители)
		|				И (ДатаОкончания >= &ДатаПроверки
		|					ИЛИ ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))) КАК ОсобыеУсловияОтсрочкиСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ОсобыеУсловияОтсрочкиСрезПоследних.ВидРасчетаДней";
	
	Запрос.УстановитьПараметр("Номенклатура", ТЗТовары);
	Запрос.УстановитьПараметр("ТипПоставки", ТипПоставки);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ДатаПроверки", ?(ЗначениеЗаполнено(ДатаПроверки), НачалоДня(ДатаПроверки), НачалоДня(ТекущаяДата())));
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаДней = РезультатЗапроса.Выгрузить();
	
	Если ТаблицаДней.Количество() = 1 Тогда
		ЗаполнитьЗначенияСвойств(ДопустимоеЧислоДнейЗадолженности, ТаблицаДней[0]);
	КонецЕсли;
	
	Возврат ДопустимоеЧислоДнейЗадолженности;
	
КонецФункции

Функция ДоговорВзаиморасчетов(Договор) Экспорт
	     
	Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "Владелец");
	ГоловнойКонтрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ГоловнойКонтрагент");
	
	ДоговорВзаиморасчетов = Договор;
	Если Контрагент <> ГоловнойКонтрагент И ЗначениеЗаполнено(ГоловнойКонтрагент) Тогда
		//Запрос = Новый Запрос("ВЫБРАТЬ
		//                      |	ДоговорыКонтрагентов.Ссылка,
		//                      |	ВЫБОР
		//                      |		КОГДА ДоговорыКонтрагентов.ДоговорНаОферту = &ДоговорНаОферту
		//                      |			ТОГДА 0
		//                      |		ИНАЧЕ 1
		//                      |	КОНЕЦ КАК Приоритет
		//                      |ИЗ
		//                      |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		//                      |ГДЕ
		//                      |	ДоговорыКонтрагентов.Владелец = &ГоловнойКонтрагент
		//                      |	И ДоговорыКонтрагентов.Организация = &Организация
		//                      |	И НЕ ДоговорыКонтрагентов.ПометкаУдаления
		//                      |	И НЕ ДоговорыКонтрагентов.СлужебныйДоговор
		//                      |	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
		//                      |	И ДоговорыКонтрагентов.ВидОплаты = &ВидОплаты
		//                      |	И НЕ ДоговорыКонтрагентов.ДоговорПриостановлен
		//                      |
		//                      |УПОРЯДОЧИТЬ ПО
		//                      |	Приоритет");
		//Запрос.УстановитьПараметр("ГоловнойКонтрагент", ГоловнойКонтрагент);
		//Запрос.УстановитьПараметр("ДоговорНаОферту", Договор.ДоговорНаОферту);
		//Запрос.УстановитьПараметр("Организация", Договор.Организация);
		//Запрос.УстановитьПараметр("ВидДоговора", Договор.ВидДоговора);
		//Запрос.УстановитьПараметр("ВидОплаты", Договор.ВидОплаты);
		//Выборка = Запрос.Выполнить().Выбрать();
		//ДоговорВзаиморасчетов = ?(Выборка.Следующий(), Выборка.Ссылка, Договор);
		
		//ХудинВВ 20180724, XX-356 При расчете даты оплаты для подчиненных контрагентов (головной контрагент не равен контрагенту), 
		//брать количество дней отсрочки оплаты из основного договора головного контрагента. 
		//Если основной договор не установлен берем из договора в документе. 
		ОсновнойДоговорКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнойКонтрагент, "ОсновнойДоговорКонтрагента");
		Если ЗначениеЗаполнено(ОсновнойДоговорКонтрагента) Тогда
			 ДоговорВзаиморасчетов = ОсновнойДоговорКонтрагента;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДоговорВзаиморасчетов;
	
КонецФункции

Функция СуммаДолгаПоДоговору(Договор) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(ВзаиморасчетыОстатки.ДоговорКонтрагента, ДепозитыКонтрагентовОстатки.ДоговорКонтрагента) КАК ДоговорКонтрагента,
	                      |	ЕСТЬNULL(ВзаиморасчетыОстатки.СуммаУпрОстаток, 0) + ЕСТЬNULL(ДепозитыКонтрагентовОстатки.СуммаУпрОстаток, 0) КАК СуммаДолга
	                      |ИЗ
	                      |	РегистрНакопления.Взаиморасчеты.Остатки(, ДоговорКонтрагента = &ДоговорКонтрагента) КАК ВзаиморасчетыОстатки
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ДепозитыКонтрагентов.Остатки(, ДоговорКонтрагента = &ДоговорКонтрагента) КАК ДепозитыКонтрагентовОстатки
	                      |		ПО ВзаиморасчетыОстатки.ДоговорКонтрагента = ДепозитыКонтрагентовОстатки.ДоговорКонтрагента");
	Запрос.УстановитьПараметр("ДоговорКонтрагента", Договор);
	Результат = Запрос.Выполнить().Выбрать();
	Возврат ?(Результат.Следующий(), Результат.СуммаДолга, 0)
	
КонецФункции
