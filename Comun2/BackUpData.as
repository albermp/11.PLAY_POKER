package  {
	public class BackUpData {
		private var powerFail_SQL:PowerFailMySQL;
		private var cfs:ControlFileServerPowerFail;
		private var cfl:ControlFileLocal;
		//************************************************************************************************************************************************
		public function BackUpData() {
			powerFail_SQL 	= new PowerFailMySQL();
			cfs 			= new ControlFileServerPowerFail();
			cfl 			= new ControlFileLocal();
		}
		//************************************************************************************************************************************************
		//********************************** POWER FAIL **************************************************************************************************
		//************************************************************************************************************************************************
		public function savePowerFail(idMaquina:String,idJuego:int,timeStamp:Number,isPowerFail:Boolean,cadena:String):void{
			//return; // ojo - si no queremos guardar informacion
			
			// Guardamos powerFail en la base de datos
			if (isPowerFail)
				powerFail_SQL.executeUpdate(idMaquina,idJuego,timeStamp,isPowerFail,cadena,-1);
			else
				powerFail_SQL.executeUpdate2(idMaquina,idJuego,timeStamp,isPowerFail,-1);
			
			// Guardamos powerFail fichero en el servidor
			var nombreFile:String =  cfs.createNameFile(idMaquina, idJuego);
			cfs.writeFile(nombreFile,timeStamp,isPowerFail,cadena,-1);
			
			// Guardamos powerFail en local (SharedObject). 
			// En la versión BROWSER_WEB no se guarda el power fail en local.
			if (!c.ignorarPowerFailLocal){
				cfl.writeData(idMaquina,idJuego,timeStamp,isPowerFail,cadena,-1);
			}
		}
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		// Este método modificará los creditos del powerfail que hay almacenado en ese momento. Se utiliza por el tema del PAGO. Si el jugador inserta
		// creditos y en ese momento hay un power fail, actualizará los creditos de ese powerfail. (Solo los creditos)
		public function savePowerFail_credits(idMaquina:String,idJuego:int,credits:int):void{
			// Realizamos un update directamente a la tabla para modificar solamente el campo: Creditos
			powerFail_SQL.executeUpdate3(idMaquina,idJuego,credits);
			
			//Recuperamos el power fail local. La recuperación es instantanea.
			cfl.readData(idMaquina,idJuego);
			var timeStamp:Number    = cfl.getTimeStamp();
			var isPowerFail:Boolean = cfl.getIsPowerFail();
			var cadenaDatos:String  = cfl.getCadenaDatos();
			
			// Con los datos recuperados de local, aprovechamos para grabar el local y el fichero servidor, con los creditos actualizados.
			// Grabamos en local
			// En la versión BROWSER_WEB no se guarda el power fail en local.
			if (!c.ignorarPowerFailLocal){
				cfl.writeData(idMaquina,idJuego,timeStamp,isPowerFail,cadenaDatos,credits);
			}
			
			// Grabamos en el servidor
			var nombreFile:String =  cfs.createNameFile(idMaquina, idJuego);
			cfs.writeFile(nombreFile,timeStamp,isPowerFail,cadenaDatos,credits);
		}
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
		//************************************************************************************************************************************************
	}
	
}
