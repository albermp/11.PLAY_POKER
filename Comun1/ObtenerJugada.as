package  {
	import flash.net.*;
	import flash.events.*;
	
	public class ObtenerJugada {
		private static const Fase1:int	= 1;
		private static const Fase2:int	= 2;
		private static const Fase3:int	= 3;
		private static const Fase4:int	= 4;
		
		
		private var gd:GameData;
		private var jMySQL:JugadaMySQL;
		
		private var stateObtenerJugada:int;
		private var jugadaObtenida:Boolean;
		
		
		private var t_Jugada:Array;
		private var contTimeOut:int;
		private var timeSecurityLoader:int;
		private var timeMaxSecurityLoader:int = 30;
		private var timeIncSecurity:int = 1;																
		
		private var validarPremiosGNA:Boolean; // Si queremos validar o no los premios de la jugada recibida del GNA con nuestro propios calculops.
		
		
		private var idTimeStampMov:Number;
		// Jugada en formato string, igual como la genera el GNA
		public var sJugadaInterna:String;	
		// Jackpot actualizado cada vez que generamos una partida
		public var jackpotAcumulated:Number;
		// Creditos que hay en estos momentos en la base de datos
		// Lo utilizamos si queremos refrescar los creditos antes de empezar una nueva partida (Por ejemplo en el caso del entorno BROWSER_WEB)
		public var creditos_bd:int;
		// Booleano que nos dice si tenemos saldo suficiente para jugar. Este valor se obtiene en el php, comparará el credito existente en la base de datos
		// con el valor de apuesta enviada
		public var puedeJugar:Boolean;
		
		// Jugada en formato string, igual como la genera el GNA
		private var sJugada:String;
		//**********************************************************************************************************************************************
		public function ObtenerJugada(g_:GameData) {
			gd = g_;
			
			jMySQL 				 = new JugadaMySQL();
			jugadaObtenida 		 = false;
			jackpotAcumulated 	 = 0.0;
			creditos_bd			 = 0;
			puedeJugar		     = false;
			idTimeStampMov 		 = 0;
		}
		//*********************************************************************************************************************************************		
		public function init():void{
			sJugada			 		 = "";
			sJugadaInterna			 = "null";
			jackpotAcumulated 		 = 0.0;
			creditos_bd				 = 0;
			puedeJugar     			 = false;
			jugadaObtenida   		 = false;
			validarPremiosGNA 		 = true;
			idTimeStampMov    		 = 0;
			
			switchEstado(ObtenerJugada.Fase1);
		}		
		//*********************************************************************************************************************************************		
		public function run():void{
			
			switch(stateObtenerJugada){
				case ObtenerJugada.Fase1: // Comprobamos que exista registro de comunicación con GNA
						contTimeOut = 0;
						timeSecurityLoader = timeMaxSecurityLoader;
						jMySQL.executeObtenerJugada(gd.idMaquina,								// string
													gd.idJuego,									// int
												  	gd.autohold,								// Boolean
													gd.bet, 									// int
													gd.jackpotAcumulated,						// Number
													gd.incremetoJackpot,						// Number	
													gd.valorJackpotMaximo,						// Number	
													gd.apuestaMinima,							// Number
													gd.valorJackpotInicial,						// Number
													gd.credits,									// int
													gd.ultimoPremioPagado,						// int
													gd.idioma,									// int
													gd.valorDenominacion,						// int
													idTimeStampMov,								// Number
													gd.regionHoraria,							// string
													sJugadaInterna,								// string
													c.contenedorFlash,							// int	
													gd.valor_centimos_de_un_credito);			// int	
						switchEstado(ObtenerJugada.Fase2);
						break;
				case ObtenerJugada.Fase2: // Validamos la existencia del registro y actuamos de una forma u otra dependiendo del caso.
						contTimeOut ++;
						if (jMySQL.isAccessCompleted()){  // consulta completada	
							if (jMySQL.getStateResult() == JugadaMySQL.RESULT_OK){ // la colsulta ha ido bien
								if (jMySQL.isRegFound()){ // existe registro
									sJugada			  	 = jMySQL.getCadenaDatos();
									jackpotAcumulated 	 = Number(jMySQL.getJackpot());
									creditos_bd		  	 = int(jMySQL.getCredits_BD());
									puedeJugar			 = jMySQL.getPuedeJugar();
									switchEstado(ObtenerJugada.Fase3);
								}else{					 // no existe registro
									switchEstado(ObtenerJugada.Fase1);
								}
							}else
								switchEstado(ObtenerJugada.Fase1);
						}else if (jMySQL.isWithError()){
							switchEstado(ObtenerJugada.Fase1);
						}else if (contTimeOut > timeSecurityLoader){
							jMySQL.cancelLoader();
							switchEstado(ObtenerJugada.Fase1);
						}else if (jMySQL.estaAccionFinalizada()){
							timeSecurityLoader = contTimeOut + timeIncSecurity;
						}
						break;						
				//======================================================================================================================================================
				//======================================================================================================================================================
				//======================================================================================================================================================
				case ObtenerJugada.Fase3: // ya tenemos la jugada preparada
						jugadaObtenida = true;
						switchEstado(ObtenerJugada.Fase4);
						break;
				case ObtenerJugada.Fase4: // La jugada no ha superado la validacion
						break;

			}
		}
		//*********************************************************************************************************************************************		
		public function setTimeStamp_mov(id:Number):void{
			idTimeStampMov = id;
		}				
		//*********************************************************************************************************************************************		
		public function getJugada():String{
			return sJugada;
		}
		//*********************************************************************************************************************************************		
		public function getJugadaObtenida():Boolean{
			return jugadaObtenida;
		}
		//*********************************************************************************************************************************************		
		//********************************************* PRIVATE FUNCTIONS *****************************************************************************		
		//*********************************************************************************************************************************************				
		private function switchEstado(estado:int):void{
			stateObtenerJugada = estado;
		}			
		//*********************************************************************************************************************************************		
		public function getEstado():int{
			return stateObtenerJugada;
		}
		//*********************************************************************************************************************************************				
	}
	
}
