
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W14(containerId)
{
	@super(containerId);
	//TODO:edit here

}
@extends AWindow;


@function FD0000_W14:onReady()
{
	@super.onReady();
	//TODO:edit here

};

@function FD0000_W14:onButton1Click(comp, info)
{
	//TODO:edit here
	this.close(0);
};

@function FD0000_W14:onBtnWeekClick(comp, info)
{
	//TODO:edit here
	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate()+6);
	now2 = now.format('yyyyMMdd');
	
	theApp.prefInfo.set('EventDate3', now2);

	this.close(0);

};
