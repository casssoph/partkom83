﻿
&НаКлиенте
Процедура МоиАкты(Команда)
	УстановитьОтборПоОтветственному(ПараметрыСеанса.ТекущийПользователь);
КонецПроцедуры

&НаКлиенте
Процедура АктыБезОтветственного(Команда)
	УстановитьОтборПоОтветственному()
КонецПроцедуры

&НаКлиенте
Процедура АктыМоейГруппы(Команда)
	УстановитьОтборПоОтветственному(ПараметрыСеанса.ТекущийПользователь.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя)
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоОтветственному(ПользовательОтбора = Неопределено)
	
	УстановитьОтборСписка(АктыРассмотренияВозврата.КомпоновщикНастроек, "Ответственный", ПользовательОтбора, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСписка(пКомпоновщикНастроек, ИмяПоля, ЗначениеПоля = Неопределено, ВидСравнения = Неопределено, Использование = Истина)

	ЭлОтбора = НайтиЭлементОтбора(пКомпоновщикНастроек.Настройки.Отбор.Элементы, ИмяПоля);
	
	ЭлОтбора.ПравоеЗначение = ЗначениеПоля;
	ЭлОтбора.Использование = Использование;
	ЭлОтбора.ВидСравнения = ВидСравнения;
	
	Для каждого ЭлементОтбора Из пКомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если Строка(ЭлементОтбора.ИдентификаторПользовательскойНастройки) = ЭлОтбора.ИдентификаторПользовательскойНастройки Тогда
			ЭлементОтбора.ПравоеЗначение = ЭлОтбора.ПравоеЗначение;
			ЭлементОтбора.Использование = ЭлОтбора.Использование;
			ЭлементОтбора.ВидСравнения = ЭлОтбора.ВидСравнения;
		КонецЕсли;
	КонецЦикла;             
	
КонецПроцедуры

&НаКлиенте
Функция НайтиЭлементОтбора(КоллекцияЭлементов, ИмяЭлемента)
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если Строка(ЭлементОтбора.ЛевоеЗначение) = ИмяЭлемента Тогда
			ВозвращаемоеЗначение = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции

