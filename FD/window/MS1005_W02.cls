
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W02(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	this.url = 'FD/window/MS1005_W02.lay';

	this.infoView = null;
	this.infoMsg = null; // 가운데글자
	this.btnGroupId = null;
	this.btnType = 0;
	this.btnText = null; //버튼글자
}
@extends BaseWindow;


@function MS1005_W02:onReady()
{
	@super.onReady();

	this.label = this.findCompById('Label2');
	this.btn = this.findCompById('Button2');
	
	this.label.$ele.html(this.infoMsg);
	if( 1 == this.btnType )
	{
		this.btn.setText('동의');
	}
	if(this.btnText)
	{
		this.btn.setText(this.btnText);
	}
};


@function MS1005_W02:onButton2Click(comp, info)
{
	this.close(1);
};

@function MS1005_W02:onButtonCancel(comp, info)
{
	this.close(0);
};

