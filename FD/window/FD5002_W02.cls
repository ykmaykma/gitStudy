
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_W02(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5002_W02.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5002_W02:onReady()
{
	@super.onReady();

};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5002_W02:onActiveDone(reload)
{
	@super.onActiveDone(reload);

	this.lblTitle = this.findCompById('lblTitle');
	this.webView = this.findCompById('WebView');

	this.lblTitle.setText(this.loadTitle);
	this.webView.loadWebView(this.loadViewUrlAddr);
};


// X 버튼 또는 확인 버튼 클릭
@function FD5002_W02:onBtnCloseClick(comp, info)
{
	this.close(0);
};


