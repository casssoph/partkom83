﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		_НаборЗаписей = РегистрыСведений.ОшибкиЗагрузкиОП.СоздатьНаборЗаписей();
		_НаборЗаписей.Отбор.НомерДокумента.Установить(ЭтотОбъект.Отбор.НомерДокумента.Значение);
		_НаборЗаписей.Отбор.КлючСвязи.Установить(ЭтотОбъект.Отбор.КлючСвязи.Значение);
		_НаборЗаписей.Отбор.Период.Установить(ЭтотОбъект.Отбор.Период.Значение);
		_Массив = Новый Массив;
		_Массив.Добавить(ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика, 3));
		ПланыОбмена.УдалитьРегистрациюИзменений(_Массив, _НаборЗаписей);
	Иначе
		Для Каждого ТекущаяЗапись Из ЭтотОбъект Цикл
			_НаборЗаписей = РегистрыСведений.ОшибкиЗагрузкиОП.СоздатьНаборЗаписей();
			_НаборЗаписей.Отбор.НомерДокумента.Установить(ТекущаяЗапись.НомерДокумента);
			_НаборЗаписей.Отбор.КлючСвязи.Установить(ТекущаяЗапись.КлючСвязи);
			_НаборЗаписей.Отбор.Период.Установить(ТекущаяЗапись.Период);
			_Массив = Новый Массив;
			_Массив.Добавить(ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика, 3));
			ПланыОбмена.ЗарегистрироватьИзменения(_Массив, _НаборЗаписей);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры