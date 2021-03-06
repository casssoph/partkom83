﻿Процедура ЗафиксироватьЗапускРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьЗапускРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////

	МенеджерЗаписи = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.Запуск");
	МенеджерЗаписи.РегламентноеЗадание = РегламентноеЗадание;
	МенеджерЗаписи.Начало = ТекущаяДатаСеанса();
	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МенеджерЗаписи.НомерСеанса = НомерСеансаИнформационнойБазы();
	МенеджерЗаписи.ВнешняяОбработка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегламентноеЗадание, "ТипОбработки") = 1;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ЗафиксироватьЗавершениеРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьЗавершениеРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.Запуск");
	
	Начало = ПолучитьДатуНачалаРегламентногоЗадания(РегламентноеЗадание, Событие);
	Если Не ЗначениеЗаполнено(Начало) Тогда
		Начало = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РегламентноеЗадание.Установить(РегламентноеЗадание);
	НаборЗаписей.Отбор.Событие.Установить(Событие);
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыСеанса.ТекущийПользователь);
	НаборЗаписей.Отбор.НомерСеанса.Установить(НомерСеансаИнформационнойБазы());
	НаборЗаписей.Отбор.Период.Установить(Начало);
	
	НаборЗаписей.Прочитать();
		
	Если НаборЗаписей.Количество() Тогда 
		Запись = НаборЗаписей[0];
		Запись.Конец = ТекущаяДатаСеанса();
		Запись.Длительность = ТекущаяДатаСеанса() - Начало;
		Запись.Завершено = Истина;
	Иначе
		Запись = НаборЗаписей.Добавить();
		Запись.Начало = ТекущаяДатаСеанса();
		Запись.Конец = ТекущаяДатаСеанса();
		Запись.РегламентноеЗадание = РегламентноеЗадание;
		Запись.Событие = Событие;
		Запись.НомерСеанса = НомерСеансаИнформационнойБазы();
		Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Запись.Период = Начало;
		Запись.Завершено = Истина;
	КонецЕсли;
	
	НаборЗаписей.Записать();
		
КонецПроцедуры

Процедура ЗафиксироватьОшибкуРегламентногоЗадания(РегламентноеЗадание, ОписаниеОшибки) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьОшибкуРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////

	Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.Запуск");
	Начало = ПолучитьДатуНачалаРегламентногоЗадания(РегламентноеЗадание, Событие);
	Если Не ЗначениеЗаполнено(Начало) Тогда
		Начало = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РегламентноеЗадание.Установить(РегламентноеЗадание);
	НаборЗаписей.Отбор.Событие.Установить(Событие);
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыСеанса.ТекущийПользователь);
	НаборЗаписей.Отбор.Период.Установить(Начало);
	НаборЗаписей.Отбор.НомерСеанса.Установить(НомерСеансаИнформационнойБазы());
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() Тогда 
		Запись = НаборЗаписей[0];
		Запись.Конец = ТекущаяДатаСеанса();
		Запись.Длительность = ТекущаяДатаСеанса() - Начало;
		Запись.Ошибка = Истина;
		Запись.ОписаниеОшибки = ОписаниеОшибки;
		Запись.Завершено = Истина;
	Иначе
		Запись = НаборЗаписей.Добавить();
		Запись.Начало = ТекущаяДатаСеанса();
		Запись.Конец = ТекущаяДатаСеанса();
		Запись.НомерСеанса = НомерСеансаИнформационнойБазы();
		Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Запись.Завершено = Истина;
		Запись.Ошибка = Истина;
		Запись.Завершено = Истина;
		Запись.ОписаниеОшибки = ОписаниеОшибки;
		Запись.ВнешняяОбработка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегламентноеЗадание, "ТипОбработки") = 1;
	КонецЕсли;
	
	НаборЗаписей.Записать();
		
КонецПроцедуры

Процедура ЗафиксироватьИзмененияНастроекРегламентогоЗадания(РегламентноеЗадание, ИзмененныеНастройки) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьИзмененияНастроекРегламентогоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	ИзмененныеНастройкиСтрока = ""; ПерваяСтрока = Истина;
	
	Если ИзмененныеНастройки.Количество() = 1 Тогда
		ИзмененныеНастройкиСтрока = ИзмененныеНастройки[0];
	Иначе
		Для Каждого Настройка Из ИзмененныеНастройки Цикл
			ИзмененныеНастройкиСтрока = ИзмененныеНастройкиСтрока + ?(ПерваяСтрока, "",", ") + Настройка;
			ПерваяСтрока = Ложь;
		КонецЦикла;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.ИзменениеНастроек");
	МенеджерЗаписи.РегламентноеЗадание = РегламентноеЗадание;
	МенеджерЗаписи.Начало = ТекущаяДатаСеанса();
	МенеджерЗаписи.ОписаниеОшибки = "Изменены настройки: " + ИзмененныеНастройкиСтрока;
	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МенеджерЗаписи.НомерСеанса = Истина;
	МенеджерЗаписи.ВнешняяОбработка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегламентноеЗадание, "ТипОбработки") = 1;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ЗафиксироватьВключениеРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьВключениеРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////

	МенеджерЗаписи = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.Включение");
	МенеджерЗаписи.РегламентноеЗадание = РегламентноеЗадание;
	МенеджерЗаписи.Начало = ТекущаяДатаСеанса();
	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МенеджерЗаписи.НомерСеанса = Истина;
	МенеджерЗаписи.ВнешняяОбработка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегламентноеЗадание, "ТипОбработки") = 1;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ЗафиксироватьОтключениеРегламентногоЗадания(РегламентноеЗадание) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ЗафиксироватьОтключениеРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	МенеджерЗаписи = РегистрыСведений.ИсторияРегламентныхЗаданий.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Событие = ПредопределенноеЗначение("Перечисление.СобытияРегламентныхЗаданий.Отключение");
	МенеджерЗаписи.РегламентноеЗадание = РегламентноеЗадание;
	МенеджерЗаписи.Начало = ТекущаяДатаСеанса();
	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МенеджерЗаписи.НомерСеанса = Истина;
	МенеджерЗаписи.ВнешняяОбработка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегламентноеЗадание, "ТипОбработки") = 1;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция ПолучитьДатуНачалаРегламентногоЗадания(РегламентноеЗадание, Событие)
	
	лКлючАлгоритма = "РегистрСведений_ИсторияРегламентныхЗаданий_МодульМенеджера_ПолучитьДатуНачалаРегламентногоЗадания";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИсторияРегламентныхЗаданий.Начало КАК Начало
	|ИЗ
	|	РегистрСведений.ИсторияРегламентныхЗаданий КАК ИсторияРегламентныхЗаданий
	|ГДЕ
	|	НЕ ИсторияРегламентныхЗаданий.Завершено
	|	И ИсторияРегламентныхЗаданий.РегламентноеЗадание = &РегламентноеЗадание
	|	И ИсторияРегламентныхЗаданий.Событие = &Событие
	|	И ИсторияРегламентныхЗаданий.Пользователь = &Пользователь
	|	И ИсторияРегламентныхЗаданий.НомерСеанса = &НомерСеанса
	|
	|УПОРЯДОЧИТЬ ПО
	|	Начало УБЫВ";
	
	Запрос.УстановитьПараметр("РегламентноеЗадание", РегламентноеЗадание);
	Запрос.УстановитьПараметр("Событие", Событие);
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("НомерСеанса", НомерСеансаИнформационнойБазы());
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Начало;
		
КонецФункции