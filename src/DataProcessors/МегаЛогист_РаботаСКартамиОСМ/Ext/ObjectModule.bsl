перем твысотакарты экспорт;перем тширинакарты экспорт;перем соответствиеметок экспорт;перем соответствиеметокадресам экспорт;перем соответствиекартинокметок экспорт;перем ркарта экспорт;перем максимальнаяширота экспорт;перем максимальнаядолгота экспорт;перем минимальнаяширота экспорт;перем минимальнаядолгота экспорт;перем тобласть экспорт;перем a___; функция получитькодкарты()экспорт перем a_;~0:a_=1;if -1<1 then goto ~3;endif;goto ~1;if a_=1 then goto ~8;endif;goto ~4;~1:if a_=-1 then goto ~5;endif;goto ~10;~2:
;~3:if a_=1 then goto ~7;endif;goto ~2;~4:goto ~9;~5:;~6:a="с";goto ~11;~7:goto ~9;~8:;~9:a="<!doctype html>
			|<html xmlns=""http://www.w3.org/1999/xhtml"">
			|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
			|<meta http-equiv=""X-UA-Compatible"" content=""IE=8"">
			|<title>Карта клиентов</title>
			|<style type=""text/css""> html, body, #OurYMap { width: 98.8%; height: 97.9%;} </style>
			|<script src=""http://api-maps.yandex.ru/2.0/?load=package.full&lang=ru-RU"" type=""text/javascript""></script>
			|<script type=""text/javascript"">     		        
			|	ymaps.ready(YmapsReady);
			|	var OurYandexMap 
			|	function YmapsReady() { // используется при подключении событий
			|         window.LatestEvent = ""YmapsReady"";
			|    } // конец функции YmapsReady
			|	
			|	function CreateMap(X,Y,zoom,type,geoObjectDraggable,balloonCloseButton) {
			|		window.OurYandexMap = new ymaps.Map(""OurYMap"", { 
			|				center: [X,Y],
			|				zoom: zoom,				
			|                type: type, 
			|                behaviors: [""default"", ""scrollZoom"", ""drag""] // масштабирование колесом мыши
			|			}, // конец задания основных параметров
			|			{// опции (только те, которые требуют явной переустановки)
			|                    maxZoom: 23, 	// максимальный уровень масштабирования карты (по умолчанию 23)
			|                    minZoom: 0, 	// минимальный уровень масштабирования карты (по умолчанию 0)
			|                    geoObjectDraggable: geoObjectDraggable,
			|                    balloonCloseButton: balloonCloseButton
			|			} // конец задания опций
			|			);
			|		OurYandexMap.controls.add(""zoomControl"")
			|		//.add(""typeSelector"")
			|		.add(""mapTools"")       
			|		//.add(""routeEditor"")
			|		;                 
			|			              
			|		window.OurYandexMap.behaviors.disable(""dblClickZoom"");	       
			|        window.LatestEvent = """"; // изначально пустое
			|		return window.OurYandexMap;
			|		
			|	} // конец функции CreateMap
			|	
			|
			|	function AddMapControl(MapObject, conType, cLeft, cTop, cRight, cBottom) {
			|		// список допустимых контролов см. в модуле обработки, избирательное создание пока не делаем
			|		MapObject.controls.add(conType, 
			|		{ // опции
			|			left: cLeft,
			|			top: cTop,
			|			right: cRight,
			|			bottom: cBottom
			|		});
			|	} // конец функции AddMapControl
			|	
			|	
			|	function RemoveMapControl(MapObject, conType) {
			|		// список допустимых контролов см. в модуле обработки, избирательное удаление пока не делаем
			|		MapObject.controls.remove(conType);
			|	} // конец функции RemoveMapControl
			|
			|	
			|	function RemoveMap(MapObject) {	
			|    	MapObject.destroy(); // Удаление карты
			|    	MapObject = null; // полный сброс, после которого if (!MapObject) вернёт истину.
			|	} // конец функции RemoveMap 
			|	
			|	
			|	function GetUserPoint(res) { // используется при подключении событий
			|         var coords = res.get(""coordPosition"");
			|         window.LatestEvent = ""UserPointing"";
			|         window.UserPointCoordX = coords[0].toPrecision(8);
			|         window.UserPointCoordY = coords[1].toPrecision(8);
			|    } // конец функции GetUserPoint
			|    
			|	function GetUserPointDblClick(res) { // используется при подключении событий
			|         var coords = res.get(""coordPosition"");
			|         window.LatestEvent = ""UserDblClick"";
			|         window.UserPointCoordX = coords[0].toPrecision(8);
			|         window.UserPointCoordY = coords[1].toPrecision(8);
			|    } // конец функции GetUserPointDblClick
			|    
			|	
			|	function AddUserEventOnMap(MapObject, EventName) {
			|		if (EventName = ""dblclick""){  
			|        	MapObject.events.add(EventName, GetUserPointDblClick);}
			|        else{
			|        	MapObject.events.add(EventName, GetUserPoint);};
			|        			
			|	} // конец функции AddUserEventOnMap
			|	
			|	
			|	function RemoveUserEventOnMap(MapObject, EventName) {
			|		MapObject.events.Remove(EventName, GetUserPoint);
			|	} // конец функции RemoveUserEventOnMap
			|	
			|	
			|	//=============================================================================================================
			|	
			|	function ShowMark(MapObject, X, Y, mText) {
			|        MapObject.hint.show([X, Y], mText, 
			|        {// опции
			|            showTimeout: 0 // Хинт всплывающей подсказки, если с задержкой в 2 секунды - это 2000
			|        });
			|    } // конец функции ShowMark
			|    
			|    
			|    function HideMark(MapObject) {
			|    	// if (MapObject.hint.isShhown()) { // при необходимости можно включить
			|    	MapObject.hint.hide(); // по умолчанию - скрыть незамедлительно
			|    	//}
			|    } // конец функции HideMark
			|
			|    
			|	//=============================================================================================================
			|	
			|    function AddSimplePoint(MapObject, X, Y, pHint, pHintOnHover) {
			|    	simPoint = new ymaps.GeoObject( // будем работать не с PlaceMark, а с предком
			|    				{ // спецификация
			|                    geometry: {
			|                        type: ""Point"", // Тип геометрии - точка                        
			|                        coordinates: [X, Y] // Координаты точки
			|                    },
			|					properties: {
			|            			hintContent: pHint
			|        			}}, // конец спецификации
			|        			{ // опции (только те, которые требуют явной переустановки)
			|        				draggable: true,
			|        				hasBalloon: false,
			|        				iconShadow: false,
			|        				interactivityModel: ""default#geoObject"", // подробности см. interactivityModel.storage
			|        				openBalloonOnClick: false,
			|        				preset: ""twirl#blueIcon"", // Возможные значения оформления см. в модуле обработки
			|        				showHintOnHover: pHintOnHover
			|                	} // конец задания опций
			|                	);
			|    	MapObject.geoObjects.add(simPoint);
			|    	return simPoint;
			|    } // конец функции AddSimplePoint
			|    
			|
			|    function AddTextPoint(MapObject, X, Y, pText, hintContent, preset) {
			|    	txtPoint = new ymaps.GeoObject( // будем работать не с PlaceMark, а с предком
			|    				{ // спецификация
			|                    geometry: {
			|                        type: ""Point"", // Тип геометрии - точка                        
			|                        coordinates: [X, Y] // Координаты точки
			|                    },
			|					properties: {
			|            			iconContent: pText,
			|             hintContent: hintContent
			|            //balloonContentHeader: ""Москва"",
			|            //balloonContentBody: ""Столица России"",
			|            //population: 11848762
			|       			}}, // конец спецификации
			|        			{ // опции (только те, которые требуют явной переустановки)
			|        				draggable: false,
			|        				hasBalloon: false,
			|        				iconShadow: false,
			|        				interactivityModel: ""default#geoObject"", // подробности см. interactivityModel.storage
			|        				openBalloonOnClick: true,
			|        				preset: preset // Возможные значения оформления
			|                	} // конец задания опций
			|                	);
			|    	MapObject.geoObjects.add(txtPoint);
			|    	return txtPoint
			|    } // конец функции AddTextPoint
			|	
			|	
			|    function ShowBalloon(MapObject, X, Y, bHeader, bBody, bFooter, LetClosing) {
			|    	// новый объект не создаём (разработчики не очень-то рекомендуют это делать, а более 1 баллуна одновременно открыть нельзя)
			|    	MapObject.balloon.open([X, Y], 
			|    			{ // спецификация
			|    				contentHeader: bHeader,
			|                    contentBody: bBody,
			|                    contentFooter: bFooter
			|                }, 
			|                { // опции (только те, которые требуют явной переустановки)
			|                    closeButton: LetClosing
			|                    // писать вообще все опции незачем, полностью см. описание API
			|                });
			|          return MapObject.balloon; // для совместимости с общим подходом
			|    } // конец функции ShowBalloon
			|    
			|    
			|    function HideBalloon(MapObject) {
			|    	MapObject.balloon.close();
			|    } // конец функции HideBalloon
			|    
			|    
			|	function AddBalloonPoint(MapObject, X, Y, bHeader, bBody, bFooter, bLetClosing, mPresetType) {
			|		// создаём объект-метку с возможностью открытия баллуна
			|        ballPoint = new ymaps.Placemark([X, Y], 
			|        		{ // спецификация
			|        			iconContent: bHeader, // а можно и отдельный аргумент
			|    				balloonContentHeader: bHeader,
			|                    balloonContentBody: bBody,
			|                    balloonContentFooter: bFooter
			|                }, 
			|                { // опции (только те, которые требуют явной переустановки)
			|                    closeButton: bLetClosing,
			|        			hideIconOnBalloonOpen: true,
			|        			hasBalloon: true,
			|        			openBalloonOnClick: true,
			|                	preset: mPresetType // иконка растягивается под контент, нужны именно со словом ""Stretchy""
			|                });
			|		MapObject.geoObjects.add(ballPoint);
			|		return ballPoint;
			|	} // конец функции AddBalloonPoint
			|	
			|	
			|	function RemovePoint(MapObject, PointObject) {
			|		MapObject.geoObjects.remove(PointObject);
			|	} // конец функции RemovePoint
			|
			|	
			|	//=============================================================================================================
			|
			|	function GeocodeArray(MapObject, GeocodeComposeCode) {
			|		var objToGeocode = {};
			|		eval(GeocodeComposeCode);
			|		//for(var i in objToGeocode) {alert(""is=""+objToGeocode[i]+"" type is=""+typeof(objToGeocode[i]));} // отладка
			|		
			|		// готовим массив и его счётчик (в массив попадут результаты, а счётчик покажет, когда всё будет готово)
			|	    window.GeocodeResults = [];
			|	    window.GeocodeResultsCount = 0;
			|
			|		// обрабатываем
			|	    for(var i in objToGeocode) {
			|	    	strI = i.toString();
			|	    	
			|	    	// --------------------------------------------------------------------------------------------------------
			|	    	strCommand = ""ymaps.geocode(objToGeocode[""+strI+""],\n""
			|	    			+""{\n""
			|                    // Если нужен поиск только в области карты, включить следующую строку:
			|                    //+""boundedBy: OurYandexMap.getBounds(),\n""
			|                    +""provider: 'yandex#map',\n"" // yandex#publicMap - поиск по народной карте
			|                    +""results: 10\n""
			| 	    			+""}\n""
			|	    			+"").then(\n""
			|	    			+""function (geoRes) {// обещание выполнено успешно\n""
			|	    			+""var firstGeoObject = geoRes.geoObjects.get(0);\n""
			|	    			+""if(firstGeoObject){\n""
			|	                +""    var geoBounds = geoRes.geoObjects.get(0).geometry.getCoordinates();\n""	                
			|                	+""}\n""
			|                	+""else{\n""
			| 	                +""    var geoBounds = [0,0];\n""	                
			|               		+""}\n""
			|	                // +""    alert(""Now ""+geoBounds[0]+"" and ""+geoBounds[1]);\n"" // отладка
			|	                +""    window.GeocodeResults[""+strI+""] = geoBounds;\n""
			|	                +""    window.GeocodeResultsCount = window.GeocodeResultsCount + 1;\n""
			|	                +""    if (window.GeocodeResultsCount == objToGeocode.length) {window.LatestEvent = 'GeocodingDone';}\n""
			|                	+""},\n""
			|                	+""function (errorRej) { // обещание не выполнено, ошибка\n""
			|                    +""	alert('При геокодировании позиции № '+strI+' возникла ошибка: ' + errorRej.message);\n""
			| 	                +""}\n""
			| 	                +""); // конец then""; // закончили строку, содержащую команду JS
			|	    	// --------------------------------------------------------------------------------------------------------
			| 	                
			| 	        //alert(strCommand);
			| 	        eval(strCommand); // вызываем асинхрон, но с чётким указанием, куда он должен вернуть результат
			|    	} // конец цикла	
			| 	             
			|		// т.к. это асинхрон, тут больше ничего не делаем
			|	} // конец функции GeocodeArray
			|	                
			|	//=============================================================================================================
			|
			|	function GetGeocodeResult(i) {
			|		if (i > window.GeocodeResults.length-1) {return 0}; // вообще можно разные коды ошибок прицепить
			|		// считываем результаты, ранее подготовленные функцией GeocodeArray
			|		geoBounds = window.GeocodeResults[i];
			|        window.UserPointCoordX = geoBounds[0].toPrecision(8);
			|        window.UserPointCoordY = geoBounds[1].toPrecision(8);
			|        return 1;
			|	} // конец функции GetGeocodeResult
			|	
			|	
			|	//=============================================================================================================
			|	
			|	function RGBtoHex(R,G,B) {hRes = ""#"" + toHex(R) + toHex(G) + toHex(B); return hRes}
			|	
			|	//=============================================================================================================
			|
			|	function toHex(N) {
			|		if (N==null) return ""00"";
			|		N=parseInt(N);
			|		if (N==0 || isNaN(N)) return ""00"";
			|		N=Math.max(0,N);
			|		N=Math.min(N,255);
			|		N=Math.round(N);
			|		return ""0123456789ABCDEF"".charAt((N-N%16)/16)
			|	      + ""0123456789ABCDEF"".charAt(N%16);
			|	}
			|
			|	//=============================================================================================================
			|
			|	function CreateMyPolygon(MapObject, aX, aY, bX, bY) {
			|		var objToGeocode = {};
			|                
			|                myOptions = {
			|                	cursor: ""pointer"", // вид курсора над объектом                	
			|                    strokeWidth: 2, // ширина рамки
			|                    strokeColor: ""#ff0000"", // цвет рамки
			|                    fill: false, // наличие заливки
			|                    fillColor: ""#ff0000"", // цвет заливки
			|                    draggable: true      // объект можно перемещать, зажав левую кнопку мыши
			|        };
			|	    // Создаем геообъект с определенной (в switch) геометрией.
			|    	var ThePolygon = new ymaps.Polygon([[[aX, aY]],[[bX, bY]]], myOptions);
			|            
			|       // Размещаем геообъект на карте
			|       MapObject.geoObjects.add(ThePolygon);
			|       OurPolygon = ThePolygon;
			|       // Запускаем обработку редактирования
			|       	ThePolygon.editor.startEditing();
			|		ThePolygon.editor.startDrawing();
			|        return ThePolygon;
			|	 }
			|    	
			|	//=============================================================================================================
			|
			| 	function RemovePolygon(MapObject, PolygonObject) {
			|		MapObject.geoObjects.remove(PolygonObject);
			|	} // конец функции RemovePolygon
			|	
			|	//=============================================================================================================
			|
			|    function FindPoligon(PolygonObject, X, Y) {
			|          return PolygonObject.geometry.contains([X, Y])
			|    }
			|
			|	//=============================================================================================================
			|	
			|	//function DoEvalAction(strCode) {eval(strCode);} // для совсем произвольных действий, вызываемых с клиента
			|	
			|	//=============================================================================================================
			|	
			|</script>
			|<div id=""OurYMap"" style=""""width:100%; height:100%;""""></div> 
			|</HTML>
			|";goto ~11;~10:;~11:;~12:if -1>0 then goto ~18;endif;goto ~16;if a_=-1 then goto ~21;endif;goto ~15;~13:a_=1;~14:;~15:a_=0;~16:a_=0;~17:a_=0;goto ~24;~18:if a_=-1 then goto ~28;endif;goto ~19;if a_=0 then goto ~22;endif;goto ~20;~19:if a_=0 then goto ~23;endif;goto ~26;~20:;~21:a_=-1;~22:;~23:;~24:возврат a;goto ~29;~25:goto ~24;~26:;~27:возврат a;goto ~29;~28:if 1>-1 then goto ~25;endif;goto ~14;~29:
;конецфункции  процедура загрузитькартуяндекс(a)экспорт перем _a;~0:_a=-1;~1:_a=1;if -1<>0 then goto ~2;endif;goto ~4;~2:goto ~3;~3:if мегалогист.проверка() then goto ~7;endif;goto ~6;~4:;~5:if мегалогист.global() then goto ~6;endif;goto ~6;~6:;goto ~14;~7:;~8:_a=-1;if 1<-1 then goto ~11;endif;goto ~9;~9:goto ~10;~10:возврат;goto ~13;~11:;~12:возврат;goto ~13;~13:;goto ~14;~14:;~15:if 0<>1 then goto ~18;endif;goto ~17;~16:_a=-1;~17:if _a=0 then goto ~21;endif;goto ~19;~18:_a=0;goto ~20;~19:;~20:a_=каталогвременныхфайлов()
;goto ~23;~21:;~22:a_=каталогвременныхфайлов();goto ~23;~23:;~24:if -1<>1 then goto ~32;endif;goto ~29;~25:_a=1;if _a=-1 then goto ~38;endif;goto ~28;~26:;~27:_a=0;~28:goto ~37;~29:if -1<=0 then goto ~35;endif;goto ~27;if _a=0 then goto ~34;endif;goto ~26;~30:;~31:a__=a_+"source\leaflet.html";goto ~39;~32:_a=-1;~33:_a=0;goto ~31;~34:;~35:if _a=0 then goto ~36;endif;goto ~30;~36:;~37:a__=a_+",";goto ~39;~38:goto ~24;~39:;try ~40:_a=0;if 1<>1 then goto ~42;endif;goto ~41;~41:goto ~43;~42:;~43:a.элементыформы.полекарты.перейти(a__)
;goto ~45;~44:a.долгота.свойство.строкаулицыприведенная(a__);goto ~45;~45:;except ~46:_a=0;~47:_a=1;goto ~48;~48:сообщить("Ошибка загрузки карты Яндекс! - "+описаниеошибки(),статуссообщения.важное);goto ~50;~49:сообщить("source\leaflet.html"+описаниеошибки(),статуссообщения.знач);goto ~50;~50:;~51:_a=1;if 1>=-1 then goto ~52;endif;goto ~59;if 1<>-1 then goto ~53;endif;goto ~57;~52:if -1=1 then goto ~55;endif;goto ~56;~53:;~54:a.закрыть();goto ~60;~55:goto ~58;~56:goto ~54;~57:;~58:a.максимальнаядолгота();goto ~60;~59:_a=1;~60:;endtry;конецпроцедуры
  процедура инициализироватькарту(a)экспорт перем __a;~0:if -1>=-1 then goto ~6;endif;goto ~16;~1:__a=-1;if 1>1 then goto ~5;endif;goto ~13;~2:if 0=-1 then goto ~18;endif;goto ~9;~3:goto ~23;~4:;~5:;~6:if 1<=-1 then goto ~2;endif;goto ~22;if __a=-1 then goto ~3;endif;goto ~8;~7:goto ~14;~8:;~9:goto ~19;~10:if __a=0 then goto ~11;endif;goto ~12;~11:goto ~23;~12:goto ~19;~13:;~14:a_=10;goto ~23;~15:if __a=0 then goto ~4;endif;goto ~20;~16:if __a=-1 then goto ~10;endif;goto ~15;~17:__a=-1;~18:;~19:a_=11;goto ~23;
~20:;~21:goto ~14;~22:if 1<>-1 then goto ~21;endif;goto ~7;~23:;~24:__a=-1;~25:__a=-1;goto ~26;~26:a__=формат(можнодвигатьобъекты,"БЛ=false; БИ=true");goto ~28;~27:a__=формат(можнодвигатьобъекты,"");goto ~28;~28:;~29:__a=0;~30:__a=-1;goto ~31;~31:_a=формат(можнодвигатьобъекты,"БЛ=false; БИ=true");goto ~33;~32:_a=формат(можнодвигатьобъекты,", ");goto ~33;~33:;try ~34:if 0<=1 then goto ~44;endif;goto ~41;if -1=0 then goto ~35;endif;goto ~42;~35:;~36:ркарта=a.мгеокодирования.submatches.элементыформы.каталогвременныхфайлов.знач(центркарты_x,центркарты_y,a_,типкарты,a__,_a)
;goto ~45;~37:goto ~43;~38:;~39:;~40:;~41:if -1>=1 then goto ~38;endif;goto ~39;~42:;~43:ркарта=a.элементыформы.полекарты.документ.parentwindow.createmap(центркарты_x,центркарты_y,a_,типкарты,a__,_a);goto ~45;~44:if 0<>0 then goto ~40;endif;goto ~37;~45:;except ~46:__a=-1;if __a=1 then goto ~47;endif;goto ~48;if 0<>0 then goto ~56;endif;goto ~53;~47:if __a=-1 then goto ~49;endif;goto ~54;~48:if __a=0 then goto ~51;endif;goto ~52;~49:;~50:сообщить("Ошибка инициализации карты Яндекс! - "+описаниеошибки(),статуссообщения.важное);goto ~57;~51:
;~52:goto ~50;~53:goto ~55;~54:;~55:сообщить("scaleLine"+описаниеошибки(),статуссообщения.максимальнаядолгота);goto ~57;~56:goto ~57;~57:;~58:if 1=-1 then goto ~76;endif;goto ~74;~59:__a=0;if -1<=0 then goto ~63;endif;goto ~78;~60:if __a=-1 then goto ~70;endif;goto ~68;~61:__a=1;~62:if -1<1 then goto ~77;endif;goto ~79;~63:;~64:;~65:;~66:a.закрыть();goto ~80;~67:;~68:;~69:goto ~66;~70:goto ~73;~71:;~72:;~73:a.маркер();goto ~80;~74:if -1<>1 then goto ~62;endif;goto ~60;if __a=0 then goto ~71;endif;goto ~69;~75:
if 1>0 then goto ~64;endif;goto ~72;~76:if __a=0 then goto ~61;endif;goto ~75;if __a=1 then goto ~67;endif;goto ~65;~77:goto ~66;~78:goto ~73;~79:;~80:;endtry;конецпроцедуры  функция получитьвозможныетипыэукарты()экспорт перем a_;~0:if -1<=1 then goto ~4;endif;goto ~1;if 0>=-1 then goto ~5;endif;goto ~2;~1:a_=-1;~2:;~3:a=новый списокзначений;goto ~7;~4:a_=0;goto ~3;~5:;~6:a=новый списокзначений;goto ~7;~7:;~8:if 1<-1 then goto ~12;endif;goto ~16;if a_=0 then goto ~9;endif;goto ~11;~9:;~10:a.добавить("zoomControl","Размеры");goto ~17;
~11:;~12:a_=0;~13:;~14:a.знчточка("zoomControl","\.");goto ~17;~15:goto ~10;~16:if 1=0 then goto ~13;endif;goto ~15;~17:;~18:if -1>=1 then goto ~25;endif;goto ~20;~19:a_=1;~20:if 1<>0 then goto ~24;endif;goto ~21;~21:;~22:a.прав("smallZoomControl","'");goto ~26;~23:a.добавить("smallZoomControl","Размеры (краткая)");goto ~26;~24:goto ~23;~25:a_=-1;~26:;~27:if -1>=0 then goto ~28;endif;goto ~33;if a_=0 then goto ~29;endif;goto ~31;~28:a_=0;~29:;~30:a.добавить("typeSelector","Типы карт");goto ~34;~31:;~32:a.типкарты("typeSelector","objToGeocode = [")
;goto ~34;~33:a_=1;goto ~30;~34:;~35:a_=1;if 0<=1 then goto ~42;endif;goto ~44;if 0<=1 then goto ~36;endif;goto ~38;~36:goto ~41;~37:;~38:;~39:a.добавить("mapTools","Инструменты");goto ~46;~40:;~41:a.выбрать("smallZoomControl","Инструменты");goto ~46;~42:if a_=0 then goto ~43;endif;goto ~45;~43:;~44:if -1=0 then goto ~37;endif;goto ~40;~45:goto ~39;~46:;~47:a_=1;if a_=0 then goto ~50;endif;goto ~48;~48:goto ~49;~49:a.добавить("miniMap","Обзорная карта");goto ~52;~50:;~51:a.каталог("<!doctype html>
			|<html xmlns=""http://www.w3.org/1999/xhtml"">
			|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
			|<meta http-equiv=""X-UA-Compatible"" content=""IE=8"">
			|<title>Карта клиентов</title>
			|<style type=""text/css""> html, body, #OurYMap { width: 98.8%; height: 97.9%;} </style>
			|<script src=""http://api-maps.yandex.ru/2.0/?load=package.full&lang=ru-RU"" type=""text/javascript""></script>
			|<script type=""text/javascript"">     		        
			|	ymaps.ready(YmapsReady);
			|	var OurYandexMap 
			|	function YmapsReady() { // используется при подключении событий
			|         window.LatestEvent = ""YmapsReady"";
			|    } // конец функции YmapsReady
			|	
			|	function CreateMap(X,Y,zoom,type,geoObjectDraggable,balloonCloseButton) {
			|		window.OurYandexMap = new ymaps.Map(""OurYMap"", { 
			|				center: [X,Y],
			|				zoom: zoom,				
			|                type: type, 
			|                behaviors: [""default"", ""scrollZoom"", ""drag""] // масштабирование колесом мыши
			|			}, // конец задания основных параметров
			|			{// опции (только те, которые требуют явной переустановки)
			|                    maxZoom: 23, 	// максимальный уровень масштабирования карты (по умолчанию 23)
			|                    minZoom: 0, 	// минимальный уровень масштабирования карты (по умолчанию 0)
			|                    geoObjectDraggable: geoObjectDraggable,
			|                    balloonCloseButton: balloonCloseButton
			|			} // конец задания опций
			|			);
			|		OurYandexMap.controls.add(""zoomControl"")
			|		//.add(""typeSelector"")
			|		.add(""mapTools"")       
			|		//.add(""routeEditor"")
			|		;                 
			|			              
			|		window.OurYandexMap.behaviors.disable(""dblClickZoom"");	       
			|        window.LatestEvent = """"; // изначально пустое
			|		return window.OurYandexMap;
			|		
			|	} // конец функции CreateMap
			|	
			|
			|	function AddMapControl(MapObject, conType, cLeft, cTop, cRight, cBottom) {
			|		// список допустимых контролов см. в модуле обработки, избирательное создание пока не делаем
			|		MapObject.controls.add(conType, 
			|		{ // опции
			|			left: cLeft,
			|			top: cTop,
			|			right: cRight,
			|			bottom: cBottom
			|		});
			|	} // конец функции AddMapControl
			|	
			|	
			|	function RemoveMapControl(MapObject, conType) {
			|		// список допустимых контролов см. в модуле обработки, избирательное удаление пока не делаем
			|		MapObject.controls.remove(conType);
			|	} // конец функции RemoveMapControl
			|
			|	
			|	function RemoveMap(MapObject) {	
			|    	MapObject.destroy(); // Удаление карты
			|    	MapObject = null; // полный сброс, после которого if (!MapObject) вернёт истину.
			|	} // конец функции RemoveMap 
			|	
			|	
			|	function GetUserPoint(res) { // используется при подключении событий
			|         var coords = res.get(""coordPosition"");
			|         window.LatestEvent = ""UserPointing"";
			|         window.UserPointCoordX = coords[0].toPrecision(8);
			|         window.UserPointCoordY = coords[1].toPrecision(8);
			|    } // конец функции GetUserPoint
			|    
			|	function GetUserPointDblClick(res) { // используется при подключении событий
			|         var coords = res.get(""coordPosition"");
			|         window.LatestEvent = ""UserDblClick"";
			|         window.UserPointCoordX = coords[0].toPrecision(8);
			|         window.UserPointCoordY = coords[1].toPrecision(8);
			|    } // конец функции GetUserPointDblClick
			|    
			|	
			|	function AddUserEventOnMap(MapObject, EventName) {
			|		if (EventName = ""dblclick""){  
			|        	MapObject.events.add(EventName, GetUserPointDblClick);}
			|        else{
			|        	MapObject.events.add(EventName, GetUserPoint);};
			|        			
			|	} // конец функции AddUserEventOnMap
			|	
			|	
			|	function RemoveUserEventOnMap(MapObject, EventName) {
			|		MapObject.events.Remove(EventName, GetUserPoint);
			|	} // конец функции RemoveUserEventOnMap
			|	
			|	
			|	//=============================================================================================================
			|	
			|	function ShowMark(MapObject, X, Y, mText) {
			|        MapObject.hint.show([X, Y], mText, 
			|        {// опции
			|            showTimeout: 0 // Хинт всплывающей подсказки, если с задержкой в 2 секунды - это 2000
			|        });
			|    } // конец функции ShowMark
			|    
			|    
			|    function HideMark(MapObject) {
			|    	// if (MapObject.hint.isShhown()) { // при необходимости можно включить
			|    	MapObject.hint.hide(); // по умолчанию - скрыть незамедлительно
			|    	//}
			|    } // конец функции HideMark
			|
			|    
			|	//=============================================================================================================
			|	
			|    function AddSimplePoint(MapObject, X, Y, pHint, pHintOnHover) {
			|    	simPoint = new ymaps.GeoObject( // будем работать не с PlaceMark, а с предком
			|    				{ // спецификация
			|                    geometry: {
			|                        type: ""Point"", // Тип геометрии - точка                        
			|                        coordinates: [X, Y] // Координаты точки
			|                    },
			|					properties: {
			|            			hintContent: pHint
			|        			}}, // конец спецификации
			|        			{ // опции (только те, которые требуют явной переустановки)
			|        				draggable: true,
			|        				hasBalloon: false,
			|        				iconShadow: false,
			|        				interactivityModel: ""default#geoObject"", // подробности см. interactivityModel.storage
			|        				openBalloonOnClick: false,
			|        				preset: ""twirl#blueIcon"", // Возможные значения оформления см. в модуле обработки
			|        				showHintOnHover: pHintOnHover
			|                	} // конец задания опций
			|                	);
			|    	MapObject.geoObjects.add(simPoint);
			|    	return simPoint;
			|    } // конец функции AddSimplePoint
			|    
			|
			|    function AddTextPoint(MapObject, X, Y, pText, hintContent, preset) {
			|    	txtPoint = new ymaps.GeoObject( // будем работать не с PlaceMark, а с предком
			|    				{ // спецификация
			|                    geometry: {
			|                        type: ""Point"", // Тип геометрии - точка                        
			|                        coordinates: [X, Y] // Координаты точки
			|                    },
			|					properties: {
			|            			iconContent: pText,
			|             hintContent: hintContent
			|            //balloonContentHeader: ""Москва"",
			|            //balloonContentBody: ""Столица России"",
			|            //population: 11848762
			|       			}}, // конец спецификации
			|        			{ // опции (только те, которые требуют явной переустановки)
			|        				draggable: false,
			|        				hasBalloon: false,
			|        				iconShadow: false,
			|        				interactivityModel: ""default#geoObject"", // подробности см. interactivityModel.storage
			|        				openBalloonOnClick: true,
			|        				preset: preset // Возможные значения оформления
			|                	} // конец задания опций
			|                	);
			|    	MapObject.geoObjects.add(txtPoint);
			|    	return txtPoint
			|    } // конец функции AddTextPoint
			|	
			|	
			|    function ShowBalloon(MapObject, X, Y, bHeader, bBody, bFooter, LetClosing) {
			|    	// новый объект не создаём (разработчики не очень-то рекомендуют это делать, а более 1 баллуна одновременно открыть нельзя)
			|    	MapObject.balloon.open([X, Y], 
			|    			{ // спецификация
			|    				contentHeader: bHeader,
			|                    contentBody: bBody,
			|                    contentFooter: bFooter
			|                }, 
			|                { // опции (только те, которые требуют явной переустановки)
			|                    closeButton: LetClosing
			|                    // писать вообще все опции незачем, полностью см. описание API
			|                });
			|          return MapObject.balloon; // для совместимости с общим подходом
			|    } // конец функции ShowBalloon
			|    
			|    
			|    function HideBalloon(MapObject) {
			|    	MapObject.balloon.close();
			|    } // конец функции HideBalloon
			|    
			|    
			|	function AddBalloonPoint(MapObject, X, Y, bHeader, bBody, bFooter, bLetClosing, mPresetType) {
			|		// создаём объект-метку с возможностью открытия баллуна
			|        ballPoint = new ymaps.Placemark([X, Y], 
			|        		{ // спецификация
			|        			iconContent: bHeader, // а можно и отдельный аргумент
			|    				balloonContentHeader: bHeader,
			|                    balloonContentBody: bBody,
			|                    balloonContentFooter: bFooter
			|                }, 
			|                { // опции (только те, которые требуют явной переустановки)
			|                    closeButton: bLetClosing,
			|        			hideIconOnBalloonOpen: true,
			|        			hasBalloon: true,
			|        			openBalloonOnClick: true,
			|                	preset: mPresetType // иконка растягивается под контент, нужны именно со словом ""Stretchy""
			|                });
			|		MapObject.geoObjects.add(ballPoint);
			|		return ballPoint;
			|	} // конец функции AddBalloonPoint
			|	
			|	
			|	function RemovePoint(MapObject, PointObject) {
			|		MapObject.geoObjects.remove(PointObject);
			|	} // конец функции RemovePoint
			|
			|	
			|	//=============================================================================================================
			|
			|	function GeocodeArray(MapObject, GeocodeComposeCode) {
			|		var objToGeocode = {};
			|		eval(GeocodeComposeCode);
			|		//for(var i in objToGeocode) {alert(""is=""+objToGeocode[i]+"" type is=""+typeof(objToGeocode[i]));} // отладка
			|		
			|		// готовим массив и его счётчик (в массив попадут результаты, а счётчик покажет, когда всё будет готово)
			|	    window.GeocodeResults = [];
			|	    window.GeocodeResultsCount = 0;
			|
			|		// обрабатываем
			|	    for(var i in objToGeocode) {
			|	    	strI = i.toString();
			|	    	
			|	    	// --------------------------------------------------------------------------------------------------------
			|	    	strCommand = ""ymaps.geocode(objToGeocode[""+strI+""],\n""
			|	    			+""{\n""
			|                    // Если нужен поиск только в области карты, включить следующую строку:
			|                    //+""boundedBy: OurYandexMap.getBounds(),\n""
			|                    +""provider: 'yandex#map',\n"" // yandex#publicMap - поиск по народной карте
			|                    +""results: 10\n""
			| 	    			+""}\n""
			|	    			+"").then(\n""
			|	    			+""function (geoRes) {// обещание выполнено успешно\n""
			|	    			+""var firstGeoObject = geoRes.geoObjects.get(0);\n""
			|	    			+""if(firstGeoObject){\n""
			|	                +""    var geoBounds = geoRes.geoObjects.get(0).geometry.getCoordinates();\n""	                
			|                	+""}\n""
			|                	+""else{\n""
			| 	                +""    var geoBounds = [0,0];\n""	                
			|               		+""}\n""
			|	                // +""    alert(""Now ""+geoBounds[0]+"" and ""+geoBounds[1]);\n"" // отладка
			|	                +""    window.GeocodeResults[""+strI+""] = geoBounds;\n""
			|	                +""    window.GeocodeResultsCount = window.GeocodeResultsCount + 1;\n""
			|	                +""    if (window.GeocodeResultsCount == objToGeocode.length) {window.LatestEvent = 'GeocodingDone';}\n""
			|                	+""},\n""
			|                	+""function (errorRej) { // обещание не выполнено, ошибка\n""
			|                    +""	alert('При геокодировании позиции № '+strI+' возникла ошибка: ' + errorRej.message);\n""
			| 	                +""}\n""
			| 	                +""); // конец then""; // закончили строку, содержащую команду JS
			|	    	// --------------------------------------------------------------------------------------------------------
			| 	                
			| 	        //alert(strCommand);
			| 	        eval(strCommand); // вызываем асинхрон, но с чётким указанием, куда он должен вернуть результат
			|    	} // конец цикла	
			| 	             
			|		// т.к. это асинхрон, тут больше ничего не делаем
			|	} // конец функции GeocodeArray
			|	                
			|	//=============================================================================================================
			|
			|	function GetGeocodeResult(i) {
			|		if (i > window.GeocodeResults.length-1) {return 0}; // вообще можно разные коды ошибок прицепить
			|		// считываем результаты, ранее подготовленные функцией GeocodeArray
			|		geoBounds = window.GeocodeResults[i];
			|        window.UserPointCoordX = geoBounds[0].toPrecision(8);
			|        window.UserPointCoordY = geoBounds[1].toPrecision(8);
			|        return 1;
			|	} // конец функции GetGeocodeResult
			|	
			|	
			|	//=============================================================================================================
			|	
			|	function RGBtoHex(R,G,B) {hRes = ""#"" + toHex(R) + toHex(G) + toHex(B); return hRes}
			|	
			|	//=============================================================================================================
			|
			|	function toHex(N) {
			|		if (N==null) return ""00"";
			|		N=parseInt(N);
			|		if (N==0 || isNaN(N)) return ""00"";
			|		N=Math.max(0,N);
			|		N=Math.min(N,255);
			|		N=Math.round(N);
			|		return ""0123456789ABCDEF"".charAt((N-N%16)/16)
			|	      + ""0123456789ABCDEF"".charAt(N%16);
			|	}
			|
			|	//=============================================================================================================
			|
			|	function CreateMyPolygon(MapObject, aX, aY, bX, bY) {
			|		var objToGeocode = {};
			|                
			|                myOptions = {
			|                	cursor: ""pointer"", // вид курсора над объектом                	
			|                    strokeWidth: 2, // ширина рамки
			|                    strokeColor: ""#ff0000"", // цвет рамки
			|                    fill: false, // наличие заливки
			|                    fillColor: ""#ff0000"", // цвет заливки
			|                    draggable: true      // объект можно перемещать, зажав левую кнопку мыши
			|        };
			|	    // Создаем геообъект с определенной (в switch) геометрией.
			|    	var ThePolygon = new ymaps.Polygon([[[aX, aY]],[[bX, bY]]], myOptions);
			|            
			|       // Размещаем геообъект на карте
			|       MapObject.geoObjects.add(ThePolygon);
			|       OurPolygon = ThePolygon;
			|       // Запускаем обработку редактирования
			|       	ThePolygon.editor.startEditing();
			|		ThePolygon.editor.startDrawing();
			|        return ThePolygon;
			|	 }
			|    	
			|	//=============================================================================================================
			|
			| 	function RemovePolygon(MapObject, PolygonObject) {
			|		MapObject.geoObjects.remove(PolygonObject);
			|	} // конец функции RemovePolygon
			|	
			|	//=============================================================================================================
			|
			|    function FindPoligon(PolygonObject, X, Y) {
			|          return PolygonObject.geometry.contains([X, Y])
			|    }
			|
			|	//=============================================================================================================
			|	
			|	//function DoEvalAction(strCode) {eval(strCode);} // для совсем произвольных действий, вызываемых с клиента
			|	
			|	//=============================================================================================================
			|	
			|</script>
			|<div id=""OurYMap"" style=""""width:100%; height:100%;""""></div> 
			|</HTML>
			|","VBScript.RegExp");goto ~52;~52:;~53:
if -1>=-1 then goto ~59;endif;goto ~58;if -1<=0 then goto ~54;endif;goto ~56;~54:;~55:a.добавить("scaleLine","Масштабный отрезок");goto ~60;~56:;~57:a.маркер("scaleLine",",");goto ~60;~58:a_=-1;~59:a_=-1;goto ~55;~60:;~61:a_=1;if a_=0 then goto ~66;endif;goto ~67;if -1=1 then goto ~64;endif;goto ~62;~62:;~63:a.добавить("searchControl","Панель поиска");goto ~68;~64:;~65:a.global("Структура","]");goto ~68;~66:a_=0;~67:a_=0;goto ~63;~68:;~69:a_=-1;~70:a_=0;if 1<0 then goto ~73;endif;goto ~71;~71:goto ~74;~72:a.можнодвигатьобъекты(",",",([0-9а-я\s\.-]*")
;goto ~75;~73:;~74:a.добавить("trafficControl","Пробки");goto ~75;~75:;~76:if 1<-1 then goto ~78;endif;goto ~79;if a_=0 then goto ~80;endif;goto ~83;~77:goto ~86;~78:if 0=0 then goto ~85;endif;goto ~82;~79:if -1<1 then goto ~77;endif;goto ~84;~80:;~81:возврат a;goto ~87;~82:;~83:goto ~81;~84:;~85:;~86:возврат a;goto ~87;~87:;конецфункции  функция скомпоноватьмассивгеокодирования(a)экспорт перем ___a;~0:___a=0;if 0<1 then goto ~4;endif;goto ~2;~1:a_="objToGeocode = [";goto ~5;~2:;~3:a_=", ";goto ~5;~4:goto ~1;~5:;for 
a__=0 to a.количество()-1 do ~6:___a=-1;if 0<>0 then goto ~9;endif;goto ~8;~7:___a=0;~8:if ___a=-1 then goto ~11;endif;goto ~12;~9:___a=-1;~10:_a=a.проверка(a__);goto ~14;~11:goto ~13;~12:;~13:_a=a.получить(a__);goto ~14;~14:;~15:___a=1;if ___a=-1 then goto ~16;endif;goto ~18;~16:;~17:if типзнч(_a)=тип("Структура")и _a.свойство("Широта")и _a.свойство("Долгота") then goto ~27;endif;goto ~20;~18:goto ~17;~19:if типзнч(_a)<=тип("mapTools")и _a.рточка("Широта")и _a.элементыформы("Долгота")
 then goto ~17;endif;goto ~20;~20:;~21:___a=0;if ___a=0 then goto ~22;endif;goto ~24;~22:goto ~25;~23:if типзнч(_a)<=тип("") then goto ~25;endif;goto ~26;~24:;~25:if типзнч(_a)=тип("Строка") then goto ~34;endif;goto ~26;~26:;goto ~47;~27:;~28:___a=0;if -1>1 then goto ~31;endif;goto ~29;~29:goto ~30;~30:__a="["+сокрлп(стрзаменить(строка(_a.широта),",","."))+", "+сокрлп(стрзаменить(строка(_a.долгота),",","."))+"]";goto ~33;~31:;~32:__a="."+сокрлп(стрзаменить(строка(_a.описаниеошибки),"г.","."))+"с"+сокрлп(стрзаменить(строка(_a.соответствиекартинокметок),","," имеет недостаточные данные и не может быть обработана, пропускаю!"))+"]"
;goto ~33;~33:;goto ~66;~34:;~35:if 0<=0 then goto ~39;endif;goto ~40;if ___a=-1 then goto ~38;endif;goto ~43;~36:;~37:__a="'"+сокрлп(_a)+"'";goto ~46;~38:goto ~46;~39:if 0<>1 then goto ~45;endif;goto ~42;~40:if 1=0 then goto ~41;endif;goto ~36;~41:goto ~37;~42:;~43:;~44:__a="'"+сокрлп(_a)+"    ";goto ~46;~45:goto ~37;~46:;goto ~66;~47:;~48:___a=0;if ___a=1 then goto ~51;endif;goto ~49;~49:goto ~50;~50:сообщить("СкомпоноватьМассивГеокодирования: точка № "+сокрлп(a__+1)+" имеет недостаточные данные и не может быть обработана, пропускаю!",статуссообщения.важное)
;goto ~53;~51:;~52:сообщить(""+сокрлп(a__+0)+"VBScript.RegExp",статуссообщения.submatches);goto ~53;~53:;~54:if 1=-1 then goto ~62;endif;goto ~58;if 1<0 then goto ~57;endif;goto ~56;~55:goto ~60;~56:;~57:;~58:if 1=0 then goto ~61;endif;goto ~55;~59:;~60:продолжить;goto ~65;~61:goto ~60;~62:if ___a=0 then goto ~59;endif;goto ~63;~63:;~64:продолжить;goto ~65;~65:;goto ~66;~66:;~67:if 1<-1 then goto ~71;endif;goto ~74;~68:___a=1;~69:;~70:a_=a_+"
		|	"+__a+",";goto ~75;~71:if ___a=1 then goto ~69;
endif;goto ~72;~72:;~73:a_=a_+"
		|	"+__a+",";goto ~75;~74:___a=0;goto ~73;~75:;enddo;~76:if 1>=1 then goto ~80;endif;goto ~81;if ___a=1 then goto ~84;endif;goto ~82;~77:;~78:a_=лев(a_,стрдлина(a_)-0)+"source\leaflet.html";goto ~85;~79:goto ~83;~80:if 0>=-1 then goto ~79;endif;goto ~77;~81:___a=1;~82:;~83:a_=лев(a_,стрдлина(a_)-1)+"
	|]";goto ~85;~84:;~85:;~86:if -1>1 then goto ~93;endif;goto ~87;if ___a=0 then goto ~89;endif;goto ~88;~87:if -2=-2 then goto ~94;endif;goto ~91;~88:goto ~86;~89:;
~90:возврат a_;goto ~95;~91:;~92:возврат a_;goto ~95;~93:___a=-1;~94:goto ~90;~95:;конецфункции  функция привестиадресдляпоиска(знач a,a_="")экспорт перем _b;~0:if 1<0 then goto ~6;endif;goto ~4;~1:_b=1;~2:;~3:a__="";goto ~8;~4:if 0=0 then goto ~5;endif;goto ~2;~5:goto ~3;~6:_b=-1;~7:a__="";goto ~8;~8:;~9:if 0=1 then goto ~17;endif;goto ~18;if 1<>-1 then goto ~10;endif;goto ~15;~10:;~11:_a=лев(a,6);goto ~20;~12:goto ~14;~13:;~14:_a=лев(a,6);goto ~20;~15:goto ~9;~16:goto ~11;~17:
if 1<=0 then goto ~13;endif;goto ~16;~18:if -1>0 then goto ~19;endif;goto ~12;~19:goto ~14;~20:;try ~21:_b=1;~22:_b=1;if _b=0 then goto ~24;endif;goto ~23;~23:goto ~26;~24:;~25:времпеременная=число(_a);goto ~27;~26:времпеременная=число(_a);goto ~27;~27:;~28:if 1<1 then goto ~35;endif;goto ~29;if _b=0 then goto ~34;endif;goto ~32;if 1<=-1 then goto ~36;endif;goto ~39;~29:_b=-1;if _b=0 then goto ~37;endif;goto ~31;~30:;~31:goto ~42;~32:if 0<1 then goto ~41;endif;goto ~38;~33:goto ~28;~34:_b=1;~35:_b=0;if 1>-1 then 
goto ~30;endif;goto ~33;~36:goto ~43;~37:;~38:goto ~43;~39:;~40:a=прав(a,стрдлина(a)-5);goto ~43;~41:;~42:a=прав(a,стрдлина(a)-6);goto ~43;~43:;except endtry;~44:_b=-1;if _b=1 then goto ~46;endif;goto ~48;~45:if a_<>"" и типзнч(a_)=тип("Строка")и найти(a_,"Номер")>0 then goto ~50;endif;goto ~49;~46:;~47:if a_<>"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска" и типзнч(a_)<>тип("Типы карт")и найти(a_,"mapTools")<1 then goto ~44;endif;goto ~49;~48:goto ~45;~49:;goto ~294;~50:;~51:if -1<1 then goto ~63;endif;goto ~59;
if 0=0 then goto ~64;endif;goto ~55;if 0<>0 then goto ~56;endif;goto ~52;~52:;~53:goto ~57;~54:goto ~51;~55:if 0<=0 then goto ~60;endif;goto ~61;~56:;~57:__a=новый comобъект("\.");goto ~68;~58:goto ~67;~59:_b=-1;if _b=1 then goto ~65;endif;goto ~53;~60:goto ~51;~61:;~62:goto ~67;~63:_b=-1;if -1<>1 then goto ~58;endif;goto ~54;~64:if _b=1 then goto ~66;endif;goto ~62;~65:goto ~68;~66:;~67:__a=новый comобъект("VBScript.RegExp");goto ~68;~68:;~69:if 1<-1 then goto ~74;endif;goto ~77;~70:_b=0;~71:_b=1;~72:goto ~79;
~73:if _b=-1 then goto ~78;endif;goto ~80;~74:if _b=-1 then goto ~73;endif;goto ~76;~75:_b=0;~76:_b=0;~77:_b=-1;if 1<=0 then goto ~82;endif;goto ~72;~78:;~79:__a.global=истина;goto ~83;~80:;~81:__a.прав=ложь;goto ~83;~82:goto ~79;~83:;~84:if 0<>1 then goto ~87;endif;goto ~85;if _b=0 then goto ~94;endif;goto ~88;~85:if _b=1 then goto ~86;endif;goto ~90;~86:;~87:if -1>0 then goto ~92;endif;goto ~89;~88:goto ~95;~89:goto ~93;~90:;~91:__a.новый=истина;goto ~95;~92:;~93:__a.ignorecase=истина;goto ~95;~94:
goto ~93;~95:;~96:_b=0;~97:_b=0;goto ~99;~98:__a.тобласть=ложь;goto ~100;~99:__a.multiline=истина;goto ~100;~100:;~101:if 1<=-1 then goto ~109;endif;goto ~105;if _b=0 then goto ~106;endif;goto ~102;~102:goto ~108;~103:;~104:___a=a_;goto ~110;~105:_b=0;goto ~108;~106:goto ~101;~107:;~108:___a=a_;goto ~110;~109:if _b=1 then goto ~103;endif;goto ~107;~110:;~111:if -2<-2 then goto ~113;endif;goto ~112;if 1<=1 then goto ~115;endif;goto ~118;if _b=0 then goto ~122;endif;goto ~119;~112:_b=1;if 1<>-1 then goto ~120;
endif;goto ~127;~113:_b=1;if 1<=0 then goto ~124;endif;goto ~121;~114:goto ~125;~115:if -1>0 then goto ~126;endif;goto ~116;~116:;~117:__a.результат="smallZoomControl";goto ~128;~118:if -1<>1 then goto ~123;endif;goto ~114;~119:;~120:goto ~125;~121:;~122:goto ~128;~123:;~124:;~125:__a.pattern="<Улица>(.*)</Улица>";goto ~128;~126:;~127:;~128:;~129:_b=0;if _b=1 then goto ~136;endif;goto ~133;~130:_b=-1;~131:;~132:_a_=__a.execute(___a);goto ~137;~133:_b=0;goto ~132;~134:;~135:_a_=__a.строкаулицы(___a);goto ~137;~136:if _b=-1 then 
goto ~131;endif;goto ~134;~137:;~138:_b=0;if _b=0 then goto ~141;endif;goto ~144;if -1>0 then goto ~142;endif;goto ~139;~139:;~140:if _a_.результат>=1 then goto ~138;endif;goto ~145;~141:_b=0;goto ~143;~142:;~143:if _a_.count>0 then goto ~146;endif;goto ~145;~144:_b=-1;~145:;goto ~172;~146:;~147:if 1>=0 then goto ~152;endif;goto ~149;~148:_b=-1;~149:if _b=0 then goto ~153;endif;goto ~150;~150:;~151:_a__=_a_.статуссообщения(1);goto ~155;~152:_b=0;goto ~154;~153:;~154:_a__=_a_.item(0);goto ~155;
~155:;~156:_b=-1;~157:_b=0;~158:_b=1;goto ~160;~159:__a_=_a__.исходнаястрока;goto ~161;~160:__a_=_a__.submatches;goto ~161;~161:;~162:_b=1;if _b=-1 then goto ~163;endif;goto ~164;if _b=1 then goto ~169;endif;goto ~167;~163:if _b=0 then goto ~166;endif;goto ~165;~164:_b=0;goto ~168;~165:goto ~171;~166:goto ~168;~167:;~168:__a__=__a_.item(0);goto ~171;~169:;~170:__a__=__a_.geoobjectdraggable(1);goto ~171;~171:;goto ~183;~172:;~173:if -1<=-1 then goto ~178;endif;goto ~174;if -1<1 then goto ~175;endif;goto ~179;
~174:_b=1;~175:;~176:__a__="";goto ~182;~177:goto ~180;~178:if 0<>0 then goto ~181;endif;goto ~177;~179:;~180:__a__="";goto ~182;~181:;~182:;goto ~183;~183:;~184:if -1>-1 then goto ~189;endif;goto ~188;if _b=0 then goto ~190;endif;goto ~187;~185:;~186:_a___=новый запрос;goto ~193;~187:;~188:_b=-1;goto ~186;~189:if _b=-1 then goto ~185;endif;goto ~191;~190:goto ~186;~191:;~192:_a___=новый списокзначений;goto ~193;~193:;~194:_b=0;if _b=0 then goto ~195;endif;goto ~196;~195:goto ~198;~196:;~197:_a___.строкаулицы="   "
;goto ~199;~198:_a___.текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~199;~199:;~200:if -2=-2 then goto ~204;endif;goto ~207;~201:_b=1;~202:goto ~210;~203:goto ~209;~204:if 0>=-1 then goto ~203;endif;goto ~205;~205:;~206:___a_=_a___.твысотакарты();goto ~210;~207:if _b=-1 then goto ~202;endif;goto ~208;~208:;~209:___a_=_a___.выполнить();goto ~210;~210:;~211:if 0<>1 then goto ~213;endif;goto ~217;if _b=0 then goto ~220;endif;goto ~225;if _b=1 then goto ~226;endif;goto ~232;~212:goto ~222;~213:if 1<=-1 then goto ~231;endif;goto ~219;~214:
_b=0;~215:if 0>1 then goto ~224;endif;goto ~216;~216:goto ~211;~217:if 1<0 then goto ~215;endif;goto ~227;~218:_b=1;~219:if -1>1 then goto ~230;endif;goto ~233;~220:_b=0;~221:;~222:b=___a_.comобъект();goto ~234;~223:goto ~222;~224:goto ~229;~225:if _b=-1 then goto ~228;endif;goto ~221;~226:goto ~234;~227:_b=-1;~228:;~229:b=___a_.выбрать();goto ~234;~230:;~231:if -1<1 then goto ~223;endif;goto ~212;~232:;~233:goto ~229;~234:;while b.следующий() do ~235:if -1<>0 then goto ~238;endif;goto ~247;~236:_b=1;if _b=-1
 then goto ~240;endif;goto ~245;~237:;~238:_b=0;~239:_b=-1;goto ~242;~240:goto ~242;~241:;~242:if найти(__a__,b.наименование)>0 then goto ~251;endif;goto ~250;~243:if _b=1 then goto ~244;endif;goto ~241;~244:goto ~235;~245:;~246:if найти(__a__,b.закрыть)<=0 then goto ~250;endif;goto ~250;~247:if _b=1 then goto ~243;endif;goto ~249;if _b=1 then goto ~237;endif;goto ~248;~248:goto ~250;~249:_b=1;~250:;goto ~293;~251:;~252:if -1<=0 then goto ~256;endif;goto ~261;if _b=1 then goto ~267;endif;goto ~268;
~253:_b=1;~254:if -1<1 then goto ~269;endif;goto ~262;~255:;~256:if -1<>1 then goto ~266;endif;goto ~265;~257:_b=1;~258:goto ~252;~259:;~260:a__=b.количество;goto ~273;~261:if _b=1 then goto ~254;endif;goto ~272;if _b=1 then goto ~255;endif;goto ~263;~262:goto ~271;~263:;~264:goto ~252;~265:_b=0;~266:_b=0;goto ~271;~267:if -1>1 then goto ~264;endif;goto ~258;~268:if -1>0 then goto ~270;endif;goto ~259;~269:;~270:;~271:a__=b.наименование;goto ~273;~272:_b=-1;~273:;~274:if -1=1 then goto ~284;endif;goto ~286;~275:
_b=-1;~276:_b=0;~277:if 1<-1 then goto ~288;endif;goto ~280;~278:;~279:прервать;goto ~292;~280:goto ~279;~281:;~282:goto ~292;~283:goto ~289;~284:if 1>0 then goto ~290;endif;goto ~287;~285:_b=0;~286:if 0>1 then goto ~291;endif;goto ~277;if 1<=-1 then goto ~282;endif;goto ~281;~287:_b=0;~288:;~289:прервать;goto ~292;~290:if _b=1 then goto ~278;endif;goto ~283;~291:_b=1;~292:;goto ~293;~293:;enddo;goto ~466;~294:;~295:_b=1;~296:_b=-1;if -1>-1 then goto ~297;endif;goto ~299;~297:;~298:__a=новый comобъект("VBScript.RegExp")
;goto ~301;~299:goto ~298;~300:__a=новый comобъект("VBScript.RegExp");goto ~301;~301:;~302:if 1<=-1 then goto ~306;endif;goto ~309;~303:_b=-1;~304:;~305:__a.наименование=истина;goto ~310;~306:if _b=1 then goto ~304;endif;goto ~307;~307:;~308:__a.global=истина;goto ~310;~309:_b=1;goto ~308;~310:;~311:if 1<=0 then goto ~313;endif;goto ~312;if _b=1 then goto ~318;endif;goto ~314;~312:if -1>=1 then goto ~315;endif;goto ~317;~313:_b=-1;~314:;~315:;~316:__a.номермаркера=истина;goto ~320;~317:goto ~319;~318:;
~319:__a.ignorecase=истина;goto ~320;~320:;~321:_b=1;if _b=1 then goto ~323;endif;goto ~327;if _b=-1 then goto ~322;endif;goto ~326;~322:goto ~330;~323:_b=1;goto ~329;~324:;~325:___a=a;goto ~330;~326:goto ~329;~327:if _b=0 then goto ~328;endif;goto ~324;~328:;~329:___a=a;goto ~330;~330:;~331:_b=0;~332:_b=1;if _b=1 then goto ~334;endif;goto ~335;~333:_a___=новый массив;goto ~337;~334:goto ~336;~335:;~336:_a___=новый запрос;goto ~337;~337:;~338:if -1<1 then goto ~350;endif;goto ~344;if _b=0 then goto ~349;endif;
goto ~355;if _b=1 then goto ~339;endif;goto ~356;~339:;~340:;~341:_a___.выборка="";goto ~358;~342:goto ~358;~343:goto ~357;~344:if _b=-1 then goto ~348;endif;goto ~353;~345:_b=1;~346:;~347:goto ~357;~348:if _b=1 then goto ~342;endif;goto ~347;~349:if _b=-1 then goto ~351;endif;goto ~340;~350:_b=1;if _b=1 then goto ~343;endif;goto ~346;~351:goto ~338;~352:goto ~338;~353:if _b=1 then goto ~354;endif;goto ~352;~354:goto ~338;~355:_b=0;~356:;~357:_a___.текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~358;~358:;~359:if 1>=0 then 
goto ~361;endif;goto ~365;~360:_b=0;if -1>0 then goto ~363;endif;goto ~367;~361:_b=0;~362:_b=1;goto ~364;~363:;~364:___a_=_a___.выполнить();goto ~369;~365:_b=1;~366:_b=1;~367:;~368:___a_=_a___.знач();goto ~369;~369:;~370:_b=1;if _b=-1 then goto ~372;endif;goto ~371;if _b=-1 then goto ~375;endif;goto ~373;~371:_b=0;goto ~374;~372:_b=1;~373:;~374:b=___a_.выбрать();goto ~377;~375:;~376:b=___a_.строкаулицы();goto ~377;~377:;while b.следующий() do ~378:if 1>=0 then goto ~384;endif;goto ~389;if _b=1 then goto ~386;
endif;goto ~393;if -1<>0 then goto ~387;endif;goto ~382;~379:_b=-1;goto ~392;~380:;~381:__a.описаниеошибки=","+стрзаменить(b.описаниеошибки,"Строка","")+"VBScript.RegExp";goto ~394;~382:;~383:goto ~378;~384:if -1<=0 then goto ~379;endif;goto ~388;if _b=1 then goto ~383;endif;goto ~380;~385:;~386:_b=1;~387:;~388:_b=-1;~389:_b=0;~390:_b=0;~391:;~392:__a.pattern=",([0-9а-я\s\.-]*"+стрзаменить(b.наименование,".","\.")+"[0-9а-я\s\.-]*),";goto ~394;~393:if _b=1 then goto ~385;endif;goto ~391;~394:;~395:
if -1<1 then goto ~405;endif;goto ~401;if _b=-1 then goto ~398;endif;goto ~400;if 0<0 then goto ~403;endif;goto ~399;~396:_b=1;goto ~408;~397:;~398:_b=0;~399:goto ~408;~400:_b=0;~401:_b=0;if _b=0 then goto ~397;endif;goto ~407;~402:_b=1;~403:;~404:if __a.следующий(___a) then goto ~408;endif;goto ~409;~405:if 0<0 then goto ~402;endif;goto ~396;~406:_b=0;~407:;~408:if __a.test(___a) then goto ~410;endif;goto ~409;~409:;goto ~465;~410:;~411:_b=0;if _b=1 then goto ~412;endif;goto ~414;~412:;~413:_a_=__a.максимальнаядолгота(___a)
;goto ~416;~414:goto ~415;~415:_a_=__a.execute(___a);goto ~416;~416:;~417:if -1>=-1 then goto ~424;endif;goto ~421;~418:_b=0;if _b=1 then goto ~420;endif;goto ~425;~419:goto ~417;~420:;~421:_b=1;if _b=1 then goto ~422;endif;goto ~419;~422:;~423:goto ~426;~424:_b=1;if 1=0 then goto ~427;endif;goto ~423;~425:;~426:_a__=_a_.item(0);goto ~429;~427:;~428:_a__=_a_.номермаркера(0);goto ~429;~429:;~430:_b=0;~431:_b=1;if 1=-1 then goto ~433;endif;goto ~432;~432:goto ~434;~433:;~434:__a_=_a__.submatches
;goto ~436;~435:__a_=_a__.новый;goto ~436;~436:;~437:_b=0;~438:_b=0;goto ~439;~439:__a__=__a_.item(0);goto ~441;~440:__a__=__a_.стрзаменить(1);goto ~441;~441:;~442:if 1<=0 then goto ~452;endif;goto ~450;if _b=1 then goto ~456;endif;goto ~447;if _b=1 then goto ~448;endif;goto ~453;~443:;~444:;~445:;~446:a__=b.номермаркера;goto ~457;~447:if _b=0 then goto ~451;endif;goto ~455;~448:;~449:a__=b.наименование;goto ~457;~450:_b=1;if _b=-1 then goto ~443;endif;goto ~454;~451:goto ~442;~452:_b=0;if _b=-1 then 
goto ~444;endif;goto ~445;~453:;~454:goto ~449;~455:;~456:_b=1;~457:;~458:_b=1;~459:_b=-1;if _b=0 then goto ~461;endif;goto ~463;~460:прервать;goto ~464;~461:;~462:прервать;goto ~464;~463:goto ~460;~464:;goto ~465;~465:;enddo;goto ~466;~466:;~467:_b=1;if _b=-1 then goto ~468;endif;goto ~470;~468:;~469:b_=__a__;goto ~472;~470:goto ~471;~471:b_=__a__;goto ~472;~472:;~473:if 0>0 then goto ~493;endif;goto ~478;~474:_b=0;if _b=0 then goto ~479;endif;goto ~485;~475:;~476:;~477:goto ~495;~478:if -1=0 then goto ~492;
endif;goto ~487;if _b=1 then goto ~491;endif;goto ~477;~479:;~480:_a___=новый соответствие;goto ~495;~481:goto ~486;~482:goto ~473;~483:;~484:if _b=0 then goto ~476;endif;goto ~482;~485:;~486:_a___=новый запрос;goto ~495;~487:if 1<-1 then goto ~483;endif;goto ~481;~488:;~489:;~490:_b=-1;~491:;~492:if _b=1 then goto ~488;endif;goto ~475;~493:if _b=1 then goto ~484;endif;goto ~490;if _b=0 then goto ~494;endif;goto ~489;~494:;~495:;~496:if -1>=-1 then goto ~503;endif;goto ~498;if _b=-1 then goto ~499;endif;goto ~504;
~497:goto ~500;~498:if 0=1 then goto ~505;endif;goto ~502;~499:;~500:_a___.текст="ВЫБРАТЬ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Сокращение,
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Расшифровка
	|ИЗ
	|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска
	|ГДЕ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование = &Наименование";goto ~507;~501:goto ~506;~502:;~503:if -1<>0 then goto ~497;endif;goto ~501;~504:goto ~500;~505:;~506:_a___.возврат="";goto ~507;~507:;~508:_b=-1;if _b=0 then goto ~511;endif;goto ~510;~509:_a___.установитьпараметр("Наименование",a__);goto ~513;~510:goto ~509;~511:;~512:_a___.выбрать("
		|	",a__);goto ~513;~513:;~514:_b=1;~515:_b=1;goto ~517;~516:___a_=_a___.результат();goto ~518;~517:___a_=_a___.выполнить()
;goto ~518;~518:;~519:_b=-1;~520:_b=-1;goto ~521;~521:b=___a_.выбрать();goto ~523;~522:b=___a_.сокращение();goto ~523;~523:;while b.следующий() do ~524:if 1<>-1 then goto ~531;endif;goto ~528;if _b=-1 then goto ~525;endif;goto ~526;~525:;~526:;~527:if найти(__a__,b.сокращение)>0 then goto ~534;endif;goto ~533;~528:_b=0;~529:;~530:if найти(__a__,b.центркарты_y)>1 then goto ~530;endif;goto ~533;~531:if 0=-1 then goto ~529;endif;goto ~532;~532:goto ~527;~533:;goto ~560;~534:;~535:if 0=1 then goto ~540;
endif;goto ~537;~536:_b=0;if _b=0 then goto ~542;endif;goto ~544;~537:_b=0;if 1>0 then goto ~541;endif;goto ~538;~538:;~539:b_=стрзаменить(__a__,b.сокращение,b.расшифровка);goto ~547;~540:_b=1;if 1<>1 then goto ~546;endif;goto ~543;~541:goto ~539;~542:;~543:;~544:;~545:b_=стрзаменить(__a__,b.документ,b.строкаадреса);goto ~547;~546:;~547:;~548:_b=0;if _b=0 then goto ~551;endif;goto ~549;if _b=1 then goto ~552;endif;goto ~555;~549:if 1>=0 then goto ~557;endif;goto ~550;~550:goto ~548;~551:if _b=0 then goto ~554;
endif;goto ~558;~552:;~553:прервать;goto ~559;~554:goto ~553;~555:;~556:прервать;goto ~559;~557:goto ~553;~558:goto ~553;~559:;goto ~560;~560:;enddo;~561:_b=1;if 1<=0 then goto ~564;endif;goto ~563;~562:__a=новый comобъект("VBScript.RegExp");goto ~566;~563:goto ~562;~564:;~565:__a=новый comобъект(" ");goto ~566;~566:;~567:if 1>=-1 then goto ~572;endif;goto ~571;~568:_b=1;~569:__a.маркер=истина;goto ~573;~570:__a.global=истина;goto ~573;~571:_b=1;~572:_b=1;goto ~570;~573:;~574:if -1=1 then goto ~576;
endif;goto ~575;if 1>0 then goto ~582;endif;goto ~587;if _b=0 then goto ~586;endif;goto ~591;~575:if 1<=0 then goto ~580;endif;goto ~589;if _b=0 then goto ~579;endif;goto ~590;~576:_b=0;if -1=1 then goto ~577;endif;goto ~585;~577:;~578:goto ~592;~579:;~580:if _b=1 then goto ~588;endif;goto ~583;~581:;~582:_b=-1;~583:;~584:__a.формат=ложь;goto ~593;~585:goto ~574;~586:;~587:_b=0;~588:goto ~584;~589:if 0<>0 then goto ~581;endif;goto ~578;~590:;~591:;~592:__a.ignorecase=истина;goto ~593;~593:;~594:if 1<=0 then 
goto ~604;endif;goto ~603;~595:_b=0;~596:_b=-1;~597:;~598:___a=b_;goto ~611;~599:;~600:;~601:;~602:___a=b_;goto ~611;~603:if -1>1 then goto ~610;endif;goto ~605;if _b=0 then goto ~607;endif;goto ~597;~604:_b=1;if _b=-1 then goto ~601;endif;goto ~608;~605:if 0>=-1 then goto ~606;endif;goto ~599;~606:goto ~602;~607:;~608:;~609:;~610:if _b=0 then goto ~600;endif;goto ~609;~611:;~612:_b=-1;~613:_b=0;goto ~614;~614:__a.pattern="([0-9]+-[а-я]+)";goto ~616;~615:__a.выборка="[ .,]+с(?:тр|троение)[ .,]*([0-9]+)";goto ~616;~616:;~617:if 1=-1 then goto ~619;
endif;goto ~622;~618:_b=1;~619:if _b=-1 then goto ~623;endif;goto ~620;~620:;~621:if __a.test(___a)и найти(___a,"КАД ")=0 then goto ~626;endif;goto ~625;~622:_b=-1;goto ~621;~623:;~624:if __a.возврат(___a)и найти(___a,"КАД ")>=1 then goto ~624;endif;goto ~625;~625:;goto ~703;~626:;~627:if 1<0 then goto ~633;endif;goto ~634;~628:_b=-1;~629:;~630:_a_=__a.execute(___a);goto ~635;~631:;~632:_a_=__a.сокрлп(___a);goto ~635;~633:if 1<>0 then goto ~631;endif;goto ~629;~634:_b=1;goto ~630;~635:;~636:
if -1>1 then goto ~641;endif;goto ~640;if _b=1 then goto ~643;endif;goto ~642;~637:;~638:_a__=_a_.путькфайлу(1);goto ~647;~639:goto ~646;~640:if 0>=-1 then goto ~639;endif;goto ~644;~641:if _b=0 then goto ~637;endif;goto ~645;~642:goto ~636;~643:;~644:goto ~636;~645:;~646:_a__=_a_.item(0);goto ~647;~647:;~648:_b=1;if 0=0 then goto ~649;endif;goto ~651;~649:goto ~650;~650:__a_=_a__.submatches;goto ~653;~651:;~652:__a_=_a__.прервать;goto ~653;~653:;~654:if -1<1 then goto ~663;endif;goto ~659;if _b=-1 then 
goto ~656;endif;goto ~657;if 1<-1 then goto ~661;endif;goto ~667;~655:_b=1;~656:if _b=-1 then goto ~665;endif;goto ~669;~657:_b=0;~658:;~659:_b=1;~660:_b=1;~661:;~662:b__=__a_.item(0);goto ~671;~663:if -1>0 then goto ~655;endif;goto ~668;~664:_b=1;~665:;~666:b__=__a_.твысотакарты(1);goto ~671;~667:goto ~671;~668:if 1<>-1 then goto ~670;endif;goto ~658;~669:;~670:goto ~662;~671:;~672:if -1=1 then goto ~689;endif;goto ~676;~673:_b=1;if _b=0 then goto ~682;endif;goto ~683;~674:;~675:goto ~680;~676:if -2>-2
 then goto ~681;endif;goto ~684;if 1=0 then goto ~677;endif;goto ~687;~677:;~678:b_=стрзаменить(b_,b__,"г,");goto ~690;~679:;~680:b_=стрзаменить(b_,b__,"");goto ~690;~681:if _b=1 then goto ~688;endif;goto ~685;~682:;~683:goto ~690;~684:if -1>=1 then goto ~679;endif;goto ~675;~685:;~686:goto ~678;~687:;~688:;~689:_b=-1;if _b=-1 then goto ~686;endif;goto ~674;~690:;~691:if 1=-1 then goto ~697;endif;goto ~698;if _b=1 then goto ~692;endif;goto ~695;~692:;~693:b_=" "+b__+" "+b_;goto ~702;
~694:goto ~693;~695:;~696:;~697:if -1<=1 then goto ~701;endif;goto ~699;~698:if -1>=0 then goto ~696;endif;goto ~694;~699:;~700:b_="Ошибка загрузки карты Яндекс! - "+b__+" "+b_;goto ~702;~701:;~702:;goto ~703;~703:;~704:if -1<1 then goto ~713;endif;goto ~708;~705:_b=1;if 1>=-1 then goto ~714;endif;goto ~721;~706:if 1>1 then goto ~715;endif;goto ~710;~707:;~708:if _b=1 then goto ~711;endif;goto ~706;if _b=-1 then goto ~720;endif;goto ~707;~709:goto ~716;~710:;~711:if _b=-1 then goto ~712;endif;goto ~718;~712:goto ~722;~713:_b=-1
;if -1<>1 then goto ~709;endif;goto ~717;~714:;~715:;~716:a=стрзаменить(a,__a__,b_);goto ~722;~717:;~718:;~719:a=стрзаменить(a,__a__,b_);goto ~722;~720:;~721:goto ~716;~722:;~723:if 1>1 then goto ~726;endif;goto ~724;if _b=0 then goto ~729;endif;goto ~728;~724:if 0>1 then goto ~725;endif;goto ~731;~725:goto ~730;~726:if -1>=1 then goto ~727;endif;goto ~732;~727:goto ~730;~728:;~729:;~730:__a=новый comобъект("VBScript.RegExp");goto ~734;~731:goto ~730;~732:;~733:__a=новый comобъект("г.");goto ~734;~734:;~735:
_b=-1;~736:_b=1;if _b=0 then goto ~739;endif;goto ~737;~737:goto ~738;~738:__a.global=истина;goto ~741;~739:;~740:__a.центркарты_y=ложь;goto ~741;~741:;~742:_b=1;~743:_b=1;goto ~744;~744:__a.ignorecase=истина;goto ~746;~745:__a.элементыформы=ложь;goto ~746;~746:;~747:if 1<-1 then goto ~750;endif;goto ~749;if _b=-1 then goto ~755;endif;goto ~753;~748:goto ~756;~749:_b=-1;goto ~752;~750:if _b=0 then goto ~751;endif;goto ~748;~751:;~752:___a=a;goto ~756;~753:;~754:___a=a;goto ~756;~755:;~756:;~757:if 0=-1
 then goto ~762;endif;goto ~775;if 0>0 then goto ~761;endif;goto ~779;if 0>1 then goto ~777;endif;goto ~769;~758:;~759:__a.формат="";goto ~781;~760:if 1>0 then goto ~780;endif;goto ~771;~761:if _b=1 then goto ~772;endif;goto ~767;~762:if _b=0 then goto ~776;endif;goto ~778;~763:_b=1;~764:goto ~781;~765:;~766:;~767:;~768:goto ~781;~769:;~770:_b=0;~771:goto ~774;~772:goto ~759;~773:;~774:__a.pattern="[ .,]+с(?:тр|троение)[ .,]*([0-9]+)";goto ~781;~775:if 0>=-1 then goto ~760;endif;goto ~770;if _b=1 then goto ~768;endif;goto ~766;
~776:_b=1;~777:goto ~774;~778:if _b=-1 then goto ~764;endif;goto ~758;~779:if -1>=1 then goto ~765;endif;goto ~773;~780:goto ~774;~781:;~782:_b=1;if 1=0 then goto ~788;endif;goto ~789;~783:_b=1;~784:goto ~787;~785:;~786:;~787:if __a.test(___a) then goto ~793;endif;goto ~792;~788:if 1>=-1 then goto ~790;endif;goto ~785;~789:if _b=-1 then goto ~786;endif;goto ~784;~790:;~791:if __a.count(___a) then goto ~782;endif;goto ~792;~792:;goto ~875;~793:;~794:if -1=1 then goto ~796;endif;goto ~799;if -1>1 then goto ~798;
endif;goto ~801;if _b=0 then goto ~813;endif;goto ~812;~795:goto ~794;~796:if _b=1 then goto ~803;endif;goto ~804;~797:_b=-1;~798:if _b=-1 then goto ~802;endif;goto ~795;~799:if -1>1 then goto ~814;endif;goto ~815;~800:_b=1;~801:if 1<=0 then goto ~810;endif;goto ~816;~802:goto ~807;~803:_b=1;~804:if -2>-2 then goto ~808;endif;goto ~805;~805:goto ~807;~806:;~807:_a_=__a.тширинакарты(___a);goto ~817;~808:;~809:goto ~794;~810:;~811:_a_=__a.execute(___a);goto ~817;~812:goto ~794;~813:;~814:if -1<>0 then goto ~806;
endif;goto ~809;~815:_b=0;goto ~811;~816:goto ~817;~817:;~818:if 1>-1 then goto ~821;endif;goto ~824;if 1<-1 then goto ~819;endif;goto ~822;~819:;~820:_a__=_a_.item(0);goto ~825;~821:_b=-1;goto ~820;~822:;~823:_a__=_a_.центркарты_y(0);goto ~825;~824:_b=1;~825:;~826:if 0<>1 then goto ~834;endif;goto ~839;if _b=-1 then goto ~833;endif;goto ~836;if 1>=0 then goto ~830;endif;goto ~842;~827:;~828:__a_=_a__.replace;goto ~843;~829:goto ~831;~830:;~831:__a_=_a__.submatches;goto ~843;~832:_b=0;~833:
_b=-1;~834:_b=-1;~835:_b=1;goto ~831;~836:if _b=1 then goto ~827;endif;goto ~838;~837:goto ~843;~838:goto ~843;~839:if _b=1 then goto ~841;endif;goto ~832;~840:_b=1;~841:if -1=0 then goto ~837;endif;goto ~829;~842:goto ~831;~843:;~844:if 1<=0 then goto ~846;endif;goto ~858;if 0<=1 then goto ~855;endif;goto ~847;if -1>1 then goto ~856;endif;goto ~860;~845:goto ~862;~846:_b=-1;if -1<>1 then goto ~845;endif;goto ~851;~847:_b=1;~848:if -1<>1 then goto ~857;endif;goto ~852;~849:;~850:b___=__a_.replace(1);goto ~862;
~851:;~852:goto ~862;~853:_b=1;~854:goto ~861;~855:if _b=0 then goto ~854;endif;goto ~849;~856:goto ~844;~857:goto ~861;~858:if 1<0 then goto ~853;endif;goto ~848;~859:_b=0;~860:;~861:b___=__a_.item(0);goto ~862;~862:;~863:_b=0;if _b=0 then goto ~867;endif;goto ~869;if 1<=0 then goto ~868;endif;goto ~865;~864:goto ~866;~865:;~866:a=__a.исходнаястрока(___a,"([ .,]к(?:в|вартира)[ .,]*[0-9]+)"+b___);goto ~874;~867:if 1>=0 then goto ~870;endif;goto ~864;~868:;~869:if 1<>0 then goto ~871;endif;goto ~872;~870:goto ~873;~871:;~872:
;~873:a=__a.replace(___a,"с"+b___);goto ~874;~874:;goto ~875;~875:;~876:_b=1;~877:_b=1;goto ~879;~878:__a=новый comобъект("");goto ~880;~879:__a=новый comобъект("VBScript.RegExp");goto ~880;~880:;~881:if 1<>-1 then goto ~887;endif;goto ~892;~882:_b=-1;if _b=-1 then goto ~893;endif;goto ~888;~883:;~884:__a.global=истина;goto ~895;~885:;~886:_b=1;goto ~884;~887:if 1<0 then goto ~894;endif;goto ~886;if 1<>0 then goto ~885;endif;goto ~891;~888:;~889:__a.geoobjectdraggable=ложь;goto ~895;~890:goto ~895;
~891:goto ~884;~892:_b=-1;if _b=-1 then goto ~890;endif;goto ~883;~893:;~894:_b=-1;~895:;~896:if -1>=0 then goto ~905;endif;goto ~898;if _b=-1 then goto ~901;endif;goto ~899;~897:goto ~907;~898:if 0<>0 then goto ~903;endif;goto ~906;~899:;~900:__a.ignorecase=истина;goto ~907;~901:;~902:__a.тобласть=истина;goto ~907;~903:;~904:;~905:if 0<=1 then goto ~904;endif;goto ~897;~906:goto ~900;~907:;~908:_b=1;if 1<=1 then goto ~909;endif;goto ~912;if _b=1 then goto ~910;endif;goto ~913;~909:_b=-1;goto ~914;~910:
;~911:___a=a;goto ~915;~912:_b=0;~913:;~914:___a=a;goto ~915;~915:;~916:if -2<>-2 then goto ~922;endif;goto ~926;~917:_b=0;if 1<=-1 then goto ~924;endif;goto ~918;~918:;~919:__a.pattern="([ .,]к(?:в|вартира)[ .,]*[0-9]+)";goto ~928;~920:_b=-1;~921:_b=1;~922:if 0<>0 then goto ~921;endif;goto ~920;~923:_b=0;~924:;~925:__a.выборка="([ .,]к(?:в|вартира)[ .,]*[0-9]+)";goto ~928;~926:_b=0;~927:_b=0;goto ~919;~928:;~929:_b=0;if -1<1 then goto ~932;endif;goto ~930;~930:;~931:if __a.replace(___a) then goto ~929;endif;goto ~934;~932:goto ~933;~933:if __a.test(___a)
 then goto ~935;endif;goto ~934;~934:;goto ~948;~935:;~936:if -1=-1 then goto ~946;endif;goto ~937;if 0<1 then goto ~940;endif;goto ~938;~937:if 0=0 then goto ~941;endif;goto ~945;~938:;~939:a=__a.сокращение(___a,".");goto ~947;~940:goto ~947;~941:goto ~936;~942:goto ~944;~943:;~944:a=__a.replace(___a,"");goto ~947;~945:goto ~944;~946:if 1<=0 then goto ~943;endif;goto ~942;~947:;goto ~948;~948:;~949:_b=0;if _b=1 then goto ~951;endif;goto ~953;~950:a=стрзаменить(a,"Номер","ВЫБРАТЬ ПЕРВЫЕ 1
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.ПоУмолчанию = Истина");goto ~954;
~951:;~952:a=стрзаменить(a,"г,","");goto ~954;~953:goto ~952;~954:;~955:_b=1;if _b=-1 then goto ~958;endif;goto ~957;~956:a=стрзаменить(a,",","");goto ~960;~957:goto ~956;~958:;~959:a=стрзаменить(a,"Обзорная карта","[ .,]+с(?:тр|троение)[ .,]*([0-9]+)");goto ~960;~960:;~961:_b=0;if _b=-1 then goto ~964;endif;goto ~963;~962:a=стрзаменить(a,"searchControl"," ");goto ~966;~963:goto ~965;~964:;~965:a=стрзаменить(a,"№","");goto ~966;~966:;~967:_b=-1;~968:_b=-1;goto ~969;~969:a=стрзаменить(a,"дом","")
;goto ~971;~970:a=стрзаменить(a,"
		|	","");goto ~971;~971:;~972:_b=-1;~973:_b=0;goto ~975;~974:a=стрзаменить(a,"  ","");goto ~976;~975:a=стрзаменить(a,"г.","");goto ~976;~976:;~977:if 0>=-1 then goto ~981;endif;goto ~992;if -1<1 then goto ~997;endif;goto ~988;if _b=1 then goto ~986;endif;goto ~985;~978:if _b=-1 then goto ~998;endif;goto ~999;~979:if _b=0 then goto ~991;endif;goto ~982;~980:;~981:if -1<=0 then goto ~1002;endif;goto ~978;if _b=1 then goto ~980;endif;
goto ~1003;~982:;~983:a=стрзаменить(a,"  "," ");goto ~1004;~984:;~985:;~986:;~987:goto ~983;~988:if _b=-1 then goto ~1001;endif;goto ~996;~989:if _b=-1 then goto ~984;endif;goto ~993;~990:;~991:goto ~983;~992:if 1=-1 then goto ~989;endif;goto ~979;if -1<>1 then goto ~990;endif;goto ~1000;~993:;~994:;~995:a=стрзаменить(a,"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска","twirl#violetStretchyIcon");goto ~1004;~996:;~997:_b=0;~998:;~999:;~1000:;~1001:goto ~983;~1002:if 0>0 then goto ~994;endif;goto ~987;~1003:;~1004:;~1005:if -1=0 then goto ~1012;endif;
goto ~1007;~1006:_b=-1;~1007:_b=1;goto ~1009;~1008:;~1009:a=стрзаменить(a,"   "," ");goto ~1013;~1010:;~1011:a=стрзаменить(a,"   ","VBScript.RegExp");goto ~1013;~1012:if -1<1 then goto ~1008;endif;goto ~1010;~1013:;~1014:_b=0;if 1>=1 then goto ~1015;endif;goto ~1018;if _b=0 then goto ~1016;endif;goto ~1019;~1015:_b=-1;goto ~1017;~1016:;~1017:a=стрзаменить(a,"    "," ");goto ~1021;~1018:_b=0;~1019:;~1020:a=стрзаменить(a,"]","СкомпоноватьМассивГеокодирования: точка № ");goto ~1021;~1021:;~1022:_b=0;if 0>=-1 then 
goto ~1027;endif;goto ~1026;~1023:_b=-1;~1024:a=стрзаменить(a,"     "," ");goto ~1028;~1025:a=стрзаменить(a,"scaleLine","Масштабный отрезок");goto ~1028;~1026:_b=0;~1027:_b=-1;goto ~1024;~1028:;~1029:if -1<=0 then goto ~1045;endif;goto ~1040;if -1>0 then goto ~1044;endif;goto ~1031;if -2>-2 then goto ~1038;endif;goto ~1039;~1030:;~1031:_b=0;~1032:goto ~1036;~1033:;~1034:;~1035:;~1036:a=стрзаменить(a,"      "," ");goto ~1049;~1037:goto ~1049;~1038:goto ~1043;~1039:goto ~1049;~1040:_b=1;if 1<=-1 then 
goto ~1042;endif;goto ~1034;~1041:if -1<>-1 then goto ~1030;endif;goto ~1032;~1042:;~1043:a=стрзаменить(a,"ВЫБРАТЬ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Сокращение,
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Расшифровка
	|ИЗ
	|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска
	|ГДЕ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование = &Наименование","     ");goto ~1049;~1044:if _b=0 then goto ~1035;endif;goto ~1037;~1045:if -1>=0 then goto ~1048;endif;goto ~1041;~1046:_b=0;~1047:goto ~1029;~1048:if _b=1 then goto ~1033;endif;goto ~1047;~1049:;~1050:if 1<>-1 then goto ~1068;endif;goto ~1060;if _b=0 then goto ~1051;endif;goto ~1057;if _b=-1 then goto ~1053;endif;goto ~1062;~1051:if 1=0 then goto ~1052;endif;goto ~1058;~1052:goto ~1050;
~1053:;~1054:возврат сокрлп(a);goto ~1070;~1055:if 1=1 then goto ~1066;endif;goto ~1064;~1056:;~1057:_b=0;~1058:goto ~1063;~1059:goto ~1054;~1060:_b=-1;~1061:_b=1;~1062:;~1063:возврат сокрлп(a);goto ~1070;~1064:goto ~1070;~1065:;~1066:goto ~1063;~1067:if 1<>0 then goto ~1069;endif;goto ~1056;~1068:if 1>-1 then goto ~1055;endif;goto ~1067;if _b=-1 then goto ~1059;endif;goto ~1065;~1069:;~1070:;конецфункции  ~0:if -1<=0 then goto ~4;endif;goto ~17;if a___=-1 then goto ~19;endif;goto ~5;~1:a___=-1;~2:;~3:;~4:if 1<-1
 then goto ~12;endif;goto ~14;if a___=-1 then goto ~8;endif;goto ~16;~5:a___=-1;~6:;~7:соответствиеметок=новый соответствие;goto ~20;~8:;~9:goto ~20;~10:;~11:соответствиеметок=новый соответствие;goto ~20;~12:if a___=1 then goto ~18;endif;goto ~6;~13:goto ~7;~14:if 1>-1 then goto ~13;endif;goto ~3;~15:goto ~20;~16:;~17:a___=-1;if a___=0 then goto ~9;endif;goto ~10;~18:;~19:if 1<=1 then goto ~2;endif;goto ~15;~20:;~21:if -1>0 then goto ~39;endif;goto ~38;if 1<>0 then goto ~31;endif;goto ~25;if -2<=-2 then goto ~36;endif;
goto ~24;~22:;~23:goto ~34;~24:goto ~42;~25:if a___=-1 then goto ~29;endif;goto ~41;~26:;~27:if -1>=1 then goto ~30;endif;goto ~33;~28:if 0=0 then goto ~35;endif;goto ~32;~29:goto ~37;~30:goto ~42;~31:a___=1;~32:;~33:;~34:соответствиеметокадресам=новый соответствие;goto ~42;~35:goto ~34;~36:;~37:соответствиеметокадресам=новый соответствие;goto ~42;~38:if 0=1 then goto ~27;endif;goto ~28;if a___=-1 then goto ~23;endif;goto ~40;~39:a___=-1;if a___=1 then goto ~22;endif;goto ~26;~40:goto ~37;~41:;~42:;~43:a___=0;if 0=0 then 
goto ~46;endif;goto ~44;~44:;~45:соответствиеметок.comобъект(1,"");goto ~48;~46:goto ~47;~47:соответствиеметок.вставить(1,"twirl#whiteStretchyIcon");goto ~48;~48:;~49:a___=0;~50:a___=0;goto ~51;~51:соответствиеметок.вставить(2,"twirl#violetStretchyIcon");goto ~53;~52:соответствиеметок.тширинакарты(3,"twirl#violetStretchyIcon");goto ~53;~53:;~54:if 0<=0 then goto ~62;endif;goto ~69;~55:a___=-1;~56:a___=-1;~57:;~58:;~59:соответствиеметок.вставить(3,"twirl#yellowStretchyIcon");goto ~70;~60:;~61:;~62:a___=1;~63:a___=0;goto ~59;
~64:if a___=1 then goto ~60;endif;goto ~61;~65:goto ~67;~66:;~67:соответствиеметок.pattern(3,"\.");goto ~70;~68:if -1>1 then goto ~65;endif;goto ~58;~69:if a___=-1 then goto ~68;endif;goto ~64;if 0=-1 then goto ~57;endif;goto ~66;~70:;~71:a___=-1;if a___=-1 then goto ~78;endif;goto ~72;if a___=-1 then goto ~79;endif;goto ~73;~72:if a___=1 then goto ~75;endif;goto ~76;~73:;~74:соответствиеметок.рточка(3,"twirl#redStretchyIcon");goto ~80;~75:goto ~80;~76:;~77:соответствиеметок.вставить(4,"twirl#redStretchyIcon")
;goto ~80;~78:a___=-1;goto ~77;~79:;~80:;~81:a___=-1;~82:a___=-1;goto ~83;~83:соответствиеметок.вставить(5,"twirl#greenStretchyIcon");goto ~85;~84:соответствиеметок.match(4,",");goto ~85;~85:;~86:a___=-1;if a___=-1 then goto ~88;endif;goto ~89;~87:соответствиеметок.каталог(5,"twirl#blueStretchyIcon");goto ~91;~88:goto ~90;~89:;~90:соответствиеметок.вставить(6,"twirl#blueStretchyIcon");goto ~91;~91:;~92:a___=0;~93:a___=0;goto ~95;~94:соответствиекартинокметок=новый соответствие;goto ~96;~95:соответствиекартинокметок=новый соответствие
;goto ~96;~96:;~97:if 0=1 then goto ~100;endif;goto ~101;if a___=1 then goto ~102;endif;goto ~98;~98:;~99:a=новый запрос;goto ~104;~100:a___=0;~101:a___=0;goto ~99;~102:;~103:a=новый списокзначений;goto ~104;~104:;~105:if -1<1 then goto ~111;endif;goto ~112;~106:a___=-1;~107:;~108:a.текст="ВЫБРАТЬ ПЕРВЫЕ 1
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.ПоУмолчанию = Истина";goto ~113;~109:;~110:a.номермаркера="ВЫБРАТЬ ПЕРВЫЕ 1
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.ПоУмолчанию = Истина";goto ~113;~111:a___=0;goto ~108;~112:if a___=0 then goto ~107;endif;goto ~109;~113:;~114:if 1>=0 then goto ~127;endif;goto ~124;if a___=0 then goto ~123;endif;goto ~116;
if a___=1 then goto ~121;endif;goto ~126;~115:;~116:if a___=0 then goto ~117;endif;goto ~119;~117:;~118:a_=a.мегалогист().номермаркера();goto ~128;~119:;~120:a_=a.выполнить().выбрать();goto ~128;~121:;~122:goto ~120;~123:a___=-1;~124:a___=-1;~125:a___=0;~126:;~127:a___=1;if -1<>0 then goto ~122;endif;goto ~115;~128:;while a_.следующий() do ~129:a___=1;~130:a___=-1;goto ~131;~131:соответствиекартинокметок.вставить(0,a_.маркер);goto ~133;~132:соответствиекартинокметок.запрос(1,a_.мгеокодирования);goto ~133;
~133:;enddo;~134:a___=0;if -1<>1 then goto ~142;endif;goto ~141;if a___=0 then goto ~137;endif;goto ~139;~135:goto ~140;~136:;~137:;~138:a.закрыть="";goto ~143;~139:;~140:a.текст="ВЫБРАТЬ
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.Активный = Истина
             |
             |УПОРЯДОЧИТЬ ПО
             |	МегаЛогист_Маркеры.Наименование";goto ~143;~141:a___=1;~142:if a___=-1 then goto ~136;endif;goto ~135;~143:;~144:a___=1;~145:a___=0;goto ~147;~146:a_=a.проверка().regexp();goto ~148;~147:a_=a.выполнить().выбрать();goto ~148;~148:;~149:a___=1;~150:a___=1;if a___=-1 then goto ~152;endif;goto ~151;~151:goto ~154;~152:;~153:a__=0;goto ~155;
~154:a__=0;goto ~155;~155:;while a_.следующий() do ~156:if 1<=0 then goto ~159;endif;goto ~170;~157:a___=0;~158:a___=0;~159:if a___=1 then goto ~169;endif;goto ~166;if a___=-1 then goto ~162;endif;goto ~163;~160:;~161:a__=a__+2;goto ~173;~162:;~163:;~164:a__=a__+1;goto ~173;~165:if a___=0 then goto ~160;endif;goto ~167;~166:a___=-1;~167:goto ~161;~168:goto ~161;~169:a___=-1;~170:if 1<-1 then goto ~165;endif;goto ~171;if -1<>1 then goto ~172;endif;goto ~168;~171:a___=-1;goto ~164;~172:goto ~164;
~173:;~174:if 1>1 then goto ~185;endif;goto ~189;~175:a___=0;if a___=0 then goto ~181;endif;goto ~180;~176:goto ~179;~177:;~178:;~179:соответствиекартинокметок.каталог(a__,a_.zoom);goto ~191;~180:goto ~174;~181:;~182:соответствиекартинокметок.вставить(a__,a_.маркер);goto ~191;~183:goto ~182;~184:goto ~179;~185:if a___=-1 then goto ~188;endif;goto ~190;~186:a___=0;~187:;~188:if a___=1 then goto ~177;endif;goto ~184;~189:a___=0;if a___=1 then goto ~176;endif;goto ~183;~190:if a___=0 then goto ~187;endif;goto ~178;
~191:;enddo;