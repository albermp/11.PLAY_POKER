package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.*;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.external.ExternalInterface; // Para realizar una llamada directa al browser
	
	// Clase que controla el flujo principal del juego, controla la transicion entre una pantalla y otra.
	// el clico de vida de una pantalla es: init ---> inicializa todos los componentes
	//										run ----> se vae jecutando la pantalla	
	//										finish -> salimos de la pantalla, se eliminan del stage todos los elementos de la misma.
	public class GameControl extends MovieClip {
		//*
		public var systemFunction:Function; // vamo almacenando la función que ejecutaremos en cada momento del juego. El juego es una máquina de estados.
		//*
		public var currentSystemState:int;  // almacenamos el estado actual del juego.
		public var nextSystemState:int;     // próximo estado que se ejecutará 
		public var lastSystemState:int;     // guardamos el anterior estado que hemos ejectuado (a veces puede ser util consultar esta información) 
		//*
		// variables para gestionar el bucle principal del juego
		private var contForceGarbageCollect:int = 0; // Para controlar la llamada manual al Garbage Collect.
		public var fps:int;
		public var timerPeriod:Number;
		public var gameTimer:Timer;
		//*
		public var screenGame:ScreenBase;			// Es la pantalla principal del juego, dónde están los 5 rodillos.
		public var screenInitializing:ScreenBase;	// Es la pantalla que utilizaremos mientras nos conectamos a la base de datos
		
		public var gameData:GameData;				// Game Data, información del tipo, creditos, lineas de apuesta, etc...
		/*
		public var screenHelp:MovieClip;			// Es la pantalla que utilizaremos para mostrar el menú.
		public var screenMiniGame1:MovieClip;		// Para mostrar el juego bonus ---> Bonus Cauldron
		public var screenMiniGame2:MovieClip;		// Para mostrar el juego bonus ---> Bonus Magic
		public var screenMiniGame3:MovieClip;		// Para mostrar el juego bonus ---> Bonus Pumpkin
		public var screenMiniGame4:MovieClip;		// Para mostrar el juego bonus ---> Free Games
		*/
		
		public var screenHelp:ScreenHelp;			// Es la pantalla que utilizaremos para mostrar el menú.
		public var screenMiniGame1:ScreenMiniGame1;	// Para mostrar el juego bonus ---> Bonus Cauldron
		public var screenMiniGame2:ScreenMiniGame2;	// Para mostrar el juego bonus ---> Bonus Magic
		public var screenMiniGame3:ScreenMiniGame3;	// Para mostrar el juego bonus ---> Bonus Pumpkin
		public var screenMiniGame4:ScreenMiniGame4;	// Para mostrar el juego bonus ---> Free Games
		
		   	
		public var loadMinigames:LoadMinigames_2;	// Clase que carga los swf de los minigames
		public var powerFail:PowerFail;			   	// Para codificar y decodificar la información y hacer posible el resposicionamiento
		public var powerFail_SQL:PowerFailMySQL;   	// Para guardar y recuperar de la base de datos
		public var cfs:ControlFileServerPowerFail; 	// Para guardar y recuperar informacion del servidor
		public var cfl:ControlFileLocal;		   	// Para guardar y recuperar informacion del shared object local	
		//public var cf_log:ControlFileLog;		   	// Para escribir en un fichero Log en el servidor 
		public var userCredits_SQL:UserCreditMySQL; // Para guardar y recuperar de la base de datos los creditos
		public var jackPot_SQL:JackpotSlotMySQL;   	// Para guardar y recuperar de la base de datos el jackpot y los sus parametros
		public var con_internet:ValidarConexionInternet; 	// Para poder validar si tenemos conexion a internet
		public var rtsp:RefrescarTimeStampPlaying;	// Actualiza en la bd (tabla Machines), cada cierto tiempo, el timestamp actual.
		public var vmb:ValidarMaquinaBloqueada;		// Para determinar si una maquina está bloqueada o no
		
		private var quitTheGame:Boolean;
		
		public var listenerBrowserPago:ListenerBrowserPago; 							// Listener para la comunicacion directa con el browser cuando se introduzcan nuevos creditos
		public var mostrar_NombreUsuario:MostrarNombreUsuario; 							// Para poder mostrar el nombre usuario (MachineName) en la parte superior izquierda de la pantalla
		public var listenerBrowserConexionInternet:ListenerBrowserConexionInternet; 	// Listener para la comunicacion directa con el browser. Recibimos el estado de la conexion a internet
		public var accesoBrowser_SMI:AccesoBrowser_SMI;									// Clase para que el browser SMI pueda consultar o realizar acciones sobre el juego
		
		public var backUp:BackUpData;
		
		//*****************************************************************************************************************************
		public function GameControl() {}
		//*****************************************************************************************************************************
		public function initializeGame_1():void {
			
			//Preparamos la instnacia que nos facilitará la conexión la base de datos por primera vez.
			screenInitializing = new ScreenInitializing(this);				
			// Game Data
			gameData	  = new GameData();		
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// proceso que refrescará en la bd (tabla Machines), cada cierto tiempo, el actual timestamp. Lo hará durante el juego esté cargado.
			//-----------------------------------------------------------------------------------------------------------------------------------
			rtsp		  = new RefrescarTimeStampPlaying();
			quitTheGame   = false;

			//-----------------------------------------------------------------------------------------------------------------------------------
			//      Validamos si la maquina está bloqueada o no. La opcion de bloqueo se puede modificar a traves de la aplicacion web
			//-----------------------------------------------------------------------------------------------------------------------------------
			vmb = new ValidarMaquinaBloqueada();
		}				
		//*****************************************************************************************************************************
		public function initializeGame_2():void {
			// creamos el sound manager para manegar todos los sonidos del juego			
			//soundManager = new SoundManager();
			//stage.addEventListener(CustomEventSound.PLAY_SOUND,soundEventListener,false,0,true); // ¡¡ esta linea es opcional !!
			
			// Para guardar informacion (PowerFail,etc..) en los diferentes modos, base de datos, fichero en el servidor o en local.
			backUp = new BackUpData();
			// Definimos la clase que controla todo lo relacionado con el power fail
			powerFail    = new PowerFail();
			// Descomentar estas lineas si se quiere probar un power fail sin acceder a la base de datos.			
			
			
			// OJO - INI
			// Si queremos probar el powerFail sin necesidad de acceder a la base de datos
			/*
			powerFail.setCadena("31*11*2*10*13*10*5*7*13*10*6*5*8*10*3*7*10*0*25*1*999975*0.00125*1*15*3*true*true*true*0*0_10_0_10_0_0_0_10_0_0_0_10_0_0_10_0_4_/15_3$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_12_0_0_12_0_0_12_0_0_0_2_225$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_7_0_0_7_0_0_7_0_0_0_0_0_0_540_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0_0$*");
			powerFail.setHayReposicion(true);
			if (powerFail.reposicionar()){
				powerFail.decodificar();
			}
			*/

			// OJO - FIN
						
			//Power fail acceso a base de datos.
			powerFail_SQL 	= new PowerFailMySQL(); 
			//Acceso al servidor: lo utilizaremos para guardar fichero powerFail en el servidor.
			cfs				= new ControlFileServerPowerFail();
			//Acceso al shared object local: Utilizado para almacenar la información powerFail en un sharedObject (espacio local)
			cfl				= new ControlFileLocal();
			//Para escribir un log en un fichero del servidor y registrar información, por ejemplo un historico de jugadas.
			//cf_log			= new ControlFileLog();
			//Para recuperar y guardar los creditos de la maquina de la base de datos
			userCredits_SQL = new UserCreditMySQL();
			// Para guardar y recuperar de la base de datos el jackpot y los sus parametros
			jackPot_SQL		= new JackpotSlotMySQL();
			// Validador de conexion a internet
			con_internet	= new ValidarConexionInternet();
			//screenInitializing = new ScreenInitializing(this);				
			// Cargamos los juegos de bonus y el menu ayuda
			loadMinigames = new LoadMinigames_2();	
			loadMinigames.init(); // iniciamos la descarga del resto de componentes.
			
			listenerBrowserConexionInternet = new ListenerBrowserConexionInternet();
						
			//-----------------------------------------------------------------------------------------------------------------------------------
			//--    El juego muestra el nombre de máquina (nombre de usuario), en la parte superior izquierda.                        -----------
			//-----------------------------------------------------------------------------------------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND:
					mostrar_NombreUsuario = new MostrarNombreUsuario();
					break;
				default:
					mostrar_NombreUsuario = null;
					break;
			}									
			//-----------------------------------------------------------------------------------------------------------------------------------
			//--   Proporcionamos posibilidad que un browser externo realice consultas o realice  diferentes acciones en el juego     -----------
			//-----------------------------------------------------------------------------------------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND:
					break;
				case c.BROWSER_SMI:
					accesoBrowser_SMI = new AccesoBrowser_SMI(this);
					break;
				case c.MICROSOFT_EXPLORER:
				case c.BROWSER_WEB:
					break;
				default:
					break;
			}						
			//-----------------------------------------------------------------------------------------------------------------------------------
			//---- Notificamos al browser (contenedor del juego) que el juego ya está caragado --------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND:
					ExternalInterface.call("JuegoCargado","");
					break;
				case c.BROWSER_SMI:
					ExternalInterface.call("JuegoIniciado",c.nombreJuego);				
					break;
				case c.MICROSOFT_EXPLORER:
				case c.BROWSER_WEB:
					break;
				default:
					break;
			}
			//-----------------------------------------------------------------------------------------------------------------------------------
			//--                             Notificamos al browser externo el idioma actual                                          -----------
			//-----------------------------------------------------------------------------------------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND:
					break;
				case c.BROWSER_SMI:
					var nombreIdioma:String = "";
					switch(gameData.idioma){
						case c.PORTUGUESE: 	nombreIdioma = "PORTUGUES";	break;
						case c.ENGLISH: 	nombreIdioma = "INGLES";	break;
						case c.SPANISH: 	nombreIdioma = "CASTELLANO";break;
						case c.FRENCH: 		nombreIdioma = "FRANCES";	break;
					}
					ExternalInterface.call("IdiomaActual",nombreIdioma); 
					break;
				case c.MICROSOFT_EXPLORER:
				case c.BROWSER_WEB:
					break;
				default:
					break;
			}			
			//-----------------------------------------------------------------------------------------------------------------------------------
			//--                             Notificamos al browser la apuesta actual                                                     -------
			//-----------------------------------------------------------------------------------------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND:
					break;
				case c.BROWSER_SMI:
					var valorApuesta:String = String(gameData.bet);
					ExternalInterface.call("valorApuesta",valorApuesta); 
					break;
				case c.MICROSOFT_EXPLORER:
				case c.BROWSER_WEB:
					break;
				default:
					break;
			}						
			//-----------------------------------------------------------------------------------------------------------------------------------
			//              Preparamos los eventos de teclado para poder salir del juego en cualquier momento
			//              Se enviará una notifiacación al browser de que se ha pulsado la tecla ESC
			//-----------------------------------------------------------------------------------------------------------------------------------
			switch(c.contenedorFlash){
				case c.BROWSER_LUCKHAND: 	stage.addEventListener(KeyboardEvent.KEY_DOWN, accesoTecladoDown); break;
				case c.BROWSER_SMI:			break;
				case c.MICROSOFT_EXPLORER:	break;
				case c.BROWSER_WEB:			break;
				default:					break;
			}
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			
			// Creamos la pantalla principal del juego
			screenGame 	  = new ScreenGame(this);
			
		}
		//*****************************************************************************************************************************
		public function initializeGame_3():void {
			//-----------------------------------------------------------------------------------------------------------------------------------
			//---- Inicializamos el listener para los nuevos creditos insertados, segun cual sea el contenedor que contiene el juego flash. ----
			//-----------------------------------------------------------------------------------------------------------------------------------
			if (c.controlInsertCreditsBrowser){
				listenerBrowserPago = new ListenerBrowserPago(gameData);
			}			
		}		
		//*************************************************************************************************************************************
		//********************************************* TECLAS ACCESO RAPIDO ******************************************************************
		//*************************************************************************************************************************************
		private function accesoTecladoDown(e:KeyboardEvent){ 
			if (e.keyCode == Keyboard.ESCAPE){			// Notificamos al browser que queremos salir del juego SALIR DEL JUEGO EN CUALQUIER MOMENTO
			
				//-------------------------------------------------------------
				// OJO - ini -
				// Cuando el cliente sea Luxemburgo, anulamos la tecla ESC
				if (gameData.cliente == 1) return;
				// OJO - fin -
				//-------------------------------------------------------------
			
			
				// Miramos si la tecla ESC está activa en estos momentos
				if (gameData.tecla_ESC){
					ExternalInterface.call("tecla_ESC",""); 
				}
			}
		}		
		//***************************************************************************************************************************************
		//************************************** INICIALIZAMOS EL CLIENTE ***********************************************************************
		//***************************************************************************************************************************************
		public function initializeCliente(cliente:int):void {
			gameData.cliente = cliente;
		}					
		//***************************************************************************************************************************************
		//************************************** INICIALIZAMOS EL IdSessionGameWeb **************************************************************
		//***************************************************************************************************************************************
		public function initializeIdSessionGameWeb(idSessionGameWeb:Number):void {
			gameData.IdSessionGameWeb = idSessionGameWeb;
		}									
		//***************************************************************************************************************************************
		//************************************** INICIALIZAMOS LA ZON HORARIA *******************************************************************
		//***************************************************************************************************************************************
		public function initializeRegionHoraria(region:String):void {
			gameData.regionHoraria = region;
		}							
		//***************************************************************************************************************************************
		//************************************** INICIALIZAMOS LA LA TABLA DE IDIOMAS ***********************************************************
		//***************************************************************************************************************************************
		public function initializeTablaIdiomas(t:Array):void {
			gameData.t_idioma = t;
		}									
		//***************************************************************************************************************************************
		//******************************** INICIALIZAMOS LA LA TABLA DE lista IDIOMAS ***********************************************************
		//***************************************************************************************************************************************
		public function initializeTablaListaIdiomas(t:Array):void {
			gameData.t_lista_idiomas = t;
		}									
		//***************************************************************************************************************************************
		//******************************** INICIALIZAMOS LA LA TABLA DE frames MONEDA  **********************************************************
		//***************************************************************************************************************************************
		public function initializeTablaFramesImagenMoneda(t:Array):void {
			// Cargamos la lista de imagenes para la moneda
			gameData.t_imagenMoneda = t;
			// Valor por defecto de la imagen Moneda
			gameData.imagenMoneda 	= gameData.t_imagenMoneda[1];
		}									
		//***************************************************************************************************************************************
		//******************************** INICIALIZAMOS LA LA TABLA DE valores MONEDA  *********************************************************
		//***************************************************************************************************************************************
		public function initializeTablaValoresMoneda(t:Array):void {
			// Cargamos la lista de valores para la moneda
			gameData.t_valorDenominacion = t;
			// Valor por defecto de la imagen Moneda
			gameData.valorDenominacion   = gameData.t_valorDenominacion[1];
		}			
		//***************************************************************************************************************************************
		//************************************** INICIALIZAMOS EL IDIOMA  ***********************************************************************
		//***************************************************************************************************************************************
		public function initializeIdioma(idioma:int):void {
			if (idioma > 0)
				gameData.idioma = idioma;
			else
				gameData.idioma = gameData.t_lista_idiomas[0];	// Cargamos por defecto el primer idioma de la lista
		}						
		//***************************************************************************************************************************************
		//***************************************************************************************************************************************
		//***************************************************************************************************************************************
		//Funcion que inicia el juego
		public function startGame():void {			
			
			fps = 60;
			
			//=======================================
			// Metodo 1: El juego se mueve por Timer
			//=======================================
			timerPeriod = 1000 / fps;	
			/*
			gameTimer=new Timer(timerPeriod);
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();
			*/
			//=======================================================
			// Metodo 2: El juego se mueve por en evento ENTER_FRAME
			//=======================================================
			stage.frameRate = fps;
			stage.addEventListener(Event.ENTER_FRAME, runGame);
			
		}
		//***************************************************************************************************************************************
		public function add_event_TIMER():void{
			gameTimer=new Timer(timerPeriod);
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();
		}
		public function delete_event_TIMER():void{
			gameTimer.removeEventListener(TimerEvent.TIMER, runGame);
			gameTimer.stop();
			gameTimer = null;
		}
		//=======================================================================================================================================
		public function add_event_ENTER_FRAME():void{
			stage.addEventListener(Event.ENTER_FRAME, runGame);
		}				
		public function delete_event_ENTER_FRAME():void{
			stage.removeEventListener(Event.ENTER_FRAME, runGame);
		}
		//***************************************************************************************************************************************
		//***************************************************************************************************************************************
		//***************************************************************************************************************************************
		/*
		public function soundEventListener(e:CustomEventSound):void{
			if (e.type == CustomEventSound.PLAY_SOUND){
				soundManager.playSound(e.name, e.isSoundTrack, e.loops, e.offset, e.volume);
			}else{
				soundManager.playSound(e.name, e.isSoundTrack);
			}
		}	
		*/
		//***************************************************************************************************************************************
		// Llamamos a esta función en cada vuelta de bucle (tic) del juego
		//public function runGame(e:TimerEvent):void {
		  public function runGame(e:Event):void {

			
			// Calculating fps - ini -
			var timeNow:Number = new Date().getTime();
			gameData.deltaTime = timeNow - gameData.currentTime;
			gameData.currentTime = timeNow;
					
			gameData.currentTime2 += gameData.deltaTime;
			gameData.contFPS ++;
			
			if (gameData.currentTime2 > 1000){
				gameData.newFPS = true;
			}
			// Calculating fps - fin -
			
			//---------------------------------------------------------------------------------------------------------------------------------------------
			// Refrescamos cada cierto tiempo, en la tabla Machines (LastPing), el actual timestamp. Proceso que se realizará durente todo el juego.
			// Tambien utilizamos esta accion para validar si el idSession es el mismo que está habilitado en la base de datos. Esta accion se utiliza
			// en en entorno WEB para evitar duplicidad de sesiones con una misma maquina.
			
			// Esta funcionalidad estará activa en los siguientes entornos: MICROSOFT_EXPLORER, BROWSER_WEB y BROWSER_SMI.
			if ((c.contenedorFlash == c.MICROSOFT_EXPLORER) ||
			    (c.contenedorFlash == c.BROWSER_WEB)		||
			    (c.contenedorFlash == c.BROWSER_SMI)){					
				if (rtsp.get_activado()){
					rtsp.run();
					if (!rtsp.isSesionHabilitada()){
						switch (c.contenedorFlash){
							case c.BROWSER_WEB:
								if (!quitTheGame){
									flash.net.navigateToURL(new URLRequest("../logout.php?id="+ gameData.IdSessionGameWeb),"_self");
									quitTheGame = true;
								}
								break;
							default:
								break;
						}
					}
				}
			}
			//---------------------------------------------------------------------------------------------------------------------------------------------
			
			// Estamos pendiente de si la maquina está bloqueada o no, para enviar la notificacion al browser y nos saque fuera en caso de estar bloqueada
			vmb.run();
			
			systemFunction();
			//e.updateAfterEvent();
			
			// Force garbage collect
			//contForceGarbageCollect ++;
			//if (contForceGarbageCollect>2){
				System.gc(); // Force garbage collect every 10 tics
				//contForceGarbageCollect = 0;
			//}
		}
		//***************************************************************************************************************************************
		// aquí definimos la máquina de estados por los que irá pasando el juego
		public function switchSystemState(stateval:int):void {
			lastSystemState = currentSystemState;
			currentSystemState = stateval;
			
			switch(stateval) {
				//******************************************************************************
				case GameStates.STATE_SYSTEM_NONE:
					break;
				//**** Pantalla Connecting (Recupera creditos, jackpot, powerfail, etc..) ******
				case GameStates.STATE_SYSTEM_INIT_INITIALIZING:
					systemFunction = systemInitInitializing;
					break;
				case GameStates.STATE_SYSTEM_RUN_INITIALIZING:
					systemFunction = systemRunInitializing;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_INITIALIZING:
					systemFunction = systemFinishInitializing;
					break;					
				//********************* Pantalla Juego Principal  ******************************
				case GameStates.STATE_SYSTEM_INIT_GAME:
					systemFunction = systemInitGame;
					break;
				case GameStates.STATE_SYSTEM_RUN_GAME:
					systemFunction = systemRunGame;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_GAME:
					systemFunction = systemFinishGame;
					break;
				//********************* SCREEN HELP (pantallas de ayuda) ***********************
				case GameStates.STATE_SYSTEM_INIT_HELP:
					systemFunction = systemInitHelp;
					break;
				case GameStates.STATE_SYSTEM_RUN_HELP:
					systemFunction = systemRunHelp;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_HELP:
					systemFunction = systemFinishHelp;
					break;
				//***************** SCREEN MINI GAME 1 (Bonus 1) *******************************
				case GameStates.STATE_SYSTEM_INIT_MINIGAME_1:
					systemFunction = systemInitMiniGame1;
					break;
				case GameStates.STATE_SYSTEM_RUN_MINIGAME_1:
					systemFunction = systemRunMiniGame1;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_1:
					systemFunction = systemFinishMiniGame1;
					break;
				//********************* SCREEN MINI GAME 2 (Bonus 2) ***************************
				case GameStates.STATE_SYSTEM_INIT_MINIGAME_2:
					systemFunction = systemInitMiniGame2;
					break;
				case GameStates.STATE_SYSTEM_RUN_MINIGAME_2:
					systemFunction = systemRunMiniGame2;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_2:
					systemFunction = systemFinishMiniGame2;
					break;
				//*************** SCREEN MINI GAME 3 (Bonus 3) ********************************* 
				case GameStates.STATE_SYSTEM_INIT_MINIGAME_3:
					systemFunction = systemInitMiniGame3;
					break;
				/*
				case GameStates.STATE_SYSTEM_PRE_RUN_MINIGAME_3:
					systemFunction = systemPreRunMiniGame3;
					break;					
				*/
				case GameStates.STATE_SYSTEM_RUN_MINIGAME_3:
					systemFunction = systemRunMiniGame3;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_3:
					systemFunction = systemFinishMiniGame3;
					break;
				//******************** SCREEN MINI GAME 4 (Bonus 4) ****************************
				case GameStates.STATE_SYSTEM_INIT_MINIGAME_4:
					systemFunction = systemInitMiniGame4;
					break;
				case GameStates.STATE_SYSTEM_RUN_MINIGAME_4:
					systemFunction = systemRunMiniGame4;
					break;					
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_4:
					systemFunction = systemFinishMiniGame4;
					break;
				//*************************************************************************************
			}
		}
		//*****************************************************************************************************************************
		//*********************************************** POWER FAIL ******************************************************************
		//*****************************************************************************************************************************
		public function systemInitInitializing():void {
			screenInitializing.init();
			switchSystemState(GameStates.STATE_SYSTEM_RUN_INITIALIZING); 
		}
		//*****************************************************************************************************************************
		public function systemRunInitializing():void {
			screenInitializing.run();
		}
		//*****************************************************************************************************************************
		public function systemFinishInitializing():void {
			screenInitializing.clean();
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME); 
		}		
		//*****************************************************************************************************************************
		//*********************************************** GAME ************************************************************************
		//*****************************************************************************************************************************
		public function systemInitGame():void {
			switch (lastSystemState){
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_1: 
					screenGame.init();
					screenMiniGame1.clean(); 					
					stage.removeChild(screenMiniGame1);screenMiniGame1=null;
					screenGame.loadData();
					break; 
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_2: 
					screenGame.init();
					screenMiniGame2.clean(); 
					stage.removeChild(screenMiniGame2);screenMiniGame2=null;
					screenGame.loadData();
					break; 
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_3: 
					screenGame.init();
					screenMiniGame3.clean(); 
					stage.removeChild(screenMiniGame3);screenMiniGame3=null;
					screenGame.loadData();
					break; 
				case GameStates.STATE_SYSTEM_FINISH_MINIGAME_4: 
					screenMiniGame4.clean();
					stage.removeChild(screenMiniGame4);screenMiniGame4=null;
					screenGame.clean();
					screenGame.init();
					screenGame.loadData();
					break; 
				case GameStates.STATE_SYSTEM_FINISH_HELP:		
					//screenGame.init();
					screenGame.init_2();
					screenHelp.clean();
					stage.removeChild(screenHelp);screenHelp=null;
					screenGame.loadData();
					break;
				default: 										
					screenGame.init(); 
					break;
			}
			switchSystemState(GameStates.STATE_SYSTEM_RUN_GAME);
		}
		//*****************************************************************************************************************************
		public function systemRunGame():void {
			screenGame.run();
		}
		//*****************************************************************************************************************************
		public function systemFinishGame():void {
			screenGame.saveData();	// Guardamos la informacion actual de la pantalla del juego, para que después podamos recuperarla
			// Si vamos a un mini game, no limpiamos la pantalla (así evitamos el parpadeo entre frames)
			if ((nextSystemState != GameStates.STATE_SYSTEM_INIT_MINIGAME_1) && 
				(nextSystemState != GameStates.STATE_SYSTEM_INIT_MINIGAME_2) && 
				(nextSystemState != GameStates.STATE_SYSTEM_INIT_MINIGAME_3) && 
				(nextSystemState != GameStates.STATE_SYSTEM_INIT_MINIGAME_4) && 
			    (nextSystemState != GameStates.STATE_SYSTEM_INIT_HELP)){
				screenGame.clean();	
			}
			
			switchSystemState(nextSystemState);
		}
		//*****************************************************************************************************************************
		//********************************************* HELP **************************************************************************
		//*****************************************************************************************************************************
		public function systemInitHelp():void {			
			// Nos esperamos que el la pantalla help se haya cargado en memoria
			if (loadMinigames.isScreenHelpLoaded()){				
				if (loadMinigames.isLabelLoadingInStage()){
					loadMinigames.delSceneLabelLoading(stage);
				}				
				screenHelp = loadMinigames.getScreenHelp();
				screenHelp.setInitInformation(gameData);
				stage.addChild(screenHelp);				
				screenHelp.init();
				//screenGame.clean();
				switchSystemState(GameStates.STATE_SYSTEM_RUN_HELP);
			}else{
				if (!loadMinigames.isLabelLoadingInStage()){
					loadMinigames.addSceneLabelLoading(stage);
				}
			}
		}
		//*****************************************************************************************************************************
		public function systemRunHelp():void {
			screenHelp.run();
			if (screenHelp.isScreenHelpFinished()){
				switchSystemState(GameStates.STATE_SYSTEM_FINISH_HELP);
			}
		}
		//*****************************************************************************************************************************
		public function systemFinishHelp():void {
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME);
		}
		//*****************************************************************************************************************************
		//********************************************* MINI GAME 1 *******************************************************************
		//*****************************************************************************************************************************
		public function systemInitMiniGame1():void {
			// Nos esperamos que el minigame1 se haya cargado en memoria
			if (loadMinigames.isMinigame1Loaded()){
				if (loadMinigames.isLabelLoadingInStage()){
					loadMinigames.delSceneLabelLoading(stage);
				}
				screenMiniGame1 = loadMinigames.getMinigame1();				
				screenMiniGame1.setInitInformation(gameData,powerFail,backUp);
				stage.addChild(screenMiniGame1);
				screenMiniGame1.init();
				screenGame.clean();
				switchSystemState(GameStates.STATE_SYSTEM_RUN_MINIGAME_1);
			}else{
				if (!loadMinigames.isLabelLoadingInStage()){
					loadMinigames.addSceneLabelLoading(stage);
				}
			}
		}
		//*****************************************************************************************************************************
		public function systemRunMiniGame1():void {
			screenMiniGame1.run();
			if (screenMiniGame1.isMinigameFinished()){
				switchSystemState(GameStates.STATE_SYSTEM_FINISH_MINIGAME_1);
			}
		}
		//*****************************************************************************************************************************
		public function systemFinishMiniGame1():void {
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME);
		}
		//*****************************************************************************************************************************
		//********************************************* MINI GAME 2 *******************************************************************
		//*****************************************************************************************************************************
		public function systemInitMiniGame2():void {
			// Nos esperamos que el minigame2 se haya cargado en memoria
			if (loadMinigames.isMinigame2Loaded()) {
				if (loadMinigames.isLabelLoadingInStage()){
					loadMinigames.delSceneLabelLoading(stage);
				}
				
				screenMiniGame2 = loadMinigames.getMinigame2();
				screenMiniGame2.setInitInformation(gameData,powerFail,backUp);
				stage.addChild(screenMiniGame2);
				screenMiniGame2.init();
				screenGame.clean();
				switchSystemState(GameStates.STATE_SYSTEM_RUN_MINIGAME_2);
			}else{
				if (!loadMinigames.isLabelLoadingInStage()){
					loadMinigames.addSceneLabelLoading(stage);
				}
			}
		}
		//*****************************************************************************************************************************
		public function systemRunMiniGame2():void {
			screenMiniGame2.run();
			if (screenMiniGame2.isMinigameFinished()){
				switchSystemState(GameStates.STATE_SYSTEM_FINISH_MINIGAME_2);
			}
		}
		//*****************************************************************************************************************************
		public function systemFinishMiniGame2():void {
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME);
		}
		//*****************************************************************************************************************************
		//********************************************* MINI GAME 3 *******************************************************************
		//*****************************************************************************************************************************
		public function systemInitMiniGame3():void {
			// Nos esperamos que el minigame3 se haya cargado en memoria
			if (loadMinigames.isMinigame3Loaded()){
				if (loadMinigames.isLabelLoadingInStage()){
					loadMinigames.delSceneLabelLoading(stage);
				}
				
				screenMiniGame3 = loadMinigames.getMinigame3();
				screenMiniGame3.setInitInformation(gameData,powerFail,backUp);
				stage.addChild(screenMiniGame3);
				screenMiniGame3.init();
				screenGame.clean();
				//switchSystemState(GameStates.STATE_SYSTEM_PRE_RUN_MINIGAME_3);
				switchSystemState(GameStates.STATE_SYSTEM_RUN_MINIGAME_3);
			}else{
				if (!loadMinigames.isLabelLoadingInStage()){
					loadMinigames.addSceneLabelLoading(stage);
				}
			}
		}
		//*****************************************************************************************************************************
		/*
		public function systemPreRunMiniGame3():void {
			screenMiniGame3.run();
			Este método sirve para NO limpiar la pantalla previa (GAME), hasta que el titulo inicial se haya mostrado del todo: alpha = 1
			if (screenMiniGame3.isTitleShowed()){
				screenGame.clean();
				switchSystemState(GameStates.STATE_SYSTEM_RUN_MINIGAME_3);				
			}
		}
		*/
		//*****************************************************************************************************************************
		public function systemRunMiniGame3():void {
			screenMiniGame3.run();
			if (screenMiniGame3.isMinigameFinished()){
				switchSystemState(GameStates.STATE_SYSTEM_FINISH_MINIGAME_3);
			}
		}
		//*****************************************************************************************************************************
		public function systemFinishMiniGame3():void {
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME);
		}				
		//*****************************************************************************************************************************
		//********************************************* MINI GAME 4 *******************************************************************
		//*****************************************************************************************************************************
		public function systemInitMiniGame4():void {
			// Nos esperamos que el minigame3 se haya cargado en memoria
			if (loadMinigames.isMinigame4Loaded()){
				if (loadMinigames.isLabelLoadingInStage()){
					loadMinigames.delSceneLabelLoading(stage);
				}
				
				screenMiniGame4 = loadMinigames.getMinigame4();
				screenMiniGame4.setInitInformation(gameData,powerFail,backUp);
				stage.addChild(screenMiniGame4);
				screenMiniGame4.init();
				switchSystemState(GameStates.STATE_SYSTEM_RUN_MINIGAME_4);
			}else{
				if (!loadMinigames.isLabelLoadingInStage()){
					loadMinigames.addSceneLabelLoading(stage);
				}
			}			
		}
		//*****************************************************************************************************************************
		public function systemRunMiniGame4():void {
			screenMiniGame4.run();
			if (screenMiniGame4.isMinigameFinished()){
				switchSystemState(GameStates.STATE_SYSTEM_FINISH_MINIGAME_4);
			}
			
		}
		//*****************************************************************************************************************************
		public function systemFinishMiniGame4():void {
			switchSystemState(GameStates.STATE_SYSTEM_INIT_GAME);
		}		
		//*****************************************************************************************************************************		
		//*****************************************************************************************************************************		
		//*****************************************************************************************************************************		
	}
}