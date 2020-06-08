
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5001_W01.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5001_W01:onReady()
{
	@super.onReady();

	//TODO:edit here
	

};
@function FD5001_W01:onActiveDone(reload)
{
	@super.onActiveDone(reload);

	//TODO:edit here
	
	this.textField1 = this.findCompById('TextField1');

}
@function FD5001_W01:onCancelWindowBtnClick(comp, info)
{

	//TODO:edit here
	
	this.close(0);

};

@function FD5001_W01:onButton1Click(comp, info)
{

	//TODO:edit here
	
	if(this.textField1.getText() >= 5){
		this.close({"key" : "1", "data" : this.textField1.getText()});
	}else{
		AToast.show('저축기간은 최소 5년 이상 입력해주십시오');
	}

};
