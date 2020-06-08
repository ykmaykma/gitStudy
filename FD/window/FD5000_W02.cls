
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5000_W02(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5000_W02.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5000_W02:onReady()
{
	@super.onReady();

	//TODO:edit here		
};


@function FD5000_W02:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.lblTitle = this.findCompById('lblTitle');
	this.webView = this.findCompById('WebView');
	this.checkType = this.cType;
	this.lblTitle.setText(this.loadTitle);
	this.webView.loadWebView(this.loadViewUrlAddr);
};

@function FD5000_W02:onbtnCloseClick(comp, info)
{	
	if(this.checkType == '4'){
		this.close(1);
	}else{
		this.close(0);
	}
	
};
