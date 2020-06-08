
/**
Constructor
Do not call Function in Constructor.
** 자산현황 **
*/
@class FD4101()
{
	@super();

	//TODO:edit here

}
@extends BasePage;

@function FD4101:onReady()
{
	@super.onReady();
};

@function FD4101:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD4101:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD4101:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD4101:refreshData() ');
};

@function FD4101:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

