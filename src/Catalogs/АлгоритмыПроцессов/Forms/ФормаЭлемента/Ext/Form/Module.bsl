﻿
&НаКлиенте
Процедура УсловиеПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры


&НаКлиенте
Процедура НастроитьЭлементыФормы()
	
	Элементы.ГруппаСообщениеПриНевыполнении.Видимость = Объект.Условие;
	Элементы.ДекорацияПодсказка.Заголовок = ТекстПодсказки();
	
КонецПроцедуры

&НаКлиенте
Функция ТекстПодсказки()
	
	ТекстПодсказки = "Для алгоритмов выполняющихся на сервере доступен объект документа Акт рассмотрения возврата (""ДокументОбъект"").
	|
	|Для алгоритмов, выполняющихся на клиенте доступна форма документа (""пФорма"").
	|	
	|Локальные именованные константы доступны с помощью обращения лИК[""ИмяКонстанты""]
	|	
	|Именованные константы процесса доступны с помощью обращения ИК[""ИмяКонстанты""]
	|
	|Для условия должно быть установлено значение переменной ""Результат""
	|
	|Если условие не выполнено, пояснение можно поместить в переменную ""СообщениеПриНевыполнении"", либо задать на отдельной вкладке
	|
	|Дополнительный комментарий о результате выполнения можно поместить в переменную ""ДопТекстСобытия""
	|
	|Чтобы не записывать комментарий о результате выполнения команды, необходимо установить значение переменной	НеФиксироватьСобытиеВыполненияКоманды = Истина;
	|";
	
	Возврат ТекстПодсказки;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьЭлементыФормы();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользованиеВКомандах.Параметры.УстановитьЗначениеПараметра("Алгоритм", Объект.Ссылка);
	ИспользованиеВоВзаимосвязях.Параметры.УстановитьЗначениеПараметра("Алгоритм", Объект.Ссылка);
	ИспользованиеВСтатусах.Параметры.УстановитьЗначениеПараметра("Алгоритм", Объект.Ссылка);
	
	ИнициализироватьПараметрыФорматированияТекста();
	
	ВстроенныйЯзык.Добавить(Объект.Алгоритм);
	
	ОбновитьФорматированиеНаСервере(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеВКомандахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеВоВзаимосвязяхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеВСтатусахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьФорматирование(Команда)
	
	// Получить выделенный диапазон
	ЗакладкаНачалаВыделения = 0;
	ЗакладкаКонцаВыделения = 0;
	Элементы.Алгоритм.ПолучитьГраницыВыделения(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения);
	ПозицияНачалаВыделения = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаНачалаВыделения);
	
	Если УстановитьКорректныеГраницыВыделения(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения) Тогда
		
		// Расскрасить выделенную область
		ОбновитьФорматированиеНаСервере();
		
		// Снять выделение
		ЗакладкаНачалаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуПоПозиции(ПозицияНачалаВыделения);
		Элементы.Алгоритм.УстановитьГраницыВыделения(ЗакладкаНачалаВыделения, ЗакладкаНачалаВыделения);
		
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОбновитьФорматированиеПолное(Команда)
	
	// Расскрасить выделенную область
	ОбновитьФорматированиеНаСервере(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьПараметрыФорматированияТекста()

	ПараметрыФорматированияТекста = Новый Структура;
	
	// Цвета
	ПараметрыФорматированияТекста.Вставить("Цвета", Новый Структура);	
	ПараметрыФорматированияТекста.Цвета.Вставить("Красный", Новый Цвет(255, 0, 0));
	ПараметрыФорматированияТекста.Цвета.Вставить("Зеленый", Новый Цвет(0, 128, 0));
	ПараметрыФорматированияТекста.Цвета.Вставить("Синий", Новый Цвет(0, 0, 255));
	ПараметрыФорматированияТекста.Цвета.Вставить("Черный",  Новый Цвет(0, 0, 1));
	ПараметрыФорматированияТекста.Цвета.Вставить("Коричневый", Новый Цвет(150, 50, 0));
	
	// Шрифты
	ПараметрыФорматированияТекста.Вставить("Шрифты", Новый Структура);
	ПараметрыФорматированияТекста.Шрифты.Вставить("ШрифтОшибки",
		Новый Шрифт(Элементы.Алгоритм.Шрифт, , , Истина));
	
	// Массив ключевых (зарезервированных) слов встроенного языка 1С
	ПараметрыФорматированияТекста.Вставить("КлючевыеСлова", Новый Массив);
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("if");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("если");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("then");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("тогда");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("elsif");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("иначеесли");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("else");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("иначе");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("endif");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("конецесли");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("do");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("цикл");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("for");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("для");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("to");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("по");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("each");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("каждого");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("in");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("из");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("while");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("пока");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("endDo");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("конеццикла");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("procedure");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("процедура");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("endprocedure");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("конецпроцедуры");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("function");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("функция");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("endfunction");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("конецфункции");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("var");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("перем");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("export");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("экспорт");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("goto");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("перейти");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("and");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("и");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("or");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("или");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("not");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("не");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("val");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("знач");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("break");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("прервать");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("continue");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("продолжить");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("return");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("возврат");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("try");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("попытка");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("except");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("исключение");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("endtry");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("конецпопытки");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("raise");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("вызватьисключение");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("false");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("ложь");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("true");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("истина");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("undefined");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("неопределено");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("null");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("new");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("новый");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("execute");
	ПараметрыФорматированияТекста.КлючевыеСлова.Добавить("выполнить");
	
	//
	ПараметрыФорматированияТекста.Вставить("ПозицияНачалаВыделения", Неопределено);
	ПараметрыФорматированияТекста.Вставить("ПозицияКонцаВыделения", Неопределено);
	
КонецПроцедуры
 
&НаКлиенте
Функция УстановитьКорректныеГраницыВыделения(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения)

	ВсеЭлементы = ВстроенныйЯзык.ПолучитьЭлементы();
	
	ВыделенныеЭлементы = ВстроенныйЯзык.ПолучитьЭлементы(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения);
	Если ВыделенныеЭлементы.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Выделите строку целиком'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли; 	
	
	// Установить закладку начала выделения в начало строки
	Ин = ВсеЭлементы.Найти(ВыделенныеЭлементы[0]);
	Ин = Ин - 1;
	Пока Ин >= 0 Цикл
		Если ТипЗнч(ВсеЭлементы[Ин]) = Тип("ПереводСтрокиФорматированногоДокумента") Тогда
			ЗакладкаНачалаВыделения = ВсеЭлементы[Ин].ЗакладкаНачала;
			ПозицияНачалаВыделения = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаНачалаВыделения);
			Прервать;
		КонецЕсли; 		
		Ин = Ин - 1;
	КонецЦикла; 
	Если Ин < 0 Тогда
		ЗакладкаНачалаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуНачала();
		ПозицияНачалаВыделения = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаНачалаВыделения);
	КонецЕсли; 
	
	// Установить закладку конца выделения в конец строки
	Ин = ВсеЭлементы.Найти(ВыделенныеЭлементы[ВыделенныеЭлементы.Количество() - 1]);
	Ин = Ин + 1;
	ВсегоЭлементов = ВсеЭлементы.Количество();
	Пока Ин < ВсегоЭлементов Цикл
		Если ТипЗнч(ВсеЭлементы[Ин]) = Тип("ПереводСтрокиФорматированногоДокумента") Тогда
			ЗакладкаКонцаВыделения = ВсеЭлементы[Ин].ЗакладкаНачала;
			// тут нужно "-1", чтобы при форматировании выделенного диапазона не удалился перенос строки
			ПозицияКонцаВыделения = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаКонцаВыделения) - 1;
			Прервать;
		КонецЕсли; 		
		Ин = Ин + 1;
	КонецЦикла; 
	Если Ин >= ВсегоЭлементов Тогда
		ЗакладкаКонцаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуКонца();
		ПозицияКонцаВыделения = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаКонцаВыделения);
	КонецЕсли; 
	
	// Установить новое выделение
	Элементы.Алгоритм.УстановитьГраницыВыделения(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения);
	
	// Поместить позиции выделения в параметры, чтобы использовать их же на сервере
	ПараметрыФорматированияТекста.ПозицияНачалаВыделения = ПозицияНачалаВыделения;
	ПараметрыФорматированияТекста.ПозицияКонцаВыделения = ПозицияКонцаВыделения;
	
	Возврат Истина;
	
КонецФункции
 
&НаСервере
Процедура ОбновитьФорматированиеНаСервере(ИспользоватьВыделенныйФрагмент = Истина)

	Если ИспользоватьВыделенныйФрагмент Тогда
		// Получить выделенный диапазон строк
		ЗакладкаНачалаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуПоПозиции(
			ПараметрыФорматированияТекста.ПозицияНачалаВыделения);
		ЗакладкаКонцаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуПоПозиции(
			ПараметрыФорматированияТекста.ПозицияКонцаВыделения);
		
		// Получить исходные данные
		ИсходныйТекст = ВстроенныйЯзык.ПолучитьТекст(ЗакладкаНачалаВыделения, ЗакладкаКонцаВыделения);
		ИсходнаяПозицияНачала = ПараметрыФорматированияТекста.ПозицияНачалаВыделения;
		ИсходнаяПозицияКонца = ПараметрыФорматированияТекста.ПозицияКонцаВыделения;
		
	Иначе
		// Обработка всего документа
		ЗакладкаНачалаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуНачала();
		ЗакладкаКонцаВыделения = ВстроенныйЯзык.ПолучитьЗакладкуКонца();
		
		// Получить исходные данные
		ИсходныйТекст = ВстроенныйЯзык.ПолучитьТекст();
		ИсходнаяПозицияНачала = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаНачалаВыделения);
		ИсходнаяПозицияКонца = ВстроенныйЯзык.ПолучитьПозициюПоЗакладке(ЗакладкаКонцаВыделения);
		
	КонецЕсли;
	
	// Инициализация переменных для цикла
	Закладка = ЗакладкаКонцаВыделения;
	ЕстьОшибки = Ложь;
	КоличествоСтрокИсходногоТекста = СтрЧислоСтрок(ИсходныйТекст);	
	НовыеЭлементы = Новый Массив;
	
	// << Цикл построчно по тексту
	Для Ин = 1 По КоличествоСтрокИсходногоТекста Цикл
		
		// Очередная строка текста
		Строка = СтрПолучитьСтроку(ИсходныйТекст, Ин);
		
		// Создать элементы теста и раскрасить
		Успешно = СоздатьЭлементыФорматированногоДокумента(Закладка, Строка, НовыеЭлементы);
		Если НЕ Успешно Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обнаружены ошибки при форматировании строки ""%1""'"),
				Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , ЕстьОшибки);
			
		КонецЕсли; 
		
		// Создать элемент перевода строки
		Если Ин < КоличествоСтрокИсходногоТекста Тогда			
			НовыйЭлемент = ВстроенныйЯзык.Вставить(Закладка, , Тип("ПереводСтрокиФорматированногоДокумента"));
			Закладка = НовыйЭлемент.ЗакладкаКонца;
			НовыеЭлементы.Добавить(НовыйЭлемент);
			
		КонецЕсли; 
				
	КонецЦикла;
	// >> Цикл построчно по тексту
	
	// Проверить правильность разложения текста на элементы форматированного документа
	Если ЕстьОшибки Тогда
		// Удалить созданные элементы
		Для каждого Элемент Из НовыеЭлементы Цикл
			ВстроенныйЯзык.Элементы.Удалить(Элемент);
		КонецЦикла; 
		
	Иначе
		// Удалить исходный элемент параграфа 	
		ИсходнаяЗакладкаНачала = ВстроенныйЯзык.ПолучитьЗакладкуПоПозиции(ИсходнаяПозицияНачала);
		ИсходнаяЗакладкаКонца = ВстроенныйЯзык.ПолучитьЗакладкуПоПозиции(ИсходнаяПозицияКонца);
		Скрипт = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВстроенныйЯзык.Удалить(%1, %2);",
				?(ИсходнаяПозицияНачала = 0, "", "ИсходнаяЗакладкаНачала"),
				?(ИсходнаяПозицияКонца = 0, "", "ИсходнаяЗакладкаКонца"));
		Выполнить Скрипт;
		
	КонецЕсли; 
		
КонецПроцедуры
 
&НаСервере
Функция СоздатьЭлементыФорматированногоДокумента(Закладка, Текст, НовыеЭлементы)

	// Инициализация переменных для цикла
	ТекстСокрЛП = СокрЛП(Текст);
	ТекстСокрЛПЛев1 = Лев(ТекстСокрЛП, 1);	
	ТекстРазложенныхЭлементов = "";
	
	Если ТекстСокрЛПЛев1 = "&" ИЛИ ТекстСокрЛПЛев1 = "#" Тогда		
		// Создать элемент форматированного документа
		НовыйЭлемент = ВстроенныйЯзык.Вставить(Закладка, Текст, Тип("ТекстФорматированногоДокумента"));
		Закладка = НовыйЭлемент.ЗакладкаКонца;
		НовыеЭлементы.Добавить(НовыйЭлемент);
		
		// Вся строка коричневая
		НовыйЭлемент.ЦветТекста = ПараметрыФорматированияТекста.Цвета.Коричневый;			
		ТекстРазложенныхЭлементов = Текст;
		
	ИначеЕсли Лев(ТекстСокрЛП, 2) = "//" Тогда		
		// Создать элемент форматированного документа
		НовыйЭлемент = ВстроенныйЯзык.Вставить(Закладка, Текст, Тип("ТекстФорматированногоДокумента"));
		Закладка = НовыйЭлемент.ЗакладкаКонца;
		НовыеЭлементы.Добавить(НовыйЭлемент);
		
		// Вся строка зеленая
		НовыйЭлемент.ЦветТекста = ПараметрыФорматированияТекста.Цвета.Зеленый;
		
		ТекстРазложенныхЭлементов = Текст;
		
	Иначе
		
		// Разложить текст на слова
		МассивСлов = РазложитьТекстНаСлова(Текст);
		
		// << Цикл по массиву слов
		ПредыдущееСлово = Неопределено;
		Для каждого Слово Из МассивСлов Цикл
			
			// Создать элемент форматированного документа
			НовыйЭлемент = ВстроенныйЯзык.Вставить(Закладка, Слово, Тип("ТекстФорматированногоДокумента"));
			Закладка = НовыйЭлемент.ЗакладкаКонца;
			НовыеЭлементы.Добавить(НовыйЭлемент);
			
			// Установить цвет текста
			ЭтоНазваниеМетодаИлиСвойства = (ПредыдущееСлово = ".");
			НовыйЭлемент.ЦветТекста = УстановитьЦветТекста(Слово, ЭтоНазваниеМетодаИлиСвойства);
			
			ТекстРазложенныхЭлементов = ТекстРазложенныхЭлементов + Слово;
			ПредыдущееСлово = Слово;
			
		КонецЦикла;
		// >> Цикл по массиву слов
		
	КонецЕсли;	

	Возврат (Текст = ТекстРазложенныхЭлементов);
	
КонецФункции
 
#КонецОбласти

#Область Прочее

&НаСервере
Функция УстановитьЦветТекста(Слово, ЭтоНазваниеМетодаИлиСвойства)

	Цвет = ПараметрыФорматированияТекста.Цвета.Синий;
	
	СловоСокрЛП = СокрЛП(Слово);
	СловоНРегСокрЛП = НРег(СловоСокрЛП);
	СловоСокрЛПЛев1 = Лев(СловоСокрЛП, 1);
	СловоСокрЛПЛев2 = Лев(СловоСокрЛП, 2);
	
	Если СтрДлина(СловоНРегСокрЛП) = 1 Тогда // один символ					
		Если Найти("и;+-/*=.,<>?()", СловоНРегСокрЛП) > 0 Тогда
			Цвет = ПараметрыФорматированияТекста.Цвета.Красный;
		ИначеЕсли Найти("[]{}1234567890!@#$^&""№!|\'~", СловоНРегСокрЛП) > 0 Тогда
			Цвет = ПараметрыФорматированияТекста.Цвета.Черный;
		КонецЕсли;
		
	ИначеЕсли СловоСокрЛПЛев2 = "//" Тогда
		Цвет = ПараметрыФорматированияТекста.Цвета.Зеленый;
		
	ИначеЕсли СловоСокрЛПЛев1 = """" ИЛИ СловоСокрЛПЛев1 = "|" Тогда
		Цвет = ПараметрыФорматированияТекста.Цвета.Черный;
		
	ИначеЕсли НЕ ЭтоНазваниеМетодаИлиСвойства И ПараметрыФорматированияТекста.КлючевыеСлова.Найти(СловоНРегСокрЛП) <> Неопределено Тогда
		Цвет = ПараметрыФорматированияТекста.Цвета.Красный;				
		
	КонецЕсли;

	Возврат Цвет;
	
КонецФункции
 
&НаСервере
Функция РазложитьТекстНаСлова(Текст)
	
	Слова = Новый Массив;
	
	// Инициализация переменых для цикла
	НачалоСлова = 1;
	НомерСлова = 0;
	ДелитьСтроку = Истина;
	СимволКавычка = """";
	СимволПалка = "|";
	СимволСлеш = "/";
	РазмерТекста = СтрДлина(Текст);
	НомерЗначащегоСимволаВСтроке = 0; // не пробел
	НезначащиеСимволы = " " + " " + Символы.ВК + Символы.ВТаб + Символы.НПП + Символы.ПС + Символы.ПФ + Символы.Таб;
	
	// << Цикл по символам текста
	Для Позиция = 1 По РазмерТекста Цикл
				
		// Очередной символ		
		Символ = Сред(Текст, Позиция, 1);
		// Следующий символ
		СледСимвол = ?(Позиция = РазмерТекста, Неопределено, Сред(Текст, Позиция + 1, 1));
		//
		НомерЗначащегоСимволаВСтроке = НомерЗначащегоСимволаВСтроке + ?(Найти(НезначащиеСимволы, Символ) > 0, 0, 1);
		
		Если ДелитьСтроку И (Символ = СимволКавычка ИЛИ (Символ = СимволПалка И НомерЗначащегоСимволаВСтроке = 1)) Тогда
			// первая " или | строкового литерала
			ДелитьСтроку = Ложь;
			ЭтоЗакрывающаяКавычка = Ложь;
			
		ИначеЕсли ДелитьСтроку И Символ = СимволСлеш И СледСимвол = СимволСлеш Тогда
			Слова.Добавить(Прав(Текст, СтрДлина(Текст) - Позиция + 1));
			Прервать;
			
		ИначеЕсли НЕ ДелитьСтроку И Символ = СимволКавычка Тогда
			Если СледСимвол = СимволКавычка Тогда
				// две кавычки подряд ("")
				Позиция = Позиция + 1;
				
			Иначе
				// это закрытие строкового литерала
				ДелитьСтроку = Истина;
				ЭтоЗакрывающаяКавычка = Истина;
				
			КонецЕсли;
			
		КонецЕсли; 
		
		КодСимвола = КодСимвола(Текст, Позиция);
		ЭтоРазделитель = СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола, " ;+-/*=.,<>?""()[]{}!@#$^&№!|\");
		Если (ДелитьСтроку И ЭтоРазделитель) ИЛИ Позиция = РазмерТекста Тогда
			
			Если Позиция = РазмерТекста И НЕ ЭтоРазделитель Тогда
				Слова.Добавить(Сред(Текст, НачалоСлова, Позиция - НачалоСлова + 1));				
				НомерСлова = НомерСлова + 1;
				Продолжить;
				
			КонецЕсли; 
			
			Если Позиция <> НачалоСлова Тогда
				Слова.Добавить(Сред(Текст, НачалоСлова, Позиция - НачалоСлова));				
				НомерСлова = НомерСлова + 1;
				
			КонецЕсли;
			
			// Добавить в текущий элемент массива и сам разделитель
			Если НомерСлова > 0 И (Символ = " " ИЛИ (Символ = СимволКавычка И ЭтоЗакрывающаяКавычка)) Тогда
				Слова[НомерСлова - 1] = Слова[НомерСлова - 1] + Символ;
				
			Иначе
				Слова.Добавить(Символ);
				НомерСлова = НомерСлова + 1;
				
			КонецЕсли;
			
			//
			НачалоСлова = Позиция + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	// >> Цикл по символам текста
	
	Возврат Слова;
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Алгоритм = ВстроенныйЯзык.ПолучитьТекст();
КонецПроцедуры

#КонецОбласти
