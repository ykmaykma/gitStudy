
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5003_W03(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5003_W03.lay';

	//TODO:edit here

}
@extends AWindow;


@function FD5003_W03:onReady()
{
	@super.onReady();

	// 펀드내용
	this.fundContent = this.findCompById('lblFundContent');
		
	// 컴포넌트 초기화
	this.onInitComponents();
};


// 컴포넌트 초기화
@function FD5003_W03:onInitComponents()
{
	// 펀드내용 셋팅
	this.fundContent.setText(this.w_fundContent);
};


// X 버튼 또는 확인 버튼 클릭
@function FD5003_W03:onBtnCloseClick(comp, info)
{
	this.close(0);
};


