
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1006()
{
	@super();

	this.selectedView = null;
}
@extends APage;


@function MS1006:onReady()
{
	@super.onReady();
	
	this.guideView = this.findCompById('GuideView');
	this.guideView.viewLoad('FD/view/MS1005_T00.lay');
};

@function MS1006:onActive(reload)
{
	@super.onActive(reload);
	
	if(reload) {
		AppManager.endOltp();
		AppManager.hidePatchView();
	}
	
	 theApp.initNotice();
	
};

@function MS1006:onNextBtnClick(comp, info)
{
	this.navigator.goPage('MS1005',false);	
};
