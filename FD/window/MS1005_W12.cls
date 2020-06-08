
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W12(containerId)
{
	@super(containerId);
	
	//this.rManager = null;
}
@extends BaseWindow;


@function MS1005_W12:onReady()
{
	
	this.title = this.findCompById('Title');
	this.rbManager = new RadioBtnManager();
	this.skt = this.findCompById("SKT");
	
	this.title.setText(this.titleText);
	
	this.webView = this.findCompById('WebView');
	this.webGroup = this.findCompByGroup('WebGroup');
	if(this.data != null && typeof this.data != 'undefined') {
		this.webGroup[0].setDelegator(this);
		this.webGroup[1].setDelegator(this);
		this.webGroup[2].setDelegator(this);
		this.webGroup[0].enableZoom(true);
		this.webGroup[1].enableZoom(true);
		this.webGroup[2].enableZoom(true);
		this.webGroup[0].setUrl(this.data[0]);
		this.webGroup[1].setUrl(this.data[1]);
		this.webGroup[2].setUrl(this.data[2]);
		this.onSKTActionUp(this.skt);
	} else {
		this.close(0);
	}
	
	@super.onReady();
};

@function MS1005_W12:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function MS1005_W12:onDocReady(awebview, contentDocument)
{
	awebview.zoom(0.7);
};

@function MS1005_W12:onImage1ActionDown(comp, info)
{
	this.close(0);
};

@function MS1005_W12:onSKTActionUp(comp, info)
{
	this.rbManager.selectButton(comp);
	this.webGroup[0].$ele.show();
	this.webGroup[1].$ele.hide();
	this.webGroup[2].$ele.hide();
};

@function MS1005_W12:onKTActionUp(comp, info)
{
	this.rbManager.selectButton(comp);
	this.webGroup[1].$ele.show();
	this.webGroup[0].$ele.hide();
	this.webGroup[2].$ele.hide();
};

@function MS1005_W12:onLGUActionUp(comp, info)
{
	this.rbManager.selectButton(comp);
	this.webGroup[2].$ele.show();
	this.webGroup[1].$ele.hide();
	this.webGroup[0].$ele.hide();
};