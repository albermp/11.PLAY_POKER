package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent; 	// ojo VERSION BETA
	import flash.ui.Keyboard; 			// ojo VERSION BETA
	import flash.text.*;	
	import flash.display.*;
	public class ScreenInitializing extends ScreenBase {
		//**************************************************************************************************************************************************
		
		public static const stateEnd			  		 	 	= 0;
		public static const stateError					 	 	= 1;
		public static const stateGettingIdMaquina  		 	 	= 2;
		public static const stateGettingIdMaquina_MANUAL 	 	= 3; 
		public static const stateGettingPowerFail_BD  	 	 	= 4;
		public static const stateCheckingPowerFail_BD	 	 	= 5;
		public static const stateCheckingPowerFail_BD_insert    = 6;
		public static const stateCheckingPowerFail_BD_inserting = 7;
		public static const stateGettingPowerFail_FS	 	 	= 8;	
		public static const stateCheckingPowerFail_FS	 	 	= 9;
		public static const stateGettingPowerFail_FL	 	 	= 10;	
		public static const statePreparingPowerFail		 	 	= 11;
		public static const recuperar_datos_connecting		 	= 12;
		/*
		public static const recuperar_creditos_IN_pendientes = 10
		public static const statePreparingGettingCredits 	 = 11;
		public static const stateGettingCredits			 	 = 12;
		public static const	statePrepareInsertCredits	 	 = 13;
		public static const	stateInsertingCredits		 	 = 14;	
		public static const statePreparingGettingJackPot 	 = 15;
		public static const stateGettingJackPot			 	 = 16;
		public static const	statePrepareInsertJackPot	 	 = 17;
		public static const	stateInsertingJackPot		 	 = 18;	
		public static const	statePrepareUpdateJackPot	 	 = 19;
		public static const	stateUpdatingJackPot  		 	 = 20;
		*/

		private var stateScreenInitializing:int;
		private var gc:GameControl;
		
		//private var omib:ObtenerMovimientos_IN_browser;
		private var rdc:RecuperaDatosConnecting;
		
		private var backGroundBase:mc_backGroundBase;
		private var backGroundConnecting:mc_Background_Connecting;
		private var label_connecting:mc_label_connecting;
		public  var animationConnecting:AnimationConnecting;
		
		private var textFieldIdMaquina:TextField;	  		// version BETA
		private var labelTextFieldIdMaquina:TextField;	  	// version BETA
		private var idMaquina_introduced:Boolean;	  		// version BETA
		private var tipoEjecucion:int;						// version BETA
		private var stringNombreMaquina:String;				// version BETA
		
		// variables auxiliares.
		private var contWaitToExecuteAnimation:int;
		private var contTimeOut:int;
		private var timeSecurityLoader:int;
		private var timeMaxSecurityLoader:int = 30;
		private var timeIncSecurity:int = 1;																
		
		private var nameFile:String; 
		private var i,j:int;
		private var tPowerFail:Array;
		private var hayPowerFail:Boolean;
		private var cambiarValorJackpot_BD:Boolean;
		//**************************************************************************************************************************************************
		public function ScreenInitializing(gControl:GameControl) {
			
			gc =  gControl;			
			
		}
		//**************************************************************************************************************************************************
		public override function init():void{
			
			initParamTipoEjecucion();			
			
			// Se pasarán valores desde fuera a traves del parametro <flashvar>.
			gc.initializeCliente(getParamCliente());
			gc.initializeIdSessionGameWeb(getParamIdSessionGameWeb());
			gc.initializeRegionHoraria(getZonaHoraria(gc.gameData.cliente));
			gc.initializeTablaIdiomas(getTablaIdioma(gc.gameData.cliente));
			gc.initializeTablaListaIdiomas(getTablaListaIdiomas(gc.gameData.cliente));
			gc.initializeTablaFramesImagenMoneda(getTablaFramesImagenMoneda(gc.gameData.cliente));
			gc.initializeTablaValoresMoneda(getTablaValoresMoneda(gc.gameData.cliente));			
			gc.initializeIdioma(getParamIdioma());			
			
			//-------------------------------------------------------------------------
			// Obtenemos el pack de parametros que nos enviaran desde el browser de SMI
			if (c.contenedorFlash == c.BROWSER_SMI){
				gc.gameData.multiJuego_SMI 			= getParamMultiJuego();
				gc.gameData.displayAspectRatio_SMI 	= getParamDisplayAspectRatio();
				gc.gameData.tipoMaquina_SMI 		= getParamTipoMaquina();
			}
			//-------------------------------------------------------------------------
			
			gc.initializeGame_2();
			
			backGroundBase = Create.createBackGroundBase(gc);        	   
			gc.stage.addChild(backGroundBase);
			
			// creamos y colocamos el fondo de la pantalla
			backGroundConnecting = new mc_Background_Connecting();
			backGroundConnecting.x = -gc.stage.stageWidth   * .5;
			backGroundConnecting.y = -gc.stage.stageHeight  * .5;
			backGroundBase.addChild(backGroundConnecting);
			
			// Creamos y ponemos el label "connecting..."
			label_connecting = new mc_label_connecting();
			label_connecting.x = gc.stage.stageWidth * .5;
			label_connecting.y = 500;
			backGroundConnecting.addChild(label_connecting);
			
			// Animacion de monedas izquierda - derecha, mientras realiza las acciones.
			animationConnecting = new AnimationConnecting();
			animationConnecting.init(backGroundConnecting,300,620,350);
			
			
			
			//--- Version BETA - FIN ----			
			if (c.getIdMaquinaManual){
				var f:TextFormat = new TextFormat();
				f.color = 0xFFFFFF;
				f.size = 24;
				f.bold = true;
				f.align = TextFormatAlign.CENTER;
				f.font = "Courier";
	
				var f1:TextFormat = new TextFormat();
				f1.color = 0xFFFFFF;
				f1.size = 24;
				f1.bold = true;
				f1.align = TextFormatAlign.CENTER;
			
				labelTextFieldIdMaquina = new TextField();
				labelTextFieldIdMaquina.defaultTextFormat = f1;
				labelTextFieldIdMaquina.width  = 500;
				labelTextFieldIdMaquina.height = 34;
				labelTextFieldIdMaquina.x = (backGroundConnecting.width * .5) - (labelTextFieldIdMaquina.width * .5);
				labelTextFieldIdMaquina.y = 260;
				labelTextFieldIdMaquina.autoSize = TextFieldAutoSize.NONE;
				labelTextFieldIdMaquina.background = false;
				labelTextFieldIdMaquina.textColor		= 0x000000;
				labelTextFieldIdMaquina.text = "Introduzca credenciales y pulse ENTER";
				labelTextFieldIdMaquina.multiline = false;
				labelTextFieldIdMaquina.selectable = false;	
				backGroundConnecting.addChild(labelTextFieldIdMaquina);
				
				textFieldIdMaquina = new TextField();
				textFieldIdMaquina.defaultTextFormat = f;
				textFieldIdMaquina.width  = 520;
				textFieldIdMaquina.height = 26;			
				textFieldIdMaquina.x = (backGroundConnecting.width * .5) - (textFieldIdMaquina.width * .5);
				textFieldIdMaquina.y = 300;
				textFieldIdMaquina.type=TextFieldType.INPUT; //to enable the textbox
				textFieldIdMaquina.autoSize = TextFieldAutoSize.NONE;
				textFieldIdMaquina.background = true;
				textFieldIdMaquina.backgroundColor	=  0xFFE923; //0xFFFFFF;
				textFieldIdMaquina.textColor		=  0x0026FF; //0x000000;
				textFieldIdMaquina.text = c.maquinaInicial;
				textFieldIdMaquina.multiline = false;
				textFieldIdMaquina.selectable = true;	
				backGroundConnecting.addChild(textFieldIdMaquina);				
				idMaquina_introduced = false;
				backGroundConnecting.addEventListener(KeyboardEvent.KEY_DOWN, keyDownFunction);
			}
			//--- Version BETA - FIN ----

			// posicion 0: base de datos
			// posicion 1: fichero en servidor
			// posicion 2: fichero en local shared object.
			// para cada posicion se guarda, hay_powerFail, timeStamp, isPowerFail, cadenaDatos y Creditos
			tPowerFail = [[false,null,null,null,null],[false,null,null,null,null],[false,null,null,null,null]];
			
			contWaitToExecuteAnimation = 0;
			
			switchStateInitializing(ScreenInitializing.stateGettingIdMaquina);
		}
		//**************************************************************************************************************************************************
		public override function run():void{
			
			// Esperamos unos instantes antes de mostrar la animacion de las monedas	
			contWaitToExecuteAnimation ++;
			if ((contWaitToExecuteAnimation > 180)){
				animationConnecting.setVisible(true);
			}
			
			// Animacion de monedas moviendose en horizontal mientras realizamos las acciones.
			animationConnecting.updateAnimation();
			
			switch(stateScreenInitializing){
				//************************************************************************************************************************************************
				case ScreenInitializing.stateError:
					break;
				//************************************************************************************************************************************************
				//***************************** GET idMaquina ***** (Parte I) ************************************************************************************
				//************************************************************************************************************************************************
				
				case ScreenInitializing.stateGettingIdMaquina:			
					//recuperamos el identificador del terminal que está ejecutando el juego.
					//var paramObj:Object = LoaderInfo(gc.root.loaderInfo).parameters; //si el swf está integrado en el html
					//var paramObj:Object = LoaderInfo(gc.root.parent.loaderInfo).parameters; // si el swf está encima de otro swf (pantala pre-loading, por ejemplo)
					var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters; // si el swf está encima de otro swf (pantala pre-loading, por ejemplo)
					
					// Recuperamos el idMaquina del <flashvars>
					var stringIdMaquina:String = String(paramObj["idMaquina"]);
					gc.gameData.idMaquina = stringIdMaquina;

					/*
					// Recuperamos el idioma con que queremos que se cargue el juego inicialmente del <flashvars>
					// En caso de que no nos pasen esta información, se iniciará con el idioma por defecto que se haya definido en el programa (GameData)
					// 1: Portugués
					// 4: Frances
					var stringIdioma:String = String(paramObj["idioma"]);
					if ((paramObj["idioma"]!=null) && (paramObj["idioma"]!=undefined)){
						gc.gameData.idioma = int(stringIdioma);
					}
					*/

					
					// Recuperamos el path menu, opcion utilizada cuando salgamos del juego con un navegador normal, sin utilizar el browser
					// por tanto, esta variable de flashvar a veces estará informada y a veces no.
					var stringPathMenu:String = "";
					if ((paramObj["pathMenu"]!=null) && (paramObj["pathMenu"]!=undefined))
						stringPathMenu = String(paramObj["pathMenu"]);
						
					gc.gameData.pathMenu = stringPathMenu;

					if (c.getIdMaquinaManual){
						switchStateInitializing(ScreenInitializing.stateGettingIdMaquina_MANUAL); 
					}else{
						if (validarIdMaquina(stringIdMaquina)){
							// Inicializamos el proces que refrescará la tabla Machines (LastPing), cada cierto tiempo, el timestamp actual.
							gc.rtsp.init(stringIdMaquina, gc.gameData.IdSessionGameWeb);
							//------------------------------------------------------------------------------------------ 
							// Inicializamos el proceso que consulta en cada momento si la maquina está bloqueada o no
							// Y envia una notificacion al browser en caso de que esté bloqueada
							switch(c.contenedorFlash){
								case c.BROWSER_LUCKHAND: 	gc.vmb.init(gc.gameData.idMaquina);   break;
								case c.BROWSER_SMI:			break;
								case c.MICROSOFT_EXPLORER:	break;
								case c.BROWSER_WEB:			break;
								default:					break;
							}
							//------------------------------------------------------------------------------------------ 
							
							switchStateInitializing(ScreenInitializing.stateGettingPowerFail_BD);
						}else
							switchStateInitializing(ScreenInitializing.stateError);
					}
					break;
				//************************************************************************************************************************************************
				// Introducimos el idMaquina manualmente
				case ScreenInitializing.stateGettingIdMaquina_MANUAL:
					if (idMaquina_introduced){
						idMaquina_introduced = false;
						if (validarIdMaquina(textFieldIdMaquina.text)){
							gc.gameData.idMaquina = textFieldIdMaquina.text;
							
							// Inicializamos el proces que refrescará la tabla Machines (LastPing), cada cierto tiempo, el timestamp actual.
							gc.rtsp.init(gc.gameData.idMaquina,gc.gameData.IdSessionGameWeb);
							//------------------------------------------------------------------------------------------ 
							// Inicializamos el proceso que consulta en cada momento si la maquina está bloqueada o no
							// Y envia una notificacion al browser en caso de que esté bloqueada
							switch(c.contenedorFlash){
								case c.BROWSER_LUCKHAND: 	gc.vmb.init(gc.gameData.idMaquina);   break;
								case c.BROWSER_SMI:			break;
								case c.MICROSOFT_EXPLORER:	break;
								case c.BROWSER_WEB:			break;
								default:					break;
							}
							//------------------------------------------------------------------------------------------ 
							
							gc.gameData.pathMenu = "=../index.php";
							switchStateInitializing(ScreenInitializing.stateGettingPowerFail_BD);
						}
					}
					break;				
				//************************************************************************************************************************************************
				//***************************** POWER FAIL (DataBase MYSQL) **************************************************************************************
				//************************************************************************************************************************************************
				case ScreenInitializing.stateGettingPowerFail_BD:					
					// Accedemos a la tabla PowerFail para validar si tiene tiene algún registro de resposicionamiento de la partida anterior.
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.powerFail_SQL.executeSelect(gc.gameData.idMaquina,gc.gameData.idJuego);
					switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD);
					break;						
				//************************************************************************************************************************************************
				case ScreenInitializing.stateCheckingPowerFail_BD:					
					contTimeOut ++;
					if(gc.powerFail_SQL.isAccessCompleted()){
						if (gc.powerFail_SQL.getStateResult() == PowerFailMySQL.RESULT_OK){
							if (gc.powerFail_SQL.isRegFound()){ // si encontramos registro.
								tPowerFail[0][1] = gc.powerFail_SQL.getTimeStamp();
								tPowerFail[0][2] = gc.powerFail_SQL.getIsPowerFail();
								tPowerFail[0][3] = gc.powerFail_SQL.getCadenaDatos();
								tPowerFail[0][4] = gc.powerFail_SQL.getCreditos();								
								switchStateInitializing(ScreenInitializing.stateGettingPowerFail_FS);
							}else{ 
								switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD_insert);
							}
						}else{
							switchStateInitializing(ScreenInitializing.stateGettingPowerFail_BD);
						}
					}else if (gc.powerFail_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.stateGettingPowerFail_BD);
					}else if (contTimeOut > timeSecurityLoader){
						gc.powerFail_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.stateGettingPowerFail_BD);
					}else if (gc.powerFail_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateCheckingPowerFail_BD_insert:					
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.powerFail_SQL.executeInsert(gc.gameData.idMaquina,gc.gameData.idJuego,Generic.getTimeStamp(0), false,"",-1);	
					switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD_inserting);
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateCheckingPowerFail_BD_inserting:					
					contTimeOut ++;
					if(gc.powerFail_SQL.isAccessCompleted()){
						if (gc.powerFail_SQL.getStateResult() == PowerFailMySQL.RESULT_OK){
							switchStateInitializing(ScreenInitializing.stateGettingPowerFail_FS);
						}else{
							switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD_insert);
						}
					}else if (gc.powerFail_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD_insert);
					}else if (contTimeOut > timeSecurityLoader){
						gc.powerFail_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_BD_insert);
					}else if (gc.powerFail_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;			
				//************************************************************************************************************************************************
				//***************************** POWER FAIL (FILE SERVER) *****************************************************************************************
				//************************************************************************************************************************************************
				// Recuperar la información powerFail del fichero del servidor
				case ScreenInitializing.stateGettingPowerFail_FS:
					contTimeOut = 0;
					nameFile = gc.cfs.createNameFile(gc.gameData.idMaquina, gc.gameData.idJuego);
					gc.cfs.readFile(nameFile);
					switchStateInitializing(ScreenInitializing.stateCheckingPowerFail_FS);
					break;
				//************************************************************************************************************************************************					
				// Validamos la información powerFail recuperada del fichero del servidor
				case ScreenInitializing.stateCheckingPowerFail_FS:					
					contTimeOut ++;
					if(gc.cfs.isAccessCompleted()){
						if (gc.cfs.getStateResult() == ControlFileServerPowerFail.RESULT_OK){
							if (gc.cfs.isRegFound()){
								tPowerFail[1][1] = gc.cfs.getTimeStamp();
								tPowerFail[1][2] = gc.cfs.getIsPowerFail();
								tPowerFail[1][3] = gc.cfs.getCadenaDatos();
								tPowerFail[1][4] = gc.cfs.getCreditos();
							}
						}else{
							gc.cfs.readFile(nameFile);
						}
						switchStateInitializing(ScreenInitializing.stateGettingPowerFail_FL);
					}else if (contTimeOut > timeMaxSecurityLoader){
						switchStateInitializing(ScreenInitializing.stateGettingPowerFail_FS);
					}
					break;

				//************************************************************************************************************************************************
				//***************************** POWER FAIL (FILE LOCAL - Shared Object) **************************************************************************
				//************************************************************************************************************************************************
				// Recuperar la información powerFail del fichero del shared object Local
				case ScreenInitializing.stateGettingPowerFail_FL:
				
					// La versión BROWSER_WEB no recupera el power fail local
					if (!c.ignorarPowerFailLocal){																								
						gc.cfl.readData(gc.gameData.idMaquina,gc.gameData.idJuego);
						if (gc.cfl.isDataFound()){
							tPowerFail[2][1] = gc.cfl.getTimeStamp();
							tPowerFail[2][2] = gc.cfl.getIsPowerFail();
							tPowerFail[2][3] = gc.cfl.getCadenaDatos();
							tPowerFail[2][4] = gc.cfl.getCreditos();
						}
					}
					
					switchStateInitializing(ScreenInitializing.statePreparingPowerFail);
					
					break;
				//************************************************************************************************************************************************
				//***************************** BUILD POWER FAIL OBJECT ******************************************************************************************
				//************************************************************************************************************************************************
				case ScreenInitializing.statePreparingPowerFail:
					
					//para anular el power fail OJO -ini-
					if (c.ignorarPowerFail){ // ignoramos todo el powerFail que pueda existir tanto en la base de dastos, en el fichero del servidor, como en local.
						tPowerFail = [[false,null,null,null,null],[false,null,null,null,null],[false,null,null,null,null]]; 
					}
					if (c.ignorarPowerFailLocal){ // Anulamos el power fail solo de local
						tPowerFail[2][0] = false;
						tPowerFail[2][1] = null;
						tPowerFail[2][2] = null;
						tPowerFail[2][3] = null;	
						tPowerFail[2][4] = null;	
					}
					//para anular o no el power fail OJO -fin-
					
					
					// Repsasamos la tabla y activamos la primera posición en las fillas que se haya encontrado información
					// Fila 0: PowerFail obtenido de MySql
					// Fila 1: PowerFail obtenido de File server
					// Fila 2: PowerFail obtenido de shared object
					for(i=0;i<tPowerFail.length;i++){
						if ((tPowerFail[i][1] != null) && (tPowerFail[i][2] != null) && (tPowerFail[i][3] != null)){
							tPowerFail[i][0] = true;
						}
						//trace (tPowerFail[i][0],tPowerFail[i][1],tPowerFail[i][2],tPowerFail[i][3]);
					}
					//Seleccionamos el power fail más reciente segun el timeStamp.
					// en caso de igualdad el orden de prioriedad será: MySql (0), file server (1) y shared object (2)
					var selec:int=-1; // este indice almacenará el powerFail escogido: 0: MySql, 1: file server, 2: Shared Object
					for(i=tPowerFail.length-1;i>=0;i--){
						if (tPowerFail[i][0]){
							selec = i;
							for(j=i+1;j<tPowerFail.length;j++){
								if ((tPowerFail[j][0]) && ((tPowerFail[j][1]) > (tPowerFail[i][1]))){
									selec = j;
								}
							}
						}
						
					}
					var timeStampPowerFail_selec:Number = 0;
					var isPowerFail_selec:Boolean 		= false;
					var cadenaPowerFail_selec:String  	= "";
					var credits_selec:int  				= -1;
					if (selec != -1){
						timeStampPowerFail_selec = tPowerFail[selec][1];
						isPowerFail_selec 		 = tPowerFail[selec][2];
						cadenaPowerFail_selec 	 = tPowerFail[selec][3];
						credits_selec 			 = tPowerFail[selec][4];
					}
					//trace(selec);
					
					// creamos el objeto power fail que hemos obtenido 
					gc.powerFail.setCadena(cadenaPowerFail_selec); 
					gc.powerFail.setHayReposicion(isPowerFail_selec);
					gc.powerFail.setCreditos(credits_selec);
					
					if (gc.powerFail.reposicionar()){
						gc.powerFail.decodificar();
					}
					
					//==============================
					// NO hay powerFail pendiente
					//==============================
					if (!gc.powerFail.reposicionar()){
						hayPowerFail = false;
						/*
						switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);					
						*/
					//==============================
					// SI hay powerFail pendiente 
					//==============================
					}else{
						hayPowerFail = true;
						/*
						omib = new ObtenerMovimientos_IN_browser();
						omib.init(gc.gameData.idMaquina,timeStampPowerFail_selec);
						switchStateInitializing(ScreenInitializing.recuperar_creditos_IN_pendientes);						
						*/
					}
					rdc	 = new RecuperaDatosConnecting();
					rdc.init(gc.gameData.idMaquina,gc.gameData.idJuego,timeStampPowerFail_selec);
					switchStateInitializing(ScreenInitializing.recuperar_datos_connecting);							
					break;
				//************************************************************************************************************************************************	
				//             RECUPERAMOS
				//                - Posible cantidad de creditos que han podido ser introducidos en el browser mientras había un powerfail en un juego.
				//                - Creditos Actuales (User_Credit)
				//                - Valores actuales de la tabla jackpot (Jackpot_Slot)
				//************************************************************************************************************************************************	
				case ScreenInitializing.recuperar_datos_connecting:	
					rdc.run();
					if (rdc.finalizado()){
						gc.gameData.creditos_in_browser 	= rdc.getCantidadMovIN();
						if (!hayPowerFail){
							gc.gameData.creditos_in_browser = 0;
							gc.gameData.credits				= rdc.getCreditos(); 
							gc.gameData.jackpotAcumulated 	= rdc.getActualJackpot();
						}
						
						gc.gameData.apuestaMinima		= rdc.getAp_Minimum();
						gc.gameData.incremetoJackpot	= rdc.getIncrease();
						gc.gameData.valorJackpotMaximo	= rdc.getMaximum();
						gc.gameData.valorJackpotInicial	= rdc.getInitial();
						
						// Obtenemos el literal que pondremos al lado del valor del jackpot actual (#, CPL, etc..)
						var	lit_moneda_jackpot_aux:String	= rdc.getLiteralMonedaJackpot();
						
						// CARLOS
						if (lit_moneda_jackpot_aux != null) {
							if (lit_moneda_jackpot_aux.length > 1) 
								gc.gameData.literal_moneda_jackpot = " " + lit_moneda_jackpot_aux;
							else
								gc.gameData.literal_moneda_jackpot = lit_moneda_jackpot_aux;
						} else {
							gc.gameData.literal_moneda_jackpot = "";
						}
						//-------
						
						if (rdc.getTimeStampServer() > 0){
							var timeStamp_pc:Number         = Generic.getTimeStamp(0);
							gc.gameData.dif_timeStampServer = rdc.getTimeStampServer() - timeStamp_pc;
						}else{
							gc.gameData.dif_timeStampServer = 0;
						}
						
						gc.gameData.nameMachine		    = rdc.getNameMachine();
						
						// Obtenemos el valor en céntimos de un credito según el tipo de moneda del país (EURO [1 Credito -> 1 Centimo], PESO [1 Credito -> 1000 Centimos])
						gc.gameData.valor_centimos_de_un_credito = rdc.getValorCentimosDeUnCredito();
						
						// Ya hemos recopilados todos lo datos necesario para inicializar el juego. Ya podemos pasar a la pantalla del juego.							  
						switchStateInitializing(ScreenInitializing.stateEnd);
					}
					break;
				/*	
				//===== modificacion 15/05/2017   (ini) ==	
				//************************************************************************************************************************************************
				//************* Recuperamos creditos que hayan podidos ser insertado en el browser  mientras habia un powerfail en el juego  *********************
				//************************************************************************************************************************************************					
				case ScreenInitializing.recuperar_creditos_IN_pendientes:
					omib.run();
					if (omib.estaFinalizado()){
						gc.gameData.creditos_in_browser = omib.get_cantidad_IN();
						switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);					
					}
					break;

				//************************************************************************************************************************************************
				//***************************** GETTING CREDITS MAQUINA **** (Parte II) **************************************************************************
				//************************************************************************************************************************************************
				case ScreenInitializing.statePreparingGettingCredits:
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.userCredits_SQL.executeSelect(gc.gameData.idMaquina);
					switchStateInitializing(ScreenInitializing.stateGettingCredits);
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateGettingCredits:
					contTimeOut ++;
					if (gc.userCredits_SQL.isAccessCompleted()){ // consulta completada	
						if (gc.userCredits_SQL.getStateResult() == UserCreditMySQL.RESULT_OK){ // la colsulta ha ido bien
							if (gc.userCredits_SQL.isRegFound()){ 	// existe registro
								if (!hayPowerFail){
									gc.gameData.credits = gc.userCredits_SQL.getCreditos();								
								}
								
								// Comprobamos si la maquina está bloqueado o no
								if (gc.userCredits_SQL.getBloqueado() == 0)
									switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);
								else
									switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);

							}else{					 			// no existe registro 
							  //switchStateInitializing(ScreenInitializing.statePrepareInsertCredits);
								switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);
							}
						}else
							switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);
					}else if (gc.userCredits_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);
					}else if (contTimeOut > timeSecurityLoader){
						gc.userCredits_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);
					}else if (gc.userCredits_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.statePrepareInsertCredits:
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.userCredits_SQL.executeInsert(gc.gameData.idMaquina,0,0,0,0,0,0); // Insertamos un registro con 0 creditos
					switchStateInitializing(ScreenInitializing.stateInsertingCredits);
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateInsertingCredits:
					contTimeOut ++;
					if (gc.userCredits_SQL.isAccessCompleted()){ // insert completed
						if (gc.userCredits_SQL.getStateResult() == UserCreditMySQL.RESULT_OK){ // el insert ha ido bien				
							switchStateInitializing(ScreenInitializing.statePreparingGettingCredits);// volvemos a cosultar los creditos.
						}else{
							switchStateInitializing(ScreenInitializing.statePrepareInsertCredits);// volvemos a insertar los creditos
						}
					}else if (gc.userCredits_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.statePrepareInsertCredits);
					}else if (contTimeOut > timeSecurityLoader){
						gc.userCredits_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.statePrepareInsertCredits);
					}else if (gc.userCredits_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;
				//************************************************************************************************************************************************
				//***************************** GETTING JACKPOT ****** (Parte III) *******************************************************************************
				//************************************************************************************************************************************************
				case ScreenInitializing.statePreparingGettingJackPot:
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.jackPot_SQL.executeSelect(gc.gameData.idMaquina);
					switchStateInitializing(ScreenInitializing.stateGettingJackPot);
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateGettingJackPot:
					contTimeOut ++;
					if (gc.jackPot_SQL.isAccessCompleted()){ // consulta completada	
						if (gc.jackPot_SQL.getStateResult() == JackpotSlotMySQL.RESULT_OK){ // la colsulta ha ido bien
							if (gc.jackPot_SQL.isRegFound()){ 	// existe registro
								cambiarValorJackpot_BD = false;
								if (!hayPowerFail){ // El jackpot solo lo recogemos de la base de datos en caso de que no vengamos de powerfail.
									gc.gameData.jackpotAcumulated 	= gc.jackPot_SQL.getActualJackpot();
									// El valor del jackpot como mínimo debe ser el que marca el campo "Initial" de la tabla, si no es así, lo modificamos
									if (gc.gameData.jackpotAcumulated < gc.jackPot_SQL.getInitial()){
										gc.gameData.jackpotAcumulated = gc.jackPot_SQL.getInitial();
										cambiarValorJackpot_BD = true; // Modificamos este booleano para indicar que tenemos que modificar este valor en la base de datos.
									}
								}
								gc.gameData.apuestaMinima		= gc.jackPot_SQL.getAp_Minimum();
								gc.gameData.incremetoJackpot	= gc.jackPot_SQL.getIncrease();
								gc.gameData.valorJackpotMaximo	= gc.jackPot_SQL.getMaximum();
								gc.gameData.valorJackpotInicial	= gc.jackPot_SQL.getInitial();
								if (cambiarValorJackpot_BD)
									switchStateInitializing(ScreenInitializing.statePrepareUpdateJackPot); // Necesitamos modificar el valor del jackpot.
								else
									switchStateInitializing(ScreenInitializing.stateEnd); // Ya se han realizado todas las acciones referentes al jackpot.
							}else{					 			// no existe registro
							  //switchStateInitializing(ScreenInitializing.statePrepareInsertJackPot);
								switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);
							}
						}else
							switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);
					}else if (gc.jackPot_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);
					}else if (contTimeOut > timeSecurityLoader){
						gc.jackPot_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);
					}else if (gc.jackPot_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.statePrepareInsertJackPot:
					// Insertamos un registro nuevo
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.jackPot_SQL.executeInsert(gc.gameData.idMaquina,	0.5,  		// Incremento jackpot
												 						1500.0,		// BreakDown
												 						0.25,		// Apuesta minima 
																		1000.0, 	// Valor jackpot inicial
																		3000.0, 	// Valor jackpot maximo
																		0.0, 
																		0.0);  		// Acumulado jackpot
					switchStateInitializing(ScreenInitializing.stateInsertingJackPot);				
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateInsertingJackPot:
					contTimeOut ++;
					if (gc.jackPot_SQL.isAccessCompleted()){ // insert completed
						if (gc.jackPot_SQL.getStateResult() == JackpotSlotMySQL.RESULT_OK){ // el insert ha ido bien				
							switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);// volvemos a cosultar el jackpot
						}else{
							switchStateInitializing(ScreenInitializing.statePrepareInsertJackPot);// volvemos a insertar el jackpot
						}
					}else if (gc.jackPot_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.statePrepareInsertJackPot);
					}else if (contTimeOut > timeSecurityLoader){
						gc.jackPot_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.statePrepareInsertJackPot);
					}else if (gc.jackPot_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.statePrepareUpdateJackPot:
					// Insertamos un registro nuevo
					contTimeOut = 0;
					timeSecurityLoader = timeMaxSecurityLoader;
					gc.jackPot_SQL.executeUpdate2(gc.gameData.idMaquina,gc.gameData.jackpotAcumulated);
					switchStateInitializing(ScreenInitializing.stateUpdatingJackPot);				
					break;
				//************************************************************************************************************************************************
				case ScreenInitializing.stateUpdatingJackPot:
					contTimeOut ++;
					if (gc.jackPot_SQL.isAccessCompleted()){ // insert completed
						if (gc.jackPot_SQL.getStateResult() == JackpotSlotMySQL.RESULT_OK){ // el insert ha ido bien				
							switchStateInitializing(ScreenInitializing.statePreparingGettingJackPot);// volvemos a cosultar el jackpot
						}else{
							switchStateInitializing(ScreenInitializing.statePrepareUpdateJackPot);// volvemos a insertar el jackpot
						}
					}else if (gc.jackPot_SQL.isWithError()){
						switchStateInitializing(ScreenInitializing.statePrepareUpdateJackPot);
					}else if (contTimeOut > timeSecurityLoader){
						gc.jackPot_SQL.cancelLoader();
						switchStateInitializing(ScreenInitializing.statePrepareUpdateJackPot);
					}else if (gc.jackPot_SQL.estaAccionFinalizada()){
						timeSecurityLoader = contTimeOut + timeIncSecurity;
					}				
					break;					
				//===== modificacion 15/05/2017   (fin) ==	
				*/
				//************************************************************************************************************************************************
				//************************************* END ****************************************************************************************************
				//************************************************************************************************************************************************
				case ScreenInitializing.stateEnd:
					gc.initializeGame_3();
					gc.switchSystemState(GameStates.STATE_SYSTEM_FINISH_INITIALIZING); 
					break;
				//************************************************************************************************************************************************
			}
		}
		//**************************************************************************************************************************************************
		public override function clean():void{
			if (animationConnecting != null){
				animationConnecting.cleanAnimation();
				animationConnecting = null;
			}
			if (backGroundBase != null){
				gc.stage.removeChild(backGroundBase);
				backGroundBase = null;
			}
			
			if (c.getIdMaquinaManual){
				backGroundConnecting.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownFunction); // Version BETA
			}
		}
		//**************************************************************************************************************************************************
		public function switchStateInitializing(s:int){
			stateScreenInitializing = s;
		}				
		//**************************************************************************************************************************************************		
		//************************************************* Version BETA ***********************************************************************************
		//**************************************************************************************************************************************************
		private function keyDownFunction(e:KeyboardEvent){
			if (e.keyCode == Keyboard.ENTER){		
				if (!idMaquina_introduced){
					idMaquina_introduced = true;
				}
			}
		}		
		//**************************************************************************************************************************************************
		private function validarIdMaquina(s:String):Boolean{
			var valid:Boolean = true;
			s = s.toUpperCase();
			if ((s.length == 36) && (s != "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")){
				for (var i:int=0;i<s.length;i++){
					if ((i == 8) || (i == 13) || (i == 18) || (i == 23)){
						if (s.charAt(i)  != "-") valid = false;
					
					}else{
						if (((s.charCodeAt(i) <65)  || (s.charCodeAt(i) > 90)) &&
							((s.charCodeAt(i) <48)  || (s.charCodeAt(i) > 57)))
							valid = false;
					}
				}
			}else{
				valid = false;
			}
			
			return valid;
		}
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		private function initParamTipoEjecucion():void{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// 0   --> Browser Luckhand.
			// 1   --> Browser Luckhand (Muestra logs ni botones auxiliares)
			// 2   --> Microsoft Explorer.
			// 3   --> Microsoft Explorer (Muestra logs ni botones auxiliares)
			// 4   --> Browser SMI
			// 5   --> Browser SMI (Muestra logs ni botones auxiliares)			
			// 6   --> Browser WEB
			// 7   --> Browser WEB (Muestra logs ni botones auxiliares)						
			// 100 --> Version local
			
			var stipoEjecucion:String = "0";
			
			if ((paramObj["tipoEjecucion"] != null) && (paramObj["tipoEjecucion"] != undefined))
				stipoEjecucion = String(paramObj["tipoEjecucion"]);
			else
				stipoEjecucion = "0";
			
			if ((paramObj["nombreMaquina"] != null) && (paramObj["nombreMaquina"] != undefined))
				stringNombreMaquina = String(paramObj["nombreMaquina"]);
			else
				stringNombreMaquina = "";
			
			
			if (c.versionLocal){
				stipoEjecucion = "100";
			}
			
			c.tipoEjecucion = stipoEjecucion;
			
			// BROWSER LUCKHAND
			if (stipoEjecucion == "0"){ 
					c.contenedorFlash				= c.BROWSER_LUCKHAND;
					c.opcionBETA					= false;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= true;
					c.inhabilitarBotonCobrar 		= false;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost 				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal				= false;
					c.pasarCreditosAlBrowser    	= true;
					c.notificarBrowserPagoGuardado 	= true;
					c.controlClickPanelPrintError   = true;
					c.controlInsertCreditsBrowser   = true;
			}
			// BROWSER LUCKHAND (mostrando logs)
			else if (stipoEjecucion == "1"){
					c.contenedorFlash				= c.BROWSER_LUCKHAND;
					c.opcionBETA					= true;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= true;
					c.inhabilitarBotonCobrar 		= false;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal 			= false;
					c.pasarCreditosAlBrowser    	= true;
					c.notificarBrowserPagoGuardado 	= true;
					c.controlClickPanelPrintError   = true;
					c.controlInsertCreditsBrowser   = true;
			}
			// MICROSOFT EXPLORER
			else if (stipoEjecucion == "2"){
					c.contenedorFlash				= c.MICROSOFT_EXPLORER;
					c.opcionBETA					= false;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= false;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal 			= false;		
					c.pasarCreditosAlBrowser    	= false;
					c.notificarBrowserPagoGuardado 	= false;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
					c.nombreMaquina                 = stringNombreMaquina;
			}
			// MICROSOFT EXPLORER (mostrando logs)
			else if (stipoEjecucion == "3"){
					c.contenedorFlash				= c.MICROSOFT_EXPLORER;
					c.opcionBETA					= true;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= false;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal 			= false;
					c.pasarCreditosAlBrowser    	= false;
					c.notificarBrowserPagoGuardado 	= false;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
					c.nombreMaquina                 = stringNombreMaquina;
			}
			// BROWSER SMI
			else if (stipoEjecucion == "4"){ 
					c.contenedorFlash				= c.BROWSER_SMI;
					c.opcionBETA					= false;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= true;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost 				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal				= false;
					c.pasarCreditosAlBrowser    	= true;
					c.notificarBrowserPagoGuardado 	= true;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
			}
			// BROWSER SMI (mostrando logs)
			else if (stipoEjecucion == "5"){
					c.contenedorFlash				= c.BROWSER_SMI;
					c.opcionBETA					= true;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= true;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal 			= false;
					c.pasarCreditosAlBrowser    	= true;
					c.notificarBrowserPagoGuardado 	= true;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
			}
			// BROWSER WEB
			else if (stipoEjecucion == "6"){
					c.contenedorFlash				= c.BROWSER_WEB;
					c.opcionBETA					= false;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= false;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= true;
					c.loadMinigameLocal 			= false;		
					c.pasarCreditosAlBrowser    	= false;
					c.notificarBrowserPagoGuardado 	= false;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
					c.nombreMaquina                 = stringNombreMaquina;
			}
			// BROWSER WEB (mostrando logs)
			else if (stipoEjecucion == "7"){
					c.contenedorFlash				= c.BROWSER_WEB;
					c.opcionBETA					= true;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= false;
					c.botonSalirWhithBrowser 		= false;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= false;
					c.maquinaInicial 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
					c.phpEnLocalhost				= false;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= true;
					c.loadMinigameLocal 			= false;
					c.pasarCreditosAlBrowser    	= false;
					c.notificarBrowserPagoGuardado 	= false;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = true;
					c.nombreMaquina                 = stringNombreMaquina;
			}						
			// Version local
			else if (stipoEjecucion == "100"){
					c.contenedorFlash				= 0;
					c.opcionBETA					= true;
					c.inhabilitarFuncionTrace		= true;
					c.inhabilitarBotonSalir 		= true;
					c.botonSalirWhithBrowser 		= false;
					c.inhabilitarBotonCobrar 		= true;
					c.getIdMaquinaManual 			= true;
					c.maquinaInicial 				= "3736416c-6265-4727-4373-6416c6265727";		// Albert
					//c.maquinaInicial				= "33314361-726C-46F7-3303-433314361726"; 		// Carlos
					c.phpEnLocalhost 				= true;
					c.ignorarPowerFail 				= false;
					c.ignorarPowerFailLocal 		= false;
					c.loadMinigameLocal 			= false;
					c.pasarCreditosAlBrowser    	= false;
					c.notificarBrowserPagoGuardado 	= false;
					c.controlClickPanelPrintError   = false;
					c.controlInsertCreditsBrowser   = false;
			}			
		}
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos el cliente (pais) en el que se está ejecutando del browser
		private function getParamCliente():int{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// 0   ---> Madrid
			// 1   -->  Luxemburgo
			// 2   -->  Portugal
			// 3   -->  Brasil
			// 4   -->  Chile
			
			var s_pais:String = "0";
			
			if ((paramObj["pais"] != null) && (paramObj["pais"] != undefined))
				s_pais = String(paramObj["pais"]);
			else
				s_pais = "0";		
			
			return int(s_pais);
		}				
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos el idSessionGameWeb, para identificar que sesion de juego está habilitada para esta maquina.
		private function getParamIdSessionGameWeb():Number{
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			var s_idSessionGameWeb:String = "0";
			
			if ((paramObj["idSessionGameWeb"] != null) && (paramObj["idSessionGameWeb"] != undefined))
				s_idSessionGameWeb = String(paramObj["idSessionGameWeb"]);
			else
				s_idSessionGameWeb = "0";		
			
			return Number(s_idSessionGameWeb);
		}						
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos la region (zona horaria) dependiendo del pais que nos ha pasado el browser
		private function getZonaHoraria(cliente:int):String{
			// cliente
			// 		0   -->  Madrid
			// 		1   -->  Luxemburgo
			// 		2   -->  Portugal
			// 		3   -->  Brasil
			// 		4   -->  Chile
			// 		5   -->  México
			
			var region = "Europe/Madrid";
			
			switch(cliente){
				case 0:
					region = "Europe/Madrid";
					break;
				case 1:
					region = "Europe/Luxembourg";
					break;
				case 2:
					region = "Europe/Lisbon";
					break;
				case 3:
					region = "America/Sao_Paulo";
					break;
				case 4:
					region = "America/La_Paz";
					break;					
				case 5:
					region = "America/Mexico_City";
					break;										
			}
			
			return (region);
		}			
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos la la tabla de idioma que vamos a cargar dependiendo del pais que nos ha pasado el browser
		// Se almacenará el frame del moviclip que le corresoponde  al idioma. 
		// El indice de la tabla corresponderá al idioma (1:Portugues,2:Ingles,3:Español,4:Frances).	
		// La primera posición siempre será 0.
		// Ejemplo: [0, 5, 2, 0, 4] => El idioma 1 (Portugués) le corresponde el frame 5 del moviclip mc_buttonFlag
		//                             El idioma 2 (Inglés) le corresponde el frame 2 del moviclip mc_buttonFlag
		//                             El idioma 3 (Español) no está habilitado
		//                             El idioma 4 (Frances) le corresponde al frame 4 del moviclip mc_buttonFlag
		private function getTablaIdioma(cliente:int):Array{
			// cliente
			// 		0   -->  Madrid
			// 		1   -->  Luxemburgo
			// 		2   -->  Portugal
			// 		3   -->  Brasil
			// 		4   -->  Chile			
			// 		5   -->  México
			
			var t:Array = [0,1,2,3,4];
			
			if (c.contenedorFlash == c.BROWSER_SMI){
				t = [0,1,2,3,4];
			}
			else{
				switch(cliente){
					case 0:	//  Madrid
						t = [0,1,2,3,4];
						break;
					case 1:	//  Luxemburgo
						t = [0,1,2,3,4];
						break;
					case 2:	//  Portugal
						t = [0,1,2,3,4];
						break;
					case 3:	//  Brasil
						t = [0,5,2,3,4];
						break;
					case 4:	//  Chile
						t = [0,5,2,6,4];
						break;					
					case 5:	//  México
						t = [0,5,2,7,4];
						break;											
				}
			}
			
			return (t);
		}			
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos la la tabla de los idioma que vamos a cargar dependiendo del pais (cliente) que nos ha pasado el browser
		// El primer idioma del array será el que se cargue por defecto, y el orden en los que asignemos los valores
		// será el orden en el que irán apareciendo a medida que pulsemos el boton de cambio de idioma.		
		// Los valores posibles serán 1,2,3 y 4:
		//			1: Portugués
		//			2: Inglés
		//			3: Español
		//			4: Frances
		private function getTablaListaIdiomas(cliente:int):Array{
			// cliente (País)
			// 		0   -->  Madrid
			// 		1   -->  Luxemburgo
			// 		2   -->  Portugal
			// 		3   -->  Brasil
			// 		4   -->  Chile
			// 		5   -->  México
			
			var t:Array = [1,2,3,4];
			
			if (c.contenedorFlash == c.BROWSER_SMI){
				t = [3,2,4,1];
			}
			else{			
				switch(cliente){
					case 0:	//  Madrid
						t = [1,2,3,4];
						break;
					case 1:	//  Luxemburgo
						t = [4,1,2,3];
						break;
					case 2:	//  Portugal
						t = [1,2,3,4];
						break;
					case 3:	//  Brasil
						t = [1,3,2];
						break;
					case 4:	//  Chile
						t = [3,1,2];
						break;					
					case 5:	//  México
						t = [3,2,1];
						break;											
				}
			}
			
			return (t);
		}						
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos la la tabla de los frames activos para la imagen de la moneda según el país
		// Los valores posibles serán 1,2,3 y 4:
		//			1: Portugués
		//			2: Inglés
		//			3: Español
		//			4: Frances
		private function getTablaFramesImagenMoneda(cliente:int):Array{
			// cliente (País)
			// 		0   -->  Madrid
			// 		1   -->  Luxemburgo
			// 		2   -->  Portugal
			// 		3   -->  Brasil
			// 		4   -->  Chile
			// 		5   -->  México
			
			var t:Array = [1,2];
			
			switch(cliente){
				case 0:	//  Madrid
					t = [1,2];
					break;
				case 1:	//  Luxemburgo
					t = [1,2];
					break;
				case 2:	//  Portugal
					t = [1,2];
					break;
				case 3:	//  Brasil
					t = [1,2];
					break;
				case 4:	//  Chile
					t = [3,4];
					break;					
				case 5:	//  México
					t = [1,2];
					break;					
			}
			
			return (t);
		}				
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos la la tabla de los valores activos para la moneda según el país (Valor de centimos que tiene un credito)
		// Los valores posibles serán 1,2,3 y 4:
		//			1: Portugués
		//			2: Inglés
		//			3: Español
		//			4: Frances
		private function getTablaValoresMoneda(cliente:int):Array{
			// cliente (País)
			// 		0   -->  Madrid
			// 		1   -->  Luxemburgo
			// 		2   -->  Portugal
			// 		3   -->  Brasil
			// 		4   -->  Chile
			// 		5   -->  México
			
			var t:Array = [1,10];
			
			switch(cliente){
				case 0:	//  Madrid
					t = [1,10];
					break;
				case 1:	//  Luxemburgo
					t = [1,10];
					break;
				case 2:	//  Portugal
					t = [1,10];
					break;
				case 3:	//  Brasil
					t = [1,10];
					break;
				case 4:	//  Chile
					t = [1,10];
					break;					
				case 5:	//  México
					t = [1,10];
					break;					
			}
			
			return (t);
		}					
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		// Obtenemos el idioma por defecto con el que se inicializará el juego.
		private function getParamIdioma():int{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// 1   --> Portugues
			// 2   --> Ingles 
			// 3   --> Español
			// 4   --> Frances
			
			var s_idioma:String = "0";
			
			if ((paramObj["idioma"] != null) && (paramObj["idioma"] != undefined)){
				s_idioma = String(paramObj["idioma"]);
			}else{
				s_idioma = "0";		
			}
			
			return int(s_idioma);
		}				
		//*********************************************************************************************************		
		//*********************************************************************************************************
		//*********************************************************************************************************		
		// -----------------------------
		// ----- Funcion para SMI ------
		// -----------------------------
		// Obtenemos el parametro multiJuego
		private function getParamMultiJuego():Boolean{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// 0: false --> Maquina que solo contiene un único juego
			// 1: true  --> Maquina que contiene un pack de juegos con su correspondiente menú.
			
			var s_multiJuego:String = "1";
			
			if ((paramObj["multiJuego"] != null) && (paramObj["multiJuego"] != undefined)){
				s_multiJuego = String(paramObj["multiJuego"]);
			}else{
				s_multiJuego = "1";		
			}
			
			if (s_multiJuego == "1")
				return true;
			else 
				return false;
		}						
		//*********************************************************************************************************		
		//*********************************************************************************************************
		//*********************************************************************************************************		
		// -----------------------------
		// ----- Funcion para SMI ------
		// -----------------------------
		// Obtenemos el parametro displayAspectRatio: Que indica el ratio del monitor, será un string del tipo:   "5:4",  "4:3",   "16:10",   "16:9"
		private function getParamDisplayAspectRatio():String{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// Diferentes tipos de ratio del monitor:  "5:4",  "4:3",   "16:10",   "16:9"
			
			var s_displayAspectRatio:String = "";
			
			if ((paramObj["displayAspectRatio"] != null) && (paramObj["displayAspectRatio"] != undefined)){
				s_displayAspectRatio = String(paramObj["displayAspectRatio"]);
			}else{
				s_displayAspectRatio = "";		
			}
			
			return s_displayAspectRatio;
		}						
		//*********************************************************************************************************		
		//*********************************************************************************************************
		//*********************************************************************************************************		
		// -----------------------------
		// ----- Funcion para SMI ------
		// -----------------------------
		// Obtenemos el parametro tipoMaquina
		private function getParamTipoMaquina():int{
			
			var paramObj:Object = LoaderInfo(gc.stage.loaderInfo).parameters;
			
			// 0:    Multiluck España
			// 1:    Casinos (en formato créditos)
			// 2:    Casinos (en formato créditos – Euros, intercambiables)
			
			var s_tipoMaquina:String = "0";
			
			if ((paramObj["tipoMaquina"] != null) && (paramObj["tipoMaquina"] != undefined)){
				s_tipoMaquina = String(paramObj["tipoMaquina"]);
			}else{
				s_tipoMaquina = "0";
			}
			
			return int(s_tipoMaquina);
		}			
		//*********************************************************************************************************		
		//*********************************************************************************************************		
		//*********************************************************************************************************		
				
		
	}	
}
