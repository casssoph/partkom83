﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Проверка прав доступа должна располагаться самой первой
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		ВызватьИсключение НСтр("ru = 'Использование обработки в интерактивном режиме доступно только администратору.'");
	КонецЕсли;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Объект.ИмяФайлаОбмена = Параметры.ИмяФайлаОбмена;
	Объект.ИмяФайлаПравилОбмена = Параметры.ИмяФайлаПравилОбмена;
	Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = Параметры.ИмяФайлаВнешнейОбработкиОбработчиковСобытий;
	Объект.РежимОтладкиАлгоритмов = Параметры.РежимОтладкиАлгоритмов;
	Объект.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена = Параметры.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена;
	ИмяФормыРедактораТекстовогоДокумента = Параметры.ИмяОбработки + "УправляемаяФормаРедактораТекстовогоДокумента";
	
	ЗаголовокФормы = НСтр("ru = 'Настройка отладки обработчиков при %Событие% данных'");	
	Событие = ?(Параметры.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена, НСтр("ru = 'выгрузке'"), НСтр("ru = 'загрузке'"));
	ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%Событие%", Событие);
	Заголовок = ЗаголовокФормы;
	
	ЗаголовокКнопки = НСтр("ru = 'Сформировать модуль отладки %Событие%'");
	Событие = ?(Параметры.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена, НСтр("ru = 'выгрузки'"), НСтр("ru = 'загрузки'"));
	ЗаголовокКнопки = СтрЗаменить(ЗаголовокКнопки, "%Событие%", Событие);
	Элементы.ВыгрузитьКодОбработчиков.Заголовок = ЗаголовокКнопки;
	
	УстановитьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтладкаАлгоритмовПриИзменении(Элемент)
	
	ОтладкаАлгоритмовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр     = НСтр("ru = 'Файл внешней обработки обработчиков событий (*.epf)|*.epf'");
	ДиалогВыбораФайла.Расширение = "epf";
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = ДиалогВыбораФайла.ПолноеИмяФайла;
		
		ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(Элемент)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	
	СтрокаСообщения = "";
	ПроверитьПравильностьВыполненияШаговМастера(Отказ, СтрокаСообщения);
	
	Если Отказ Тогда
		Предупреждение(НСтр("ru = 'Не все необходимые шаги выполнены:'") + Символы.ПС + Символы.ПС + СтрокаСообщения); 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ИмяФайлаВнешнейОбработкиОбработчиковСобытий", Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий);
	ПараметрыЗакрытия.Вставить("РежимОтладкиАлгоритмов", Объект.РежимОтладкиАлгоритмов);
	ПараметрыЗакрытия.Вставить("ИмяФайлаПравилОбмена", Объект.ИмяФайлаПравилОбмена);
	ПараметрыЗакрытия.Вставить("ИмяФайлаОбмена", Объект.ИмяФайлаОбмена);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ПоказатьОбработчикиСобытийВОкне();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВидимость()
	
	ОтладкаАлгоритмовПриИзмененииНаСервере();
	
	//Выделение красным цветом шагов мастера, которые выполнены неправильно
	УстановитьВыделениеРамки("Группа_Шаг_4", ПустаяСтрока(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий));
	
	Элементы.ОткрытьФайл.Доступность = Не ПустаяСтрока(Объект.ИмяВременногоФайлаОбработчиковСобытий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВыделениеРамки(ИмяРамки, НадоВыделитьРамку = Ложь) 
	
	РамкаШагаМастера = Элементы[ИмяРамки];
	
	Если НадоВыделитьРамку Тогда
		
		РамкаШагаМастера.ЦветТекстаЗаголовка = ЦветаСтиля.ЦветОсобогоТекста;
		
	Иначе
		
		РамкаШагаМастера.ЦветТекстаЗаголовка = Новый Цвет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПравильностьВыполненияШаговМастера(Отказ, СтрокаСообщения)
	
	Если ПустаяСтрока(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий) Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 4, СтрокаСообщения, НСтр("ru = 'Укажите имя файла внешней обработки.'"));
		
	КонецЕсли;
	
	ФайлВнешнейОбработкиОбработчиковСобытий = Новый Файл(Объект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий);
	
	Если Не ФайлВнешнейОбработкиОбработчиковСобытий.Существует() Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 4, СтрокаСообщения, НСтр("ru = 'Указанный файл внешней обработки не существует.'"));
		
	КонецЕсли;
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщениеОбОшибке(Отказ, НомерШага, СтрокаСообщения, СообщениеОбОшибке) 
	
	//Выделяем рамку красным цветом
	УстановитьВыделениеРамки("Группа_Шаг_"+Строка(НомерШага), Истина);
	
	//Формируем сообщение об ошибке 
	СтрокаСообщения = НСтр("ru = 'Шаг №'") + Строка(НомерШага) + ": " + СообщениеОбОшибке;
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКодОбработчиков(Команда)
	
	//Возможно выгрузку уже совершали ранее...
	Если Не ПустаяСтрока(Объект.ИмяВременногоФайлаОбработчиковСобытий) Тогда
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выгрузить повторно'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Открыть модуль'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
		
		Ответ = Вопрос(НСтр("ru = 'Модуль отладки с кодом обработчиков уже выгружен.'"), СписокКнопок,,КодВозвратаДиалога.Нет);
		
		//Открываем имеющийся файл выгрузки
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			
			ПоказатьОбработчикиСобытийВОкне();
			
			Возврат;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	Отказ = Ложь;
	
	ВыгрузитьОбработчикиСобытийНаСервере(Отказ);
	
	Если Не Отказ Тогда
		
		УстановитьВидимость();
		
		ПоказатьОбработчикиСобытийВОкне();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОбработчикиСобытийВОкне()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяВременногоФайлаОбработчиковСобытий", Объект.ИмяВременногоФайлаОбработчиковСобытий);
	ПараметрыФормы.Вставить("ИмяВременногоФайлаПротоколаОбмена", Объект.ИмяВременногоФайлаПротоколаОбмена);
	
	ОткрытьФорму(ИмяФормыРедактораТекстовогоДокумента, ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьОбработчикиСобытийНаСервере(Отказ)
	
	ОбъектДляСервера = РеквизитФормыВЗначение("Объект");
	ЗаполнитьЗначенияСвойств(ОбъектДляСервера, Объект);
	ОбъектДляСервера.ВыгрузитьОбработчикиСобытий(Отказ);
	ЗначениеВРеквизитФормы(ОбъектДляСервера, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОтладкаАлгоритмовПриИзмененииНаСервере()
	
	Подсказка = Элементы.ПодсказкаОтладкаАлгоритмов;
	
	Подсказка.ТекущаяСтраница = Подсказка.ПодчиненныеЭлементы["Группа_"+Объект.РежимОтладкиАлгоритмов];
	
КонецПроцедуры