package  {
	
	public class PowerFail {
		public static const POWER_FAIL_NONE:int	= 0;
		public static const POWER_FAIL_1:int	= 1;   // los carriles se están moviendo 
		public static const POWER_FAIL_2:int	= 2;   // los carriles se han detenido completamente.
		
		
		public static const POWER_FAIL_1_1:int	= 3;   // Bonus 1
		public static const POWER_FAIL_2_1:int	= 4;   // Bonus 2 		
		public static const POWER_FAIL_3_1:int	= 5;   // Bonus 3
		public static const POWER_FAIL_4_1:int	= 6;   // Bonus 4
		
		public static const CODIFICAR:int 		= 1;
		public static const DECODIFICAR:int 	= 2;
		
		private const DELIMITADOR:String = "*";
		private var typePowerFail:int;	   	// tipo de resposicionamiento segun el punto del programa en el que nos encontramos.
		private var cadenaFinal:String;	   	// string codificado que almacenaremos en la BBDD con los parametros que necesitemos para cada uno de los puntos de reposicionamiento
		private var hayReposicion:Boolean; 	// variable que indica si tiene que haber respocion, o el programa se ejecuta con normalidad.
		private var creditos:int; 		   	// creditos actuales que deberán mostrarse en la pantalla.
										   	//    Si el powerfail está activado: si creditos  = -1 => coge los creditos de la cadenaFinal
											//    								 si creditos <> -1 => coge los creditos de esta variable
											//    Si el powerfail NO está activado: Cogerá los creditos de la tabla User_Credits
		public var param01_int:int;	   // variable int	
		public var param02_int:int;	   // variable int	
		public var param03_int:int;	   // variable int	
		public var param04_int:int;	   // variable int	
		public var param05_int:int;	   // variable int	
		public var param06_int:int;	   // variable int	
		public var param07_int:int;	   // variable int	
		public var param08_int:int;	   // variable int	
		public var param09_int:int;	   // variable int	
		public var param10_int:int;	   // variable int	
		public var param11_int:int;	   // variable int	
		public var param12_int:int;	   // variable int	
		public var param13_int:int;	   // variable int	
		public var param14_int:int;	   // variable int	
		public var param15_int:int;	   // variable int	
		public var param16_int:int;	   // variable int	
		public var param17_int:int;	   // variable int	
		public var param18_int:int;	   // variable int	
		public var param19_int:int;	   // variable int	
		public var param20_int:int;	   // variable int	
		
		public var table00_int:Array;	// tabla de enteros
		public var table01_int:Array;   // tabla de enteros
		public var table02_int:Array;   // tabla de enteros
		public var table03_int:Array;   // tabla de enteros
		public var table04_int:Array;   // tabla de enteros
		public var table05_int:Array;   // tabla de enteros
		public var table06_int:Array;   // tabla de enteros
		
		public var table01_bool:Array;  // tabla de Booleanos
		
		public var param01_bool:Boolean;	  // variable Boolean
		public var param02_bool:Boolean;	  // variable Boolean
		public var param03_bool:Boolean;	  // variable Boolean
		public var param04_bool:Boolean;	  // variable Boolean
		public var param05_bool:Boolean;	  // variable Boolean
		
		public var param01_string:String;     // variable string
		public var param02_string:String;     // variable string
		public var param03_string:String;     // variable string
		public var param04_string:String;     // variable string
		public var param05_string:String;     // variable string
		
		public var param01_float:Number;  // variable Number 
		public var param02_float:Number;  // variable Number 
		
		public var param2:Number;  // variable Number 
		public var param3:Boolean; // variable Boolean 
		public var table1:Array;   // tabla de booleanos 1 dimension
		public var table2:Array;   // tabla de booleanos 2 dimensiones
		
		//**********************************************************************************************************************************************
		public function PowerFail() {
			typePowerFail 	= POWER_FAIL_NONE;
			cadenaFinal 	= "";
			hayReposicion 	= false;
			creditos 		= -1;
			
			param01_int=0;
			param02_int=0;
			param03_int=0;
			param04_int=0;
			param05_int=0;
			param06_int=0;
			param07_int=0;
			param08_int=0;
			param09_int=0;
			param10_int=0;
			param11_int=0;
			param12_int=0;
			param13_int=0;
			param14_int=0;
			param15_int=0;
			param16_int=0;
			param17_int=0;
			param18_int=0;
			param19_int=0;
			param20_int=0;
			
			table01_int  = new Array();
			table02_int  = new Array();
			table03_int  = new Array();
			table04_int  = new Array();
			table05_int  = new Array();
			table06_int  = new Array();
			
			table01_bool = new Array();
			
			param01_bool = false;
			param02_bool = false;
			param03_bool = false;
			param04_bool = false;
			param05_bool = false;
			
			param01_string = "";
			param02_string = "";
			param03_string = "";
			param04_string = "";
			param05_string = "";
			
		}
		//**********************************************************************************************************************************************
		public function codificar():void{
			var i:int;
			switch(typePowerFail){
				//**************************************************************************************************************************************
				case POWER_FAIL_1:					
					cadenaFinal  = typePowerFail  + DELIMITADOR;
					cadenaFinal += param01_int    + DELIMITADOR;
					cadenaFinal += param02_int    + DELIMITADOR;
					cadenaFinal += param03_int    + DELIMITADOR;
					cadenaFinal += param04_int    + DELIMITADOR;
					cadenaFinal += param05_int    + DELIMITADOR;
					cadenaFinal += param01_float  + DELIMITADOR;
					cadenaFinal += param01_bool   + DELIMITADOR;
					cadenaFinal += param01_string + DELIMITADOR;
					for(i=0;i<table01_bool.length;i++){
						cadenaFinal += table01_bool[i];
						cadenaFinal += DELIMITADOR;
					}
					cadenaFinal += param06_int    + DELIMITADOR;
					cadenaFinal += param02_bool   + DELIMITADOR;
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_2:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_1_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_2_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_3_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_4_1:
					break;
				//**************************************************************************************************************************************
				default:
					break;
				//**************************************************************************************************************************************
			}
		}
		//**********************************************************************************************************************************************
		public function decodificar():void{
			var tExtract:Array;
			var i,i2:int;
			var longTable:int;
			
			// extraemos todos los parametros del string
			tExtract = cadenaFinal.split(DELIMITADOR); 
			//El primer parametro del string siempre hará refernecia al tipo de power fail que almacena
			typePowerFail = int(tExtract[0]);
			i=1;
			switch(typePowerFail){
				//**************************************************************************************************************************************				
				case POWER_FAIL_1:
					param01_int   = int(tExtract[i]);  i++;
					param02_int   = int(tExtract[i]);  i++;
					param03_int   = int(tExtract[i]);  i++;
					param04_int   = int(tExtract[i]);  i++;
					param05_int   = int(tExtract[i]);  i++;
					param01_float = Number(tExtract[i]); i++;
					param01_bool  = converStringToBoolean(tExtract[i]);i++;
					param01_string = tExtract[i];	i++;
					
					table01_bool=[false,false,false,false,false];
					for(i2=0;i2<5;i2++){
						table01_bool[i2] = converStringToBoolean(tExtract[i + i2]);
					}
					i += i2;
					
					param06_int   = int(tExtract[i]);  i++;
					param02_bool = converStringToBoolean(tExtract[i]);	i++;
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_2:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_1_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_2_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_3_1:
					break;
				//**************************************************************************************************************************************
				case POWER_FAIL_4_1:
					break;					
				//**************************************************************************************************************************************
				default:
					break;
				//**************************************************************************************************************************************
			}			
		}		
		//**********************************************************************************************************************************************
		//**********************************************************************************************************************************************
		//**********************************************************************************************************************************************
		//**********************************************************************************************************************************************
		public function resetPowerFail():void{
			hayReposicion 	= false;
			typePowerFail	= POWER_FAIL_NONE;
			cadenaFinal		= "";
			creditos		= -1;
		}		
		//**********************************************************************************************************************************************
		public function setCadena(s:String):void{
			cadenaFinal = s;
		}
		public function getCadena():String{
			return cadenaFinal;
		}		
		//**********************************************************************************************************************************************
		public function setTypePowerFail(type:int):void{
			typePowerFail = type;
		}		
		public function getTypePowerFail():int{
			return typePowerFail;
		}				
		//**********************************************************************************************************************************************
		public function setHayReposicion(r:Boolean):void{
			hayReposicion = r;
		}		
		//**********************************************************************************************************************************************
		public function setCreditos(c:int):void{
			creditos = c;
		}				
		public function getCreditos():int{
			return creditos;
		}						
		//**********************************************************************************************************************************************
		public function reposicionar():Boolean{
			return hayReposicion;
		}
		//**********************************************************************************************************************************************
		private function converStringToBoolean(s:String):Boolean{
			if (s == "true"){
				return true;
			}else{
				return false;
			}
		}
		//**********************************************************************************************************************************************		
		protected function makeInt(value:String, index:int, array:Array):Number {
    		return parseInt(value);
		}
		//**********************************************************************************************************************************************		
		protected function makeBool(value:String, index:int, array:Array):Boolean {
    		if (value == "true"){
				return true;
			}else{
				return false;
			}
		}
		
	}
	
}
