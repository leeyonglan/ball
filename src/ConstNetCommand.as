package
{
	public final class ConstNetCommand
	{
		public function ConstNetCommand()
		{
		}
	
		/**
		 * 角色移动 
		 */
		public static const CS_ROLE_MOVETO:String = "r_sync.move";
		
		
		public static const CS_SYNC_INIT:String = "r_sync.init";
		/**
		 * 吃掉对方
		 */
		public static const CS_SYNC_SYNCEAT:String = "r_sync.eat";
		/**
		 * 同步角色出现 
		 */
		public static const SC_SYNC_SYNCAPPEAR:String = "r_sync.syncappear";
		
		public static const SC_SYNC_SYNCRANK:String = "r_sync.rank";
		/**
		 * 同步角色消失 
		 */
		public static const SC_SYNC_SYNDISAPPEAR:String = "r_sync.syncdisappear";
		/**
		 * 同步角色移动 
		 */
		public static const SC_SYNC_SYNCMOVETO:String = "r_sync.syncmoveto";
		
		public static const SC_SYNC_Fail:String = "r_sync.fail";
		
		public static const SC_SYNC_Status:String = "r_sync.syncstatus";
		
		public static const SC_SYNC_REFRESHNPC:String = "r_sync.refreshnpc";

		/**
		 * 同步角色升级 
		 */
		public static const SC_SYNC_UPLEVEL:String = "r_sync.syncuplevel";
		
		/**
		 * 更换坐骑
		 */
		public static const SC_SYNC_RIDE_CHANGE:String = "r_sync.syncridechange";
		/**
		 * 好友上线
		 */
		public static const SC_SYNC_FRIEND_ONLINE:String = "r_sync.syncfriendonline"
		/**
		 * 好友下线
		 */
		public static const SC_SYNC_FRIEND_OFFLINE:String = "r_sync.syncfriendoffline"
		
		/**
		 * 获取武将列表
		 */
		public static const CS_HERO_GET_HEROS:String = "r_sync.init";
		
	}
}