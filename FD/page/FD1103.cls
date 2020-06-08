
/**
Constructor
Do not call Function in Constructor.
** 공지사항 **
*/
@class FD1103()
{
	@super();

	//TODO:edit here

}
@extends BasePage;

@function FD1103:onReady()
{
	@super.onReady();
	
};

@function FD1103:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1103:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	this.webView = this.findCompById('WebView');
	this.webView.loadWebView('https://www.meritzam.com/category/finance_info/info/manage_notice');
};

@function FD1103:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	//afc.log(this.getId()+' -> FD1103:refreshData() ');
};

@function FD1103:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

