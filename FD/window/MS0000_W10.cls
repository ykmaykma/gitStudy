
/**
Constructor
Do not call Function in Constructor.
*/
@class MS0000_W10(containerId)
{
	@super(containerId);

}
@extends BaseWindow;

@function MS0000_W10:onReady()
{
	@super.onReady();

	//TODO:edit here

};


@function MS0000_W10:onBtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function MS0000_W10:onBtnTodayClick(comp, info)
{

	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate());
	now2 = now.format('yyyyMMdd');								

	//theApp.prefInfo.set('NoticeEvent', now2);
	AppManager.setPref('NoticeEvent2', now2);
	//TODO:edit here
	this.close(0);

};
