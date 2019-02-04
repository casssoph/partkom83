﻿//Обмен 1С-Сайт: ОбменПартКом83_Сайт_состояние_заявок//
Процедура ДобавитьДанныеИсторииСтрокЗаявок(Список, НомерСообщения) Экспорт
	
	//Временный переключатель, данные пойдут из РС.ИсторияЗаявокПокупателя//
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт","Выгружать историю строк заявок", Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДата();
	ТипОбъектаXDTO = ФабрикаXDTO.Тип("http://ws-02.part-kom.ru/partkom83/hs/SiteExchange/XMLSchema", "ИсторияСтрокЗаявок");
	ВыборкаИсторииСтрокЗаявок = ВыборкаИсторииСтрокЗаявок();
	
	Пока ВыборкаИсторииСтрокЗаявок.Следующий() Цикл
		
		ОбъектXDTO = ФабрикаXDTO.Создать(ТипОбъектаXDTO);
		ЗаполнитьЗначенияСвойств(ОбъектXDTO, ВыборкаИсторииСтрокЗаявок, "IDSite,Количество,НомерЗаявки,Артикул,Цена,ЗакупочнаяЦена");
		ОбъектXDTO.Состояние = ВыборкаИсторииСтрокЗаявок.Состояние.УникальныйИдентификатор();
		ОбъектXDTO.ВерсияДанных = ВыборкаИсторииСтрокЗаявок.Период;
		ОбъектXDTO.Склад = ВыборкаИсторииСтрокЗаявок.СкладСсылка.УникальныйИдентификатор();
		Список.Добавить(ОбъектXDTO);
		//Семенов И.П. 31.01.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(ВыборкаИсторииСтрокЗаявок.СтрокаЗаявки,ОбъектXDTO,"РегистрСведений._ИсторияСтрокЗаявок");
		//)Семенов И.П.
		Запись = РегистрыСведений._ИсторияСтрокЗаявок.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, ВыборкаИсторииСтрокЗаявок, "Период,СтрокаЗаявки,Состояние");
		Запись.Прочитать();
		Запись.НомерСообщенияОтправленного = НомерСообщения;
		Запись.ДатаОтправки = ТекущаяДата;
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ФиксацияПринятогоСообщения(НомерСообщения) Экспорт
	
	ТекущаяДата = ТекущаяДата();
	Выборка = ВыборкаПодтвержденныхСтрокЗаявок(НомерСообщения);
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений._ИсторияСтрокЗаявок.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка, "Период,СтрокаЗаявки,Состояние");
		Запись.Прочитать();
		Запись.ДатаОбработкиСайтом = ТекущаяДата;
		Запись.ПолученоСайтом = Истина;
		Запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ВыборкаИсторииСтрокЗаявок()
	
	КоличествоОбъектов = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен (Общее)","Количество объектов в обмене", 1000);
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1234
	                      |	_ИсторияСтрокЗаявок.СтрокаЗаявки,
	                      |	_ИсторияСтрокЗаявок.IDSite,
	                      |	_ИсторияСтрокЗаявок.Период КАК Период,
	                      |	ЕСТЬNULL(_ИсторияСтрокЗаявок.СтрокаЗаявки.Заявка.Номер, """") КАК НомерЗаявки,
	                      |	ЕСТЬNULL(_ИсторияСтрокЗаявок.СтрокаЗаявки.Заявка.Склад.Код, 0) КАК Склад,
	                      |	ЕСТЬNULL(_ИсторияСтрокЗаявок.СтрокаЗаявки.Заявка.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК СкладСсылка,
	                      |	_ИсторияСтрокЗаявок.Количество,
	                      |	ЕСТЬNULL(_ИсторияСтрокЗаявок.СтрокаЗаявки.Цена, 0) КАК Цена,
	                      |	ЕСТЬNULL(_ИсторияСтрокЗаявок.СтрокаЗаявки.ЦенаЗакупки, 0) КАК ЗакупочнаяЦена,
	                      |	_ИсторияСтрокЗаявок.Состояние,
	                      |	ВЫБОР
	                      |		КОГДА _ИсторияСтрокЗаявок.СтрокаЗаявки.ПоследняяКорректировка <> ЗНАЧЕНИЕ(Документ.КорректировкаЗаявкиПокупателя.ПустаяСсылка)
	                      |			ТОГДА _ИсторияСтрокЗаявок.СтрокаЗаявки.ПоследняяКорректировка
	                      |		ИНАЧЕ _ИсторияСтрокЗаявок.СтрокаЗаявки.Заявка
	                      |	КОНЕЦ КАК ДокументСвязи
	                      |ПОМЕСТИТЬ ДанныеИстории
	                      |ИЗ
	                      |	РегистрСведений._ИсторияСтрокЗаявок КАК _ИсторияСтрокЗаявок
	                      |ГДЕ
	                      |	НЕ _ИсторияСтрокЗаявок.ПолученоСайтом
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЗаявкаПокупателяТовары.Ссылка КАК Документ,
	                      |	ЗаявкаПокупателяТовары.СтрокаЗаявки,
	                      |	ЗаявкаПокупателяТовары.Номенклатура
	                      |ПОМЕСТИТЬ ОпределениеНоменклатуры
	                      |ИЗ
	                      |	Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
	                      |ГДЕ
	                      |	ЗаявкаПокупателяТовары.Ссылка В
	                      |			(ВЫБРАТЬ
	                      |				ДанныеИстории.ДокументСвязи
	                      |			ИЗ
	                      |				ДанныеИстории КАК ДанныеИстории)
	                      |	И ЗаявкаПокупателяТовары.СтрокаЗаявки В
	                      |			(ВЫБРАТЬ
	                      |				ДанныеИстории.СтрокаЗаявки
	                      |			ИЗ
	                      |				ДанныеИстории КАК ДанныеИстории)
	                      |
	                      |ОБЪЕДИНИТЬ ВСЕ
	                      |
	                      |ВЫБРАТЬ
	                      |	КорректировкаЗаявкиПокупателяТовары.Ссылка,
	                      |	КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки,
	                      |	КорректировкаЗаявкиПокупателяТовары.Номенклатура
	                      |ИЗ
	                      |	Документ.КорректировкаЗаявкиПокупателя.Товары КАК КорректировкаЗаявкиПокупателяТовары
	                      |ГДЕ
	                      |	КорректировкаЗаявкиПокупателяТовары.Ссылка В
	                      |			(ВЫБРАТЬ
	                      |				ДанныеИстории.ДокументСвязи
	                      |			ИЗ
	                      |				ДанныеИстории КАК ДанныеИстории)
	                      |	И КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки В
	                      |			(ВЫБРАТЬ
	                      |				ДанныеИстории.СтрокаЗаявки
	                      |			ИЗ
	                      |				ДанныеИстории КАК ДанныеИстории)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ДанныеИстории.СтрокаЗаявки,
	                      |	ДанныеИстории.IDSite,
	                      |	ДанныеИстории.Период,
	                      |	ДанныеИстории.НомерЗаявки,
	                      |	ДанныеИстории.Склад,
	                      |	ДанныеИстории.СкладСсылка,
	                      |	ДанныеИстории.Количество,
	                      |	ДанныеИстории.Цена,
	                      |	ДанныеИстории.ЗакупочнаяЦена,
	                      |	ДанныеИстории.Состояние,
	                      |	ДанныеИстории.ДокументСвязи,
	                      |	ЕСТЬNULL(ОпределениеНоменклатуры.Номенклатура.Артикул, """") КАК Артикул
	                      |ИЗ
	                      |	ДанныеИстории КАК ДанныеИстории
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ОпределениеНоменклатуры КАК ОпределениеНоменклатуры
	                      |		ПО ДанныеИстории.СтрокаЗаявки = ОпределениеНоменклатуры.СтрокаЗаявки
	                      |			И ДанныеИстории.ДокументСвязи = ОпределениеНоменклатуры.Документ");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1234", Формат(КоличествоОбъектов, "ЧГ="));
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции
Функция ВыборкаПодтвержденныхСтрокЗаявок(НомерПринятого)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	_ИсторияСтрокЗаявок.Период,
	                      |	_ИсторияСтрокЗаявок.СтрокаЗаявки,
	                      |	_ИсторияСтрокЗаявок.Состояние
	                      |ИЗ
	                      |	РегистрСведений._ИсторияСтрокЗаявок КАК _ИсторияСтрокЗаявок
	                      |ГДЕ
	                      |	_ИсторияСтрокЗаявок.НомерСообщенияОтправленного МЕЖДУ 1 И &НомерПринятого
	                      |	И НЕ _ИсторияСтрокЗаявок.ПолученоСайтом");
	Запрос.УстановитьПараметр("НомерПринятого", НомерПринятого);
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции