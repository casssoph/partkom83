﻿
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Если Объект.Дата <> НачалоДня(Объект.Дата) Тогда
		 Объект.Дата = НачалоДня(Объект.Дата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияДокумента(Команда)
	ОткрытьФорму("Отчет.ОтчетПоДвижениямДокумента.Форма", Новый Структура("Документ,СпособВыводаОтчета", Объект.Ссылка, "ПоВертикали"));
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОповеститьОВыборе(Объект.ДоговорКонтрагента);
КонецПроцедуры


&НаКлиенте
Процедура ОсобыеУсловияДопустимоеЧислоДнейЗадолженностиПриИзменении(Элемент)
	
	текСтрока = Элементы.ОсобыеУсловия.ТекущиеДанные;
	Если текСтрока.ДопустимоеЧислоДнейЗадолженности > 60 Тогда
		текСтрока.ДопустимоеЧислоДнейЗадолженности = 60;
	КонецЕсли;
	
КонецПроцедуры

