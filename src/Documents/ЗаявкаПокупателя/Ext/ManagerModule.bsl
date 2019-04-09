﻿
//// ОБРАБОТЧИКИ МОДУЛЯ ОБЪЕКТА

Процедура ВыполнитьПроведение(вхОбъект, вхОтказ, вхПараметры = Неопределено) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ВыполнитьПроведение";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Документы.КорректировкаЗаявкиПокупателя.ВыполнитьПроведение(вхОбъект, вхОтказ, вхПараметры);
	
КонецПроцедуры

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ВыполнитьОтменуПроведения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Документы.КорректировкаЗаявкиПокупателя.ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры);
	
КонецПроцедуры

//// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПоследнийДокументКорректировки(вхСсылкаНаДокумент) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ПолучитьПоследнийДокументКорректировки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если Не ЗначениеЗаполнено(вхСсылкаНаДокумент) Тогда
		Возврат вхСсылкаНаДокумент
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорректировкаЗаявки.Ссылка
	|ИЗ
	|	Документ.КорректировкаЗаявкиПокупателя КАК КорректировкаЗаявки
	|ГДЕ
	|	КорректировкаЗаявки.Проведен
	|	И КорректировкаЗаявки.ДокументОснование = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	КорректировкаЗаявки.МоментВремени УБЫВ");
	Если ТипЗнч(вхСсылкаНаДокумент) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда
		Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	ИначеЕсли ТипЗнч(вхСсылкаНаДокумент) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") Тогда
		Запрос.УстановитьПараметр("Ссылка", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ДокументОснование"));
	Иначе
		Возврат вхСсылкаНаДокумент
	КонецЕсли;
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат вхСсылкаНаДокумент
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка
		
	КонецЕсли;
	
КонецФункции

Функция ЕстьИзмененияДокумента(вхСсылкаНаДокумент, вхОбъект) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ЕстьИзмененияДокумента";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	//ЕстьИзмененияПоДокументу = Ложь;
	
	МассивИсключаемыхРеквизитов = Новый Массив;
	МассивИсключаемыхРеквизитов.Добавить("ДокументОснование"); //В документе заявка и корректировка несут разный смысл
	МассивИсключаемыхРеквизитов.Добавить("Подтверждена"); //По данному реквизиту изменения расчитываются по статусу документа
	МассивИсключаемыхРеквизитов.Добавить("Ответственный"); 
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорректировкаЗаявки.Ссылка,
	|	КорректировкаЗаявки.МоментВремени КАК МоментВремени
	|ИЗ
	|	Документ.КорректировкаЗаявкиПокупателя КАК КорректировкаЗаявки
	|ГДЕ
	|	КорректировкаЗаявки.Проведен
	|	И КорректировкаЗаявки.ДокументОснование = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	МоментВремени УБЫВ");
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ПредыдущийДокумент = Выборка.Ссылка;
	Иначе
		ПредыдущийДокумент = вхСсылкаНаДокумент;
	КонецЕсли;
	
	Для Каждого ТекРеквизит Из вхОбъект.Метаданные().Реквизиты Цикл
		Если МассивИсключаемыхРеквизитов.Найти(ТекРеквизит.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПредыдущийДокумент[ТекРеквизит.Имя] = вхОбъект[ТекРеквизит.Имя] Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекТабЧасть Из вхОбъект.Метаданные().ТабличныеЧасти Цикл
		
		Если Не ПредыдущийДокумент[ТекТабЧасть.Имя].Количество() = вхОбъект[ТекТабЧасть.Имя].Количество() Тогда
			Возврат Истина;
		КонецЕсли;
		
		Для Каждого ТекСтрока Из ПредыдущийДокумент[ТекТабЧасть.Имя] Цикл
			
			ИндексТекущейСтроки = ПредыдущийДокумент[ТекТабЧасть.Имя].Индекс(ТекСтрока);
			СтрокаДокумента = вхОбъект[ТекТабЧасть.Имя].Получить(ИндексТекущейСтроки);
			Для Каждого ТекРеквизит Из ТекТабЧасть.Реквизиты Цикл
				Если Не ТекСтрока[ТекРеквизит.Имя] = СтрокаДокумента[ТекРеквизит.Имя] Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ВернутьФилиал(пар_КА) экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ВернутьФилиал";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////

	лФилиал = Справочники.Филиалы.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(пар_КА) тогда
		л_Регион = ОбщегоНазначения.ПолучитьЗначениеРеквизита(пар_КА.ОсновнаяТорговаяТочка,"Регион");
		Если ЗначениеЗаполнено(л_Регион) тогда
			лФилиал = ОбщегоНазначения.ПолучитьЗначениеРеквизита(л_Регион,"Филиал");
		КонецЕсли;
	КонецЕсли;
	
	Возврат лФилиал;
КонецФункции
	
Функция ПолучитьМетаданные()
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ПолучитьМетаданные";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	Возврат Метаданные.Документы.ЗаявкаПокупателя;	
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ПолучитьРеквизитыКонтроля";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Результат = Новый Структура;
	Если (вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом83_77) тогда
		Результат = ОбменДаннымиКлиентСервер.РеквизитыКонтроляПоДокументу(ПолучитьМетаданные(), ИсключаемыеРеквизитыКонтроляРегистрации());
	Иначе
		Результат.Вставить("Шапка", "Дата,Проведен");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИсключаемыеРеквизитыКонтроляРегистрации() Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ИсключаемыеРеквизитыКонтроляРегистрации";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	ИсключаемыеРеквизиты = ОбменДаннымиКлиентСервер.ИнициализироватьТаблицуИсключаемыхРеквизитовКонтроля();
	ОбменДаннымиКлиентСервер.ДобавитьВИсключаемыеРевизиты(ИсключаемыеРеквизиты, "Ссылка");
	
	Возврат ИсключаемыеРеквизиты;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ПолучитьЗначенияРеквизитовКонтроля";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр);
КонецФункции

// Обновление ссылки на последнюю корректировку в идентификаторах заявок
//
// Параметры:
//  вхСсылкаНаДокумент  - <ДокументСсылка.ЗаявкаПокупателя, ДокументСсылка.КорректировкаЗаявкиПокупателя> - ссылка на документ, в котором нужно обновить данные
//                 
//
Процедура ОбновитьПоследнююКорректировку(Знач вхСсылкаНаДокумент) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ОбновитьПоследнююКорректировку";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если ТипЗнч(вхСсылкаНаДокумент) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") Тогда
		вхСсылкаНаДокумент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "ДокументОснование");
	КонецЕсли;
	
	Если Не ТипЗнч(вхСсылкаНаДокумент) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	ПоследняяКорректировка = ПолучитьПоследнийДокументКорректировки(вхСсылкаНаДокумент);
	СостояниеЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПоследняяКорректировка, "СтатусДокумента");
	
	Если ТипЗнч(ПоследняяКорректировка) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда 
		ПоследняяКорректировка = Документы.КорректировкаЗаявкиПокупателя.ПустаяСсылка();
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Заявка", вхСсылкаНаДокумент);
	Запрос.УстановитьПараметр("ПоследняяКорректировка", ПоследняяКорректировка);
	Запрос.УстановитьПараметр("СостояниеЗаявки", СостояниеЗаявки);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИдентификаторыСтрокЗаявок.Ссылка
	               |ИЗ
	               |	Справочник.ИдентификаторыСтрокЗаявок КАК ИдентификаторыСтрокЗаявок
	               |ГДЕ
	               |	ИдентификаторыСтрокЗаявок.Заявка = &Заявка
	               |	И НЕ ИдентификаторыСтрокЗаявок.ПометкаУдаления
	               |	И ИдентификаторыСтрокЗаявок.ПоследняяКорректировка <> &ПоследняяКорректировка";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		лОбъект = Выборка.Ссылка.ПолучитьОбъект();
		лОбъект.ПоследняяКорректировка = ПоследняяКорректировка;
		лОбъект.СостояниеЗаявки = СостояниеЗаявки;
		лОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьМассивОбязательныхРеквизитов(ВидОперации) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ПолучитьМассивОбязательныхРеквизитов";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	СписокЗначений = Новый СписокЗначений;
	Если ВидОперации = Перечисления.ВидыОперацийЗаявкаПокупателя.ЗаявкаПокупателя Тогда
		СписокЗначений.Добавить("Контрагент", "Контрагент");
		СписокЗначений.Добавить("ДоговорКонтрагента", "Договор контрагента");
		СписокЗначений.Добавить("ТорговаяТочка", "Торговая точка");
		СписокЗначений.Добавить("МаршрутДоставки", "Маршрут доставки");
	КонецЕсли;
	СписокЗначений.Добавить("Организация", "Организация");
	СписокЗначений.Добавить("Склад", "Склад");
	//СписокЗначений.Добавить("МаршрутДоставки", "Маршрут доставки");

	Возврат СписокЗначений
	
КонецФункции

Процедура ЗакрытьЗаявкиПокупателей() Экспорт	
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ЗакрытьЗаявкиПокупателей";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкиПокупателейОстатки.СтрокаЗаявки.Заявка КАК Заявка,
	               |	ЗаявкиПокупателейОстатки.СтрокаЗаявки КАК СтрокаЗаявки,
	               |	ЗаявкиПокупателейОстатки.КоличествоОстаток КАК Количество
	               |ПОМЕСТИТЬ втСтрокиЗаявок
	               |ИЗ
	               |	РегистрНакопления.ЗаявкиПокупателей.Остатки КАК ЗаявкиПокупателейОстатки
	               |ГДЕ
	               |	ЗаявкиПокупателейОстатки.КоличествоОстаток > 0
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	СтрокаЗаявки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПродажиОбороты.СтрокаЗаявки КАК СтрокаЗаявки,
	               |	ПродажиОбороты.КоличествоОборот КАК Количество
	               |ПОМЕСТИТЬ втВыполнено
	               |ИЗ
	               |	РегистрНакопления.Продажи.Обороты(
	               |			,
	               |			,
	               |			,
	               |			СтрокаЗаявки В
	               |				(ВЫБРАТЬ
	               |					втСтрокиЗаявок.СтрокаЗаявки
	               |				ИЗ
	               |					втСтрокиЗаявок)) КАК ПродажиОбороты
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ПополнениеСкладаОбороты.СтрокаЗаявки,
	               |	ПополнениеСкладаОбороты.КоличествоОборот
	               |ИЗ
	               |	РегистрНакопления.ПополнениеСклада.Обороты(
	               |			,
	               |			,
	               |			,
	               |			СтрокаЗаявки В
	               |				(ВЫБРАТЬ
	               |					втСтрокиЗаявок.СтрокаЗаявки
	               |				ИЗ
	               |					втСтрокиЗаявок)) КАК ПополнениеСкладаОбороты
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	СтрокаЗаявки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ОтказыПоЗаявкамОбороты.СтрокаЗаявки КАК СтрокаЗаявки,
	               |	ОтказыПоЗаявкамОбороты.КоличествоОборот КАК Количество
	               |ПОМЕСТИТЬ втОтказы
	               |ИЗ
	               |	РегистрНакопления.ОтказыПоЗаявкам.Обороты(
	               |			,
	               |			,
	               |			,
	               |			СтрокаЗаявки В
	               |				(ВЫБРАТЬ
	               |					втСтрокиЗаявок.СтрокаЗаявки
	               |				ИЗ
	               |					втСтрокиЗаявок)) КАК ОтказыПоЗаявкамОбороты
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	СтрокаЗаявки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	втСтрокиЗаявок.Заявка
	               |ПОМЕСТИТЬ втЗаявкиНеЗакр
	               |ИЗ
	               |	втСтрокиЗаявок КАК втСтрокиЗаявок
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втВыполнено КАК втВыполнено
	               |		ПО втСтрокиЗаявок.СтрокаЗаявки = втВыполнено.СтрокаЗаявки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втОтказы КАК втОтказы
	               |		ПО втСтрокиЗаявок.СтрокаЗаявки = втОтказы.СтрокаЗаявки
	               |ГДЕ
	               |	втСтрокиЗаявок.Количество > ЕСТЬNULL(втВыполнено.Количество, 0) + ЕСТЬNULL(втОтказы.Количество, 0)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	втСтрокиЗаявок.Заявка КАК Заявка
	               |ПОМЕСТИТЬ втПотенцЗаявки
	               |ИЗ
	               |	втСтрокиЗаявок КАК втСтрокиЗаявок
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ втВыполнено
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ втОтказы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ втСтрокиЗаявок
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 99999
	               |	втПотенцЗаявки.Заявка КАК Документ
	               |ИЗ
	               |	втПотенцЗаявки КАК втПотенцЗаявки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втЗаявкиНеЗакр КАК втЗаявкиНеЗакр
	               |		ПО втПотенцЗаявки.Заявка = втЗаявкиНеЗакр.Заявка
	               |ГДЕ
	               |	втЗаявкиНеЗакр.Заявка ЕСТЬ NULL
	               |	И (ВЫРАЗИТЬ(втПотенцЗаявки.Заявка КАК Документ.ЗаявкаПокупателя)) <> &ПустаяЗаявка";
		Запрос.УстановитьПараметр("ПустаяЗаявка", Документы.ЗаявкаПокупателя.ПустаяСсылка());
		
		ПрекратитьВыполнение = Ложь;		   
		Пока Не ПрекратитьВыполнение Цикл 
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый); 
				РезультатЗапроса = Запрос.Выполнить();
			ЗафиксироватьТранзакцию();
			
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Автоматический); 
			Если Не РезультатЗапроса.Пустой() Тогда 
				Таблица = РезультатЗапроса.Выгрузить();
				Документ = Документы.ЗакрытиеЗаявокПокупателя.СоздатьДокумент();
				Документ.Заявки.Загрузить(Таблица);
				Документ.Дата = ТекущаяДата();
				Документ.Ответственный = ПолныеПрава.ТекущийПользователь();
				Документ.Организация = Константы.ОрганизацияПоУмолчаниюБезнал.Получить();
				Попытка
					Документ.Записать(РежимЗаписиДокумента.Проведение);
					ЗафиксироватьТранзакцию();
				Исключение
					ОписаниеОшибки = ОписаниеОшибки();
					#Если Клиент Тогда 
						Сообщить(ОписаниеОшибки);
					#КонецЕсли
					ЗаписьЖурналаРегистрации("Закрытие заявок", ,,,ОписаниеОшибки);
					ПрекратитьВыполнение = Истина;
					ОтменитьТранзакцию();
				КонецПопытки;
			Иначе
				ПрекратитьВыполнение = Истина;
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 99999
		               |	ЗаявкиПокупателейОстатки.СтрокаЗаявки.Заявка КАК Документ
		               |ИЗ
		               |	РегистрНакопления.ЗаявкиПокупателей.Остатки КАК ЗаявкиПокупателейОстатки
		               |ГДЕ
		               |	ЗаявкиПокупателейОстатки.КоличествоОстаток = 0
		               |	И ЗаявкиПокупателейОстатки.СуммаРеглОстаток <> 0
		               |	И ЗаявкиПокупателейОстатки.СуммаУпрОстаток <> 0";
		ПрекратитьВыполнение = Ложь;		   
		Пока Не ПрекратитьВыполнение Цикл 
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);  
				РезультатЗапроса = Запрос.Выполнить();
			ЗафиксироватьТранзакцию();
			
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Автоматический); 
			Если Не РезультатЗапроса.Пустой() Тогда 
				Таблица = РезультатЗапроса.Выгрузить();
				Документ = Документы.ЗакрытиеЗаявокПокупателя.СоздатьДокумент();
				Документ.Заявки.Загрузить(Таблица);
				Документ.Дата = ТекущаяДата();
				Документ.Ответственный = ПолныеПрава.ТекущийПользователь();
				Документ.Организация = Константы.ОрганизацияПоУмолчаниюБезнал.Получить();
				Документ.Комментарий = "Коррекция ненулевых сумм";
				Попытка
					Документ.Записать(РежимЗаписиДокумента.Проведение);
					ЗафиксироватьТранзакцию();
				Исключение
					ПрекратитьВыполнение = Истина;
					ОтменитьТранзакцию();
				КонецПопытки;
			Иначе
				ПрекратитьВыполнение = Истина;
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	РезервыТоваровОстатки.СтрокаЗаявки.Заявка КАК Заявка,
		               |	РезервыТоваровОстатки.Номенклатура,
		               |	РезервыТоваровОстатки.Склад,
		               |	РезервыТоваровОстатки.Качество,
		               |	РезервыТоваровОстатки.СтрокаЗаявки,
		               |	РезервыТоваровОстатки.СтрокаПрихода
		               |ПОМЕСТИТЬ вт
		               |ИЗ
		               |	РегистрНакопления.РезервыТоваров.Остатки(, ЕСТЬNULL(СтрокаЗаявки.Заявка, &ПустаяЗаявка) <> &ПустаяЗаявка) КАК РезервыТоваровОстатки
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	Заявка
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 99999
		               |	вт.Заявка КАК Документ
		               |ИЗ
		               |	вт КАК вт
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗакрытиеЗаявокПокупателя.Заявки КАК ЗакрытиеЗаявокПокупателяЗаявки
		               |		ПО вт.Заявка = ЗакрытиеЗаявокПокупателяЗаявки.Документ
		               |ГДЕ
		               |	ЗакрытиеЗаявокПокупателяЗаявки.Ссылка.Проведен";
		Запрос.УстановитьПараметр("ПустаяЗаявка", Документы.ЗаявкаПокупателя.ПустаяСсылка());
		ПрекратитьВыполнение = Ложь;		   
		Пока Не ПрекратитьВыполнение Цикл 
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);  
				РезультатЗапроса = Запрос.Выполнить();
			ЗафиксироватьТранзакцию();
			
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Автоматический); 
			Если Не РезультатЗапроса.Пустой() Тогда 
				Таблица = РезультатЗапроса.Выгрузить();
				Документ = Документы.ЗакрытиеЗаявокПокупателя.СоздатьДокумент();
				Документ.Заявки.Загрузить(Таблица);
				Документ.Дата = ТекущаяДата();
				Документ.Ответственный = ПолныеПрава.ТекущийПользователь();
				Документ.Организация = Константы.ОрганизацияПоУмолчаниюБезнал.Получить();
				Документ.Комментарий = "Коррекция резервов";
				Попытка
					Документ.Записать(РежимЗаписиДокумента.Проведение);
					ЗафиксироватьТранзакцию();
				Исключение
					ПрекратитьВыполнение = Истина;
					ОтменитьТранзакцию();
				КонецПопытки;
			Иначе
				ПрекратитьВыполнение = Истина;
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		КонецЦикла;
КонецПроцедуры // ЗакрытьЗаявкиПокупателей()

Процедура ЗаполнитьЗаявкуПриОбмене(ДокументОбъект, Параметры = Неопределено) Экспорт  //Предположительно не используется
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ЗаполнитьЗаявкуПриОбмене";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если Параметры = Неопределено Тогда 
		Параметры = Новый Структура;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДокументОбъект, Параметры);
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.СтатусДокумента) Тогда 
		ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден;	
	КонецЕсли;
	
	Если ДокументОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден Тогда 
		ДокументОбъект.Подтверждена = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.БанковскийСчет) Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Организации.ОсновнойБанковскийСчет
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Организация);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			ДокументОбъект.БанковскийСчет = Выборка.ОсновнойБанковскийСчет;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда 
		ДокументОбъект.ВалютаДокумента = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДокументОбъект.ДоговорКонтрагента, "ВалютаВзаиморасчетов"); 	
		ВалютаРубль = Константы.ВалютаРубль.Получить();
		
		Дата = ?(ЗначениеЗаполнено(ДокументОбъект.Дата),ДокументОбъект.Дата, ТекущаяДата());
		Если ДокументОбъект.ВалютаДокумента = ВалютаРубль Тогда 
			ДокументОбъект.КурсВзаиморасчетов = 1;
			ДокументОбъект.КратностьВзаиморасчетов = 1;	
		Иначе
			СтруктураКурса = МодульВалютногоУчета.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента, ТекущаяДата());
			ДокументОбъект.КурсВзаиморасчетов = СтруктураКурса.Курс;
			ДокументОбъект.КратностьВзаиморасчетов = СтруктураКурса.Кратность;	
		КонецЕсли;
	КонецЕсли;
	
	
	ДокументОбъект.УчитыватьНДС = Истина;
	ДокументОбъект.СуммаВключаетНДС = Истина;
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.Ответственный) Тогда 
		ДокументОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.Менеджер) Тогда 
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТорговаяТочка", ДокументОбъект.ТорговаяТочка);
		Запрос.УстановитьПараметр("ВидМенеджера", Перечисления.ВидыМенеджеров.Продажи);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Р.Менеджер
		|ИЗ
		|	РегистрСведений.МенеджерыТорговыхТочек.СрезПоследних(
		|			,
		|			ТорговаяТочка = &ТорговаяТочка
		|				И ВидМенеджера = &ВидМенеджера) КАК Р";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() тогда
			ДокументОбъект.Менеджер = Выборка.Менеджер;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДокументОбъект.Контрагент, "Организация") = ДокументОбъект.Организация Тогда 
		ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийЗаявкаПокупателя.ПополнениеСклада;
	Иначе
		ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийЗаявкаПокупателя.ЗаявкаПокупателя;
	КонецЕсли;
	
	КлючСвязи = 1;
	
	Для Каждого СтрокаТабличнойЧасти Из ДокументОбъект.Товары Цикл 
		
		НовыйИдентификатор = Справочники.ИдентификаторыСтрокЗаявок.СоздатьЭлемент();
		НовыйИдентификатор.Наименование = ДокументОбъект.Номер + "; " + СтрокаТабличнойЧасти.Номенклатура.Наименование + "; " + СтрокаТабличнойЧасти.Цена;
		НовыйИдентификатор.Заявка = ДокументОбъект.Ссылка;
		ЗаполнитьЗначенияСвойств(НовыйИдентификатор, СтрокаТабличнойЧасти, "IDSite,ПрайсПоставщика,СрокГарантированный,СрокОжидаемый,СрокГарантированныйЗаказа,СрокОжидаемыйЗаказа,Цена,ЦенаЗакупки,Количество,Поставщик");
		//Сергеев. Проблема в различии типов (ТТ и Контрагент), пока не меняем ни где, подменяем объект.
		НовыйИдентификатор.Поставщик=СтрокаТабличнойЧасти.Поставщик.Владелец;
		//
		НовыйИдентификатор.Записать();
		
		СтрокаТабличнойЧасти.СтрокаЗаявки = НовыйИдентификатор.Ссылка;
		СтрокаТабличнойЧасти.Качество = Справочники.Качество.Новый;
		
		СтрокаТабличнойЧасти.КлючСвязи = КлючСвязи;
		КлючСвязи = КлючСвязи + 1;
		
	КонецЦикла;
	
	ДокументОбъект.СуммаДокумента = ДокументОбъект.Товары.Итог("Сумма");
	
КонецПроцедуры

Функция СкладОтгрузкиПоЗаявкеКорректировке(ЗаявкаКорректировка) Экспорт
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_СкладОтгрузкиПоЗаявкеКорректировке";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Склад = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РезервыТоваровОстатки.Склад
	|ИЗ
	|	РегистрНакопления.РезервыТоваров.Остатки(, СтрокаЗаявки.Заявка = &Заявка И Не Склад.ТоварыВПути) КАК РезервыТоваровОстатки
	|ГДЕ
	|	РезервыТоваровОстатки.КоличествоОстаток > 0";
	
	ЗаявкаСсылка = ?(ТипЗнч(ЗаявкаКорректировка) = Тип("ДокументСсылка.ЗаявкаПокупателя"), ЗаявкаКорректировка,  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаявкаКорректировка, "ДокументОснование")); 
	Запрос.УстановитьПараметр("Заявка", ЗаявкаСсылка);
	МассивСкладов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0); 
	Если МассивСкладов.Количество() = 0 Тогда 
		//Могут быть услуги без резервов
		//Если склада резерва нет, то заполним склад, только если в заявке есть услуги
		РезультатУслуги = Документы.РеализацияТоваровУслуг.ОстаткиУслугПоЗаявкеКорректировке(ЗаявкаСсылка);
		Если Не РезультатУслуги.Пустой() Тогда
			Склад = ЗаявкаКорректировка.Склад;
		КонецЕсли;
	ИначеЕсли МассивСкладов.Количество() = 1 Тогда 
		Склад = МассивСкладов.Получить(0);
	Иначе
		Попытка
			#Если Клиент Тогда
				Форма = ПолучитьФорму("ФормаВыбораСклада");
				Форма.МассивСкладов = МассивСкладов;
				Склад = Форма.ОткрытьМодально();
				Если Не ЗначениеЗаполнено(Склад) Тогда 
					Сообщить("Не выбран склад для выписки реализации");
				КонецЕсли;
			#Иначе
				Склад = МассивСкладов.Получить(0);
			#КонецЕсли
		Исключение
			Сообщить("Нет резерва по текущей заявке!");
			Склад = ЗаявкаКорректировка.Склад;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Склад;	
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ОбработкаПолученияФормы";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	Если ВидФормы = "ФормаСписка" Тогда
		// ЛНА, Замер  APDEX ++(
		APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ЗаявкаПокупателя_ОткрытиеФормыСписка");		
		//)--
	КонецЕсли;	
КонецПроцедуры


#Область СервисныеПроцедурыИФункции

Процедура ПроставитьПолныйОтказНаДокумент(ДокументСсылка,Период = Неопределено, ПричинаОтказа = Неопределено) Экспорт
	лКлючАлгоритма = "Документ_ЗявкаПокупателя_МодульМенеджера_ПроставитьПолныйОтказНаДокумент";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если ПричинаОтказа = Неопределено тогда 
		ПричинаОтказа = Справочники.СостоянияСтрокДокументов.ОтказПоСроку;
	КонецЕсли;	
	
	
	Если РаботаСоСтатусамиДокументовСервер.ПоЗаявкеЕстьАктивныйЗаказ(ДокументСсылка) тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Есть активный заказ, отказ не возможен");
		Возврат;
	КонецЕсли;	
	
	ПоследняяКорректировка = РаботаСоСтатусамиДокументовСервер.ПолучитьПоследниюКорректировкуЗаявкиЗаказа(ДокументСсылка);
	
	Ошибки = Неопределено;
	ВыборкаСтроккЗакрытию  = ДанныеКПолномуОтказу(ПоследняяКорректировка,Период);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	 
	СтруктураЗаполнения = новый Структура;
	СтруктураЗаполнения.Вставить("Дата",ТекущаяДата());
	СтруктураЗаполнения.Вставить("Ответственный",Пользователи.АвторизованныйПользователь());
	СтруктураЗаполнения.Вставить("ДокументОснование",ДокументСсылка);
	
	ТабПричинОтказа  = ПоследняяКорректировка.ПричиныОтказов.Выгрузить();	
	ТабТоваров = ПоследняяКорректировка.Товары;
	
	Пока ВыборкаСтроккЗакрытию.Следующий() Цикл
		КоличествоКЗакрытию  = ВыборкаСтроккЗакрытию.КоличествоКЗакрытию; 
		НайдСтроки = ТабТоваров.НайтиСтроки(Новый структура("СтрокаЗаявки",ВыборкаСтроккЗакрытию.СтрокаЗаявки)); 
		Если  НайдСтроки.Количество() 
			и  КоличествоКЗакрытию > 0  тогда 
			Для каждого НайдСтрока из НайдСтроки цикл  				 
				НовСтрока =  ТабПричинОтказа.добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока,НайдСтрока,"КлючСвязи");
				НовСтрока.ПричинаОтмены  = ПричинаОтказа;
				
				КоличествоПоДокументу = НайдСтрока.Количество ;//-НайдСтрока.КоличествоОтказ;	
				Если 	КоличествоКЗакрытию > КоличествоПоДокументу ТОГДА 			
					НовСтрока.Количество =КоличествоПоДокументу;
					КоличествоКЗакрытию = КоличествоКЗакрытию - КоличествоПоДокументу;
				иначе 
					НовСтрока.Количество =КоличествоКЗакрытию;
					КоличествоКЗакрытию = 0 ;
				КонецЕсли;
			КонецЦикла; 
		КонецЕсли; 
		
	КонецЦикла;	
	СтруктураЗаполнения.Вставить("Товары",ТабТоваров.Выгрузить());
	СтруктураЗаполнения.Вставить("ПричиныОтказов",ТабПричинОтказа);
	
	РаботаСоСтатусамиДокументовСервер.СоздатьКорректировкуЗаказаЗаявки(ПоследняяКорректировка,СтруктураЗаполнения,Истина);
	
КонецПроцедуры	

Функция ДанныеКПолномуОтказу(ПоследняяКорректировка, Период = Неопределено,Ошибки = Неопределено)
	лКлючАлгоритма = "Документ_ЗаявкаПокупателя_МодульМенеджера_ДанныеКПолномуОтказу";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если период = Неопределено тогда 
		Период =  Новый Граница(ПоследняяКорректировка.МоментВремени(),ВидГраницы.Включая);
	КонецЕсли;	
	
	ЗапросДанныхкОтмене =  новый Запрос ;
	ТексЗапроса = "ВЫБРАТЬ
	              |	ЗаявкаПокупателяТовары.СтрокаЗаявки,
	              |	ЗаявкаПокупателяТовары.Ссылка,
	              |	ЗаявкаПокупателяТовары.Количество
	              |ПОМЕСТИТЬ СтрокиЗаявкиДокумента
	              |ИЗ
	              |	Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
	              |ГДЕ
	              |	ЗаявкаПокупателяТовары.Ссылка = &ДокументСсылка
	              |
	              |ОБЪЕДИНИТЬ
	              |
	              |ВЫБРАТЬ
	              |	КорректировкаЗаявкиПокупателяТовары.СтрокаЗаявки,
	              |	КорректировкаЗаявкиПокупателяТовары.Ссылка,
	              |	КорректировкаЗаявкиПокупателяТовары.Количество
	              |ИЗ
	              |	Документ.КорректировкаЗаявкиПокупателя.Товары КАК КорректировкаЗаявкиПокупателяТовары
	              |ГДЕ
	              |	КорректировкаЗаявкиПокупателяТовары.Ссылка = &ДокументСсылка
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ДанныеКЗакрытию.СтрокаЗаявки,
	              |	СУММА(ДанныеКЗакрытию.КоличествоОстатокЗаявок - ДанныеКЗакрытию.КоличествоВСборке - ДанныеКЗакрытию.КоличествоОстатокЗаказ) КАК КоличествоКЗакрытию,
	              |	ДанныеКЗакрытию.КоличествоВСборке,
	              |	ДанныеКЗакрытию.КоличествоОстатокЗаказ
	              |ПОМЕСТИТЬ ДанныеРегистров
	              |ИЗ
	              |	(ВЫБРАТЬ
	              |		ЗаявкиПокупателейОстатки.СтрокаЗаявки КАК СтрокаЗаявки,
	              |		СУММА(ЗаявкиПокупателейОстатки.КоличествоОстаток) КАК КоличествоОстатокЗаявок,
	              |		СУММА(ЕСТЬNULL(РеализацияТоваровУслугТовары.Количество, 0)) КАК КоличествоВСборке,
	              |		СУММА(ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0)) КАК КоличествоОстатокЗаказ
	              |	ИЗ
	              |		РегистрНакопления.ЗаявкиПокупателей.Остатки(
	              |				&Период,
	              |				СтрокаЗаявки В
	              |					(ВЫБРАТЬ
	              |						СтрокиЗаявкиДокумента.СтрокаЗаявки КАК СтрокаЗаявки
	              |					ИЗ
	              |						СтрокиЗаявкиДокумента КАК СтрокиЗаявкиДокумента)) КАК ЗаявкиПокупателейОстатки
	              |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	              |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = РеализацияТоваровУслугТовары.СтрокаЗаявки
	              |				И (РеализацияТоваровУслугТовары.Ссылка.Проведен)
	              |				И (РеализацияТоваровУслугТовары.Ссылка.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.РеализацияТоваровУслугСборка))
	              |			ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки КАК ЗаказыПоставщикамОстатки
	              |			ПО ЗаявкиПокупателейОстатки.СтрокаЗаявки = ЗаказыПоставщикамОстатки.СтрокаЗаявки
	              |	
	              |	СГРУППИРОВАТЬ ПО
	              |		ЗаявкиПокупателейОстатки.СтрокаЗаявки) КАК ДанныеКЗакрытию
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	ДанныеКЗакрытию.СтрокаЗаявки,
	              |	ДанныеКЗакрытию.КоличествоВСборке,
	              |	ДанныеКЗакрытию.КоличествоОстатокЗаказ
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ДанныеРегистров.СтрокаЗаявки,
	              |	ДанныеРегистров.КоличествоКЗакрытию
	              |ИЗ
	              |	ДанныеРегистров КАК ДанныеРегистров
	              |ГДЕ
	              |	ДанныеРегистров.КоличествоКЗакрытию > 0
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ДанныеРегистров.СтрокаЗаявки,
	              |	ДанныеРегистров.КоличествоВСборке,
	              |	ДанныеРегистров.КоличествоОстатокЗаказ
	              |ИЗ
	              |	ДанныеРегистров КАК ДанныеРегистров
	              |ГДЕ
	              |	ДанныеРегистров.КоличествоКЗакрытию <= 0";
	ЗапросДанныхкОтмене.Текст = ТексЗапроса;
	
	ЗапросДанныхкОтмене.УстановитьПараметр("Период",Период);
	ЗапросДанныхкОтмене.УстановитьПараметр("ДокументСсылка",ПоследняяКорректировка);
	
	Результат = ЗапросДанныхкОтмене.ВыполнитьПакет();
	ВыборкаОтказов = Результат[2].Выбрать();
	ВыборкаОшибок  = Результат[3].Выбрать();
	Пока ВыборкаОшибок.Следующий() цикл 
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,," не удалось проставить отказ  на "+ВыборкаОшибок.СтрокаЗаявки+". В заказе : "
		+ВыборкаОшибок.КоличествоОстатокЗаказ  + " , в сборке" +ВыборкаОшибок.КоличествоВСборке);
	КонецЦикла;
	
	Возврат ВыборкаОтказов;

	
КонецФункции	

#КонецОбласти