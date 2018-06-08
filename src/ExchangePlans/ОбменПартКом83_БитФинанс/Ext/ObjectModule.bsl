﻿Процедура ЗаписатьСообщениеСИзменениями(ДанныеОбмена) Экспорт
	Если ДанныеОбмена = Неопределено Тогда
		Возврат;
	Иначе
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДанныеОбмена.Ссылка
		|ПОМЕСТИТЬ ДанныеОбмена
		|ИЗ
		|	&ДанныеОбмена КАК ДанныеОбмена
		|ГДЕ
		|	ДанныеОбмена.Ссылка ССЫЛКА Справочник.Контрагенты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Счета.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК Счета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОбмена КАК ДанныеОбмена
		|		ПО Счета.Владелец = ДанныеОбмена.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Договоры.Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОбмена КАК ДанныеОбмена
		|		ПО Договоры.Владелец = ДанныеОбмена.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТорговыеТочки.Ссылка
		|ИЗ
		|	Справочник.ТорговыеТочки КАК ТорговыеТочки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОбмена КАК ДанныеОбмена
		|		ПО ТорговыеТочки.Владелец = ДанныеОбмена.Ссылка"
		);
		Запрос.УстановитьПараметр("ДанныеОбмена", ДанныеОбмена);
		МассивДанныхОбмена = Новый Массив;
		Для Каждого СтрДанных Из ДанныеОбмена Цикл
			МассивДанныхОбмена.Добавить(СтрДанных.Ссылка);
		КонецЦикла;
		Для Каждого СтрДанных Из Запрос.Выполнить().Выгрузить() Цикл
			МассивДанныхОбмена.Добавить(СтрДанных.Ссылка);
		КонецЦикла;
	КонецЕсли;
	Каталог = СокрЛП(Константы.КаталогОбменаБИТ.Получить());
	 // Сформировать имя временного файла
	ИмяФайла = Каталог +?(Прав(Каталог, 1) = "\","", "\") + "RecTrade" 
					+ СокрЛП(ПланыОбмена.ОбменПартКом83_БитФинанс.ЭтотУзел().Код) + "_" + 
					СокрЛП(Ссылка.Код) + ".xml";
	// Создать объект записи XML
	// *** Запись XML-документов
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайла);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	// *** Инфраструктура сообщений
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьСообщения.НачатьЗапись(ЗаписьXML, Ссылка);
	// Получить выборку измененных данных
	// *** Механизм регистрации изменений
	ВыборкаИзменений =ПланыОбмена.ВыбратьИзменения(ЗаписьСообщения.Получатель, 
											ЗаписьСообщения.НомерСообщения, МассивДанныхОбмена);
	ЗаписьСообщения.ЗакончитьЗапись();
	ЗаписьXML.Закрыть();
КонецПроцедуры

 Процедура ПрочитатьСообщениеСИзменениями() Экспорт
	 Каталог = СокрЛП(Константы.КаталогОбменаБИТ.Получить());
	 // Сформировать имя файла
	ИмяФайла = Каталог +?(Прав(Каталог, 1) = "\", "", "\") + "RecAcc002_001.xml";
					//+ СокрЛП(Ссылка.Код) + "_" + 
					//СокрЛП(ПланыОбмена.ОбменПартКом83_БитФинанс.ЭтотУзел().Код) + ".xml";
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	// *** Чтение документов XML	
	// Попытаться открыть файл
	ЧтениеXML = Новый ЧтениеXML;
	Попытка 
		ЧтениеXML.ОткрытьФайл(ИмяФайла);
	Исключение 
		Сообщить("Невозможно открыть файл обмена данными.");
		Возврат;
	КонецПопытки;
	// Загрузить из найденного файла
	// *** Инфраструктура сообщений
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	// Читать заголовок сообщения обмена данными - файла XML
	ЧтениеСообщения.НачатьЧтение(ЧтениеXML);
	// Сообщение предназначено не для этого узла
	Если ЧтениеСообщения.Отправитель <> Ссылка Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	// Удаляем регистрацию изменений
	// для узла отправителя сообщения
	// *** Служба регистрации изменений
	ПланыОбмена.УдалитьРегистрациюИзменений(ЧтениеСообщения.Отправитель,ЧтениеСообщения.НомерПринятого);
	// Читаем данные из сообщения
	// *** XML-сериализация
	ЧтениеСообщения.ЗакончитьЧтение();
	ЧтениеXML.Закрыть();
	УдалитьФайлы(ИмяФайла);
КонецПроцедуры