﻿Функция ПолучитьРеквизитыКонтроля(МетаданныеОтбора) Экспорт
	
	СтруктураПроверяемыхРеквизитов = Новый Структура;
	
	Если МетаданныеОтбора = ПланыОбмена.ОбменПартКом83_Сайт.ПолучитьМетаданные() Тогда
		СтруктураПроверяемыхРеквизитов.Вставить("Шапка", "Наименование,Код,Город,СкладVMI,Филиал,ТипСклада,ФизическийСклад,ОсновнойСкладРегиона,КодСайта,АвтоматическоеПеремещение");
	КонецЕсли;
	
	Возврат СтруктураПроверяемыхРеквизитов;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
	
КонецФункции

Функция ВыгрузитьЭлементы(ТаблицаСсылокНаОбъекты, МетаданныеПланаОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	Если МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт Тогда
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты);
	ИначеЕсли МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда	
		ВыгрузитьДанныеПланаОбменаОбменПартКом83_TopLog(МассивОбъектов, ТаблицаСсылокНаОбъекты);
	Иначе
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Возврат МассивОбъектов;
	
КонецФункции

Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_Сайт(МассивОбъектов, ТаблицаСсылокНаОбъекты)
	
	//ВНИМАНИЕ
	//При добавлении новых реквизитов в обмен, изменить функцию ПолучитьРеквизитыКонтроля
	
	URI = ПланыОбмена.ОбменПартКом83_Сайт.URIПространстваИмен();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.Склады");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_Сайт(ТаблицаСсылокНаОбъекты);
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		ОбъектXDTO.ФизическийСклад = Выборка.ФизическийСклад.УникальныйИдентификатор();
		ОбъектXDTO.Филиал = Выборка.Филиал.УникальныйИдентификатор();
		
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка, "Наименование,ГородНаименование,ПризнакVMI,Адрес,Оптовый,АвтоматическоеПеремещение");
		ОбъектXDTO.КонтрагентПополненияСкладаЛогин = СокрЛП(Выборка.КонтрагентПополненияСкладаЛогин);
		Если Выборка.ТипСкладаПорядок <> NULL Тогда 
			ОбъектXDTO.ТипСклада = //ФабрикаXDTO.Тип(URI, "EnumRef.ТипыСкладов").Фасеты.Перечисления.Получить(Выборка.ТипСкладаПорядок).Значение;
			Метаданные.Перечисления.ТипыСкладов.ЗначенияПеречисления.Получить(Выборка.ТипСкладаПорядок).Имя;
		КонецЕсли;
		
		ОбъектXDTO.Код = ЧислоБезВедущихНулей(Выборка.Код);
		ОбъектXDTO.КодСайта = ЧислоБезВедущихНулей(Выборка.КодСайта);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;	
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.Склады";
		ОбъектXDTO.Ссылка = Выборка.Ссылка.УникальныйИдентификатор();
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
	
КонецПроцедуры
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
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады)) <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
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
	                      |	Объекты.Ссылка.Код КАК Код,
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.СкладVMI
	                      |			ТОГДА 1
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК ПризнакVMI,
	                      |	ЕСТЬNULL(Объекты.Ссылка.Город.Наименование, """") КАК ГородНаименование,
	                      |	Объекты.Ссылка.КодСайта КАК КодСайта,
	                      |	Объекты.Ссылка.Филиал КАК Филиал,
	                      |	Объекты.Ссылка.ФизическийСклад КАК ФизическийСклад,
	                      |	ЕСТЬNULL(КонтактнаяИнформация.Представление, """") КАК Адрес,
	                      |	ВЫБОР
	                      |		КОГДА Объекты.Ссылка.СкладVMI
	                      |				ИЛИ Объекты.Ссылка.ОсновнойСкладРегиона
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК Оптовый,
	                      |	Объекты.Ссылка.ТипСклада.Порядок КАК ТипСкладаПорядок,
	                      |	Объекты.Ссылка.АвтоматическоеПеремещение КАК АвтоматическоеПеремещение,
	                      |	ЕСТЬNULL(УчетныеЗаписиСайта.Код, """") КАК КонтрагентПополненияСкладаЛогин
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                      |		ПО Объекты.Ссылка = КонтактнаяИнформация.Объект
	                      |			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	                      |			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресСклада))
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УчетныеЗаписиСайта КАК УчетныеЗаписиСайта
	                      |		ПО Объекты.Ссылка.КонтрагентПополнениеСклада.ОсновнаяТорговаяТочка = УчетныеЗаписиСайта.Владелец
	                      |ГДЕ
	                      |	НЕ Объекты.ЭтоУдаление
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

Процедура ВыгрузитьДанныеПланаОбменаОбменПартКом83_TopLog(МассивОбъектов, ТаблицаСсылокНаОбъекты)
	
	URI = "http://partkom83-TopLogExchangeScheme.ru";
	ТипОбъектаXDTO = ФабрикаXDTO.Тип(URI, "Справочники.Склады");
	ТипУдалениеОбъекта = ФабрикаXDTO.Тип(URI, "УдалениеОбъекта");
	ОбъектыОбмена = ДанныеОбъектовПланаОбменаОбменПартКом83_TopLog(ТаблицаСсылокНаОбъекты);
	
	Выборка = ОбъектыОбмена[2].Выбрать();
	Пока Выборка.Следующий() цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, Выборка,, "Ссылка");
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П.
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
		
	Выборка = ОбъектыОбмена[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипУдалениеОбъекта);
		ОбъектXDTO.ТипОбъекта = "Справочники.Склады";
		ОбъектXDTO.Ссылка = XMLСтрока(Выборка.Ссылка);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(Выборка.Ссылка, ОбъектXDTO);
		//)Семенов И.П
		МассивОбъектов.Добавить(ОбъектXDTO);
	КонецЦикла;
		
КонецПроцедуры
Функция ДанныеОбъектовПланаОбменаОбменПартКом83_TopLog(ТаблицаСсылокНаОбъекты)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВнешняяТаблица.Ссылка
	                      |ПОМЕСТИТЬ ЗарегистрированныеОбъекты
	                      |ИЗ
	                      |	&ТаблицаСсылокНаОбъекты КАК ВнешняяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады) КАК Ссылка,
	                      |	ВЫБОР
	                      |		КОГДА ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады).ВерсияДанных ЕСТЬ NULL
	                      |				И (ВЫРАЗИТЬ(ЗарегистрированныеОбъекты.Ссылка КАК Справочник.Склады)) <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
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
	                      |	Объекты.Ссылка КАК Ссылка,
	                      |	Объекты.Ссылка.Наименование КАК Наименование,
	                      |	Объекты.Ссылка.ПометкаУдаления КАК ПометкаУдаления,
	                      |	Объекты.Ссылка.ЭтоГруппа КАК ЭтоГруппа
	                      |ИЗ
	                      |	Объекты КАК Объекты
	                      |ГДЕ
	                      |	НЕ Объекты.ЭтоУдаление
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

Функция ЧислоБезВедущихНулей(Строка)
	
	ЧислоСтрокой = 0;
	Попытка
		ЧислоСтрокой = Формат(Число(Строка), "ЧГ=");
	Исключение
	КонецПопытки;
	
	Возврат ЧислоСтрокой;
	
КонецФункции

Функция СкладыБракаИНедостач() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Склады.СкладНедостач КАК СкладНедостач
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	НЕ Склады.ЭтоГруппа
		|	И НЕ Склады.СкладНедостач = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|	И НЕ Склады.СкладНедостач.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СкладНедостач");
	
КонецФункции

Функция СкладыРегионов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	НЕ Склады.ЭтоГруппа
		|	И Склады.ОсновнойСкладРегиона
		|	И НЕ Склады.ТоварыВПути";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад");
	
КонецФункции

Функция СкладТоварыВПутиДляФизическогоСклада(ФизическийСклад) Экспорт

	СкладТоварыВПути = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Ссылка
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.ФизическийСклад = &ФизическийСклад
		|	И Склады.ТоварыВПути";
	
	Запрос.УстановитьПараметр("ФизическийСклад", ФизическийСклад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка= РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		 СкладТоварыВПути = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат СкладТоварыВПути;
	
КонецФункции

Функция СкладГородаРазгрузкиКонтрагента(Контрагент, ТекстОшибки = "") Экспорт
	
	СкладГородаРазгрузки = Неопределено;
	
	РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, "ОсновнаяТорговаяТочка.ГородПоставки, ОсновнаяТорговаяТочка.ГородПоставки2");
	
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОсновнаяТорговаяТочкаГородПоставки) Тогда
		ГородРазгрузки = РеквизитыКонтрагента.ОсновнаяТорговаяТочкаГородПоставки;
	ИначеЕсли  ЗначениеЗаполнено(РеквизитыКонтрагента.ОсновнаяТорговаяТочкаГородПоставки2) Тогда
		ГородРазгрузки = РеквизитыКонтрагента.ОсновнаяТорговаяТочкаГородПоставки2;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ГородРазгрузки) Тогда
		ТекстОшибки = ТекстОшибки = Символы.ПС + "Не заполнен город разгрузки контагента "+Контрагент+"!";
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Город = &Город
	|	И Склады.ОсновнойСкладРегиона";
	
	Запрос.УстановитьПараметр("Город", ГородРазгрузки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС + "Не найден склад для города разгрузки "+ГородРазгрузки+", контрагента: "+Контрагент+"!";
		
	ИначеЕсли  Выборка.Количество() > 1 Тогда
		
		ТекстОшибки = ТекстОшибки + Символы.ПС + "Не удалось определить склад! Найдено несколько складов для города разгрузки "+ГородРазгрузки+", контрагента "+Контрагент+":";
		Пока Выборка.Следующий() Цикл
			ТекстОшибки = ТекстОшибки + Символы.ПС + Выборка.Ссылка; 
		КонецЦикла;
		
	Иначе
		
		Выборка.Следующий(); 
		СкладГородаРазгрузки = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат СкладГородаРазгрузки;	  
	
КонецФункции

//ХудинВВ XX-2749 04072019
Функция ДатаБлокировкиИнтерактивныхДействий(Склад) Экспорт
	
	лКлючАлгоритма = "Справочник_Склады_МодульМенеджера_ДатаБлокировкиИнтерактивныхДействий";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ДатаБлокировкиИнтерактивныхДействий");
	
КонецФункции

//ХудинВВ XX-2749 04072019
Функция ЗапрещеныИнтерактивныеДействияПоСкладу(Склад, ДатаПроверки = Неопределено, СообщатьОбОшибке = Истина, ВызыватьИсключение = Истина, Отказ = Неопределено) Экспорт
	
	лКлючАлгоритма = "Справочник_Склады_МодульМенеджера_ЗапрещеныИнтерактивныеДействияПоСкладу";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	ДатаБлокировкиИнтерактивныхДействий = ДатаБлокировкиИнтерактивныхДействий(Склад);
	
	ДатаКонтроля = ?(ЗначениеЗаполнено(ДатаПроверки), ДатаПроверки, ТекущаяДата());
	
	ЗапрещеныИнтерактивныеДействияПоСкладу = ЗначениеЗаполнено(ДатаБлокировкиИнтерактивныхДействий) И  ДатаКонтроля >= ДатаБлокировкиИнтерактивныхДействий;
	
	Если ЗапрещеныИнтерактивныеДействияПоСкладу Тогда
		
		ТекстОшибки = "Для склада """+Склад+""" запрещена работа с "+Формат(ДатаБлокировкиИнтерактивныхДействий, "ДФ=dd.MM.yyyy")+"!";
		
		Если СообщатьОбОшибке Тогда
			Сообщить(ТекстОшибки, СтатусСообщения.Важное);
		КонецЕсли;
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Возврат ЗапрещеныИнтерактивныеДействияПоСкладу;
	
КонецФункции

