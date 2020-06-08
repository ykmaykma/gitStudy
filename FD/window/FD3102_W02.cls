
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3102_W02(containerId)
{
	@super(containerId);

	//TODO:edit here
	//20180316
	this.webView = null;
}

//@extends AWindow;
@extends BaseWindow;


@function FD3102_W02:onReady()
{
	@super.onReady();
	//20180316
	this.webView = this.findCompById('WebView1');
	//this.webView.setUrl(this.viewLink);
	this.webView.loadWebView(this.viewLink);
};


@function FD3102_W02:onWillActive(reload)
{
	@super.onWillActive(reload);
};




@function FD3102_W02:onbtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close();
};

@function FD3102_W02:onButton1Click(comp, info)
{

	//TODO:edit here
	this.close();
};

