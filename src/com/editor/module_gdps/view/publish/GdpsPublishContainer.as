package com.editor.module_gdps.view.publish
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPublishToolBar;

	public class GdpsPublishContainer extends UICanvas
	{
		public function GdpsPublishContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsPublishToolBar;
		public var infoText:UILabel;
		public var publishDataGridContainer:GdpsModuleDataGrid;
		
		private function create_init():void
		{
			visible = true;
			enabledPercentSize = true;
			padding = 0;
			backgroundColor = 0xFFFFFF;
			
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.verticalGap = 2;
			vbox.horizontalGap = 2;
			vbox.horizontalAlign = "center";
			vbox.padding = 5;
			addChild(vbox);
			
			toolBar = new GdpsPublishToolBar();
			vbox.addChild(toolBar);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 30;
			hbox.paddingLeft = 20;
			hbox.paddingTop = 10;
			vbox.addChild(hbox);
			
			infoText = new UILabel();
			infoText.percentWidth = 100;
			infoText.verticalCenter = 0;
			infoText.wordWrap = false;
			infoText.text = "更新发布管理菜单功能说明......";
			hbox.addChild(infoText);
			
			publishDataGridContainer = new GdpsModuleDataGrid();
			publishDataGridContainer.enabledPercentSize = true;
			vbox.addChild(publishDataGridContainer);
			
			initComplete();
		}
	}
}