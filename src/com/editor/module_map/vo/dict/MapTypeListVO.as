package com.editor.module_map.vo.dict
{
	public class MapTypeListVO
	{
		public function MapTypeListVO()
		{
		}
		
		//
		public static var list:Array = [];
		public static var all_ls:Array = [];
		
		public static function parser(x:XML):void
		{
			for each(var p:XML in x.i)
			{
				var cell:MapDictItemVO = new MapDictItemVO(p);
				list[cell.c] = cell;
				all_ls.push(cell);
			}
		}
		
		public static function getValue(id:String):String
		{
			return MapDictItemVO(list[id]).v;
		}
		
		
	}
}