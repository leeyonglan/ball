package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import netServer.SocketManager;
	
	
	public class login extends Sprite
	{
		private var _txtUsername:TextField
		public function login()
		{
			super();
			_initUI();
		}

		
		private function _initUI():void
		{
			
			var tips:TextField = new TextField
			tips.x = 100;
			tips.y = 80;
			tips.text = "请输入用户名"
			this.addChild(tips);
			var sp:Sprite = new Sprite;
			with(sp.graphics)
			{
				beginFill(0x0000FF);
				drawRect(0,0,85,18);
				endFill();
			}
			sp.x = 100;
			sp.y = 100;
			this.addChild(sp);
			_txtUsername = new TextField();
			_txtUsername.name = "username";
			_txtUsername.type = TextFieldType.INPUT;
			_txtUsername.restrict = "a-zA-Z0-9_@\\-\\.";
			_txtUsername.maxChars = 50;
			_txtUsername.defaultTextFormat = login.getTextFormat(0x000000);
			_txtUsername.x = 100;
			_txtUsername.y = 100;
			_txtUsername.width = 85;
			_txtUsername.height = 18;
			_txtUsername.text = ""
			this.addChild(_txtUsername);
			
			var loginTxt:TextField = new TextField();
			loginTxt.text = "登录";
			loginTxt.defaultTextFormat = new TextFormat("宋体",14,0x00FF00)
			loginTxt.addEventListener(MouseEvent.CLICK,loginHandler);
			loginTxt.x = 100;
			loginTxt.y = 150;
			this.addChild(loginTxt);
		}
		
		private function loginHandler(e:MouseEvent):void
		{
			var param:Dictionary = new Dictionary;
			param['name'] = _txtUsername.text;
			SocketManager.o.callunlock2("r_sync.init",param);
		}

		public static function getTextFormat(color:uint = 0xFFFFFF, size:int = 12, bold:Boolean = false, align:String = "left", leading:int = 4):TextFormat
		{
			var _style:TextFormat = new TextFormat();
			_style.leading = leading;
			_style.size = size;
			_style.color = color;
			_style.bold = bold;
			_style.align = align;
			return _style;
		}
	}
}