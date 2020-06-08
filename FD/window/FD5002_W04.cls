
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_W04(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5002_W04.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5002_W04:onReady()
{
	@super.onReady();
};


// 연금저축계좌개설[계약이전(계좌이체)] 페이지로 이동
@function FD5002_W04:onConfirmBtnClick(comp, info)
{
	this.close(0);
	
	// 연금저축계좌개설로 이동
	theApp.goPageCheck('FD5001', false, {tabId:'FD5001_T02'});
};


