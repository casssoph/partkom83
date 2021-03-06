﻿Функция ПолучитьИзмененияИстории()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Р.Период,
	|	Р.Документ,
	|	Р.ОсновноеСостояние
	|ПОМЕСТИТЬ Д
	|ИЗ
	|	РегистрСведений.ИзменениеСтрокЗаявок КАК Р
	|ГДЕ
	|	НЕ Р.ИсторияСформирована
	|
	|УПОРЯДОЧИТЬ ПО
	|	Р.Период,
	|	Р.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Р.Период КАК Период,
	|	Р.Документ КАК Документ,
	|	Р.СтрокаЗаявки,
	|	Р.ОсновноеСостояние
	|ИЗ
	|	РегистрСведений.ИзменениеСтрокЗаявок КАК Р
	|ГДЕ
	|	(Р.Документ, Р.ОсновноеСостояние) В
	|			(ВЫБРАТЬ
	|				Д.Документ,
	|				Д.ОсновноеСостояние
	|			ИЗ
	|				Д КАК Д)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Документ"
	);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура СформироватьИсторию(лДокумент, лСостояние, лПериод, лСписокСтрокЗаявок)
	тСтруктураИсторииСтрок = Новый Структура;
	тСтруктураИсторииСтрок.Вставить("ТекДокумент", лДокумент);
	тСтруктураИсторииСтрок.Вставить("ТекСостояние", лСостояние);
	тСтруктураИсторииСтрок.Вставить("ТекДатаРегистрации", лПериод);
	тСтруктураИсторииСтрок.Вставить("ТекСтроки", лСписокСтрокЗаявок);
	
	НачатьТранзакцию();
	Попытка
		ТаблицаИстории = Неопределено;
		ОбщегоНазначения.СоздатьСтруктуруРегистраСведений("_ИсторияСтрокЗаявок", ТаблицаИстории);
		
		РаботаСоСтатусамиДокументов.СформироватьПолнуюИсторию(тСтруктураИсторииСтрок, ТаблицаИстории); 
		Для Каждого СтрокаИстории Из ТаблицаИстории Цикл
			
			аЗапись = РегистрыСведений._ИсторияСтрокЗаявок.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(аЗапись, СтрокаИстории);
			//PaSe-05.07.2018
			//Перезаписывать существующую историю не нужно, она уже отправлялась на сайт//
			//аЗапись.Записать(Истина);
			аЗапись.Прочитать();
			Если НЕ аЗапись.Выбран() Тогда
				ЗаполнитьЗначенияСвойств(аЗапись, СтрокаИстории);
				аЗапись.Записать(Истина);
			КонецЕсли;
			//PaSe-05.07.2018//
			
		КонецЦикла;
		
		Для Каждого КлючИЗначение ИЗ лСписокСтрокЗаявок Цикл
			аЗапись = РегистрыСведений.ИзменениеСтрокЗаявок.СоздатьМенеджерЗаписи();
			азапись.Период = лПериод;
			аЗапись.Документ = лДокумент;
			аЗапись.СтрокаЗаявки = КлючИЗначение.Значение;
			аЗапись.ОсновноеСостояние = лСостояние;
			аЗапись.ИсторияСформирована = Истина;
			
			аЗапись.Записать(Истина);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		// + Пушкин 20180427
		лОписаниеОшибки = ОписаниеОшибки();
		
		ЗаписьЖурналаРегистрации("Обработка.ФормированиеИсторииЗаявок", УровеньЖурналаРегистрации.Ошибка,,, лОписаниеОшибки);
		ОтменитьТранзакцию();
		
		аларм_стр = "попытка зафиксировать транзакцию не увенчалась успехом:" + Символы.ПС +
					"лДокумент:" + СокрЛП(лДокумент) + Символы.ПС + 
					"лСостояние:" + СокрЛП(лСостояние) + Символы.ПС + 
					"Описание ошибки:" + СокрЛП(лОписаниеОшибки);
		
		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаФормированияИсторииЗаявок,аларм_стр,"err СформироватьИсторию");
		// - Пушкин 20180427
		
	КонецПопытки;
		
КонецПроцедуры

Процедура ВыполнитьРегламентноеЗадание() Экспорт
	ЗапросИзменений = ПолучитьИзмененияИстории();
	
	Если ЗапросИзменений.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	тДокумент = Неопределено;
	ВыборкаИзменений = ЗапросИзменений.Выбрать();
	Пока ВыборкаИзменений.Следующий() Цикл
		//Если тДокумент = Неопределено Тогда
		//	тДокумент = ВыборкаИзменений.Документ;
		//	тОсновноеСостояние = ВыборкаИзменений.ОсновноеСостояние;
		//	тДатаРегистрации = ВыборкаИзменений.Период;
		//	тСписокСтрокЗаявок = Новый СписокЗначений;
		//	
		//Иначе
		//	Если тДокумент <> ВыборкаИзменений.Документ Тогда
		//		СформироватьИсторию(тДокумент, тОсновноеСостояние, тДатаРегистрации, тСписокСтрокЗаявок);
		//		
		//		тДокумент = ВыборкаИзменений.Документ;
		//		тОсновноеСостояние = ВыборкаИзменений.ОсновноеСостояние;
		//		тДатаРегистрации = ВыборкаИзменений.Период;
		//		тСписокСтрокЗаявок = Новый СписокЗначений;
		//		
		//	КонецЕсли;
		//	
		//КонецЕсли;
		
		тДокумент = ВыборкаИзменений.Документ;
		тОсновноеСостояние = ВыборкаИзменений.ОсновноеСостояние;
		тДатаРегистрации = ВыборкаИзменений.Период;
		тСписокСтрокЗаявок = Новый СписокЗначений;
		тСписокСтрокЗаявок.Добавить(ВыборкаИзменений.СтрокаЗаявки);
		СформироватьИсторию(тДокумент, тОсновноеСостояние, тДатаРегистрации, тСписокСтрокЗаявок);
		
	КонецЦикла;
	
	//СформироватьИсторию(тДокумент, тОсновноеСостояние, тДатаРегистрации, тСписокСтрокЗаявок);
		
КонецПроцедуры