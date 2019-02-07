﻿
Функция ПолучитьМетаданные()
	Возврат Метаданные.Справочники.Номенклатура;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхМетаданныеОтбора) Экспорт
	Если (вхМетаданныеОтбора = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт) тогда
		Возврат (Новый Структура("Шапка", "Наименование,Изготовитель,Артикул"));
	КонецЕсли;
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхМетаданныеОтбора);
КонецФункции

Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена, ВыгружаемыеОбъекты = Неопределено) Экспорт
	
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
	
	Если (лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт) тогда
		
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
		|					Справочник.Номенклатура.Ссылка
		|				ИЗ
		|					Справочник.Номенклатура)
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
		|	Т.Изготовитель КАК Изготовитель,
		|	Т.Артикул КАК Артикул
		|ИЗ
		|	Справочник.Номенклатура КАК Т
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
				лОбъект.Наименование = лВыборка.Наименование;
				лОбъект.Изготовитель = лВыборка.Изготовитель.УникальныйИдентификатор();
				лОбъект.Артикул = лВыборка.Артикул;
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
		|					Справочник.Номенклатура.Ссылка
		|				ИЗ
		|					Справочник.Номенклатура)
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
		|	ЕСТЬNULL(Т.Изготовитель, ЗНАЧЕНИЕ(Справочник.Изготовители.ПустаяСсылка)) КАК Изготовитель,
		|	ЕСТЬNULL(Т.Артикул, """") КАК Артикул,
		|	ЕСТЬNULL(Т.НаименованиеПолное, """") КАК НаименованиеПолное,
		|	Т.ПометкаУдаления,
		|	Т.Услуга,
		|	Т.ЭтоГруппа,
		|	Т.Родитель
		|ИЗ
		|	Справочник.Номенклатура КАК Т
		|ГДЕ
		|	Т.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты
		|			ГДЕ
		|				НЕ Объекты.ЭтоУдаление)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ
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
				ЗаполнитьЗначенияСвойств(лОбъект, лВыборка,,"Ссылка");
				лОбъект.ИзготовительСсылка = XMLСтрока(лВыборка.Изготовитель);
				лОбъект.Ссылка = XMLСтрока(лВыборка.Ссылка);
				лОбъект.РодительСсылка = XMLСтрока(лВыборка.Родитель);
				//Семенов И.П. 07.02.2019 XX-1768(
				ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(лВыборка.Ссылка, лОбъект);
				//)Семенов И.П.
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
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьЭлемент(вхОбъектXDTO, вхОтправитель) Экспорт
	
	лМетаданныеПланаОбмена = Метаданные.НайтиПоТипу(ТипЗнч(вхОтправитель));
	Если (лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт) тогда
		
		НачатьТранзакцию();
		Попытка
			
			лЭтоНовый = Ложь;
			лСсылкаНаОбъект = ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Ссылка));
			лОбъект = лСсылкаНаОбъект.ПолучитьОбъект();
			
			Если (лОбъект = Неопределено) тогда
				лОбъект = СоздатьЭлемент();
				лОбъект.УстановитьСсылкуНового(лСсылкаНаОбъект);
				лОбъект.УстановитьНовыйКод();
				лЭтоНовый = Истина;
			КонецЕсли;
			
			лОбъект.Наименование = вхОбъектXDTO.Наименование;
			лОбъект.Изготовитель = Справочники.Изготовители.ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Изготовитель));
			лОбъект.Артикул = вхОбъектXDTO.Артикул;
			
			Если лЭтоНовый тогда
				лОбъект.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
				лОбъект.НаименованиеПолное = лОбъект.Наименование;
				лОбъект.ДатаСоздания = ТекущаяДата();
				лОбъект.СтранаПроисхождения = Справочники.СтраныМира.Россия;
				лОбъект.ЕдиницаХраненияОстатков = Справочники.ЕдиницыИзмерения.ПолучитьСсылку();
				лОбъект.ВидЛиквидности = Перечисления.ВидыЛиквидности.НеЛиквидный;
			КонецЕсли;
			
			лОбъект.ОбменДанными.Загрузка = Истина;
			лОбъект.ОбменДанными.Отправитель = вхОтправитель;
			лОбъект.Записать();
			
			Если лЭтоНовый тогда
				лЕдиницаОбъект = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
				лЕдиницаОбъект.УстановитьСсылкуНового(лОбъект.ЕдиницаХраненияОстатков);
				лЕдиницаОбъект.Владелец = лОбъект.Ссылка;
				лЕдиницаОбъект.ЕдиницаПоКлассификатору = Константы.ОсновнаяЕдиницаПоКлассификатору.Получить();
				лЕдиницаОбъект.Коэффициент = 1;
				лЕдиницаОбъект.Наименование = СокрЛП(лЕдиницаОбъект.ЕдиницаПоКлассификатору);
				лЕдиницаОбъект.УстановитьНовыйКод();
				лЕдиницаОбъект.ОбменДанными.Загрузка = Истина;
				лЕдиницаОбъект.Записать();
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ВызватьИсключение;			
			
		КонецПопытки;		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПеревыгрузитьНаСайт(Номенклатура) Экспорт
	
	ПланыОбмена.ОбменПартКом83_Сайт.ЗарегистрироватьВОбмен(Номенклатура);
	Если ТипЗнч(Номенклатура) = Тип("Массив") Тогда
		Для Каждого Объект Из Номенклатура Цикл
			УдалитьРегистрациюОстатковНоменклатуры(Объект);
		КонецЦикла;
	Иначе
		УдалитьРегистрациюОстатковНоменклатуры(Номенклатура);
	КонецЕсли;

КонецПроцедуры
Процедура УдалитьРегистрациюОстатковНоменклатуры(Номенклатура)
	
	НаборЗаписей = РегистрыСведений.ОстаткиНоменклатурыДляПланаОбменаССайтом.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция СвободныеОстаткиПоОрганизациям(Номенклатура, Склад, ДатаОстатков = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РезервыТоваровОстатки.СтрокаЗаявки.Заявка.Организация КАК Организация,
		|	РезервыТоваровОстатки.Качество,
		|	СУММА(РезервыТоваровОстатки.КоличествоОстаток) КАК Количество
		|ПОМЕСТИТЬ РезервыТоваровОстатки
		|ИЗ
		|	РегистрНакопления.РезервыТоваров.Остатки(
		|			&ДатаОстатков,
		|			Склад = &Склад
		|				И Номенклатура = &Номенклатура) КАК РезервыТоваровОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РезервыТоваровОстатки.СтрокаЗаявки.Заявка.Организация,
		|	РезервыТоваровОстатки.Качество
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПартииТоваровОстатки.Организация,
		|	ПартииТоваровОстатки.Качество,
		|	ПартииТоваровОстатки.КоличествоОстаток - ЕСТЬNULL(РезервыТоваровОстатки.Количество, 0) КАК Количество
		|ПОМЕСТИТЬ СвободныеОстатки
		|ИЗ
		|	РегистрНакопления.ПартииТоваров.Остатки(
		|			&ДатаОстатков,
		|			Склад = &Склад
		|				И Номенклатура = &Номенклатура) КАК ПартииТоваровОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РезервыТоваровОстатки КАК РезервыТоваровОстатки
		|		ПО (РезервыТоваровОстатки.Организация = ПартииТоваровОстатки.Организация)
		|			И (РезервыТоваровОстатки.Качество = ПартииТоваровОстатки.Качество)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СвободныеОстатки.Организация,
		|	СвободныеОстатки.Качество,
		|	СвободныеОстатки.Организация.Наименование КАК ОрганизацияНаименование,
		|	СвободныеОстатки.Качество.Наименование КАК КачествоНаименование,
		|	СвободныеОстатки.Количество
		|ИЗ
		|	СвободныеОстатки КАК СвободныеОстатки
		|ГДЕ
		|	СвободныеОстатки.Количество > 0";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ДатаОстатков", ?(ЗначениеЗаполнено(ДатаОстатков), ДатаОстатков, Дата(1,1,1)));
	
	Возврат Запрос.Выполнить();
	
КонецФункции