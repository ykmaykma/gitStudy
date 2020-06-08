
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1501_W01(containerId)
{
	@super(containerId);

	this.urlType = null;
	this.titleText = null;
	this.enableZoom = null;
	this.lbl1 = null;
}
@extends BaseWindow;


@function FD1501_W01:onReady()
{
	@super.onReady();

	thisObj = this;
	this.webView = this.findCompById('WebView1');
	this.lbl1 = this.findCompById('Label1');
	this.lbl1.show(AComponent.VISIBLE);
	this.webView.show(AComponent.INVISIBLE);
	
	//넘어온 데이터에 따라 url세팅하기.
	if(this.data != null && typeof this.data != 'undefined') {
			this.webView.setDelegator(this);
			this.webView.setUrl(this.data);
			this.webView.enableZoom(true);
	} else {
		this.close(0);
	}
	
}; 

@function FD1501_W01:onButtonApply(comp, info)
{
	this.close(1);
};

@function FD1501_W01:onDocReady(comp, info)
{
	this.lbl1.show(AComponent.GONE);
	this.webView.show(AComponent.VISIBLE);
	if(this.enableZoom === undefined || this.enableZoom != false) {
		comp.zoom(0.5);
	}
};
