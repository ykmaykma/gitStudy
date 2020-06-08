
/**
Constructor
Do not call Function in Constructor.
** 펀드계좌정보 **
*/

@class FD2202()
{
	@super();
	
	//TODO:edit here
}
@extends BasePage;

@function FD2202:onReady()
{
	@super.onReady();
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD2202:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD2202:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD2202:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD2202:refreshData() ');
};

@function FD2202:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

