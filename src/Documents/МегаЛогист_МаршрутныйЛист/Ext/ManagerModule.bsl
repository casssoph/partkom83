﻿//// ОБМЕНЫ

//Выгрузка
Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена) Экспорт
	
	лКлючАлгоритма = "Документ_МегаЛогист_МаршрутныйЛист_МодульМенеджера_ВыгрузитьЭлементы";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Результат = Новый Массив;
	
	лМетаданныеПланаОбмена = Неопределено;
	лТип = ТипЗнч(вхПланОбмена);
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.Найти(вхПланОбмена);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.ПланыОбмена.Содержит(вхПланОбмена) тогда
		лМетаданныеПланаОбмена = вхПланОбмена;
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = Неопределено) тогда
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog Тогда 
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		
		лЗапрос = Новый Запрос;
		лЗапрос.УстановитьПараметр("ТаблицаСсылок", вхТаблицаСсылокНаОбъекты);
		лЗапрос.УстановитьПараметр("ПустойЗаказ", Документы.РеализацияТоваровУслуг.ПустаяСсылка());
		лЗапрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Ссылка
		|ПОМЕСТИТЬ Объекты
		|ИЗ
		|	&ТаблицаСсылок КАК Т
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МегаЛогист_МаршрутныйЛист.Ссылка КАК Ссылка,
		|	МегаЛогист_МаршрутныйЛист.Номер КАК Номер,
		|	МегаЛогист_МаршрутныйЛист.Дата КАК Дата,
		|	МегаЛогист_МаршрутныйЛист.ДатаДоставки КАК ДатаДоставки,
		|	МегаЛогист_МаршрутныйЛист.Курьер КАК Водитель,
		|	МегаЛогист_МаршрутныйЛист.Филиал КАК Филиал,
		|	ЕСТЬNULL(МегаЛогист_МаршрутныйЛист.Филиал.ОсновнойСклад, """") КАК Склад,
		|	ЕСТЬNULL(МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.ДокументСсылка, """") КАК Заказ
		|ИЗ
		|	Объекты КАК Объекты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МегаЛогист_МаршрутныйЛист КАК МегаЛогист_МаршрутныйЛист
		|		ПО (МегаЛогист_МаршрутныйЛист.Ссылка = Объекты.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.МегаЛогист_МаршрутныйЛист.МаршрутныеЗадания КАК МегаЛогист_МаршрутныйЛистМаршрутныеЗадания
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.МегаЛогист_МаршрутноеЗадание.ДокументыРеализации КАК МегаЛогист_МаршрутноеЗаданиеДокументыРеализации
		|			ПО (МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка = МегаЛогист_МаршрутныйЛистМаршрутныеЗадания.ДокументСсылка)
		|				И (МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Проведен)
		|		ПО (МегаЛогист_МаршрутныйЛистМаршрутныеЗадания.Ссылка = Объекты.Ссылка)
		|ИТОГИ ПО
		|	Ссылка";
		
		РезультатЗапроса = лЗапрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			лТипОбъектаXDTO = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "МаршрутныйЛист");
			лВыборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока лВыборка.Следующий() Цикл
				
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				ЗаполнитьЗначенияСвойств(лОбъект, лВыборка, "Номер,Дата,ДатаДоставки");
				лОбъект.Ссылка 				= XMLСтрока(лВыборка.Ссылка);
				лОбъект.СкладСсылка 		= XMLСтрока(лВыборка.Склад);
				лОбъект.ВодительСсылка 		= XMLСтрока(лВыборка.Водитель);
				
				лЗаказы = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "МаршрутныйЛист.Заказы"));
				лЗаказыСписок = лЗаказы.ПолучитьСписок("СтрокаЗаказы");
				
				ВыборкаПоЗаказам = лВыборка.Выбрать();
				
				Пока ВыборкаПоЗаказам.Следующий() Цикл
					
					НоваяСтрока = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), лЗаказыСписок.ВладеющееСвойство.Тип.Имя)); 
					НоваяСтрока.ЗаказСсылка = XMLСтрока(ВыборкаПоЗаказам.Заказ);
					
					лЗаказыСписок.Добавить(НоваяСтрока);
					
				КонецЦикла;	
				
				лОбъект.Заказы = лЗаказы;
				Результат.Добавить(лОбъект);
				//Семенов И.П. 07.02.2019 XX-1768(
				ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(лВыборка.Ссылка, лОбъект);
				//)Семенов И.П
			КонецЦикла;

		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
