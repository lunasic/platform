package com.editor.module_mapIso.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.popview.MapInfoPopView;
	import com.editor.module_mapIso.popview.MouseInfoPopView;
	import com.editor.module_mapIso.proxy.MapEditorIsoProxy;
	import com.editor.module_mapIso.tool.MapEditorUtils;
	import com.editor.module_mapIso.view.MapEditorIsoTopContainer;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class MapEditorIsoTopContainerMediator extends AppMediator
	{
		public static const NAME:String = "MapEditorIsoTopContainerMediator";
		
		public function MapEditorIsoTopContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorIsoTopContainer
		{
			return viewComponent as MapEditorIsoTopContainer;
		}
		public function get visiLogButton():UIButton
		{
			return mainUI.visiLogButton;
		}
		public function get infoTxt():UILabel
		{
			return mainUI.infoTxt;
		}
		public function get infoTxt2():UILabel
		{
			return mainUI.infoTxt2;
		}
		public function get menuBar():UIMenuBar
		{
			return mainUI.menuBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			MapEditorIsoManager.topContainerMediator = this;
			
			menuBar.addEventListener(ASEvent.CHANGE,menuBarChangeHandle)
		}
		
		private function menuBarChangeHandle(e:ASEvent):void
		{
			var dat:IASMenuButton = e.data as IASMenuButton;
			var xml:XML = dat.getMenuXML();
			var d:String = xml.@data;
			if(d == "1"){
				selectSceneButtonClick()
			}else{
				get_MapIsoBottomContainerMediator().menuHandler(d);
			}
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditorIsoManager.currentSelectedSceneItme;
		}
		
		public function reactToVisiLogButtonClick(e:MouseEvent):void
		{
			get_MapEditorIsoModuleMediator().logContainer.visible = !get_MapEditorIsoModuleMediator().logContainer.visible;
			if(get_MapEditorIsoModuleMediator().logContainer.visible){
				visiLogButton.label = "隐藏LOG";
			}else{
				visiLogButton.label = "显示LOG";
			}
		}
		
		/**选择场景按钮点击**/
		private function selectSceneButtonClick():void
		{
			if(currentScene == null){
				selectedScene();
				return ;
			}
			
			var confirmData:OpenMessageData = new OpenMessageData();
			confirmData.info = "些操作将覆盖之前编辑的内容，\<br\>是否确定已保存之前编辑的场景？";
			confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			confirmData.okFunction = selectedScene;
			showConfirm(confirmData);
		}
		
		private function selectedScene():Boolean
		{
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = get_MapEditorIsoProxy().mapDefine.getList();
			vo.labelField = "name1";
			vo.label = "选择要编辑的场景: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSceneCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
			
			return true;
		}
		
		private function selectedSceneCallBack(item:AppMapDefineItemVO, item1:SelectEditPopWin2VO):void
		{
			infoTxt2.htmlText = "当前编辑的场景：<font color='#00CC00'><b>" + item.name + "</b></font>";
			MapEditorIsoManager.currentSelectedSceneItme = item;
			
			var ld:UILoader = new UILoader();
			ld.complete_fun = loadXML;
			ld.ioError_fun = ioErrorLoadXML;
			ld.load(MapEditorIsoManager.currProject.mapConfigUrl+item.id+".xml")
		}
		
		private function loadXML(s:String):void
		{
			parserXML(XML(s));
		}
				
		/**解析XML**/
		private function parserXML(x:XML):void
		{
			if(x){
				if(x.m){
					var mapParam:MapIsoMapData = new MapIsoMapData();
					mapParam.xml = x;
					mapParam.mapWidth   = x.@mapW;        //地图的宽=地图信息XML.地图宽
					mapParam.mapHeight  = x.@mapH;       //地图的高=地图信息XML.地图高
					mapParam.cellWidth  = x.f.@tileW; //单元格的宽=地图信息XML.面板.单元格宽
					mapParam.cellHeight = x.f.@tileH;//单元格的高=地图信息XML.面板.单元格高
					mapParam.col        = x.f.@c;       //地图横向节点数=XML.地图横向节点数
					mapParam.row        = x.f.@r;       //地图纵向节点数=XML.地图纵向节点数
										
					mapParam.mapArr = MapEditorUtils.getArrByStr(x.f,mapParam.col,mapParam.row);
					
					MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata = mapParam;
					get_MapIsoBottomContainerMediator().parser();
				}
			}
		}
		
		private function ioErrorLoadXML(e:*=null):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.CreateMapPopwin_sign
			dat.data = null;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function get_MapEditorIsoModuleMediator():MapEditorIsoModuleMediator
		{
			return retrieveMediator(MapEditorIsoModuleMediator.NAME) as MapEditorIsoModuleMediator;
		}
		
		private function get_MapEditorIsoProxy():MapEditorIsoProxy
		{
			return retrieveProxy(MapEditorIsoProxy.NAME) as MapEditorIsoProxy;
		}
			
		private function get_MapIsoBottomContainerMediator():MapIsoBottomContainerMediator
		{
			return retrieveMediator(MapIsoBottomContainerMediator.NAME) as MapIsoBottomContainerMediator;
		}
		
		
	}
}