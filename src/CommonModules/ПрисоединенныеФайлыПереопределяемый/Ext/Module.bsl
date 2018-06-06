﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Позволяет переопределить справочники хранения файлов по типам владельцев.
// 
// Параметры:
//  ТипВладелецФайла  - Тип ссылки объекта, к которому добавляется файл.
//
//  ИменаСправочников - Соответствие, содержащее в ключах имена справочников.
//                      При вызове содержит имя одного стандартного справочника.
//                      Если в значении соответствия разместить Истина только
//                      один раз, тогда в случаях, когда требуется один справочник,
//                      будет выбран такой справочник.
//                      Если же справочников несколько, и не один в значении не содержит
//                      Истина или более одного содержат Истина, тогда будет ошибка.
//
Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
	
	МассивКлючейКУдалению = Новый Массив;
	Для Каждого КлючИЗначение Из ИменаСправочников Цикл
		Если Метаданные.Справочники.Найти(КлючИЗначение.Ключ) = Неопределено Тогда
			МассивКлючейКУдалению.Добавить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Ключ Из МассивКлючейКУдалению Цикл
		ИменаСправочников.Удалить(Ключ);
	КонецЦикла;
	ИменаСправочников.Вставить("ЭДПрисоединенныеФайлы");
	
КонецПроцедуры
