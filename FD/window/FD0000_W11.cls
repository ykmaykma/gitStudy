
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W11(containerId)
{
	@super(containerId);

}
@extends BaseWindow;


@function FD0000_W11:onReady()
{
	@super.onReady();

	//TODO:edit here

};


@function FD0000_W11:onBtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD0000_W11:onBtnTodayClick(comp, info)
{

	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate());
	now2 = now.format('yyyyMMdd');								

	theApp.prefInfo.set('EventDate2', now2);

	//TODO:edit here
	this.close(0);

};


@function FD0000_W11:onBtnBuyClick(comp, info)
{
	//TODO:edit here
	this.close(1);

};