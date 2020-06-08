
/**
Constructor
Do not call Function in Constructor.
** 약관조회 **
*/
@class FD1501()
{
	@super();
}
@extends BasePage;


@function FD1501:onReady()
{
	@super.onReady();
};

@function FD1501:onWillActive(reload)
{
	@super.onWillActive(reload);
};

@function FD1501:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	this.webView = this.findCompById('WebView');
	this.webView.loadWebView('https://www.meritzam.com/termsinfo/');
};

@function FD1501:onWillDeactive()
{
	@super.onWillDeactive();
};


@function FD1501:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

