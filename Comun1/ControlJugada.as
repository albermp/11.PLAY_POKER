package  {
	// Esta clase nos permite generar secuencias ganadoras para los slots, con bonus, sin bonus, segun las lineas de apuesta activas, etc..
	public class ControlJugada{
		private var cardDeck:Array;
		private var tPosiblesValoresCarta:Array;
		/*
		[[Cell.simbol1,Cell.simbol2,Cell.simbol3,Cell.simbol4,Cell.simbol5,Cell.simbol6,Cell.simbol7,Cell.cellComodin,Cell.cellBonus1,Cell.cellBonus3,Cell.cellBonus4,Cell.cellBonus5],	//slot 1
		 [Cell.simbol1,Cell.simbol2,Cell.simbol3,Cell.simbol4,Cell.simbol5,Cell.simbol6,Cell.simbol7,Cell.cellBonus1,Cell.cellBonus3,Cell.cellBonus4,Cell.cellBonus5],									//slot 2
		 [Cell.simbol1,Cell.simbol2,Cell.simbol3,Cell.simbol4,Cell.simbol5,Cell.simbol6,Cell.simbol7,Cell.cellBonus1,Cell.cellBonus2,Cell.cellBonus3,Cell.cellBonus4,Cell.cellBonus5],					//slot 3
		 [Cell.simbol1,Cell.simbol2,Cell.simbol3,Cell.simbol4,Cell.simbol5,Cell.simbol6,Cell.simbol7,Cell.cellBonus2,Cell.cellBonus3,Cell.cellBonus4,Cell.cellBonus5],									//slot 4
		 [Cell.simbol1,Cell.simbol2,Cell.simbol3,Cell.simbol4,Cell.simbol5,Cell.simbol6,Cell.simbol7,Cell.cellBonus2,Cell.cellBonus3,Cell.cellBonus4,Cell.cellBonus5]];		 							//slot 5
		*/
		
		//private var groupSlots:GroupSlots;
		//private var groupButtonsBetLines:GroupButtonsBetLines;
		private var gd:GameData;
		
		
		//* parametros que consultaremos fuera de clase, obtenido de la decodifación de un string *
		public var t_JugadaFinal:Array;
		public var premioJugada:int;
		public var idBonus:int;
		// bonus 1
		public var premioBonus1:int;
		// bonus 2
		public var premioBonus2:int;
		// bonus 3
		public var premioBonus3:int;
		/*
		public var hastafase1:Boolean;
		public var hastafase2:Boolean;
		public var hastafase3:Boolean;
		public var hastafase4:Boolean;
        public var premioFase1:int;
        public var premioFase2:int;
        public var premioFase3:int;
        public var premioFase4:int;
		*/
		// jackpot
		public var premioJackpot:Number;
		//****************************************************************************************************************************************
		public function ControlJugada(gdParam:GameData) {
			gd 		= gdParam;
			
			cardDeck = new Array();
			for (var i:int = 0; i < 53; i++) cardDeck.push(i);
			
			tPosiblesValoresCarta = new Array();
			for (var i:int = 0; i < 10; i++) tPosiblesValoresCarta.push(cardDeck);
		}
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		
		// CARLOS
		//public function setGroupSlots(gs:GroupSlots):void{
			//groupSlots = gs;
		//}
		
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		
		// CARLOS
		//public function setGroupBetLines(gbl:GroupButtonsBetLines):void{
			//groupButtonsBetLines = gbl;
		//}
		
		//****************************************************************************************************************************************
		//******************************************** PUBLIC FUNCTIONS **************************************************************************
		//****************************************************************************************************************************************
		// Generamos una tirada totalmente aleatoria. La utilizaremos para inicilizar el juego la primera vez que arranquemos.
		public function generateSequenceRandom():Array{
			// La jugada se creará aleatoriamente con algunas reestricciones:
			//     - No se creará nunca carril con un mismo simbolo repetido más de una vez.
			var tFinal:Array = new Array(); // tabla final que devolveremos con la jugada aleatoria (5 railes x 3 filas)
			var tSlot:Array;
			var val1,val2,val3:int; // valores para la fila 1, 2 y 3, para cada uno de los carriles (slots);
			
			for(var i:int=0;i<5;i++){ // recorresmo los 5 carriles (slots);
				tSlot = new Array();
				// El primer simbolo se coge aleatoriamente
				//val1 = tPosiblesValoresSlot[i][Math.floor(Math.random()*tPosiblesValoresSlot[i].length)];
				val1 = tPosiblesValoresCarta[i][Math.floor(Math.random()*tPosiblesValoresSlot[i].length)];
				
				// El segundo simbolo se coge aleatoriamente, pero no puede ser ninguno creado anteriormente en las filas superiores
				do{
					val2 = tPosiblesValoresSlot[i][Math.floor(Math.random()*tPosiblesValoresSlot[i].length)];
				}while (val2 == val1); // Cualquier simbolo
				//}while (isBonus(val2) && (val2 == val1)); // Solo realizamos este tratamiento en los bonus
				
				// El segundo simbolo se coge aleatoriamente, pero no puede ser ninguno creado anteriormente en las filas superiores
				do{
					val3 = tPosiblesValoresSlot[i][Math.floor(Math.random()*tPosiblesValoresSlot[i].length)];
				}while ((val3 == val1) || (val3 == val2)); // Cualquier simbolo
				//}while (/*isBonus(val3) &&*/ ((val3 == val1) || (val3 == val2))); // Solo realizamos este tratamiento en los bonus
				
				tSlot = [val1,val2,val3];
				tFinal.push(tSlot);
			}
			
			return tFinal;
		}
		//****************************************************************************************************************************************
		// Comprueba si el GNA nos envia (idBonus != 5), y en cambio los simbolos a mostrar nos envia 5 jackpots. Cambiamos uno de ellos.
		public function reformatear_jackpot(t_JugadaFinal:Array, idBonus:int):Array{
			// Caso especial: Si el GNA nos envia que no hay jackpot (idBonus != 5), pero nos envia una jugada con 5 simbolos jackpot. 
			// Forzamos el cambiamos unos de lo simbolos
			if ((idBonus != 5) && (yaHaySimbolosJackpot(t_JugadaFinal))){
				// Quitamos uno de los simbolos jacktpo en el primer rodillo
				if (t_JugadaFinal[0][0] == c.Jackpot) t_JugadaFinal[0][0] = 0;
				if (t_JugadaFinal[0][1] == c.Jackpot) t_JugadaFinal[0][1] = 0;
				if (t_JugadaFinal[0][2] == c.Jackpot) t_JugadaFinal[0][2] = 0;
			}
			return t_JugadaFinal;
		}
		//****************************************************************************************************************************************
		public function decodificarJugada(sJugada:String):Boolean{
			// ENTRADA
			//   sJugada: s1*s1*s1*s2*s2*s2*s3*s3*s3*s4*s4*s4*s5*s5*s5;
			//            Cada tres numero es una combinacion de slot a mostrar, con los simbolos correspondientes.
			// SALIDA
			//   True:  La decodifiacion ha ido bien
			//   False: Ha habido algún tipo de error en la decodifiacion. El premio que envia el GNA no coincide con el que calcula la parte gamePlay.
			var i,i2,bonus:int;
			
			var tCod:Array = sJugada.split("*"); 
			
			var numParametros:int=tCod.length;
			
			t_JugadaFinal = [[int(tCod[0]),  int(tCod[1]),  int(tCod[2])],
							 [int(tCod[3]),  int(tCod[4]),  int(tCod[5])],
							 [int(tCod[6]),  int(tCod[7]),  int(tCod[8])],
						     [int(tCod[9]),  int(tCod[10]), int(tCod[11])],
					         [int(tCod[12]), int(tCod[13]), int(tCod[14])]];
							 
			premioJugada  = int(tCod[15]);
			idBonus		  = int(tCod[16]);

			// Premio enviado por el GNA
			// Según si el GNA nos envia el premio multiplicado o no por la apuesta, lo hacemos ahora.
			if (!c.linea_gna_multiplicada_apuesta){
				premioJugada *= gd.betByLine;
			}
			// Según si el GNA nos envia el premio multiplicado o no por el multiplicado de free games, lo hacemos ahora.
			/*
			if (gd.cfg.isFreeGamesActivated()){
				if (!c.linea_gna_multiplicada_mult_FG){
					premioJugada *= gd.cfg.fg_multiplicador;
				}
			}
			*/
			
			// Premio calculado por el propio juego
			// comprobamos que la jugada que nos envia el GNA (premioJugada), es igual al que el gamePlay calcula.
			var calculoPremioLineas:int = premioObtenido(t_JugadaFinal) * gd.betByLine;			
			// Si los free games están activos, el premio debe multiplicarse además por el multiplicador de los free games.
			/*
			if (gd.cfg.isFreeGamesActivated()){
				calculoPremioLineas *= gd.cfg.fg_multiplicador;
			}
			*/
			
			//trace(premioJugada, calculoPremioLineas);
			
			if (premioJugada != calculoPremioLineas){
				return false;
			}else{
				inicializaPremiosBonus();			
				switch(idBonus){
					case 0: // No hay bonus
						break;
					case 1: // Bonus Cauldron
						//0*0*9*0*0*9*0*0*9*0*0*0*0*0*0*0*1*7
						premioBonus1  = int(tCod[17]);
						// validamos que el premio del bonus sea multiplo de la apuesta total.
						if (premioBonus1 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;
						break;
					case 2: // Bonus Magic
						//0*0*0*0*0*0*0*0*12*0*12*0*12*0*0*0*2*17
						premioBonus2  = int(tCod[17]);
						// validamos que el premio del bonus sea multiplo de la apuesta total.
						if (premioBonus2 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;						
						break;				
					case 3: // Bonus Pumpkin					
						//0*0*0*0*0*0*0*0*12*0*12*0*12*0*0*0*3*17
						premioBonus3  = int(tCod[17]);
						// validamos que el premio del bonus sea multiplo de la apuesta total.
						if (premioBonus3 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;						
						break;				
						/*				
						//0*11*0*0*0*11*0*11*0*0*0*11*11*0*0*0*3*225*1*200*1*625*1*2500
						hastafase1		 = true;
						premioFase1		 = int(tCod[17]);
						if (numParametros-1 >= 18) hastafase2	= converIntToBool(int(tCod[18]));
						if (numParametros-1 >= 19) premioFase2	= int(tCod[19]);
						if (numParametros-1 >= 20) hastafase3	= converIntToBool(int(tCod[20]));
						if (numParametros-1 >= 21) premioFase3  = int(tCod[21]);
						if (numParametros-1 >= 22) hastafase4   = converIntToBool(int(tCod[22]));
						if (numParametros-1 >= 23) premioFase4  = int(tCod[23]);	
						
						// Validamos que el premio del bonus sea multiplo de la apuesta total.
						if (premioFase1 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;
						if (premioFase2 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;
						if (premioFase3 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;
						if (premioFase4 % (gd.betByLine * gd.lastBetLineActived) != 0) return false;
						*/
						break;
					case 4: 
						break;
					case 5: // Jackpot
						// 0*7*0*7*0*0*0*0*0*0*0*0*0*0*0*900*5*1212.5000
						//
						// En caso de jackpot, la parte gameplay se encarga de poner los simbolos jackpot de forma aleatoria en los rodillos.
						// El GNA nos pone en la jugada el jackpot acumulado, tenemos que recuperarlo de ahí (posicion 17) ==> premioJackpot
						if (yaHaySimbolosJackpot(t_JugadaFinal)){
							premioJackpot = Number(tCod[17]);
						}else{
							if (sePuedePonerSimbolosJackpot(t_JugadaFinal)){ // validamos que realmente podemos poner simbolos jackpot
								premioJackpot = Number(tCod[17]);
								t_JugadaFinal = ponerSimbolosJackpot(t_JugadaFinal);
							}else
								return false;
						}
						break;
					default:
						break;
				}
				return true;
			}
		}
		//****************************************************************************************************************************************
		public function completarJugada(tJugada:Array):Array{
			// A partir de una jugada con solo unas lineas de apuesta activas, rellenar el resto de casillero sin alterar el premio total
			// tJugada: tabla 5x3 Ejemplo  0 0 2 0 0
			//                             2 2 0 2 2
			//                             0 0 0 0 0
			// devolvemos null en caso que la jugada completada no sea valida. En caso contrario, devolvemos la jugada en un array.
			var t:Array;
			var cont:int = 0;
			var premio,nBonus,premio2,nBonus2:int;
			var numSimbBonusActivo, numSimbBonusActivo2:int;
			var t_BonusAntes,t_BonusDespues:Array;
			
			// obtenemos los resultado a partir de la tabla que nos llega del GNA
			premio  	 = premioObtenido(tJugada);  // Premios de las lineas
			
			t_BonusAntes 		= numBonusActivos(tJugada); // Bumero de bonus activo. Será 0 o 1.
			nBonus		 		= t_BonusAntes[0]; // numero de bonus activos
			numSimbBonusActivo 	= t_BonusAntes[1]; // numero de simbolos que hacen bonus. A veces un bonus puede salir con 3,4 o 5 simbolos, dando diferentes premios en cada caso.
			
			// rellenamos la tabla con valores aleatorios
			t = clonarJugada(tJugada);
			rellenarJugadaAleatoria(t); // rellenamos jugada, evitando volver a poner simbolos bonus ganadores. Así el bonus se vea más claramente.
			premio2 = premioObtenido(t)
			
			t_BonusDespues 		= numBonusActivos(t);
			nBonus2 			= t_BonusDespues[0];
			numSimbBonusActivo2 = t_BonusDespues[1];
			
			cont++;
			
			// si la jugada completada no es valida (porqué sin querer hemos puesto más premios o más bonus), devolvemos null
			if ((premio!=premio2) || (nBonus!=nBonus2) || (numSimbBonusActivo!=numSimbBonusActivo2))
				return null;
			// si la jugada completada es valida, la devolvemos en una tabla
			else										
				return t;
		}
		//****************************************************************************************************************************************
		// Validamos que realmente podemos poner simbolos jackpot
		private function sePuedePonerSimbolosJackpot(t:Array):Boolean{
			for(var i:int=0;i<t.length;i++){
				if ((t[i][0]!=0) && (t[i][1]!=0) && (t[i][2]!=0)){
					return false;
				}
			}
			return true;
		}
		//****************************************************************************************************************************************
		// Validamos si ya están puestos los 5 simbolos, por el caso de que vengamos de un powerfail dónde nosotros hayamos puestos los simbolos anteriormente.
		private function yaHaySimbolosJackpot(t:Array):Boolean{
			var tCountSpecialCells:Array = Metodo.countScatterCells(t);			
			if (tCountSpecialCells[5]>=c.minEqualsBonus5)
				return true;
			else
				return false;
		}		
		//****************************************************************************************************************************************
		// Cuando recibimos una jugada con jackpot, la parte gameplay se encarga de poner los simbolos jackpot
		private function ponerSimbolosJackpot(t:Array):Array{
			var i,j:int;
			
			// Ponemos los simbolos jackpot aleatoriamente
			for(i=0;i<t.length;i++){
				// Comprobamos si en el slot actual, no hay ningun simbolo jackpot. En caso de que haya alguno (enviado por el GNA),
				// nosotros no tendremos que poner ninguno y pasaremos al siguiente slot.
				if ((t[i][0] != Cell.cellBonus5) && (t[i][1] != Cell.cellBonus5) && (t[i][2] != Cell.cellBonus5)){				
					var v_aleatorio:int;
					do{
						v_aleatorio = Math.floor(Math.random()*3);
					}while(t[i][v_aleatorio]!=0);
					t[i][v_aleatorio] = Cell.cellBonus5;
				}
			}
			
			return t;
		}
		
		//****************************************************************************************************************************************
		public function extraerPremioTotalJugada(sJugada:String):int{
			// A partir de una jugada en formato GNA, extraemos el premio total.
			var premioTotal:int=0;
			
			var tCod:Array = sJugada.split("$"); 
			for(var i:int=0;i<tCod.length;i++){
				var tCod_1:Array = tCod[i].split("*"); 
				
				// En las jugadas que activan más free games dentro de los free games, el GNA añadirá una letra al inicio de la secuencia
				// para que sepamos cuantos free games se han obtenido. Hay que tener en cuenta esto, para saltarse esta posición y no tratarla.
				var ini:int=0;
				if ((tCod_1[0]=="F") || //---> "F" --> 15 free games más dentro de los free games
					(tCod_1[0]=="G") || //---> "G" --> 20 free games más dentro de los free games
					(tCod_1[0]=="H"))   //---> "H" --> 25 free games más dentro de los free games
						ini=1;
				
				//===================================
				// Miramos los premios de las lineas
				//===================================
				var premio_lineas:int = 0;
				// Si el GNA no nos ha multiplicado por la apuesta, lo hacemos nostros ahora. En caso contrario, lo cogemos directamente.
				premio_lineas = int(tCod_1[15+ini]);
				
				if (!c.linea_gna_multiplicada_apuesta){
					premio_lineas *= gd.betByLine;
				}
				
				// Según si el GNA nos envia el premio multiplicado o no por el multiplicado de free games, lo hacemos ahora.
				// (i>0) --> se pone porqué no queremos que la primera juagada este afectado por el multiplicador de freegames.
				//           Es la jugada que genera los free games, pero aun no está dentro de los free games.
				if ((gd.cfg.isFreeGamesActivated()) && (i > 0)){
					if (!c.linea_gna_multiplicada_mult_FG){
						premio_lineas *= gd.cfg.fg_multiplicador;
					}
				}				
				
				//===================================
				// Miramos los premios de los bonus
				//===================================
				var premio_bonus:int = 0;
				switch(int(tCod_1[16+ini])){
					case 0: 
						break;
					case 1: 
					case 2:
						premio_bonus = int(tCod_1[17+ini]);
						break;
					case 3:
						premio_bonus = int(tCod_1[17+ini]);
						if (converIntToBool(int(tCod_1[18+ini])))	premio_bonus += int(tCod_1[19+ini]);
						if (converIntToBool(int(tCod_1[20+ini])))	premio_bonus += int(tCod_1[21+ini]);
						if (converIntToBool(int(tCod_1[22+ini])))	premio_bonus += int(tCod_1[23+ini]);
						break;
				}
				// Si estamos en free games y el GNA no nos envia el premios bonus multiplicado por el mult_FG, lo multiplicamos ahora
				if (!c.bonus_gna_mulitplicado_mult_FG){
					if (gd.cfg.isFreeGamesActivated()){
						premio_bonus *= gd.cfg.fg_multiplicador;
					}
				}
				premioTotal += premio_lineas; 
				premioTotal += premio_bonus;
				
			}
			return premioTotal;
		}
		//****************************************************************************************************************************************
		//******************************************** PRIVATE FUNCTIONS *************************************************************************
		//****************************************************************************************************************************************
		private function inicializaPremiosBonus():void{
			premioBonus1     = 0;
			premioBonus2     = 0;
			premioBonus3     = 0;
			/*
			hastafase1		 = false;
			premioFase1		 = 0;
			hastafase2		 = false;
			premioFase2		 = 0;
			hastafase3		 = false;
			premioFase3		 = 0;
			hastafase4		 = false;
        	premioFase4		 = 0;	
			*/
			premioJackpot    = 0.0;
		}
		//****************************************************************************************************************************************
		private function clonarJugada(tJugada:Array):Array{
			var jugadaClon:Array = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
			for (var slot:int=0;slot<tJugada.length;slot++){
				for (var fila:int=0;fila<tJugada[slot].length;fila++){
						jugadaClon[slot][fila] = tJugada[slot][fila];
				}
			}
			return jugadaClon;
		}		
		//****************************************************************************************************************************************
		private function rellenarJugadaAleatoria(tJugada:Array):void{
			// Esta funcion rellena una jugada con simbolos aleatorios, teniendo en cuenta de no mostrar más de un mismo simbolo en un mismo rail
			for (var slot:int=0;slot<tJugada.length;slot++){
				for (var fila:int=0;fila<tJugada[slot].length;fila++){
					if (tJugada[slot][fila] == 0){
						var valorCandidato:int = 0;
						var candidatoValido:Boolean = true;
						do{
							valorCandidato  = tPosiblesValoresSlot[slot][Math.floor(Math.random()*tPosiblesValoresSlot[slot].length)];
							candidatoValido = true; 
							// validamos que solo aparezca un mismo simbolo por carril. 
							switch(fila){
								case 0: // fila 1
									//if ((isBonus(valorCandidato)) || (isWild(valorCandidato))){
										if ((tJugada[slot][1]!=0) && (tJugada[slot][1]==valorCandidato)) candidatoValido = false;
										if ((tJugada[slot][2]!=0) && (tJugada[slot][2]==valorCandidato)) candidatoValido = false;
									//}
									break;
								case 1: // fila 2
									//if ((isBonus(valorCandidato)) || (isWild(valorCandidato))){
										if ((tJugada[slot][0]!=0) && (tJugada[slot][0]==valorCandidato)) candidatoValido = false;
										if ((tJugada[slot][2]!=0) && (tJugada[slot][2]==valorCandidato)) candidatoValido = false;
									//}
									break;
								case 2: // fila 3
									//if ((isBonus(valorCandidato)) || (isWild(valorCandidato))){
										if ((tJugada[slot][0]!=0) && (tJugada[slot][0]==valorCandidato)) candidatoValido = false;
										if ((tJugada[slot][1]!=0) && (tJugada[slot][1]==valorCandidato)) candidatoValido = false;
									//}
									break;
							}
						}while (!candidatoValido);
						// cuando hemos encontrado un candidato valido se lo asignamos a la tabla
						tJugada[slot][fila] = valorCandidato;
					}
				}
			}
		}
		//****************************************************************************************************************************************
		private function isBonus(valor:int):Boolean{
			if ((valor == Cell.cellBonus1) || 
				(valor == Cell.cellBonus2) || 
				(valor == Cell.cellBonus3) || 
				(valor == Cell.cellBonus4) ||
				(valor == Cell.cellBonus5))
				return true;
			else 
				return false;
		}
		private function isWild(valor:int):Boolean{
			if (valor == Cell.cellComodin)
				return true;
			else 
				return false;
		}
		//****************************************************************************************************************************************
		// Devuelve el premio obtenido a partir de una jugada
		// tJugada: tabla 5x3 Ejemplo  0 0 2 0 0
		//                             2 2 0 2 2
		//                             0 0 0 0 0		
		public function premioObtenido(tJugada:Array):int{
			var i,i2,premioTotal:int;
			premioTotal = 0;
			for(i=1;i<=groupButtonsBetLines.getLastBetLineActived();i++){
				var t1:Array = groupButtonsBetLines.getTableButtonsBetLinesObj()[i].getTableBetLine();
				var t2:Array = [0,0,0,0,0,0,0,0,0]; // 7 numeros posibles. La posicion 0 y 1 se pone para que el algoritmo quede más claro. No se tratarán.
				
				var numComodin:int = 0;
				var sLine:String = "";
				var valueId:int = tJugada[0][t1[0]];
				var simbolo_maestro:int = 0; // En caso de que la linea contenga comodines, guardamos el simbolo fijo (no comodin) por el que se tendrá que sustituir los comodines
				var ha_salido_simbolo_bonus:Boolean = false;
				for(i2=0;i2<t1.length;i2++){
					var v:int = tJugada[i2][t1[i2]];
					// normal simbols y no-simbol
					if ((v == 0) ||  ((v >= 2) && (v <= 8))){ 
						sLine += v;
						// Guardamos el primer simbolo que no sea comodin, ni bonus.
						if ((v >= 2) && (v <= 8)){
							if ((simbolo_maestro == 0) && (!ha_salido_simbolo_bonus))	simbolo_maestro = v;
						}												
					}
					// Comodin
					else if (tJugada[i2][t1[i2]] == Cell.cellComodin){
						sLine += "C";					
						numComodin ++;
					}
					// Bonus
					else if ((tJugada[i2][t1[i2]] == Cell.cellBonus1) || 
							  (tJugada[i2][t1[i2]] == Cell.cellBonus2) || 
							  (tJugada[i2][t1[i2]] == Cell.cellBonus3) || 
							  (tJugada[i2][t1[i2]] == Cell.cellBonus4) || 
							  (tJugada[i2][t1[i2]] == Cell.cellBonus5)){
						sLine += "B";					
						ha_salido_simbolo_bonus = true;
					}					
						
				}
				var valueWin,maxPrizeWin:int;
				valueWin 	= 0;
				maxPrizeWin = 0;
				
				// Si hay comodines se sutituyen solo por el simbolo capturada previamente: simbolo_maestro, que es el que manda
				var coincidencias:int = Metodo.getNumCellsEqual(sLine,simbolo_maestro,c.tMinEqualsCell[simbolo_maestro],c.idCellMaxValue);	
				if (coincidencias > 0){
					maxPrizeWin = c.tablePrizes[simbolo_maestro][coincidencias];
				}
				/*
				for(i2=t2.length-1;i2>0;i2--){ //analizamos todas las posibles combinaciones ganadoras para cada unos de los simbolos					
					t2[i2] = Metodo.getNumCellsEqual(sLine,i2,c.tMinEqualsCell[i2],c.idCellMaxValue);	
					//Nos quedamos con el valor que obtiene premio y además sea el premio más alto. Para detectar por que simbolo se debe sustituir el comodín
					//en caso de que haya comodin en la secuencia que se está analizando en ese momento.
					if ((t2[i2]>0) && (c.tablePrizes[i2][t2[i2]] >= maxPrizeWin)){
						valueWin 	= i2;
						maxPrizeWin = c.tablePrizes[i2][t2[i2]];
					}
				}
				*/
				if (numComodin > 0) maxPrizeWin *= c.factorMultiplicadorComodin; //Si hay un comodin en la linea de apuestas actual multiplicamos su valor
				premioTotal += maxPrizeWin;
				
			}
			return premioTotal;
		}
		//****************************************************************************************************************************************
		public function mostrarJugada(t:Array):void{
			trace (t[0][0],t[1][0],t[2][0],t[3][0],t[4][0]);
			trace (t[0][1],t[1][1],t[2][1],t[3][1],t[4][1]);
			trace (t[0][2],t[1][2],t[2][2],t[3][2],t[4][2]);
		}
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		//****************************************************************************************************************************************
		private function numBonusActivos(tJugada:Array):Array{
			// tFinal: tJugada sequence, with all cells 5 cols x 3 rows
			//     Example:  3 4 7 1 2
			//				 2 1 5 4 3
			//				 5 7 4 2 1		
			// Salida: una tabla de dos posiciones
			//		posicion 0: Devuelve el numero de bonus activos a partir de la jugada que pasamos por parametro
			//		posicion 1: Devuelve el numero de simbolos que provocan el bonus 
			
			var numBonus:int=0;
			var numSimbolos:int=0;
			var tCountSpecialCells:Array = Metodo.countScatterCells(tJugada);			

			// BONUS 1
			if (tCountSpecialCells[1]>=c.minEqualsBonus1){ numBonus ++; numSimbolos = tCountSpecialCells[1];}
			// BONUS 2
			if (tCountSpecialCells[2]>=c.minEqualsBonus2){ numBonus ++; numSimbolos = tCountSpecialCells[2];}
			// BONUS 3
			if (tCountSpecialCells[3]>=c.minEqualsBonus3){ numBonus ++; numSimbolos = tCountSpecialCells[3];}
			// BONUS 4
			if (tCountSpecialCells[4]>=c.minEqualsBonus4){ numBonus ++; numSimbolos = tCountSpecialCells[4];}
			// BONUS 5 (JackPot)
			if (tCountSpecialCells[5]>=c.minEqualsBonus5){ numBonus ++; numSimbolos = tCountSpecialCells[5];}
			
			
			 
			return [numBonus,numSimbolos];
		}
		//****************************************************************************************************************************************
		private function idBonusActivos(tJugada:Array):int{
			// tFinal: tJugada sequence, with all cells 5 cols x 3 rows
			//     Example:  3 4 7 1 2
			//				 2 1 5 4 3
			//				 5 7 4 2 1		
			// idBonus: Devuelve el id de bonus activo a partir de la jugada que pasamos por parametro
			
			var idBonus:int=0;
			var tCountSpecialCells:Array = Metodo.countScatterCells(tJugada);			

			// BONUS 1
			if (tCountSpecialCells[1]>=c.minEqualsBonus1) idBonus = Cell.cellBonus1;
			// BONUS 2
			if (tCountSpecialCells[2]>=c.minEqualsBonus2) idBonus = Cell.cellBonus2;
			// BONUS 3
			if (tCountSpecialCells[3]>=c.minEqualsBonus3) idBonus = Cell.cellBonus3;
			// BONUS 4
			if (tCountSpecialCells[4]>=c.minEqualsBonus4) idBonus = Cell.cellBonus4;
			// BONUS 5 (JackPot)
			if (tCountSpecialCells[5]>=c.minEqualsBonus5) idBonus = Cell.cellBonus5;
			
			return idBonus;
		}
		//****************************************************************************************************************************************
		private function converIntToBool(i:int):Boolean{
			if (i == 0)
				return false;
			else
				return true;
		}
		//****************************************************************************************************************************************


		
	}
	
}
