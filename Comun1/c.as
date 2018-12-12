package  {
	//*****************************************************************************************************************************************************
	// Esta clase contiene información de todo tipo de forma unificada, variables, contantes, etc. Se consultarán en cualquier punto del programa. 
	public class c{
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//********************** Variables globales de configuracion, dependiendo de que versión queramos compilar **************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		public static const versionLocal:Boolean	= false;
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************		
		public static const BROWSER_LUCKHAND:int  	= 1;
		public static const BROWSER_SMI:int  		= 2;
		public static const MICROSOFT_EXPLORER:int 	= 3;
		public static const BROWSER_WEB:int			= 4;
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		public static var contenedorFlash:int					= 0;		// 1: Browser Luckhand    2:Browser SMI    3:Microsoft Explorer    4:Browser WEB
		public static var tipoEjecucion:String					= "";		// tipoEjecucion 
																			//				0 BROWSER LUCKHAND
																			//				1 BROWSER LUCKHAND (mostrando logs)
																			//				2 MICROSOFT EXPLORER
																			//				3 MICROSOFT EXPLORER (mostrando logs)
																			//				4 BROWSER SMI
																			//				5 BROWSER SMI (mostrando logs)		
		
		public static var opcionBETA:Boolean					= false;	// Si queremos mostrar o no, los botones GNA, AUTO, y los textField (log, memory, fps,...)		
		public static var inhabilitarFuncionTrace:Boolean		= true;		// Si queremos habilitar o no, las llamadas a la funcion trace(...) cuando imprimimos las cadenas power fail.
		public static var inhabilitarBotonSalir:Boolean 		= false;	// Si queremos inhabilitar el boton salir
		public static var botonSalirWhithBrowser:Boolean 		= true;		// True:  si queremos salir utilizando la comunicacion con el browser
																			// False: si queremos salir directamente direccionando la url
		public static var inhabilitarBotonCobrar:Boolean 		= false;	// Si queremos inhabilitar el boton Cobrar SI N0 (para que no se quede esperando, cuando no estemos ejecutando en un browser normal)
		public static var getIdMaquinaManual:Boolean 			= false;	// Si queremos que el idMaquina lo recoja del html (flashvars), o que sea introducido manualmente por el jugador (modo tester)
		public static var maquinaInicial:String 				= "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"; // En caso de que introduzcamos el idMaquina manualmente. Por defecto, aparecerá el idMaquina que pongamos aquí.
		public static var phpEnLocalhost:Boolean 				= false;	// Para indicarle si los php tiene que cogerlos de localhost o no.	 
		public static var ignorarPowerFail:Boolean 				= false;	// Ignorar la recuperacion del powerFail en el inicio, es decir, si hay powerFail pendiente de la partida anterior, que sea ignorado.
		public static var ignorarPowerFailLocal:Boolean 		= false;  	// Ignorar salvar powerfail LOCAL (SharedObject) y también evita la recuperacion del powerFail LOCAL (SharedObject) en el inicio del juego.
		public static var loadMinigameLocal:Boolean 			= false;  	// Cargar los miniGames desde local. Esta opcion solo tiene sentido si los juegos están en swf separados. Si no es así, da igual el valor de esta variable.
		public static var pasarCreditosAlBrowser:Boolean		= false;    // Para pasar los creditos actuales que estamos mostrando en pantalla al browser
		public static var notificarBrowserPagoGuardado:Boolean 	= false; 	// Si tenemos que notificamos al browser que hemos guardado el PAGO en la base de datos (tabla user_credits)
		public static var controlClickPanelPrintError:Boolean 	= false; 	// Si tenemos que detectar algun comportamiento en caso que pulsemos encima del panel PRINT ERROR
		public static var controlInsertCreditsBrowser:Boolean 	= false; 	// Si queremos que se controle la insercion de creditos por parte de un contenedor (browser)
		public static var nombreMaquina:String                  = "";       // Nombre de la maquina que estamos utilizando para jugar (Para version explorerer)
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		public static var durationShowTitleInitial:int = 90; 		// Duracion en la que se mostrará el titulo del juego cuando entramos por primera vez.
		public static var timeMaxWaitShowNotEnoughCredit:int = 180; // Tiempo que esperaremos antes de mostrar el mensaje de que no hay suficiente credito.		
		public static var timeQuitGameNotEnoughCredit:int = 3600;   // Tiempo que esperaremos antes de salir del juego porque no hay suficiente credito. (1 minuto)
		public static var timeQuitGameInactividad:int = 5 * 3600;   // Tiempo que esperaremos antes de salir del juego porque no hay actividad. (5 minutos)
		public static var timeQuitHelpInactividad:int = 2 * 3600;   // Tiempo que esperaremos antes de salir del menu porque no hay actividad.  (2 minutos)
		
		public static var timeShowMsgNotConnected:int = 300;     	// Tiempo prudencial que esperaremos antes de mostrar el mensaje NOT CONNECTED, cuando los rodillos están rodando (300 tincs = 5 segundos).
		//public static var timeMaxSecurityLoader:int   = 16;		 	// variable utilizada en las clases: ObtenerJugada, SalvarCreditos y SalvarJackpot. Tiempo que espera como maximo para resolver un llamada Loader a un php
		//public static var timeMaxSecurityLoader_2:int = 12;		 	// Como la variable anterior, pero con menos tiempo. La utilizaremos en initializing
		//public static var timeIncSecurity:int    	  = 1;		 	// Tiempo que vamos a esperar de más, una vez el event progress ha completado la carga y esperamos que dispare el evento completed.
		public static var contTimeWaitToPrint:int	  = 60 * 30;	// Tiempo maximo de espera antes de mostrar el mensaje PRINTER ERROR (error de impresion ticket)
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		// localhoat_1 
		public static var rutaLocalHost:String = "http://localhost:8080/"; // La direccion raiz de nuestro localhost. Puede variar segun como hayamos configurado los puertos de nuestro servidor
		// localhoat_2
		//public static var rutaLocalHost:String = "http://localhost/"; // La direccion raiz de nuestro localhost. Puede variar segun como hayamos configurado los puertos de nuestro servidor
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		// Nombre del juego
		// Ejemplos --> "Duende_de_la_suerte"    "Halloween_Night"       "The_Golden_Mine" 
		//              "Pirates_Treasure"       "Crazy_Farm_II"         "Billy_Joe_II" 
		//              "Magic_Forest_II"        "Bingo_Fortune_Sea"	 "Poker_Luck_Jackpot
		//
		//public static var nombreJuego:String = "Poker_Luck_Jackpot"; 
		public static var nombreJuego:String = "Play_Poker"; //"Poker_Luck_Jackpot"; 
		//***********************************************************************************************************************************************
		// Definimos el numero de idiomas que soporta el juego
	    public static var num_idiomas:int = 4;
		public static var PORTUGUESE:int  = 1;
		public static var ENGLISH:int 	  = 2;
		public static var SPANISH:int 	  = 3;
		public static var FRENCH:int 	  = 4;
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		// Los diferentes valores que puede tener la moneda 
	    //public static var tValorMoneda:Array  = [0.01]; //[0.01, 0.02, 0.05]; 
		
		
		//***********************************************************************************************************************************************
		//*********************                 ===============================================                      ************************************
		//*********************                     VALORES EXPORTADOS DEL JUEGO INDIVIDUAL                          ************************************
		//*********************                 ===============================================                      ************************************
		//***********************************************************************************************************************************************		
		/* ... */
		




		/* ... */
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************
		//***********************************************************************************************************************************************		
	}
	//*****************************************************************************************************************************************************	
}
