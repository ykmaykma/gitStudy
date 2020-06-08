
/**
Constructor
Do not call Function in Constructor.
** 펀드가입 **
*/
@class FD3201()
{
	@super();

	//TODO:edit here

}
@extends BasePage;

@function FD3201:onReady()
{
	@super.onReady();
};

@function FD3201:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD3201:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD3201:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD3201:refreshData() ');
};

@function FD3201:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};
