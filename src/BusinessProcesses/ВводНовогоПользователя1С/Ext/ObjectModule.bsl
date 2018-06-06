﻿
Процедура ЗаявкаНаДобавлениеПользователяПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

// Процедура вызывается перед стартом бизнес-процесса для выполнения проверок и
//заполнения реквизитов.
//
Процедура ПередСтартомБизнесПроцесса(Отказ)

	Заголовок = "Старт бизнес-процесса:" + Ссылка;

	//ПроверитьЗаполнениеРеквизитов(Отказ,Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ОбработатьСтартБизнесПроцесса();

	//ОбновитьНомерЦиклаБизнесПроцесса();

КонецПроцедуры // ПередСтартомБизнесПроцесса()

// Процедура вызывается перед стартом бизнес-процесса для заполнения реквизитов.
//
Процедура ОбработатьСтартБизнесПроцесса()

	ДатаСтарта = ТекущаяДата();
	Если Инициатор.Пустая() Тогда
		Инициатор = ОбщегоНазначения.ПолучитьЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;

	//// Установим начальное состояние согласования.
	//СостояниеСогласования = Перечисления.СостояниеОбъектаСогласования.НаСогласовании;

КонецПроцедуры // ОбработатьСтартБизнесПроцесса()


Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
		ПередСтартомБизнесПроцесса(Отказ);
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
//ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет принудительное завершение бизнес-процесса.
//
Процедура ВыполнитьЗавершениеБизнесПроцесса(ЗавершатьВедущуюЗадачу = Истина) Экспорт

	// Пометим все задачи как выполненные.
	ЗапросЗадачи       = Новый Запрос;
	ЗапросЗадачи.УстановитьПараметр("БизнесПроцесс", Ссылка);
	ЗапросЗадачи.Текст =
	"ВЫБРАТЬ
	|	Задачи.Ссылка КАК ЗадачаПользователя
	|ИЗ
	|	Задача.ЗадачиПользователя КАК Задачи
	|ГДЕ
	|	Задачи.БизнесПроцесс = &БизнесПроцесс
	|	И Задачи.Выполнена = ЛОЖЬ";

	Выборка        = ЗапросЗадачи.Выполнить().Выбрать();
	РазмерВыборки  = Выборка.Количество();
	СчетчикВыборки = 0;

	НачатьТранзакцию();

	Пока Выборка.Следующий() Цикл

		#Если Клиент Тогда
		Состояние("Обработка:" + СчетчикВыборки + " из " + РазмерВыборки);
		#КонецЕсли

		СчетчикВыборки = СчетчикВыборки + 1;
		Попытка
	
			ЗадачаОбъект = Выборка.ЗадачаПользователя.ПолучитьОбъект();
			ЗадачаОбъект.Выполнена       = Истина;
			ЗадачаОбъект.Записать();

		Исключение

			ВызватьИсключение "Ошибка при выполнении задачи:" + Строка(Выборка.ЗадачаПользователя)
								+ Символы.ПС + "По причине: " + ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;

	ДатаЗавершения        = ТекущаяДата();
	Завершен              = Истина;
	ЗавершенПринудительно = Истина;

	Попытка

		Записать();

	Исключение

		ВызватьИсключение "Ошибка при записи бизнес-процесса:" + Строка(Ссылка)
							+ Символы.ПС + "По причине: " + ОписаниеОшибки();
	КонецПопытки;

	Если ЗначениеЗаполнено(ВедущаяЗадача) И ЗавершатьВедущуюЗадачу Тогда
		Попытка

			ЗадачаОбъект = ВедущаяЗадача.ПолучитьОбъект();
			ЗадачаОбъект.ВыполнитьЗадачу();

		Исключение
			
			ВызватьИсключение "Ошибка при выполнении задачи:" + Строка(ВедущаяЗадача)
								+ Символы.ПС + "По причине: " + ОписаниеОшибки();
		КонецПопытки;

	КонецЕсли;

	ЗафиксироватьТранзакцию();

КонецПроцедуры // ВыполнитьЗавершениеБизнесПроцесса()

////////////////////////////////////////////////////////////////////////////////
//СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Процедура устанавливает реквизиты бизнес-процесса перед завершением.
//
Процедура ОбработатьЗавершениеБизнесПроцесса()

	ДатаЗавершения = ТекущаяДата();

КонецПроцедуры // ОбработатьЗавершениеБизнесПроцесса()


// Процедура проверяет заполнение обязательных реквизитов объекта.
//
Процедура ПроверитьВозможностьСтарта(Отказ, Заголовок)

	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("УстановкаЦенНоменклатуры");
	СтруктураПолей.Вставить("Склад");
	СтруктураПолей.Вставить("Настройка");
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,
			СтруктураПолей,
			Отказ,
			Заголовок);

КонецПроцедуры // ПроверитьВозможностьСтарта()

// Процедура формирует массив задач для точки маршрута.
//
//Параметры:
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцесса.
//  ФормируемыеЗадачи           - пустой массив для задач.
//
Процедура СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
											ФормируемыеЗадачи, 
											СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	//Исполнитель = Справочники.Пользователи.ПустаяСсылка();//ПолучитьПользователяОтветственногоЗаСклад(Склад);
	//Если Исполнитель.Пустая() Тогда
		Исполнитель = ТочкаМаршрутаБизнесПроцесса.Исполнитель;
		Должность = ТочкаМаршрутаБизнесПроцесса.Должность;
		
	//КонецЕсли;
	
	ВыборкаПараметры = РаботаСБизнесПроцессами.ПолучитьПараметрыТочкиМаршрута(
						Настройка, 
						ТочкаМаршрутаБизнесПроцесса);

	Если Не ВыборкаПараметры.Следующий() Тогда
		Возврат;
	КонецЕсли;

	Если Не ВыборкаПараметры.Выполнять Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗадач = РаботаСБизнесПроцессами.СформироватьПараметрыШапкиЗадач(ВыборкаПараметры);
	ПараметрыЗадач.Вставить("ТочкаМаршрута", ТочкаМаршрутаБизнесПроцесса);
	ПараметрыЗадач.Вставить("Исполнитель",   Исполнитель);
	ПараметрыЗадач.Вставить("Должность",   Должность);
	ПараметрыЗадач.Вставить("БизнесПроцесс", Ссылка);

	ФормируемыеЗадачи.Добавить(РаботаСБизнесПроцессами.УстановитьПараметрыЗадачи(ПараметрыЗадач));

КонецПроцедуры // СформироватьЗадачиТочкиМаршрута()

////////////////////////////////////////////////////////////////////////////////
//ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ТОЧЕК МАРШРУТА
//

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА
//

// Процедура - обработчик события "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)

	Инициатор      = Справочники.Пользователи.ПустаяСсылка();
	ДатаЗавершения = Дата(1,1,1);
	ДатаСтарта     = Дата(1,1,1);
	ЗавершенПринудительно = Ложь;

КонецПроцедуры // ПриКопировании()

Процедура ВводФИОПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
		СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры

Процедура ВводЛогинаПароляПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
		СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры

Процедура ВводПользователяВКонфигуратореПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
		СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры

Процедура ЗаполнениеДанныхФизЛицаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
		СформироватьЗадачиТочкиМаршрута(ТочкаМаршрутаБизнесПроцесса,
									ФормируемыеЗадачи,
									СтандартнаяОбработка);

КонецПроцедуры


