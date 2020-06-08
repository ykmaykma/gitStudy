
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W07(containerId)
{
	@super(containerId);

	this.titleText = '안내';
	this.isAppClose = false;
	this.infoMsg = null;
	this.btnText = '확인';
	this.processType = '0';
}
@extends BaseWindow;


@function MS1005_W07:onReady()
{
	@super.onReady();
	
	this.msgLbl = this.findCompById('MsgLbl');
	this.btn = this.findCompById('Button2');
	this.label2 = this.findCompById('Label2');
	this.view4 = this.findCompById('View4');
	
	this.label2.setText(DEFINE_VERSION);
	
	if(this.isAppClose) this.label2.show(AComponent.VISIBLE);
	else this.label2.show(AComponent.INVISIBLE);
	
	this.msgLbl.$ele.html(this.infoMsg);
	this.btn.setText(this.btnText);
		
	this.moveToCenter();
};


@function MS1005_W07:onButton2Click(comp, info)
{
	this.close(1);
};

@function MS1005_W07:onButtonCancel(comp, info)
{
	this.close(0);
};
