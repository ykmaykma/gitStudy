
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0200_W02(containerId)
{
	@super(containerId);
	
	//this.rManager = null;
}
@extends BaseWindow;


@function FD0200_W02:onReady()
{

	
	this.title = this.findCompById('Title');
	this.rbManager = new RadioBtnManager();
	this.skt = this.findCompById("SKT");
	this.kt = this.findCompById("KT");
	this.lgu = this.findCompById("LGU");
	
	
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

@function FD0200_W02:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD0200_W02:onDocReady(awebview, contentDocument)
{
	awebview.zoom(0.7);
};

@function FD0200_W02:onImage1ActionDown(comp, info)
{
	this.close(0);
};

@function FD0200_W02:onSKTActionUp(comp, info)
{
	this.skt.addClass('on');
	this.kt.removeClass('on');
	this.lgu.removeClass('on');
	this.rbManager.selectButton(comp);	
	this.webGroup[0].$ele.show();
	this.webGroup[1].$ele.hide();
	this.webGroup[2].$ele.hide();
};

@function FD0200_W02:onKTActionUp(comp, info)
{

	this.skt.removeClass('on');
	this.kt.addClass('on');
	this.lgu.removeClass('on');
	this.rbManager.selectButton(comp);
	this.webGroup[1].$ele.show();
	this.webGroup[0].$ele.hide();
	this.webGroup[2].$ele.hide();
};

@function FD0200_W02:onLGUActionUp(comp, info)
{
	this.skt.removeClass('on');
	this.kt.removeClass('on');
	this.lgu.addClass('on');
	this.rbManager.selectButton(comp);
	this.webGroup[2].$ele.show();
	this.webGroup[1].$ele.hide();
	this.webGroup[0].$ele.hide();
};
@function FD0200_W02:onCancelBtnClick(comp, info)
{


	this.close(0);

};
