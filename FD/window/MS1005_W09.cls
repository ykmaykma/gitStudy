
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W09(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	this.url = 'FD/window/MS1005_W09.lay';
	this.infoMsg = null;   //가운데 글자
	this.btnText = '확인'; //버튼 글자
}
@extends BaseWindow;


@function MS1005_W09:onReady()
{
	@super.onReady();

	this.msgLbl = this.findCompById('MsgLbl');
	this.btn = this.findCompById('Button2');
	
	this.msgLbl.$ele.html(this.infoMsg);
	this.btn.setText(this.btnText);
};

@function MS1005_W09:onButton2Click(comp, info)
{
	this.close(1);
};