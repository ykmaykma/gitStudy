
/**
Constructor
Do not call Function in Constructor.
*/
//약관 팝업 
@class FD5001_W05(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5001_W05.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5001_W05:onReady()
{
	@super.onReady();

	//TODO:edit here		
};


@function FD5001_W05:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.lblTitle = this.findCompById('lblTitle');
	this.webView = this.findCompById('WebView');
	this.checkType = this.cType;
	this.lblTitle.setText(this.loadTitle);
	this.webView.loadWebView(this.loadViewUrlAddr);
};

@function FD5001_W05:onbtnCloseClick(comp, info)
{	
	if(this.checkType == '4'){
		this.close(1);
	}else{
		this.close(0);
	}
	
};
