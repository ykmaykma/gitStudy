
/**
Constructor
Do not call Function in Constructor.
** 매도예상금액조회(가계산) **
*/

@class FD4104()
{
	@super();
	
	//TODO:edit here
}
@extends BasePage;

@function FD4104:onReady()
{
	@super.onReady();
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD4104:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD4104:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD4104:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD4104:refreshData() ');
};

@function FD4104:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

