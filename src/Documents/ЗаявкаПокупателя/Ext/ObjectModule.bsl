﻿Перем мНеПерезаполнятьДвижения Экспорт; 
Перем мПроверкаПередПроведением Экспорт; 

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//Перем вхПараметры;
	
	Если мНеПерезаполнятьДвижения Тогда
		Возврат
	КонецЕсли;
	
	//ДополнительныеСвойства.Свойство("вхПараметры", вхПараметры);
	Документы.ЗаявкаПокупателя.ВыполнитьПроведение(Ссылка, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	РазрешенаОтменаПроведения = (Дата < глЗначениеПеременной("ДатаЗаявкиСоздаютсяВ83"));
	Если РазрешенаОтменаПроведения Или СтатусДокумента <> Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден Тогда 
		Документы.ЗаявкаПокупателя.ВыполнитьОтменуПроведения(Ссылка, Отказ);
	Иначе
		ВызватьИсключение "Распроведение заявки запрещено";	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СозданВ77 = Ложь;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	КорректировкаЗаявки.Ссылка,
	                      |	КорректировкаЗаявки.МоментВремени КАК МоментВремени
	                      |ИЗ
	                      |	Документ.КорректировкаЗаявкиПокупателя КАК КорректировкаЗаявки
	                      |ГДЕ
	                      |	КорректировкаЗаявки.Проведен
	                      |	И КорректировкаЗаявки.ДокументОснование = &Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	МоментВремени УБЫВ");
	Запрос.УстановитьПараметр("Ссылка", ОбъектКопирования.Ссылка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка.Ссылка,,"Проведен");
		Товары.Загрузить(Выборка.Ссылка.Товары.Выгрузить());
		
	КонецЕсли;
	
	Номер = "";
	Дата = ТекущаяДата();
	ДокументОснование = Неопределено;
	ПричиныОтказов.Очистить();
	КлючСвязи = 0;
	Подтверждена = Ложь;
	СтатусДокумента = Справочники.СтатусыДокументов.ЗаявкаПокупателяНеПодтвержден;
	Комментарий = "";
	СуммаРезерва = 0;
	ДатаОплаты = Неопределено;
	ДатаОтгрузки = Неопределено;

	Для Каждого ТекСтрока Из Товары Цикл
		
		ТекСтрока.СтрокаЗаявки = Неопределено;
		ТекСтрока.IDSite = "";
		ТекСтрока.Отмена = 0;
		КлючСвязи = КлючСвязи + 1;
		ТекСтрока.КлючСвязи = КлючСвязи;
		ТекСтрока.СрокГарантированный = Неопределено;
		ТекСтрока.СрокГарантированныйЗаказа = Неопределено;
		ТекСтрока.СрокОжидаемый = Неопределено;
		ТекСтрока.СрокОжидаемыйЗаказа = Неопределено;
		ТекСтрока.ДатаУстановкиРезерва = Неопределено;
		ТекСтрока.Прибыль = 0;
		ТекСтрока.Сумма = ТекСтрока.Количество * ТекСтрока.Цена;
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(ТекСтрока, ЭтотОбъект);
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("Копирование");
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не ОбменДанными.Загрузка  Тогда
		Если не ОбщегоНазначения.ПолучитьПоследнююКорректировкуЗаявки(Ссылка) = Ссылка и ПометкаУдаления Тогда
			Сообщить("Это не конечная заявка. Пометка на удаление запрещена!",СтатусСообщения.ОченьВажное);	
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ИсточникЗаявки.Пустая() Тогда
		ИсточникЗаявки = Перечисления.ИсточникиЗаявок.Прочее;
	КонецЕсли;
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("мЗаписьБезОбработки") Тогда 
		Возврат;
	КонецЕсли;
	
	ДатаЗаявкиСоздаютсяВ83 = глЗначениеПеременной("ДатаЗаявкиСоздаютсяВ83");
	
	Если Не ЭтоНовый() И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка,"Проведен") И (ПометкаУдаления ИЛИ Не Проведен) И Дата >= ДатаЗаявкиСоздаютсяВ83 Тогда 
		ВызватьИсключение "Распроведение заявки запрещено";	//Распроведение запрещено, если заявки не грузятся из 7.7
	КонецЕсли;
	
	Если МаршрутДоставки = Справочники.МаршрутыДоставки.ПустаяСсылка() Тогда
		Попытка
			МаршрутДоставки = Контрагент.ОсновнаяТорговаяТочка.МаршрутДоставки;
		Исключение
		КонецПопытки;
	КонецЕсли;
	СТДок=Неопределено;
	Попытка
		СТДок=ОбщегоНазначения.ПолучитьПоследнююКорректировкуЗаявки(Ссылка).СтатусДокумента;
	Исключение
		СТДок=СтатусДокумента;
	КонецПопытки;	
	Если не ОбменДанными.Загрузка И РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения И СТДок=Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден Тогда 
		Отказ=Истина;
		Сообщить("Нельзя отменять проведение документа в статусе подтвержден!");
		Возврат
	КонецЕсли;	
	//Если СтатусДокумента=Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден и Контрагент.Служебный Тогда 
	//	Сообщить("Заявка не может быть оформлена на служебного контрагента, выберите корректного контрагента");
	//	Если НЕ РольДоступна("ПолныеПрава") Тогда 
	//		Отказ=Истина;
	//		Возврат
	//	КонецЕсли;	
	//КонецЕсли;	
	ОбщегоНазначения.УдалитьДвиженияПриПометкеУдаления(ЭтотОбъект, РежимЗаписи);   // Очистка движений у помеченного на удаление документа
	
	СоздаватьКорректировку = Неопределено;
	ДополнительныеСвойства.Свойство("СоздаватьКорректировку", СоздаватьКорректировку);
	Если СоздаватьКорректировку = Неопределено Тогда 
		СоздаватьКорректировку = (Дата >= ДатаЗаявкиСоздаютсяВ83);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(Контрагент, "ПокупательИзДрБазы") Тогда
		//для питерских заявок нужна цена закупки и прайс поставщика 16, если он не заполнен
		Если Склад = Справочники.Склады.НайтиПоКоду("000000132") Тогда
			ПрайсПоставщика = Справочники.ПрайсыПоставщиков.НайтиПоКоду(8555);
		Иначе
			ПрайсПоставщика = Справочники.ПрайсыПоставщиков.НайтиПоКоду(16);
		КонецЕсли;
		
		Для Каждого Товар Из Товары Цикл
			ДописатьВСтрокуЗаявки = Ложь;
			
			Если Товар.ЦенаЗакупки = 0 Тогда
				Товар.ЦенаЗакупки = Товар.Цена;
				ДописатьВСтрокуЗаявки = Истина;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Товар.ПрайсПоставщика) Тогда
				Товар.ПрайсПоставщика = ПрайсПоставщика;
				ДописатьВСтрокуЗаявки = Истина;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Товар.СтрокаЗаявки) И ДописатьВСтрокуЗаявки Тогда
				ОбъектСтрокаЗаявки = Товар.СтрокаЗаявки.ПолучитьОбъект();
				ОбъектСтрокаЗаявки.ЦенаЗакупки = Товар.ЦенаЗакупки;
				ОбъектСтрокаЗаявки.ПрайсПоставщика = Товар.ПрайсПоставщика;
				ОбъектСтрокаЗаявки.Записать();
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не СоздаватьКорректировку Тогда 
		ЭтотОбъект.мНеПерезаполнятьДвижения = Ложь;
	Иначе
		ПроверитьСоздатьКорректировку(РежимЗаписи, РежимПроведения, Отказ);	
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("мНеПерезаполнятьДвижения", ЭтотОбъект.мНеПерезаполнятьДвижения);
	Документы.КорректировкаЗаявкиПокупателя.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	//Добавлено Валиахметов А.А. 06.03.2018 PK83-267
	
	Перем ЗагрузкаССайта;
	ДополнительныеСвойства.Свойство("ЗагрузкаССайта", ЗагрузкаССайта);
	
	Если ЗагрузкаССайта = Неопределено Тогда 
		ЗагрузкаССайта = Ложь;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	//Акцепт договора оферты
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "ДоговорНаОферту,Дата,ДопустимаяСуммаЗадолженности");
	Если ЗагрузкаССайта И Реквизиты.ДоговорНаОферту И Не ЗначениеЗаполнено(Реквизиты.Дата) И Ссылка = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка) Тогда 
		
		ДоговорОбъект = ДоговорКонтрагента.ПолучитьОбъект();
		
		Если Не ЗначениеЗаполнено(Реквизиты.ДопустимаяСуммаЗадолженности) Тогда  
			//Находим рабочий
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			               |	ДоговорыКонтрагентов.Ссылка,
			               |	ДоговорыКонтрагентов.ДопустимаяСуммаЗадолженности
			               |ИЗ
			               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
			               |ГДЕ
			               |	ДоговорыКонтрагентов.Владелец = &Владелец
			               |	И ДоговорыКонтрагентов.ДоговорПодписан
			               |	И НЕ ДоговорыКонтрагентов.ДоговорНаОферту
			               |	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
			               |	И НЕ ДоговорыКонтрагентов.ПометкаУдаления";
			Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
			Запрос.УстановитьПараметр("Владелец", Контрагент);
			Результат = Запрос.Выполнить();
			Если Не Результат.Пустой() Тогда 
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				ДоговорОбъект.ДопустимаяСуммаЗадолженности = Выборка.ДопустимаяСуммаЗадолженности;
			КонецЕсли;
		КонецЕсли;
		
		ДоговорОбъект.Дата = ДоговорОбъект.Организация.Договор_ОфертаПокупателя_Дата;
		ДоговорОбъект.Номер = ДоговорОбъект.Организация.Договор_ОфертаПокупателя_Номер;
		
		ДоговорОбъект.НомерЗаявкиОферты = Номер;
		ДоговорОбъект.ДатаДоговораОферты = Дата;
		
		ДоговорОбъект.ДоговорПодписан = Истина;
		Попытка
			ДоговорОбъект.Записать();
		Исключение
			ОписаниеОшибки = "Не удалось акцептовать договор " + ДоговорКонтрагента + " в заявке " + ЭтотОбъект.Ссылка;
			РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаАкцептаОферты, ОписаниеОшибки, "Ошибка акцепта оферты");
		КонецПопытки;
	КонецЕсли;
	
	//Конец Добавлено Валиахметов А.А. 06.03.2018 PK83-267
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьСоздатьКорректировку(РежимЗаписи, РежимПроведения, Отказ) Экспорт
	
	Если Не ЭтоНовый() И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЕстьИзменения = Документы.ЗаявкаПокупателя.ЕстьИзмененияДокумента(Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка), ЭтотОбъект);
		Если ЕстьИзменения Тогда
			ДокументКорректировка = Документы.КорректировкаЗаявкиПокупателя.СоздатьДокумент();
			ЗаполнитьЗначенияСвойств(ДокументКорректировка, ЭтотОбъект,,"Номер,Ответственный,СозданВ77");
			ДокументКорректировка.Дата = ТекущаяДата();
			ДокументКорректировка.Товары.Загрузить(Товары.Выгрузить());
			ДокументКорректировка.Услуги.Загрузить(Услуги.Выгрузить());
			ДокументКорректировка.ПричиныОтказов.Загрузить(ПричиныОтказов.Выгрузить());
			ДокументКорректировка.ДокументОснование = Ссылка;
			ДокументКорректировка.мПроверкаПередПроведением = ЭтотОбъект.мПроверкаПередПроведением;
			ДокументКорректировка.Записать(РежимЗаписиДокумента.Проведение, РежимПроведения);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Ссылка);
		Товары.Загрузить(Ссылка.Товары.Выгрузить());
		Услуги.Загрузить(Ссылка.Услуги.Выгрузить());
		ПричиныОтказов.Загрузить(Ссылка.ПричиныОтказов.Выгрузить());
		ДокументПоследнейКорректировки = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка);
		
		Если ЕстьИзменения Тогда
			ЭтотОбъект.мНеПерезаполнятьДвижения = Истина;
		Иначе
			Если Ссылка = ДокументПоследнейКорректировки Тогда
				ЭтотОбъект.мНеПерезаполнятьДвижения = Ложь;
			Иначе
				ЭтотОбъект.мНеПерезаполнятьДвижения = Истина;
				ДокументПоследнейКорректировкиОбъект = ДокументПоследнейКорректировки.ПолучитьОбъект();
				ДокументПоследнейКорректировкиОбъект.мПроверкаПередПроведением = ЭтотОбъект.мПроверкаПередПроведением;
				ДокументПоследнейКорректировкиОбъект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВозможноПодтверждениеЗаявки(ФрмТовары, ФрмКонтрагент, ТекстОшибки) Экспорт
	
	ВозможноПодтверждениеЗаявки = Ложь;
	СтруктураДат = Новый Структура("СрокГарантированный,СрокОжидаемый,СрокГарантированныйЗаказа,СрокОжидаемыйЗаказа", "guaranteed_date", "expected_date", "provider_guaranteed_date", "provider_expected_date");
	
	Если ВсеДатыЗаказовЗаполнены(ФрмТовары, СтруктураДат, ТекстОшибки) Тогда
		ДокументПоследнейКорректировки = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка);
		Если Не ФрмКонтрагент.Служебный Тогда 
			ВозможноПодтверждениеЗаявки = Истина;
		Иначе 
			Сообщить("Заявка не может быть оформлена на служебного контрагента, выберите корректного контрагента");
			ВозможноПодтверждениеЗаявки=Ложь;
		КонецЕсли;	
	Иначе
		Если ДатыЗаказовБылиУстановленыССайта(ФрмТовары, СтруктураДат) Тогда
			ВозможноПодтверждениеЗаявки = ВсеДатыЗаказовЗаполнены(ФрмТовары, СтруктураДат, ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозможноПодтверждениеЗаявки;
	
КонецФункции

Функция ВсеДатыЗаказовЗаполнены(ФрмТовары, СтруктураДат, ТекстОшибки)
	
	ТекстОшибки = "";
	ЕстьНезаполненныеДаты = Ложь;
	
	Для Каждого Строка Из ФрмТовары Цикл
		ОшибкаВСтроке = Ложь;
		ТекстОшибкиВСтроки = "";
		Для Каждого Реквизит Из СтруктураДат Цикл
			ИмяРеквизита = Реквизит.Ключ;
			Если НЕ ЗначениеЗаполнено(Строка[ИмяРеквизита]) Тогда
				ОшибкаВСтроке = Истина;
				ЕстьНезаполненныеДаты = Истина;
				ТекстОшибкиВСтроки = ТекстОшибкиВСтроки + ?(ТекстОшибкиВСтроки = "","",",") + ИмяРеквизита;
			КонецЕсли;
		КонецЦикла;
		Если ОшибкаВСтроке Тогда
			ТекстОшибки = ТекстОшибки + ?(ТекстОшибки = "", "", Символы.ПС) + "Не заполнены даты в строке IDSite: " + Строка.IDSite + " (" + ТекстОшибкиВСтроки + ")";
		КонецЕсли;
	КонецЦикла;	
	
	Возврат НЕ ЕстьНезаполненныеДаты;
	
КонецФункции

Функция ДатыЗаказовБылиУстановленыССайта(ФрмТовары, СтруктураДат)
	
	БылоЗаполнение = Истина;
	СтрокаПрайсов = СтрокаПрайсовПоставщика(ФрмТовары);
	НастройкиДат = НастройкиДатССайтаПоСкладам(Строка(Ссылка.Контрагент.УникальныйИдентификатор()), СтрокаПрайсов);
	Для Каждого Строка Из ФрмТовары Цикл
		Настройка = НастройкиДат[КодПрайсаЧислом(Строка.ПрайсПоставщика)];
		Если ЗначениеЗаполнено(Настройка) Тогда
			ЗаполнитьЗначенияСвойств(Строка, Настройка);
		Иначе
			ЗаполнитьЗначенияСвойств(Строка, НастройкиДат[0]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат БылоЗаполнение;
	
КонецФункции
Функция СтрокаПрайсовПоставщика(Таблица)
	
	МассивПрайсов = Новый Массив;
	СписокПрайсов = "";
	Для Каждого Строка Из Таблица Цикл
		Прайс = Строка.ПрайсПоставщика;
		Если НЕ Прайс.Пустая() И МассивПрайсов.Найти(Прайс) = Неопределено Тогда
			КодПрайса = КодПрайсаЧислом(Прайс);
			Если ЗначениеЗаполнено(КодПрайса) Тогда
				МассивПрайсов.Добавить(Прайс);
				СписокПрайсов = ?(СписокПрайсов = "", "",",") + КодПрайса;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат СписокПрайсов;
	
КонецФункции
Функция КодПрайсаЧислом(Прайс)
	
	Попытка
		КодПрайса = Формат(Число(Прайс.Код), "ЧГ=");
	Исключение
		КодПрайса = 0;
	КонецПопытки;
	
	Возврат КодПрайса;
	
КонецФункции
Функция НастройкиДатССайтаПоСкладам(UUIDКонтрагента, СтрокаПрайсов)
	
	ДатаПоУмолчанию = КонецДня(ТекущаяДата() + 24*60*60);
	
	Соответствие = Новый Соответствие;
	Структура = Новый Структура;
	Структура.Вставить("СрокГарантированный", ДатаПоУмолчанию);
	Структура.Вставить("СрокОжидаемый", ДатаПоУмолчанию);
	Структура.Вставить("СрокГарантированныйЗаказа", ДатаПоУмолчанию);
	Структура.Вставить("СрокОжидаемыйЗаказа", ДатаПоУмолчанию);
	Соответствие.Вставить(0, Структура);
	
	Если ЗначениеЗаполнено(СтрокаПрайсов) Тогда
		Попытка
			Настройка = Справочники.НастройкиРеквизитовДляОбменов.WebServiceПолученияДатЗаказов;
			Адрес = ?(ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза(), Настройка.СтрокаДляРабочейБазы, Настройка.СтрокаДляТестовойБазы);
			HTTPСоединение = Новый HTTPСоединение(Адрес);
			HTTPЗапрос = Новый HTTPЗапрос("/engine/order-delivery-dates?client=" + UUIDКонтрагента + "&warehouse=" + СтрокаПрайсов); 
			Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
			
			Если Ответ.КодСостояния = 200 Тогда
				Текст = Ответ.ПолучитьТелоКакСтроку();
				ЧтениеJSON = Новый ЧтениеJSON;
				ЧтениеJSON.УстановитьСтроку(Текст);
				
				ЧтениеJSON.Прочитать();
				СтруктураОтвета = ОбменДаннымиСервер.РазобратьСтруктуруJSON(ЧтениеJSON);
				//Формат пакета в виде структуры и массивов//
				//<success>false/true</success>
				//<data>
				//	<warehouse>Код склада(Число)</warehouse>
				//	<guaranteed_date>Дата</guaranteed_date>
				//	<expected_date>Дата</expected_date>
				//	<provider_guaranteed_date>Дата</provider_guaranteed_date>
				//	<provider_expected_date>Дата</provider_expected_date>
				//</data>
				//<error>Текст ошибки<error>
				Для Каждого ДанныеПоСкладу Из СтруктураОтвета.data Цикл
					Структура = Новый Структура;
					Структура.Вставить("СрокГарантированный", ДатаИзСтроки(ДанныеПоСкладу.guaranteed_date));
					Структура.Вставить("СрокОжидаемый", ДатаИзСтроки(ДанныеПоСкладу.expected_date));
					Структура.Вставить("СрокГарантированныйЗаказа", ДатаИзСтроки(ДанныеПоСкладу.provider_guaranteed_date));
					Структура.Вставить("СрокОжидаемыйЗаказа", ДатаИзСтроки(ДанныеПоСкладу.provider_expected_date));
					Соответствие.Вставить(ДанныеПоСкладу.warehouse, Структура);
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
			
	Возврат Соответствие;		
	
КонецФункции
Функция ДатаИзСтроки(Строка)

	ВыравниваниеТипаДаты = СтрЗаменить(Строка, " ","");
	ВыравниваниеТипаДаты = СтрЗаменить(ВыравниваниеТипаДаты, ":","");
	ВыравниваниеТипаДаты = СтрЗаменить(ВыравниваниеТипаДаты, "-","");
	
	Возврат Дата(ВыравниваниеТипаДаты);

КонецФункции

// +++ функция выкидывает из номера документа все буквы, оставляя только цифры (Карпычев 12.03.18)
Функция ПреобразоватьНомерДокумента(ИсходнаяСтрока)
	
	КонечнаяСтрока = "";
	Для й = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, й, 1);
		Если Найти("0123456789", ТекущийСимвол) > 0 Тогда
			КонечнаяСтрока = КонечнаяСтрока + ТекущийСимвол; 
		КонецЕсли;	
	КонецЦикла;
	
	// - удаление ведущих нулей
	Пока Лев(КонечнаяСтрока, 1) = "0" Цикл
		КонечнаяСтрока = Сред(КонечнаяСтрока, 2);
	КонецЦикла;
	
	Возврат КонечнаяСтрока;	
	
КонецФункции // --- Карпычев (12.03.18)

#КонецОбласти

#Область Печать

#Если Клиент Тогда
	
// +++ Карпычев (12.03.18)
Функция ПечатьСчетаНаОплату(Макет = Неопределено) Экспорт
	
	ПараметрыПечати = ПолучитьПараметрыПечатиСчетаЗаказа();
	
	ТабДокумент  = Новый ТабличныйДокумент;
	
	// Зададим параметры макета
	ТабДокумент.ПолеСверху              = 0;
	ТабДокумент.ПолеСлева               = 0;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	ТабДокумент.КоличествоЭкземпляров   = 1;
	ТабДокумент.ТолькоПросмотр          = Истина;
	
	ПечатьИзВнешнейОбработки = Макет <> Неопределено;
	Если НЕ ПечатьИзВнешнейОбработки Тогда
		Макет = ПолучитьОбщийМакет("СчетНаОплату");
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакетаШапкатаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакетаШапкатаблицы);
	
	КоличествоСтрок = ПараметрыПечати.Позиции.Количество();
	
	// - Выводим строки таблицы
	ОбластьМакета  = Макет.ПолучитьОбласть("Строка");
	Для Каждого ПараметрыПозиции Из ПараметрыПечати.Позиции Цикл 

		//Если Не ЗначениеЗаполнено(ПараметрыПозиции.Номенклатура) Тогда
		//	Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
		//	Продолжить;
		//КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ПараметрыПозиции);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// - Проверим возможность вывода табличного документа
		СтрокаСПодвалом = Новый Массив;
		СтрокаСПодвалом.Добавить(ОбластьМакета);
		Если НЕ ТабДокумент.ПроверитьВывод(СтрокаСПодвалом) Тогда
			
			Если КоличествоСтрок > 0 Тогда
				// - Вывод разделителя и заголовка таблицы на новой странице
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабДокумент.Вывести(ОбластьМакетаШапкатаблицы);
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЦикла;
	
	// Выводим итоги
	ОбластьМакета  = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);	
	
	Если ПараметрыПечати.УчитыватьНДС Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакетаРеклама = Макет.ПолучитьОбласть("Реклама");
	ТабДокумент.Вывести(ОбластьМакетаРеклама);

	Возврат ТабДокумент;
	
КонецФункции  // ПечатьСчетаНаОплату()  (Карпычев 12.03.18)

// +++ Карпычев (12.03.18)	
Функция ПолучитьПараметрыПечатиСчетаЗаказа() Экспорт
	
	// - если есть корректировки заявки покупателя, то данные берем из последней корректировки
	Док = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка);
	
	ПараметрыПечати = Новый Структура;
	Позиции = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент",    Док);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Док.Ссылка) = ТИП(Документ.КорректировкаЗаявкиПокупателя)
	|			ТОГДА Док.Ссылка.ДокументОснование
	|		ИНАЧЕ Док.Ссылка
	|	КОНЕЦ КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Док.Ссылка) = ТИП(Документ.КорректировкаЗаявкиПокупателя)
	|			ТОГДА Док.Ссылка.ДокументОснование.Номер
	|		ИНАЧЕ Док.Номер
	|	КОНЕЦ КАК Номер,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Док.Ссылка) = ТИП(Документ.КорректировкаЗаявкиПокупателя)
	|			ТОГДА Док.Ссылка.ДокументОснование.Дата
	|		ИНАЧЕ Док.Дата
	|	КОНЕЦ КАК Дата,
	|	Док.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Док.Организация,
	|	Док.БанковскийСчет,
	|	Док.Контрагент КАК Получатель,
	|	Док.Контрагент.Код КАК КодКлиента,
	|	Док.Организация КАК Руководители,
	|	Док.Организация КАК Поставщик,
	|	Док.СуммаДокумента,
	|	Док.ВалютаДокумента,
	|	Док.Организация.УчитыватьНДС КАК УчитыватьНДС,
	|	Док.СуммаВключаетНДС,
	|	ВЫБОР
	|		КОГДА Док.Контрагент.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоФизЛицо
	|ИЗ
	|	Документ." + Док.Метаданные().Имя + " КАК Док
	|ГДЕ
	|	Док.Ссылка = &ТекущийДокумент";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", Док);
	Запрос.УстановитьПараметр("УчитыватьНДС"   , Шапка.УчитыватьНДС);
	
	УниверсальныеМеханизмы.ОпределитьКурсыДокументаДляПечати(ЭтотОбъект, Запрос);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК ТоварНаименование,
	|	ВложенныйЗапрос.Номенклатура.Наименование КАК ТоварНаименованиеКраткое,
	|	"""" КАК ТоварКод,
	|	ВложенныйЗапрос.Номенклатура.Артикул КАК ТоварАртикул,
	|	ВложенныйЗапрос.Номенклатура.Изготовитель.Наименование КАК ТоварПроизводительНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК БазоваяЕдиницаНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код КАК БазоваяЕдиницаКодПоОКЕИ,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ЕдиницаИзмеренияМест.Представление КАК ВидУпаковки,
	|	1 КАК КоличествоВОдномМесте,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.КоличествоМест > 0
	|			ТОГДА ВложенныйЗапрос.КоличествоМест * ВложенныйЗапрос.ЕдиницаИзмеренияМест.Вес
	|		ИНАЧЕ ВложенныйЗапрос.Количество * ВложенныйЗапрос.ЕдиницаИзмерения.Вес
	|	КОНЕЦ КАК МассаБрутто,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.СтавкаНДС КАК СтавкаНДС,
	|	ВложенныйЗапрос.Цена КАК Цена,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.ПроцентСкидкиНаценки = 0
	|				И ВложенныйЗапрос.ПроцентАвтоматическихСкидок = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьСкидкиПоСтроке,
	|	ВложенныйЗапрос.Количество КАК Количество,
	|	ВложенныйЗапрос.КоличествоМест КАК КоличествоМест,
	|	ВложенныйЗапрос.Сумма КАК Сумма,
	|	ВложенныйЗапрос.СуммаНДС КАК СуммаНДС,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.Метка КАК Метка,
	|	ВложенныйЗапрос.ПроцентСкидкиНаценки + ВложенныйЗапрос.ПроцентАвтоматическихСкидок КАК Скидка
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаявкаПокупателя.Номенклатура КАК Номенклатура,
	|		ЗаявкаПокупателя.Коэффициент КАК Коэффициент,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения КАК ЕдиницаИзмеренияМест,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения.Коэффициент КАК КоэффициентМест,
	|		NULL КАК Характеристика,
	|		NULL КАК Серия,
	|		ВЫБОР
	|			КОГДА &УчитыватьНДС
	|				ТОГДА ЗаявкаПокупателя.СтавкаНДС
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|		КОНЕЦ КАК СтавкаНДС,
	|		ЗаявкаПокупателя.Цена * &Курс / &Кратность КАК Цена,
	|		ЗаявкаПокупателя.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		0 КАК ПроцентАвтоматическихСкидок,
	|		СУММА(ЗаявкаПокупателя.Количество) КАК Количество,
	|		СУММА(ЗаявкаПокупателя.Количество) КАК КоличествоМест,
	|		СУММА(ЗаявкаПокупателя.Сумма * &Курс / &Кратность) КАК Сумма,
	|		СУММА(ВЫБОР
	|				КОГДА &УчитыватьНДС
	|					ТОГДА ЗаявкаПокупателя.СуммаНДС * &Курс / &Кратность
	|				ИНАЧЕ 0
	|			КОНЕЦ) КАК СуммаНДС,
	|		МИНИМУМ(ЗаявкаПокупателя.НомерСтроки) КАК НомерСтроки,
	|		0 КАК Метка
	|	ИЗ
	|		Документ." + Док.Метаданные().Имя + ".Товары КАК ЗаявкаПокупателя
	|	ГДЕ
	|		ЗаявкаПокупателя.Ссылка = &ТекущийДокумент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗаявкаПокупателя.Номенклатура,
	|		ЗаявкаПокупателя.Коэффициент,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения,
	|		ЗаявкаПокупателя.СтавкаНДС,
	|		ЗаявкаПокупателя.Цена,
	|		ЗаявкаПокупателя.ПроцентСкидкиНаценки,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения,
	|		ЗаявкаПокупателя.ЕдиницаИзмерения.Коэффициент) КАК ВложенныйЗапрос";
	
	СтрокаВыборкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("ЗаявкаПокупателя");
	
	Запрос.Текст = Запрос.Текст + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаявкаПокупателя.Номенклатура                        КАК Номенклатура,
		|	" + СтрокаВыборкиПоляСодержания + "                  КАК ТоварНаименование,
		|	" + СтрокаВыборкиПоляСодержания + "                  КАК ТоварНаименованиеКраткое,
		|	""""                                                 КАК ТоварКод,
		|	ЗаявкаПокупателя.Номенклатура.Артикул                КАК ТоварАртикул,
		|	NULL                                                 КАК ТоварПроизводительНаименование,
		|	""шт""                                               КАК БазоваяЕдиницаНаименование,
		|	""796""                                              КАК БазоваяЕдиницаКодПоОКЕИ,
		|	""шт""                                               КАК ЕдиницаИзмерения,
		|	NULL                                                 КАК ВидУпаковки,
		|	NULL                                                 КАК КоличествоВОдномМесте,
		|	0                                                    КАК МассаБрутто,
		|	NULL                                                 КАК Характеристика,
		|	NULL                                                 КАК Серия,
		|	ВЫБОР
	    |		КОГДА &УчитыватьНДС
	    |			ТОГДА ЗаявкаПокупателя.СтавкаНДС
	    |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	    |	КОНЕЦ                                                КАК СтавкаНДС,
		|	ЗаявкаПокупателя.Цена * &Курс / &Кратность           КАК Цена,
		|	ЛОЖЬ                                                 КАК ЕстьСкидкиПоСтроке,
		|	ЗаявкаПокупателя.Количество                          КАК Количество,
		|	NULL                                                 КАК КоличествоМест,
		|	ЗаявкаПокупателя.Сумма    * &Курс / &Кратность       КАК Сумма,
		|	ВЫБОР
		|		КОГДА &УчитыватьНДС
		|			ТОГДА ЗаявкаПокупателя.СуммаНДС * &Курс / &Кратность
		|		ИНАЧЕ 0
		|	КОНЕЦ                                                КАК СуммаНДС,
		|	ЗаявкаПокупателя.НомерСтроки                         КАК НомерСтроки,
		|	1                                                    КАК Метка,
		|	0                                                    КАК Скидка
		|ИЗ
		|	Документ." + Док.Метаданные().Имя + ".Услуги КАК ЗаявкаПокупателя
		|
		|ГДЕ
		|	ЗаявкаПокупателя.Ссылка = &ТекущийДокумент
		|УПОРЯДОЧИТЬ ПО Метка ВОЗР, НомерСтроки ВОЗР
		|";
	
	// --- Карпычев (02.03.18)
	
	ЗапросТовары = Запрос.Выполнить().Выгрузить();
		
	ПараметрыПечати.Вставить("УчитыватьНДС", Шапка.УчитыватьНДС);
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
	ПараметрыПечати.Вставить("ИНН", СведенияОПоставщике.ИНН);
	ПараметрыПечати.Вставить("КПП", СведенияОПоставщике.КПП);
	ПредставлениеПоставщикаДляПлатПоручения = "";
	Если ЗначениеЗаполнено(Шапка.БанковскийСчет) Тогда
		Банк       = ?(Не ЗначениеЗаполнено(Шапка.БанковскийСчет.БанкДляРасчетов), Шапка.БанковскийСчет.Банк, Шапка.БанковскийСчет.БанкДляРасчетов);
		НомерСчета = Шапка.БанковскийСчет.НомерСчета;
	Иначе
		Банк       = СведенияОПоставщике.Банк;
		НомерСчета = СведенияОПоставщике.НомерСчета;
	КонецЕсли;
	БИК        = Банк.Код;
	КоррСчет   = Банк.КоррСчет;
	ГородБанка = Банк.Город;
	
	ПараметрыПечати.Вставить("Покупатель", Шапка.Получатель);
	ПараметрыПечати.Вставить("Поставщик", Шапка.Поставщик);
	ПараметрыПечати.Вставить("БИКБанкаПолучателя", БИК);
	ПараметрыПечати.Вставить("БанкПолучателя", Банк);
	ПараметрыПечати.Вставить("БанкПолучателяПредставление", СокрЛП(Банк) + " " + ГородБанка);
	ПараметрыПечати.Вставить("СчетБанкаПолучателя", КоррСчет);
	ПараметрыПечати.Вставить("СчетБанкаПолучателяПредставление", КоррСчет);
	ПараметрыПечати.Вставить("СчетПолучателяПредставление", НомерСчета);
	ПараметрыПечати.Вставить("СчетПолучателя", НомерСчета);
	ПредставлениеПоставщикаДляПлатПоручения = Шапка.БанковскийСчет.ТекстКорреспондента;
	Если ПустаяСтрока(ПредставлениеПоставщикаДляПлатПоручения) Тогда
		ПредставлениеПоставщикаДляПлатПоручения = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
	КонецЕсли;
	ПараметрыПечати.Вставить("ПредставлениеПоставщикаДляПлатПоручения", ПредставлениеПоставщикаДляПлатПоручения);
	//ПараметрыПечати.Вставить("ТекстЗаголовка", ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Счет на оплату"));
	ПараметрыПечати.Вставить("ТекстЗаголовка", "Счет на оплату № " + ПреобразоватьНомерДокумента(ОбщегоНазначения.ПолучитьНомерНаПечать(Шапка)) + " от " + Формат(Шапка.Дата, "ДФ='дд ММММ гггг'") + " г.");
	ПараметрыПечати.Вставить("ПредставлениеПоставщика", ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));
	СведенияОПолучателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
	ПараметрыПечати.Вставить("ПредставлениеПолучателя", ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));

	ПараметрыПечати.Вставить("ЕстьСкидки", Ложь);
	ПараметрыПечати.Вставить("ВыводитьКоды", Истина);
	
	Сумма    = 0;
	СуммаНДС = 0;
	ВсегоСкидок    = 0;
	ВсегоБезСкидок = 0;

	Для Каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
		
		ПараметрыПозиции = Новый Структура;

		ПараметрыПозиции.Вставить("Номенклатура", ВыборкаСтрокТовары.Номенклатура);
		ПараметрыПозиции.Вставить("НомерСтроки", ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1);

		Если ПараметрыПечати.ВыводитьКоды Тогда
			ПараметрыПозиции.Вставить("ТоварАртикул", ВыборкаСтрокТовары.ТоварАртикул);
		КонецЕсли;

		ПараметрыПозиции.Вставить("Количество", ВыборкаСтрокТовары.Количество);
		ПараметрыПозиции.Вставить("ЕдиницаИзмерения", ВыборкаСтрокТовары.ЕдиницаИзмерения);
		ПараметрыПозиции.Вставить("Цена", ВыборкаСтрокТовары.Цена);
		ПараметрыПозиции.Вставить("ТоварПроизводительНаименование", СокрП(ВыборкаСтрокТовары.ТоварПроизводительНаименование));
		Если НЕ ПустаяСтрока(СокрЛП(ВыборкаСтрокТовары.ТоварНаименование)) Тогда
			ПараметрыПозиции.Вставить("Товар", СокрЛП(ВыборкаСтрокТовары.ТоварНаименование));
		Иначе
			ПараметрыПозиции.Вставить("Товар", СокрЛП(ВыборкаСтрокТовары.ТоварНаименованиеКраткое));
		КонецЕсли;

		Скидка = Ценообразование.ПолучитьСуммуСкидки(ВыборкаСтрокТовары.Сумма, ВыборкаСтрокТовары.Скидка);

		Если ПараметрыПечати.ЕстьСкидки Тогда
			ПараметрыПозиции.Вставить("Скидка", Скидка);
			ПараметрыПозиции.Вставить("СуммаБезСкидки", ВыборкаСтрокТовары.Сумма + Скидка);
		КонецЕсли;

		ПараметрыПозиции.Вставить("Сумма", ВыборкаСтрокТовары.Сумма); 
		
		Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
		СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;
		ВсегоСкидок    = ВсегоСкидок + Скидка;
		ВсегоБезСкидок = Сумма       + ВсегоСкидок;
		
		Позиции.Добавить(ПараметрыПозиции);

	КонецЦикла;
	
	ПараметрыПечати.Вставить("Позиции", Позиции);

	// Вывести Итого
	Если ПараметрыПечати.ЕстьСкидки Тогда
		ПараметрыПечати.Вставить("ВсегоСкидок", ВсегоСкидок);
		ПараметрыПечати.Вставить("ВсегоБезСкидок", ВсегоБезСкидок);
	КонецЕсли;
	ПараметрыПечати.Вставить("Всего", ОбщегоНазначения.ФорматСумм(Сумма));

	// Вывести ИтогоНДС
	Если ПараметрыПечати.УчитыватьНДС Тогда
		ПараметрыПечати.Вставить("НДС", ?(Шапка.СуммаВключаетНДС, "В том числе НДС:", "Сумма НДС:"));
		ПараметрыПечати.Вставить("ВсегоНДС", ОбщегоНазначения.ФорматСумм(ЗапросТовары.Итог("СуммаНДС")));
	КонецЕсли;

	// Вывести Сумму прописью
	СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
	ПараметрыПечати.Вставить("ИтоговаяСтрока", "Всего наименований " + ЗапросТовары.Количество()
	+ ", на сумму " + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента));
	ПараметрыПечати.Вставить("СуммаПрописью", ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента));

	// Вывести подписи
	Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизации(Шапка.Руководители, Шапка.Дата,);
	Руководитель = Руководители.Руководитель;
	Бухгалтер    = Руководители.ГлавныйБухгалтер;

	ПараметрыПечати.Вставить("ФИОРуководителя", "/" + Руководитель  + "/");
	ПараметрыПечати.Вставить("ФИОБухгалтера", "/" + Бухгалтер     + "/");
	ПараметрыПечати.Вставить("ФИООтветственный", "/" + ПараметрыСеанса.ТекущийПользователь + "/");
	
	ПараметрыПечати.Вставить("КодКлиента", "ID клиента: " + Шапка.КодКлиента);

	Возврат ПараметрыПечати;
	
КонецФункции  // --- ПечатьСчетаНаОплату()   (Карпычев 12.03.18)
	
#КонецЕсли

#КонецОбласти

// +++ Карпычев (12.03.18)
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт

	СтруктураМакетов = Новый Структура;
	
	СтруктураМакетов.Вставить("СчетНаОплату", "Счет на оплату");

	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()



мНеПерезаполнятьДвижения = Ложь;
мПроверкаПередПроведением = Ложь;