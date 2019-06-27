﻿
Процедура ПередЗаписью(Отказ, Замещение)
	лКлючАлгоритма = "РегистрыСведений_КонтактнаяИнформация_МодульОбъекта_ПередЗаписью";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	//Регистрируем контрагентов к обмену на сайт//
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Контрагенты", Ложь) И НЕ ОбменДанными.Загрузка Тогда
		Узел = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, 2);
		Для Каждого Запись Из ЭтотОбъект Цикл
			Если ЗначениеЗаполнено(Запись.Объект) И ТипЗнч(Запись.Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
				//Семенов И.П. 31.01.2019 XX-1768(
				//ПланыОбмена.ЗарегистрироватьИзменения(Узел, Запись.Объект);
				ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(Узел, Запись.Объект);
				//)Семенов И.П.
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(Запись.Объект) И ТипЗнч(Запись.Объект) = Тип("СправочникСсылка.Менеджеры") 
			И Запись.Вид = Справочники.ВидыКонтактнойИнформации.МобильныйТелефонМенеджера Тогда
			
			УзелТоплог = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ, 3);

			Запрос = Новый Запрос;
			Запрос.Текст =  "ВЫБРАТЬ
			                |	МенеджерыТорговыхТочек.ТорговаяТочка
			                |ИЗ
			                |	РегистрСведений.МенеджерыТорговыхТочек.СрезПоследних(
			                |			,
			                |			ВидМенеджера = &ВидМенеджера
			                |				И Менеджер = &Менеджер) КАК МенеджерыТорговыхТочек
			                |ГДЕ
			                |	МенеджерыТорговыхТочек.ТорговаяТочка <> ЗНАЧЕНИЕ(Справочник.ТорговыеТочки.ПустаяСсылка)";
			Запрос.УстановитьПараметр("Менеджер", Запись.Объект);
			Запрос.УстановитьПараметр("ВидМенеджера", Перечисления.ВидыМенеджеров.Продажи);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл 
				
				//ПланыОбмена.ЗарегистрироватьИзменения(УзелТоплог, Выборка.ТорговаяТочка);
				//# Kalinin V.A. ( 2019-06-27 )  /*
				ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(Узел, Запись.Объект);
				// */
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

