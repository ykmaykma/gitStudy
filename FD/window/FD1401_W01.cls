
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1401_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD1401_W01.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD1401_W01:onReady()
{
	@super.onReady();

	//TODO:edit here		

};


@function FD1401_W01:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.lblTitle = this.findCompById('lblTitle');
	this.webView = this.findCompById('WebView');

	this.lblTitle.setText(this.loadTitle);
	this.webView.loadWebView(this.loadviewUrlAddr);
	
};
@function FD1401_W01:onbtnCloseClick(comp, info)
{

	this.close(0);
	
};
