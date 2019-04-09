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



