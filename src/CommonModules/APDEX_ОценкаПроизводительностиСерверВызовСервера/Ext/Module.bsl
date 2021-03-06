﻿
///////////////////////////////////////////////////////////////////////////////
// ОСНОВНЫЕ ФУНКЦИИ

// Функция время начала замера
//
// Параметры:
//  КодКлючевойОперации - Строка, код элемента справочника "КлючевыеОперации"
//
// Возвращаемое значение:
//  Число - время начала замера
//
Функция ЗафиксироватьВремяНачала(КлючеваяОперация, ВызовССервера, Описание = "") Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗафиксироватьВремяНачала";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Если ПараметрыСеанса.APDEX_НастройкиЗамеров.APDEX_ОтключитьЗамер тогда
		Возврат Ложь;
	КонецЕсли;

	Соответствие = ПолучитьПараметрСеанса();
	
	Если Соответствие = Неопределено тогда
		Соответствие = Новый Соответствие;
	КонецЕсли;
	

	ВремяНачала = ТочноеВремя();

	Соответствие.Вставить(КлючеваяОперация, ВремяНачала);
	Если ЗначениеЗаполнено(Описание) тогда
		Соответствие.Вставить("%Описание"+КлючеваяОперация, Описание);
	КонецЕсли;
	УстановитьПараметрСеанса(Соответствие);
	
	УстановитьФлаг(Не ВызовССервера);
	
	Возврат ВремяНачала;
	
КонецФункции

Функция НомерСеансаИнформационнойБазыЛк()
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_НомерСеансаИнформационнойБазыЛк";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	Возврат 0;
КонецФункции

// Процедура фиксирует время окончания замер
//
// Возвращаемое значение:
//  Число - время окончания замера
//
Функция ЗафиксироватьВремяОкончания(КлючеваяОперация = Неопределено, ВызовИзОбработчикаОжидания, Описание = "", ТекстЗапроса = "", Ссылка = Неопределено) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗафиксироватьВремяОкончания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Если ПараметрыСеанса.APDEX_НастройкиЗамеров.APDEX_ОтключитьЗамер тогда
		Возврат Ложь;
	КонецЕсли;

	ВремяОкончания = ТочноеВремя();
	ДатаЗамера = ТекущаяДата();
	
	Соответствие = ПолучитьПараметрСеанса(Ложь);
	
	Если Соответствие = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	// Проверка, если обработчик ожидания подключен, то пользователь не должен сам завершать замер
	Если Не ВызовИзОбработчикаОжидания Тогда
		ОбработчикПодключен = Соответствие.Получить("%ОбработчикПодключен%");
		ОбработчикПодключен = ?(ОбработчикПодключен = Неопределено, Ложь, ОбработчикПодключен);
		Если ОбработчикПодключен Тогда
			Возврат 0;
		КонецЕсли;
	КонецЕсли;
	
	ВремяНачала = Неопределено;
	Если КлючеваяОперация = Неопределено Тогда // Параллельно выполняется замер только одной ключевой операции
		
		Если Соответствие.Количество() > 3 Тогда
			УстановитьПараметрСеанса(Неопределено);
            Возврат 0;
			//ВызватьИсключение "Начато несколько различных замеров.
			//				  |В таких случаях необходимо указывать какая ключевая операция завершилась.";
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из Соответствие Цикл
			
			// Чтобы не читать значение ключа %ОбработчикПодключен%
			Если ТипЗнч(КлючИЗначение.Ключ) = Тип("СправочникСсылка.APDEX_КлючевыеОперации") тогда 
			//	или Лев(""+КлючИЗначение.Ключ,10)="Метаданные" Тогда
			//Если НЕ Лев(КлючИЗначение.Ключ,1) = "%" тогда
				КлючеваяОперация = КлючИЗначение.Ключ;
				ВремяНачала = КлючИЗначение.Значение;
				Если Описание = "" тогда
					Попытка
						Описание = Соответствие["%Описание"+КлючеваяОперация];
					Исключение
					КонецПопытки;
				КонецЕсли;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ВремяНачала = Соответствие.Получить(КлючеваяОперация);
		
	КонецЕсли;
	
	Если ВремяНачала = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	
	Соответствие.Удалить(КлючеваяОперация);
	Попытка
		Соответствие.Удалить("%Описание"+КлючеваяОперация)
	Исключение
	КонецПопытки;
	УстановитьПараметрСеанса(Соответствие);
	
	Время = (ВремяОкончания - ВремяНачала - ?((ВремяОкончания - ВремяНачала) = 0,0,?(ВызовИзОбработчикаОжидания, 100*0, 0)) ) / 1000;
	Если Время < ПараметрыСеанса.APDEX_НастройкиЗамеров.APDEX_МинимальноеВремяЗамера тогда
		Возврат ВремяОкончания;
	КонецЕсли;
	
	//ДатаЗамера = ТекущаяДата();
	ТекПользователь = "";
	Попытка
		ТекПользователь = ПараметрыСеанса.ТекущийПользователь; 
	Исключение
	КонецПопытки;
	
	APDEX_СпособЗаписиЗамеров = ПараметрыСеанса.APDEX_НастройкиЗамеров.APDEX_СпособЗаписиЗамеров;
	
	НомерСеанса = НомерСеансаИнформационнойБазы();
	
	//УИДСобытия = Строка(Новый УникальныйИдентификатор);
	
	
	Если APDEX_СпособЗаписиЗамеров = 0  тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ";", "$");
		СтрокаСведений = ""+ДатаЗамера+";"+КлючеваяОперация+";"+Время+";"+Описание+";"+ТекПользователь+";"+ТекстЗапроса+";"+НомерСеанса;//+";"+УИДСобытия;
		ЗаписатьВЖурналРегистрации(СтрокаСведений);
		
	Иначе
		
		ПараметрыЗамера = Новый Структура;
		ПараметрыЗамера.Вставить("ДатаЗамера",ДатаЗамера);
		ПараметрыЗамера.Вставить("КлючеваяОперация",КлючеваяОперация);
		ПараметрыЗамера.Вставить("Информация",Описание);
		ПараметрыЗамера.Вставить("НомерСеанса",НомерСеанса);
		ПараметрыЗамера.Вставить("ВремяВыполнения",Время);
		ПараметрыЗамера.Вставить("Пользователь",ТекПользователь);
		ПараметрыЗамера.Вставить("ТекстЗапроса",ТекстЗапроса);
		//ПараметрыЗамера.Вставить("УИДСобытия",УИДСобытия);
		
		ПараметрыЗамера.Вставить("Ссылка", Ссылка);
		
		
		Если APDEX_СпособЗаписиЗамеров = 1 Тогда
			ЗаписатьЗамерВРегистр(ПараметрыЗамера);
		ИначеЕсли APDEX_СпособЗаписиЗамеров = 2 Тогда
			
			МассивПараметров = Новый Массив;
			МассивПараметров.Добавить(ПараметрыЗамера);
			
			
			ФоновыеЗадания.Выполнить("APDEX_ОценкаПроизводительностиСерверВызовСервера.ЗаписатьЗамерВРегистр",МассивПараметров,Новый УникальныйИдентификатор,"Фоновая фиксация замера APDEX");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВремяОкончания;
	
КонецФункции

Процедура ЗаписатьЗамерВРегистр(ПараметрыЗамера) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗаписатьЗамерВРегистр";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	УстановитьПривилегированныйРежим(ИСТИНА);
	
	ТекНабор = РегистрыСведений.APDEX_ЗамерыВремени.СоздатьНаборЗаписей();
	ТекНабор.Отбор.ДатаЗамера.Установить(ПараметрыЗамера.ДатаЗамера);
	ТекНабор.Отбор.КлючеваяОперация.Установить(ПараметрыЗамера.КлючеваяОперация);
	ТекНабор.Отбор.НомерСеанса.Установить(ПараметрыЗамера.НомерСеанса);
	//ТекНабор.Отбор.УИДСобытия.Установить(ПараметрыЗамера.УИДСобытия);
	
	Запись = ТекНабор.Добавить();
	Запись.ДатаЗамера = ПараметрыЗамера.ДатаЗамера;
	Запись.КлючеваяОперация = ПараметрыЗамера.КлючеваяОперация;
	Запись.Информация = ПараметрыЗамера.Информация;
	Запись.НомерСеанса = ПараметрыЗамера.НомерСеанса;
	Запись.ВремяВыполнения = ПараметрыЗамера.ВремяВыполнения;
	Запись.Пользователь = ПараметрыЗамера.Пользователь; 
	Запись.ТекстЗапроса = ПараметрыЗамера.ТекстЗапроса;
	//Запись.УИДСобытия = ПараметрыЗамера.УИДСобытия;
	Запись.Ссылка		= ПараметрыЗамера.Ссылка;
	Попытка
		ТекНабор.Записать();
	Исключение
	КонецПопытки;
	
	
	
КонецПроцедуры	

// Процедура устанавливает флаг ОбработчикПодключен
//
// Параметры:
//  Значение - Булево, значение устанавливаемого флага
//
Процедура УстановитьФлаг(ОбработчикПодключен)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_УстановитьФлаг";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Соответствие = ПолучитьПараметрСеанса();
	
	Соответствие.Вставить("%ОбработчикПодключен%", ОбработчикПодключен);
	
	УстановитьПараметрСеанса(Соответствие);
	
КонецПроцедуры

// Функция получает значение параметра сеанса ТекущийЗамерВремени
//
// Возвращаемое занчение:
//  Соответствие - параметр сеанса установлен
//  Неопределено - параметр сеанса не установлен
//
Функция ПолучитьПараметрСеанса(Создавать = Истина)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьПараметрСеанса";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Попытка
		Возврат ПараметрыСеанса.APDEX_ТекущийЗамерВремени.Получить();
	Исключение
		Если Создавать Тогда
			Возврат Новый Соответствие;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецПопытки;
	
КонецФункции

// Процедура устанавливает значение параметра сеанса ТекущийЗамерВремени
// Параметры:
//  Соответствие - Произвольный тип данных, значение которое будет помещенов в параметр сеанса ТекущийЗамерВремени
//
Процедура УстановитьПараметрСеанса(Соответствие)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_УстановитьПараметрСеанса";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	ХранилищеЗначения = Новый ХранилищеЗначения(Соответствие);
	ПараметрыСеанса.APDEX_ТекущийЗамерВремени = ХранилищеЗначения;
	
КонецПроцедуры

// Функция получает точное время
//
// Возвращаемое значение:
//  Число - время с точностью до миллисекунд
Функция ТочноеВремя()	
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ТочноеВремя";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	ВремяВСекундах=0;
	//СистемнаяИнформация = Новый СистемнаяИнформация;
	//стрВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
	//Если Число(Сред(стрВерсияПриложения, 5, 2))>=17 или Лев(стрВерсияПриложения,3) = "8.3" Тогда
		Выполнить("ВремяВСекундах=ТекущаяУниверсальнаяДатаВМиллисекундах();");
		Возврат ВремяВСекундах;
	//Иначе
	//	
	//	Попытка
	//		
	//		//1 попытка
	//		//Получение времени средствами внешней компомненты 
	//		Инструменты = ПолучитьИнструменты();
	//		Возврат ЗначениеТаймера(Инструменты);
	//		
	//	Исключение
	//		Попытка
	//			
	//			//2 попытка
	//			//Получение времени средствами джава скрипта
	//			Возврат ПолучитьВремяСПомощьюЯваСкрипт();
	//			
	//		Исключение
	//			
	//			//3 попытка
	//			//Получение времени средствами 1С
	//			Возврат ПолучитьДату();
	//			
	//		КонецПопытки;
	//	КонецПопытки;
	//КонецЕсли;
	
КонецФункции

// Процедура записывает данные в журнал регистрации
//
Процедура ЗаписатьВЖурналРегистрации(Текст)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗаписатьВЖурналРегистрации";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
 
	ЗаписьЖурналаРегистрации("Оценка производительности", 
	УровеньЖурналаРегистрации.Информация, 
	Метаданные.РегистрыСведений.APDEX_ЗамерыВремени, 
	"Оценка производительности", 
	Текст);
 
КонецПроцедуры

// Выполнить метод внешнего компонента
//
// Параметры:
//  Объект - "Addin.ETP.*", экземпляр класса внешнего компонента
//  Имя - Строка, имя выполняемого метода
//  Параметры - Структура, содержит имена и значения параметров
//
// Возвращаемое значение:
//   Произвольный - результат, возвращаемый методом
//
Функция ВыполнитьМетод(Объект, Имя, Параметры = Неопределено)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ВыполнитьМетод";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	ИменаПараметров = "";
	
	Если Параметры <> Неопределено Тогда
		Для каждого Параметр Из Параметры Цикл
			Если Не ПустаяСтрока(ИменаПараметров) Тогда
				ИменаПараметров = ИменаПараметров + ", ";
			КонецЕсли;
			
			ИменаПараметров = ИменаПараметров + "Параметры." + Параметр.Ключ;
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		Возврат Вычислить("Объект." + Имя + "(" + ИменаПараметров + ")");
	Исключение
		Если Объект <> Неопределено И Объект.ЕстьОшибка() Тогда
			ВызватьИсключение Объект.ОписаниеОшибки();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецФункции // ВыполнитьМетод()

// Получить значение таймера для замера интервала времени
//
// Параметры:
//  Инструменты - Объект внешнего компонента
//
// Возвращаемое значение:
//  Число - текущее значение таймера в миллисекундах
//
Функция ЗначениеТаймера(Инструменты)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗначениеТаймера";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Возврат ВыполнитьМетод(Инструменты, "ЗначениеТаймера");
	
КонецФункции // ЗначениеТаймера()

Функция ПолучитьОперацию(КлючеваяОперация) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьОперацию";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	Если ТипЗнч(КлючеваяОперация) = тип("СправочникСсылка.APDEX_КлючевыеОперации") тогда
		Возврат КлючеваяОперация;
	ИначеЕсли ТипЗнч(КлючеваяОперация) = Тип("Строка") тогда
		КлючеваяОперацияТекст = КлючеваяОперация;
		КлючеваяОперацияСсылка = Справочники.APDEX_КлючевыеОперации.НайтиПоНаименованию(КлючеваяОперацияТекст,Истина);
		Если НЕ ЗначениеЗаполнено(КлючеваяОперацияСсылка) тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	APDEX_КлючевыеОперации.Приоритет КАК Приоритет
			|ИЗ
			|	Справочник.APDEX_КлючевыеОперации КАК APDEX_КлючевыеОперации
			|
			|УПОРЯДОЧИТЬ ПО
			|	Приоритет УБЫВ";
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			Приоритет = 1;
			Если Выборка.Следующий() тогда
				Приоритет = Выборка.Приоритет + 1; 
			КонецЕсли;
			
			КлючеваяОперацияОбъект = Справочники.APDEX_КлючевыеОперации.СоздатьЭлемент();
			КлючеваяОперацияОбъект.Наименование = КлючеваяОперацияТекст;
			КлючеваяОперацияОбъект.ЦелевоеВремя = 5;
			КлючеваяОперацияОбъект.Приоритет = Приоритет;
			КлючеваяОперацияОбъект.Описание = "";
			КлючеваяОперацияОбъект.Записать();
			КлючеваяОперацияСсылка = КлючеваяОперацияОбъект.Ссылка;
		КонецЕсли;
		Возврат КлючеваяОперацияСсылка;
	Иначе 
		Попытка
			КлючеваяОперацияТекст = ""+КлючеваяОперация.Метаданные();
			КлючеваяОперацияСсылка = Справочники.APDEX_КлючевыеОперации.НайтиПоНаименованию(КлючеваяОперацияТекст,Истина);
			Если НЕ ЗначениеЗаполнено(КлючеваяОперацияСсылка) тогда
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
				|	APDEX_КлючевыеОперации.Приоритет КАК Приоритет
				|ИЗ
				|	Справочник.APDEX_КлючевыеОперации КАК APDEX_КлючевыеОперации
				|
				|УПОРЯДОЧИТЬ ПО
				|	Приоритет УБЫВ";
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				
				Приоритет = 1;
				Если Выборка.Следующий() тогда
					Приоритет = Выборка.Приоритет + 1; 
				КонецЕсли;
				
				КлючеваяОперацияОбъект = Справочники.APDEX_КлючевыеОперации.СоздатьЭлемент();
				КлючеваяОперацияОбъект.Наименование = КлючеваяОперацияТекст;
				КлючеваяОперацияОбъект.ЦелевоеВремя = 5;
				КлючеваяОперацияОбъект.Приоритет = Приоритет;
				КлючеваяОперацияОбъект.Описание = КлючеваяОперация.Метаданные().Синоним;
				КлючеваяОперацияОбъект.Записать();
				КлючеваяОперацияСсылка = КлючеваяОперацияОбъект.Ссылка;
			КонецЕсли;
			Возврат КлючеваяОперацияСсылка;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Возврат КлючеваяОперация;
	
КонецФункции

Функция РазложитьСтрокуВМассив(Знач Стр, Разделитель = ",") Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_РазложитьСтрокуВМассив";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция  ПолучитьПодключениеКБазе(СтруктураПараметров) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьПодключениеКБазе";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецФункции	

Функция ПолучитьОпределениеВебСервиса(СтруктураПараметров)
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьОпределениеВебСервиса";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецФункции // ()
 
Функция ПолучитьТаблицуМаршрутовССайта(ИмяСервиса) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьТаблицуМаршрутовССайта";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	СтрокаМаршрута = НЕОПРЕДЕЛЕНО;
	
	Сервер = "www.gilev.ru";			
	Соединение = Новый HTTPСоединение(Сервер);			
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("host", Сервер);   		
	Запрос = Новый HTTPЗапрос("/host_services/", Заголовки);
	Ответ =Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда // Данные получены, обрабатываем их
		
		ТекстСтраницы= Ответ.ПолучитьТелоКакСтроку();
		
		ЧтениеHTML=Новый ЧтениеHTML;
		ЧтениеHTML.УстановитьСтроку(ТекстСтраницы,"UTF-8");
		
		ПостроительDOM=Новый ПостроительDOM;
		
		ДокументПостроитель=ПостроительDOM.Прочитать(ЧтениеHTML);
		
		
		ТЗМаршрутов = Новый ТаблицаЗначений;
		ТЗМаршрутов.Колонки.Добавить("ИмяСервиса");
		ТЗМаршрутов.Колонки.Добавить("ОсновнойСервис");
		ТЗМаршрутов.Колонки.Добавить("ОсновнойСервисIP");
		ТЗМаршрутов.Колонки.Добавить("РезервныйСервис");
		ТЗМаршрутов.Колонки.Добавить("РезервныйСервисIP");

		ПолучитьТаблицуМаршрутовСервисовИзHTML(ТЗМаршрутов,ДокументПостроитель, ИмяСервиса);
		
		СтрокаМаршрута =  ТЗМаршрутов.Найти(ИмяСервиса,"ИмяСервиса");
		
		
	КонецЕсли;    
	
	Возврат  СтрокаМаршрута;
	
КонецФункции // ()

Процедура ЗаполнитьТЗМаршрутов(ТЗМаршрутов,ЭлементСтрокиТаблицы, ИмяСервиса="APDEX") 
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗаполнитьТЗМаршрутов";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры

Процедура ЗаполнитьТЗМаршрутов_стар(ТЗМаршрутов,ЭлементСтрокиТаблицы, ИмяСервиса="APDEX") 
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ЗаполнитьТЗМаршрутов_стар";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры

Процедура ПолучитьТаблицуМаршрутовСервисовИзHTML(ТЗМаршрутов,ДокументПостроитель, ИмяСервиса="APDEX")
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьТаблицуМаршрутовСервисовИзHTML";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
// ВЫГРУЗКА ДАННЫХ APDEX
//
Процедура ВыгрузитьAPDEX() Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ВыгрузитьAPDEX";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры

Процедура СформироватьФайлыПочтовыхВложений(ТаблицаЗамеров,ИдентификаторБазы)  
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_СформироватьФайлыПочтовыхВложений";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры	

Функция ПолучитьПрофильИнтернетПочтовоеПодключения(УчетнаяЗапись) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьПрофильИнтернетПочтовоеПодключения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	

	Профиль = Новый ИнтернетПочтовыйПрофиль;
	
	Профиль.АдресСервераPOP3 = УчетнаяЗапись.POP3Сервер;
	Профиль.АдресСервераSMTP = УчетнаяЗапись.SMTPСервер;
	Если УчетнаяЗапись.ВремяОжиданияСервера > 0 Тогда
		Профиль.ВремяОжидания = УчетнаяЗапись.ВремяОжиданияСервера;
	КонецЕсли; 
	Профиль.Пароль           = УчетнаяЗапись.Пароль;
	Профиль.Пользователь     = УчетнаяЗапись.Логин;
	Профиль.ПортPOP3         = УчетнаяЗапись.ПортPOP3;
	//Профиль.ИспользоватьSSLPOP3 = УчетнаяЗапись.ИспользоватьSSLPOP3;
	//Профиль.ИспользоватьSSLSMTP = УчетнаяЗапись.ИспользоватьSSLSMTP;
	//Профиль.ИспользоватьSSLIMAP = Истина;
	Профиль.ПортSMTP         = УчетнаяЗапись.ПортSMTP;
	
	Если УчетнаяЗапись.ТребуетсяSMTPАутентификация Тогда
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;  
		Профиль.ПарольSMTP       = УчетнаяЗапись.ПарольSMTP;
		Профиль.ПользовательSMTP = УчетнаяЗапись.ЛогинSMTP;                 		
	Иначе
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		Профиль.ПарольSMTP       = "";
		Профиль.ПользовательSMTP = "";
	КонецЕсли; 
	
	Возврат Профиль;

КонецФункции 

Процедура  ОтправитьПочтовоеСообщение(УчетнаяЗаписьОтправителя,АдресЭлектроннойПочты,ИмяФайла) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ОтправитьПочтовоеСообщение";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецПроцедуры	

Функция ПроверкаВебСервиса() Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПроверкаВебСервиса";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
КонецФункции

Функция ПолучитьНастройки() Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_ПолучитьНастройки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	СтруктураПараметров = Новый Структура;

	
	НаборЗаписей = РегистрыСведений.APDEX_Настройки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Измерение.Установить(0);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		НаборЗаписей.Добавить();
	КонецЕсли; 
	
	ТЗНастроек = НаборЗаписей.Выгрузить();
	СтрокаТЗ = ТЗНастроек[0];
	
	КолекцияКолонок = ТЗНастроек.Колонки;
	
	Для каждого Колонка из КолекцияКолонок Цикл
		ИмяКолонки = Колонка.Имя;
		СтруктураПараметров.Вставить(ИмяКолонки,СтрокаТЗ[ИмяКолонки]);
	КонецЦикла;	
	
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция УстановитьНастройки(Запись) Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_УстановитьНастройки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	
	НЗ = РегистрыСведений.APDEX_Настройки.СоздатьНаборЗаписей();
	НЗ.Отбор.Измерение.Установить(0);
	Запись2 = НЗ.Добавить();
	ЗаполнитьЗначенияСвойств(Запись2, Запись);
	НЗ.Записать();
КонецФункции

Процедура APDEX_УдалениеСтарыхДанных() Экспорт
	лКлючАлгоритма = "ОбщийМодуль_APDEX_ОценкаПроизводительностиСерверВызовСервера_APDEX_УдалениеСтарыхДанных";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////	
	  	
	APDEX_Настройки = APDEX_ОценкаПроизводительностиСерверВызовСервера.ПолучитьНастройки();
	
	ПорогЗаписей = ?(APDEX_Настройки.APDEX_ПорогДляСтарыхДанных = 0, 2000000,APDEX_Настройки.APDEX_ПорогДляСтарыхДанных);
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(APDEX_ЗамерыВремени.ДатаЗамера) КАК КоличествоЗаписей
	|ИЗ
	|	РегистрСведений.APDEX_ЗамерыВремени КАК APDEX_ЗамерыВремени";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	
	Если Выборка.Следующий() Тогда
		
		Если  Выборка.КоличествоЗаписей > ПорогЗаписей Тогда
			Запрос.УстановитьПараметр("ТекущийПериод",НачалоДня(ТекущаяДата())-86400); //оставляем предыдущий день
			Запрос.Текст = "ВЫБРАТЬ
			|	APDEX_ЗамерыВремени.ДатаЗамера КАК ДатаЗамера,
			|	КОЛИЧЕСТВО(APDEX_ЗамерыВремени.НомерСеанса) КАК КоличествоЗаписей
			|ИЗ
			|	РегистрСведений.APDEX_ЗамерыВремени КАК APDEX_ЗамерыВремени
			|ГДЕ
			|	APDEX_ЗамерыВремени.ДатаЗамера < &ТекущийПериод
			|
			|СГРУППИРОВАТЬ ПО
			|	APDEX_ЗамерыВремени.ДатаЗамера,
			|	APDEX_ЗамерыВремени.КлючеваяОперация,
			|	APDEX_ЗамерыВремени.НомерСеанса
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаЗамера УБЫВ";
			
			
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				
				Если ПорогЗаписей >= Выборка.КоличествоЗаписей Тогда
					ПорогЗаписей = ПорогЗаписей - Выборка.КоличествоЗаписей;
					продолжить;
				Иначе
					ПорогЗаписей = 0;
				КонецЕсли;
				
				Набор = РегистрыСведений.APDEX_ЗамерыВремени.СоздатьНаборЗаписей();
				Набор.Отбор.ДатаЗамера.Установить(Выборка.ДатаЗамера);
				Попытка
					Набор.Записать();
				Исключение
				КонецПопытки;
				
				
			КонецЦикла; 
			
			
			
		КонецЕсли; 
		
	КонецЕсли; 
КонецПроцедуры
 
	
	
 
