перем твысотакарты экспорт;перем тширинакарты экспорт;перем соответствиеметок экспорт;перем соответствиеметокадресам экспорт;перем соответствиекартинокметок экспорт;перем ркарта экспорт;перем максимальнаяширота экспорт;перем максимальнаядолгота экспорт;перем минимальнаяширота экспорт;перем минимальнаядолгота экспорт;перем тобласть экспорт;перем a___; функция получитькодкарты()экспорт перем a_;~0:if -1=1 then goto ~11;endif;goto ~16;~1:a_=0;if a_=0 then goto ~14;endif;goto ~18;~2:;~3:a="Ошибка инициализации карты Яндекс! - ";goto ~19;~4:a_=0
;~5:goto ~9;~6:if -2=-2 then goto ~5;endif;goto ~12;~7:;~8:;~9:a="<!doctype html>
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
			|";goto ~19;~10:a_=-1;~11:if a_=-1 then goto ~10;endif;goto ~15;if -1<>1 then goto ~2;endif;goto ~8;~12:;~13:;~14:;~15:if a_=0 then goto ~7;endif;goto ~13;~16:if -1<=1 then goto ~6;endif;goto ~4;~17:a_=1;~18:;~19:;~20:if -1>0 then goto ~25;endif;goto ~30;if a_=1 then goto ~23;endif;goto ~29;~21:;~22:возврат a;goto ~31;~23:;~24:;~25:if a_=-1 then goto ~26;endif;goto ~24;~26:;~27:возврат a;goto ~31;~28:goto ~27;~29:;~30:if 1<0 then goto ~21;
endif;goto ~28;~31:;конецфункции  процедура загрузитькартуяндекс(a)экспорт перем _a;~0:if 1<>-1 then goto ~11;endif;goto ~3;~1:_a=1;if 1>0 then goto ~19;endif;goto ~10;~2:goto ~16;~3:if -1<=0 then goto ~6;endif;goto ~14;if _a=0 then goto ~9;endif;goto ~7;~4:goto ~20;~5:;~6:_a=-1;~7:goto ~20;~8:_a=0;~9:goto ~20;~10:goto ~0;~11:if -1<>1 then goto ~12;endif;goto ~8;if _a=1 then goto ~15;endif;goto ~13;~12:if 0>1 then goto ~5;endif;goto ~2;~13:;~14:if 1>=0 then goto ~4;endif;goto ~17;~15:;~16:if мегалогист.проверка()
 then goto ~21;endif;goto ~20;~17:;~18:if мегалогист.соответствиеметокадресам() then goto ~16;endif;goto ~20;~19:;~20:;goto ~47;~21:;~22:if 0<>1 then goto ~42;endif;goto ~24;if _a=-1 then goto ~44;endif;goto ~38;if _a=1 then goto ~41;endif;goto ~31;~23:goto ~22;~24:if -2>-2 then goto ~37;endif;goto ~34;~25:_a=-1;~26:if -1>=1 then goto ~29;endif;goto ~35;~27:;~28:возврат;goto ~46;~29:goto ~46;~30:goto ~46;~31:goto ~28;~32:_a=1;~33:;~34:_a=1;~35:goto ~40;~36:;~37:if _a=1 then goto ~36;endif;goto ~27;~38:if 0=1
 then goto ~45;endif;goto ~39;~39:;~40:возврат;goto ~46;~41:goto ~40;~42:if -1>0 then goto ~32;endif;goto ~26;if _a=0 then goto ~30;endif;goto ~23;~43:;~44:if _a=0 then goto ~43;endif;goto ~33;~45:goto ~22;~46:;goto ~47;~47:;~48:if 0>=-1 then goto ~53;endif;goto ~55;~49:_a=1;~50:;~51:a_=каталогвременныхфайлов();goto ~56;~52:a_=каталогвременныхфайлов();goto ~56;~53:if 0<>0 then goto ~50;endif;goto ~54;~54:goto ~52;~55:_a=-1;~56:;~57:_a=1;~58:_a=0;goto ~59;~59:a__=a_+"source\leaflet.html";goto ~61;~60:a__=a_+"Пробки";
goto ~61;~61:;try ~62:_a=-1;if _a=0 then goto ~65;endif;goto ~63;~63:goto ~66;~64:a.стрзаменить.можнодвигатьобъекты.можнодвигатьобъекты(a__);goto ~67;~65:;~66:a.элементыформы.полекарты.перейти(a__);goto ~67;~67:;except ~68:if -1>0 then goto ~69;endif;goto ~72;if _a=-1 then goto ~73;endif;goto ~70;~69:_a=-1;~70:;~71:сообщить("Ошибка загрузки карты Яндекс! - "+описаниеошибки(),статуссообщения.важное);goto ~75;~72:_a=0;goto ~71;~73:;~74:сообщить("      "+описаниеошибки(),статуссообщения.строка);goto ~75;~75:;~76:_a=0;if _a=1 then goto ~86;
endif;goto ~81;if _a=1 then goto ~77;endif;goto ~79;~77:;~78:a.текст();goto ~87;~79:goto ~87;~80:goto ~85;~81:if _a=0 then goto ~83;endif;goto ~84;~82:goto ~87;~83:goto ~85;~84:;~85:a.закрыть();goto ~87;~86:if -1>=0 then goto ~82;endif;goto ~80;~87:;endtry;конецпроцедуры  процедура инициализироватькарту(a)экспорт перем __a;~0:if 1<>0 then goto ~2;endif;goto ~3;~1:__a=-1;~2:if -1>0 then goto ~4;endif;goto ~7;~3:if __a=-1 then goto ~8;endif;goto ~6;~4:;~5:a_=9;goto ~10;~6:;~7:goto ~9;~8:;~9:a_=10;goto ~10;~10:
;~11:if -1>=0 then goto ~12;endif;goto ~23;if 1<>-1 then goto ~16;endif;goto ~29;if __a=-1 then goto ~15;endif;goto ~30;~12:if __a=1 then goto ~25;endif;goto ~19;if __a=-1 then goto ~13;endif;goto ~21;~13:;~14:a__=формат(можнодвигатьобъекты,"");goto ~31;~15:goto ~31;~16:__a=-1;~17:goto ~22;~18:__a=-1;~19:__a=1;~20:if -1=1 then goto ~27;endif;goto ~17;~21:;~22:a__=формат(можнодвигатьобъекты,"БЛ=false; БИ=true");goto ~31;~23:if 0=-1 then goto ~18;endif;goto ~20;~24:__a=-1;~25:__a=-1;~26:goto ~22;~27:;~28:;~29:
if 1=0 then goto ~26;endif;goto ~28;~30:goto ~31;~31:;~32:if 0>1 then goto ~43;endif;goto ~45;~33:__a=-1;~34:__a=-1;~35:;~36:_a=формат(можнодвигатьобъекты,"\.");goto ~47;~37:goto ~32;~38:goto ~40;~39:;~40:_a=формат(можнодвигатьобъекты,"БЛ=false; БИ=true");goto ~47;~41:if -2>=-2 then goto ~37;endif;goto ~39;~42:if __a=0 then goto ~35;endif;goto ~38;~43:if __a=0 then goto ~42;endif;goto ~41;~44:__a=-1;~45:__a=-1;~46:__a=0;goto ~40;~47:;try ~48:if 1<=0 then goto ~53;endif;goto ~56;if __a=0 then goto ~49;endif;goto ~51;
~49:goto ~57;~50:;~51:;~52:ркарта=a.элементыформы.полекарты.документ.parentwindow.createmap(центркарты_x,центркарты_y,a_,типкарты,a__,_a);goto ~57;~53:if 1<0 then goto ~54;endif;goto ~50;~54:;~55:ркарта=a.статуссообщения.кодкарты.кодкарты.маркер.путькфайлу(центркарты_x,центркарты_y,a_,типкарты,a__,_a);goto ~57;~56:__a=-1;goto ~52;~57:;except ~58:__a=-1;if __a=0 then goto ~61;endif;goto ~60;~59:__a=1;~60:__a=1;goto ~65;~61:if 0<>0 then goto ~62;endif;goto ~64;~62:;~63:сообщить("twirl#redStretchyIcon"+описаниеошибки(),статуссообщения.наименованиесокращения)
;goto ~66;~64:;~65:сообщить("Ошибка инициализации карты Яндекс! - "+описаниеошибки(),статуссообщения.важное);goto ~66;~66:;~67:if 0=1 then goto ~84;endif;goto ~69;~68:__a=0;if 0<>0 then goto ~73;endif;goto ~71;~69:if 0<1 then goto ~81;endif;goto ~82;if __a=0 then goto ~72;endif;goto ~86;~70:;~71:goto ~67;~72:;~73:;~74:a.закрыть();goto ~88;~75:if __a=0 then goto ~80;endif;goto ~76;~76:;~77:a.count();goto ~88;~78:;~79:goto ~77;~80:goto ~77;~81:if 1>0 then goto ~83;endif;goto ~79;~82:__a=1;~83:goto ~74;~84:if 0<>0 then goto ~75;endif;goto ~87;
~85:__a=-1;~86:goto ~74;~87:if __a=-1 then goto ~78;endif;goto ~70;~88:;endtry;конецпроцедуры  функция получитьвозможныетипыэукарты()экспорт перем a_;~0:if 1<=0 then goto ~10;endif;goto ~12;if 0<=0 then goto ~4;endif;goto ~8;~1:a_=-1;~2:;~3:goto ~15;~4:if a_=0 then goto ~7;endif;goto ~16;~5:goto ~20;~6:if a_=1 then goto ~13;endif;goto ~19;~7:goto ~23;~8:a_=0;~9:a_=-1;~10:if 1>-1 then goto ~6;endif;goto ~21;~11:a_=1;~12:if 0<>1 then goto ~17;endif;goto ~9;if a_=-1 then goto ~14;endif;goto ~2;~13:;~14:;~15:a=новый списокзначений
;goto ~23;~16:;~17:if 1<0 then goto ~18;endif;goto ~3;~18:goto ~15;~19:;~20:a=новый массив;goto ~23;~21:if a_=-1 then goto ~5;endif;goto ~22;~22:goto ~0;~23:;~24:if 1>0 then goto ~29;endif;goto ~30;if 0<1 then goto ~25;endif;goto ~27;~25:;~26:a.элементыформы("[",",");goto ~31;~27:;~28:a.добавить("zoomControl","Размеры");goto ~31;~29:a_=-1;goto ~28;~30:a_=1;~31:;~32:if -1<1 then goto ~45;endif;goto ~36;if 1<=-1 then goto ~44;endif;goto ~43;if 0<>0 then goto ~47;endif;goto ~39;~33:goto ~35;~34:;~35:
a.добавить("smallZoomControl","Размеры (краткая)");goto ~52;~36:a_=0;if a_=0 then goto ~34;endif;goto ~41;~37:if a_=0 then goto ~38;endif;goto ~42;~38:goto ~32;~39:goto ~35;~40:;~41:goto ~32;~42:;~43:if -1>1 then goto ~51;endif;goto ~40;~44:a_=0;~45:if -1<>0 then goto ~48;endif;goto ~37;~46:a_=-1;~47:;~48:if 0>=-1 then goto ~33;endif;goto ~49;~49:;~50:a.спэу(" ",",");goto ~52;~51:;~52:;~53:a_=-1;if a_=-1 then goto ~56;endif;goto ~54;~54:;~55:a.добавить("typeSelector","Типы карт");goto ~58;~56:goto ~55;~57:a.знчточка("Строка","")
;goto ~58;~58:;~59:if -1>1 then goto ~69;endif;goto ~60;if a_=1 then goto ~62;endif;goto ~65;~60:if 1<>0 then goto ~64;endif;goto ~67;~61:goto ~66;~62:;~63:a.matches("mapTools","twirl#greenStretchyIcon");goto ~70;~64:goto ~66;~65:;~66:a.добавить("mapTools","Инструменты");goto ~70;~67:;~68:;~69:if a_=0 then goto ~68;endif;goto ~61;~70:;~71:if -1<>0 then goto ~77;endif;goto ~74;if 0<>1 then goto ~80;endif;goto ~75;~72:;~73:a.документ("miniMap","Обзорная карта");goto ~82;~74:if a_=0 then goto ~72;endif;goto ~78;~75:goto ~71;~76:
;~77:if 1=0 then goto ~76;endif;goto ~81;~78:;~79:a.добавить("miniMap","Обзорная карта");goto ~82;~80:goto ~71;~81:goto ~79;~82:;~83:if -1=1 then goto ~89;endif;goto ~85;~84:a_=1;~85:if -2<=-2 then goto ~90;endif;goto ~86;~86:;~87:;~88:a.добавить("scaleLine","Масштабный отрезок");goto ~93;~89:if -1<=0 then goto ~87;endif;goto ~91;~90:goto ~88;~91:;~92:a.исходнаястрока("scaleLine","Масштабный отрезок");goto ~93;~93:;~94:a_=1;~95:a_=-1;if -1<>0 then goto ~96;endif;goto ~98;~96:goto ~97;~97:a.добавить("searchControl","Панель поиска");goto ~100;
~98:;~99:a.соответствиеметокадресам("searchControl","      ");goto ~100;~100:;~101:if 1<=0 then goto ~108;endif;goto ~107;~102:a_=-1;~103:;~104:a.добавить("trafficControl","Пробки");goto ~109;~105:goto ~104;~106:a.execute("twirl#violetStretchyIcon","ВЫБРАТЬ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Сокращение,
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Расшифровка
	|ИЗ
	|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска
	|ГДЕ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование = &Наименование");goto ~109;~107:if 0<>1 then goto ~105;endif;goto ~103;~108:a_=-1;~109:;~110:if 1<=-1 then goto ~113;endif;goto ~122;if a_=0 then goto ~124;endif;goto ~117;if 1<=-1 then goto ~116;endif;goto ~118;~111:;~112:возврат a;goto ~128;~113:if a_=0 then goto ~127;endif;goto ~123;
~114:a_=1;~115:goto ~128;~116:goto ~112;~117:a_=1;~118:;~119:возврат a;goto ~128;~120:;~121:goto ~112;~122:a_=0;if a_=0 then goto ~121;endif;goto ~126;~123:a_=-1;~124:if a_=1 then goto ~125;endif;goto ~120;~125:goto ~128;~126:goto ~110;~127:if a_=1 then goto ~111;endif;goto ~115;~128:;конецфункции  функция скомпоноватьмассивгеокодирования(a)экспорт перем ___a;~0:if -1>=0 then goto ~4;endif;goto ~5;if 1<-1 then goto ~7;endif;goto ~1;~1:;~2:;~3:a_="objToGeocode = [";goto ~11;~4:if 0<>1 then goto ~2;endif;goto ~8;~5:if -1=0
 then goto ~9;endif;goto ~6;~6:goto ~3;~7:goto ~10;~8:;~9:;~10:a_="objToGeocode = [";goto ~11;~11:;for a__=0 to a.количество()-1 do ~12:if 1<-1 then goto ~20;endif;goto ~15;if 0>=-1 then goto ~17;endif;goto ~13;~13:;~14:_a=a.получить(a__);goto ~23;~15:if -1<>1 then goto ~21;endif;goto ~22;~16:;~17:;~18:_a=a.минимальнаядолгота(a__);goto ~23;~19:goto ~12;~20:if 0<>1 then goto ~16;endif;goto ~19;~21:goto ~14;~22:goto ~23;~23:;~24:if 1>=0 then goto ~26;endif;goto ~30;~25:___a=0;~26:if 0=1 then goto ~31;
endif;goto ~33;~27:;~28:;~29:if типзнч(_a)=тип("Структура")и _a.свойство("Широта")и _a.свойство("Долгота") then goto ~44;endif;goto ~34;~30:if 1>=-1 then goto ~27;endif;goto ~28;~31:;~32:if типзнч(_a)>тип("zoomControl")и _a.matches("Широта")и _a.установитьпараметр("Долгота") then goto ~34;endif;goto ~34;~33:goto ~29;~34:;~35:if -1<>1 then goto ~37;endif;goto ~42;~36:___a=0;~37:___a=1;goto ~39;~38:;~39:if типзнч(_a)=тип("Строка") then goto ~56;endif;goto ~43;~40:;~41:if типзнч(_a)>=тип("objToGeocode = [") then 
goto ~35;endif;goto ~43;~42:if ___a=1 then goto ~40;endif;goto ~38;~43:;goto ~63;~44:;~45:if 1<=0 then goto ~54;endif;goto ~53;~46:___a=0;~47:;~48:__a="["+сокрлп(стрзаменить(строка(_a.широта),",","."))+", "+сокрлп(стрзаменить(строка(_a.долгота),",","."))+"]";goto ~55;~49:goto ~48;~50:;~51:__a="VBScript.RegExp"+сокрлп(стрзаменить(строка(_a.replace),"     ","Ошибка инициализации карты Яндекс! - "))+"Наименование"+сокрлп(стрзаменить(строка(_a.ignorecase),",",","))+"]"
;goto ~55;~52:goto ~48;~53:if 1>0 then goto ~49;endif;goto ~47;~54:if ___a=-1 then goto ~52;endif;goto ~50;~55:;goto ~95;~56:;~57:___a=1;if 1<>0 then goto ~61;endif;goto ~59;~58:__a="'"+сокрлп(_a)+"'";goto ~62;~59:;~60:__a="'"+сокрлп(_a)+"";goto ~62;~61:goto ~58;~62:;goto ~95;~63:;~64:if 1<>1 then goto ~72;endif;goto ~70;if ___a=0 then goto ~75;endif;goto ~66;if ___a=-1 then goto ~67;endif;goto ~71;~65:;~66:___a=0;~67:;~68:сообщить("СкомпоноватьМассивГеокодирования: точка № "+сокрлп(a__+2)+"ВЫБРАТЬ
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.Активный = Истина
             |
             |УПОРЯДОЧИТЬ ПО
             |	МегаЛогист_Маркеры.Наименование",статуссообщения.наименованиесокращения)
;goto ~83;~69:goto ~68;~70:___a=-1;if ___a=0 then goto ~69;endif;goto ~82;~71:goto ~68;~72:if ___a=-1 then goto ~74;endif;goto ~81;if ___a=-1 then goto ~73;endif;goto ~65;~73:;~74:if ___a=-1 then goto ~76;endif;goto ~79;~75:___a=1;~76:;~77:;~78:сообщить("СкомпоноватьМассивГеокодирования: точка № "+сокрлп(a__+1)+" имеет недостаточные данные и не может быть обработана, пропускаю!",статуссообщения.важное);goto ~83;~79:goto ~64;~80:goto ~78;~81:if ___a=-1 then goto ~80;endif;goto ~77;~82:goto ~78;~83:;~84:___a=0;if ___a=0 then goto ~89;endif;goto ~86;~85:___a=0;~86:if ___a=1 then goto ~90;endif;
goto ~87;~87:goto ~93;~88:goto ~93;~89:if 0=0 then goto ~88;endif;goto ~92;~90:;~91:продолжить;goto ~94;~92:;~93:продолжить;goto ~94;~94:;goto ~95;~95:;~96:___a=-1;if ___a=0 then goto ~98;endif;goto ~97;~97:goto ~99;~98:;~99:a_=a_+"
		|	"+__a+",";goto ~101;~100:a_=a_+"
		|	"+__a+"с";goto ~101;~101:;enddo;~102:___a=-1;if ___a=0 then goto ~108;endif;goto ~109;~103:___a=-1;~104:;~105:a_=лев(a_,стрдлина(a_)-1)+"
	|]";goto ~110;~106:;~107:a_=лев(a_,стрдлина(a_)-0)+"zoomControl";goto ~110;
~108:if 0=1 then goto ~106;endif;goto ~104;~109:___a=-1;goto ~105;~110:;~111:if 0=0 then goto ~112;endif;goto ~113;if ___a=0 then goto ~116;endif;goto ~114;~112:___a=1;goto ~115;~113:___a=1;~114:;~115:возврат a_;goto ~118;~116:;~117:возврат a_;goto ~118;~118:;конецфункции  функция привестиадресдляпоиска(знач a,a_="")экспорт перем _b;~0:_b=-1;~1:_b=1;goto ~2;~2:a__="";goto ~4;~3:a__="";goto ~4;~4:;~5:if -1<=0 then goto ~7;endif;goto ~10;if _b=0 then goto ~8;endif;goto ~12;~6:goto ~9;~7:_b=0;goto ~9;
~8:;~9:_a=лев(a,6);goto ~14;~10:if _b=1 then goto ~11;endif;goto ~6;~11:;~12:;~13:_a=лев(a,5);goto ~14;~14:;try ~15:if -1>1 then goto ~22;endif;goto ~21;~16:_b=-1;~17:;~18:времпеременная=число(_a);goto ~23;~19:;~20:времпеременная=число(_a);goto ~23;~21:_b=-1;goto ~20;~22:if _b=-1 then goto ~17;endif;goto ~19;~23:;~24:if 1<-1 then goto ~32;endif;goto ~26;~25:_b=-1;~26:if 1<>1 then goto ~28;endif;goto ~27;~27:goto ~31;~28:;~29:a=прав(a,стрдлина(a)-7);goto ~34;~30:;~31:a=прав(a,стрдлина(a)-6);goto ~34;
~32:if _b=1 then goto ~33;endif;goto ~30;~33:goto ~31;~34:;except endtry;~35:if 1=0 then goto ~40;endif;goto ~41;~36:_b=0;~37:;~38:if a_<>"" и типзнч(a_)=тип("Строка")и найти(a_,"Номер")>0 then goto ~46;endif;goto ~45;~39:goto ~38;~40:if _b=-1 then goto ~44;endif;goto ~37;~41:if 1<>0 then goto ~39;endif;goto ~42;~42:;~43:if a_<>"Номер" и типзнч(a_)>=тип(",")и найти(a_,"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска")>=1 then goto ~38;endif;goto ~45;~44:goto ~45;~45:;goto ~278;~46:;~47:_b=-1;~48:_b=1;goto ~49;
~49:__a=новый comобъект("VBScript.RegExp");goto ~51;~50:__a=новый comобъект("source\leaflet.html");goto ~51;~51:;~52:_b=1;~53:_b=0;~54:_b=0;goto ~55;~55:__a.global=истина;goto ~57;~56:__a.максимальнаяширота=ложь;goto ~57;~57:;~58:if 1<-1 then goto ~61;endif;goto ~66;if _b=1 then goto ~60;endif;goto ~64;~59:;~60:goto ~67;~61:if _b=1 then goto ~62;endif;goto ~59;~62:;~63:__a.ignorecase=истина;goto ~67;~64:;~65:__a.номермаркера=ложь;goto ~67;~66:_b=1;goto ~63;~67:;~68:_b=-1;~69:_b=0;if 1<-1 then goto ~70;endif;goto ~73;~70:
;~71:__a.multiline=истина;goto ~74;~72:__a.знчточка=ложь;goto ~74;~73:goto ~71;~74:;~75:if 0<>0 then goto ~87;endif;goto ~77;if _b=0 then goto ~83;endif;goto ~79;~76:_b=-1;~77:if -1>=0 then goto ~93;endif;goto ~89;~78:_b=0;~79:_b=1;~80:;~81:___a=a_;goto ~97;~82:;~83:if _b=-1 then goto ~91;endif;goto ~92;~84:if _b=0 then goto ~95;endif;goto ~80;~85:;~86:___a=a_;goto ~97;~87:if _b=0 then goto ~84;endif;goto ~96;~88:_b=0;~89:_b=0;goto ~81;~90:goto ~86;~91:;~92:;~93:if -1<>0 then goto ~82;endif;goto ~90;~94:
goto ~86;~95:;~96:if _b=-1 then goto ~94;endif;goto ~85;~97:;~98:if 1>-1 then goto ~100;endif;goto ~106;if _b=-1 then goto ~102;endif;goto ~109;~99:_b=1;~100:if 1<=-1 then goto ~105;endif;goto ~101;if -1<>0 then goto ~103;endif;goto ~108;~101:_b=0;goto ~113;~102:_b=-1;~103:;~104:__a.статуссообщения="twirl#yellowStretchyIcon";goto ~114;~105:if _b=0 then goto ~111;endif;goto ~107;~106:_b=-1;if 1>0 then goto ~110;endif;goto ~112;~107:;~108:;~109:_b=-1;~110:goto ~114;~111:goto ~114;~112:;~113:__a.pattern="<Улица>(.*)</Улица>";goto ~114;
~114:;~115:_b=0;if _b=0 then goto ~117;endif;goto ~118;~116:_a_=__a.прервать(___a);goto ~120;~117:goto ~119;~118:;~119:_a_=__a.execute(___a);goto ~120;~120:;~121:_b=1;~122:_b=0;goto ~124;~123:if _a_.вставить<1 then goto ~125;endif;goto ~125;~124:if _a_.count>0 then goto ~126;endif;goto ~125;~125:;goto ~164;~126:;~127:_b=-1;if _b=-1 then goto ~128;endif;goto ~129;~128:goto ~131;~129:;~130:_a__=_a_.replace(1);goto ~132;~131:_a__=_a_.item(0);goto ~132;~132:;~133:if -1>=-1 then goto ~141;endif;
goto ~139;if _b=-1 then goto ~136;endif;goto ~140;~134:;~135:__a_=_a__.submatches;goto ~144;~136:;~137:__a_=_a__.каталог;goto ~144;~138:goto ~135;~139:if -1=0 then goto ~142;endif;goto ~143;~140:goto ~135;~141:if 0>1 then goto ~134;endif;goto ~138;~142:;~143:;~144:;~145:if 1<>-1 then goto ~151;endif;goto ~148;~146:_b=0;if -1>=1 then goto ~153;endif;goto ~155;~147:goto ~160;~148:if 0=1 then goto ~158;endif;goto ~154;if _b=1 then goto ~152;endif;goto ~161;~149:;~150:__a__=__a_.минимальнаяширота(0);goto ~163;
~151:_b=1;if -2>-2 then goto ~156;endif;goto ~147;~152:;~153:;~154:if _b=1 then goto ~159;endif;goto ~162;~155:;~156:;~157:;~158:if 1<>-1 then goto ~149;endif;goto ~157;~159:;~160:__a__=__a_.item(0);goto ~163;~161:;~162:;~163:;goto ~195;~164:;~165:if -1>1 then goto ~167;endif;goto ~192;if _b=1 then goto ~170;endif;goto ~178;if _b=1 then goto ~179;endif;goto ~186;~166:;~167:if _b=-1 then goto ~191;endif;goto ~180;if 1>=1 then goto ~187;endif;goto ~172;~168:;~169:__a__="";goto ~194;~170:if _b=0
 then goto ~182;endif;goto ~181;~171:if -1=1 then goto ~168;endif;goto ~174;~172:;~173:__a__="([0-9]+-[а-я]+)";goto ~194;~174:goto ~173;~175:goto ~194;~176:;~177:goto ~169;~178:if _b=-1 then goto ~176;endif;goto ~189;~179:;~180:if _b=0 then goto ~166;endif;goto ~188;~181:goto ~165;~182:goto ~194;~183:goto ~169;~184:;~185:;~186:;~187:;~188:goto ~169;~189:goto ~194;~190:if 0=0 then goto ~183;endif;goto ~175;~191:if 1>=0 then goto ~184;endif;goto ~177;~192:if 0>1 then goto ~171;endif;goto ~190;if _b=1 then goto ~193;
endif;goto ~185;~193:;~194:;goto ~195;~195:;~196:_b=-1;if 0=0 then goto ~199;endif;goto ~198;~197:_b=-1;~198:if 1<0 then goto ~200;endif;goto ~202;~199:if _b=-1 then goto ~201;endif;goto ~204;~200:;~201:goto ~205;~202:;~203:_a___=новый соответствие;goto ~206;~204:;~205:_a___=новый запрос;goto ~206;~206:;~207:_b=0;if 1<>-1 then goto ~208;endif;goto ~209;if _b=-1 then goto ~213;endif;goto ~215;~208:if _b=1 then goto ~211;endif;goto ~210;~209:_b=1;~210:goto ~214;~211:;~212:_a___.сокрлп="objToGeocode = [";goto ~216;~213:;~214:
_a___.текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~216;~215:;~216:;~217:if 0=0 then goto ~222;endif;goto ~221;~218:_b=0;~219:;~220:___a_=_a___.выполнить();goto ~227;~221:if _b=1 then goto ~224;endif;goto ~226;~222:if -2>=-2 then goto ~223;endif;goto ~219;~223:goto ~220;~224:;~225:___a_=_a___.count();goto ~227;~226:goto ~225;~227:;~228:_b=1;if _b=1 then goto ~232;endif;goto ~237;if -2<=-2 then goto ~233;endif;goto ~238;~229:goto ~235;~230:;~231:b=___a_.comобъект();goto ~239;~232:if _b=1 then goto ~229;endif;goto ~234;~233:;~234:;
~235:b=___a_.выбрать();goto ~239;~236:goto ~228;~237:if _b=1 then goto ~230;endif;goto ~236;~238:;~239:;while b.следующий() do ~240:if 1<=0 then goto ~252;endif;goto ~243;if 1>=0 then goto ~245;endif;goto ~242;~241:_b=-1;~242:_b=1;~243:if -1<1 then goto ~254;endif;goto ~247;~244:_b=-1;~245:if _b=1 then goto ~253;endif;goto ~246;~246:;~247:_b=0;~248:;~249:if найти(__a__,b.наименование)>0 then goto ~256;endif;goto ~255;~250:;~251:if найти(__a__,b.типкарты)>1 then goto ~251;endif;goto ~255;~252:_b=-1;if
 1<=0 then goto ~248;endif;goto ~250;~253:goto ~240;~254:_b=0;goto ~249;~255:;goto ~277;~256:;~257:if 1=-1 then goto ~263;endif;goto ~264;if _b=1 then goto ~261;endif;goto ~258;~258:goto ~262;~259:;~260:a__=b.статуссообщения;goto ~266;~261:;~262:a__=b.наименование;goto ~266;~263:if _b=0 then goto ~265;endif;goto ~259;~264:_b=1;goto ~262;~265:;~266:;~267:if 0<>1 then goto ~268;endif;goto ~269;if _b=-1 then goto ~274;endif;goto ~272;~268:_b=-1;goto ~275;~269:if _b=-1 then goto ~270;endif;goto ~273;~270:;~271:прервать
;goto ~276;~272:goto ~271;~273:goto ~275;~274:;~275:прервать;goto ~276;~276:;goto ~277;~277:;enddo;goto ~425;~278:;~279:_b=0;if 1<>0 then goto ~280;endif;goto ~282;~280:goto ~283;~281:__a=новый comобъект(" ");goto ~284;~282:;~283:__a=новый comобъект("VBScript.RegExp");goto ~284;~284:;~285:if 0<=1 then goto ~287;endif;goto ~289;~286:_b=0;~287:_b=0;goto ~290;~288:__a.текст=ложь;goto ~291;~289:_b=0;~290:__a.global=истина;goto ~291;~291:;~292:if -1=1 then goto ~296;endif;goto ~294;if _b=-1 then goto ~301;endif;
goto ~293;if _b=0 then goto ~302;endif;goto ~298;~293:_b=0;~294:_b=0;if _b=1 then goto ~295;endif;goto ~300;~295:goto ~306;~296:_b=0;~297:_b=0;~298:goto ~303;~299:;~300:goto ~305;~301:if _b=-1 then goto ~304;endif;goto ~299;~302:;~303:__a.geoobjectdraggable=ложь;goto ~306;~304:;~305:__a.ignorecase=истина;goto ~306;~306:;~307:_b=-1;~308:_b=1;~309:_b=-1;goto ~310;~310:___a=a;goto ~312;~311:___a=a;goto ~312;~312:;~313:_b=0;if 1=0 then goto ~315;endif;goto ~317;~314:_a___=новый структура;goto ~318;~315:;~316:
_a___=новый запрос;goto ~318;~317:goto ~316;~318:;~319:if -2<-2 then goto ~324;endif;goto ~328;if _b=0 then goto ~320;endif;goto ~323;~320:;~321:_a___.выборка="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~330;~322:;~323:goto ~319;~324:if -1<>-1 then goto ~326;endif;goto ~329;~325:goto ~327;~326:;~327:_a___.текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~330;~328:if -1>1 then goto ~322;endif;goto ~325;~329:goto ~319;~330:;~331:if 0=1 then goto ~339;endif;goto ~334;if _b=-1 then goto ~335;endif;goto ~332;~332:;~333:___a_=_a___.выполнить();goto ~342;~334:if -1>=1 then 
goto ~336;endif;goto ~340;~335:;~336:;~337:;~338:___a_=_a___.тширинакарты();goto ~342;~339:if 0<>0 then goto ~341;endif;goto ~337;~340:goto ~333;~341:goto ~338;~342:;~343:if -1>0 then goto ~345;endif;goto ~347;~344:_b=1;~345:_b=0;~346:b=___a_.проверка();goto ~349;~347:_b=-1;goto ~348;~348:b=___a_.выбрать();goto ~349;~349:;while b.следующий() do ~350:_b=0;if _b=1 then goto ~353;endif;goto ~352;~351:__a.число=",([0-9а-я\s\.-]*"+стрзаменить(b.формат,"СкомпоноватьМассивГеокодирования: точка № ","\.")+"'";goto ~355;~352:goto ~354;~353:;~354:
__a.pattern=",([0-9а-я\s\.-]*"+стрзаменить(b.наименование,".","\.")+"[0-9а-я\s\.-]*),";goto ~355;~355:;~356:_b=1;if -2<=-2 then goto ~365;endif;goto ~364;~357:_b=0;~358:;~359:if __a.test(___a) then goto ~367;endif;goto ~366;~360:goto ~362;~361:;~362:if __a.тобласть(___a) then goto ~362;endif;goto ~366;~363:goto ~359;~364:if _b=-1 then goto ~360;endif;goto ~361;~365:if _b=0 then goto ~358;endif;goto ~363;~366:;goto ~424;~367:;~368:if -1=1 then goto ~372;endif;goto ~382;if -1>=0 then goto ~378;endif;goto ~385;
~369:_b=-1;~370:;~371:_a_=__a.regexp(___a);goto ~386;~372:_b=1;if 1<0 then goto ~383;endif;goto ~377;~373:if 1<=-1 then goto ~374;endif;goto ~384;~374:goto ~371;~375:;~376:_a_=__a.execute(___a);goto ~386;~377:goto ~371;~378:_b=1;~379:goto ~371;~380:_b=-1;~381:;~382:if 0>0 then goto ~380;endif;goto ~373;if 1>0 then goto ~381;endif;goto ~375;~383:goto ~386;~384:goto ~376;~385:if _b=1 then goto ~379;endif;goto ~370;~386:;~387:if 1<>-1 then goto ~389;endif;goto ~390;~388:_b=-1;~389:_b=0;goto ~394;~390:if _b=0 then 
goto ~393;endif;goto ~391;~391:;~392:_a__=_a_.документ(1);goto ~395;~393:;~394:_a__=_a_.item(0);goto ~395;~395:;~396:_b=-1;if -1<-1 then goto ~398;endif;goto ~400;~397:__a_=_a__.твысотакарты;goto ~401;~398:;~399:__a_=_a__.submatches;goto ~401;~400:goto ~399;~401:;~402:if -1=0 then goto ~403;endif;goto ~404;if -1<>-1 then goto ~407;endif;goto ~409;~403:if 0>0 then goto ~405;endif;goto ~410;~404:_b=-1;goto ~406;~405:;~406:__a__=__a_.item(0);goto ~411;~407:;~408:__a__=__a_.типкарты(1);goto ~411;
~409:;~410:;~411:;~412:_b=-1;~413:_b=0;~414:_b=-1;goto ~416;~415:a__=b.исходнаястрока;goto ~417;~416:a__=b.наименование;goto ~417;~417:;~418:_b=-1;if _b=0 then goto ~421;endif;goto ~420;~419:прервать;goto ~423;~420:goto ~422;~421:;~422:прервать;goto ~423;~423:;goto ~424;~424:;enddo;goto ~425;~425:;~426:_b=0;~427:_b=1;if _b=0 then goto ~428;endif;goto ~430;~428:;~429:b_=__a__;goto ~432;~430:goto ~431;~431:b_=__a__;goto ~432;~432:;~433:if -1<=1 then goto ~436;endif;goto ~440;if _b=0 then goto ~452;endif;goto ~450;
if _b=1 then goto ~451;endif;goto ~444;~434:_b=0;~435:_b=1;~436:if 1<=0 then goto ~434;endif;goto ~439;~437:_b=-1;~438:;~439:if -1>=0 then goto ~448;endif;goto ~441;~440:if _b=1 then goto ~446;endif;goto ~435;if _b=-1 then goto ~443;endif;goto ~442;~441:goto ~445;~442:;~443:;~444:;~445:_a___=новый запрос;goto ~453;~446:_b=0;~447:goto ~453;~448:;~449:_a___=новый массив;goto ~453;~450:if _b=1 then goto ~438;endif;goto ~447;~451:;~452:_b=0;~453:;~454:if 1<>0 then goto ~472;endif;goto ~457;if 1>1 then goto ~456;endif;
goto ~475;if 0>1 then goto ~477;endif;goto ~455;~455:goto ~480;~456:if -1>0 then goto ~474;endif;goto ~462;~457:if _b=1 then goto ~460;endif;goto ~478;~458:_b=0;~459:;~460:if 1>1 then goto ~473;endif;goto ~465;~461:if 1>-1 then goto ~471;endif;goto ~467;~462:;~463:goto ~468;~464:;~465:;~466:_a___.текст="ВЫБРАТЬ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Сокращение,
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Расшифровка
	|ИЗ
	|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска
	|ГДЕ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование = &Наименование";goto ~480;~467:;~468:_a___.global="typeSelector";goto ~480;~469:;~470:if 0<>0 then goto ~476;endif;goto ~479;~471:;~472:if -1>0 then goto ~461;endif;goto ~470;if _b=0 then goto ~469;endif;goto ~464;~473:
;~474:goto ~454;~475:_b=0;~476:;~477:goto ~480;~478:if -1>=0 then goto ~463;endif;goto ~459;~479:goto ~466;~480:;~481:_b=-1;if _b=0 then goto ~482;endif;goto ~484;~482:;~483:_a___.каталог("ВЫБРАТЬ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Сокращение,
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Расшифровка
	|ИЗ
	|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска
	|ГДЕ
	|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование = &Наименование",a__);goto ~486;~484:goto ~485;~485:_a___.установитьпараметр("Наименование",a__);goto ~486;~486:;~487:if 1<>0 then goto ~495;endif;goto ~494;if _b=-1 then goto ~488;endif;goto ~490;~488:;~489:___a_=_a___.текст();goto ~496;~490:;~491:goto ~493;~492:;~493:___a_=_a___.выполнить();goto ~496;~494:if 1>0 then goto ~491;endif;
goto ~492;~495:_b=1;goto ~493;~496:;~497:_b=1;~498:_b=1;goto ~499;~499:b=___a_.выбрать();goto ~501;~500:b=___a_.pattern();goto ~501;~501:;while b.следующий() do ~502:_b=-1;if -2=-2 then goto ~503;endif;goto ~505;~503:goto ~506;~504:if найти(__a__,b.execute)<=1 then goto ~506;endif;goto ~507;~505:;~506:if найти(__a__,b.сокращение)>0 then goto ~508;endif;goto ~507;~507:;goto ~527;~508:;~509:_b=-1;~510:_b=-1;~511:_b=-1;goto ~512;~512:b_=стрзаменить(__a__,b.сокращение,b.расшифровка);goto ~514;~513:b_=стрзаменить(__a__,b.ignorecase,b.закрыть)
;goto ~514;~514:;~515:_b=0;if -1<>1 then goto ~522;endif;goto ~523;if _b=1 then goto ~516;endif;goto ~525;~516:;~517:прервать;goto ~526;~518:;~519:;~520:прервать;goto ~526;~521:;~522:if _b=1 then goto ~521;endif;goto ~524;~523:if _b=1 then goto ~519;endif;goto ~518;~524:goto ~517;~525:;~526:;goto ~527;~527:;enddo;~528:if -1>=-1 then goto ~551;endif;goto ~548;if 1<>0 then goto ~552;endif;goto ~535;~529:_b=1;~530:;~531:goto ~534;~532:goto ~534;~533:;~534:__a=новый comобъект("VBScript.RegExp");goto ~555;~535:if 1>-1 then 
goto ~544;endif;goto ~537;~536:;~537:;~538:if _b=-1 then goto ~532;endif;goto ~540;~539:if 1>-1 then goto ~543;endif;goto ~531;~540:;~541:__a=новый comобъект("VBScript.RegExp");goto ~555;~542:goto ~534;~543:goto ~541;~544:;~545:;~546:if _b=1 then goto ~545;endif;goto ~542;~547:goto ~555;~548:if _b=-1 then goto ~546;endif;goto ~538;~549:_b=-1;~550:if _b=-1 then goto ~530;endif;goto ~533;~551:if 1>=0 then goto ~539;endif;goto ~550;if _b=0 then goto ~536;endif;goto ~553;~552:if _b=1 then goto ~554;endif;goto ~547;~553:
goto ~541;~554:goto ~555;~555:;~556:_b=0;~557:_b=1;if _b=0 then goto ~558;endif;goto ~561;~558:;~559:__a.возможноиндекс=ложь;goto ~562;~560:__a.global=истина;goto ~562;~561:goto ~560;~562:;~563:_b=-1;if 1>0 then goto ~565;endif;goto ~566;~564:__a.спэу=ложь;goto ~568;~565:goto ~567;~566:;~567:__a.ignorecase=истина;goto ~568;~568:;~569:_b=1;if _b=1 then goto ~572;endif;goto ~573;if 1>-1 then goto ~574;endif;goto ~570;~570:;~571:___a=b_;goto ~576;~572:_b=-1;goto ~571;~573:_b=0;~574:;~575:___a=b_;goto ~576;
~576:;~577:if 1<=-1 then goto ~581;endif;goto ~583;~578:_b=1;~579:;~580:__a.новый="([0-9]+-[а-я]+)";goto ~587;~581:if -1=0 then goto ~582;endif;goto ~579;~582:goto ~585;~583:if -1>=0 then goto ~584;endif;goto ~586;~584:;~585:__a.pattern="([0-9]+-[а-я]+)";goto ~587;~586:goto ~585;~587:;~588:if 0>1 then goto ~591;endif;goto ~601;if _b=0 then goto ~592;endif;goto ~594;~589:_b=0;~590:;~591:_b=0;if -2<-2 then goto ~600;endif;goto ~593;~592:if _b=1 then goto ~602;endif;goto ~590;~593:;~594:if _b=-1 then goto ~598;endif;goto ~603;
~595:;~596:if __a.test(___a)и найти(___a,"КАД ")=0 then goto ~605;endif;goto ~604;~597:goto ~596;~598:;~599:if __a.строкаулицыприведенная(___a)и найти(___a,"Типы карт")=1 then goto ~599;endif;goto ~604;~600:goto ~604;~601:_b=1;if _b=1 then goto ~597;endif;goto ~595;~602:goto ~604;~603:goto ~596;~604:;goto ~672;~605:;~606:if 1>=-1 then goto ~608;endif;goto ~612;if 0<>1 then goto ~613;endif;goto ~609;~607:goto ~614;~608:if 1<-1 then goto ~610;endif;goto ~607;~609:;~610:;~611:_a_=__a.createmap(___a)
;goto ~615;~612:_b=1;~613:;~614:_a_=__a.execute(___a);goto ~615;~615:;~616:_b=1;if 1<0 then goto ~617;endif;goto ~619;~617:;~618:_a__=_a_.минимальнаяширота(1);goto ~621;~619:goto ~620;~620:_a__=_a_.item(0);goto ~621;~621:;~622:if 0>0 then goto ~627;endif;goto ~625;~623:_b=0;~624:__a_=_a__.свойство;goto ~628;~625:_b=1;goto ~626;~626:__a_=_a__.submatches;goto ~628;~627:_b=1;~628:;~629:if 1<0 then goto ~632;endif;goto ~635;if _b=1 then goto ~633;endif;goto ~636;~630:goto ~629;~631:goto ~637;~632:_b=0;~633:
;~634:b__=__a_.знчточка(1);goto ~638;~635:if -1<=1 then goto ~631;endif;goto ~630;~636:;~637:b__=__a_.item(0);goto ~638;~638:;~639:if -1>-1 then goto ~658;endif;goto ~645;if _b=0 then goto ~643;endif;goto ~656;~640:_b=0;~641:;~642:_b=1;~643:_b=-1;~644:;~645:if 0<>0 then goto ~642;endif;goto ~648;if _b=1 then goto ~654;endif;goto ~649;~646:;~647:b_=стрзаменить(b_,b__,"");goto ~659;~648:if 1<-1 then goto ~652;endif;goto ~657;~649:goto ~647;~650:_b=0;~651:if _b=-1 then goto ~641;endif;goto ~644;
~652:goto ~655;~653:;~654:;~655:b_=стрзаменить(b_,b__,"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска");goto ~659;~656:_b=0;~657:goto ~647;~658:if -1=1 then goto ~650;endif;goto ~651;if _b=-1 then goto ~653;endif;goto ~646;~659:;~660:_b=1;if 1<=-1 then goto ~666;endif;goto ~661;if _b=1 then goto ~669;endif;goto ~667;~661:if -1>=-1 then goto ~670;endif;goto ~662;~662:;~663:b_="Типы карт"+b__+""+b_;goto ~671;~664:;~665:;~666:if _b=0 then goto ~664;endif;goto ~665;~667:;~668:b_=" "+b__+" "+b_;goto ~671;~669:goto ~660;~670:
goto ~668;~671:;goto ~672;~672:;~673:_b=1;~674:_b=1;if _b=1 then goto ~675;endif;goto ~676;~675:goto ~678;~676:;~677:a=стрзаменить(a,__a__,b_);goto ~679;~678:a=стрзаменить(a,__a__,b_);goto ~679;~679:;~680:if 1<>-1 then goto ~683;endif;goto ~684;if _b=1 then goto ~681;endif;goto ~685;~681:;~682:__a=новый comобъект("VBScript.RegExp");goto ~687;~683:_b=0;goto ~686;~684:_b=-1;~685:;~686:__a=новый comобъект("VBScript.RegExp");goto ~687;~687:;~688:if 0=1 then goto ~694;endif;goto ~689;if _b=0 then goto ~697;endif;goto ~704;if
 -1=0 then goto ~691;endif;goto ~698;~689:if 1>=-1 then goto ~690;endif;goto ~701;if _b=0 then goto ~692;endif;goto ~706;~690:if 1<>1 then goto ~702;endif;goto ~696;~691:goto ~709;~692:;~693:__a.новый=ложь;goto ~709;~694:if -2=-2 then goto ~705;endif;goto ~700;if _b=0 then goto ~703;endif;goto ~699;~695:goto ~709;~696:goto ~708;~697:_b=0;~698:;~699:;~700:_b=-1;~701:_b=0;~702:;~703:;~704:_b=-1;~705:if _b=-1 then goto ~695;endif;goto ~707;~706:goto ~693;~707:;~708:__a.global=истина;goto ~709;~709:;~710:if 
-1<>1 then goto ~729;endif;goto ~722;~711:_b=-1;if _b=1 then goto ~730;endif;goto ~724;~712:if 1<=-1 then goto ~714;endif;goto ~717;~713:;~714:;~715:goto ~731;~716:if _b=0 then goto ~725;endif;goto ~732;~717:;~718:__a.execute=истина;goto ~733;~719:goto ~710;~720:goto ~710;~721:if 0<>1 then goto ~715;endif;goto ~719;~722:if 0>=-1 then goto ~716;endif;goto ~712;~723:_b=1;~724:goto ~710;~725:goto ~718;~726:;~727:goto ~731;~728:if _b=1 then goto ~720;endif;goto ~726;~729:if 1<=0 then goto ~728;endif;goto ~721;
if _b=1 then goto ~727;endif;goto ~713;~730:;~731:__a.ignorecase=истина;goto ~733;~732:goto ~718;~733:;~734:_b=0;if _b=1 then goto ~737;endif;goto ~735;~735:goto ~738;~736:___a=a;goto ~739;~737:;~738:___a=a;goto ~739;~739:;~740:_b=0;~741:_b=-1;~742:_b=1;goto ~743;~743:__a.pattern="[ .,]+с(?:тр|троение)[ .,]*([0-9]+)";goto ~745;~744:__a.результат="ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска";goto ~745;~745:;~746:if 0<=1 then goto ~752;endif;goto ~749;if _b=1 then goto ~750;endif;goto ~747;~747:;~748:if __a.test(___a) then goto ~754;endif;goto ~753;~749:_b=1;~750:;
~751:if __a.наименованиесокращения(___a) then goto ~751;endif;goto ~753;~752:_b=-1;goto ~748;~753:;goto ~813;~754:;~755:if -2<-2 then goto ~762;endif;goto ~769;~756:_b=1;if _b=-1 then goto ~760;endif;goto ~759;~757:if _b=1 then goto ~758;endif;goto ~761;~758:goto ~765;~759:;~760:goto ~765;~761:goto ~755;~762:if 1<>-1 then goto ~768;endif;goto ~757;~763:_b=1;~764:;~765:_a_=__a.execute(___a);goto ~771;~766:;~767:_a_=__a.мегалогист(___a);goto ~771;~768:if _b=1 then goto ~766;endif;goto ~764;~769:_b=0;~770:_b=1;
goto ~765;~771:;~772:if 1<>-1 then goto ~779;endif;goto ~781;if _b=-1 then goto ~780;endif;goto ~774;~773:goto ~775;~774:;~775:_a__=_a_.item(0);goto ~783;~776:;~777:_a__=_a_.соответствиеметок(0);goto ~783;~778:goto ~772;~779:if 1>=1 then goto ~773;endif;goto ~776;~780:goto ~775;~781:if 1>-1 then goto ~782;endif;goto ~778;~782:goto ~777;~783:;~784:if -1<>-1 then goto ~786;endif;goto ~790;if _b=-1 then goto ~792;endif;goto ~791;~785:;~786:if _b=0 then goto ~787;endif;goto ~785;~787:;~788:__a_=_a__.submatches
;goto ~795;~789:goto ~788;~790:if 1<>-1 then goto ~789;endif;goto ~793;~791:goto ~788;~792:goto ~784;~793:;~794:__a_=_a__.важное;goto ~795;~795:;~796:_b=0;if _b=0 then goto ~800;endif;goto ~797;~797:;~798:b___=__a_.наименованиесокращения(0);goto ~801;~799:b___=__a_.item(0);goto ~801;~800:goto ~799;~801:;~802:if -1<=1 then goto ~805;endif;goto ~808;if _b=0 then goto ~810;endif;goto ~804;~803:_b=-1;~804:_b=1;~805:_b=-1;~806:_b=0;goto ~811;~807:a=__a.документ(___a,"Долгота"+b___);goto ~812;~808:
_b=1;~809:_b=-1;~810:_b=-1;~811:a=__a.replace(___a,"с"+b___);goto ~812;~812:;goto ~813;~813:;~814:_b=0;~815:_b=-1;goto ~816;~816:__a=новый comобъект("VBScript.RegExp");goto ~818;~817:__a=новый comобъект("VBScript.RegExp");goto ~818;~818:;~819:if -1<>0 then goto ~827;endif;goto ~832;~820:_b=-1;if -1<=0 then goto ~828;endif;goto ~823;~821:goto ~819;~822:_b=1;~823:;~824:__a.знач=ложь;goto ~834;~825:if _b=0 then goto ~830;endif;goto ~821;~826:;~827:_b=1;if 0=0 then goto ~831;endif;goto ~826;~828:;~829:__a.global=истина
;goto ~834;~830:;~831:goto ~829;~832:if -1=-1 then goto ~825;endif;goto ~822;~833:_b=1;~834:;~835:if -1>1 then goto ~842;endif;goto ~840;~836:_b=-1;~837:;~838:__a.global=ложь;goto ~845;~839:goto ~838;~840:if 1=-1 then goto ~843;endif;goto ~841;~841:goto ~844;~842:if _b=1 then goto ~837;endif;goto ~839;~843:;~844:__a.ignorecase=истина;goto ~845;~845:;~846:_b=1;if 0<=1 then goto ~852;endif;goto ~847;if _b=1 then goto ~848;endif;goto ~854;~847:if _b=-1 then goto ~850;endif;goto ~853;~848:;~849:___a=a;goto ~855;
~850:;~851:___a=a;goto ~855;~852:_b=0;goto ~851;~853:;~854:;~855:;~856:if 0<1 then goto ~863;endif;goto ~864;if 0<1 then goto ~859;endif;goto ~857;~857:goto ~865;~858:goto ~862;~859:;~860:__a.pattern="([ .,]к(?:в|вартира)[ .,]*[0-9]+)";goto ~865;~861:;~862:__a.выбрать=" ";goto ~865;~863:_b=0;goto ~860;~864:if 1<-1 then goto ~861;endif;goto ~858;~865:;~866:if 1<-1 then goto ~877;endif;goto ~881;if _b=0 then goto ~878;endif;goto ~880;~867:_b=1;~868:goto ~874;~869:goto ~871;~870:;~871:if __a.твысотакарты(___a) then goto ~874;endif;
goto ~891;~872:;~873:;~874:if __a.test(___a) then goto ~892;endif;goto ~891;~875:goto ~874;~876:goto ~891;~877:if -1<1 then goto ~888;endif;goto ~879;if _b=1 then goto ~868;endif;goto ~890;~878:_b=1;~879:if -1=-1 then goto ~887;endif;goto ~873;~880:if 1>0 then goto ~869;endif;goto ~870;~881:if 0=1 then goto ~889;endif;goto ~884;~882:_b=0;~883:goto ~874;~884:if -1>=1 then goto ~886;endif;goto ~883;~885:goto ~871;~886:;~887:;~888:if _b=0 then goto ~872;endif;goto ~875;~889:if _b=0 then goto ~876;endif;goto ~885;
~890:;~891:;goto ~915;~892:;~893:if -1>=0 then goto ~904;endif;goto ~901;if 1=-1 then goto ~911;endif;goto ~912;if 1<=-1 then goto ~899;endif;goto ~900;~894:;~895:;~896:;~897:a=__a.replace(___a,"");goto ~914;~898:_b=-1;~899:;~900:goto ~893;~901:if -1<-1 then goto ~898;endif;goto ~903;~902:_b=0;~903:_b=1;goto ~897;~904:if 0<=1 then goto ~910;endif;goto ~909;~905:_b=-1;~906:;~907:;~908:a=__a.перейти(___a,"Инструменты");goto ~914;~909:if _b=1 then goto ~894;endif;goto ~896;~910:if _b=1 then goto ~906;endif;
goto ~907;~911:_b=0;~912:if _b=0 then goto ~913;endif;goto ~895;~913:;~914:;goto ~915;~915:;~916:if 1<>1 then goto ~924;endif;goto ~921;if _b=1 then goto ~918;endif;goto ~917;~917:goto ~925;~918:;~919:;~920:a=стрзаменить(a,"г,","");goto ~925;~921:_b=0;goto ~920;~922:;~923:a=стрзаменить(a,"","ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	МегаЛогист_ПреобразованиеУлицДляПоиска.Наименование
		|ИЗ
		|	Справочник.МегаЛогист_ПреобразованиеУлицДляПоиска КАК МегаЛогист_ПреобразованиеУлицДляПоиска");goto ~925;~924:if _b=-1 then goto ~919;endif;goto ~922;~925:;~926:_b=0;if 0<0 then goto ~928;endif;goto ~931;~927:_b=0;~928:if _b=1 then goto ~933;endif;goto ~929;~929:;~930:a=стрзаменить(a,",","")
;goto ~936;~931:if -1>=0 then goto ~935;endif;goto ~932;~932:goto ~930;~933:;~934:a=стрзаменить(a,"с","");goto ~936;~935:goto ~930;~936:;~937:_b=1;if 0=1 then goto ~939;endif;goto ~941;~938:a=стрзаменить(a,"VBScript.RegExp","с");goto ~942;~939:;~940:a=стрзаменить(a,"№","");goto ~942;~941:goto ~940;~942:;~943:if -1<=1 then goto ~949;endif;goto ~945;if _b=1 then goto ~964;endif;goto ~961;if _b=1 then goto ~950;endif;goto ~946;~944:;~945:_b=-1;if 1=0 then goto ~953;endif;goto ~963;
~946:;~947:a=стрзаменить(a,"дом","");goto ~966;~948:goto ~966;~949:if 0=1 then goto ~954;endif;goto ~958;if _b=-1 then goto ~965;endif;goto ~955;~950:;~951:;~952:goto ~943;~953:goto ~960;~954:if 1>-1 then goto ~944;endif;goto ~959;~955:goto ~943;~956:goto ~947;~957:;~958:if -2>-2 then goto ~951;endif;goto ~956;~959:;~960:a=стрзаменить(a,"Строка","Широта");goto ~966;~961:if _b=-1 then goto ~957;endif;goto ~952;~962:goto ~966;~963:goto ~966;~964:if _b=1 then goto ~962;endif;goto ~948;~965:
;~966:;~967:_b=-1;~968:_b=0;~969:_b=0;goto ~970;~970:a=стрзаменить(a,"г.","");goto ~972;~971:a=стрзаменить(a,"г.","");goto ~972;~972:;~973:if 1>=0 then goto ~981;endif;goto ~980;if _b=-1 then goto ~974;endif;goto ~977;~974:;~975:a=стрзаменить(a,"  "," ");goto ~982;~976:goto ~978;~977:;~978:a=стрзаменить(a,"   "," ");goto ~982;~979:goto ~975;~980:_b=1;~981:if -1=1 then goto ~976;endif;goto ~979;~982:;~983:if -2<=-2 then goto ~995;endif;goto ~1004;if
 _b=0 then goto ~985;endif;goto ~990;if _b=1 then goto ~986;endif;goto ~1000;~984:goto ~1006;~985:_b=0;~986:;~987:goto ~1006;~988:if _b=0 then goto ~998;endif;goto ~992;~989:if _b=-1 then goto ~999;endif;goto ~984;~990:if _b=-1 then goto ~994;endif;goto ~991;~991:;~992:goto ~1008;~993:;~994:;~995:if -1>=0 then goto ~989;endif;goto ~996;if -1<>0 then goto ~993;endif;goto ~1002;~996:if 1<=-1 then goto ~1007;endif;goto ~987;~997:;~998:goto ~1006;~999:;~1000:;~1001:a=стрзаменить(a,"Структура"," ");goto ~1008;
~1002:;~1003:_b=1;~1004:if 0=-1 then goto ~988;endif;goto ~1003;if _b=-1 then goto ~997;endif;goto ~1005;~1005:;~1006:a=стрзаменить(a,"   "," ");goto ~1008;~1007:goto ~1008;~1008:;~1009:_b=-1;if _b=-1 then goto ~1011;endif;goto ~1012;~1010:a=стрзаменить(a,"([0-9]+-[а-я]+)","VBScript.RegExp");goto ~1014;~1011:goto ~1013;~1012:;~1013:a=стрзаменить(a,"    "," ");goto ~1014;~1014:;~1015:if -2=-2 then goto ~1022;endif;goto ~1025;~1016:_b=1;if 0=1 then goto ~1021;endif;goto ~1017;~1017:;~1018:a=стрзаменить(a,"     "," ")
;goto ~1026;~1019:;~1020:a=стрзаменить(a,"mapTools","КАД ");goto ~1026;~1021:;~1022:_b=1;~1023:_b=1;goto ~1018;~1024:goto ~1015;~1025:_b=1;if _b=0 then goto ~1019;endif;goto ~1024;~1026:;~1027:_b=0;~1028:_b=1;goto ~1029;~1029:a=стрзаменить(a,"      "," ");goto ~1031;~1030:a=стрзаменить(a," "," ");goto ~1031;~1031:;~1032:_b=0;~1033:_b=0;goto ~1034;~1034:возврат сокрлп(a);goto ~1036;~1035:возврат сокрлп(a);goto ~1036;~1036:;конецфункции  ~0:a___=-1;~1:a___=1;goto ~2;~2:соответствиеметок=новый соответствие
;goto ~4;~3:соответствиеметок=новый массив;goto ~4;~4:;~5:if -1<=0 then goto ~15;endif;goto ~8;if a___=0 then goto ~25;endif;goto ~20;~6:a___=0;~7:goto ~13;~8:if a___=0 then goto ~22;endif;goto ~10;if a___=1 then goto ~7;endif;goto ~28;~9:;~10:if 1<>-1 then goto ~29;endif;goto ~16;~11:goto ~5;~12:;~13:соответствиеметокадресам=новый списокзначений;goto ~31;~14:goto ~30;~15:if -1>1 then goto ~24;endif;goto ~23;if a___=0 then goto ~19;endif;goto ~14;~16:;~17:;~18:goto ~5;~19:goto ~5;~20:a___=0;~21:;~22:if a___=-1
 then goto ~11;endif;goto ~18;~23:if 0=0 then goto ~26;endif;goto ~17;~24:if a___=1 then goto ~9;endif;goto ~12;~25:if 1>0 then goto ~21;endif;goto ~27;~26:goto ~30;~27:;~28:goto ~31;~29:;~30:соответствиеметокадресам=новый соответствие;goto ~31;~31:;~32:if 0<=1 then goto ~39;endif;goto ~53;if a___=-1 then goto ~49;endif;goto ~42;if a___=-1 then goto ~48;endif;goto ~38;~33:;~34:соответствиеметок.вставить(1,"twirl#whiteStretchyIcon");goto ~54;~35:goto ~32;~36:;~37:соответствиеметок.закрыть(2,"twirl#whiteStretchyIcon");goto ~54;~38:;~39:if
 1>0 then goto ~43;endif;goto ~52;~40:a___=-1;~41:goto ~54;~42:a___=-1;~43:if -1<=0 then goto ~46;endif;goto ~41;~44:;~45:if a___=0 then goto ~35;endif;goto ~44;~46:goto ~34;~47:;~48:goto ~34;~49:if a___=1 then goto ~33;endif;goto ~51;~50:a___=0;~51:;~52:a___=0;~53:if a___=-1 then goto ~45;endif;goto ~50;if a___=-1 then goto ~36;endif;goto ~47;~54:;~55:if 1=-1 then goto ~56;endif;goto ~63;if a___=1 then goto ~59;endif;goto ~57;~56:a___=-1;~57:;~58:соответствиеметок.вставить(2,"twirl#violetStretchyIcon");goto ~64;~59:
;~60:goto ~58;~61:;~62:соответствиеметок.сокращение(2,",");goto ~64;~63:if 0=1 then goto ~61;endif;goto ~60;~64:;~65:a___=0;if 0<>0 then goto ~69;endif;goto ~66;if a___=0 then goto ~67;endif;goto ~70;~66:a___=1;goto ~68;~67:;~68:соответствиеметок.вставить(3,"twirl#yellowStretchyIcon");goto ~72;~69:a___=0;~70:;~71:соответствиеметок.прав(3,"VBScript.RegExp");goto ~72;~72:;~73:if 0<>0 then goto ~75;endif;goto ~79;if -1>=0 then goto ~82;endif;goto ~77;~74:goto ~78;~75:if -1>1 then goto ~74;endif;goto ~76;
~76:goto ~78;~77:;~78:соответствиеметок.минимальнаяширота(5,".");goto ~84;~79:if -1>1 then goto ~81;endif;goto ~80;~80:goto ~83;~81:;~82:;~83:соответствиеметок.вставить(4,"twirl#redStretchyIcon");goto ~84;~84:;~85:a___=1;if a___=1 then goto ~89;endif;goto ~87;~86:соответствиеметок.сообщить(5,"zoomControl");goto ~90;~87:;~88:соответствиеметок.вставить(5,"twirl#greenStretchyIcon");goto ~90;~89:goto ~88;~90:;~91:if -1>0 then goto ~100;endif;goto ~93;~92:a___=1;if a___=1 then goto ~97;endif;goto ~96;~93:if
 -1<1 then goto ~94;endif;goto ~99;if 0=1 then goto ~95;endif;goto ~104;~94:a___=1;goto ~103;~95:;~96:goto ~91;~97:;~98:соответствиеметок.вставить(5,"twirl#blueStretchyIcon");goto ~106;~99:if a___=0 then goto ~102;endif;goto ~105;~100:a___=-1;~101:a___=-1;~102:;~103:соответствиеметок.вставить(6,"twirl#blueStretchyIcon");goto ~106;~104:goto ~91;~105:;~106:;~107:if 1=0 then goto ~116;endif;goto ~110;~108:a___=0;if a___=-1 then goto ~109;endif;goto ~121;~109:goto ~123;~110:if 1>-1 then goto ~113;endif;goto ~112;if -1<>0 then goto ~118;
endif;goto ~114;~111:;~112:a___=0;~113:if 1>0 then goto ~115;endif;goto ~119;~114:;~115:goto ~120;~116:a___=0;if 0<=1 then goto ~111;endif;goto ~117;~117:;~118:goto ~120;~119:;~120:соответствиекартинокметок=новый соответствие;goto ~123;~121:;~122:соответствиекартинокметок=новый списокзначений;goto ~123;~123:;~124:if 0=-1 then goto ~127;endif;goto ~140;if a___=0 then goto ~135;endif;goto ~132;~125:a___=1;~126:goto ~124;~127:a___=0;~128:a___=0;~129:if 0>1 then goto ~126;endif;goto ~136;~130:if -1>1 then goto ~141;endif;
goto ~131;~131:;~132:a___=-1;~133:goto ~139;~134:goto ~142;~135:if -1>0 then goto ~138;endif;goto ~133;~136:goto ~139;~137:;~138:;~139:a=новый запрос;goto ~143;~140:if -1>0 then goto ~130;endif;goto ~129;if 1<>0 then goto ~134;endif;goto ~137;~141:;~142:a=новый массив;goto ~143;~143:;~144:if 0=1 then goto ~157;endif;goto ~161;if a___=-1 then goto ~148;endif;goto ~154;~145:a___=0;~146:if 0=0 then goto ~165;endif;goto ~149;~147:goto ~150;~148:if a___=1 then goto ~147;endif;goto ~151;~149:;~150:a.текст="ВЫБРАТЬ ПЕРВЫЕ 1
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.ПоУмолчанию = Истина";
goto ~166;~151:goto ~156;~152:goto ~150;~153:goto ~166;~154:a___=1;~155:;~156:a.submatches="Широта";goto ~166;~157:if -1<>0 then goto ~162;endif;goto ~159;if a___=0 then goto ~164;endif;goto ~155;~158:goto ~166;~159:if a___=1 then goto ~163;endif;goto ~153;~160:a___=-1;~161:if -1=1 then goto ~160;endif;goto ~146;if a___=0 then goto ~152;endif;goto ~158;~162:a___=0;~163:goto ~150;~164:goto ~156;~165:goto ~150;~166:;~167:if 1<>0 then goto ~177;endif;goto ~176;if 1>-1 then goto ~172;endif;goto ~173;~168:;~169:
;~170:a_=a.выполнить().выбрать();goto ~178;~171:goto ~174;~172:;~173:;~174:a_=a.широта().выбрать();goto ~178;~175:goto ~170;~176:if 0>=0 then goto ~168;endif;goto ~171;~177:if -1<=0 then goto ~175;endif;goto ~169;~178:;while a_.следующий() do ~179:a___=1;if a___=-1 then goto ~181;endif;goto ~180;~180:goto ~182;~181:;~182:соответствиекартинокметок.вставить(0,a_.маркер);goto ~184;~183:соответствиекартинокметок.сообщить(1,a_.matches);goto ~184;~184:;enddo;~185:a___=1;~186:a___=1;goto ~187;~187:a.текст="ВЫБРАТЬ
             |	МегаЛогист_Маркеры.Ссылка КАК Маркер
             |ИЗ
             |	Справочник.МегаЛогист_Маркеры КАК МегаЛогист_Маркеры
             |ГДЕ
             |	МегаЛогист_Маркеры.Активный = Истина
             |
             |УПОРЯДОЧИТЬ ПО
             |	МегаЛогист_Маркеры.Наименование"
;goto ~189;~188:a.geoobjectdraggable="Долгота";goto ~189;~189:;~190:a___=0;if a___=0 then goto ~192;endif;goto ~193;~191:a_=a.выполнить().выбрать();goto ~195;~192:goto ~191;~193:;~194:a_=a.знчточка().наименование();goto ~195;~195:;~196:if 1<0 then goto ~198;endif;goto ~197;if -2=-2 then goto ~204;endif;goto ~200;~197:if 1=0 then goto ~205;endif;goto ~199;~198:if a___=-1 then goto ~201;endif;goto ~203;~199:goto ~206;~200:goto ~196;~201:;~202:a__=0;goto ~207;~203:goto ~202;~204:goto ~207;~205:;~206:
a__=0;goto ~207;~207:;while a_.следующий() do ~208:a___=-1;if a___=0 then goto ~214;endif;goto ~211;if a___=0 then goto ~212;endif;goto ~209;~209:;~210:a__=a__+1;goto ~215;~211:a___=-1;goto ~213;~212:;~213:a__=a__+1;goto ~215;~214:a___=1;~215:;~216:a___=0;~217:a___=0;goto ~218;~218:соответствиекартинокметок.вставить(a__,a_.маркер);goto ~220;~219:соответствиекартинокметок.стрзаменить(a__,a_.replace);goto ~220;~220:;enddo;