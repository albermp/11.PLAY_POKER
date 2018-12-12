package  {
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	//**************************************************************************************************************************************************
	//                        Clase para que el browser SMI pueda consultar o realizar acciones sobre el juego
	//**************************************************************************************************************************************************	
	public class AccesoBrowser_SMI extends MovieClip{
		private var fps_backup:int;
		private var gc:GameControl;
		//**********************************************************************************************************************************************
		public function AccesoBrowser_SMI(gc_:GameControl) {
			gc = gc_;
			init();
			
			// Parar y reanudar el juego
			ExternalInterface.addCallback("pararJuego",pararJuego);
			ExternalInterface.addCallback("reanudarJuego",reanudarJuego);
			
			// Consultar idioma
			ExternalInterface.addCallback("consultaIdioma",consultaIdioma);

			// Consultar apuesta
			ExternalInterface.addCallback("consultaApuesta",consultaApuesta);

			// Consultar creditos en centimos
			ExternalInterface.addCallback("consultaCreditosEnCentimos",consultaCreditosEnCentimos);

		}
		//**********************************************************************************************************************************************
		private function init():void{
			fps_backup = 0;
		}
		//**********************************************************************************************************************************************
		
		
		
		//**********************************************************************************************************************************************
		//                  Para poder modificar los fps desde la aplicacion SMI
		//**********************************************************************************************************************************************
		function pararJuego():void{
			fps_backup 		= gc.stage.frameRate;
			gc.stage.frameRate = 0;
		}
		//**********************************************************************************************************************************************
		function reanudarJuego():void{
			gc.stage.frameRate = fps_backup;
		}		
		//**********************************************************************************************************************************************
		//                 Consulta del idioma actual en el juego
		//**********************************************************************************************************************************************
		function consultaIdioma():String{
			var nombreIdioma:String = "";
			switch(gc.gameData.idioma){
				case c.PORTUGUESE: 	nombreIdioma = "PORTUGUES";	break;
				case c.ENGLISH: 	nombreIdioma = "INGLES";	break;
				case c.SPANISH: 	nombreIdioma = "CASTELLANO";break;
				case c.FRENCH: 		nombreIdioma = "FRANCES";	break;
			}
			return nombreIdioma;
		}
		//**********************************************************************************************************************************************
		//                 Consulta de la apuesta actual en el juego
		//**********************************************************************************************************************************************
		function consultaApuesta():String{
			var valorApuesta:String = String(gc.gameData.bet);
			return valorApuesta;
		}
		//**********************************************************************************************************************************************
		//                 Consulta el valor en centimos de un credito
		//**********************************************************************************************************************************************
		function consultaCreditosEnCentimos():int{
			return gc.gameData.valorDenominacion;
		}
		//*********************************************************************************************************************************************		
		
	}
	
}
