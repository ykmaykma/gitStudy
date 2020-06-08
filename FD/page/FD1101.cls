
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1101()
{
	@super();
}
@extends BasePage;

@function FD1101:onReady()
{
	@super.onReady();

	this.title = this.findCompById('Label1');

	if(this.pageData && this.pageData.title) {
		this.title.setText(this.pageData.title);
	}
};

@function FD1101:onActiveDone(reload)
{
	@super.onActiveDone(reload);

	this.webView = this.findCompById('WebView');
	
	this.webView.loadWebView("https://www.meritzam.com/fund"); //ÆÝµå¼±¹°

};

@function FD1101:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};
