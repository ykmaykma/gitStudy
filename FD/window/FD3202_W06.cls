
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W06(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W06.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W06:onReady()
{
	@super.onReady();

	//TODO:edit here		

};


@function FD3202_W06:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.lblTitle = this.findCompById('lblTitle');
	
	this.webView = this.findCompById('View3');
	
	this.lblTitle.setText(this.loadTitle);
		
	this.webView.loadWebView(this.loadviewUrlAddr);
	
//	this.WebView1.setUrl('http://webmts.koscom.co.kr/notice/mts/Event/winEvent40Hy1.html');
	
};
@function FD3202_W06:onbtnCloseClick(comp, info)
{

	//TODO:edit here
	if(this.lblTitle.getText() == "약관동의"){
		this.close(3);
	}else if(this.lblTitle.getText() == "개인정보 수집 및 이용동의"){
		this.close(4);
	}else if(this.lblTitle.getText() == "개인정보 제 3자 제공동의"){
		this.close(5);
	}else{
		this.close(0);
	}
	
};
