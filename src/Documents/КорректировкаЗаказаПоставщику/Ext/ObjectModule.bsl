﻿Перем мЗарегистрироватьИзмененияДляОкнаПоставщика;

Функция ПолучитьОстаткиПоРегиструЗаказовПостащикам(вхОснование) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыПоставщикамОстатки.СтрокаЗаказа КАК СтрокаЗаказа,
	|	ЗаказыПоставщикамОстатки.ЕдиницаИзмерения.Владелец КАК Номенклатура,
	|	ЗаказыПоставщикамОстатки.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗаказыПоставщикамОстатки.ЕдиницаИзмерения.Коэффициент КАК Коэффициент,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток КАК Количество,
	|	ЗаказыПоставщикамОстатки.СуммаУпрОстаток КАК Всего,
	|	ЗаказыПоставщикамОстатки.СостояниеСтрокиЗаказа КАК СостояниеСтрокиЗаказа,
	|	ЗаказыПоставщикамОстатки.СтрокаЗаказа.СтавкаНДС КАК СтавкаНДС,
	|	ЗаказыПоставщикамОстатки.СтрокаЗаказа.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, СтрокаЗаказа.ЗаказПоставщику = &ЗаказПоставщику) КАК ЗаказыПоставщикамОстатки";
	
	//Запрос.УстановитьПараметр("Дата", Дата);
	Если ЗначениеЗаполнено(вхОснование) Тогда
		Запрос.УстановитьПараметр("ЗаказПоставщику", вхОснование);
	Иначе
		Запрос.УстановитьПараметр("ЗаказПоставщику", ДокументОснование);
	КонецЕсли;
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.КорректировкаЗаказаПоставщику.ВыполнитьПроведение(Ссылка, Отказ);
	РегистрыСведений.ДокументыКорректировок.УстановитьКорректировку(Движения.ДокументыКорректировок, Ссылка.ДокументОснование, Ссылка);
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуТоваров(вхОснование = Неопределено) Экспорт
	Товары.Очистить();
	
	ТабТоваров = ПолучитьОстаткиПоРегиструЗаказовПостащикам(вхОснование);
	
	Для Каждого ТекСтрокаТовары Из ТабТоваров Цикл
		НоваяСтрока = Товары.Добавить();
		//НоваяСтрока.Всего = ТекСтрокаТовары.Всего;
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
		НоваяСтрока.Коэффициент = ТекСтрокаТовары.Коэффициент;
		НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
		//НоваяСтрока.СостояниеСтрокиЗаказа = ТекСтрокаТовары.СостояниеСтрокиЗаказа;
		//НоваяСтрока.СтавкаНДС = ТекСтрокаТовары.СтавкаНДС;
		НоваяСтрока.СтрокаЗаказа = ТекСтрокаТовары.СтрокаЗаказа;
		НоваяСтрока.Сумма = ТекСтрокаТовары.Всего;//сумма всегда включает НДС
		НоваяСтрока.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(НоваяСтрока.Сумма, Истина, Истина, УчетНДС.ПолучитьСтавкуНДС(ТекСтрокаТовары.СтрокаЗаказа.СтавкаНДС));
		НоваяСтрока.Цена = Окр(НоваяСтрока.Сумма/НоваяСтрока.Количество,2);
		НоваяСтрока.Комментарий = ТекСтрокаТовары.Комментарий;
		//НоваяСтрока.СуммаНДС = ТекСтрокатовары.СуммаНДС;
		//НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
	КонецЦикла;
	
КонецПроцедуры

Процедура СобратьПредыдущиеПричиныОтказов()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Причины.СтрокаЗаявки,
	|	Причины.ПричинаОтказа,
	|	Причины.Количество,
	|	Причины.КлючСвязи,
	|	Причины.ЗагруженИзОП
	|ИЗ
	|	Документ.ЗаказПоставщику.ПричиныОтказов КАК Причины
	|ГДЕ
	|	Причины.Ссылка = &ДокументОснование
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КоррПричины.СтрокаЗаявки,
	|	КоррПричины.ПричинаОтказа,
	|	КоррПричины.Количество,
	|	КоррПричины.КлючСвязи,
	|	КоррПричины.ЗагруженИзОП
	|ИЗ
	|	Документ.КорректировкаЗаказаПоставщику.ПричиныОтказов КАК КоррПричины
	|ГДЕ
	|	КоррПричины.Ссылка.ДокументОснование = &ДокументОснование
	|	И КоррПричины.Ссылка.Дата < &Дата"
	);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() > 0 Тогда
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Результат, ПричиныОтказов);
		ПричиныОтказов.Свернуть("СтрокаЗаявки,ПричинаОтказа,КлючСвязи,ЗагруженИзОП", "Количество");
		Для Каждого Товар Из Товары Цикл
			пар = Новый Структура("СтрокаЗаявки", Товар.СтрокаЗаявки);
			СтрокиОтказов = ПричиныОтказов.НайтиСтроки(пар);
			Если СтрокиОтказов.Количество() > 0 Тогда
				Товар.КоличествоОтказ = 0;
				Для Каждого СтрокаОтказа Из СтрокиОтказов Цикл
					Товар.КоличествоОтказ =Товар.КоличествоОтказ + СтрокаОтказа.Количество;
				КонецЦикла;
				Товар.Сумма = (Товар.Количество - Товар.КоличествоОтказ) * Товар.Цена;
				Товар.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Товар.Сумма, УчитыватьНДС, СуммаВключаетНДС, Товар.СтавкаНДС);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		//СобратьПредыдущиеПричиныОтказов();
		Возврат;
	//ИначеЕсли НЕ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
	//    Сообщить("Изменить документ вручную пока невозможно.");
	//	Отказ = Истина;
	//	Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УчНДС = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Организация, "УчитыватьНДС");
	
	Для Каждого Товар Из Товары Цикл
		Товар.Сумма = (Товар.Количество - Товар.КоличествоОтказ) * Товар.Цена;
		Товар.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Товар.Сумма, УчНДС, Истина, Товар.СтавкаНДС);
	КонецЦикла;
	
	Если Не ЭтоНовый() Тогда 
		Если РежимЗаписи=РежимЗаписиДокумента.Проведение Или  РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения Тогда 
			СС = ЭтотОбъект.Ссылка;
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	КорректировкаЗаказаПоставщику.Ссылка
			|ИЗ
			|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
			|ГДЕ
			|	КорректировкаЗаказаПоставщику.ДокументОснование = &ДокументОснование
			|	И КорректировкаЗаказаПоставщику.Проведен
			|	И КорректировкаЗаказаПоставщику.Дата >= &Дата
			|
			|УПОРЯДОЧИТЬ ПО
			|	КорректировкаЗаказаПоставщику.Дата УБЫВ"
			);
			Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
			Запрос.УстановитьПараметр("Дата", Дата);
			Результат = Запрос.Выполнить();
			Если Не Результат.Пустой() Тогда 
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				Если Ссылка <> Выборка.Ссылка Тогда 
					Сообщить("Нельзя изменять состояние проведения промежуточных корректировок!");
					Отказ=Истина;
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТорговаяТочка) Тогда
		ТорговаяТочка = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Контрагент, "ОсновнаяТорговаяТочка");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование.Контрагент) И ДокументОснование.Контрагент.РаботатьСОкномПоставщика И НЕ ДокументОснование.ПометкаУдаления И НЕ ДополнительныеСвойства.Свойство("ЗагруженоИзОП") Тогда
		мЗарегистрироватьИзмененияДляОкнаПоставщика = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика, ЭтотОбъект);
	КонецЕсли;
	
	//Добавлено Валиахметов А.А. 01.03.2018 PK83-232				
	ЗаполнениеДокументов.ЗаполнитьКлючиСвязи(ЭтотОбъект);
	//Конец Добавлено Валиахметов А.А. 01.03.2018
	
	//Добавлено Валиахметов А.А. 07.03.2018 PK83-283				
	ОбщегоНазначения.ЗаполнитьДопСвойстваДокумента(ЭтотОбъект, РежимЗаписи);
	//Конец Добавлено Валиахметов А.А. 07.03.2018
	
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма") + ?(СуммаВключаетНДС, 0, Товары.Итог("СуммаНДС") + Услуги.Итог("СуммаНДС"));
	
КонецПроцедуры

Процедура ЗаполнитьДляОтмены(ДанныеЗаполнения) Экспорт
	Дата = ТекущаяДата();
	Контрагент = ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента = ДанныеЗаполнения.ДоговорКонтрагента;
	Организация = ДанныеЗаполнения.Организация;
	Ответственный = ДанныеЗаполнения.Ответственный;
	Комментарий = ДанныеЗаполнения.Комментарий;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ДокументОснование = ДанныеЗаполнения;
	Иначе
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	КонецЕсли;
	Склад = ДанныеЗаполнения.Склад;
	ВалютаДокумент = ДанныеЗаполнения.ВалютаДокумента;
	КратностьВзаиморасчетов = ДанныеЗаполнения.КратностьВзаиморасчетов;
	КурсВзаиморасчетов = ДанныеЗаполнения.КурсВзаиморасчетов;
	КонтактноеЛицоКонтрагента = ДанныеЗаполнения.КонтактноеЛицоКонтрагента;
	СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	ТипЦен = ДанныеЗаполнения.ТипЦен;
	УчитыватьНДС = ДанныеЗаполнения.ТипЦен;
	ЭлектронныйАдрес = Данныезаполнения.ЭлектронныйАдрес;
	
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если мЗарегистрироватьИзмененияДляОкнаПоставщика Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъектВУзлах(ДокументОснование, Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика);
		//ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ДокументОснование, Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	СозданВ77 = Ложь;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Документы.КорректировкаЗаказаПоставщику.ВыполнитьОтменуПроведения(Ссылка, Отказ);
КонецПроцедуры

мЗарегистрироватьИзмененияДляОкнаПоставщика = Ложь;