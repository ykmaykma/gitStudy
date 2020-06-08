
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1401_W02(containerId)
{
	@super(containerId);
	//TODO:edit here

}
@extends BaseWindow;


@function FD1401_W02:onReady()
{
	@super.onReady();			
};

@function FD1401_W02:onWillActive(reload)
{
	@super.onWillActive(reload);
			
	this.webView = this.findCompById('WebView');
};



@function FD1401_W02:onActiveDone(reload){
	
	@super.onActiveDone(reload);
			
};


@function FD1401_W02:onbtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);
};
