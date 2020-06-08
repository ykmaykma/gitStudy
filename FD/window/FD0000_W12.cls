
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W12(containerId)
{
	@super(containerId);

}
@extends BaseWindow;


@function FD0000_W12:onReady()
{
	@super.onReady();

	//TODO:edit here

};


@function FD0000_W12:onBtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD0000_W12:onBtnTodayClick(comp, info)
{

	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate());
	now2 = now.format('yyyyMMdd');								

	theApp.prefInfo.set('EventDate3', now2);

	//TODO:edit here
	this.close(0);

};


@function FD0000_W12:onBtnDetailClick(comp, info)
{

	//TODO:edit here	
	var fundGoPage = 'https://www.meritzam.com/14795/';
	
	// 해당 URL로 웹페이지 열기
	AppManager.goUrl(fundGoPage);
	
	this.close(0);

};
