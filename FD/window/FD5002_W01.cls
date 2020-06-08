
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5002_W01.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5002_W01:onReady()
{
	@super.onReady();
};


// X 버튼 또는 확인 버튼 클릭
@function FD5002_W01:onBtnCloseClick(comp, info)
{
	this.close(0);
};


