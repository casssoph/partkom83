﻿
Процедура ДобавитьСобытие(АктРассмотренияВозврата, ПараметрыСобытия) Экспорт
	
	МЗ = РегистрыСведений.СобытияАктовРассмотренияВозврата.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, ПараметрыСобытия);
	МЗ.Период 					= ТекущаяДата();
	МЗ.АктРассмотренияВозврата 	= АктРассмотренияВозврата;
	Если НЕ ЗначениеЗаполнено(МЗ.Ответственный) Тогда
		МЗ.Ответственный 			= ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	МЗ.Записать();
	
КонецПроцедуры