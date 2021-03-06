﻿&НаСервере
Функция ПолучитьСсылкуНаФайл() 
	
	Ссылка=ПоместитьВоВременноеХранилище(Справочники.МегаЛогист_Маркеры.ПолучитьМакет("Картинки"));
	Возврат Ссылка
	
КонецФункции

Процедура СоздатьОбновитьМаркер(Идентификатор,Картинки,Ореол)
	
	ИмяМаркера="Маркер_"+Идентификатор;
	Маркер=Справочники.МегаЛогист_Маркеры.НайтиПоНаименованию(ИмяМаркера);
	
	Если НЕ Маркер.Пустая()  тогда
		Маркер=Маркер.ПолучитьОбъект();	
	иначе		
		Маркер=Справочники.МегаЛогист_Маркеры.СоздатьЭлемент();		
	КонецЕсли;	
	
	Маркер.Активный=?(Идентификатор=0,Ложь,Истина);
	Маркер.Наименование=ИмяМаркера;
	Маркер.ПоУмолчанию=?(Идентификатор=0,Истина,Ложь);
	
	Для Каждого Картинка из Картинки цикл
		Если Ореол тогда
			Если Найти(Картинка.ИмяФайла,"Адреса")>0 тогда
				Маркер.Маркер2=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
			ИначеЕсли Найти(Картинка.ИмяФайла,"Грузовик")>0 тогда
				Маркер.ТССОреолом=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
			ИначеЕсли Найти(Картинка.ИмяФайла,"Курьеры")>0 тогда
				Маркер.ПешийСОреолом=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));			
			КонецЕсли;
		иначе	
			Если Найти(Картинка.ИмяФайла,"Адреса")>0 тогда 
				Маркер.Маркер1=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
			ИначеЕсли Найти(Картинка.ИмяФайла,"Грузовик")>0 тогда
				Маркер.Маркер3=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
			ИначеЕсли Найти(Картинка.ИмяФайла,"Курьеры")>0 тогда
				Маркер.ПешийКурьер=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));			
			КонецЕсли;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если Идентификатор=0 тогда
		Маркер.ЦветПолиЛинии="";
	ИначеЕсли Идентификатор=1 тогда
		Маркер.ЦветПолиЛинии="#4B2A4B";
	ИначеЕсли Идентификатор=2 тогда
		Маркер.ЦветПолиЛинии="#9A1329";
	ИначеЕсли Идентификатор=3 тогда
		Маркер.ЦветПолиЛинии="#E32636";
	ИначеЕсли Идентификатор=4 тогда
		Маркер.ЦветПолиЛинии="#03C03C";
	ИначеЕсли Идентификатор=5 тогда
		Маркер.ЦветПолиЛинии="#087296";
	ИначеЕсли Идентификатор=6 тогда
		Маркер.ЦветПолиЛинии="#41045D";
	ИначеЕсли Идентификатор=7 тогда
		Маркер.ЦветПолиЛинии="#991199";
	ИначеЕсли Идентификатор=8 тогда
		Маркер.ЦветПолиЛинии="#889084";
	ИначеЕсли Идентификатор=9 тогда
		Маркер.ЦветПолиЛинии="#99958C";	
	ИначеЕсли Идентификатор=10 тогда
		Маркер.ЦветПолиЛинии="#261708";
	ИначеЕсли Идентификатор=11 тогда
		Маркер.ЦветПолиЛинии="#B87333";
	ИначеЕсли Идентификатор=12 тогда
		Маркер.ЦветПолиЛинии="#3A1F03";
	ИначеЕсли Идентификатор=13 тогда
		Маркер.ЦветПолиЛинии="#406BA5";
	ИначеЕсли Идентификатор=14 тогда
		Маркер.ЦветПолиЛинии="#674776";
	ИначеЕсли Идентификатор=15 тогда
		Маркер.ЦветПолиЛинии="#DC8604";
	ИначеЕсли Идентификатор=16 тогда
		Маркер.ЦветПолиЛинии="#00A6FF";
	ИначеЕсли Идентификатор=17 тогда
		Маркер.ЦветПолиЛинии="#C71585";
	ИначеЕсли Идентификатор=18 тогда
		Маркер.ЦветПолиЛинии="#003366";
	ИначеЕсли Идентификатор=19 тогда
		Маркер.ЦветПолиЛинии="#52A778";	
	ИначеЕсли Идентификатор=20 тогда
		Маркер.ЦветПолиЛинии="#177245";
	ИначеЕсли Идентификатор=21 тогда
		Маркер.ЦветПолиЛинии="#D35A0D";
	ИначеЕсли Идентификатор=22 тогда
		Маркер.ЦветПолиЛинии="#83D2AB";
	ИначеЕсли Идентификатор=23 тогда
		Маркер.ЦветПолиЛинии="#9C1C6C";
	ИначеЕсли Идентификатор=24 тогда
		Маркер.ЦветПолиЛинии="#031F3A";
	ИначеЕсли Идентификатор=25 тогда
		Маркер.ЦветПолиЛинии="#867FA4";
	ИначеЕсли Идентификатор=26 тогда
		Маркер.ЦветПолиЛинии="#B53B88";
	ИначеЕсли Идентификатор=27 тогда
		Маркер.ЦветПолиЛинии="#013220";
	ИначеЕсли Идентификатор=28 тогда
		Маркер.ЦветПолиЛинии="#DB7093";
	ИначеЕсли Идентификатор=29 тогда
		Маркер.ЦветПолиЛинии="#A39DCC";	
	ИначеЕсли Идентификатор=30 тогда
		Маркер.ЦветПолиЛинии="#4F7942";
	ИначеЕсли Идентификатор=31 тогда
		Маркер.ЦветПолиЛинии="#B66502";
	ИначеЕсли Идентификатор=32 тогда
		Маркер.ЦветПолиЛинии="#D8A903";
	ИначеЕсли Идентификатор=33 тогда
		Маркер.ЦветПолиЛинии="#C52BE9";
	ИначеЕсли Идентификатор=34 тогда
		Маркер.ЦветПолиЛинии="#78756D";
	ИначеЕсли Идентификатор=35 тогда
		Маркер.ЦветПолиЛинии="#4E564D";
	ИначеЕсли Идентификатор=36 тогда
		Маркер.ЦветПолиЛинии="#7E4002";
	ИначеЕсли Идентификатор=37 тогда
		Маркер.ЦветПолиЛинии="#DDADAF";
	ИначеЕсли Идентификатор=38 тогда
		Маркер.ЦветПолиЛинии="#3CAA3C";
	ИначеЕсли Идентификатор=39 тогда
		Маркер.ЦветПолиЛинии="#4C5866";	
	ИначеЕсли Идентификатор=40 тогда
		Маркер.ЦветПолиЛинии="#2E8B57";
	ИначеЕсли Идентификатор=41 тогда
		Маркер.ЦветПолиЛинии="#079EAB";
	ИначеЕсли Идентификатор=42 тогда
		Маркер.ЦветПолиЛинии="#079EAB";
	ИначеЕсли Идентификатор=43 тогда
		Маркер.ЦветПолиЛинии="#800000";
	ИначеЕсли Идентификатор=44 тогда
		Маркер.ЦветПолиЛинии="#082567";
	ИначеЕсли Идентификатор=45 тогда
		Маркер.ЦветПолиЛинии="#0F752D";
	ИначеЕсли Идентификатор=46 тогда
		Маркер.ЦветПолиЛинии="#720E86";
	ИначеЕсли Идентификатор=47 тогда
		Маркер.ЦветПолиЛинии="#F4A460";
	ИначеЕсли Идентификатор=48 тогда
		Маркер.ЦветПолиЛинии="#C71564";
	ИначеЕсли Идентификатор=49 тогда
		Маркер.ЦветПолиЛинии="#BB0724";	
	ИначеЕсли Идентификатор=50 тогда
		Маркер.ЦветПолиЛинии="#E6BD0F";	
	КонецЕсли;
	
	Маркер.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзображения()
	
	СсылкаНаФайл = ПолучитьСсылкуНаФайл();
		
	ВременныйКаталог   = КаталогВременныхФайлов();
	ВременныйФайл      = ВременныйКаталог + "Маркеры.zip";
	КаталогИнсталляции = ВременныйКаталог + "Маркеры\";
	
	// Распаковка архива во временный каталог.
	Результат = ПолучитьФайл(СсылкаНаФайл, ВременныйФайл, Ложь);
	
	ФайлАрхива = Новый ЧтениеZipФайла();
	ФайлАрхива.Открыть(ВременныйФайл);
	ФайлАрхива.ИзвлечьВсе(КаталогИнсталляции);
	ФайлАрхива.Закрыть();
		
	Для а=0 по 100 цикл
		//Простые
		НайденныеФайлы = НайтиФайлы(КаталогИнсталляции, ""+а+".png",Истина);
		Если НайденныеФайлы.Количество()>0 тогда
			
			МассивАдресов=Новый Массив;
			
			Для Каждого НайденныйФайл из НайденныеФайлы цикл
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(НайденныйФайл.ПолноеИмя));
				МассивАдресов.Добавить(Новый Структура("Адрес,ИмяФайла",АдресВоВременномХранилище,НайденныйФайл.ПолноеИмя));
			КонецЦикла;
			
			СоздатьОбновитьМаркер(а,МассивАдресов,Ложь);		
			
		КонецЕсли;
		
		//Ореолы
		НайденныеФайлы = НайтиФайлы(КаталогИнсталляции, ""+а+"-1.png",Истина);
		Если НайденныеФайлы.Количество()>0 тогда
			
			МассивАдресов=Новый Массив;
			
			Для Каждого НайденныйФайл из НайденныеФайлы цикл
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(НайденныйФайл.ПолноеИмя));
				МассивАдресов.Добавить(Новый Структура("Адрес,ИмяФайла",АдресВоВременномХранилище,НайденныйФайл.ПолноеИмя));
			КонецЦикла;
			
			СоздатьОбновитьМаркер(а,МассивАдресов,Истина);		
			
		КонецЕсли;	
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	ЗагрузитьИзображения();
КонецПроцедуры
