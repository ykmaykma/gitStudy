
/**
Constructor
Do not call Function in Constructor.
** 은행이체한도 변경 **
*/
@class FD1303()
{
	@super();

	//TODO:edit here
}
@extends BasePage;

@function FD1303:onReady()
{
	@super.onReady();
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD1303:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1303:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD1303:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1303:refreshData() ');
};

@function FD1303:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


