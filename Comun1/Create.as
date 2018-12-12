package  {
	import flash.display.MovieClip;
	//import flash.text.TextField;
	import flash.text.*;
	//*****************************************************************************************************************************************************
	// Esta clase se utiliza para generar los diferentes componentes de la pantalla. Se unifica todo aquí porqué hay componentes que se utilizan en diferentes
	// escenas, así lo tenemos todo unificado en un mismo sitio.
	// Por ejemplo, los botones en la pantalla principal de los rodillos, y los botones que se muestran en el juego del bonus de los sombreros, no son los mismos, ya
	// que se ha cambiado de escena. Se borran los primeros y se crean de nuevo en la pantalla de los sombreros, este proceso se realiza en varios puntos del programa
	// para tenerlo todo codificado una vez, se crean aquí, y así siempre nos aseguraremos que los elementos se crearán siempre con las mismas caracteristicas.
	public class Create{
		//****************************************************************************************************************************************	
		public static function createBackGroundBase(gc:GameControl):mc_backGroundBase{
			var backGroundBase:mc_backGroundBase;
			backGroundBase = new mc_backGroundBase();
			backGroundBase.x = gc.stage.stageWidth  * .5;
			backGroundBase.y = gc.stage.stageHeight * .5;
			backGroundBase.scaleX = 1;
			backGroundBase.scaleY = 1; 
			return backGroundBase;
		}
		//****************************************************************************************************************************************	
		public static function createBackGround(gc:GameControl):MovieClip{
			var backGround:MovieClip; 
			backGround = new mc_backGroundGame();
			backGround.x = -gc.stage.stageWidth  * .5;
			backGround.y = -gc.stage.stageHeight * .5;
			return backGround;
		}
		//****************************************************************************************************************************************	
		public static function createButtonHome(gd:GameData):mc_buttonHome{ 
			var buttonHome:mc_buttonHome;
			buttonHome   = new mc_buttonHome();
			buttonHome.scaleX = 1.55; //1.15;
			buttonHome.scaleY = 1.4; //1.15;
			buttonHome.x = 54; //928; //612;
			buttonHome.y = 657; //174; //714;
			buttonHome.gotoAndStop(1);
			buttonHome.visible = true;
			
			//-----------------------------------------------------------------------------
			// Para SMI en caso de máquina monojuego, no mostraremos el botón de la casita. 
			// Son máquinas que solo disponen de un juego, por tanto no hay menú, el botón 
			// de la casita (HOME) no tiene sentido.
			if (c.contenedorFlash == c.BROWSER_SMI){
				if (!gd.multiJuego_SMI){
					buttonHome.visible = false;
				}
			}
			//-----------------------------------------------------------------------------
			
			return buttonHome;
		}
		//****************************************************************************************************************************************	
		public static function createButtonFlag(gd:GameData):mc_buttonFlag{ 
			var buttonFlag:mc_buttonFlag;
			buttonFlag   = new mc_buttonFlag();
			//buttonFlag.width = 32;
			//buttonFlag.height = 26;			
			buttonFlag.x = 1000; //888; //994; // 75;
			buttonFlag.y = 20; //618; //675; //206;
			buttonFlag.gotoAndStop(gd.t_idioma[gd.idioma]);
			buttonFlag.visible = true;
			return buttonFlag;
		}
		//****************************************************************************************************************************************	
		public static function createButtonHelp(gc:GameControl):mc_buttonHelp{ 
			var buttonHelp:mc_buttonHelp;
			buttonHelp   = new mc_buttonHelp();
			//buttonHelp.width  = 63;
			//buttonHelp.height = 63;
			//buttonHelp.scaleX = 1.1;
			//buttonHelp.scaleY = 1.1;
			buttonHelp.x = 750; //975; //585; //412;
			buttonHelp.y = 738; //656; //176; //714;
			buttonHelp.gotoAndStop((2 * gc.gameData.idioma) - 1);
			return buttonHelp;
		}			
		//****************************************************************************************************************************************	
		public static function createButtonCobrar(gc:GameControl):mc_buttonCobrar{ 
			var buttonCobrar:mc_buttonCobrar;
			buttonCobrar   = new mc_buttonCobrar;
			buttonCobrar.scaleX = 1;
			buttonCobrar.scaleY = 1;
			buttonCobrar.x = 100 + 490; //296; //60;
			buttonCobrar.y = 738; //735; //768;
			buttonCobrar.gotoAndStop(1);	
			return buttonCobrar;
		}		
		//****************************************************************************************************************************************	
		public static function createButtonValorMoneda(gc:GameControl):mc_buttonValorMoneda{  
			var buttonValorMoneda:mc_buttonValorMoneda;
			buttonValorMoneda   = new mc_buttonValorMoneda();
			buttonValorMoneda.scaleX = 1.7;
			buttonValorMoneda.scaleY = 1.6;
			buttonValorMoneda.x = 974; //943;
			buttonValorMoneda.y = 656; //207;
			buttonValorMoneda.gotoAndStop(gc.gameData.imagenMoneda);			
			return buttonValorMoneda;
		}		
		//****************************************************************************************************************************************	
		//******************************************** TextField COBRO CREDITOS ******************************************************************
		//****************************************************************************************************************************************
		public static function createTextCobroCredits():TextField{ 
			var format:TextFormat = new TextFormat();
	       	format.color = 0x000000;
        	format.size = 50;
        	format.bold = true;
			format.align = TextFormatAlign.CENTER;
			//format.font = "Plantagenet Cherokee";
			//format.font = "Matura";
			//format.font = "Ubuntu";
			//format.font = "Goudy Stout";
			format.font = "Times New Roman";
			
			var textCreditsCobro:TextField;
			textCreditsCobro = new TextField();
			textCreditsCobro.defaultTextFormat = format;
			textCreditsCobro.text = "";
			textCreditsCobro.multiline = false;
			textCreditsCobro.selectable = false;
			textCreditsCobro.textColor = 0x000000; 
			textCreditsCobro.type = TextFieldType.DYNAMIC; 
			textCreditsCobro.width = 320;
			textCreditsCobro.x = 150;
			textCreditsCobro.y = 200;

			return textCreditsCobro;		
		}	
		//****************************************************************************************************************************************	
	}
	//*****************************************************************************************************************************************************	
}
