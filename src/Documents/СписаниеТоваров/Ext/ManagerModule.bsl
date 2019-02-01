﻿
//// ОБРАБОТЧИКИ МОДУЛЯ ОБЪЕКТА

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	//Если Не ПараметрыСеанса.ОпределятьСтратегиюПогашенияПартийТоваровПоСкладу Тогда
	//	ПроведениеДокументовКлиентСервер.ПогашениеПартийТоваров(вхСсылкаНаДокумент, вхПараметры);
	//КонецЕсли;
	
	лКонтроль = Неопределено;
	лФильтр = Неопределено;
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДанныеОбъекта.Контроль", лКонтроль);
	ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "Фильтр", лФильтр);	

	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ТоварыНаСкладах") тогда
		ПроведениеДокументовКлиентСервер.КонтрольОстатков(вхСсылкаНаДокумент, вхОтказ,,вхПараметры);
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ТоварыНаСкладах",
		РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
	//Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваровУпр") тогда
	//	ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ПартииТоваровУпр",
	//	РегистрыНакопления_ПартииТоваровУпр(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	//КонецЕсли;
	
	//Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") ИЛИ ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваровVMI") Тогда
	//	
	//	Структура = ПроведениеДокументовКлиентСервер.ПогашениеПартийТоваровНовое(вхСсылкаНаДокумент, вхОтказ);
	//	
	//	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") Тогда
	//		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ПартииТоваров", Структура.ПартииТоваров);
	//	КонецЕсли;
	//	
	//	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваровVMI") Тогда
	//		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ПартииТоваровVMI", Структура.ПартииТоваровVMI);
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваров") тогда
		
		лОчищать = ПроведениеДокументовКлиентСервер.НеобходимоОчиститьДвиженияПартииТоваров(вхСсылкаНаДокумент, лФильтр);		
		
		НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
		
		Если лОчищать тогда
			Если лФильтр = Неопределено Тогда 
				ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);
				лБазовая = Неопределено;
				ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ПартииТоваров", лБазовая);
			Иначе
				// Очищаем только движения по фильтру
				лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
				лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
				ОбщегоНазначения.ЗаписатьДвиженияДокументаБезОбработки(вхСсылкаНаДокумент, РегистрыНакопления.ПартииТоваров, лРазделенныеБазовая.Исключенные, Истина); 
				лБазовая = лРазделенныеБазовая.Исключенные;
			КонецЕсли;
		Иначе
			лБазовая = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров);	
		КонецЕсли;
		
		лРазделенныеБазовая = РаботаСПоследовательностямиКлиентСервер.РазделенныеДанные(лБазовая, лФильтр);
		лИсходная = лРазделенныеБазовая.Включенные;
		
		Структура = ПроведениеДокументовКлиентСервер.ПогашениеПартийТоваровНовое(вхСсылкаНаДокумент, вхОтказ, ,лФильтр);
		Если Не вхОтказ	Тогда 			
			лТребуемая = Структура.ПартииТоваров;
			
			//Удалим служебные колонки 
			ОбщегоНазначения.УдалитьКолонки(лИсходная, лТребуемая);
			
			лРазностныеДанные = РаботаСПоследовательностямиКлиентСервер.РазностныеДанные(лИсходная, лТребуемая); 
			ПроведениеДокументовКлиентСервер.ЗаписатьДвижения(вхСсылкаНаДокумент, Метаданные.РегистрыНакопления.ПартииТоваров,
			лРазностныеДанные, лРазделенныеБазовая.Исключенные);
			
			ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
			Если лФильтр = Неопределено Тогда 
				РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Истина);
			КонецЕсли;
			ПроведениеДокументовКлиентСервер.ЗаписатьИзмененныеДвижения(вхСсылкаНаДокумент, лФильтр, Структура.ПартииТоваровVMI, Метаданные.РегистрыНакопления.ПартииТоваровVMI);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьОтменуПроведения(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	ПроведениеДокументовКлиентСервер.ОчиститьДвиженияДокумента(вхСсылкаНаДокумент);
	ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, Метаданные.Последовательности.ПартионныйУчет, вхПараметры);
	
	РаботаСПоследовательностямиКлиентСервер.ЗарегистрироватьОбъектПоСсылке(вхСсылкаНаДокумент, "ПартионныйУчет", Ложь);
КонецПроцедуры

//// ТАБЛИЦЫ ДВИЖЕНИЙ ДОКУМЕНТОВ

Функция РегистрыНакопления_ТоварыНаСкладах(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт 
	ТабТоваров = Неопределено;
	ОбщегоНазначения.СоздатьСтруктуруРегистраНакопления("ТоварыНаСкладах", ТабТоваров);
	
	ДатаДокумента =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	Если ДатаДокумента < глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Если ДатаДокумента < ПараметрыСеанса.ДатаНачалаРаботыТовары Тогда
		Возврат ТабТоваров;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ВидДвижения,
	|	СписаниеТоваровТовары.Ссылка КАК Регистратор,
	|	СписаниеТоваровТовары.Ссылка.Дата КАК Период,
	|	СписаниеТоваровТовары.Ссылка.Склад КАК Склад,
	|	СписаниеТоваровТовары.Номенклатура,
	|	СписаниеТоваровТовары.Качество,
	|	СписаниеТоваровТовары.Количество
	|ИЗ
	|	Документ.СписаниеТоваров.Товары КАК СписаниеТоваровТовары
	|ГДЕ
	|	СписаниеТоваровТовары.Ссылка = &Ссылка";
	
		
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабТоваров);
	
	Возврат ТабТоваров;
	
КонецФункции

//// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ТаблицыДляРасчетаСписанияПоПартиям(вхСсылкаНаДокумент, вхФильтр = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СписаниеТоваровТовары.Номенклатура КАК Номенклатура,
	               |	СписаниеТоваровТовары.Ссылка.Склад КАК Склад,
	               |	СписаниеТоваровТовары.Качество,
	               |	СписаниеТоваровТовары.СтрокаПрихода КАК СтрокаПрихода,
	               |	СписаниеТоваровТовары.СтрокаПрихода = &ПустаяСтрокаПрихода КАК ПустаяСтрокаПрихода,
	               |	ВЫБОР
	               |		КОГДА СписаниеТоваровТовары.Ссылка.Склад.СкладVMI
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.ПринятыйНаОтветХранение)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыПартии.Собственный)
	               |	КОНЕЦ КАК СтатусПартии,
	               |	СписаниеТоваровТовары.Количество КАК Количество,
	               |	""Cписание"" КАК ВидСписания,
	               |	СписаниеТоваровТовары.Ссылка.Склад.СкладVMI КАК ОприходоватьПоVMI,
	               |	СписаниеТоваровТовары.Ссылка.Организация КАК Организация,
	               |	СписаниеТоваровТовары.НомерСтроки КАК НомерСтрокиВДокументе
	               |ИЗ
	               |	Документ.СписаниеТоваров.Товары КАК СписаниеТоваровТовары
	               |ГДЕ
	               |	СписаниеТоваровТовары.Ссылка = &Ссылка";
	Если ТипЗнч(вхФильтр) = Тип("Структура") и вхФильтр.Свойство("Номенклатура") Тогда 
		Запрос.Текст = Запрос.Текст + " И СписаниеТоваровТовары.Номенклатура = &Номенклатура";
		Запрос.УстановитьПараметр("Номенклатура", вхФильтр.Номенклатура);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ПустаяСтрокаПрихода", Справочники.ИдентификаторыСтрокПриходов.ПустаяСсылка());
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ТаблицаДляКонтроляОстатков(вхСсылкаНаДокумент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.Ссылка.Склад КАК Склад,
	               |	Док.Номенклатура КАК Номенклатура,
	               |	Док.Качество КАК Качество,
	               |	СУММА(Док.Количество) КАК Количество
	               |ИЗ
	               |	Документ.СписаниеТоваров.Товары КАК Док
	               |ГДЕ
	               |	Док.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Док.Ссылка.Склад,
	               |	Док.Номенклатура,
	               |	Док.Качество";
				   
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ПолучитьМетаданные()
	Возврат Метаданные.Документы.СписаниеТоваров;
КонецФункции

Функция ПолучитьРеквизитыКонтроля(вхПараметр = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Если (вхПараметр = Метаданные.ПланыОбмена.ОбменПартКом83_77) тогда
		Результат = ОбменДаннымиКлиентСервер.РеквизитыКонтроляПоДокументу(ПолучитьМетаданные(), ИсключаемыеРеквизитыКонтроляРегистрации());
	Иначе
		Результат.Вставить("Шапка", "Дата,Проведен");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИсключаемыеРеквизитыКонтроляРегистрации() Экспорт
	
	ИсключаемыеРеквизиты = ОбменДаннымиКлиентСервер.ИнициализироватьТаблицуИсключаемыхРеквизитовКонтроля();
	ОбменДаннымиКлиентСервер.ДобавитьВИсключаемыеРевизиты(ИсключаемыеРеквизиты, "Ссылка");
	
	Возврат ИсключаемыеРеквизиты;
	
КонецФункции

Функция ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр = Неопределено) Экспорт
	Возврат	РаботаСПоследовательностямиКлиентСервер.ПолучитьЗначенияРеквизитовКонтроля(вхСсылкаНаОбъект, вхПараметр);
КонецФункции

Функция ПолучитьДанныеГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхФильтр = Неопределено) Экспорт
	
	Результат = Неопределено;
	лМетаданныеПоследовательности = Неопределено;
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеГраницПоследовательности]: неправильный параметр номер 2.";	
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) Тогда
		Результат = ПроведениеДокументовКлиентСервер.ЗначенияДвиженийДокумента(вхСсылкаНаДокумент,
		Метаданные.РегистрыНакопления.ПартииТоваров, вхФильтр);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.НачатьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Процедура ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры = Неопределено)
	РаботаСПоследовательностямиКлиентСервер.ЗакончитьКорректировкуГраницПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, вхПараметры);	
КонецПроцедуры

Функция ПолучитьЗаписиПоследовательности(вхСсылкаНаДокумент, вхПоследовательность, Проведение) Экспорт 
	
	лМетаданныеПоследовательности = Неопределено;	
	Если (ТипЗнч(вхПоследовательность) = Тип("Строка")) тогда
		лМетаданныеПоследовательности = Метаданные.Последовательности.Найти(вхПоследовательность);
	ИначеЕсли (ТипЗнч(вхПоследовательность) = Тип("ОбъектМетаданных")) И Метаданные.Последовательности.Содержит(вхПоследовательность) тогда
		лМетаданныеПоследовательности = вхПоследовательность;
	КонецЕсли;
	
	Если (лМетаданныеПоследовательности = Неопределено) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	лМетаданныеДокумента = вхСсылкаНаДокумент.Метаданные();
	Если НЕ лМетаданныеПоследовательности.Документы.Содержит(лМетаданныеДокумента) тогда
		ВызватьИсключение "[ПолучитьДанныеДляПоследовательности]: неправильный параметр номер 1.";
	КонецЕсли;
	
	Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(вхСсылкаНаДокумент, "Дата");
	лРезультат = ОбщегоНазначения.СоздатьСтруктуруПоследовательности(лМетаданныеПоследовательности);
	Если (лМетаданныеПоследовательности = Метаданные.Последовательности.ПартионныйУчет) тогда
		Если Проведение 
			И Дата >= ПараметрыСеанса.ДатаНачалаРаботыТовары 
			И Дата >= глЗначениеПеременной("ДатаЗапускаПервогоЭтапа") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
			               |	СписаниеТоваровТовары.Ссылка.Дата КАК Период,
			               |	СписаниеТоваровТовары.Ссылка КАК Регистратор,
			               |	СписаниеТоваровТовары.Номенклатура КАК Номенклатура
			               |ИЗ
			               |	Документ.СписаниеТоваров.Товары КАК СписаниеТоваровТовары
			               |ГДЕ
			               |	СписаниеТоваровТовары.Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(лРезультат.Добавить(), Выборка); 
			КонецЦикла;
		КонецЕсли;
		
		Результат = ПроведениеДокументовКлиентСервер.ПолучитьМоментыВремени(лМетаданныеПоследовательности, лРезультат);
		
	Иначе
		
		ВызватьИсключение "[ПолучитьЗаписиПоследовательности]: неправильный параметр номер 1.";
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

//Выгрузка при обмене
Функция ВыгрузитьЭлементы(вхТаблицаСсылокНаОбъекты, вхПланОбмена) Экспорт
	
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
	
	Если лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog 
		Или лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ Тогда 
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		
		лЗапрос = Новый Запрос;
		лЗапрос.УстановитьПараметр("ТаблицаСсылок", вхТаблицаСсылокНаОбъекты);
		лЗапрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
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
		|	ПартииТоваров.Регистратор,
		|	ПартииТоваров.НомерСтрокиВДокументе,
		|	МАКСИМУМ(ПартииТоваров.СтрокаПрихода) КАК СтрокаПрихода
		|ПОМЕСТИТЬ втПартии
		|ИЗ
		|	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
		|ГДЕ
		|	ПартииТоваров.Регистратор В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты)
		|	И ПартииТоваров.СтрокаПрихода.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
		|	И ПартииТоваров.СтрокаПрихода.СтранаПроисхождения <> ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПартииТоваров.Регистратор,
		|	ПартииТоваров.НомерСтрокиВДокументе
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втПартии.Регистратор,
		|	втПартии.НомерСтрокиВДокументе,
		|	втПартии.СтрокаПрихода.НомерГТД.Код КАК ГТД,
		|	втПартии.СтрокаПрихода.СтранаПроисхождения.Код КАК СтранаКод,
		|	втПартии.СтрокаПрихода.СтранаПроисхождения.Наименование КАК СтранаНаименование
		|ПОМЕСТИТЬ втПартии2
		|ИЗ
		|	втПартии КАК втПартии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписаниеТоваров.Ссылка КАК Ссылка,
		|	СписаниеТоваров.Номер КАК Номер,
		|	СписаниеТоваров.Дата КАК Дата,
		|	СписаниеТоваров.Организация КАК Организация,
		|	СписаниеТоваров.Склад.ФизическийСклад КАК Склад,
		|	СписаниеТоваров.СуммаДокумента КАК СуммаДокумента,
		|	ЕСТЬNULL(СписаниеТоваров.Склад.ФизическийСклад.КонтрагентТопЛог.ОсновнаяТорговаяТочка, ЗНАЧЕНИЕ(Справочник.ТорговыеТочки.ПустаяСсылка)) КАК Контрагент,
		|	"""" КАК ТипДоставки,
		|	СписаниеТоваровТовары.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(СписаниеТоваровТовары.Номенклатура.Наименование, """") КАК НоменклатураНаименование,
		|	ЕСТЬNULL(СписаниеТоваровТовары.Номенклатура.Артикул, """") КАК НоменклатураАртикул,
		|	ЕСТЬNULL(СписаниеТоваровТовары.СтрокаЗаявки.IDSite, """") КАК SSID,
		|	ВЫБОР
		|		КОГДА СписаниеТоваровТовары.СтрокаЗаявки.ПрайсПоставщика.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК КроссСток,
		|	СписаниеТоваровТовары.Количество КАК Количество,
		|	СписаниеТоваровТовары.Цена,
		|	НЕОПРЕДЕЛЕНО КАК Клиент,
		|	ЕСТЬNULL(СписаниеТоваров.АктРассмотренияВозврата.Контрагент.ОсновнаяТорговаяТочка.Наименование, """") КАК КлиентНаименование,
		|	ЕСТЬNULL(СписаниеТоваров.АктРассмотренияВозврата.Контрагент.ЮрФизЛицо.Порядок, 0) = 0 КАК ЭтоЮридическоеЛицо,
		|	"""" КАК МаршрутДоставкиКод,
		|	"""" КАК МаршрутДоставкиНаименование,
		|	КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ) КАК ДатаОтгрузки,
		|	ЕСТЬNULL(СписаниеТоваровТовары.СтрокаЗаявки.Заявка.ТорговаяТочка.Город, ЗНАЧЕНИЕ(Справочник.Города.ПустаяСсылка)) КАК Город,
		|	ЕСТЬNULL(СписаниеТоваровТовары.СтрокаЗаявки.Заявка.ТорговаяТочка.Город.Наименование, """") КАК ГородНаименование,
		|	ПРЕДСТАВЛЕНИЕ(ТИПЗНАЧЕНИЯ(СписаниеТоваров.Ссылка)) КАК ВидДокумента,
		|	ЕСТЬNULL(СписаниеТоваров.АктРассмотренияВозврата.Контрагент.ПокупательИзДрБазы, ЛОЖЬ) КАК ПокупательИзДрБазы,
		|	ЕСТЬNULL(втПартии2.ГТД, """") КАК ГТД,
		|	ЕСТЬNULL(втПартии2.СтранаКод, """") КАК СтранаКод,
		|	ЕСТЬNULL(втПартии2.СтранаНаименование, """") КАК СтранаНаименование,
		|	ЕСТЬNULL(СписаниеТоваровТовары.СтрокаЗаявки.Заявка.НомерРозничнойЗаявки, """") КАК НомерРозничнойЗаявки
		|ИЗ
		|	Документ.СписаниеТоваров КАК СписаниеТоваров
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеТоваров.Товары КАК СписаниеТоваровТовары
		|			ЛЕВОЕ СОЕДИНЕНИЕ втПартии2 КАК втПартии2
		|			ПО СписаниеТоваровТовары.Ссылка = втПартии2.Регистратор
		|				И СписаниеТоваровТовары.НомерСтроки = втПартии2.НомерСтрокиВДокументе
		|		ПО (СписаниеТоваровТовары.Ссылка = СписаниеТоваров.Ссылка)
		|ГДЕ
		|	СписаниеТоваров.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты)
		|	И СписаниеТоваровТовары.Ссылка В
		|			(ВЫБРАТЬ
		|				Объекты.Ссылка
		|			ИЗ
		|				Объекты)
		|	И СписаниеТоваровТовары.Количество > 0
		|ИТОГИ
		|	МАКСИМУМ(Контрагент),
		|	МАКСИМУМ(ТипДоставки),
		|	МАКСИМУМ(МаршрутДоставкиКод),
		|	МАКСИМУМ(ДатаОтгрузки),
		|	МАКСИМУМ(НомерРозничнойЗаявки)
		|ПО
		|	Ссылка";
		
		лРезультатЗапрос = лЗапрос.Выполнить();
		
		Если НЕ лРезультатЗапрос.Пустой() Тогда
			//SQL Запрос
			ТаблицаДляВыгрузки = лРезультатЗапрос.Выгрузить();
			СтрокиДляЗапросаSQL = ТаблицаДляВыгрузки.НайтиСтроки(Новый Структура("ПокупательИзДрБазы", Истина));
			ВремТаблица = ТаблицаДляВыгрузки.Скопировать(СтрокиДляЗапросаSQL, "SSID");
			ВремТаблица.Свернуть("SSID");
			
			Строка_site_ID = "";
			
			Для Каждого СтрокаДляЗапросаSQL Из ВремТаблица Цикл 
				Если ЗначениеЗаполнено(СтрокаДляЗапросаSQL.SSID) Тогда 
					Строка_site_ID = Строка_site_ID + "'" + СтрокаДляЗапросаSQL.SSID + "',";
				КонецЕсли;
			КонецЦикла;
			
			СоотвSSIDКлиентов = Новый Соответствие;
			Если Не ПустаяСтрока(Строка_site_ID) Тогда 
				Строка_site_ID = Лев(Строка_site_ID, СтрДлина(Строка_site_ID) - 1);	
				ОбменДаннымиВызовСервера.ЗаполнитьСоответствиеSSIDИКлиентов(СоотвSSIDКлиентов, Строка_site_ID);
			КонецЕсли;
			
			лТипОбъектаXDTO = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ЗаказНаОтгрузку");
			лВыборка = лРезультатЗапрос.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Ссылка");
			
			Пока лВыборка.Следующий() Цикл
				лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
				
				ЗаполнитьЗначенияСвойств(лОбъект, лВыборка, "Номер,Дата,СуммаДокумента,ТипДоставки,ДатаОтгрузки,НомерРозничнойЗаявки");
				
				лОбъект.ВидДокумента = "СписаниеТоваров";
				лОбъект.Ссылка = XMLСтрока(лВыборка.Ссылка);
				лОбъект.СкладСсылка = XMLСтрока(лВыборка.Склад);
				лОбъект.КонтрагентСсылка = XMLСтрока(лВыборка.Контрагент);
				лОбъект.ОрганизацияСсылка = XMLСтрока(лВыборка.Организация);
				лОбъект.МаршрутДоставкиКод = лВыборка.МаршрутДоставкиКод;
				лОбъект.СкладПолучательСсылка = XMLСтрока(Справочники.Склады.ПустаяСсылка());
				
				ОбменДаннымиКлиентСервер.ДополнитьДаннымиПоПечати(лОбъект, лВыборка.Ссылка);
				
				лТовары = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ЗаказНаОтгрузку.Товары"));
				лТоварыСписок = лТовары.ПолучитьСписок("СтрокаТовары");
				
				ВыборкаПоТоварам = лВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаПоТоварам.Следующий() Цикл
					НоваяСтрока = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), лТоварыСписок.ВладеющееСвойство.Тип.Имя)); 
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоТоварам, "НоменклатураНаименование,НоменклатураАртикул,SSID,КроссСток,Количество,Цена,ЭтоЮридическоеЛицо,ГТД,СтранаКод,СтранаНаименование");
					НоваяСтрока.НоменклатураСсылка = XMLСтрока(ВыборкаПоТоварам.Номенклатура);
					Если Не лВыборка.ПокупательИзДрБазы Тогда 
						НоваяСтрока.КлиентСсылка = XMLСтрока(ВыборкаПоТоварам.Клиент);
						НоваяСтрока.КлиентНаименование = ВыборкаПоТоварам.КлиентНаименование;
					Иначе
						КлиентСсылка = СоотвSSIDКлиентов[ВыборкаПоТоварам.SSID];
						Если КлиентСсылка = Неопределено Тогда 
							КлиентСсылка = "";
						КонецЕсли;
						НоваяСтрока.КлиентСсылка = КлиентСсылка;
						НоваяСтрока.КлиентНаименование = "";
					КонецЕсли;
					//НоваяСтрока.ГородСсылка = XMLСтрока(ВыборкаПоТоварам.Город);
					
					лТоварыСписок.Добавить(НоваяСтрока);
					
				КонецЦикла;	
				лОбъект.Товары = лТовары;
				
				
				Результат.Добавить(лОбъект);
				
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьЭлемент(ОбъектXDTO, вхОтправитель, Отказ, вхПараметры = Неопределено) Экспорт
	
	лМетаданныеПланаОбмена = Метаданные.НайтиПоТипу(ТипЗнч(вхОтправитель));
	Если (лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog
		Или лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ) Тогда 
		НомерПотока = ?(лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1);
		
		Если ОбъектXDTO.Тип().Имя = "РезультатСборки" Тогда  
			Попытка
				ЗагрузитьРезультатСборки(ОбъектXDTO, вхПараметры);
				СтруктураОшибки = Новый Структура;
				СтруктураОшибки.Вставить("ОбъектXDTO", ОбъектXDTO.Тип().Имя);
				СтруктураОшибки.Вставить("GUID", ОбъектXDTO.ЗаказСсылка);
				СтруктураОшибки.Вставить("ИмяОбъектаМетаданных", "СписаниеТоваров");
				ОбменДаннымиКлиентСервер.ОчиститьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
			Исключение
				СтруктураОшибки = Новый Структура;
				СтруктураОшибки.Вставить("ОбъектXDTO", ОбъектXDTO.Тип().Имя);
				СтруктураОшибки.Вставить("GUID", ОбъектXDTO.ЗаказСсылка);
				СтруктураОшибки.Вставить("ИмяОбъектаМетаданных", "СписаниеТоваров");
				СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
				СтруктураОшибки.Вставить("НомерСообщения", вхПараметры.НомерСообщения);
				СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
				СтруктураОшибки.Вставить("НомерПотока", НомерПотока);
				ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
				
				Если ЗначениеЗаполнено(ОбъектXDTO.ЗаказСсылка) Тогда 
					ДокСсылка = Документы.СписаниеТоваров.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.ЗаказСсылка));
				Иначе
					ДокСсылка = Документы.СписаниеТоваров.НайтиПоНомеру(ОбщегоНазначения.ПреобразоватьНомер(ОбъектXDTO.ЗаказНомер), ТекущаяДата());
				КонецЕсли;
				РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ДокСсылка, вхПараметры.НомерСообщения, Истина, "Ошибка загрузки: "+ОписаниеОшибки(), , Ложь, НомерПотока); 
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьРезультатСборки(ОбъектXDTO, вхПараметры)
	
	Если ЗначениеЗаполнено(ОбъектXDTO.ЗаказСсылка) Тогда 
		ДокСсылка = Документы.СписаниеТоваров.ПолучитьСсылку(Новый УникальныйИдентификатор(ОбъектXDTO.ЗаказСсылка));
		
		Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ДокСсылка) Тогда 
			ВызватьИсключение "Не найдено списание товаров товаров с guid = " + ОбъектXDTO.ЗаказСсылка;
		КонецЕсли;
	Иначе
		ДокСсылка = Документы.СписаниеТоваров.НайтиПоНомеру(ОбщегоНазначения.ПреобразоватьНомер(ОбъектXDTO.ЗаказНомер), ТекущаяДата());
		Если Не ЗначениеЗаполнено(ДокСсылка) Тогда 
			ВызватьИсключение "Не найдено списание товаров с номером = " + ОбъектXDTO.ЗаказНомер;
		КонецЕсли;
	КонецЕсли;
	
	СтатусДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокСсылка, "СтатусДокумента");
	
	Если СтатусДокумента = Справочники.СтатусыДокументов.СписаниеТоваровНовый Тогда
		
		ДокОбъект = ДокСсылка.ПолучитьОбъект();
		ДокОбъект.СтатусДокумента = Справочники.СтатусыДокументов.СписаниеТоваровСписан;
		ДокОбъект.ДополнительныеСвойства.Вставить("ОтключитьКонтрольОстатков");
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
	НомерСообщения = ?(вхПараметры = Неопределено, 0, вхПараметры.НомерСообщения);
	НомерПотока = ?(вхПараметры = Неопределено, 0, вхПараметры.НомерПотока);
	РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ДокСсылка, НомерСообщения, , , , Ложь, НомерПотока); 
	
КонецПроцедуры


