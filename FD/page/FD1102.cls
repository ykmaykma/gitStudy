
/**
Constructor
Do not call Function in Constructor.
** 이용가이드 **
*/
@class FD1102()
{
	@super();

	//TODO:edit here

}
@extends BasePage;

@function FD1102:onReady()
{
	@super.onReady();
	this.webView = this.findCompById('WebView');
	this.webView.loadWebView('https://www.meritzam.com/fund/fund_application/');
};

@function FD1102:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1102:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD1102:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1102:refreshData() ');
};

@function FD1102:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

