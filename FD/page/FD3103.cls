
/**
Constructor
Do not call Function in Constructor.
** 공시 **
*/
@class FD3103()
{
	@super();
	
	//TODO:edit here
}
@extends BasePage;

@function FD3103:onReady()
{
	@super.onReady();
};

@function FD3103:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD3103:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD3103:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD3103:refreshData() ');
};

@function FD3103:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

