
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0001_W01(containerId)
{
	@super(containerId);

	this.topView = null;
}
@extends BaseWindow;


@function FD0001_W01:onReady()
{
	@super.onReady();
	
	this.topView = this.findCompById('View62');
};

@function FD0001_W01:onActiveDone(reload)
{
	@super.onActiveDone(reload);
// 	window.test = this;
	this.webView = this.findCompById('WebView');
	this.webView.$ele.html('<embed src="http://www.meritzasset.com/home/video.php" width="100%" height="100%">');
	this.view62 = this.findCompById('View62');
// 	this.webView.loadWebView("http://www.meritzasset.com/home/video.php");	
}

@function FD0001_W01:onCloseBtnClick(comp, info)
{
	this.close();
};


@function FD0001_W01:onButton8Click(comp, info)
{
	//가로모드로 전환
	if(theApp.screenMode == AppManager.SCREEN_ORIENTATION_PORTRAIT)
	{
		theApp.screenMode = AppManager.SCREEN_ORIENTATION_LANDSCAPE;
		this.webView.removeClass('webview');
		this.webView.addClass('webview2');
		this.view62.removeClass('header');
		this.view62.addClass('header2');
	}
	else
	{
		theApp.screenMode = AppManager.SCREEN_ORIENTATION_PORTRAIT;
		this.webView.addClass('webview');
		this.webView.removeClass('webview2');
		this.view62.addClass('header');
		this.view62.removeClass('header2');
	}
	
	AppManager.setPortrait(theApp.screenMode);
	
/*
	this.versionTimer = setInterval(function()
	{
	}, 500);
*/
};
