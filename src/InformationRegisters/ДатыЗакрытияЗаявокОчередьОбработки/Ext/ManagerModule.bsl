﻿
Процедура Добавить(СтрокаЗаявки) Экспорт
	
	МЗ = РегистрыСведений.ДатыЗакрытияЗаявокОчередьОбработки.СоздатьМенеджерЗаписи();
	МЗ.СтрокаЗаявки = СтрокаЗаявки;
	МЗ.Записать();
	
КонецПроцедуры

Процедура Удалить(СтрокаЗаявки) Экспорт
	
	НЗ = РегистрыСведений.ДатыЗакрытияЗаявокОчередьОбработки.СоздатьНаборЗаписей();
	НЗ.Отбор.СтрокаЗаявки.Установить(СтрокаЗаявки);
	НЗ.Записать();
	
КонецПроцедуры