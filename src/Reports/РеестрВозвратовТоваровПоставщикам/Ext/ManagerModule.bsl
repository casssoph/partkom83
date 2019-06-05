﻿
Процедура ВыполнитьРассылку(ИмяСхемыОтчета= "",ДополнительныеПараметры=Неопределено) Экспорт
	
	ВыборкаПоставщиков	 = ПолучитьСписокПоставщиковКРассылке();
	пока ВыборкаПоставщиков.следующий() цикл
		ДанныеОтчета =  ПолучитьДанныеОтчета(ВыборкаПоставщиков.Поставщик);
		
		ТемаПисьма = "Реестр возвратов тоаваров";
		ТелоСообщения = ТемаПисьма + " за "++Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy");
		ИмяФайлаВложения = ТемаПисьма;
		ФайлВФорматеXLS = ПолучитьИмяВременногоФайла();
		ДанныеОтчета.Записать(ФайлВФорматеXLS, ТипФайлаТабличногоДокумента.XLS);
		СписокФайловВложений = Новый СписокЗначений;
		СписокФайловВложений.Добавить(Новый Структура("Хранилище, ИмяФайла, Наименование", ПолучитьДвоичныеДанные(ФайлВФорматеXLS), (ИмяФайлаВложения + ".XLS"), ИмяФайлаВложения));
		
		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ОтправкаФайлаОтчета,
		ТелоСообщения, ТемаПисьма,ВыборкаПоставщиков.АдресЭлектроннойПочты,,,СписокФайловВложений);
	КонецЦикла;	

КонецПроцедуры	

Функция ПолучитьДвоичныеДанные(ИмяФайла)

	Файл = Новый Файл(ИмяФайла);
	
	Если Файл.Существует() Тогда
		Данные = Новый ДвоичныеДанные(ИмяФайла);
		Попытка
			УдалитьФайлы(ИмяФайла);
		Исключение
		КонецПопытки;
		Возврат Данные;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции

Функция ПолучитьСписокПоставщиковКРассылке()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Контрагент КАК Поставщик,
		|	КонтактнаяИнформация.Представление КАК АдресЭлектроннойПочты
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО ВозвратТоваровПоставщику.Контрагент = КонтактнаяИнформация.Объект
		|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТИпыКонтактнойИнформации.АдресЭлектроннойПочты))
		|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами))
		|ГДЕ
		|	ВозвратТоваровПоставщику.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ВозвратТоваровПоставщику.ПометкаУдаления = ЛОЖЬ
		|	И ВЫБОР
		|			КОГДА ВозвратТоваровПоставщику.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВозвратПоставщику.КорректировочныйСчетФактура)
		|					И ВозвратТоваровПоставщику.КоррСФНомер = """"
		|					И ВозвратТоваровПоставщику.КоррСФДата = ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|	И ВозвратТоваровПоставщику.Контрагент.РаботатьСОкномПоставщика = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ДатаНачала", РегистрыСведений.ГраницыЗапретаИзмененияДанных.Получить(Новый структура("Организация,Пользователь")).ГраницаЗапретаИзменений);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;
	
КонецФункции	

Функция ПолучитьДанныеОтчета(Поставщик)
	
	Отчет  =  Отчеты.РеестрВозвратовТоваровПоставщикам.Создать();
	КомпоновщикНастроек = новый КомпоновщикНастроекКомпоновкиДанных;
	СхемаВыгрузки = Отчет.ПолучитьМакет("ДляРассылки");
	ВариантОтчета =СхемаВыгрузки.ВариантыНастроек.ОборотыКлиентовСайта ;
	КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.настройки);
	КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Поставщик;
	
	ПериодОтчета = новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала =  РегистрыСведений.ГраницыЗапретаИзмененияДанных.Получить(Новый структура("Организация,Пользователь")).ГраницаЗапретаИзменений;
	ПериодОтчета.ДатаОкончания =КонецДня(ТекущаяДата());
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[0].Использование  = Истина;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[0].Значение = ПериодОтчета;
	
	ТабДокОтчета  = новый ТабличныйДокумент;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаВыгрузки, КомпоновщикНастроек.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДокОтчета);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	Возврат ТабДокОтчета;
		
КонецФункции

