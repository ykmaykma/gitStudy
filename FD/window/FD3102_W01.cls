
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3102_W01(containerId)
{
	@super(containerId);

	//TODO:edit here
	//this.paraFundInfo = null;

	
	this.contiKey = null; //next 키	
	this.pivotView = null;
	
	//20180316
	this.webView = null;
	this.title = '';
}

//@extends AWindow;
@extends BaseWindow;


@function FD3102_W01:onReady()
{
	@super.onReady();

	//20180316
	this.webView = this.findCompById('WebView1');
	//this.webView.setUrl(this.viewLink);
	this.webView.loadWebView(this.viewLink);
};

@function FD3102_W01:onWillActive(reload)
{
	@super.onWillActive(reload);
};

@function FD3102_W01:onbtnCloseClick(comp, info)
{
	//TODO:edit here
	this.close();
};

@function FD3102_W01:onButton3Click(comp, info)
{

	//TODO:edit here
	this.close();

};