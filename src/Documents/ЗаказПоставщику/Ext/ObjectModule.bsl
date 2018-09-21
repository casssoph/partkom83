﻿Перем Блокировка Экспорт;
Перем УжеЗаблокирован Экспорт;
Перем мВалютаРегламентированногоУчета Экспорт;
Перем мСтруктураПараметровДляПолученияДоговора Экспорт;
Перем мЗарегистрироватьИзмененияДляСайта;
Перем мЗарегистрироватьИзмененияДляОкнаПоставщика;
Перем мЗарегистрироватьИзмененияДляОбменаFTP;
Перем мЗарегистрироватьИзмененияДляОтправкиНаПочту;

//05.01.16
Функция ПолучитьПоследнююКорректировку(СтатусПриОткрытии = Неопределено) Экспорт
	Запрос = Новый Запрос(
	// Сергеев убираем привязку к статусу заказа-основания
	//"ВЫБРАТЬ ПЕРВЫЕ 1
	//|	КорректировкаЗаказаПоставщику.Ссылка
	//|ИЗ
	//|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
	//|ГДЕ
	//|	КорректировкаЗаказаПоставщику.Проведен
	//|	И КорректировкаЗаказаПоставщику.ДокументОснование = &ДокументОснование" +
	//?(ЗначениеЗаполнено(СтатусПриОткрытии), "
	//|	И КорректировкаЗаказаПоставщику.СтатусДокумента = &Статус", " ") + "
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	КорректировкаЗаказаПоставщику.Дата УБЫВ"
	//);
	
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КорректировкаЗаказаПоставщику.Ссылка
	|ИЗ
	|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
	|ГДЕ
	|	КорректировкаЗаказаПоставщику.Проведен
	|	И КорректировкаЗаказаПоставщику.ДокументОснование = &ДокументОснование
	|УПОРЯДОЧИТЬ ПО
	|	КорректировкаЗаказаПоставщику.Дата УБЫВ"
	);

	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Если ЗначениеЗаполнено(СтатусПриОткрытии) Тогда
		Запрос.УстановитьПараметр("Статус", СтатусПриОткрытии);
	КонецЕсли;
	Р = Запрос.Выполнить();
	
	Если Р.Пустой() Тогда
		Возврат Ссылка;
	КонецЕсли;
	
	Выборка = Р.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

Функция ПолучитьСтруктуруПечатныхФорм() Экспорт

	СтруктураМакетов = Новый Структура;

	СтруктураМакетов.Вставить("ДляОкнаПоставщика",       "Заказ поставщику");

	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура ОбновитьЗаписьСтрокЗаказа(ТабТовары, Статус)
	Если Статус = Справочники.СтатусыДокументов.ПолученОтветПоставщика 
		ИЛИ  Статус = Справочники.СтатусыДокументов.ОбработанПоставщиком Тогда
		СтатусСтроки = Справочники.СтатусыДокументов.ПолученОтветПоставщика;
	ИначеЕсли Статус = Справочники.СтатусыДокументов.НовыйЗаказПоставщику
		ИЛИ Статус = Справочники.СтатусыДокументов.ПроведенЗаказПоставщику
		ИЛИ Статус = Справочники.СтатусыДокументов.ОтправленПоставщику Тогда
		СтатусСтроки = Справочники.СтатусыДокументов.ОтправленПоставщику;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Товар Из ТабТовары Цикл
		Если Товар.СтрокаЗаявки.УдалитьСостояниеЗаказа <> Статус Тогда
			СтрокаЗаявкиОб = Товар.СтрокаЗаявки.ПолучитьОбъект();
			СтрокаЗаявкиОб.Заказ = ЭтотОбъект.Ссылка;
			СтрокаЗаявкиОб.УдалитьСостояниеЗаказа = СтатусСтроки;
			СтрокаЗаявкиОб.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСтрокиЗаказовПриЗагрузке() Экспорт
	ОбновитьЗаписьСтрокЗаказа(Товары, ЭтотОбъект.СтатусДокумента);
	
КонецПроцедуры

Процедура СоздатьКорректировкуЗаказаПоставщику(СтруктураДокумента) Экспорт
	
	РедактироватьПоследнююКорректировкуЗаказа = УправлениеЗаказами.РедактироватьПоследнююКорректировкуЗаказа();
	ПоследняяКорректировка = ОбщегоНазначения.ПолучитьПоследнююКорректировкуЗаказа(Ссылка);
	
	Если СтруктураДокумента.ЭтоНовый Тогда
		ДокументКорректировки = ЭтотОбъект;
		СсылкаНаДокумент = Документы.ЗаказПоставщику.ПолучитьСсылку();
		ЭтотОбъект.УстановитьСсылкуНового(СсылкаНаДокумент);
		ЭтотОбъект.Дата = ТекущаяДата();
	Иначе
		СсылкаНаДокумент = ЭтотОбъект.Ссылка;
		Если СтруктураДокумента.СтруктураШапкиДокумента.СтатусДокумента = Справочники.СтатусыДокументов.НовыйЗаказПоставщику
			ИЛИ СтруктураДокумента.СтруктураШапкиДокумента.СтатусДокумента = Справочники.СтатусыДокументов.ПроведенЗаказПоставщику Тогда
			ДокументКорректировки = ЭтотОбъект;
			Если НЕ ЭтотОбъект.Проведен Тогда
				ЭтотОбъект.Дата = ТекущаяДата();
			КонецЕсли;
		ИначеЕсли РедактироватьПоследнююКорректировкуЗаказа И ТипЗнч(ПоследняяКорректировка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику") Тогда
			ДокументКорректировки = ПоследняяКорректировка.ПолучитьОбъект();
			ДокументКорректировки.ДокументОснование = ЭтотОбъект.Ссылка;
		Иначе
			ДокументКорректировки = Документы.КорректировкаЗаказаПоставщику.СоздатьДокумент();
			ДокументКорректировки.Дата = ТекущаяДата();
			ДокументКорректировки.ДокументОснование = ЭтотОбъект.Ссылка;
			ДокументКорректировки.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЕсли;
	Если СтруктураДокумента.Товары.Колонки.Найти("СсылкаНаДокумент") = Неопределено Тогда
		СтруктураДокумента.Товары.Колонки.Добавить("СсылкаНаДокумент", Новый ОписаниеТипов("ДокументСсылка.ЗаказПоставщику"));
	КонецЕсли;
	СтруктураДокумента.Товары.ЗаполнитьЗначения(СсылкаНаДокумент, "СсылкаНаДокумент");
	Для Каждого КлючИЗначение Из СтруктураДокумента.СтруктураШапкиДокумента Цикл
		//Если КлючИЗначение.Ключ = "ДатаПодтверждения" Тогда
		//	Продолжить;
		//КонецЕсли;
		ДокументКорректировки[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	Если ТипЗнч(ДокументКорректировки) = Тип("ДокументОбъект.КорректировкаЗаказаПоставщику")
		И НЕ ЗначениеЗаполнено(ДокументКорректировки.ДокументОснование) Тогда
		ДокументКорректировки.ДокументОснование = ЭтотОбъект.Ссылка;
	КонецЕсли;
	ДокументКорректировки.Товары.Очистить();
	ДокументКорректировки.ПричиныОтказов.Очистить();
	ДокументКорректировки.Услуги.Очистить();
	Если СтруктураДокумента.ЭтоНовый Тогда
		РазместитьЗаказПоЗаявкамПокупателей(СтруктураДокумента.Товары, ЭтотОбъект.Дата);
	Иначе
		РазместитьЗаказПоЗаявкамПокупателей(СтруктураДокумента.Товары, ДокументКорректировки.Ссылка.МоментВремени());
	КонецЕсли;
		
		
	ОбновитьЗаписьСтрокЗаказа(СтруктураДокумента.Товары, СтруктураДокумента.СтруктураШапкиДокумента.СтатусДокумента);			
		
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СтруктураДокумента.Товары, ДокументКорректировки.Товары);
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СтруктураДокумента.ПричиныОтказов, ДокументКорректировки.ПричиныОтказов);
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(СтруктураДокумента.Услуги, ДокументКорректировки.Услуги);
	
	Если СтруктураДокумента.СтруктураШапкиДокумента.СтатусДокумента = Справочники.СтатусыДокументов.НовыйЗаказПоставщику Тогда
		ДокументКорректировки.Записать(РежимЗаписиДокумента.Запись);
	Иначе
		ДокументКорректировки.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Документы.ЗаказПоставщику.ВыполнитьПроведение(Ссылка, Отказ);
	РегистрыСведений.ДокументыКорректировок.УстановитьКорректировку(Движения.ДокументыКорректировок, Ссылка, Ссылка);
	
	// ЛНА, Замер  APDEX ++(
	Попытка		
		APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("ЗаказПоставщику_Проведение", "Кол-во строк: "+Товары.Количество(), , Ссылка);
	Исключение
	КонецПопытки;
	//)--
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// ЛНА, Замер  APDEX ++(
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ЗаказПоставщику_Проведение");
		
	КонецЕсли;
	//)--
	
	Если не ОбменДанными.Загрузка  Тогда
		Если не ОбщегоНазначения.ПолучитьПоследнююКорректировкуЗаказа(Ссылка) = Ссылка и ПометкаУдаления Тогда
			Сообщить("Это не конечный заказ. Пометка на удаление запрещена!",СтатусСообщения.ОченьВажное);	
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мЗарегистрироватьИзмененияДляОкнаПоставщика = Ложь;
	мЗарегистрироватьИзмененияДляОбменаFTP = Ложь;
	мЗарегистрироватьИзмененияДляОтправкиНаПочту = Ложь;
	
	Если Контрагент.РаботатьСОкномПоставщика И 
		НЕ ДополнительныеСвойства.Свойство("ЗагруженоИзОП")
		И СтатусДокумента = Справочники.СтатусыДокументов.ОтправленПоставщику
		И НЕ ПометкаУдаления
		и Проведен
		И ЗначениеЗаполнено(Склад) И НЕ Склад.СкладVMI Тогда
			мЗарегистрироватьИзмененияДляОкнаПоставщика = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика, ЭтотОбъект);
	КонецЕсли;
	
	НастройкаFTP = ЭлектронныеДокументы.ПолучитьНастройкуFTP(Контрагент, "ЗаказПоставщику", "Товары", Ложь);
	Если НастройкаFTP <> Неопределено 
		И СтатусДокумента = Справочники.СтатусыДокументов.ПроведенЗаказПоставщику
		И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		//только первичная регистрация
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ИсторияОбмена1с8FTP.Объект
		|ИЗ
		|	РегистрСведений.ИсторияОбмена1с8FTP КАК ИсторияОбмена1с8FTP
		|ГДЕ
		|	ИсторияОбмена1с8FTP.Объект = &Объект"
		);
		Запрос.УстановитьПараметр("Объект", Ссылка);
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество() = 0 Тогда
			мЗарегистрироватьИзмененияДляОбменаFTP = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Дата >= Константы.ДатаЗаявкиСоздаютсяВ83.Получить() 
		И СтатусДокумента = Справочники.СтатусыДокументов.ОтправленПоставщику Тогда
		//И ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ИсторияОтправкиПисемПоставщикам.Объект
		|ИЗ
		|	РегистрСведений.ИсторияОтправкиПисемПоставщикам КАК ИсторияОтправкиПисемПоставщикам
		|ГДЕ
		|	ИсторияОтправкиПисемПоставщикам.Объект = &Объект"
		);
		Запрос.УстановитьПараметр("Объект", Ссылка);
		
		Р = Запрос.Выполнить().Выгрузить();
		Если Р.Количество() = 0 Тогда
			мЗарегистрироватьИзмененияДляОтправкиНаПочту = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	СуммаДокумента = ?(СуммаВключаетНДС, Товары.Итог("Сумма") + Услуги.Итог("Сумма"), 
					Товары.Итог("Сумма") + Товары.Итог("СуммаНДС") + Услуги.Итог("Сумма") + Услуги.Итог("СуммаНДС"));
					
	//Добавлено Валиахметов А.А. 01.03.2018 PK83-232				
	ЗаполнениеДокументов.ЗаполнитьКлючиСвязи(ЭтотОбъект);
	//Конец Добавлено Валиахметов А.А. 01.03.2018
	
	//Добавлено Валиахметов А.А. 07.03.2018 PK83-283				
	ОбщегоНазначения.ЗаполнитьДопСвойстваДокумента(ЭтотОбъект, РежимЗаписи);
	//Конец Добавлено Валиахметов А.А. 07.03.2018
	Если (не ОбменДанными.Загрузка И РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения) Или (ПометкаУдаления И не ОбменДанными.Загрузка) Тогда 
		Если СтатусДокумента = Справочники.СтатусыДокументов.ОтправленПоставщику
			Или	СтатусДокумента = Справочники.СтатусыДокументов.ОбработанПоставщиком
			Или СтатусДокумента = Справочники.СтатусыДокументов.ОтгруженПоставщиком
			Или СтатусДокумента = Справочники.СтатусыДокументов.ОтказанПоставщиком Тогда 
			Отказ=Истина;
			Сообщить("Нельзя отменять проведение документа (удалять) в статусе Отправлен поставщику и выше!");
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	//{{ХудинВВ 20180629 ХХ-159, временный костыль
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ИНН = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ИНН"));
		Если Не ЗначениеЗаполнено(ИНН) Тогда
			Отказ = Истина;
			Сообщить("Выбрана организация с незаполненным ИНН!");
		КонецЕсли;
		
	КонецЕсли;
	//}}
	
	//ХХ-242
	Если ПометкаУдаления Тогда
		
		//3. При установке пометки удаления на заказ, проверять что нет проведенных корректировок заказа,
		ПроверитьПроведенныеКорректировки(Отказ);
		
		//пометку удаления ставить на все корректировки заказа
		Если НЕ Отказ Тогда
			Документы.КорректировкаЗаказаПоставщику.ПометитьНаУдалениеКорректировкиПоЗаказу(Ссылка);
		КонецЕсли;
	КонецЕсли;

	// + 20180918 Пушкин XX-628
	Если СтатусДокумента = Справочники.СтатусыДокументов.ОбработанПоставщиком И НЕ ЗначениеЗаполнено(ДатаПодтверждения) тогда
		ДатаПодтверждения = ТекущаяДата();
	КонецЕсли;
	// - 20180918 Пушкин XX-628
			
КонецПроцедуры

#Если Клиент Тогда
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

		Если ЭтоНовый() Тогда
			Предупреждение("Документ можно распечатать только после его записи");
			Возврат;
		ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
			Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
			Возврат;
		КонецЕсли;

		Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;

		// Получить экземпляр документа на печать
		Если ИмяМакета = "ДляОкнаПоставщика" Тогда
			//ТабДокумент = ПечатьЗаказ(ЭтотОбъект.Ссылка);
			ТабДокумент =  документы.ЗаказПоставщику.ПолучитьМакетДляОкнаПоставщика(ЭтотОбъект.Ссылка);
		КонецЕсли;

		УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

	КонецПроцедуры // Печать
#КонецЕсли

Функция ПечатьЗаказ(вхСсылкаНаДокумент) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Макет = Документы.ЗаказПоставщику.ПолучитьМакет("ДляОкнаПоставщика");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	РеквизитыШапки = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(вхСсылкаНаДокумент, 
	"Номер,Дата,Организация,Контрагент,СуммаДокумента");
	Область.Параметры.ТекстЗаголовка = "Заказ №" + РеквизитыШапки.Номер + " от " 
	+ Формат(РеквизитыШапки.Дата, "ДЛФ=DD");
	
	ТабДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Поставщик");
	Область.Параметры.Поставщик = РеквизитыШапки.Контрагент.Наименование;
	ТабДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Покупатель");
	Область.Параметры.Покупатель = РеквизитыШапки.Организация.Наименование;
	ТабДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(Область);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МАКСИМУМ(Корректировки.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ Корректировки
	|ИЗ
	|	Документ.КорректировкаЗаказаПоставщику КАК Корректировки
	|ГДЕ
	|	Корректировки.ДокументОснование = &Ссылка
	|	И Корректировки.СтатусДокумента = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ОтправленПоставщику)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура.Наименование КАК Наименование,
	|	Товары.Номенклатура.Артикул КАК Артикул,
	|	ЕСТЬNULL(Товары.СтрокаЗаявки.АртикулПоставщика, """") КАК АртикулПоставщика,
	|	ЕСТЬNULL(Товары.СтрокаЗаявки.ИзготовительПоставщика, """") КАК Изготовитель,
	|	Товары.Количество,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.СтрокаЗаявки.ПрайсПоставщика.Наименование КАК ПрайсПоставщика,
	|	Товары.Количество КАК КоличествоОтвет,
	|	Товары.СрокГарантированныйЗаказа,
	|	Товары.СтрокаЗаявки.IDSite КАК IDSite,
	|	ЕСТЬNULL(Цены.Номенклатура.МинКолПартии, 1) КАК МинКолПартии
	|ИЗ
	|	Документ.КорректировкаЗаказаПоставщику.Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних КАК Цены
	|		ПО Товары.Номенклатура = Цены.Номенклатура.Номенклатура
	|			И Товары.Ссылка.Контрагент = Цены.ПрайсПоставщика.Владелец
	|ГДЕ
	|	Товары.Ссылка В
	|			(ВЫБРАТЬ
	|				Корректировки.Ссылка
	|			ИЗ
	|				Корректировки КАК Корректировки)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Наименование";
	
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	//Рудаков заполним Регион в печатной форме
	Рег=вхСсылкаНаДокумент.Контрагент.ПолучитьФорму().ФрмРегион;
	ТабЗ = Запрос.Выполнить().Выгрузить();
	 
	//КонтрагентОП = Контрагент.РаботатьСОкномПоставщика;
	Область = Макет.ПолучитьОбласть("Строка");  
	//ДопОбласть = Макет.ПолучитьОбласть("Строка |"+?(КонтрагентОП,"ОП","НЕОП"));
	Для Каждого Товар Из ТабЗ Цикл// Товары Цикл
		Область.Параметры.Заполнить(Товар);
		//область.Параметры.АртикулПоставщика=Товар.АртикулПоставщика;
		//область.Параметры.ПрайсПоставщика=Товар.ПрайсПоставщика;
		//область.Параметры.Артикул=Товар.Артикул;
		//область.Параметры.Изготовитель=Товар.Изготовитель;
		//область.Параметры.IDSite=Товар.Товары;
		//область.Параметры.МинКолПартии=Товар.МинКолПартии;
		//область.Параметры.Регион=Рег;
		//Рудаков конец
		ТабДокумент.Вывести(Область);
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("Итого");
	Область.Параметры.КоличествоСтрок = ТабЗ.Количество();
	Область.Параметры.ИтогСумма = Формат(РеквизитыШапки.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧРГ=");
	ТабДокумент.Вывести(Область);
	ТабДокумент.Показать();
	
	Возврат ТабДокумент;
			
КонецФункции

Процедура ПриКопировании(ОбъектКопирования)
	СтатусДокумента = Справочники.СтатусыДокументов.НовыйЗаказПоставщику;
	СозданВ77 = Ложь;
	Для Каждого Стр Из Товары Цикл
		//Если ЗначениеЗаполнено(Стр.НоменклатураЗамена) Тогда
		//	Стр.НоменклатураЗамена = Справочники.Номенклатура.ПустаяСсылка();
		//	Стр.ЕдиницаИзмеренияЗамена = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
		//	//Стр.КоличествоЗамена = 0;
		//	//Стр.КоличествоОтказ = 0;
		//	//Стр.КоличествоФакт = 0;
		//КонецЕсли;
		//Стр.СостояниеСтрокиЗаказа = Справочники.СостоянияСтрокЗаказов.ЗаказПоставщикуНовая;
		Стр.СтрокаЗаявки = Справочники.ИдентификаторыСтрокЗаявок.ПустаяСсылка();
		Стр.Комментарий = "";
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если РольДоступна("ПолныеПрава") Тогда
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.ПрайсПоставщика.Владелец.Владелец КАК Контрагент,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.Заявка КАК ДокументОснование,
		|	ЗаявкиПокупателейОстатки.Склад,
		|	&СтатусДокумента,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.Заявка.Филиал КАК Филиал,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.ПрайсПоставщика.Владелец КАК ТорговаяТочка,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.ПрайсПоставщика КАК ПрайсПоставщика,
		|	ЗаявкиПокупателейОстатки.Номенклатура КАК Номенклатура,
		|	ЗаявкиПокупателейОстатки.КоличествоОстаток КАК Количество,
		|	ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ЗаявкиПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.СрокГарантированныйЗаказа КАК СрокГарантированныйЗаказа,
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.СрокОжидаемыйЗаказа КАК СрокОжидаемыйЗаказа
		|ИЗ
		|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
		|			,
		|			СтрокаЗаявки.Заявка = &Ссылка) КАК ЗаявкиПокупателейОстатки";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		Запрос.УстановитьПараметр("СтатусДокумента", Справочники.СтатусыДокументов.НовыйЗаказПоставщику);
		
		ОстаткиПоЗаявкам = Запрос.Выполнить().Выгрузить();
		
		Прайсы = ОстаткиПоЗаявкам.ВыгрузитьКолонку("ПрайсПоставщика");
		Если Прайсы.Количество() > 1 Тогда 
			#Если Клиент Тогда
				СписокПрайсов = Новый СписокЗначений;
				Для Каждого Прайс Из Прайсы Цикл
					Если СписокПрайсов.НайтиПоЗначению(Прайс) = Неопределено Тогда
						СписокПрайсов.Добавить(Прайс);
					КонецЕсли;
				КонецЦикла;
				
			#КонецЕсли
		КонецЕсли;	
		
		Организация = ДанныеЗаполнения.Организация;
		Склад = ДанныеЗаполнения.Склад;
		Филиал = ДанныеЗаполнения.Филиал;
		ДокументОснование = ДанныеЗаполнения;
		ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
		КратностьВзаиморасчетов = ДанныеЗаполнения.КратностьВзаиморасчетов;
		КурсВзаиморасчетов = ДанныеЗаполнения.КурсВзаиморасчетов;
		УчитыватьНДС = Истина;
		СуммаВключаетНДС = Истина;
		
		//ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ДанныеЗаполнения.Товары, Товары);
		Для Каждого Товар Из ДанныеЗаполнения.Товары Цикл
			НовТовар = Товары.Добавить();
			НовТовар.Номенклатура = Товар.Номенклатура;
			НовТовар.ЕдиницаИзмерения = Товар.ЕдиницаИзмерения;
			НовТовар.Коэффициент = Товар.Коэффициент;
			НовТовар.Количество = Товар.Количество;
			НовТовар.Цена = Товар.ЦенаЗакупки;
			СтавкаНДС = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Товар.Номенклатура, "СтавкаНДС");
			НовТовар.Сумма = НовТовар.Количество * НовТовар.Цена;
			НовТовар.СуммаНДС =  УчетНДС.РассчитатьСуммуНДС(НовТовар.Сумма, УчитыватьНДС, СуммаВключаетНДС, УчетНДС.ПолучитьСтавкуНДС(СтавкаНДС));
			НовТовар.СрокГарантированныйЗаказа =  Товар.СрокГарантированныйЗаказа;
			НовТовар.СрокОжидаемыйЗаказа = Товар.СрокОжидаемыйЗаказа;
			
		КонецЦикла;
			
	КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если мЗарегистрироватьИзмененияДляОкнаПоставщика тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика);
	КонецЕсли;
	
	Если мЗарегистрироватьИзмененияДляОбменаFTP Тогда
		ЭлектронныеДокументы.ИзменитьРегистрациюДокументаВОбменеFTP(Ссылка, , ТекущаяДата());
	КонецЕсли;
	
	Если мЗарегистрироватьИзмененияДляОтправкиНаПочту Тогда
		//ЭтотОбъект.ДополнительныеСвойства.Вставить("ЗарегистрироватьДляОтправкиНаПочту", Истина);
		ЭлектронныеДокументы.ЗарегистрироватьДляОтправкиПочты(Ссылка);
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказПоставщикуТовары.СтрокаЗаявки
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	|ГДЕ
	|	ЗаказПоставщикуТовары.Ссылка = &Ссылка
	|	И (ЗаказПоставщикуТовары.СтрокаЗаявки.УдалитьСостояниеЗаказа ЕСТЬ NULL
	|			ИЛИ ЗаказПоставщикуТовары.СтрокаЗаявки.УдалитьСостояниеЗаказа = ЗНАЧЕНИЕ(Справочник.СтатусыДокументов.ПустаяСсылка))"
	);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() > 0 Тогда
		ОбновитьЗаписьСтрокЗаказа(Результат, СтатусДокумента);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика);
	
КонецПроцедуры

Процедура РазместитьЗаказПоЗаявкамПокупателей(СтрокиТоваров, МоментРазмещения)
	//Запрос = Новый Запрос(
	//"ВЫБРАТЬ
	//|	Товары.СсылкаНаДокумент,
	//|	&Склад,
	//|	Товары.Номенклатура,
	//|	Товары.Количество,
	//|	Товары.КлючСвязи,
	//|	ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.ВРаботе) КАК СостояниеСтрокиЗаявки
	//|ПОМЕСТИТЬ Товары
	//|ИЗ
	//|	&Товары КАК Товары
	//|ГДЕ
	//|	Товары.СтрокаЗаявки = &Пустая
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	СУММА(ЕСТЬNULL(Заявки.КоличествоОстаток - Заказы.КоличествоПриход, Заявки.КоличествоОстаток)) КАК Количество,
	//|	Заявки.СтрокаЗаявки КАК СтрокаЗаявки,
	//|	Заявки.СтрокаЗаявки.СрокГарантированный КАК СрокГарантированный,
	//|	Заявки.СтрокаЗаявки.СрокОжидаемый КАК СрокОжидаемый,
	//|	Товары.КлючСвязи КАК КлючСвязи
	//|ИЗ
	//|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
	//|			&Период,
	//|			(Склад, Номенклатура, СостояниеСтрокиЗаявки) В
	//|				(ВЫБРАТЬ
	//|					Товары.Склад,
	//|					Товары.Номенклатура,
	//|					Товары.СостояниеСтрокиЗаявки
	//|				ИЗ
	//|					Товары КАК Товары)) КАК Заявки
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Обороты(
	//|				,
	//|				,
	//|				,
	//|				СостояниеСтрокиЗаказа = ЗНАЧЕНИЕ(Справочник.СостоянияСтрокДокументов.Новый)
	//|					И НЕ СтрокаЗаявки.Заказ В
	//|							(ВЫБРАТЬ
	//|								Товары.СсылкаНаДокумент
	//|							ИЗ
	//|								Товары КАК Товары)) КАК Заказы
	//|		ПО Заявки.СтрокаЗаявки = Заказы.СтрокаЗаявки
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Товары КАК Товары
	//|		ПО Заявки.Номенклатура = Товары.Номенклатура
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	Заявки.СтрокаЗаявки,
	//|	Заявки.СтрокаЗаявки.СрокГарантированный,
	//|	Заявки.СтрокаЗаявки.СрокОжидаемый,
	//|	Товары.КлючСвязи
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	СрокОжидаемый"
	//);
	//Запрос.УстановитьПараметр("Склад", Склад);
	//Запрос.УстановитьПараметр("Товары", СтрокиТоваров);
	//Запрос.УстановитьПараметр("Период", МоментРазмещения);
	//Запрос.УстановитьПараметр("Пустая", Справочники.ИдентификаторыСтрокЗаявок.ПустаяСсылка());
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Склад,
	|	Товары.Номенклатура,
	|	Товары.Цена
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|ГДЕ
	|	Товары.СтрокаЗаявки = &Пустая
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Цена,
	|	Заявки.СтрокаЗаявки,
	|	Заявки.СтрокаЗаявки.СрокГарантированныйЗаказа КАК СрокГарантированныйЗаказа,
	|	Заявки.СтрокаЗаявки.СрокОжидаемыйЗаказа КАК СрокОжидаемыйЗаказа,
	|	Заявки.КоличествоОстаток КАК Заявлено,
	|	СУММА(ЕСТЬNULL(Заказы.КоличествоПриход, 0)) КАК Заказано
	|ПОМЕСТИТЬ Остатки
	|ИЗ
	|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
	|			&МоментВремени,
	|			(Склад, Номенклатура) В
	|				(ВЫБРАТЬ
	|					Товары.Склад,
	|					Товары.Номенклатура
	|				ИЗ
	|					Товары КАК Товары)) КАК Заявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Обороты(
	|				,
	|				&МоментВремени,
	|				,
	|				(Склад, Номенклатура) В
	|					(ВЫБРАТЬ
	|						Товары.Склад,
	|						Товары.Номенклатура
	|					ИЗ
	|						Товары КАК Товары)) КАК Заказы
	|		ПО Заявки.СтрокаЗаявки = Заказы.СтрокаЗаявки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Товары КАК Товары
	|		ПО Заявки.Номенклатура = Товары.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Цена,
	|	Заявки.СтрокаЗаявки,
	|	Заявки.СтрокаЗаявки.СрокГарантированныйЗаказа,
	|	Заявки.СтрокаЗаявки.СрокОжидаемыйЗаказа,
	|	Заявки.КоличествоОстаток
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.Номенклатура,
	|	Остатки.Цена,
	|	Остатки.СтрокаЗаявки,
	|	Остатки.СрокГарантированныйЗаказа КАК СрокГарантированный,
	|	Остатки.СрокОжидаемыйЗаказа КАК СрокОжидаемый,
	|	Остатки.Заявлено - Остатки.Заказано КАК Количество
	|ИЗ
	|	Остатки КАК Остатки
	|ГДЕ
	|	Остатки.Заявлено - Остатки.Заказано > 0"	
	);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Товары", СтрокиТоваров);
	Запрос.УстановитьПараметр("МоментВремени", МоментРазмещения);
	Запрос.УстановитьПараметр("Пустая", Справочники.ИдентификаторыСтрокЗаявок.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выгрузить();
	ТаблицаДобавленныхСтрок = Новый ТаблицаЗначений;
	Для Каждого Колонка Из СтрокиТоваров.Колонки Цикл
		ТаблицаДобавленныхСтрок.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	
	Для Каждого Товар Из СтрокиТоваров Цикл
		Если Товар.СтрокаЗаявки <> Справочники.ИдентификаторыСтрокЗаявок.ПустаяСсылка() Тогда
			нс = ТаблицаДобавленныхСтрок.Добавить();
			Для Каждого Колонка Из СтрокиТоваров.Колонки Цикл
				Если Колонка.Имя <> "НомерСтроки" Тогда
					нс[Колонка.Имя] = Товар[Колонка.Имя];
				КонецЕсли;
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		НачальноеКоличество = Товар.Количество;
		ПараметрОтбора = Новый Структура("Номенклатура,Цена", Товар.Номенклатура, Товар.Цена);
		СтрокиОстатковПоЗаявкам = Результат.НайтиСтроки(ПараметрОтбора);
		Для Каждого Остаток Из СтрокиОстатковПоЗаявкам Цикл
			Если НачальноеКоличество <= Остаток.Количество Тогда
				Товар.Количество = НачальноеКоличество;
				Товар.СтрокаЗаявки = Остаток.СтрокаЗаявки;
				Если НЕ ЗначениеЗаполнено(Товар.СрокГарантированныйЗаказа) Тогда
					Товар.СрокГарантированныйЗаказа = Остаток.СрокГарантированный;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(Товар.СрокОжидаемыйЗаказа) Тогда
					Товар.СрокОжидаемыйЗаказа = Остаток.СрокОжидаемый;
				КонецЕсли;
				нс = ТаблицаДобавленныхСтрок.Добавить();
				Для Каждого Колонка Из СтрокиТоваров.Колонки Цикл
					Если Колонка.Имя <> "НомерСтроки" Тогда
						нс[Колонка.Имя] = Товар[Колонка.Имя];
					КонецЕсли;
				КонецЦикла;
				Прервать;
			Иначе
				Товар.Количество = Остаток.Количество;
				НачальноеКоличество = НачальноеКоличество - Остаток.Количество;
				Товар.СтрокаЗаявки = Остаток.СтрокаЗаявки;
				Если НЕ ЗначениеЗаполнено(Товар.СрокГарантированныйЗаказа) Тогда
					Товар.СрокГарантированныйЗаказа = Остаток.СрокГарантированный;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(Товар.СрокОжидаемыйЗаказа) Тогда
					Товар.СрокОжидаемыйЗаказа = Остаток.СрокОжидаемый;
				КонецЕсли;
				нс = ТаблицаДобавленныхСтрок.Добавить();
				Для Каждого Колонка Из СтрокиТоваров.Колонки Цикл
					Если Колонка.Имя <> "НомерСтроки" Тогда
						нс[Колонка.Имя] = Товар[Колонка.Имя];
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Товар Из ТаблицаДобавленныхСтрок Цикл
		Товар.Сумма = Товар.Количество * Товар.Цена;
		Товар.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Товар.Сумма, ЭтотОбъект.УчитыватьНДС, ЭтотОбъект.СуммаВключаетНДС, Товар.СтавкаНДС);
	КонецЦикла;
	
	СтрокиТоваров.Очистить();
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаДобавленныхСтрок, СтрокиТоваров);
	
КонецПроцедуры

Процедура ОтменитьВсеКорректировкиДляСтатуса(Статус) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КорректировкаЗаказаПоставщику.Ссылка
	|ИЗ
	|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
	|ГДЕ
	|	КорректировкаЗаказаПоставщику.ДокументОснование = &ДокументОснование
	|	И КорректировкаЗаказаПоставщику.СтатусДокумента = &СтатусДокумента"
	);
	Запрос.УстановитьПараметр("ДокументОснование", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("СтатусДокумента", Статус);
	
	Для Каждого СтрокаРезультата Из Запрос.Выполнить().Выгрузить() Цикл
		Док = СтрокаРезультата.Ссылка.ПолучитьОбъект();
		Док.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	//ХХ-242
	//2. Запретить распроводить заказ если есть проведенные корректировки (их распроведение должно происходить последовательно от новой к старой) 
	ПроверитьПроведенныеКорректировки(Отказ);	
	
	Документы.ЗаказПоставщику.ВыполнитьОтменуПроведения(Ссылка, Отказ);
	
	
КонецПроцедуры

Процедура ПроверитьПроведенныеКорректировки(Отказ)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ПроведенныеКорректировки = Документы.КорректировкаЗаказаПоставщику.КорректировкиПоЗаказу(Ссылка, "Проведен");
	КоличествоПроведенных = ПроведенныеКорректировки.Количество();
	Если КоличествоПроведенных > 0 Тогда
		Отказ = Истина;
		Сообщить("Нельзя отменить проведение (удалить) документ. По заказу есть проведенные корректировки: "+КоличествоПроведенных+" документ(-ов)!");
	КонецЕсли;
	
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДляПолученияДоговора = ЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПокупки();

