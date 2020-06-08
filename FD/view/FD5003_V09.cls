
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5003_V09()
{
	@super();		
}
@extends AView;


@function FD5003_V09:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	// Object
	this.cont = this.getContainer();
	this.contTab = this.cont.tvManager.getActiveView();
	
	// 스크롤 관련 영역
	this.view1 = this.findCompById('View1');
};


// 뷰의 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5003_V09:onWillActive(reload)
{
	@super.onWillActive(reload);
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5003_V09:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};
	

// 뷰 비활성화가 시작되기 바로 전에 매번 호출된다
@function FD5003_V09:onWillDeactive(reload)
{		
	@super.onWillDeactive(reload);
	
	//스크롤 영역 변경	
	this.view1.scrollTo(0);
};


// 확인버튼 클릭
@function FD5003_V09:onbtnNextClick(comp, info)
{
	// 적립식 매수현황 페이지로 이동
	theApp.goPageCheck('FD5008', false, {tabId:'FD5008_T02'});
};


