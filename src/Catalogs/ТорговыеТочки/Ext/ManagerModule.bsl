﻿Функция ПолучитьМетаданные()
	Возврат Метаданные.Справочники.ТорговыеТочки;	
КонецФункции

// + 20170301 Пушкин
Функция ПолучитьРеквизитыКонтроля(вхМетаданныеОтбора) Экспорт
	Если (вхМетаданныеОтбора = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные()) тогда
		//Возврат (Новый Структура("Шапка", "Владелец,Наименование,Код")); //,КПП,Регион,Город
		Возврат (Новый Структура("Шапка", "Наименование,Код"));
	КонецЕсли;
КонецФункции
// - 20170301 Пушкин

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
КонецФункции

// + 20170301 Пушкин
Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена) Экспорт
	
	Результат = Новый Массив;
	
	лМетаданныеПланаОбмена = Неопределено;
	лТип = ТипЗнч(вхПланОбмена);
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.Найти(вхПланОбмена);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.ПланыОбмена.Содержит(вхПланОбмена) тогда
		лМетаданныеПланаОбмена = вхПланОбмена;
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = Неопределено) тогда
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные()) тогда
		
		лЗапрос = Новый Запрос;
		лЗапрос.УстановитьПараметр("ТаблицаСсылок", вхТаблицаСсылокНаОбъекты);
		лЗапрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Ссылка
		|ПОМЕСТИТЬ ЗарегистрированныеОбъекты
		|ИЗ
		|	&ТаблицаСсылок КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Ссылка,
		|	ВЫБОР
		|		КОГДА Т.Ссылка В
		|				(ВЫБРАТЬ
		|					Справочник.ТорговыеТочки.Ссылка
		|				ИЗ
		|					Справочник.ТорговыеТочки)
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
		|	Т.Ссылка КАК Ссылка,
		|	Т.Наименование КАК Наименование,
		|	Т.Код КАК Код
		|ИЗ
		|	Справочник.ТорговыеТочки КАК Т
		|ГДЕ
		|	Т.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Ссылка
		|ИЗ
		|	Объекты КАК Т
		|ГДЕ
		|	Т.ЭтоУдаление
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ Объекты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ЗарегистрированныеОбъекты";
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		лРезультатыЗапроса = лЗапрос.ВыполнитьПакет();
		Если НЕ лРезультатыЗапроса[2].Пустой() тогда
			лТипОбъектаXDTO = лМенеджерПланаОбмена.ТипПоОбъектуМетаданных(ПолучитьМетаданные());
			лВыборка = лРезультатыЗапроса[2].Выбрать();
			Пока лВыборка.Следующий() цикл
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				
				лОбъект.Ссылка = лВыборка.Ссылка.УникальныйИдентификатор();
				лОбъект.Код = лВыборка.Код;
				лОбъект.Наименование = лВыборка.Наименование;
				лОбъект.Контрагент = лВыборка.Ссылка.Владелец.УникальныйИдентификатор();
				
				Результат.Добавить(лОбъект);
			КонецЦикла;			
		КонецЕсли;
		
		Если НЕ лРезультатыЗапроса[3].Пустой() тогда
			лМассивСсылок = лРезультатыЗапроса[3].Выгрузить().ВыгрузитьКолонку(0);
			лМенеджерПланаОбмена = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лМетаданныеПланаОбмена);
			лОбъекты = лМенеджерПланаОбмена.ВыгрузитьУдаленияЭлементов(лМассивСсылок, ПолучитьМетаданные());
			Для Каждого лОбъект Из лОбъекты цикл
				Результат.Добавить(лОбъект);
			КонецЦикла;			
		КонецЕсли;
	ИначеЕсли лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда 	
		лЗапрос = Новый Запрос;
		лЗапрос.УстановитьПараметр("ТаблицаСсылок", вхТаблицаСсылокНаОбъекты);
		лЗапрос.УстановитьПараметр("ВидФактАдрес", Справочники.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента); //Изменено Валиахметов А.А. 07.06.2018 по просьбе из ТопЛога
		лЗапрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонТорговойТочки);
		лЗапрос.УстановитьПараметр("ВидЭмейл", Справочники.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами);
		лЗапрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Ссылка
		|ПОМЕСТИТЬ ЗарегистрированныеОбъекты
		|ИЗ
		|	&ТаблицаСсылок КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Ссылка,
		|	ВЫБОР
		|		КОГДА Т.Ссылка В
		|				(ВЫБРАТЬ
		|					Справочник.ТорговыеТочки.Ссылка
		|				ИЗ
		|					Справочник.ТорговыеТочки)
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
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Объект КАК Справочник.Контрагенты) КАК Объект,
		|	КонтактнаяИнформация.Представление КАК EmailДляОбменаДокументами
		|ПОМЕСТИТЬ втЭмейлДляОбмена
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект В
		|			(ВЫБРАТЬ
		|				ВЫРАЗИТЬ(Объекты.Ссылка КАК Справочник.ТорговыеТочки).Владелец
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|	И КонтактнаяИнформация.Вид = &ВидЭмейл
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Объект КАК Справочник.Контрагенты) КАК Объект,
		|	КонтактнаяИнформация.Представление
		|ПОМЕСТИТЬ втФактАдреса
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект В
		|			(ВЫБРАТЬ
		|				ВЫРАЗИТЬ(Объекты.Ссылка КАК Справочник.ТорговыеТочки).Владелец
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|	И КонтактнаяИнформация.Вид = &ВидФактАдрес
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Объект КАК Справочник.ТорговыеТочки) КАК Объект,
		|	КонтактнаяИнформация.Представление
		|ПОМЕСТИТЬ втТелефоны
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|	И КонтактнаяИнформация.Вид = &ВидТелефон
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Ссылка КАК Ссылка,
		|	Т.Наименование КАК Наименование,
		|	Т.ПометкаУдаления КАК ПометкаУдаления,
		|	Т.КПП КАК КПП,
		|	ЕСТЬNULL(Т.Владелец.ИНН, """") КАК ИНН,
		|	ЕСТЬNULL(Т.Владелец.КодПоОКПО, """") КАК КодПоОКПО,
		|	ЕСТЬNULL(Т.Владелец.ЮрФизЛицо.Порядок = 0, 0) КАК ЭтоЮридическоеЛицо,
		|	ЕСТЬNULL(втФактАдреса.Представление, """") КАК ФактическийАдрес,
		|	ЕСТЬNULL(втТелефоны.Представление, """") КАК Телефон,
		|	Т.АвтоВозвратПоставщику КАК АвтоВозврат,
		|	Т.VIP КАК VIP,
		|	ЕСТЬNULL(Т.Регион.Наименование, """") КАК Регион,
		|	ЕСТЬNULL(Т.Город.Код, """") КАК КодГород,
		|	Т.Код КАК Код,
		|	ЕСТЬNULL(Т.Владелец.ПечататьОнЛайнЧек, ЛОЖЬ) КАК КассовыйЧек,
		|	ЕСТЬNULL(Т.МаршрутДоставки.Код, """") КАК МаршрутДоставкиКод,
		|	ЕСТЬNULL(втЭмейлДляОбмена.EmailДляОбменаДокументами, """") КАК EmailДляОбменаДокументами,
		|	Т.АвтоотправкаОтгрузочныхДокументов,
		|	Т.АвтоотправкаОтгрузочныхДокументовСКомментариями,
		|	Т.АвтоотправкаОтгрузочныхДокументовНеАрхивировать,
		|	ЕСТЬNULL(Т.Владелец.Покупатель, ЛОЖЬ) КАК Покупатель,
		|	ЕСТЬNULL(Т.Владелец.Поставщик, ЛОЖЬ) КАК Поставщик
		|ИЗ
		|	Справочник.ТорговыеТочки КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ втФактАдреса КАК втФактАдреса
		|		ПО Т.Владелец = втФактАдреса.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ втТелефоны КАК втТелефоны
		|		ПО Т.Ссылка = втТелефоны.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ втЭмейлДляОбмена КАК втЭмейлДляОбмена
		|		ПО Т.Владелец = втЭмейлДляОбмена.Объект
		|ГДЕ
		|	Т.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Ссылка
		|ИЗ
		|	Объекты КАК Т
		|ГДЕ
		|	Т.ЭтоУдаление
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ Объекты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ЗарегистрированныеОбъекты";
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		лРезультатыЗапроса = лЗапрос.ВыполнитьПакет();
		Если НЕ лРезультатыЗапроса[лРезультатыЗапроса.ВГраница() - 3].Пустой() тогда
			лТипОбъектаXDTO = лМенеджерПланаОбмена.ТипПоОбъектуМетаданных(ПолучитьМетаданные());
			лВыборка = лРезультатыЗапроса[лРезультатыЗапроса.ВГраница() - 3].Выбрать();
			Пока лВыборка.Следующий() цикл
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				ЗаполнитьЗначенияСвойств(лОбъект, лВыборка,,"Ссылка");
				лОбъект.Покупатель = лВыборка.Покупатель;
				лОбъект.Поставщик = лВыборка.Поставщик;
				
				лОбъект.Ссылка = XMLСтрока(лВыборка.Ссылка);
				//лОбъект.МаршрутДоставкиСсылка = XMLСтрока(лВыборка.МаршрутДоставки);
				
				Результат.Добавить(лОбъект);
			КонецЦикла;			
		КонецЕсли;
		Если НЕ лРезультатыЗапроса[лРезультатыЗапроса.ВГраница() - 2].Пустой() тогда
			лМассивСсылок = лРезультатыЗапроса[лРезультатыЗапроса.ВГраница() - 2].Выгрузить().ВыгрузитьКолонку(0);
			лМенеджерПланаОбмена = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лМетаданныеПланаОбмена);
			лОбъекты = лМенеджерПланаОбмена.ВыгрузитьУдаленияЭлементов(лМассивСсылок, ПолучитьМетаданные());
			Для Каждого лОбъект Из лОбъекты цикл
				Результат.Добавить(лОбъект);
			КонецЦикла;			
		КонецЕсли;	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
// - 20170301 Пушкин
