
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_V04()
{
	@super();
}
@extends AView;


@function FD5002_V04:init(context, evtListener)
{
	@super.init(context, evtListener);

	// Object
	this.cont = this.getContainer();
};


// 확인 버튼 클릭
@function FD5002_V04:onBtnCheckClick(comp, info)
{
	// 이체진행상황으로 이동
	this.cont.tvManager.changeTab('FD5002_T03');
};


