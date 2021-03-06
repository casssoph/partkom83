﻿
&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	МассивВидов = новый Массив ;

	Объект.Документы.Очистить();
	
	Для каждого ВидДокумента из  СписокВидовДокументов цикл 
		если ВидДокумента.Пометка тогда 
			МассивВидов.Добавить(ВидДокумента.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	Если НЕ МассивВидов.Количество() тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрано ниодного вида документа");
		Возврат;
	КонецЕсли;	
	
	  	
	мДатаОкончания = ?(ЗначениеЗаполнено(Период.ДатаОкончания), КонецДня(Период.ДатаОкончания), КонецДня(Дата(3999,12,31))); //Приводим дату окончания
	
	Если мДатаОкончания - Период.ДатаНачала > 30*24*60*60 Тогда 
		ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьПериод_Завершение", ЭтотОбъект,МассивВидов),"Вы выбрали период поиска больше 30 дней. Это может занять продолжительное время.Продолжить?",РежимДиалогаВопрос.ДаНет,60,КодВозвратаДиалога.Нет);
	иначе 
		ВыполнитьПоискНаКлиенте(МассивВидов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтруктураФоногоЗадания(Гуид,МассивВидов)
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Гуид);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "Выполнить поиск ноьменклатуры";
	ПараметрыПроцедуры = новый Структура();
	ПараметрыВыполнения.ОжидатьЗавершение = истина;
	ПараметрыПроцедуры.Вставить("МассивВидов",МассивВидов);
	ПараметрыПроцедуры.Вставить("Номенклатура",Объект.Номенклатура);
	ПараметрыПроцедуры.Вставить("ДатаНачала",период.ДатаНачала);
	ПараметрыПроцедуры.Вставить("ДатаОкончания",период.ДатаОкончания);
Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки.ПоискНоменклатуры.ВыполнитьПоискНоменклатуры", ПараметрыПроцедуры, ПараметрыВыполнения);;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоискНаКлиенте(МассивВидов)
	  	РезультатФоновогоЗадания = СтруктураФоногоЗадания(УникальныйИдентификатор, МассивВидов);
	ЗаданиеВыполняется = Истина;
	Пока ЗаданиеВыполняется цикл
	
	Если РезультатФоновогоЗадания.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатФоновогоЗадания.КраткоеПредставлениеОшибки);
		ЗаданиеВыполняется = ложь; 
		
	КонецЕсли;
	
	ФЗИдентификатор  = РезультатФоновогоЗадания.ИдентификаторЗадания;
	ФЗАдресХранилища = РезультатФоновогоЗадания.АдресРезультата;
	
	Если  ТипЗнч(ПолучитьИзВременногоХранилища(ФЗАдресХранилища)) = Тип("ТаблицаЗначений") Тогда
		ЗаданиеВыполняется = ложь;
		ТаблицаРезультат =  ПолучитьИзВременногоХранилища(ФЗАдресХранилища);
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаРезультат, Объект.Документы);
		
	КонецЕсли;
	 КонецЦикла;

	
КонецПроцедуры	


&НаКлиенте
Процедура ВыполнитьПериод_Завершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.ДА Тогда 
		ВыполнитьПоискНаКлиенте(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПредлагатьТолькоОсновныеДокументыПриИзменении(Элемент)
ЗаполнитьВидыДокументов();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыДокументов()
	Массив = Новый Массив;
	
	Массив.Добавить("РеализацияТоваровУслуг");
	Массив.Добавить("ПоступлениеТоваровУслуг");
	Массив.Добавить("ЗаявкаПокупателя");
	Массив.Добавить("ЗаказПоставщику");
	Массив.Добавить("АктРассмотренияВозврата");
	Массив.Добавить("ВозвратТоваровОтПокупателя");
	Массив.Добавить("ВозвратТоваровПоставщику");
	
	СписокВидовДокументов.Очистить();
	
	Для Каждого мВидДокумента Из Массив Цикл 
		мДок = Метаданные.Документы.Найти(мВидДокумента);
		Если мДок <> Неопределено Тогда 
			СписокВидовДокументов.Добавить(мВидДокумента, мДок.Синоним);	
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПредлагатьТолькоОсновныеДокументы Тогда 
		Для Каждого мДок Из Метаданные.Документы Цикл 
			Если Массив.Найти(мДок.Имя) <> Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			Для Каждого мТаб Из мДок.ТабличныеЧасти Цикл 
				Если мТаб.Имя = "Товары" И мТаб.Реквизиты.Найти("Номенклатура") <> Неопределено Тогда 
					СписокВидовДокументов.Добавить(мДок.Имя, мДок.Синоним);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.Номенклатура) тогда 
		Объект.Номенклатура = Параметры.Номенклатура;
	КонецЕсли;	
		
	Период.ДатаОкончания = ТекущаяДата();
	Период.ДатаНачала = Период.ДатаОкончания - 3*24*60*60;
	ПредлагатьТолькоОсновныеДокументы = Истина;
	ЗаполнитьВидыДокументов();
КонецПроцедуры
