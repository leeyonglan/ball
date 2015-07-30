package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class CJPlayerDataManager
	{
		private var gridDict:Dictionary = new Dictionary;
		private var ballPosDict:Dictionary = new Dictionary;
		public static var wn:Number = 40;
		public static var hn:Number = 40;
		public static var w:Number = 50;
		private static var _ins:CJPlayerDataManager;
		public function CJPlayerDataManager()
		{
			this._initGrid();	
		}
		public static function o():CJPlayerDataManager
		{
			if(_ins == null)
			{
				_ins = new CJPlayerDataManager;
			}
			return _ins;
		}
		
		private function _initGrid():void
		{
			var k:int = 1;
			for (var y:int = 0;y<200;y++)
			{
				for(var x:int = 0; x<200;x++)
				{
					var xval:Number = x*w
					var yval:Number = y*w;
					this.gridDict[k] = new Cell(k,xval,yval,w,w);
					k++;
				}
			}
		}
		
		public function getDataById(id:int):Cell
		{
			if(this.gridDict.hasOwnProperty(id))
			{
				return this.gridDict[id];
			}
			return new Cell(0,0,0,0,0);
		}
		
		public function update(gid:String,x:Number,y:Number):int
		{
			var ngrid:int = this.getGridByOriginalPos(x,y);
			if(this.gridDict.hasOwnProperty(ngrid))
			{
				//将gid 之前所在的格子的数据清空
				if(this.ballPosDict.hasOwnProperty(gid))
				{
					var vo:Vo = this.ballPosDict[gid];
					var bgrid:int = vo.cgridId;
					if(bgrid != ngrid)
					{
						vo.cgridId = ngrid;
						var beforCell:Cell = this.gridDict[bgrid];
						beforCell.deleteGid(gid);
						beforCell.globalx = 0;
						beforCell.globaly = 0;
					}
				}
				else
				{
					var newVo:Vo = new Vo(gid);
					newVo.cgridId = ngrid
					this.ballPosDict[gid] = newVo;
				}
				
				var c:Cell = this.gridDict[ngrid];
				c.addGid(gid);
				c.globalx = x;
				c.globaly = y;
			}
			return ngrid;
		}
		
		public function getOriginalPos(grid:int,x:Number,y:Number):Point
		{
			var p:Point = new Point(0,0);
			if(this.gridDict.hasOwnProperty(grid))
			{
				var rect:Rectangle = this.gridDict[grid];
				var rectx:Number = rect.x + x;
				var recty:Number = rect.y + y;
				p.x = rectx;
				p.y = recty;
			}
			return p;
		}
		
		public function getAllInGrids(grids:Array):Vector.<Cell>
		{
			var list:Vector.<Cell> = new Vector.<Cell>;
			for(var i:String in grids)
			{
				if(this.gridDict.hasOwnProperty(grids[i]))
				{
					var c:Cell = this.gridDict[grids[i]];
					if(c.getGid().length>0)
					{
						list.push(c);
					}
				}
			}
			return list;
		}
		
		public function getGridByOriginalPos(x:Number,y:Number):int
		{
			var xn:int = Math.ceil(x/w);
			var yn:int = Math.floor(y/w);
			return yn*wn + xn;
		}
		/**
		 * 获得某个格子它周围的格子
		 */
		public function getRangeGrids(grid:int,ballRadius:Number):Array
		{
			var grids:Array = new Array;
			var numRadius:int = Math.ceil(ballRadius/w);
			var xnum:int = grid%wn;
			var ynum:int = Math.floor(grid/hn);
			var startid:int = grid - (numRadius) * wn - numRadius;
			var endid:int = grid + (numRadius) * wn + numRadius;
			var rows:int = numRadius * 2 + 1;
			var clums:int = rows;
			
			for(var i:int = 0; i<rows; i++)
			{
				for(var j:int = 0;j < clums; j++)
				{
					var id:int = startid+i*wn + (j+1);
					if(id<=0 || id>40000) continue;
					grids.push(id);
				}
			}
			return grids;
		}
		
		/**
		 * 检测a 能否吃掉b
		 */
		public function checkEat(a:Ball,b:Ball):Boolean
		{
			if(a.radius <= b.radius)
			{
				return false;
			}
			var distance:Number = Math.sqrt(Math.pow((Math.abs(a.x - b.x)),2) + Math.pow((Math.abs(a.y - b.y)),2));
			if(distance <= (a.radius - b.radius))
			{
				return true;
			}
			return false;
		}
		
		public function remove(id:String):void
		{
			delete this.ballPosDict[id];
		}
		
	}
}