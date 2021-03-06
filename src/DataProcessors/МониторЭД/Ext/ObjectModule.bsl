﻿Функция СформироватьПереченьФилиалов() экспорт
	
	Результат = ВернутьСписокФилиалов();
	Результат_Количество = Результат.Количество();
	
	ФилиалыВсе  = Результат[Результат_Количество - 1].Выгрузить();
	ФилиалыПользователя  = Результат[Результат_Количество - 2].Выгрузить();
	
	Возврат  ?(ФилиалыПользователя.Количество() = 0, ФилиалыВсе.ВыгрузитьКолонку("Филиал"), ФилиалыПользователя.ВыгрузитьКолонку("Филиал") );
	
	Возврат Результат;
КонецФункции
Функция ВернутьСписокФилиалов()
	
	лТП = ПараметрыСеанса.ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПользователиФилиалыПользователя.Филиал
	|ИЗ
	|	Справочник.Пользователи.ФилиалыПользователя КАК ПользователиФилиалыПользователя
	|ГДЕ
	|	ПользователиФилиалыПользователя.Ссылка = &ТекПользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Филиалы.Ссылка КАК Филиал
	|ИЗ
	|	Справочник.Филиалы КАК Филиалы
	|";

	Запрос.УстановитьПараметр("ТекПользователь", лТП);
	
	Возврат Запрос.ВыполнитьПакет();
	
КонецФункции

Функция ЗапроситьБД() Экспорт
	
	Запрос = Новый Запрос;
Запрос.Текст = 
"ВЫБРАТЬ
|	ЭкспрессДоставкаОбмен.express_delivery_request_id КАК ed_id,
|	МАКСИМУМ(ЭкспрессДоставкаОбмен.Error) КАК Error,
|	МАКСИМУМ(ВЫРАЗИТЬ(ЭкспрессДоставкаОбмен.Description КАК СТРОКА(500))) КАК Description,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.Init""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_Init,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.Add""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_Add,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.DeletePart""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_DeletePart,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.1cChange""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_1cChange,
|	МИНИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.LogistConfirm""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_Confirm,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.1cConfirm""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_1cConfirm,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.Cancel""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_Cancel,
|	МАКСИМУМ(ВЫБОР
|			КОГДА ЭкспрессДоставкаОбмен.operation_type = ""ExpressDelivery.1cCancel""
|				ТОГДА ЭкспрессДоставкаОбмен.Период
|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|		КОНЕЦ) КАК ed_1cCancel
|ПОМЕСТИТЬ ЭД_web_Сводка
|ИЗ
|	РегистрСведений.ЭкспрессДоставкаОбмен КАК ЭкспрессДоставкаОбмен
|ГДЕ
|	ЭкспрессДоставкаОбмен.Период МЕЖДУ &Дата И &Дата2
|
|СГРУППИРОВАТЬ ПО
|	ЭкспрессДоставкаОбмен.express_delivery_request_id
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	РеализацияТоваровУслуг.Ссылка,
|	РеализацияТоваровУслуг.express_delivery_request_id,
|	РеализацияТоваровУслуг.Номер,
|	РеализацияТоваровУслуг.Дата,
|	РеализацияТоваровУслуг.Организация,
|	РеализацияТоваровУслуг.Контрагент,
|	РеализацияТоваровУслуг.Склад,
|	РеализацияТоваровУслуг.МаршрутДоставки,
|	РеализацияТоваровУслуг.Филиал,
|	РеализацияТоваровУслуг.ТорговаяТочка,
|	РеализацияТоваровУслуг.ВремяДоставкиС,
|	РеализацияТоваровУслуг.ВремяДоставкиПо,
|	РеализацияТоваровУслуг.ЭД_init,
|	РеализацияТоваровУслуг.ЭД_СуммаБесплатнойЭД,
|	РеализацияТоваровУслуг.ЭД_СтоимостьУслугиЭДрубли,
|	РеализацияТоваровУслуг.ЭД_СтоимостьУслугиЭДбонусы,
|	РеализацияТоваровУслуг.ЭД_СтоимостьУслугиЭДбонусы_расчет,
|	РеализацияТоваровУслуг.ЭД_ВидОплаты,
|	РеализацияТоваровУслуг.СуммаДокумента,
|	РеализацияТоваровУслуг.ПолныйОтказ,
|	РеализацияТоваровУслуг.ПометкаУдаления,
|	РеализацияТоваровУслуг.Проведен,
|	РеализацияТоваровУслуг.флНеВыгружатьВТопЛог
|ПОМЕСТИТЬ РТУ
|ИЗ
|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
|ГДЕ
|	РеализацияТоваровУслуг.Дата МЕЖДУ &Дата И &Дата2
|	И РеализацияТоваровУслуг.ТипДоставки = &ТипДоставки
// + Пушкин 20190424 XX-2032
//|	И РеализацияТоваровУслуг.Источник = &Источник
// - Пушкин 20190424 XX-2032
|	И РеализацияТоваровУслуг.express_delivery_request_id В
|			(ВЫБРАТЬ
|				ЭД_web_Сводка.ed_id
|			ИЗ
|				ЭД_web_Сводка)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	Склады.Ссылка,
|	ЕСТЬNULL(Склады.ВременнаяЗона.Отклонение, ЕСТЬNULL(Склады.ФизическийСклад.ВременнаяЗона.Отклонение, 0)) КАК Отклонение
|ПОМЕСТИТЬ ВременныеЗоны_Отклонения
|ИЗ
|	Справочник.Склады КАК Склады
|ГДЕ
|	Склады.Ссылка В
|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
|				РТУ.Склад
|			ИЗ
|				РТУ)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ИсторияОбменаСТопЛогПоОбъектам.Период,
|	ИсторияОбменаСТопЛогПоОбъектам.Объект,
|	ИсторияОбменаСТопЛогПоОбъектам.НомерСообщения,
|	ИсторияОбменаСТопЛогПоОбъектам.Исходящее,
|	ИсторияОбменаСТопЛогПоОбъектам.ЕстьОшибки,
|	ИсторияОбменаСТопЛогПоОбъектам.НомерПотока,
|	ИсторияОбменаСТопЛогПоОбъектам.ОписаниеОшибки
|ПОМЕСТИТЬ ОбменТопЛог
|ИЗ
|	РегистрСведений.ИсторияОбменаСТопЛогПоОбъектам КАК ИсторияОбменаСТопЛогПоОбъектам
|ГДЕ
|	ИсторияОбменаСТопЛогПоОбъектам.Объект В
|			(ВЫБРАТЬ
|				РТУ.Ссылка
|			ИЗ
|				РТУ)
// + Пушкин 20190620 XX-2568
|	И ИсторияОбменаСТопЛогПоОбъектам.Период МЕЖДУ &Дата И &Дата2
// - Пушкин 20190620 XX-2568
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	МИНИМУМ(ОбменТопЛог.Период) КАК Период,
|	ОбменТопЛог.Объект
|ПОМЕСТИТЬ ОбменТопЛог_Выгрузка
|ИЗ
|	ОбменТопЛог КАК ОбменТопЛог
|ГДЕ
|	ОбменТопЛог.Исходящее = ИСТИНА
|
|СГРУППИРОВАТЬ ПО
|	ОбменТопЛог.Объект
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
// + Пушкин 20190620 XX-2568
//|	МАКСИМУМ(ОбменТопЛог.Период) КАК Период,
|	МИНИМУМ(ОбменТопЛог.Период) КАК Период,
// - Пушкин 20190620 XX-2568
|	ОбменТопЛог.Объект
|ПОМЕСТИТЬ ОбменТопЛог_Загрузка
|ИЗ
|	ОбменТопЛог КАК ОбменТопЛог
|ГДЕ
|	ОбменТопЛог.Исходящее = ЛОЖЬ
|
|СГРУППИРОВАТЬ ПО
|	ОбменТопЛог.Объект
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ ОбменТопЛог
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	РеализацияТоваровУслугУслуги.Ссылка,
|	СУММА(РеализацияТоваровУслугУслуги.Сумма) КАК Сумма
|ПОМЕСТИТЬ РТУ_Услуги
|ИЗ
|	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияТоваровУслугУслуги
|ГДЕ
|	РеализацияТоваровУслугУслуги.Ссылка В
|			(ВЫБРАТЬ
|				РТУ.Ссылка
|			ИЗ
|				РТУ)
|	И РеализацияТоваровУслугУслуги.Номенклатура В(&ЭД_Услуга)
|
|СГРУППИРОВАТЬ ПО
|	РеализацияТоваровУслугУслуги.Ссылка
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	РеализацияТоваровУслугТовары.Ссылка,
|	СУММА(РеализацияТоваровУслугТовары.Сумма) КАК Сумма,
|	СУММА(РеализацияТоваровУслугТовары.ЭД_Сумма_Услуга) КАК ЭД_Сумма_Услуга
|ПОМЕСТИТЬ РТУ_Товары
|ИЗ
|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
|ГДЕ
|	РеализацияТоваровУслугТовары.Ссылка В
|			(ВЫБРАТЬ
|				РТУ.Ссылка
|			ИЗ
|				РТУ)
|
|СГРУППИРОВАТЬ ПО
|	РеализацияТоваровУслугТовары.Ссылка
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка,
|	МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.ДокументСсылка,
|	МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус КАК Статус,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.КРаспределению) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК КРаспределению,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполняется) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК Выполняется,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполнен) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК Выполнен,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.Отменен) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК Отменен,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.НеВыполнено) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК НеВыполнено,
|	ВЫБОР 
|		КОГДА МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.НеОбработан) ТОГДА 1
|		Иначе 0
|	КОНЕЦ КАК НеОбработан
|ПОМЕСТИТЬ МаршрутныеЗадания
|ИЗ
|	Документ.МегаЛогист_МаршрутноеЗадание.ДокументыРеализации КАК МегаЛогист_МаршрутноеЗаданиеДокументыРеализации
|ГДЕ
|	МегаЛогист_МаршрутноеЗаданиеДокументыРеализации.ДокументСсылка В
|			(ВЫБРАТЬ
|				РТУ.Ссылка
|			ИЗ
|				РТУ)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	МегаЛогист_МаршрутныйЛистМаршрутныеЗадания.Ссылка,
|	МегаЛогист_МаршрутныйЛистМаршрутныеЗадания.ДокументСсылка
|ПОМЕСТИТЬ МаршрутныеЛисты
|ИЗ
|	Документ.МегаЛогист_МаршрутныйЛист.МаршрутныеЗадания КАК МегаЛогист_МаршрутныйЛистМаршрутныеЗадания
|ГДЕ
|	МегаЛогист_МаршрутныйЛистМаршрутныеЗадания.ДокументСсылка В
|			(ВЫБРАТЬ
|				МаршрутныеЗадания.Ссылка
|			ИЗ
|				МаршрутныеЗадания)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ПартииТоваровОбороты.Регистратор,
|	СУММА(ПартииТоваровОбороты.СуммаРублиРасход - ПартииТоваровОбороты.СуммаРублиПриход) КАК Сумма
|ПОМЕСТИТЬ РТУ_себестоимость
|ИЗ
|	РегистрНакопления.ПартииТоваров.Обороты(&Дата, &Дата2, Регистратор, ) КАК ПартииТоваровОбороты
|ГДЕ
|	ПартииТоваровОбороты.Регистратор В
|			(ВЫБРАТЬ
|				РТУ.Ссылка
|			ИЗ
|				РТУ)
|
|СГРУППИРОВАТЬ ПО
|	ПартииТоваровОбороты.Регистратор
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	РТУ.ПометкаУдаления КАК d_ПометкаУдаления,
|	РТУ.ПолныйОтказ КАК d_ПолныйОтказ,
|	РТУ.Проведен КАК d_Проведен,
|	ЭД_web_Сводка.ed_id,
|	ЭД_web_Сводка.Error,
|	ЭД_web_Сводка.Description,
|	ЭД_web_Сводка.ed_Init,
|	ЭД_web_Сводка.ed_Add,
|	ЕСТЬNULL(МаршрутныеЗадания.Ссылка.Дата, ДАТАВРЕМЯ(1, 1, 1)) КАК z_МЗадание,
|	ЭД_web_Сводка.ed_DeletePart,
|	ЭД_web_Сводка.ed_1cChange,
|	ЭД_web_Сводка.ed_Cancel,
|	ЭД_web_Сводка.ed_1cCancel,
|	ЭД_web_Сводка.ed_Confirm,
|	ЭД_web_Сводка.ed_1cConfirm,
|	ЕСТЬNULL(МаршрутныеЛисты.Ссылка.Дата, ДАТАВРЕМЯ(1, 1, 1)) КАК l_МЛист,
|	РТУ.ВремяДоставкиС КАК d_ВремяДоставкиС,
|	РТУ.ВремяДоставкиПо КАК d_ВремяДоставкиПо,
|	ВЫБОР
|		КОГДА ЭД_web_Сводка.ed_1cConfirm > ДАТАВРЕМЯ(1, 1, 1)
|				И РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1), ЕСТЬNULL(МаршрутныеЗадания.Ссылка.ВремяДоставкиФакт, ДАТАВРЕМЯ(1, 1, 1)), МИНУТА) > 0
|			ТОГДА ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ЭД_web_Сводка.ed_1cConfirm, ДЕНЬ), МИНУТА, РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1), ЕСТЬNULL(МаршрутныеЗадания.Ссылка.ВремяДоставкиФакт, ДАТАВРЕМЯ(1, 1, 1)), МИНУТА)), ЧАС, ЕСТЬNULL(ВременныеЗоны_Отклонения.Отклонение, 0) * -1)
|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
|	КОНЕЦ КАК z_МЗадание_ВремяДоставкиФакт_Дата,
|	ВЫБОР
|		КОГДА ЭД_web_Сводка.ed_1cConfirm > ДАТАВРЕМЯ(1, 1, 1)
|				И РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1), ЕСТЬNULL(МаршрутныеЗадания.Ссылка.ВремяДоставкиФакт, ДАТАВРЕМЯ(1, 1, 1)), МИНУТА) > 0
|			ТОГДА РАЗНОСТЬДАТ(ЭД_web_Сводка.ed_1cConfirm,ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ЭД_web_Сводка.ed_1cConfirm, ДЕНЬ), МИНУТА, РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1), ЕСТЬNULL(МаршрутныеЗадания.Ссылка.ВремяДоставкиФакт, ДАТАВРЕМЯ(1, 1, 1)), МИНУТА)), ЧАС, ЕСТЬNULL(ВременныеЗоны_Отклонения.Отклонение, 0) * -1),МИНУТА)
|		ИНАЧЕ NULL
|	КОНЕЦ КАК ВсегоМинутОтАкцептаДоДоставки_2,
|	НЕ РТУ.флНеВыгружатьВТопЛог КАК d_флНеВыгружатьВТопЛог,
|	ЕСТЬNULL(ОбменТопЛог_Выгрузка.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК d_Выгрузка,
|	ЕСТЬNULL(ОбменТопЛог_Загрузка.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК d_Загрузка,
|	ВЫБОР
|		КОГДА ЕСТЬNULL(ОбменТопЛог_Выгрузка.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
|				ИЛИ ЕСТЬNULL(ОбменТопЛог_Загрузка.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
|			ТОГДА NULL
|		ИНАЧЕ РАЗНОСТЬДАТ(ЕСТЬNULL(ОбменТопЛог_Выгрузка.Период, ДАТАВРЕМЯ(1, 1, 1)), ЕСТЬNULL(ОбменТопЛог_Загрузка.Период, ДАТАВРЕМЯ(1, 1, 1)), МИНУТА)
|	КОНЕЦ КАК d_МинутыОбработкаВТопЛог,
|	РТУ.Дата КАК d_Дата,
|	РТУ.Номер КАК d_Номер,
|	РТУ.Ссылка КАК РТУ,
|	РТУ.Ссылка.Статус КАК Статус,
|	РТУ.Ссылка.СтатусДокумента КАК СтатусДокумента,
|	РТУ.Организация КАК d_Организация,
|	РТУ.Контрагент КАК d_Контрагент,
|	РТУ.Филиал КАК d_Филиал,
|	РТУ.Контрагент.ОсновнаяТорговаяТочка.Регион КАК Регион,
|	РТУ.ТорговаяТочка КАК d_ТорговаяТочка,
|	РТУ.ЭД_СуммаБесплатнойЭД КАК d_ЭД_СуммаБесплатнойЭД,
|	РТУ.ЭД_СтоимостьУслугиЭДрубли КАК d_ЭД_СтоимостьУслугиЭДрубли,
|	РТУ.ЭД_СтоимостьУслугиЭДбонусы КАК d_ЭД_СтоимостьУслугиЭДбонусы,
|	РТУ.ЭД_ВидОплаты КАК d_ЭД_ВидОплаты,
|	РТУ.СуммаДокумента КАК d_СуммаДокумента,
|	ЕСТЬNULL(РТУ_Товары.Сумма, 0) - ЕСТЬNULL(РТУ_Товары.ЭД_Сумма_Услуга, 0) КАК d_СуммаТовары,
|	ЕСТЬNULL(РТУ_Услуги.Сумма, 0) КАК d_СуммаУслугаРубли,
|	ЕСТЬNULL(РТУ_Товары.ЭД_Сумма_Услуга, 0) КАК d_СуммаУслугаВЦенеТовара,
|	РТУ.ЭД_СтоимостьУслугиЭДбонусы_расчет КАК d_СуммаУслугабонусы,
|	ЕСТЬNULL(РТУ_себестоимость.Сумма, 0) КАК СуммаСебестоимость,
|	ЕСТЬNULL(РТУ_Товары.Сумма, 0) - ЕСТЬNULL(РТУ_Товары.ЭД_Сумма_Услуга, 0) - РТУ.ЭД_СтоимостьУслугиЭДбонусы_расчет - ЕСТЬNULL(РТУ_себестоимость.Сумма, 0) КАК Прибыль,
|	НЕ РТУ.ЭД_init КАК d_ЭД_init,
|	РТУ.Склад КАК d_Склад,
|	РТУ.МаршрутДоставки КАК d_МаршрутДоставки,
|	МаршрутныеЗадания.Ссылка КАК МаршрутноеЗадание,

// + Пушкин XX-2448
|	ЕСТЬNULL(МаршрутныеЗадания.Ссылка.ДокументОснование, ЗНАЧЕНИЕ(Документ.СлужебноеЗадание.ПустаяСсылка)) КАК СЗ,
//|	ЗНАЧЕНИЕ(Документ.СлужебноеЗадание.ПустаяСсылка) КАК СЗ,
// - Пушкин XX-2448

|	естьNULL(МаршрутныеЗадания.Статус,ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.ПустаяСсылка)) КАК МаршрутноеЗадание_Статус,
|	естьNULL(МаршрутныеЗадания.КРаспределению,0) КАК МаршрутноеЗадание_КРаспределению,
|	естьNULL(МаршрутныеЗадания.Выполняется,0) КАК МаршрутноеЗадание_Выполняется,
|	естьNULL(МаршрутныеЗадания.Выполнен,0) КАК МаршрутноеЗадание_Выполнен,
|	естьNULL(МаршрутныеЗадания.Отменен,0) КАК МаршрутноеЗадание_Отменен,
|	естьNULL(МаршрутныеЗадания.НеВыполнено,0) КАК МаршрутноеЗадание_НеВыполнено,
|	естьNULL(МаршрутныеЗадания.НеОбработан,0) КАК МаршрутноеЗадание_НеОбработан,
|	ВЫБОР
|   	КОГДА  ЭД_web_Сводка.Error ТОГДА 1
|       ИНАЧЕ 0
|   КОНЕЦ КАК ИныеОшибки,
|	МаршрутныеЛисты.Ссылка КАК МаршрутныйЛист,
|	1 КАК Сч
|ПОМЕСТИТЬ ПолныйРасклад
|ИЗ
|	ЭД_web_Сводка КАК ЭД_web_Сводка
|		ЛЕВОЕ СОЕДИНЕНИЕ РТУ КАК РТУ
|		ПО ЭД_web_Сводка.ed_id = РТУ.express_delivery_request_id
|		ЛЕВОЕ СОЕДИНЕНИЕ ОбменТопЛог_Выгрузка КАК ОбменТопЛог_Выгрузка
|		ПО (РТУ.Ссылка = ОбменТопЛог_Выгрузка.Объект)
|		ЛЕВОЕ СОЕДИНЕНИЕ ОбменТопЛог_Загрузка КАК ОбменТопЛог_Загрузка
|		ПО (РТУ.Ссылка = ОбменТопЛог_Загрузка.Объект)
|		ЛЕВОЕ СОЕДИНЕНИЕ РТУ_Услуги КАК РТУ_Услуги
|		ПО (РТУ.Ссылка = РТУ_Услуги.Ссылка)
|		ЛЕВОЕ СОЕДИНЕНИЕ РТУ_Товары КАК РТУ_Товары
|		ПО (РТУ.Ссылка = РТУ_Товары.Ссылка)
|		ЛЕВОЕ СОЕДИНЕНИЕ МаршрутныеЗадания КАК МаршрутныеЗадания
|		ПО (РТУ.Ссылка = МаршрутныеЗадания.ДокументСсылка)
|		ЛЕВОЕ СОЕДИНЕНИЕ МаршрутныеЛисты КАК МаршрутныеЛисты
|		ПО (МаршрутныеЗадания.Ссылка = МаршрутныеЛисты.ДокументСсылка)
|		ЛЕВОЕ СОЕДИНЕНИЕ РТУ_себестоимость КАК РТУ_себестоимость
|		ПО (РТУ.Ссылка = РТУ_себестоимость.Регистратор)
|		ЛЕВОЕ СОЕДИНЕНИЕ ВременныеЗоны_Отклонения КАК ВременныеЗоны_Отклонения
|		ПО (РТУ.Склад = ВременныеЗоны_Отклонения.Ссылка)
|ГДЕ
|	РТУ.Филиал В(&мФилиалы)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ РТУ
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ ВременныеЗоны_Отклонения
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ ОбменТопЛог_Выгрузка
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ ОбменТопЛог_Загрузка
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ РТУ_Услуги
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ РТУ_Товары
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ МаршрутныеЗадания
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ МаршрутныеЛисты
|;
|
|////////////////////////////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ РТУ_себестоимость
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	""12345"" КАК пп,
|	ПолныйРасклад.d_Филиал КАК Филиал,
|	ПолныйРасклад.ed_id КАК id,

|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_Статус) КАК Статус,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_КРаспределению) КАК МаршрутноеЗадание_КРаспределению,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_Выполняется) КАК МаршрутноеЗадание_Выполняется,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_Выполнен) КАК МаршрутноеЗадание_Выполнен,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_Отменен) КАК МаршрутноеЗадание_Отменен,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_НеВыполнено) КАК МаршрутноеЗадание_НеВыполнено,
|	МАКСИМУМ(ПолныйРасклад.МаршрутноеЗадание_НеОбработан) КАК МаршрутноеЗадание_НеОбработан,
|	МАКСИМУМ(ПолныйРасклад.ИныеОшибки) КАК ИныеОшибки,

|	МАКСИМУМ(ПолныйРасклад.Error) КАК Error,
|	МАКСИМУМ(ПолныйРасклад.Description) КАК Description,
|	МИНИМУМ(ПолныйРасклад.ed_Init) КАК Init,
|	МАКСИМУМ(ПолныйРасклад.ed_Add) КАК Add,
|	МАКСИМУМ(ПолныйРасклад.z_МЗадание) КАК МЗадание,
|	МАКСИМУМ(ПолныйРасклад.ed_DeletePart) КАК Delete,
|	МАКСИМУМ(ПолныйРасклад.ed_1cChange) КАК Change1с,
|	МАКСИМУМ(ПолныйРасклад.ed_Cancel) КАК Cancel,
|	МАКСИМУМ(ПолныйРасклад.ed_1cCancel) КАК Cancel1с,
|	МАКСИМУМ(ПолныйРасклад.ed_Confirm) КАК Confirm,
|	МАКСИМУМ(ПолныйРасклад.ed_1cConfirm) КАК Confirm1с,
|	МАКСИМУМ(ПолныйРасклад.l_МЛист) КАК МЛист,
|	МИНИМУМ(ПолныйРасклад.d_ВремяДоставкиС) КАК ДоставкаС,
|	МАКСИМУМ(ПолныйРасклад.d_ВремяДоставкиПо) КАК ДоставкаПо,
|	МАКСИМУМ(ПолныйРасклад.z_МЗадание_ВремяДоставкиФакт_Дата) КАК z_МЗадание_ВремяДоставкиФакт_Дата,
|	СРЕДНЕЕ(ПолныйРасклад.ВсегоМинутОтАкцептаДоДоставки_2) КАК ВсегоМинутОтАкцептаДоДоставки_СРЕДНЕЕ,
|	МИНИМУМ(ПолныйРасклад.d_Выгрузка) КАК Выгрузка,

// + Пушкин 20190620 XX-2568
//|	МАКСИМУМ(ПолныйРасклад.d_Загрузка) КАК Загрузка,
|	МИНИМУМ(ПолныйРасклад.d_Загрузка) КАК Загрузка,
// - Пушкин 20190620 XX-2568

|	СРЕДНЕЕ(ПолныйРасклад.d_МинутыОбработкаВТопЛог) КАК МинутыОбработкаВТопЛог,
|	СРЕДНЕЕ(ПолныйРасклад.ВсегоМинутОтАкцептаДоДоставки_2 - ПолныйРасклад.d_МинутыОбработкаВТопЛог) КАК ВсегоМинутДоставка_СРЕДНЕЕ,
|	СУММА(ПолныйРасклад.Сч) КАК РТУ,
|	МАКСИМУМ(ПолныйРасклад.d_ЭД_ВидОплаты) КАК ВидОплаты,
|	МАКСИМУМ(ПолныйРасклад.d_ЭД_СуммаБесплатнойЭД) КАК СуммаБесплатнойЭД,
|	СУММА(ПолныйРасклад.d_СуммаДокумента) КАК СуммаДокумента,
|	СУММА(ПолныйРасклад.d_СуммаТовары) КАК СуммаТовары,
|	СУММА(ПолныйРасклад.d_СуммаУслугаРубли) КАК СуммаУслугаРубли,
|	СУММА(ПолныйРасклад.d_СуммаУслугаВЦенеТовара) КАК СуммаУслугаВЦенеТовара,
|	СУММА(ПолныйРасклад.d_СуммаУслугабонусы) КАК СуммаБонусы,
|	СУММА(ПолныйРасклад.СуммаСебестоимость) КАК СуммаСебестоимость,
|	СУММА(ПолныйРасклад.Прибыль) КАК Прибыль
|ИЗ
|	ПолныйРасклад КАК ПолныйРасклад
|
|СГРУППИРОВАТЬ ПО
|	ПолныйРасклад.d_Филиал,
|	ПолныйРасклад.ed_id
|
|УПОРЯДОЧИТЬ ПО
|	СУММА(ПолныйРасклад.d_СуммаДокумента) УБЫВ,
|	ПолныйРасклад.d_Филиал,
|	ПолныйРасклад.ed_id
|ИТОГИ
|	МИНИМУМ(Init),
|	МАКСИМУМ(Confirm),
|	МАКСИМУМ(Confirm1с),
|	МИНИМУМ(ДоставкаС),
|	МАКСИМУМ(ДоставкаПо),
|	МАКСИМУМ(z_МЗадание_ВремяДоставкиФакт_Дата),
|	СРЕДНЕЕ(ВсегоМинутОтАкцептаДоДоставки_СРЕДНЕЕ),
|	СРЕДНЕЕ(МинутыОбработкаВТопЛог),
|	СРЕДНЕЕ(ВсегоМинутДоставка_СРЕДНЕЕ),
|	СУММА(РТУ),
|	СУММА(СуммаДокумента),
|	СУММА(СуммаТовары),
|	СУММА(СуммаУслугаРубли),
|	СУММА(СуммаУслугаВЦенеТовара),
|	СУММА(СуммаБонусы),
|	СУММА(СуммаСебестоимость),
|	СУММА(Прибыль),
|	СУММА(МаршрутноеЗадание_Отменен),
|	СУММА(МаршрутноеЗадание_НеОбработан),

|	СУММА(МаршрутноеЗадание_КРаспределению),
|	СУММА(МаршрутноеЗадание_Выполняется),
|	СУММА(МаршрутноеЗадание_Выполнен),
|	СУММА(МаршрутноеЗадание_НеВыполнено),

|	СУММА(ИныеОшибки)

|ПО
|	Филиал
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ЖурналSMSоповещенияСрезПоследних.id,
|	ЖурналSMSоповещенияСрезПоследних.Статус,
|	ЖурналSMSоповещенияСрезПоследних.Дата_Формирования,
|	ЖурналSMSоповещенияСрезПоследних.Период,
|	ЖурналSMSоповещенияСрезПоследних.Отправлено,
|	ЖурналSMSоповещенияСрезПоследних.Дата_Отправки,
|	ЖурналSMSоповещенияСрезПоследних.Ошибка,
|	ЖурналSMSоповещенияСрезПоследних.Источник,
|	ЖурналSMSоповещенияСрезПоследних.ВидSMSоповещения,
|	ЖурналSMSоповещенияСрезПоследних.Получатель_КА КАК КА,
|	ЖурналSMSоповещенияСрезПоследних.Получатель_НомерТелефона КАК НомерТелефона,
|	ЖурналSMSоповещенияСрезПоследних.ТекстSMSоповещения
|ИЗ
|	РегистрСведений.ЖурналSMSоповещения.СрезПоследних КАК ЖурналSMSоповещенияСрезПоследних
|ГДЕ
|	ЖурналSMSоповещенияСрезПоследних.Источник В
|			(ВЫБРАТЬ
|				ПолныйРасклад.РТУ
|			ИЗ
|				ПолныйРасклад
|		
|			ОБЪЕДИНИТЬ ВСЕ
|		
|			ВЫБРАТЬ
|				ПолныйРасклад.МаршрутноеЗадание
|			ИЗ
|				ПолныйРасклад
|		
|			ОБЪЕДИНИТЬ ВСЕ
|		
|			ВЫБРАТЬ
|				ПолныйРасклад.МаршрутныйЛист
|			ИЗ
|				ПолныйРасклад)
|
|УПОРЯДОЧИТЬ ПО
|	ЖурналSMSоповещенияСрезПоследних.Период,
|	ЖурналSMSоповещенияСрезПоследних.id
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ *
|ИЗ
|	ПолныйРасклад КАК ПолныйРасклад
|
|УПОРЯДОЧИТЬ ПО
|	ПолныйРасклад.d_Дата
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ  *
|ИЗ
|	ПолныйРасклад КАК ПолныйРасклад
|ГДЕ
|	(ПолныйРасклад.Статус В (&СтатусыЭД)
|			ИЛИ ПолныйРасклад.СтатусДокумента В (&СтатусыДокумента))";
	
	у_м = новый Массив;
	ИмяПараметраУслугаДоставки = "Услуга экспресс-доставки (Безнал)";
	у_м.Добавить(РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", ИмяПараметраУслугаДоставки, Константы.УслугаЭкспрессДоставка.Получить()));
	ИмяПараметраУслугаДоставки = "Услуга экспресс-доставки (Нал)";
	у_м.Добавить(РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", ИмяПараметраУслугаДоставки, Константы.УслугаЭкспрессДоставка.Получить()));
	
	СтатусыЭД = Новый Массив;
	СтатусыЭД.Добавить(Перечисления.СтатусыРеализацииЭкспрессДоставки.ВыписанаРеализация);
	СтатусыЭД.Добавить(Перечисления.СтатусыРеализацииЭкспрессДоставки.ВыданПокупателю);
	
	СтатусыДокумента = Новый Массив;
	СтатусыДокумента.Добавить(Справочники.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче);
	СтатусыДокумента.Добавить(Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен);
	
	мФилиалы = СформироватьПереченьФилиалов();
	Если ЗначениеЗаполнено(ВыбФилиал) Тогда
		мФилиалы. Очистить();
		мФилиалы.Добавить(ВыбФилиал);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Дата", ДтВрмН);
	Запрос.УстановитьПараметр("Дата2", ДтВрмК);
	//Запрос.УстановитьПараметр("Источник", Перечисления.ИсточникиРеализаций.Сайт);
	Запрос.УстановитьПараметр("ТипДоставки", Справочники.ТипыДоставки.ЭкспрессДоставка);
	Запрос.УстановитьПараметр("ЭД_Услуга", у_м);
	Запрос.УстановитьПараметр("СтатусыЭД", СтатусыЭД);
	Запрос.УстановитьПараметр("СтатусыДокумента", СтатусыДокумента);
	Запрос.УстановитьПараметр("мФилиалы", мФилиалы);
	
	Результат = Запрос.ВыполнитьПакет();	
	
	Результат_Количество = Результат.Количество();
	
	РТУу  = Результат[Результат_Количество - 1].Выгрузить();
	ЭД   = Результат[Результат_Количество - 4].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	РТУ  = Результат[Результат_Количество - 2].Выгрузить();
	SMS  = Результат[Результат_Количество - 3].Выгрузить();
	
	Возврат Новый Структура("ЭД,РТУ,SMS,РТУу",ЭД,РТУ,SMS,РТУу);
	
КонецФункции