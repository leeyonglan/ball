package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 玩家场景控制类,主要针对玩家排序 
	 * @author yongjun
	 * 
	 */
	public class CJPlayerSceneLayer extends Sprite
	{
		private static var sSortBuffer:Vector.<DisplayObject> = new <DisplayObject>[];
		private var mChildren:Vector.<DisplayObject> = new <DisplayObject>[];

		public function CJPlayerSceneLayer()
		{
			super();
			this.addEventListener("balladded",addListHandler);
			this.addEventListener("ballremoved",removeListHandler);
		}
		
		public function sortPlayer():void
		{
			sortChildren(function(a:Ball,b:Ball):int
			{
				if(a is Ball && b is Ball)
				{
					if(a.radius< b.radius)
					{
						return -1;
					}
					else if(a.y == b.y)
					{
						return 0;
					}
					else
					{
						return 1;
					}
				}
				else
				{
					return 0;
				}
				
				
			})
		}
		
		public function getmChildren():Vector.<DisplayObject>
		{
			return mChildren;
		}
		
		private function addListHandler(e:Event):void
		{
			if(e.currentTarget is Ball && (e.currentTarget as Ball).isplayer)
			{
				mChildren[this.numChildren] = e.currentTarget as DisplayObject;	
			}
		}
		
		private function removeListHandler(e:Event):void
		{
			if(e.currentTarget is Ball)
			{
				var indexm:int = mChildren.indexOf(e.currentTarget)
				if(indexm != -1)
				{
					delete mChildren[indexm]
				}
			}
		}
		
		public function sortChildren(compareFunction:Function):void
		{
			sSortBuffer.length = mChildren.length;
			mergeSort(mChildren, compareFunction, 0, mChildren.length, sSortBuffer);
			sSortBuffer.length = 0;
		}
		private static function mergeSort(input:Vector.<DisplayObject>, compareFunc:Function, 
										  startIndex:int, length:int, 
										  buffer:Vector.<DisplayObject>):void
		{
			// This is a port of the C++ merge sort algorithm shown here:
			// http://www.cprogramming.com/tutorial/computersciencetheory/mergesort.html
			
			if (length <= 1) return;
			else
			{
				var i:int = 0;
				var endIndex:int = startIndex + length;
				var halfLength:int = length / 2;
				var l:int = startIndex;              // current position in the left subvector
				var r:int = startIndex + halfLength; // current position in the right subvector
				
				// sort each subvector
				mergeSort(input, compareFunc, startIndex, halfLength, buffer);
				mergeSort(input, compareFunc, startIndex + halfLength, length - halfLength, buffer);
				
				// merge the vectors, using the buffer vector for temporary storage
				for (i = 0; i < length; i++)
				{
					// Check to see if any elements remain in the left vector; 
					// if so, we check if there are any elements left in the right vector;
					// if so, we compare them. Otherwise, we know that the merge must
					// take the element from the left vector. */
					if (l < startIndex + halfLength && 
						(r == endIndex || compareFunc(input[l], input[r]) <= 0))
					{
						buffer[i] = input[l];
						l++;
					}
					else
					{
						buffer[i] = input[r];
						r++;
					}
				}
				
				// copy the sorted subvector back to the input
				for(i = startIndex; i < endIndex; i++)
					input[i] = buffer[int(i - startIndex)];
			}
		}
	}
}