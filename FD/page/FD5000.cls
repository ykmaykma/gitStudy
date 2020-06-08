
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5000()
{
	@super();
}
@extends APage;


@function FD5000:onReady()
{
	@super.onReady();

	// 스크롤 영역
	this.View1 = this.findCompById('View1');
	
	// 버튼
	this.Button1 = this.findCompById('Button1');
};


// 뷰의 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5000:onWillActive(reload)
{
	@super.onWillActive(reload);
	
	// 버튼 비활성화
	this.Button1.enable(false);
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5000:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};
	

// 뷰 비활성화가 시작되기 바로 전에 매번 호출된다
@function FD5000:onWillDeactive(reload)
{		
	@super.onWillDeactive(reload);
	
	this.View1.$ele.scrollTop(0);
};


// 내용보기 버튼
@function FD5000:onbtnShowContentsClick(comp, info)
{
	// 팝업 오픈
	var param = {
		viewUrl : "http://www.meritzam.com/marketings/terms21.html",
		title 	: "안내문",
		btnType : "0"
	}
	PensionCommon.fullSizePopup(this, param);
};


// 뒤로가기 버튼
@function FD5000:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


