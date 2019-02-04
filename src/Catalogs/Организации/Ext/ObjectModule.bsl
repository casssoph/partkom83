﻿
// Обработчик события "ПередЗаписью" Объекта
//
Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	// проверка корректности задания реквизитов справочника
	ИННОрг = ИНН;
	Если Ссылка.ИНН <> ИННОрг Тогда
		Если НЕ ПустаяСтрока(ИННОрг) И НЕ РегламентированнаяОтчетность.ИННсоответствуетТребованиям(ИННОрг, ЮрФизЛицо) Тогда
			Сообщить("ИНН организации задан неверно!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Если ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ФизЛицо И Ссылка.КПП <> КПП Тогда
		Если НЕ ПустаяСтрока(КПП) И СтрДлина(КПП) <> 9 Тогда
			Сообщить("КПП организации задан неверно!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	Если Ссылка.ОГРН <> ОГРН Тогда
		Если НЕ ПустаяСтрока(ОГРН) Тогда
			ОшибкаОГРН = Ложь;
			Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
				Если СтрДлина(СокрЛП(ОГРН)) <> 15 Тогда
					Сообщить("ОГРНИП указан неверно! ОГРНИП должен состоять из 15 цифр!", СтатусСообщения.Важное);
					ОшибкаОГРН = Истина;
					Отказ = Истина;
				КонецЕсли;
				Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(ОГРН) Тогда
					Сообщить("ОГРНИП указан неверно! ОГРНИП должен состоять только из цифр!", СтатусСообщения.Важное);
					ОшибкаОГРН = Истина;
					Отказ = Истина;
				КонецЕсли;
				Если НЕ Отказ Тогда
					ОГРН14 = Число(Лев(Строка(ОГРН), 14));
					Если НЕ ОшибкаОГРН И Прав(Формат(ОГРН14 % 13, "ЧН=0; ЧГ=0"), 1) <> Прав(ОГРН, 1) Тогда
						Сообщить("Возможно, ОГРНИП указан неверно (контрольный разряд не совпадает с вычисленным)!", СтатусСообщения.Важное);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если СтрДлина(ОГРН) <> 13 Тогда
					Сообщить("ОГРН организации указан неверно! ОГРН должен состоять из 13 цифр!", СтатусСообщения.Важное);
					ОшибкаОГРН = Истина;
					Отказ = Истина;
				КонецЕсли;
				Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(ОГРН) Тогда
					Сообщить("ОГРН организации указан неверно! ОГРН должен состоять только из цифр!", СтатусСообщения.Важное);
					ОшибкаОГРН = Истина;
					Отказ = Истина;
				КонецЕсли;
				Если НЕ Отказ Тогда
					ОГРН12 = Число(Лев(Строка(ОГРН), 12));
					Если НЕ ОшибкаОГРН И Прав(Формат(ОГРН12 % 11, "ЧН=0; ЧГ=0"), 1) <> Прав(ОГРН, 1) Тогда
						Сообщить("Возможно, ОГРН организации указан неверно (контрольный разряд не совпадает с вычисленным)!", СтатусСообщения.Важное);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// очистка неиспользуемых реквизитов
	Если НЕ Отказ Тогда
		Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
			КПП = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЭтоНовый() Тогда
		УИДБИТ = Строка(ЭтотОбъект.Ссылка.УникальныйИдентификатор());
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Добавлено Валиахметов А.А. 17.04.2018	
	Если Не Отказ И ДополнительныеСвойства.ЭтоНовый Тогда 
		Набор = РегистрыСведений.ГраницыЗапретаИзмененияДанных.СоздатьНаборЗаписей();
		Набор.Отбор.Организация.Установить(Ссылка);
		Запись = Набор.Добавить();
		Запись.ГраницаЗапретаИзменений = Константы.ДатаЗаявкиСоздаютсяВ83;
		Запись.Организация = Ссылка;
		Набор.Записать();
		Сообщить("Для организации установлена граница даты запрета редактирования данных", СтатусСообщения.Информация);
	КонецЕсли;
	//Конец Добавлено Валиахметов А.А. 17.04.2018	
	
КонецПроцедуры

Процедура ЗарегистрироватьКОбменуБИТ() Экспорт
	Попытка
		//Семенов И.П. 31.01.2019 XX-1768(
		//ПланыОбмена.ЗарегистрироватьИзменения(ПланыОбмена.ОбменПартКом83_БитФинанс.ПолучитьСсылку(Новый УникальныйИдентификатор("356a626c-086c-11e6-80e1-005056817b9c")), ЭтотОбъект.Ссылка);
		ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(ПланыОбмена.ОбменПартКом83_БитФинанс.ПолучитьСсылку(Новый УникальныйИдентификатор("356a626c-086c-11e6-80e1-005056817b9c")), ЭтотОбъект.Ссылка);
		//)Семенов И.П.
	Исключение
		#Если Клиент Тогда
		Предупреждение("объект не зарегистрирован в обмене с базой БИТ!!!");
		#КонецЕсли
	КонецПопытки;
	
КонецПроцедуры