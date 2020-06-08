
/**
Constructor
Do not call Function in Constructor.
*/
@class NativeWebView()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function NativeWebView:init(context, evtListener)
{

	@super.init(context, evtListener);

	this.getContainer().useNative = true;
    this.getContainer().webViewList.push(this);
	
	
};

@function NativeWebView:loadWebView(url){
	
	if(afc.isIos) {
		AppManager.loadWebView(this.$ele, url);
	} else if(afc.isAndroid) {
		WebViewManager.loadWebView(this.$ele, url);
	}
};

@function NativeWebView:destroyWebView()
{
	if(afc.isIos) {
		AppManager.destroyWebView(this.$ele);
	} else if(afc.isAndroid) {
		WebViewManager.destroyWebView(this.$ele);
	}
};

NativeWebView.bringToFront = function(isFront)
{
	if(afc.isIos) {
		AppManager.bringToFront(isFront);
	} else if(afc.isAndroid) {
		WebViewManager.bringToFront(isFront);
	}
};