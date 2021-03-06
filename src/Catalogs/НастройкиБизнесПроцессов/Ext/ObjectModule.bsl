﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция возвращает строковое имя бизнес процесса по значению реквизита "ВидБизнесПроцесса"
//
Функция ПолучитьСтроковоеИмябизнесПроцесса(лВидБизнесПроцесса = Неопределено) Экспорт

	Возврат ВидБизнесПроцесса.Метаданные().ЗначенияПеречисления[Перечисления.ВидыБизнесПроцессов.Индекс(?(лВидБизнесПроцесса = Неопределено, ВидБизнесПроцесса, лВидБизнесПроцесса))].Имя;

КонецФункции // ПолучитьСтроковоеИмябизнесПроесса()

////////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура проверяет корректность заполнения настройки для бизнес-процесса
// СогласованияЗаказаПокупателя.
//
// Параметры:
//  Отказ - булево, признак отказа от записи.
//  Заголовок - строка, заголовок сообщения.
//
Процедура ПроверитьКорректностьЗаполненияДляСогласованияЗаказа(Отказ, Заголовок)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Точки.ТочкаМаршрута КАК ТочкаМаршрута,
	|	Исполнители.Исполнитель КАК Исполнитель,
	|	Точки.Выполнять КАК Выполнять
	|ИЗ
	|	Справочник.НастройкиБизнесПроцессов.ПараметрыТочекМаршрута КАК Точки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиБизнесПроцессов.Исполнители КАК Исполнители
	|		ПО Точки.Ссылка = Исполнители.Ссылка
	|			И Точки.ТочкаМаршрута = Исполнители.ТочкаМаршрута
	|ГДЕ
	|	Точки.Ссылка      = &Ссылка
	|	И Точки.Выполнять = Истина");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл

		Если Не Выборка.Выполнять Тогда
			Продолжить;
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Выборка.Исполнитель) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Точка маршрута """ + Выборка.ТочкаМаршрута+ " "" не имеет исполнителей", Отказ , Заголовок);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьКорректностьЗаполненияДляСогласованияЗаказа()

// Процедура проверяет корректность заполнения настройки для бизнес-процесса
// ПереоценкаТоваровРозница.
//
// Параметры:
//  Отказ - булево, признак отказа от записи.
//  Заголовок - строка, заголовок сообщения.
//
Процедура ПроверитьКорректностьЗаполненияДляПереоценкиТоваровРозница(Отказ, Заголовок)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Параметры.ТочкаМаршрута КАК ТочкаМаршрута,
	|	Параметры.Настройка КАК Настройка,
	|	Параметры.Выполнять КАК Выполнять
	|ИЗ
	|	Справочник.НастройкиБизнесПроцессов.ПараметрыТочекМаршрута КАК Параметры
	|ГДЕ
	|	Параметры.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если Не Выборка.Выполнять Тогда
			Продолжить;
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Выборка.Настройка) И 
			Выборка.ТочкаМаршрута.Вид = ВидТочкиМаршрутаБизнесПроцесса.ВложенныйБизнесПроцесс Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Для точки маршрута """ + Выборка.ТочкаМаршрута + """ не заполнен реквизит ""Настройка""", Отказ, Заголовок);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьКорректностьЗаполненияДляПереоценкиТоваровРозница()

// Процедура проверяет наличие ссылок в бизнес-процессах на настройку.
//
// Параметры:
//  ВидБизнесПроцесса - ПеречислениеСсылка.ВидыБизнесПроцессов.
//  Отказ - булево, признак отказа от записи.
//  Заголовок - строка, заголовок сообщения.
//
Процедура ПроверитьНаличиеСсылокНаНастройку(ВидБизнесПроцесса, Отказ, Заголовок)

	ТаблицаБизнесПроцесса = ПолучитьСтроковоеИмябизнесПроцесса(ВидБизнесПроцесса);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаДанных.Ссылка
	|ИЗ
	|	БизнесПроцесс." + ТаблицаБизнесПроцесса + " КАК ТаблицаДанных
	|ГДЕ
	|	ТаблицаДанных.Настройка = &Настройка");

	Запрос.УстановитьПараметр("Настройка" , Ссылка);

	Если Не Запрос.Выполнить().Пустой() Тогда

		ОбщегоНазначения.СообщитьОбОшибке("Существуют бизнес-процессы по данной настройке.
		|Вид бизнес-процесса не может быть изменен!", Отказ, Заголовок);

	КонецЕсли;
	
КонецПроцедуры // ПроверитьНаличиеСсылокНаНастройку()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПриЗаписи" объекта.
//
Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	Заголовок = "Запись элемента: " + ЭтотОбъект;

	Если ВидБизнесПроцесса = Перечисления.ВидыБизнесПроцессов.СогласованиеЗаказаПокупателя Тогда

		ПроверитьКорректностьЗаполненияДляСогласованияЗаказа(Отказ, Заголовок);

	ИначеЕсли ВидБизнесПроцесса = Перечисления.ВидыБизнесПроцессов.ПереоценкаТоваровРозница Тогда

		ПроверитьКорректностьЗаполненияДляПереоценкиТоваровРозница(Отказ, Заголовок);

	КонецЕсли;

КонецПроцедуры // ПриЗаписи()

// Процедура - обработчик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	Заголовок = "Запись элемента: " + ЭтотОбъект;

	Если Не ЗначениеЗаполнено(ВидБизнесПроцесса) Тогда

		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Вид бизнес-процесса""", Отказ , Заголовок);

	КонецЕсли;

	Если Не ЭтоНовый() Тогда

		Если ВидБизнесПроцесса <> Ссылка.ВидБизнесПроцесса Тогда

			ПроверитьНаличиеСсылокНаНастройку(Ссылка.ВидБизнесПроцесса, Отказ, Заголовок);

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()
