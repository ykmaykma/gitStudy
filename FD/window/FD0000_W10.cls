
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W10(containerId)
{
	@super(containerId);

}
@extends BaseWindow;


@function FD0000_W10:onReady()
{
	@super.onReady();

	//TODO:edit here

};


@function FD0000_W10:onBtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD0000_W10:onBtnTodayClick(comp, info)
{

	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate());
	now2 = now.format('yyyyMMdd');								

	theApp.prefInfo.set('EventDate3', now2);

	//TODO:edit here
	this.close(0);

};
