
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_L02()
{
	@super();

}
@extends AView;


@function MS1005_L02:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.label1 = this.findCompByGroup('Label1Gr')[0];
	this.cbx1 = this.findCompByGroup('Label1Gr')[1];
	this.url;
	this.text;
	this.delegator = null;
};

@function MS1005_L02:setData(data, delegator)
{
	this.label1.setText(data.text);
	this.text = data.text;
	this.url = data.Url;
	this.zoom = data.zoom;
	this.delegator = delegator;
};

@function MS1005_L02:setCheck(value)
{
	this.cbx1.setCheck(value);
};

@function MS1005_L02:onButton1Click(comp, info)
{
	//상단항목 이벤트 전달 중지
	info.stopPropagation();

	if(!this.cbx1.getCheck()) {
		this.cbx1.setCheck(true);
	}
	
	this.delegator.isAllChecked();

	if(afc.isIos)
	{
		var win = AWindow.createWindow('FD/window/MS1005_W03.lay','MS1005_W03');

		win.loadTitle = comp.parent.text;
		win.data = comp.parent.url;
		win.urlType = 1;
		win.enableZoom = comp.parent.zoom;
		win.openAsDialog(this, '100%', '100%');
	}
	else		// Android
	{
		AppManager.openPdfModule(comp.parent.url, comp.parent.text);
	}

};

@function MS1005_L02:onCheckBox1Click(comp, info)
{
	this.delegator.isAllChecked();
};



@function MS1005_L02:onWindowResult(result, awindow)
{
	if(result == 1) {
		this.cbx1.setCheck(true);
	}
	this.delegator.isAllChecked();
}