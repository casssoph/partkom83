﻿
Функция ВзаимосвязьУникальна(СвзяьОбъект) Экспорт
	
	ВзаимосвязьУникальна = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка
	|ИЗ
	|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
	|ГДЕ
	|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = &ТекущийСтатус
	|	И ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус = &СледующийСтатус
	|	И НЕ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СвзяьОбъект.Ссылка);
	Запрос.УстановитьПараметр("СледующийСтатус", СвзяьОбъект.СледующийСтатус);
	Запрос.УстановитьПараметр("ТекущийСтатус", СвзяьОбъект.ТекущийСтатус);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		ВзаимосвязьУникальна = Ложь;
	КонецЕсли;

	Возврат ВзаимосвязьУникальна;
	
КонецФункции

Функция ДоступныеВзаимосвязиТекущегоСтатуса(ТекущийСтатус, ТекстОтбора = "") Экспорт
	
	ДоступныеВзаимосвязи = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка,
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Наименование
		|ИЗ
		|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
		|ГДЕ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = &ТекущийСтатус
		|	И НЕ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ПометкаУдаления
		|	И ИСТИНА";
	
	Запрос.УстановитьПараметр("ТекущийСтатус", ТекущийСтатус);
	Если ЗначениеЗаполнено(ТекстОтбора) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИСТИНА", ТекстОтбора);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДоступныеВзаимосвязи.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат ДоступныеВзаимосвязи;	
	
КонецФункции

//Используется для вывода кнопок на форме
Функция ТаблицаКомандДляТекущегоСтатуса(ТекущийСтатус, Знач Пользователь = Неопределено) Экспорт
	
	лКлючАлгоритма = "Справочник_ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя_МодульМенеджера_ТаблицаКомандДляТекущегоСтатуса";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если Пользователь = Неопределено Тогда
		Пользователь = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	ДоступныеВзаимосвязи = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка КАК Команда,
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.СледующийСтатус.Наименование КАК НаименованиеКоманды,
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ИмяКоманды КАК ИмяКоманды,
		|	ЗНАЧЕНИЕ(Перечисление.РасположенияКомандыПроцесса.ВверхуФормы) КАК Расположение,
		|	ЛОЖЬ КАК НаКлиенте,
		|	ИСТИНА КАК Доступность,
		|	ИСТИНА КАК Видимость,
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Автоматически КАК Автоматически,
		|	0 КАК Приоритет
		|ИЗ
		|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
		|ГДЕ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = &ТекущийСтатус
		|	И НЕ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ПометкаУдаления
		|	И НЕ ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка В (&ЗапрещенныеВзаимосвязиГруппыДоступности)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса,
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса.Наименование,
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса.Имя,
		|	СтатусыДокументовКомандыПроцесса.Расположение,
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса.НаКлиенте,
		|	ИСТИНА,
		|	ИСТИНА,
		|	СтатусыДокументовКомандыПроцесса.КомандаПроцесса.Автоматически,
		|	СтатусыДокументовКомандыПроцесса.НомерСтроки
		|ИЗ
		|	Справочник.СтатусыДокументов.КомандыПроцесса КАК СтатусыДокументовКомандыПроцесса
		|ГДЕ
		|	СтатусыДокументовКомандыПроцесса.Ссылка = &ТекущийСтатус
		|	И НЕ СтатусыДокументовКомандыПроцесса.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Запрос.УстановитьПараметр("ЗапрещенныеВзаимосвязиГруппыДоступности", ЗапрещенныеВзаимосвязиГруппыДоступности( ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя"), ТекущийСтатус));
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ТекущийСтатус", ТекущийСтатус);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаКоманд = РезультатЗапроса.Выгрузить();
	
	ТаблицаКоманд.Колонки.Добавить("Подсказка", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(0)));
	
	Возврат ТаблицаКоманд;
	
КонецФункции

//Ограничение взаимосвязей по группе доступности
Функция ЗапрещенныеВзаимосвязиГруппыДоступности(ГруппаДоступа, Статус)
	
	лКлючАлгоритма = "Справочник_ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя_МодульМенеджера_ЗапрещенныеВзаимосвязиГруппыДоступности";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	ВозвращаемоеЗначение = Новый Массив;
	
	РежимОграниченияВзаимосвязей = РежимОграниченияВзаимосвязей(ГруппаДоступа, Статус);
	
	Если РежимОграниченияВзаимосвязей = Перечисления.РежимыОграниченияВзаимосвязейГруппДоступаКСтатусамПроцессаВозвратов.УказыватьЗапрещенные Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяТаблицаОграниченияВзаимосвязей.Взаимосвязь
		|ИЗ
		|	Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.ТаблицаОграниченияВзаимосвязей КАК ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяТаблицаОграниченияВзаимосвязей
		|ГДЕ
		|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяТаблицаОграниченияВзаимосвязей.Статус = &Статус
		|	И ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяТаблицаОграниченияВзаимосвязей.Ссылка = &ГруппаДоступа");
		
		Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
		Запрос.УстановитьПараметр("Статус", Статус);
		
		ВозвращаемоеЗначение = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Взаимосвязь");
		
	ИначеЕсли РежимОграниченияВзаимосвязей = Перечисления.РежимыОграниченияВзаимосвязейГруппДоступаКСтатусамПроцессаВозвратов.УказыватьРазрешенные Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка КАК Взаимосвязь
		|ИЗ
		|	Справочник.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя КАК ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.ТаблицаОграниченияВзаимосвязей КАК РазрешенныеВзаимосвязи
		|		ПО (РазрешенныеВзаимосвязи.Ссылка = &ГруппаДоступа)
		|			И (РазрешенныеВзаимосвязи.Статус = &Статус)
		|			И (РазрешенныеВзаимосвязи.Взаимосвязь = ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.Ссылка)
		|			И ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = РазрешенныеВзаимосвязи.Статус
		|ГДЕ
		|	ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТекущийСтатус = &Статус
		|	И РазрешенныеВзаимосвязи.Взаимосвязь ЕСТЬ NULL";
		
		Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
		Запрос.УстановитьПараметр("Статус", Статус);
		
		ВозвращаемоеЗначение = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Взаимосвязь");
		
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;	
		
КонецФункции

Функция РежимОграниченияВзаимосвязей(ГруппаДоступа, Статус) Экспорт
	
	лКлючАлгоритма = "Справочник_ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя_МодульМенеджера_РежимОграниченияВзаимосвязей";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.РежимОграниченияВзаимосвязей
	|ИЗ
	|	Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.Статусы КАК ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы
	|ГДЕ
	|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Ссылка = &ГруппаДоступа
	|	И ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Статус = &Статус";
	
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("Статус", Статус);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	РежимОграниченияВзаимосвязей = Неопределено;
	Пока Выборка.Следующий() Цикл
		РежимОграниченияВзаимосвязей = Выборка.РежимОграниченияВзаимосвязей;		
	КонецЦикла;
	
	Возврат РежимОграниченияВзаимосвязей;
	
КонецФункции