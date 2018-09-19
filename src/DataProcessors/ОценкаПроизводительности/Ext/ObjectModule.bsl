﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Функция формирует таблицу значений которая будет выведена пользователю
//
// Возвращаемое значение:
//  ТаблицаЗначений - итоговая таблица значений
//
Функция ПоказателиПроизводительности() Экспорт
	
	ПараметрыВычисления = СтруктураПараметровДляРасчетаАпдекса();
	
	ШагЧисло = 0;
	КоличествоШагов = 0;
	Если Не ПериодичностьДиаграммы(ШагЧисло, КоличествоШагов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыВычисления.ШагЧисло = ШагЧисло;
	ПараметрыВычисления.КоличествоШагов = КоличествоШагов;
	ПараметрыВычисления.ДатаНачала = ДатаНачала;
	ПараметрыВычисления.ДатаОкончания = ДатаОкончания;
	ПараметрыВычисления.ТаблицаКлючевыхОпераций = Производительность.Выгрузить(, "КлючеваяОперация, Приоритет, ЦелевоеВремя");
	КлючеваяОперацияИтого = Справочники.APDEX_КлючевыеОперации.ОбщаяПроизводительностьСистемы;
	Если КлючеваяОперацияИтого.Пустая() Или Производительность.Найти(КлючеваяОперацияИтого, "КлючеваяОперация") = Неопределено Тогда
		ПараметрыВычисления.ВыводитьИтоги = Ложь
	Иначе
		ПараметрыВычисления.ВыводитьИтоги = Истина;
	КонецЕсли;
	
	Возврат ВычислитьAPDEX(ПараметрыВычисления);
	
КонецФункции

// Функция динамически формирует запрос и получает APDEX
//
// Параметры:
//  ПараметрыВычисления - Структура, см. СтруктураПараметровДляРасчетаАпдекса()
//
// Возвращаемое значение:
//  ТаблицаЗначений - в таблице возвращается ключевая операция и 
//  показатель производительности за определенный период времени
//
Функция ВычислитьAPDEX(ПараметрыВычисления) Экспорт
	
	КлючеваяОперацияИтого = Справочники.APDEX_КлючевыеОперации.ОбщаяПроизводительностьСистемы;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаКлючевыхОпераций", ПараметрыВычисления.ТаблицаКлючевыхОпераций);
	Запрос.УстановитьПараметр("НачалоПериода", ПараметрыВычисления.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПараметрыВычисления.ДатаОкончания);
	Запрос.УстановитьПараметр("КлючеваяОперацияИтого", КлючеваяОперацияИтого);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|ПОМЕСТИТЬ КлючевыеОперации
	|ИЗ
	|	&ТаблицаКлючевыхОпераций КАК КлючевыеОперации";
	Запрос.Выполнить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя%Колонки%
	|ИЗ
	|	КлючевыеОперации КАК КлючевыеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.APDEX_ЗамерыВремени КАК ЗамерыВремени
	|		ПО КлючевыеОперации.КлючеваяОперация = ЗамерыВремени.КлючеваяОперация
	|		И ЗамерыВремени.ДатаЗамера МЕЖДУ &НачалоПериода И &КонецПериода
	|ГДЕ
	|	НЕ КлючевыеОперации.КлючеваяОперация = &КлючеваяОперацияИтого
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючевыеОперации.КлючеваяОперация,
	|	КлючевыеОперации.Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя
	|%Итоги%";
	

	Выражение = 
	"
	|	,ВЫБОР
	|		КОГДА СУММА(ВЫБОР
	|					КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|							И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|						ТОГДА 1
	|					ИНАЧЕ 0
	|				КОНЕЦ) = 0
	|			ТОГДА 0
	|		ИНАЧЕ (ВЫРАЗИТЬ((СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) + СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|													И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) / 2) / СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|									ТОГДА 1
	|								ИНАЧЕ 0
	|							КОНЕЦ) + 0.001 КАК ЧИСЛО(6, 3)))
	|	КОНЕЦ КАК Производительность%Номер%";
	
	ВыражениеДляИтогов = 
	"
	|	,СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремВсего%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремДоТ%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонецПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|								И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремМеждуТ4Т%Номер%";
	
	Итог = 
	"
	|	МАКСИМУМ(ВремВсего%Номер%)";
	
	ПоОбщие = 
	"
	|ПО
	|	ОБЩИЕ";
	
	ЗаголовкиКолонок = Новый Массив;
	Колонки = "";
	Итоги = "";
	НачалоПериода = ПараметрыВычисления.ДатаНачала;
	Для а = 0 По ПараметрыВычисления.КоличествоШагов - 1 Цикл
		
		КонецПериода = ?(а = ПараметрыВычисления.КоличествоШагов - 1, ПараметрыВычисления.ДатаОкончания, НачалоПериода + ПараметрыВычисления.ШагЧисло - 1);
		
		Запрос.УстановитьПараметр("НачалоПериода" + а, НачалоПериода);
		Запрос.УстановитьПараметр("КонецПериода" + а, КонецПериода);
		
		ЗаголовкиКолонок.Добавить(ЗаголовокКолонки(НачалоПериода));
		
		НачалоПериода = НачалоПериода + ПараметрыВычисления.ШагЧисло;
		
		Колонки = Колонки + ?(ПараметрыВычисления.ВыводитьИтоги, ВыражениеДляИтогов, "") + Выражение;
		Колонки = СтрЗаменить(Колонки, "%Номер%", а);
		
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			Итоги = Итоги + Итог + ?(а = ПараметрыВычисления.КоличествоШагов - 1, "", ",");
			Итоги = СтрЗаменить(Итоги, "%Номер%", а);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Колонки%", Колонки);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Итоги%", ?(ПараметрыВычисления.ВыводитьИтоги, "ИТОГИ" + Итоги, ""));
	ТекстЗапроса = ТекстЗапроса + ?(ПараметрыВычисления.ВыводитьИтоги, ПоОбщие, "");
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	Иначе
		ТаблицаКлючевыхОпераций = Результат.Выгрузить();
		
		ТаблицаКлючевыхОпераций.Сортировать("Приоритет");
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			ТаблицаКлючевыхОпераций[0][0] = КлючеваяОперацияИтого;
			ВычислитьИтоговыйAPDEX(ТаблицаКлючевыхОпераций);
			ТаблицаКлючевыхОпераций.Сдвинуть(0, ТаблицаКлючевыхОпераций.Количество() - 1);
		КонецЕсли;
		
		а = 0;
		ИндексМассива = 0;
		Пока а <= ТаблицаКлючевыхОпераций.Колонки.Количество() - 1 Цикл
			
			КолонкаТаблицаКлючевыхОпераций = ТаблицаКлючевыхОпераций.Колонки[а];
			Если Лев(КолонкаТаблицаКлючевыхОпераций.Имя, 4) = "Врем" Тогда
				ТаблицаКлючевыхОпераций.Колонки.Удалить(КолонкаТаблицаКлючевыхОпераций);
				Продолжить;
			КонецЕсли;
			
			Если а < 3 Тогда
				а = а + 1;
				Продолжить;
			КонецЕсли;
			КолонкаТаблицаКлючевыхОпераций.Заголовок = ЗаголовкиКолонок[ИндексМассива];
			
			ИндексМассива = ИндексМассива + 1;
			а = а + 1;
			
		КонецЦикла;
		
		Возврат ТаблицаКлючевыхОпераций;
	КонецЕсли;
	
КонецФункции

// Создает структуру параметров необходимую для расчета APDEX
//
// Возвращаемое значение:
//  Структура - 
//  	ШагЧисло - Число, указывается размер шага в секундах
//  	КоличествоШагов - Число, количество шагов в периоде
//  	ДатаНачала - Дата, дата начала замеров
//  	ДатаОкончания - Дата, дата окончания замеров
//  	ТаблицаКлючевыхОпераций - ТаблицаЗначений,
//  		КлючеваяОперация - СправочникСсылка.КлючевыеОперации, ключевая операция
//  		НомерСтроки - Число, приоритет ключевой операции
//  		ЦелевоеВремя - Число, целевое время ключевой операции
//  	ВыводитьИтоги - Булево,
//  		Истина, вычислять итоговую производительность
//  		Ложь, не вычислять итоговую производительность
//
Функция СтруктураПараметровДляРасчетаАпдекса() Экспорт
	
	Возврат Новый Структура(
		"ШагЧисло," +
		"КоличествоШагов," + 
		"ДатаНачала," + 
		"ДатаОкончания," + 
		"ТаблицаКлючевыхОпераций," + 
		"ВыводитьИтоги");
	
КонецФункции

// Вычисляет размер и количество шагов на заданном интервале
//
// Параметры:
//  ШагЧисло [OUT] - Число, количество секунд, которое надо прибавить к дате начала чтобы выполнить следующий шаг
//  КоличествоШагов [OUT] - Число, количество шагов на заданном интервале
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, параметры рассчитаны
//  	Ложь, параметры не рассчитаны
//
Функция ПериодичностьДиаграммы(ШагЧисло, КоличествоШагов) Экспорт
	
	РазницаВремени = ДатаОкончания - ДатаНачала + 1;
	
	Если РазницаВремени <= 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//КоличествоШагов - целое число, округленное вверх
	КоличествоШагов = 0;
	Если Шаг = "Час" Тогда
		ШагЧисло = 86400 / 24;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "День" Тогда
		ШагЧисло = 86400;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Неделя" Тогда
		ШагЧисло = 86400 * 7;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Месяц" Тогда
		ШагЧисло = 86400 * 30;
		Врем = КонецДня(ДатаНачала);
		Пока Врем < ДатаОкончания Цикл
			Врем = ДобавитьМесяц(Врем, 1);
			КоличествоШагов = КоличествоШагов + 1;
		КонецЦикла;
	Иначе
		ШагЧисло = 0;
		КоличествоШагов = 1;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура рассчитывает итоговое значение APDEX
//
// Параметры:
//  ТаблицаКлючевыхОпераций - ТаблицаЗначений, результат запроса рассчитавшего APDEX
//
Процедура ВычислитьИтоговыйAPDEX(ТаблицаКлючевыхОпераций)
	
	// Начинаем с 4 колонки первые 3 это КлючеваяОперация, Приоритет, ЦелевоеВремя
	ИндексНачальнойКолонки	= 3;
	ИндексСтрокиИтогов		= 0;
	ИндексКолонкиПриоритет	= 1;
	ИндексПоследнейСтроки	= ТаблицаКлючевыхОпераций.Количество() - 1;
	ИндексПоследнейКолонки	= ТаблицаКлючевыхОпераций.Колонки.Количество() - 1;
	МинимальныйПриоритет	= ТаблицаКлючевыхОпераций[ИндексПоследнейСтроки][ИндексКолонкиПриоритет];
	
	//Обнуление строки итогов
	Для Колонка = ИндексКолонкиПриоритет По ИндексПоследнейКолонки Цикл
		ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка] = 0;
	КонецЦикла;
	
	Если МинимальныйПриоритет < 1 Тогда
		Сообщить(НСтр("ru = 'Неверно заполнены приоритеты. Расчет итогового APDEX невозможен.'"));
		Возврат;
	КонецЕсли;
	
	Колонка = ИндексНачальнойКолонки;
	Пока Колонка < ИндексПоследнейКолонки Цикл
		
		МаксимальноеКоличествоОперацийЗаПериод = ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка];
		// с 1 т.к. 0 это строка итогов
		Для Строка = 1 По ИндексПоследнейСтроки Цикл
			
			ПриоритетТекущейОперации = ТаблицаКлючевыхОпераций[Строка][ИндексКолонкиПриоритет];
			КоличествоТекущейОперации = ТаблицаКлючевыхОпераций[Строка][Колонка];
			
			Коэффициент = ?(КоличествоТекущейОперации = 0, 0, 
							МаксимальноеКоличествоОперацийЗаПериод / КоличествоТекущейОперации * (1 - (ПриоритетТекущейОперации - 1) / МинимальныйПриоритет));
			
			ТаблицаКлючевыхОпераций[Строка][Колонка] = ТаблицаКлючевыхОпераций[Строка][Колонка] * Коэффициент;
			ТаблицаКлючевыхОпераций[Строка][Колонка + 1] = ТаблицаКлючевыхОпераций[Строка][Колонка + 1] * Коэффициент;
			ТаблицаКлючевыхОпераций[Строка][Колонка + 2] = ТаблицаКлючевыхОпераций[Строка][Колонка + 2] * Коэффициент;
			
		КонецЦикла;
		
		Н = ТаблицаКлючевыхОпераций.Итог(ТаблицаКлючевыхОпераций.Колонки[Колонка].Имя);
		НС = ТаблицаКлючевыхОпераций.Итог(ТаблицаКлючевыхОпераций.Колонки[Колонка + 1].Имя);
		НТ = ТаблицаКлючевыхОпераций.Итог(ТаблицаКлючевыхОпераций.Колонки[Колонка + 2].Имя);
		Если Н = 0 Тогда
			ИтоговыйAPDEX = 0;
		ИначеЕсли НС = 0 И НТ = 0 И Н <> 0 Тогда
			ИтоговыйAPDEX = 0.001;
		Иначе
			ИтоговыйAPDEX = (НС + НТ / 2) / Н;
		КонецЕсли;
		ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка + 3] = ИтоговыйAPDEX;
		
		Колонка = Колонка + 4;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаголовокКолонки(НачалоПериода)
	
	Если Шаг = "Час" Тогда
		// Страна указана для вывода лидирующего нуля чтобы было не 1:30:25, а 01:30:25
		ЗаголовокКолонки = Строка(Формат(НачалоПериода, "ДФ=dd.MM")) + Символы.ПС + Строка(Формат(НачалоПериода, "Л=ru_UA; ДЛФ=T"));
	Иначе
		ЗаголовокКолонки = Строка(Формат(НачалоПериода, "ДФ=dd.MM.yy"));
	КонецЕсли;
	
	Возврат ЗаголовокКолонки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// УСТАРЕВШИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Устарела. Следует использовать СтруктураПараметровДляРасчетаАпдекса.
//
// Создает структуру параметров необходимую для расчета APDEX
//
// Возвращаемое значение:
//  Структура - 
//  	ШагЧисло - Число, указывается размер шага в секундах
//  	КоличествоШагов - Число, количество шагов в периоде
//  	ДатаНачала - Дата, дата начала замеров
//  	ДатаОкончания - Дата, дата окончания замеров
//  	ТаблицаКлючевыхОпераций - ТаблицаЗначений,
//  		КлючеваяОперация - СправочникСсылка.КлючевыеОперации, ключевая операция
//  		НомерСтроки - Число, приоритет ключевой операции
//  		ЦелевоеВремя - Число, целевое время ключевой операции
//  	ВыводитьИтоги - Булево,
//  		Истина, вычислять итоговую производительность
//  		Ложь, не вычислять итоговую производительность
//
Функция СтруктураПараметровДляРасчётаАпдекса() Экспорт
	
	Возврат СтруктураПараметровДляРасчетаАпдекса();
	
КонецФункции

#КонецЕсли