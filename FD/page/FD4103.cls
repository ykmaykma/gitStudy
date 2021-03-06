
/**
Constructor
Do not call Function in Constructor.
** 거래내역 **
*/

@class FD4103()
{
	@super();
	
	//TODO:edit here
}
@extends BasePage;

@function FD4103:onReady()
{
	@super.onReady();
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD4103:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD4103:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD4103:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD4103:refreshData() ');
};

@function FD4103:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

