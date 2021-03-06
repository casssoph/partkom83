﻿
Процедура ЗаполнитьДеревоОстатков(ДеревоОстатков, ТекущаяНоменклатура) Экспорт
	
	ДеревоОстатков.Строки.Очистить();
	
	// + Пушкин 20180423 
	
	// PK83-560: выводить вместо заявок и заказов их корректировки, если они есть
	
	// 1.Последняя Корректировка заявки определяется просто: через СтрокуЗаявки
	// с последней Корректировкой заказа сложнее:
	// сначала определяю дату последней корректировки по заказу,
	// потом на этот момент времени получаю ссылку
	// и если корректировка имеет место быть - подставляю ссылку на нее в поле Заказ
	// 2.изменен алгоритм расчета кол-ва: из заявок вычитаются все отказы, из заказов, только отказы по заказам
	// 3.изменил процедуру заполнения дерева: без обхода по группировкам - просто запихиваю туда результат запроса
	
	//////Запрос = Новый Запрос(
	//////"ВЫБРАТЬ
	//////|	ТабОстатков.Склад КАК Склад,
	//////|	ТабОстатков.СтрокаЗаявки КАК СтрокаЗаявки,
	//////|	ТабОстатков.Общий КАК Общий,
	//////|	ТабОстатков.Заявка,
	//////|	ТабОстатков.Покупатель,
	//////|	ТабОстатков.КоличествоЗаявка КАК КоличествоЗаявка,
	//////|	ТабОстатков.СостояниеЗаявки,
	//////|	ТабОстатков.Поставщик,
	//////|	ТабОстатков.Заказ,
	//////|	ТабОстатков.КоличествоЗаказ КАК КоличествоЗаказ,
	//////|	ТабОстатков.СостояниеЗаказа,
	//////|	ТабОстатков.ВидОтказа,
	//////|	ТабОстатков.Отказано,
	//////|	ТабОстатков.ВРезерве КАК ВРезерве
	//////|ИЗ
	//////|	(ВЫБРАТЬ
	//////|		ТоварыНаСкладахОстатки.Склад КАК Склад,
	//////|		ТоварыНаСкладахОстатки.КоличествоОстаток КАК Общий,
	//////|		NULL КАК СтрокаЗаявки,
	//////|		NULL КАК Заявка,
	//////|		NULL КАК Покупатель,
	//////|		0 КАК КоличествоЗаявка,
	//////|		NULL КАК СостояниеЗаявки,
	//////|		NULL КАК Поставщик,
	//////|		NULL КАК Заказ,
	//////|		0 КАК КоличествоЗаказ,
	//////|		NULL КАК СостояниеЗаказа,
	//////|		NULL КАК ВидОтказа,
	//////|		0 КАК Отказано,
	//////|		0 КАК ВРезерве
	//////|	ИЗ
	//////|		РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура = &Номенклатура) КАК ТоварыНаСкладахОстатки
	//////|	
	//////|	ОБЪЕДИНИТЬ
	//////|	
	//////|	ВЫБРАТЬ
	//////|		Заявки.Склад,
	//////|		NULL,
	//////|		Заявки.СтрокаЗаявки,
	//////|		Заявки.СтрокаЗаявки.Заявка,
	//////|		Заявки.ДоговорКонтрагента.Владелец,
	//////|		Заявки.КоличествоОстаток,
	//////|		NULL,
	//////|		Заказы.ДоговорКонтрагента.Владелец,
	//////|		Заказы.СтрокаЗаявки.Заказ,
	//////|		ЕСТЬNULL(Заказы.КоличествоОстаток, 0) - ЕСТЬNULL(Отказы.КоличествоОборот, 0),
	//////|		Заявки.СтрокаЗаявки.СостояниеЗаказа,
	//////|		ЕСТЬNULL(Отказы.ПричинаОтказа.ВидОтказа, NULL),
	//////|		ЕСТЬNULL(Отказы.КоличествоОборот, 0),
	//////|		ЕСТЬNULL(Резервы.КоличествоОстаток, 0)
	//////|	ИЗ
	//////|		РегистрНакопления.ЗаявкиПокупателей.Остатки(, Номенклатура = &Номенклатура) КАК Заявки
	//////|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(, Номенклатура = &Номенклатура) КАК Заказы
	//////|			ПО Заявки.СтрокаЗаявки = Заказы.СтрокаЗаявки
	//////|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОтказыПоЗаявкам.Обороты КАК Отказы
	//////|			ПО Заявки.СтрокаЗаявки = Отказы.СтрокаЗаявки
	//////|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РезервыТоваров.Остатки(, Номенклатура = &Номенклатура) КАК Резервы
	//////|			ПО Заявки.СтрокаЗаявки = Резервы.СтрокаЗаявки
	//////|				И Заявки.Склад = Резервы.Склад) КАК ТабОстатков
	//////|
	//////|ИТОГИ
	//////|	СУММА(Общий),
	//////|	СУММА(КоличествоЗаявка),
	//////|	СУММА(КоличествоЗаказ),
	//////|	СУММА(Отказано),
	//////|	СУММА(ВРезерве)
	//////|ПО
	//////|	Склад,
	//////|	СтрокаЗаявки"
	//////);
	//////Запрос.УстановитьПараметр("Номенклатура", ТекущаяНоменклатура);
	//////Запрос.УстановитьПараметр("Пустой", Справочники.ВидыОтказов.ПустаяСсылка());
	//////	
	//////РезультатЗапроса = Запрос.Выполнить();
	//////
	//////Если НЕ РезультатЗапроса.Пустой() Тогда
	//////	ВыборкаСклад = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Склад");
	//////	Пока ВыборкаСклад.Следующий() Цикл
	//////		Если ЗначениеЗаполнено(ВыборкаСклад.Склад) Тогда
	//////			СтрокаСклад = ОстаткиТоваров.Строки.Добавить();
	//////			СтрокаСклад.Склад = ВыборкаСклад.Склад;
	//////			СтрокаСклад.Общий = ВыборкаСклад.Общий;
	//////			СтрокаСклад.КоличествоЗаявка = ВыборкаСклад.КоличествоЗаявка;
	//////			СтрокаСклад.КоличествоЗаказ = ВыборкаСклад.КоличествоЗаказ;
	//////			СтрокаСклад.ВРезерве = ВыборкаСклад.ВРезерве;
	//////			
	//////			ВыборкаЗаявка = ВыборкаСклад.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СтрокаЗаявки");
	//////			Пока ВыборкаЗаявка.Следующий() Цикл
	//////				ПерваяСтрокаЗаявки = Истина;
	//////				ВыборкаДетальных = ВыборкаЗаявка.Выбрать();
	//////				Пока ВыборкаДетальных.Следующий() Цикл
	//////					Если ПерваяСтрокаЗаявки Тогда
	//////						ВычестьОтказы = 0;
	//////						ВычестьОтказыВРезервах = 0;
	//////						Если ЗначениеЗаполнено(ВыборкаДетальных.Заявка) Тогда
	//////							СтрокаЗаявка = СтрокаСклад.Строки.Добавить();
	//////							СтрокаЗаявка.Заявка = ВыборкаДетальных.Заявка;
	//////							СтрокаЗаявка.Покупатель = ВыборкаДетальных.Покупатель;
	//////							СтрокаЗаявка.КоличествоЗаявка = ВыборкаДетальных.КоличествоЗаявка;
	//////							СтрокаЗаявка.СостояниеЗаявки = ВыборкаДетальных.СостояниеЗаявки;
	//////							СтрокаЗаявка.Поставщик = ВыборкаДетальных.Поставщик;
	//////							СтрокаЗаявка.Заказ = ВыборкаДетальных.Заказ;
	//////							СтрокаЗаявка.КоличествоЗаказ = ВыборкаДетальных.КоличествоЗаказ;
	//////							СтрокаЗаявка.СостояниеЗаказа = ВыборкаДетальных.СостояниеЗаказа;
	//////							Если ЗначениеЗаполнено(ВыборкаДетальных.ВидОтказа) Тогда
	//////								ВычестьОтказыВРезервах = ВычестьОтказыВРезервах + ВыборкаДетальных.ВРезерве;
	//////							Иначе
	//////								СтрокаЗаявка.ВРезерве = ВыборкаДетальных.ВРезерве;
	//////							КонецЕсли;
	//////							ПерваяСтрокаЗаявки = Ложь;
	//////						КонецЕсли;
	//////					Иначе
	//////						Если ЗначениеЗаполнено(ВыборкаДетальных.Заявка) Тогда
	//////							СтрокаЗаявка = СтрокаСклад.Строки.Добавить();
	//////							ВычестьОтказы = ВычестьОтказы + ВыборкаДетальных.КоличествоЗаявка;
	//////							СтрокаЗаявка.Поставщик = ВыборкаДетальных.Поставщик;
	//////							СтрокаЗаявка.Заказ = ВыборкаДетальных.Заказ;
	//////							СтрокаЗаявка.КоличествоЗаказ = ВыборкаДетальных.КоличествоЗаказ;
	//////							СтрокаЗаявка.СостояниеЗаказа = ВыборкаДетальных.СостояниеЗаказа;
	//////							Если ЗначениеЗаполнено(ВыборкаДетальных.ВидОтказа) Тогда
	//////								ВычестьОтказыВРезервах = ВычестьОтказыВРезервах + ВыборкаДетальных.ВРезерве;
	//////							Иначе
	//////								СтрокаЗаявка.ВРезерве = ВыборкаДетальных.ВРезерве;
	//////							КонецЕсли;
	//////							
	//////						КонецЕсли;
	//////						
	//////					КонецЕсли;
	//////				КонецЦикла;
	//////			СтрокаСклад.КоличествоЗаявка = СтрокаСклад.КоличествоЗаявка - ВычестьОтказы;
	//////			СтрокаСклад.ВРезерве = СтрокаСклад.ВРезерве - ВычестьОтказыВРезервах;	
	//////			КонецЦикла;		
	//////			
	//////		КонецЕсли;			
	//////	КонецЦикла;//выборка по складу				
	//////КонецЕсли;//если не пустой результат запроса
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПартииТоваровОстатки.Склад КАК Склад,
	|	ПартииТоваров.Регистратор КАК Перемещение
	|ПОМЕСТИТЬ ПеремещениеНаТоварыВПути
	|ИЗ
	|	РегистрНакопления.ПартииТоваров.Остатки(
	|			,
	|			Номенклатура = &Номенклатура
	|				И Склад.ТоварыВПути) КАК ПартииТоваровОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваров КАК ПартииТоваров
	|		ПО ПартииТоваровОстатки.СтрокаПрихода = ПартииТоваров.СтрокаПрихода
	|			И ПартииТоваровОстатки.Склад = ПартииТоваров.Склад
	|			И (ПартииТоваров.Регистратор ССЫЛКА Документ.ПеремещениеТоваров)
	|			И (ПартииТоваров.Активность)
	|ГДЕ
	|	НЕ ПартииТоваров.Регистратор ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкиПокупателейОбороты.СтрокаЗаявки КАК СтрокаЗаявки
	|ПОМЕСТИТЬ СтрокиЗаявокПоНоменклатуре
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Обороты(, , , Номенклатура = &Номенклатура) КАК ЗаявкиПокупателейОбороты
	|ГДЕ
	|	ЗаявкиПокупателейОбороты.КоличествоПриход > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СтрокаЗаявки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкиПокупателейОстатки.СтрокаЗаявки
	|ПОМЕСТИТЬ ОстаткиСтрокЗаявокПоНоменклатуре
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
	|			,
	|			СтрокаЗаявки В
	|				(ВЫБРАТЬ
	|					СтрокиЗаявокПоНоменклатуре.СтрокаЗаявки
	|				ИЗ
	|					СтрокиЗаявокПоНоменклатуре)) КАК ЗаявкиПокупателейОстатки
	|ГДЕ
	|	ЗаявкиПокупателейОстатки.КоличествоОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	NULL КАК Общий,
	|	Заявки.СтрокаЗаявки КАК СтрокаЗаявки,
	|	Заявки.СтрокаЗаявки.Заявка КАК Заявка,
	|	Заявки.ДоговорКонтрагента.Владелец КАК Покупатель,
	|	Заявки.КоличествоОстаток КАК КоличествоЗаявка,
	|	NULL КАК СостояниеЗаявки,
	|	Заказы.ДоговорКонтрагента.Владелец КАК Поставщик,
	|	Заказы.СтрокаЗаявки.Заказ КАК Заказ,
	|	ЕСТЬNULL(Заказы.КоличествоОстаток, 0) КАК КоличествоЗаказ,
	|	Заявки.СтрокаЗаявки.УдалитьСостояниеЗаказа КАК СостояниеЗаказа,
	|	ЕСТЬNULL(Резервы.КоличествоОстаток, 0) КАК ВРезерве
	|ПОМЕСТИТЬ ТабОстатков_0
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
	|			,
	|			СтрокаЗаявки В
	|				(ВЫБРАТЬ
	|					ОстаткиСтрокЗаявокПоНоменклатуре.СтрокаЗаявки
	|				ИЗ
	|					ОстаткиСтрокЗаявокПоНоменклатуре)) КАК Заявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(, Номенклатура = &Номенклатура) КАК Заказы
	|		ПО Заявки.СтрокаЗаявки = Заказы.СтрокаЗаявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РезервыТоваров.Остатки(, Номенклатура = &Номенклатура) КАК Резервы
	|		ПО Заявки.СтрокаЗаявки = Резервы.СтрокаЗаявки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтказыВсе.СтрокаЗаявки,
	|	СУММА(ОтказыВсе.КоличествоОборот) КАК Количество,
	|	ОтказыВсе.Регистратор,
	|	ВЫБОР
	|		КОГДА ОтказыВсе.Регистратор ССЫЛКА Документ.ЗаявкаПокупателя
	|				ИЛИ ОтказыВсе.Регистратор ССЫЛКА Документ.КорректировкаЗаявкиПокупателя
	|			ТОГДА 1
	|		КОГДА ОтказыВсе.Регистратор ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ОтказыВсе.Регистратор ССЫЛКА Документ.КорректировкаЗаказаПоставщику
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ТипОтказа,
	|	ОтказыВсе.ПричинаОтказа
	|ПОМЕСТИТЬ Отказы
	|ИЗ
	|	РегистрНакопления.ОтказыПоЗаявкам.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			СтрокаЗаявки В
	|				(ВЫБРАТЬ
	|					ТабОстатков_0.СтрокаЗаявки
	|				ИЗ
	|					ТабОстатков_0 КАК ТабОстатков_0)) КАК ОтказыВсе
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтказыВсе.СтрокаЗаявки,
	|	ОтказыВсе.Регистратор,
	|	ОтказыВсе.ПричинаОтказа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Отказы.СтрокаЗаявки,
	|	СУММА(Отказы.Количество) КАК Количество
	|ПОМЕСТИТЬ ОтказыСверткаПОСтрокеЗаявки
	|ИЗ
	|	Отказы КАК Отказы
	|
	|СГРУППИРОВАТЬ ПО
	|	Отказы.СтрокаЗаявки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Отказы.СтрокаЗаявки,
	|	Отказы.ТипОтказа,
	|	СУММА(Отказы.Количество) КАК Количество
	|ПОМЕСТИТЬ ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа
	|ИЗ
	|	Отказы КАК Отказы
	|
	|СГРУППИРОВАТЬ ПО
	|	Отказы.СтрокаЗаявки,
	|	Отказы.ТипОтказа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабОстатков_0.Общий,
	|	ТабОстатков_0.СтрокаЗаявки,
	|	ТабОстатков_0.Заявка,
	|	ТабОстатков_0.Покупатель,
	|	ТабОстатков_0.КоличествоЗаявка - ЕСТЬNULL(ОтказыВСЕ.Количество, 0) КАК КоличествоЗаявка,
	|	ТабОстатков_0.СостояниеЗаявки,
	|	ТабОстатков_0.Поставщик,
	|	ТабОстатков_0.Заказ КАК Заказ,
	|	ТабОстатков_0.КоличествоЗаказ - ЕСТЬNULL(ОтказыКЗаказу.Количество, 0) КАК КоличествоЗаказ,
	|	ТабОстатков_0.СостояниеЗаказа,
	|	NULL КАК ВидОтказа,
	|	ЕСТЬNULL(ОтказыВСЕ.Количество, 0) КАК Отказано,
	|	ТабОстатков_0.ВРезерве
	|ПОМЕСТИТЬ ТабОстатков_1
	|ИЗ
	|	ТабОстатков_0 КАК ТабОстатков_0
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОтказыСверткаПОСтрокеЗаявки КАК ОтказыВСЕ
	|		ПО ТабОстатков_0.СтрокаЗаявки = ОтказыВСЕ.СтрокаЗаявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа.СтрокаЗаявки КАК СтрокаЗаявки,
	|			ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа.Количество КАК Количество
	|		ИЗ
	|			ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа КАК ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа
	|		ГДЕ
	|			ОтказыСверткаПОСтрокеЗаявкиИТипуОтказа.ТипОтказа = 2) КАК ОтказыКЗаказу
	|		ПО ТабОстатков_0.СтрокаЗаявки = ОтказыКЗаказу.СтрокаЗаявки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КорректировкаЗаявкиПокупателя.Контрагент,
	|	КорректировкаЗаявкиПокупателя.ДокументОснование,
	|	КорректировкаЗаявкиПокупателя.Дата
	|ПОМЕСТИТЬ ПоследниеКорректировкиВсе
	|ИЗ
	|	Документ.КорректировкаЗаявкиПокупателя КАК КорректировкаЗаявкиПокупателя
	|ГДЕ
	|	КорректировкаЗаявкиПокупателя.Проведен
	|	И КорректировкаЗаявкиПокупателя.ДокументОснование В
	|			(ВЫБРАТЬ
	|				ТабОстатков_1.Заявка
	|			ИЗ
	|				ТабОстатков_1 КАК ТабОстатков_1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеКорректировкиВсе.ДокументОснование,
	|	МАКСИМУМ(ПоследниеКорректировкиВсе.Дата) КАК Дата
	|ПОМЕСТИТЬ ПоследниеКорректировкиДаты
	|ИЗ
	|	ПоследниеКорректировкиВсе КАК ПоследниеКорректировкиВсе
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоследниеКорректировкиВсе.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеКорректировкиВсе.Контрагент,
	|	ПоследниеКорректировкиВсе.ДокументОснование,
	|	ПоследниеКорректировкиВсе.Дата
	|ПОМЕСТИТЬ ПоследниеКорректировки
	|ИЗ
	|	ПоследниеКорректировкиВсе КАК ПоследниеКорректировкиВсе
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПоследниеКорректировкиДаты КАК ПоследниеКорректировкиДаты
	|		ПО ПоследниеКорректировкиВсе.ДокументОснование = ПоследниеКорректировкиДаты.ДокументОснование
	|			И ПоследниеКорректировкиВсе.Дата = ПоследниеКорректировкиДаты.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабОстатков.Склад КАК Склад,
	|	ТабОстатков.Общий КАК Общий,
	|	ВЫБОР
	|		КОГДА ПоследниеКорректировки.Контрагент ЕСТЬ NULL
	|			ТОГДА ТабОстатков.Покупатель
	|		ИНАЧЕ ПоследниеКорректировки.Контрагент
	|	КОНЕЦ КАК Покупатель,
	|	ТабОстатков.Заявка КАК Заявка,
	|	ТабОстатков.КоличествоЗаявка КАК ВЗаявке,
	|	ТабОстатков.Поставщик,
	|	ТабОстатков.Заказ,
	|	ТабОстатков.КоличествоЗаказ КАК ВЗаказе,
	|	ТабОстатков.Отказано КАК Отказано,
	|	ТабОстатков.ВРезерве КАК ВРезерве,
	|	ТабОстатков.Перемещение КАК Перемещение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыНаСкладахОстатки.Склад КАК Склад,
	|		ТоварыНаСкладахОстатки.КоличествоОстаток КАК Общий,
	|		NULL КАК СтрокаЗаявки,
	|		NULL КАК Заявка,
	|		NULL КАК Покупатель,
	|		0 КАК КоличествоЗаявка,
	|		NULL КАК СостояниеЗаявки,
	|		NULL КАК Поставщик,
	|		NULL КАК Заказ,
	|		0 КАК КоличествоЗаказ,
	|		NULL КАК СостояниеЗаказа,
	|		NULL КАК ВидОтказа,
	|		0 КАК Отказано,
	|		0 КАК ВРезерве,
	|		NULL КАК Перемещение
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура = &Номенклатура) КАК ТоварыНаСкладахОстатки
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПеремещениеНаТоварыВПути.Склад,
	|		0,
	|		NULL,
	|		NULL,
	|		NULL,
	|		0,
	|		NULL,
	|		NULL,
	|		NULL,
	|		0,
	|		NULL,
	|		NULL,
	|		0,
	|		0,
	|		ПеремещениеНаТоварыВПути.Перемещение
	|	ИЗ
	|		ПеремещениеНаТоварыВПути КАК ПеремещениеНаТоварыВПути
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ТабОстатков_1.Заявка.Склад,
	|		ТабОстатков_1.Общий,
	|		ТабОстатков_1.СтрокаЗаявки,
	|		ТабОстатков_1.Заявка,
	|		ТабОстатков_1.Покупатель,
	|		ТабОстатков_1.КоличествоЗаявка,
	|		ТабОстатков_1.СостояниеЗаявки,
	|		ТабОстатков_1.Поставщик,
	|		ТабОстатков_1.Заказ,
	|		ТабОстатков_1.КоличествоЗаказ,
	|		ТабОстатков_1.СостояниеЗаказа,
	|		ТабОстатков_1.ВидОтказа,
	|		ТабОстатков_1.Отказано,
	|		ТабОстатков_1.ВРезерве,
	|		NULL
	|	ИЗ
	|		ТабОстатков_1 КАК ТабОстатков_1) КАК ТабОстатков
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследниеКорректировки КАК ПоследниеКорректировки
	|		ПО ТабОстатков.Заявка = ПоследниеКорректировки.ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабОстатков.Склад.Наименование,
	|	Общий УБЫВ,
	|	Покупатель,
	|	Заявка,
	|	ТабОстатков.СтрокаЗаявки
	|ИТОГИ
	|	СУММА(Общий),
	|	СУММА(ВЗаявке),
	|	СУММА(ВЗаказе),
	|	СУММА(Отказано),
	|	СУММА(ВРезерве)
	|ПО
	|	Склад";
	
	Запрос.УстановитьПараметр("Номенклатура", ТекущаяНоменклатура);      
	Результат = Запрос.Выполнить();
	
	ДеревоОстатков = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	// - Пушкин 20180423 
	
КонецПроцедуры


