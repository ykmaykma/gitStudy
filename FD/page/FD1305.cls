
/**
Constructor
Do not call Function in Constructor.
** ID비밀번호 변경 **
*/
@class FD1305()
{
	@super();

	//TODO:edit here
}
@extends BasePage;

@function FD1305:onReady()
{
	@super.onReady();
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD1305:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1305:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD1305:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1305:refreshData() ');
};

@function FD1305:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

