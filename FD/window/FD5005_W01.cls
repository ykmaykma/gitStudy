
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5005_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5005_W01.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5005_W01:onReady()
{
	@super.onReady();

	//TODO:edit here
	
};

@function FD5005_W01:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
	
	this.woriName = this.findCompById('Label2')//이름
	this.name = this.findCompById('Label6')//이름
	this.woori = this.findCompById('Label7')//우리은행
	this.acc = this.findCompById('Label9')//계좌

	this.woriName.setText(this.accName);
	this.name.setText(this.accName);
	this.woori.setText('우리은행');
	this.acc.setText(this.account);
}

@function FD5005_W01:onCloseBtnClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD5005_W01:onOkBtnClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};
