﻿Функция СкладMaxoptraДоступен(Знач ТипДоставки, Знач Склад) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_СкладMaxoptraДоступен";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	
	СкладMaxoptraДоступен = ТипДоставки = Справочники.ТипыДоставки.ДоставкаВодителем И ЕстьСкладыMaxoptra(Склад);
	
	Возврат СкладMaxoptraДоступен;
КонецФункции

Функция ЕстьСкладыMaxoptra(Знач Склад) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_ЕстьСкладыMaxoptra";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Первые 1
	               |	МегаЛогист_СоответствиеСкладов1СИMaxoptra.Ссылка
	               |ИЗ
	               |	Справочник.МегаЛогист_СоответствиеСкладов1СИMaxoptra КАК МегаЛогист_СоответствиеСкладов1СИMaxoptra
	               |ГДЕ
	               |	МегаЛогист_СоответствиеСкладов1СИMaxoptra.Склад = &Склад
	               |	И &Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)";
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

//Валиахметов http://jira.part-kom.ru/browse/XX-2697 28.06.2019

//Экспресс-доставка
Процедура ЭД_ЗаполнитьУслугу(ДокументОбъект) Экспорт 
	
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_ЭД_ЗаполнитьУслугу";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.Услуги.Очистить();
		
	Если ДокументОбъект.ДоговорКонтрагента.ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные Тогда 
		УслугаДоставки = ФормированиеСлужебныхЗаданийПовтИсп.ЭД_УслугаБезнал();
	Иначе
		УслугаДоставки = ФормированиеСлужебныхЗаданийПовтИсп.ЭД_УслугаНал();
	КонецЕсли;
	
	СтрокаСтоимостиДоставки = ДокументОбъект.Услуги.Добавить();
	СтрокаСтоимостиДоставки.Номенклатура = УслугаДоставки;
	СтрокаСтоимостиДоставки.Содержание = УслугаДоставки.НаименованиеПолное;
	СтрокаСтоимостиДоставки.Количество = 1;
	
	СтрокаСтоимостиДоставки.СтавкаНДС = ?(ДокументОбъект.ДоговорКонтрагента.ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные, ОбщегоНазначения.ПолучитьЗначениеРеквизита(УслугаДоставки,"СтавкаНДС"), Перечисления.СтавкиНДС.БезНДС);
	
КонецПроцедуры

Процедура ЭД_УстарелоСозданиеРТУНаУслугу(Знач ДокументРеализация, ДокументНаУслугу) Экспорт 
	
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_ЭД_УстарелоСозданиеРТУНаУслугу";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	ДокументНаУслугу = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(ДокументНаУслугу, ДокументРеализация,, "Номер,Дата");
	
	ДокументНаУслугу.Дата = ТекущаяДата();
	
	ЭД_ЗаполнитьУслугу(ДокументНаУслугу);
	
КонецПроцедуры

Процедура ЭД_ПроставитьInit(ДокументОбъект) Экспорт 
	Если ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2697) И ДокументОбъект.ТипДоставки = Справочники.ТипыДоставки.ЭкспрессДоставка Тогда 
		ДокументОбъект.ЭД_init = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ЭД_СнятьInit(ДокументОбъект) Экспорт 
	Если  ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2697) И ДокументОбъект.ТипДоставки = Справочники.ТипыДоставки.ЭкспрессДоставка Тогда 
		ДокументОбъект.ЭД_init = Ложь;
	КонецЕсли;
КонецПроцедуры

Функция ЭД_УслугаБезнал() Экспорт 
	
	ИмяПараметраУслугаДоставки = "Услуга экспресс-доставки (Безнал)"; 
	Возврат РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", ИмяПараметраУслугаДоставки, Константы.УслугаЭкспрессДоставка.Получить());
	
КонецФункции

Функция ЭД_УслугаНал() Экспорт 
	
	ИмяПараметраУслугаДоставки = "Услуга экспресс-доставки (Нал)"; 
	Возврат РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", ИмяПараметраУслугаДоставки, Константы.УслугаЭкспрессДоставка.Получить());
	
КонецФункции

// Загрузка услуг из ТопЛога в РТУ 
Функция УслугиXDTOиДокументаРазличаются(Знач ОбъектXDTO, Знач ДокументСсылка, Дельта) Экспорт 
	
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_УслугиXDTOиДокументаРазличаются";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	
	Различаются = Ложь;
	
	Если УслугиГрузятсяИзТопЛог(ОбъектXDTO) Тогда 
		
		Услуги = УслугиXDTOВТаблицуЗначений(ОбъектXDTO);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	РеализацияТоваровУслугУслуги.Номенклатура,
		               |	РеализацияТоваровУслугУслуги.Количество,
		               |	РеализацияТоваровУслугУслуги.Цена
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияТоваровУслугУслуги
		               |ГДЕ
		               |	РеализацияТоваровУслугУслуги.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
		УслугиДокумента = Запрос.Выполнить().Выгрузить();
		
		Дельта = Неопределено;
		Различаются =  Не РаботаСПоследовательностямиКлиентСервер.ТаблицыИдентичныНовое(УслугиДокумента, Услуги, Дельта, "Количество");
		
	КонецЕсли;
	
	Возврат Различаются;
	
КонецФункции

Функция УслугиXDTOВТаблицуЗначений(Знач ОбъектXDTO)
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_УслугиXDTOВТаблицуЗначений";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	
	Услуги = Новый ТаблицаЗначений;
	Услуги.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура")); 
	Услуги.Колонки.Добавить("Количество", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	Услуги.Колонки.Добавить("Цена", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	
	Если ОбъектXDTO.Свойства().Получить("Услуги") <> Неопределено И ОбъектXDTO.Услуги <> Неопределено Тогда 
		УслугиXDTO = ОбъектXDTO.Услуги.ПолучитьСписок("СтрокаУслуги");
		Для Каждого СтрокаУслуги Из УслугиXDTO Цикл 
			НоваяСтрока = Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаУслуги, "Количество, Цена");
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаУслуги.НоменклатураСсылка));
		КонецЦикла;
	КонецЕсли;
	
	Возврат Услуги;

КонецФункции

Процедура УслугиОбновитьВДокументе(Знач ОбъектXDTO, ДокументОбъект) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ФормированиеСлужебныхЗаданийКлиентСервер_УслугиОбновитьВДокументе";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	Если УслугиГрузятсяИзТопЛог(ОбъектXDTO) Тогда 
		ДокументОбъект.Услуги.Очистить();
		Услуги = УслугиXDTOВТаблицуЗначений(ОбъектXDTO);
		
		Для Каждого СтрокаУслуги Из Услуги Цикл 
			НоваяСтрока = ДокументОбъект.Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаУслуги);
			НоваяСтрока.Сумма = НоваяСтрока.Количество * НоваяСтрока.Цена;
			НоваяСтрока.СтавкаНДС = ?(ДокументОбъект.УчитыватьНДС, НоваяСтрока.Номенклатура.СтавкаНДС, Перечисления.СтавкиНДС.БезНДС);
			НоваяСтрока.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(НоваяСтрока.Сумма, ДокументОбъект.УчитыватьНДС, ДокументОбъект.СуммаВключаетНДС, НоваяСтрока.СтавкаНДС);
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

Функция УслугиГрузятсяИзТопЛог(Знач ОбъектXDTO)
	Возврат ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2697);
КонецФункции
//Конец Валиахметов http://jira.part-kom.ru/browse/XX-2697 28.06.2019
