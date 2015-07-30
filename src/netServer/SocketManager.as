package netServer
{
	

	/**
	 * 网络类 
	 * @author peng.zhi
	 * 
	 */
	public class SocketManager extends SSocketManager
	{
		private static var _o:SocketManager;
		public static const MESSAGERECEIVE:String = "messageReceive";
		
		public function SocketManager()
		{
			super();
			//这里是因为老项目 不愿意改其他地方了 新项目可以用 SSMessage 不用在这里弄了
			_currentMsg = new SocketMessage();
		}
		/**
		 * 设置全局发送socket ,不做单例显示,由外部设置 
		 * @param value
		 * 
		 */		
		public static function set o(value:SocketManager):void
		{
			_o = value;
		}
		/**
		 * 全局的socket发送接口 
		 * @return 
		 * 
		 */
		public static function get o():SocketManager
		{
			if(_o == null)
				_o = new SocketManager
			return _o;
		}
		/**
		 * 调用一次连接,然后断开 
		 * @param ip 服务器地址
		 * @param port 端口号
		 * @param cmd 命令字 例如 "account.getserverstatus"
		 * @param rtnfunction 调用返回 e(retParams{code:0成功,1失败 msg:获得的msg rtnfunctionParams:传入的回调参数})
		 * @param rtnfunctionParams 函数返回字段 可以为null
		 * @param params rp参数
		 * 
		 */
		public static function callonce(ip:String,port:int,cmd:String,rtnfunction:Function,rtnfunctionParams:Object,...params):void
		{
			SSocketManager.callonce(ip,port,cmd,rtnfunction,rtnfunctionParams,params);
		}

		
	}
}