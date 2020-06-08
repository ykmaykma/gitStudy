
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5007_W03(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5007_W03.lay';

	//TODO:edit here

}
@extends AWindow;


@function FD5007_W03:onReady()
{
	@super.onReady();
	
	// Object
	this.cont = this.opener.getContainer();
	
	// 컴포넌트
	this.View1 = this.findCompById('View1');
	
	// 컴포넌트 셋팅
	this.onSetComponents();
};


// 컴포넌트 셋팅
@function FD5007_W03:onSetComponents()
{
	
	var content = this.w_userNm + '님의 납입가능금액은<br>'
				+ '<b>' + afc.addComma(this.w_money*1+this.contractMoney*1) + '원</b> 입니다.';
				
	this.View1.$ele.html(content);
	this.View1.$ele.css('text-align', 'center');
};


// X 버튼 또는 확인 버튼 클릭
@function FD5007_W03:onBtnCloseClick(comp, info)
{
	this.close(0);
};


