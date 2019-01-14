﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Точка входа для выполнения итерации обмена данными – загрузки и выгрузки данных для узла плана обмена
//
// Параметры:
//  Отказ                  - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении обмена
//  УзелИнформационнойБазы – ПланОбменаСсылка – узел плана обмена, для которого выполняется итерация обмена данными
//  ВыполнятьЗагрузку      – Булево (необязательный) – флаг необходимости выполнять загрузку данных. Значение по умолчанию - Истина
//  ВыполнятьВыгрузку      – Булево (необязательный) – флаг необходимости выполнять выгрузку данных. Значение по умолчанию – Истина
//  ВидТранспортаСообщенийОбмена (необязательный) - ПеречислениеСсылка.ВидыТранспортаСообщенийОбмена – вид транспорта, 
//								который будет использоваться в процессе обмена данными. 
//								Значение по умолчанию – значение из РС.НастройкиТранспортаОбмена.Ресурс.ВидТранспортаСообщенийОбменаПоУмолчанию;
//								если в РС значение не задано, то значение по умолчанию - Перечисления.ВидыТранспортаСообщенийОбмена.FILE
// 
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку = Истина,
														ВыполнятьВыгрузку = Истина,
														ВидТранспортаСообщенийОбмена = Неопределено,
														ДлительнаяОперация = Ложь,
														ИдентификаторОперации = "",
														ИдентификаторФайла = "",
														ДлительнаяОперацияРазрешена = Ложь,
														Знач Пароль = ""
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку,
														ВыполнятьВыгрузку,
														ВидТранспортаСообщенийОбмена,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ИдентификаторФайла,
														ДлительнаяОперацияРазрешена,
														Пароль
	);
	
КонецПроцедуры

// Выполняет процесс обмена данными отдельно для каждой строки настройки обмена
// Процесс обмена данными состоит из двух стадий:
// - инициализация обмена - подготовка подсистемы обмена данными к процессу обмена
// - обмен данными        - процесс зачитывания файла сообщения с последующей загрузкой этих данных в ИБ 
//                          или выгрузки изменений в файл сообщения
// Стадия инициализации выполняется один раз за сеанс и сохраняется в кэше сеанса на сервере 
// до перезапуска сеанса или сброса повторно-используемых значений подсистемы обмена данными.
// Сброс повторно-используемых значений происходит при изменении данных, влияющих на процесс обмена данными
// (настройки транспорта, настройка выполнения обмена, настройка отборов на узлах планов обмена)
//
// Обмен может быть выполнен полностью для всех строк сценария,
// а может быть выполнен для отдельной строки ТЧ сценария обмена
//
// Параметры:
//  Отказ                     - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении сценария
//  НастройкаВыполненияОбмена - СправочникСсылка.СценарииОбменовДанными - элемент справочника,
//                              по значениям реквизитов которого будет выполнен обмен данными
//  НомерСтроки               - Число - Номер строки по которой будет выполнен обмен данными.
//                              Если не указан, то обмен данными будет выполнен для всех строк
// 
Процедура ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки = Неопределено) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки);
	
КонецПроцедуры

//

// Выполняет проверку актуальности КЭШа механизма регистрации объектов.
// Если кэш неактуальный, то выполняется инициализация КЭШа актуальными значениями.
//
// Параметры:
//  Нет.
// 
Процедура ПроверитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		АктуальнаяДата = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
		
		Если ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО <> АктуальнаяДата Тогда
			
			ОбновитьКэшМеханизмаРегистрацииОбъектов();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет/устанавливает повторно-используемые значения и параметры сеанса для подсистемы обмена данными
//
// Устанавливаемые параметры сеанса:
//   ИспользуемыеПланыОбмена    - ФиксированныйМассив - массив с именами планов обмена для которых используется обмен.
//   ПравилаРегистрацииОбъектов - ХранилищеЗначения - в бинарном виде содержит таблицу значений с правилами регистрации объектов.
//   ПравилаВыборочнойРегистрацииОбъектов - 
//   ДатаОбновленияПовторноИспользуемыхЗначенийМРО - Дата (Дата и время) - содержит дату последнего актуального
//                                                                         кэша для подсистемы обмена данными
//
// Параметры:
//  Нет.
// 
Процедура ОбновитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// получаем планы обмена конфигурации, которые используются при обмене
	ПараметрыСеанса.ИспользуемыеПланыОбмена = Новый ФиксированныйМассив(ОбменДаннымиСервер.ПолучитьИспользуемыеПланыОбмена());
	
	Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Количество() > 0 Тогда
		
		ПараметрыСеанса.ПравилаРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ПолучитьПравилаРегистрацииОбъектов());
		
		ПараметрыСеанса.ПравилаВыборочнойРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ПолучитьПравилаВыборочнойРегистрацииОбъектов());
		
	Иначе
		
		ПараметрыСеанса.ПравилаРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ИнициализацияТаблицыПравилРегистрацииОбъектов());
		
		ПараметрыСеанса.ПравилаВыборочнойРегистрацииОбъектов = Новый ХранилищеЗначения(ОбменДаннымиСервер.ИнициализацияТаблицыПравилВыборочнойРегистрацииОбъектов());
		
	КонецЕсли;
	
	// Ключ для проверки актуальности кэша
	//ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
	
КонецПроцедуры

// Устанавливает значение константы ДатаОбновленияПовторноИспользуемыхЗначенийМРО
// В качестве устанавливаемого значения используется текущая дата компьютера (сервера)
// В момент изменения значения этой константы повторно-используемые значения 
// для подсистемы обмена данными становятся неактуальными и требуют повторной инициализации.
//
// Параметры:
//  Нет.
// 
Процедура СброситьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		// записываем дату и время компьютера сервера - ТекущаяДата()
		// метод ТекущаяДатаСеанса() использовать нельзя.
		// Текущая дата сервера в данном случае используется в качестве ключа уникальности кэша механизма регистрации объектов.
		Константы.ДатаОбновленияПовторноИспользуемыхЗначенийМРО.Установить(ТекущаяДата());
		
	КонецЕсли;
	
КонецПроцедуры

//

// Выполняет загрузку данных сообщения обмена, расположенного в локальной файловой системе сервера.
//
Процедура ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезФайл(Отказ, Знач УзелИнформационнойБазы, Знач ПолноеИмяФайлаСообщенияОбмена) Экспорт
	
	Попытка
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(УзелИнформационнойБазы, ПолноеИмяФайлаСообщенияОбмена, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Исключение
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

// Фиксирует успешное выполнение обмена данными в системе.
//
Процедура ЗафиксироватьВыполнениеВыгрузкиДанныхВРежимеДлительнойОперации(Знач УзелИнформационнойБазы, Знач ДатаНачала) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	СтруктураНастроекОбмена = Новый Структура;
	СтруктураНастроекОбмена.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураНастроекОбмена.Вставить("РезультатВыполненияОбмена", Перечисления.РезультатыВыполненияОбмена.Выполнено);
	СтруктураНастроекОбмена.Вставить("ДействиеПриОбмене", ДействиеПриОбмене);
	СтруктураНастроекОбмена.Вставить("КоличествоОбъектовОбработано", 0);
	СтруктураНастроекОбмена.Вставить("КлючСообщенияЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	СтруктураНастроекОбмена.Вставить("ДатаНачала", ДатаНачала);
	СтруктураНастроекОбмена.Вставить("ДатаОкончания", ТекущаяДатаСеанса());
	СтруктураНастроекОбмена.Вставить("ЭтоОбменВРИБ", ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы));
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует аварийное завершение обмена данными.
//
Процедура ЗафиксироватьЗавершениеОбменаСОшибкой(Знач УзелИнформационнойБазы,
												Знач ДействиеПриОбмене,
												Знач ДатаНачала,
												Знач СтрокаСообщенияОбОшибке
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(УзелИнформационнойБазы,
											ДействиеПриОбмене,
											ДатаНачала,
											СтрокаСообщенияОбОшибке
	);
КонецПроцедуры

// Выполняет получение файла сообщения обмена из базы-корреспондента через веб-сервис.
// Выполняет загрузку полученного файла сообщения обмена в эту базу.
//
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															Знач УзелИнформационнойБазы,
															Знач ИдентификаторФайла,
															Знач ДатаНачалаОперации,
															Знач Пароль = ""
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															УзелИнформационнойБазы,
															ИдентификаторФайла,
															ДатаНачалаОперации,
															Пароль
	);
КонецПроцедуры

// Выполняет попытку установки внешнего соединения по переданным параметрам подключения.
// Если установить внешнее соединение не удалось, то поднимается флаг Отказ.
//
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ, СтруктураНастроек, ОшибкаПодключенияКомпоненты = Ложь) Экспорт
	
	СтрокаСообщенияОбОшибке = "";
	
	// выполняем попытку установки внешнего соединения
	ВнешнееСоединение = ОбменДаннымиСервер.УстановитьВнешнееСоединение(СтруктураНастроек, СтрокаСообщенияОбОшибке, ОшибкаПодключенияКомпоненты);
	
	Если ВнешнееСоединение = Неопределено Тогда
		
		// Выводим сообщение об ошибке
		Сообщение = НСтр("ru = 'Ошибка при установке подключения ко второй информационной базе: %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, СтрокаСообщенияОбОшибке);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение,,,, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак того, что набора записей регистра не содержит данных.
//
Функция НаборЗаписейРегистраПустой(СтруктураЗаписи, ИмяРегистра) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	// создаем набор записей регистра
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	
	// устанавливаем отбор по измерениям регистра
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		// если задано значение в структуре, то отбор устанавливаем
		Если СтруктураЗаписи.Свойство(Измерение.Имя) Тогда
			
			НаборЗаписей.Отбор[Измерение.Имя].Установить(СтруктураЗаписи[Измерение.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() = 0;
	
КонецФункции

// Возвращает ключ сообщения журнала регистрации по строке действия
//
Функция ПолучитьКлючСообщенияЖурналаРегистрацииПоСтрокеДействия(УзелИнформационнойБазы, ДействиеПриОбменеСтрокой) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене[ДействиеПриОбменеСтрокой]);
	
КонецФункции

// Возвращает структуру с данными отбора для журнала регистрации
//
Функция ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы, Знач ДействиеПриОбмене) Экспорт
	
	Если ТипЗнч(ДействиеПриОбмене) = Тип("Строка") Тогда
		
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене[ДействиеПриОбмене];
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СостоянияОбменовДанными = ОбменДаннымиСервер.СостоянияОбменовДанными(УзелИнформационнойБазы, ДействиеПриОбмене);
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	Отбор.Вставить("ДатаНачала",                СостоянияОбменовДанными.ДатаНачала);
	Отбор.Вставить("ДатаОкончания",             СостоянияОбменовДанными.ДатаОкончания);
	
	Возврат Отбор;
КонецФункции

// Получает код предопределенного узла плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как оно задано в конфигураторе
// 
// Возвращаемое значение:
//  Строка - код предопределенного узла плана обмена
//
Функция ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
КонецФункции

// Возвращает массив всех ссылочных типов, определенных в конфигурации
//
Функция ВсеСсылочныеТипыКонфигурации() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ВсеСсылочныеТипыКонфигурации();
	
КонецФункции

// Получает состояние длительной операции (фонового задания), выполняемой в базе-корреспонденте.
//
Функция СостояниеДлительнойОперации(Знач ИдентификаторОперации,
									Знач URLВебСервиса,
									Знач ИмяПользователя,
									Знач Пароль,
									СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
	ПараметрыПодключения.WSURLВебСервиса   = URLВебСервиса;
	ПараметрыПодключения.WSИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.WSПароль          = Пароль;
	
	WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения, СтрокаСообщенияОбОшибке);
	
	Если WSПрокси = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Возврат WSПрокси.GetContinuousOperationStatus(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											Пароль = ""
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											Пароль
	);
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
// Используется в том случае, если получение сообщения обмена выполнялось в контексте фонового задания в базе-корреспонденте.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							Знач Пароль = ""
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							Пароль
	);
КонецФункции

// Возвращает признак изменения конфигурации для подчиненного узла распределенной ИБ.
//
Функция ТребуетсяУстановкаОбновления() Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
КонецФункции

// Удаляет информацию о проблемах записи объекта при его записи
//
Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы, Знач НовоеЗначениеПометкиУдаления) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПараметрыСеанса.ИспользуемыеПланыОбмена.Количество() > 0 Тогда
		
		НаборЗаписейКонфликта = РегистрыСведений.РезультатыОбменаДанными.СоздатьНаборЗаписей();
		НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Источник);
		НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
		
		НаборЗаписейКонфликта.Прочитать();
		
		Если НаборЗаписейКонфликта.Количество() = 1 Тогда
			
			
			Если НовоеЗначениеПометкиУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "ПометкаУдаления") Тогда
				
				НаборЗаписейКонфликта[0].ПометкаУдаления = НовоеЗначениеПометкиУдаления;
				НаборЗаписейКонфликта.Записать();
				
				
			Иначе
				
				НаборЗаписейКонфликта.Очистить();
				НаборЗаписейКонфликта.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен данными под полными правами

// Устанавливает параметры сеанса подсистемы обмена данными
//
// Параметры:
//  ИмяПараметра - Строка - имя параметра сеанса, значение которого необходимо установить
//  УстановленныеПараметры - массив - в данный параметр помещается информация об установленных параметрах сеанса
// 
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	// процедура обновления повторно-используемых значений и параметров сеанса
	ОбновитьКэшМеханизмаРегистрацииОбъектов();
	
	// зарегистрируем имена параметров, которые установлены при 
	// выполнении ОбменДаннымиВызовСервера.ОбновитьКэшМеханизмаРегистрацииОбъектов
	УстановленныеПараметры.Добавить("ИспользуемыеПланыОбмена");
	УстановленныеПараметры.Добавить("ПравилаВыборочнойРегистрацииОбъектов");
	УстановленныеПараметры.Добавить("ПравилаРегистрацииОбъектов");
	УстановленныеПараметры.Добавить("ДатаОбновленияПовторноИспользуемыхЗначенийМРО");
	
	ОбменДаннымиСервер.УстановитьРежимЗагрузкиПараметровРаботыПрограммы(Ложь);
	УстановленныеПараметры.Добавить("ЗагрузкаПараметровРаботыПрограммы");
	
КонецПроцедуры

// Проверяет режим запуска, устанавливает привилегированный режим и выполняет обработчик
//
Процедура ВыполнитьОбработчикВПривилегированномРежиме(Значение, Знач СтрокаОбработчика) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выполнить(СтрокаОбработчика);
	
КонецПроцедуры

// Находит регламентное задание по GUID
//
// Параметры:
//  УникальныйНомерЗадания - Строка - строка с GUID регламентного задания
// 
// Возвращаемое значение:
//  Неопределено        - если поиск регламентного задания по GUID не дал результатов или
//  РегламентноеЗадание - найденное по GUID регламентное задание.
//
Функция НайтиРегламентноеЗаданиеПоПараметру(Знач УникальныйНомерЗадания) Экспорт
	
	Если ПустаяСтрока(УникальныйНомерЗадания) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(УникальныйНомерЗадания));
КонецФункции

// Возвращает структуру со значениями свойств объекта, полученных запросом из ИБ.
// Ключ структуры – имя свойства; Значение – значение свойства объекта.
//
// Параметры:
//  Ссылка – ссылка на объект ИБ, значения свойств которого требуется получить
// 
//  Возвращаемое значение:
//  Тип: Структура. Структура со значениями свойств объекта.
//
Функция ПолучитьЗначенияСвойствДляСсылки(Ссылка, СвойстваОбъекта, Знач СвойстваОбъектаСтрокой, Знач ОбъектМетаданныхИмя) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьЗначенияСвойствДляСсылки(Ссылка, СвойстваОбъекта, СвойстваОбъектаСтрокой, ОбъектМетаданныхИмя);
КонецФункции

// Возвращает массив узлов плана обмена по заданным параметрам запроса и тексту запроса к таблице плана обмена
//
//
Функция МассивУзловПоЗначениямСвойств(ЗначенияСвойств, Знач ТекстЗапроса, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.МассивУзловПоЗначениямСвойств(ЗначенияСвойств, ТекстЗапроса, ИмяПланаОбмена, ИмяРеквизитаФлага);
КонецФункции

// Возвращает значение параметра сеанса ПравилаРегистрацииОбъектов, полученное в привилегированном режиме.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Тип: ХранилищеЗначения. Значение параметра сеанса ПравилаРегистрацииОбъектов.
//
Функция ПараметрыСеансаПравилаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПравилаРегистрацииОбъектов;
	
КонецФункции

// Функция возвращает список всех узлов заданного плана обмена кроме предопределенного узла
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, как оно задано в конфигураторе, список узлов для которого необходимо получить
//
//  Возвращаемое значение:
//   Массив – список всех узлов заданного плана обмена.
//
Функция ВсеУзлыПланаОбмена(Знач ИмяПланаОбмена) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена(ИмяПланаОбмена);
	
КонецФункции

// Возвращает признак того, что для получателя зарегистрированы изменения данных
//
Функция ИзмененияЗарегистрированы(Знач Получатель) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	[Таблица].Изменения КАК ТаблицаИзменений
	|ГДЕ
	|	ТаблицаИзменений.Узел = &Узел";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Получатель);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоставПланаОбмена = Метаданные.ПланыОбмена[ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель)].Состав;
	
	Для Каждого ЭлементСостава Из СоставПланаОбмена Цикл
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "[Таблица]", ЭлементСостава.Метаданные.ПолноеИмя());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// Возвращает признак использования плана обмена в обмене данными.
// Если план обмена содержит хотя бы один узел кроме предопределенного,
// то считается, что он используется.
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, как оно задано в конфигураторе.
//
// Возвращаемое значение:
// Тип: Булево. Истина – план обмена используется, Ложь – нет.
//
Функция ОбменДаннымиВключен(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ОбменДаннымиВключен(ИмяПланаОбмена);
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать всегда»
//
// Параметры:
//  ИмяПланаОбмена    – Строка – имя плана обмена, как объекта метаданных, по которому определяются узлы
//  ИмяРеквизитаФлага – Строка – имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
// 
//  Возвращаемое значение:
//  Тип: Массив. Массив узлов плана обмена, для которых установлен признак «Выгружать всегда»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьВсегда(Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьМассивУзловДляРегистрацииВыгружатьВсегда(ИмяПланаОбмена, ИмяРеквизитаФлага);
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать при необходимости»
//
// Параметры:
//  Ссылка – ссылка на объект ИБ, для которого необходимо получить массив узлов, в которые объект ранее выгружался
//  ИмяПланаОбмена    – Строка – имя плана обмена, как объекта метаданных, по которому определяются узлы
//  ИмяРеквизитаФлага – Строка – имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
// 
//  Возвращаемое значение:
//  Тип: Массив. Массив узлов плана обмена, для которых установлен признак «Выгружать при необходимости»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьПриНеобходимости(Ссылка, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСобытия.ПолучитьМассивУзловДляРегистрацииВыгружатьПриНеобходимости(Ссылка, ИмяПланаОбмена, ИмяРеквизитаФлага);
КонецФункции

// Возвращает признак режима загрузки параметров работы программы из сообщения обмена в информационную базу.
// Актуально для обмена в РИБ при загрузке данных в подчиненном узле РИБ.
//
Функция ЗагрузкаПараметровРаботыПрограммы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ЗагрузкаПараметровРаботыПрограммы = Истина;
КонецФункции

// Возвращает признак режима загрузки параметров работы программы из сообщения обмена
//
Функция ВыполнитьЗагрузкуПараметровРаботыПрограммы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ВыполнитьЗагрузкуПараметровРаботыПрограммы.Получить() = Истина;
КонецФункции

// Отменяет режим загрузки параметров работы программы из сообщения обмена
//
Процедура ОтменитьЗагрузкуПараметровРаботыПрограммы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ВыполнитьЗагрузкуПараметровРаботыПрограммы.Установить(Ложь);
	
КонецПроцедуры

Процедура ЗарегистрироватьСообщениеВИсторииОбменаССайтом(вхИдентификаторОтправителя, вхИдентификаторПолучателя, вхСообщениеОбмена, вхНомерПринятого) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);	
	лЗапись = РегистрыСведений.ИсторияОбменаССайтом.СоздатьМенеджерЗаписи();
	лЗапись.Период = ТекущаяДата();
	лЗапись.ИдентификаторОтправителя = вхИдентификаторОтправителя;
	лЗапись.ИдентификаторПолучателя = вхИдентификаторПолучателя;
	лЗапись.СообщениеОбмена = вхСообщениеОбмена;
	лЗапись.НомерПринятого = вхНомерПринятого;
	лЗапись.Записать(Истина);
	
КонецПроцедуры

Функция РаспаковатьСообщениеОбменаССайтом(вхСообщениеОбмена) Экспорт
	Возврат DataExchangeПовтИсп.ПолучитьУпаковщик().UnpackWideString(вхСообщениеОбмена);	
КонецФункции

Процедура ДобавитьЗаписьВЛог_ОбменПартКом77_83(вхДобавляемаяСтрока) Экспорт
	
	Если НЕ ПараметрыСеанса.РасширенныйЛогОбменаПартком77_83 тогда
		Возврат;
	КонецЕсли;
		
	лДобавляемаяСтрока = СокрЛП(вхДобавляемаяСтрока);
	Если ПустаяСтрока(лДобавляемаяСтрока) тогда
		лДобавляемаяСтрока = "<<<нет данных!!!>>>";
	КонецЕсли;
	
	лДобавляемаяСтрока = Формат(ТекущаяДата(), "ДФ='гггг-ММ-дд ЧЧ:мм:сс'") + "> " + лДобавляемаяСтрока;
	Попытка
		лЗаписьТекста = Новый ЗаписьТекста("c:\Log\ОбменПартКом77_83.log", "utf-8", , Истина);
		лЗаписьТекста.ЗаписатьСтроку(лДобавляемаяСтрока);
		лЗаписьТекста.Закрыть();
	исключение
		//каталог недоступен, значит клиенту оно не надо
	КонецПопытки;
	
КонецПроцедуры

Функция ЗаполнитьСоответствиеSSIDИКлиентов(СоотвSSIDКлиентов, Строка_site_ID) Экспорт 
		
	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда 
		ИмяРеквизита = "СтрокаДляРабочейБазы";
	Иначе	
		ИмяРеквизита = "СтрокаДляТестовойБазы";
	КонецЕсли;
	
	АдресСервераMySQL = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.АдресСервераMySQL, ИмяРеквизита); 
	ИмяБазы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ИмяБазыMySQL, ИмяРеквизита);
	СтрокаПодключенияADO = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.СтрокаПодключенияADO, ИмяРеквизита);
	ИмяПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ИмяПользователяMySQL, ИмяРеквизита);
	ПарольПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ПарольПользователяMySQL, ИмяРеквизита);
	ИмяТаблицы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.НастройкиРеквизитовДляОбменов.ИмяТаблицыДляПоискаКА, ИмяРеквизита);
	
	Если Не ЗначениеЗаполнено(АдресСервераMySQL) Тогда 
		ВызватьИсключение "В константах не заполнен адрес сервера MySQL";
	КонецЕсли;
	
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%АдресСервера%", АдресСервераMySQL);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ИмяБазы%", ИмяБазы);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ИмяПользователя%", ИмяПользователя);
	СтрокаПодключенияADO = СтрЗаменить(СтрокаПодключенияADO, "%ПарольПользователя%", ПарольПользователя);
	
	ADOСоединение  = Новый COMОбъект("ADODB.Connection");

	ADOСоединение.Open(СтрокаПодключенияADO);	
	
	RS = Новый COMОбъект ("ADODB.RecordSet");
	RS.Open("SELECT site_ID, UID_client FROM " + ИмяТаблицы + " WHERE site_ID IN ("+ Строка_site_ID + ")", ADOСоединение);
	Пока Не RS.EOF Цикл 
		СоотвSSIDКлиентов.Вставить(RS.Fields("site_ID").Value, RS.Fields("UID_client").Value);
		RS.MoveNext();
	КонецЦикла;
	
	ADOСоединение.Close();
	
КонецФункции

//Временно на момент перехода
Процедура  ПолучитьДокументИз77(вхПараметры) Экспорт
	
	ЗагрузитьРТУИз77 = Обработки.ЗагрузитьРТУИз77.Создать();
	ЗаполнитьЗначенияСвойств(ЗагрузитьРТУИз77, вхПараметры);
	ЗагрузитьРТУИз77.ЗагрузитьИз77();	
	
КонецПроцедуры