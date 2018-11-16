﻿
Функция ТекстСообщенияДляСайта(АктСсылка) Экспорт
	
	ТаблицаОписание = ОписаниеТоваровАкта(АктСсылка);
	
	ЧастьСообщения1 = "1 //решение: принять = 1, отказать =2 (??)
	|0 //Открыть повторный запрос: Да = 1, нет = 0 (??)
	|---
	|";
	
	ЧастьСообщения2 = ЧастьСообщения2(АктСсылка, ТаблицаОписание);
	
	ЧастьСообщения3 = БланкВозврата(АктСсылка, ТаблицаОписание);
	
	ИтоговоеСообщение = ЧастьСообщения1 + ЧастьСообщения2 + ЧастьСообщения3;
	
	Возврат ИтоговоеСообщение;
	
КонецФункции

Функция БланкВозврата(АктСсылка, ТаблицаОписание)
	
	БланкВозврата = "
	| Решение по запросу %Контрагент% № %Штрихкод% от %Дата%:
	|
	| %Префикс%
	| %ИнформацияОТоварах%
	|
	| Описание в запросе покупателя: %Описание%
	| Служебные данные: %Логин%
	| ===================================================================================
	| \n
	| Уважаемый Партнер!
	|
	| %ПринятоРешение%
	|
	| Просим Вас:
	| <b>1. Распечатать данный бланк возврата - 1 экз., подписать и поставить печать Вашей организации.</b>
	| 2. %ИнформацияОДокументе%
	| В документах должен быть указан товар:
	|   %ИнформацияОТоваре%
	|
	| <b>Внимание!</b>
	| Для исключения ошибок при оформлении документов, предлагаем получить на почту готовые документы на возврат. Для этого перейдите в раздел ""Сообщения"" к запросу о возврате товара и нажмите «Получить».
	| <big><b>3. Привезти товар на %Склад% склад с пакетом документов (п. 2) и бланком возврата в срок до %СрокВозвратаКлиента%.</b></big>
	| 4. Предоставить товар в том виде, который был указан при формировании Вами запроса на нашем сайте
	| -
	| - %УпаковкаСледыУстановки%
	| \n
	| Обращаем Ваше внимание!
	| Мы не сможем принять товар к возврату без соблюдения условий, указанных в данном бланке.
	| Выражаем надежду на дальнейшее продуктивное сотрудничество!
	| ===================================================================================
	| <b>Комментарий сотрудника компании ""ПартКом"":
	| Срок возврата товара на склад Компании до: %СрокВозвратаКлиента%.
	| Ваш запрос одобрен.
	| Пожалуйста, изучите информацию, содержащуюся в бланке возврата.
	| При соблюдении всех условий, мы гарантируем успешный возврат детали.
	| Спасибо!
	|
	| ВНИМАНИЕ!!!
	| Деталь принимается только при условии сохранности товарного вида и целостности упаковки.
	| </b>
	|
	| По всем вопросам, связанным с данным ответом, просим обращаться в Группу поддержки Клиентов по телефону:
	|(831) 233-22-07 — многоканальный (10 линий).
	|---
	| %КодВозврата%
	|---
	| %СуммаДокумента%";

	
	НомерРТУ = "??";
	ДатаРТУ  = "??";
	УчетнаяЗапись = Справочники.УчетныеЗаписиСайта.ДанныеУчетнойЗаписиКонтрагента(АктСсылка.Контрагент);
	
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Контрагент%",  		АктСсылка.Контрагент);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Штрихкод%",  			АктСсылка.Штрихкод);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Дата%",  				АктСсылка.Дата);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Описание%",  			АктСсылка.КомментарийСайт);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Логин%",  				УчетнаяЗапись.Логин);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%КодВозврата%",			АктСсылка.КодВозврата.Код);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%СуммаДокумента%",		АктСсылка.СуммаДокумента);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Склад%", 				АктСсылка.Склад);
	БланкВозврата = СтрЗаменить(БланкВозврата, "%СрокВозвратаКлиента%", Формат(АктСсылка.СрокВозвратаКлиента, "ДФ=dd.MM.yyyy"));
	
	ИнформацияОДокументе = "";	
	Если Не АктСсылка.ДоговорКонтрагента.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные Тогда
		ИнформацияОДокументе = "Оформить пакет документов: накладная ТОРГ-12, счет-фактура с НДС 18%, оформленные в 2-х экземплярах на " + АктСсылка.Организация + ".";
		СтрокиСБраком = ТаблицаОписание.НайтиСтроки(Новый Структура("ПричинаВозврата", Перечисления.ПричиныВозврата.Брак));
		Если СтрокиСБраком.Количество() > 0 Тогда //"«Причина возврата» = «брак, СТО»"
			ИнформацияОДокументе = ИнформацияОДокументе + " Акт рекламации СТО, Заказ-наряд СТО с подтверждением оплаты работ.";
		КонецЕсли;
	КонецЕсли;
	БланкВозврата = СтрЗаменить(БланкВозврата, "%ИнформацияОДокументе%", ИнформацияОДокументе);
	
	Если АктСсылка.КодВозврата = Справочники.КодыВозврата.НаЭкспертизу Тогда
		Префикс = "Принять на экспертизу (осмотр): ";
	Иначе
		Префикс = "Принять к возврату товар: ";
	КонецЕсли;
	БланкВозврата = СтрЗаменить(БланкВозврата, "%Префикс%",  			Префикс);
	
	ИнформацияОТоварах = "";
	Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
		ИнформацияОТоварах = ИнформацияОТоварах + Символы.ПС + СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул + " в количестве " + СтрокаТаблицы.Количество + " шт."+ ", отгруженный со склада по накладной № " + НомерРТУ + " от " + ДатаРТУ + ".";
		ИнформацияОТоварах = ИнформацияОТоварах + Символы.ПС + "Причина возврата: "+СтрокаТаблицы.ПричинаВозврата;
	КонецЦикла; 
	БланкВозврата = СтрЗаменить(БланкВозврата, "%ИнформацияОТоварах%",  ИнформацияОТоварах);
	
	ПринятоРешение = "Принято решение удовлетворить Ваш запрос о возврате товара:";
	Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
		
		СтрокаУценки = "";
		Если СтрокаТаблицы.ПроцентУценки > 0 Тогда
			СтрокаУценки = ", с уценкой " + СтрокаТаблицы.ПроцентУценки + "%";
		КонецЕсли;
		СтрокаКомпенсации = "";
		Если СтрокаТаблицы.СуммаКомпенсации > 0 Тогда
			СтрокаКомпенсации = ", с компенсацией работ за проведённую установку " + СтрокаТаблицы.СуммаКомпенсации + " руб.";
		КонецЕсли;
		
		Стр = СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул + СтрокаУценки + СтрокаКомпенсации;
		ПринятоРешение = ПринятоРешение + Символы.ПС + Стр;
		
	КонецЦикла;
	БланкВозврата = СтрЗаменить(БланкВозврата, "%ПринятоРешение%", ПринятоРешение);
	
	//ИнформацияОДокументе = "";
	//Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
	//	ИнформацияОДокументе = ИнформацияОДокументе + ?(ЗначениеЗаполнено(ИнформацияОДокументе), Символы.ПС, "") + СтрокаТаблицы.ИнформацияОДокументе;
	//КонецЦикла;
	//БланкВозврата = СтрЗаменить(БланкВозврата, "%ИнформацияОДокументе%", ИнформацияОДокументе);
	
	ИнформацияОТоваре = "";
	Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
		ИнформацияОТоваре = ИнформацияОТоваре + ?(ЗначениеЗаполнено(ИнформацияОТоваре), Символы.ПС, "") + СтрокаТаблицы.ИнформацияОТоваре;
		ИнформацияОТоваре = ИнформацияОТоваре + ?(ЗначениеЗаполнено(ИнформацияОТоваре), Символы.ПС, "") + СтрокаТаблицы.ИнформацияСчетФактура;
	КонецЦикла;
	БланкВозврата = СтрЗаменить(БланкВозврата, "%ИнформацияОТоваре%", ИнформацияОТоваре);
	
	//Упаковка = "";
	//Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
	//	Упаковка = Упаковка + ?(ЗначениеЗаполнено(Упаковка), Символы.ПС, "") + СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул + " " + СтрокаТаблицы.ИнформацияОбУпаковке;
	//КонецЦикла;
	//БланкВозврата = СтрЗаменить(БланкВозврата, "%Упаковка%", Упаковка);
	//
	//СледыУстановки = "";
	//Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
	//	СледыУстановки = СледыУстановки + ?(ЗначениеЗаполнено(СледыУстановки), Символы.ПС, "") + СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул + " " + СтрокаТаблицы.ИнформацияОСледахУстановки;
	//КонецЦикла;
	//БланкВозврата = СтрЗаменить(БланкВозврата, "%СледыУстановки%", СледыУстановки);
	
	УпаковкаСледыУстановки = "";
	Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
		УпаковкаСледыУстановки = УпаковкаСледыУстановки + ?(ЗначениеЗаполнено(УпаковкаСледыУстановки), Символы.ПС, "") + СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул+ " " + СтрокаТаблицы.ИнформацияОбУпаковке + " " + СтрокаТаблицы.ИнформацияОСледахУстановки;
	КонецЦикла;
	БланкВозврата = СтрЗаменить(БланкВозврата, "%УпаковкаСледыУстановки%", УпаковкаСледыУстановки);
	
	
	Возврат БланкВозврата;

Конецфункции

Функция ЧастьСообщения2(АктСсылка, ТаблицаОписание)
	
	ТекстСообщения = "Здравствуйте!
	|
	| В ответ на Ваш запрос сообщаем:
	|
	| %Префикс%
	| %ИнформацияОТоварах%
	|
	| Для осуществления возврата перейдите по ссылке и следуйте инструкции.
	|
	|
	|---
	|";
	
	Если АктСсылка.КодВозврата = Справочники.КодыВозврата.НаЭкспертизу Тогда
		Префикс = "Мы готовы принять на ЭКСПЕРТИЗУ (осмотр): ";
	Иначе
		Префикс = "Мы готовы принять к возврату: ";
	КонецЕсли;
	
	ИнформацияОТоварах = "";
	Для каждого СтрокаТаблицы Из ТаблицаОписание Цикл
		ИнформацияОТоварах = ИнформацияОТоварах + Символы.ПС + СтрокаТаблицы.НоменклатураНаименование + ", " + СтрокаТаблицы.Изготовитель + " " + СтрокаТаблицы.Артикул + " в кол-ве " + СтрокаТаблицы.Количество + " шт."
	КонецЦикла;
	
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Префикс%", Префикс);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИнформацияОТоварах%", ИнформацияОТоварах);
	
	Возврат ТекстСообщения;

КонецФункции

Функция ОписаниеТоваровАкта(АктСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктРассмотренияВозвратаТовары.Номенклатура,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Наименование,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Изготовитель КАК Изготовитель,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Артикул КАК Артикул,
	|	АктРассмотренияВозвратаТовары.ЕдиницаИзмерения,
	|	АктРассмотренияВозвратаТовары.Количество,
	|	АктРассмотренияВозвратаТовары.Цена,
	|	АктРассмотренияВозвратаТовары.СтавкаНДС,
	|	АктРассмотренияВозвратаТовары.СуммаНДС,
	|	АктРассмотренияВозвратаТовары.Сумма,
	|	АктРассмотренияВозвратаТовары.ПроцентУценки,
	|	АктРассмотренияВозвратаТовары.ЦенаПослеУценки,
	|	АктРассмотренияВозвратаТовары.ВидУценки,
	|	АктРассмотренияВозвратаТовары.СуммаКомпенсации,
	|	АктРассмотренияВозвратаТовары.Ссылка.ПричинаВозврата КАК ПричинаВозврата,
	|	АктРассмотренияВозвратаТовары.ЦелостностьУпаковки,
	|	АктРассмотренияВозвратаТовары.ОтсутствуютСледыУстановки,
	|	АктРассмотренияВозвратаТовары.СтавкаНДС
	|ИЗ
	|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
	|ГДЕ
	|	АктРассмотренияВозвратаТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", АктСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаОписание = РезультатЗапроса.Выгрузить();
	ТаблицаОписание.Колонки.Добавить("ИнформацияОТоваре");
	ТаблицаОписание.Колонки.Добавить("ИнформацияОДокументе");
	ТаблицаОписание.Колонки.Добавить("ИнформацияОбУпаковке");
	ТаблицаОписание.Колонки.Добавить("ИнформацияОСледахУстановки");
	ТаблицаОписание.Колонки.Добавить("ИнформацияСчетФактура");
	
	Наличные = АктСсылка.ДоговорКонтрагента.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;	
	
	Для Каждого Выборка ИЗ  ТаблицаОписание Цикл
		
		//ИнфТовар
		Сумма = Выборка.Сумма + Выборка.СуммаКомпенсации;
		СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Сумма,
		АктСсылка.УчитыватьНДС, АктСсылка.СуммаВключаетНДС,
		УчетНДС.ПолучитьСтавкуНДС(Выборка.СтавкаНДС));
		
		СтрокаУценки = "по цене - ";
		Если  Выборка.ПроцентУценки > 0 Тогда
			СтрокаУценки = "по цене с учётом уценки " + Выборка.ПроцентУценки + "% - ";
		КонецЕсли;
		
		СтрокаНДС = 0;
		Если Не Наличные Тогда
			СтрокаНДС = " в том числе НДС - " + СуммаНДС + " руб. ";
		КонецЕсли;
		
		ИнфТовар = Выборка.НоменклатураНаименование + ", "+Выборка.Изготовитель+", "+Выборка.Артикул+", в кол-ве " + Выборка.Количество + "шт., " + СтрокаУценки + Выборка.ЦенаПослеУценки+ " руб. на общую сумму- " + Выборка.Сумма + " руб." + СтрокаНДС;
		
		Если Выборка.ВидУценки = Перечисления.ВидыУценки.ОбработкаОднойДетали И Выборка.ПроцентУценки > 0 Тогда //«Вид уценки» = "Обработка одной детали"
			ИнфТовар = ИнфТовар + " Стоимость обработки 1 детали составила " + "Что тут(??)" + " руб.";
		КонецЕсли;
		
		//ИнфДок
		//Если Не Наличные Тогда
		//	ИнфДок = "Оформить пакет документов: накладная ТОРГ-12, счет-фактура с НДС 18%, оформленные в 2-х экземплярах на " + АктСсылка.Организация + ".";
		//КонецЕсли;
		//
		//Если Выборка.ПричинаВозврата = Перечисления.ПричиныВозврата.Брак Тогда //"«Причина возврата» = «брак, СТО»"
		//	ИнфДок = ИнфДок + ", акт рекламации СТО, Заказ-наряд СТО с подтверждением оплаты работ";
		//КонецЕсли;
		
		//Упаковка
		Если Выборка.ЦелостностьУпаковки Тогда
			Упаковка = "- Сохранена упаковка и её товарный вид.";
		Иначе
			Упаковка = "- Упаковка отсутствует или потерян её товарный вид.";
		КонецЕсли;
		
		//СледыУст
		Если Выборка.ОтсутствуютСледыУстановки Тогда
			СледыУст = "- Товар не имеет признаков использования, отсутствуют следы установки, сохранен товарный вид.";
		Иначе
			СледыУст = "- Товар имеет следы установки.";
		КонецЕсли;
		
		ГТД = "??";
		Страна = "??";
		СчетФактура = "";
		Если НЕ Наличные Тогда
			СчетФактура = "Счет-фактура должна содержать данные о ГТД и стране происхождения: номер ГТД: " + ГТД + ", страна происхождения: " + Страна + "."
		КонецЕсли;
		
		Выборка.ИнформацияОТоваре 			= ИнфТовар;
		//Выборка.ИнформацияОДокументе 		= ИнфДок;
		Выборка.ИнформацияОбУпаковке 		= Упаковка;
		Выборка.ИнформацияОСледахУстановки 	= СледыУст;
		Выборка.ИнформацияСчетФактура 		= СчетФактура;
		
	КонецЦикла;
	
	Возврат ТаблицаОписание;
	
КонецФункции

Функция ИменаРеквизитовДляКонтроляИстории() Экспорт
	
	ИменаРеквизитов = Новый СписокЗначений;	
	ИменаРеквизитов.Добавить("КодВозврата", "Код возврата"); 
	ИменаРеквизитов.Добавить("Организация", "Организация"); 
	ИменаРеквизитов.Добавить("Контрагент", "Контрагент"); 
	ИменаРеквизитов.Добавить("ДоговорКонтрагента", "Договор контрагента"); 
	ИменаРеквизитов.Добавить("БезоговорочныйВозврат", "Безоговорочный возврат"); 
	ИменаРеквизитов.Добавить("СуммаДокумента", "Сумма документа"); 
	ИменаРеквизитов.Добавить("СтатусДокумента", "Статус документа"); 
	ИменаРеквизитов.Добавить("Ответственный", "Ответственный"); 
	
	Возврат ИменаРеквизитов;
	
КонецФункции

Функция СтруктураРеквизитовДляКонтроляИстории() Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	ИменаРеквизитов = ИменаРеквизитовДляКонтроляИстории();
	Для каждого ЭлСписка Из ИменаРеквизитов цикл
		СтруктураРеквизитов.Вставить(ЭлСписка.Значение, Неопределено);
	КонецЦикла;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

Функция АРВУникаленПоШтрихкоду(СсылкаНаДокумент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктРассмотренияВозврата.Ссылка
		|ИЗ
		|	Документ.АктРассмотренияВозврата КАК АктРассмотренияВозврата
		|ГДЕ
		|	НЕ АктРассмотренияВозврата.Ссылка = &Ссылка
		|	И АктРассмотренияВозврата.Штрихкод = &Штрихкод
		|	И АктРассмотренияВозврата.Проведен";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("Штрихкод", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДокумент, "Штрихкод"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции