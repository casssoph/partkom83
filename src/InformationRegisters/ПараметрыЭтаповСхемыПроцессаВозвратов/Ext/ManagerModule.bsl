﻿Процедура Добавить(Объект, СтруктураПараметров) Экспорт
	
	 МЗ = РегистрыСведений.ПараметрыЭтаповСхемыПроцессаВозвратов.СоздатьМенеджерЗаписи();
	 ЗаполнитьЗначенияСвойств(МЗ, СтруктураПараметров);
	 МЗ.Объект = Объект;
	 МЗ.Записать();	
	
КонецПроцедуры