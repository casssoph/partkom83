﻿
&НаКлиенте
Процедура ОтправитьПисьмо(Команда)
	Отчеты.РеестрВозвратовТоваровПоставщикам.ОтправитьПисьмоПоставщику(Поставщик,Организация,АдресПоставщика) ;
КонецПроцедуры

&НаКлиенте
Процедура Просмотр(Команда)
	ДанныеОтчета = Отчеты.РеестрВозвратовТоваровПоставщикам.ПолучитьДанныеОтчета(Поставщик,Организация);
	ДанныеОтчета.Показать();
КонецПроцедуры
