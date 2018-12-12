package  {
	//====================================================================================================================================================
	//                        Aqui almacenamos informacion generica del juego, que será accesible desde cualquier punto.	
	//====================================================================================================================================================
	public class GameData {
		//************************************************************************************************************************************************
		public static var instance:GameData = null;
		public var gameFPS:int;
		//************************************************************************************************************************************************
		public var pathMenu:String;  // Lugar dónde se encuentra el html/php del menú principal que cargaremos cada vez que pulsamos el botón salir.
		public var idMaquina:String; // Identificador del terminal que está ejecutando el juego. Ejemplo: "CC23E791-088D-4BC4-AC62-2BC9522584D0"
		public var idJuego:int; // Identificador el juego, será un valor único y preestablecido desde el inicio.
								// 1: Duende Magico          4: Pirates Treasure          7: Magic Forest II		10: Luck Jackpot (Poker)
								// 2: Golden Mine            5: Crazy Farm II			  8: Fortune Sea (Bingo)
								// 3: Halloween Night        6: Billy Joe II			  9: Show Luck (Bingo)
		public var nameMachine:String;  // Nombre de la máquina. Campo MachineName de la tabla Machines.
		//************************************************************************************************************************************************
		public var cliente:int;     // Cliente desde donde se está ejecutando el browser
									// 0: Madrid
									// 1: Luxemburgo (LX)
									// 2: Portugal	 (PT)
									// 3: Brasil 
		public var IdSessionGameWeb:Number; // Para identificar que sesion de juego está habilitada para esta maquina en la version WEB. Para evitar duplicidad
											// de sesiones con uma misma maquina
		public var regionHoraria:String; //Region horaria
										 //		"Europe/Madrid"
										 //		"Europe/Luxembourg"
										 //		"Europe/Lisbon"									
		//************************************************************************************************************************************************
		//===================
		// Calculo de FPS
		//===================
		public var deltaTime:Number;   	
		public var currentTime:Number; 	
		public var currentTime2:Number; 
		public var contFPS:int; 		
		public var newFPS:Boolean; 		
		//************************************************************************************************************************************************
		//=============
		// GENERICO
		//=============		
		public var credits:int; 			// Guarda la cantidad de creditos disponibles
		public var creditsGain:int; 		// Guarda la cantidad de creditos obtenidos con los premios
		public var ultimoPremioPagado:int;  // Guarda la cantidad de creditos que hemos pagado en la ultima jugada
		public var creditsGainMiniGame:int; // Guarda la cantidad de creditos obtenidos en el ultimo minijuego juego
		public var bet:int;					// Guarda la apuesta total realizada en cada partida. 
		public var imagenMoneda:int;		// Guarda la imagen del frame del movieClip de la moneda										    
		public var valorDenominacion:int;// Valor en céntimos de un credito
		public var t_imagenMoneda:Array;			// Lista de frames del movieClip para la imagen moneda
		public var t_valorDenominacion:Array;	// Lista de los distintos valores de la moneda
		
		public var idioma:int;				// Idioma seleccionado en el juego. 1: Portugués
											//									2: Inglés
											//									3: Español
											//									4: Francés
		public var t_lista_idiomas:Array;	// En esta tabla se almacenarán los idiomas disponibles que contiene el juego
											// El primer idioma será el que se cargue por defecto												
		public var t_idioma:Array;			// Se almacenará el frame del moviclip que le corresoponde  al idioma. 
											// El indice de la tabla corresponderá al idioma (1:Portugues, 2:Ingles, 3:Español, 4:Frances).	
											// La primera posición siempre será 0.
											// Ejemplo: [0, 5, 2, 0, 4] => El idioma 1 (Portugués) le corresponde el frame 5 del moviclip mc_buttonFlag
											//                             El idioma 2 (Inglés) le corresponde el frame 2 del moviclip mc_buttonFlag
											//                             El idioma 3 (Español) no está habilitado
											//                             El idioma 4 (Frances) le corresponde al frame 4 del moviclip mc_buttonFlag
		//************************************************************************************************************************************************
		public var valor_centimos_de_un_credito:int;	// Segun la moneda (divisa), Un credito puede tener diferente valor en céntimos
														// Euro: 1 Crédito -> 1    Centimo
														// Peso: 1 Crédito -> 1000 Centimo											
		//************************************************************************************************************************************************
		public var tipo_visualizacion_creditos:int;	// Expresa como deseamos ver todo lo relacionado a los creditos
													// 0: Formato créditos
													// 1: Formato Euros (€)														
		//************************************************************************************************************************************************											
		public var creditos_in_browser:int; // Posibles creditos insertados en browser. Se utilizará si había un powerfail en el juego y tengamos que
											// restaurar los creditos añadiendo la cantidad en esta variable a los creditos guardados en el powerfail											
		public var dif_timeStampServer:Number; // Diferencia entre el timeStamp del ordenador local y el servidor																		
		public var tecla_ESC:Boolean;		// true:   Tecla ESC activada
											// false:  Tecla ESC no activa															
		//=============
		// JACKPOT
		//=============
		public var jackpotAcumulated:Number;	// Cantidad actual acumulada en JACKPOT
		public var apuestaMinima:Number;		// Apuesta mínima para la cual se activa la opción de jugar.
		public var incremetoJackpot:Number;		// Porcentage de incremento % de la apuesta actual al jackpot
		public var valorJackpotInicial:Number;	// Valor inicial con el que resetearemos el jackpot una vez que haya salido.
		public var valorJackpotMaximo:Number;	// Valor maximo al que puede llegar el jackpot, a partir de ese valor ya no seguiremos incrementando.
		public var literal_moneda_jackpot:String;	// String que vamos a poner al lado del valor jackpot, dentro del juego (#, CPL, etc..)
		//=============
		//   BONUS
		//=============
		// Parametros referentes a los premios de los diferentes bonus del juego
		public var venimosDeBonus:Boolean;  // Para saber si venimos de un bonus o no
		// BONUS_1: Almacenamos el premio que debemos generar para el bonus 1
		public var premioBonus1:int;		   
		// BONUS_2: Almacenamos el premio que debemos generar para el bonus 2
		public var premioBonus2:int;		   
		// BONUS_3: Almacenamos el premio que debemos generar para el bonus 3
		public var premioBonus3:int;	
		// BONUS_4: Almacenamos el premio que debemos generar para el bonus 4
		public var premioBonus4:int;	
		//
		
		//============================
		//   PARAMETROS SMI
		//============================
		public var multiJuego_SMI:Boolean;			// 0: false --> Maquina que solo contiene un único juego
													// 1: true  --> Maquina que contiene un pack de juegos con su correspondiente menú.
		public var displayAspectRatio_SMI:String;	// Diferentes tipos de ratio del monitor:  "5:4",  "4:3",   "16:10",   "16:9"
		public var tipoMaquina_SMI:int;				// 0:    Multiluck España
													// 1:    Casinos (en formato créditos)
													// 2:    Casinos (en formato créditos – Euros, intercambiables)
		
		//============================
		//   POWER FAIL
		//============================
		
		public var autohold:Boolean = true;
		public var GNA:int = 1;		// 0 modo pruebas
									// 1 modo real
		public var idJugada:int;
		public var multiplier:int;
		public var lastPrize:int;
		
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		public function GameData() {
			if (!instance) {
				instance = this;
			}
			
			gameFPS		 		= 60;
			
			idJuego				= 11;			// 11: PlayPoker (Poker)
			
			nameMachine			= "";			// MachineName de la tabla Machines	
			cliente             = 0;			// 0 (Madrid), 1 (Luxemburgo), 2 (Portugal), 3 (Brasil)
			IdSessionGameWeb    = 0;
			regionHoraria		= "";
			idioma				= c.PORTUGUESE; // Por defecto, inicializamos el juego en idioma Portugués
			t_lista_idiomas		= [1,2,3,4];
			t_idioma 			= [0,1,2,3,4];
			
			venimosDeBonus      = false;
			
			credits 			 = 0; 			
			creditsGain 		 = 0;
			ultimoPremioPagado   = 0;
			creditsGainMiniGame  = 0;
			bet					 = 1;
			imagenMoneda 		 = 1;			// Asociamos el frame del moviClip del botón de la moneda
			valorDenominacion 	 = 10;          // Valor en centimos de un crédito
			t_imagenMoneda		 = [];
			t_valorDenominacion  = [];									
			creditos_in_browser  = 0;
			dif_timeStampServer  = 0;
			tecla_ESC			 = true;
			
			jackpotAcumulated	= 0.0;			// Jackpot actual acumulado en la maquina
			apuestaMinima		= 0.0;			// Apuesta mínima para poder acceder al jackpot
			incremetoJackpot	= 0.0;			// % incremento al jackpot sobre la apuesta actual
			literal_moneda_jackpot = "";		// String que vamos a poner al lado del valor jackpot, dentro del juego (#, CPL, etc..)
			valor_centimos_de_un_credito = 0;   // Valor en céntimos de un credito según el tipo de moneda del país (EURO [1 Credito -> 1 Centimo], PESO [1 Credito -> 1000 Centimos])
			tipo_visualizacion_creditos	 = 0;	// Expresa como deseamos ver todo lo relacionado a los creditos
												// 0: Formato créditos
												// 1: Formato Euros (€)			
			valorJackpotInicial = 0.0;			// Valor inicial con el que se restaurará el jackpot cada vez que lo obtengamos.
			valorJackpotMaximo  = 0.0;			// Valor límite maximo en el que el jackpot dejará de incrementarse
					
			premioBonus1        = 0;
			premioBonus2		= 0; 
			premioBonus3		= 0;
			premioBonus4		= 0;
			
			//------ Parametros SMI -------
			multiJuego_SMI			= true;
			displayAspectRatio_SMI	= "";
			tipoMaquina_SMI			= 0;
			//-----------------------------
			
			deltaTime	 		= 0.0;  
			currentTime  		= 0.0;  
			currentTime2 		= 0.0;  
			contFPS		 		= 0;	 
			
		}
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
	}
	
}
