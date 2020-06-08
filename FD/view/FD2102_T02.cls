
/**
Constructor
Do not call Function in Constructor.
*/
@class FD2102_T02()
{
	@super();	
}
@extends AView;


//초기화
@function FD2102_T02:onArrInit()
{	
};


@function FD2102_T02:init(context, evtListener)
{
	@super.init(context, evtListener);	
			
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
};


//화면이 활성화된 후 이벤트
@function FD2102_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);		
	this.accView.doInitAccInfo(0);	
};


//화면이 소멸되기 전 이벤트
@function FD2102_T02:onWillDeactive(reload)
{		
	this.onArrInit();
};
