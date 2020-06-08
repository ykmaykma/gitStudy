
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W04(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W04.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W04:onReady()
{
	@super.onReady();

	//TODO:edit here

	

};

@function FD3202_W04:onActiveDone(reload)
{
	@super.onActiveDone(reload);
		
	this.btnConfirm = this.findCompById('btnConfirm');
	
	this.CheckBox1 = this.findCompById('CheckBox1');
	this.CheckBox2 = this.findCompById('CheckBox2');
	
	// 화면을 띄울때마다 초기화
	this.btnConfirm.enable(false);
	
	this.CheckBox1.setCheck(false);
	this.CheckBox2.setCheck(false);
	
};


@function FD3202_W04:onbtnCloseClick(comp, info)
{
	//TODO:edit here
	this.close(0);
};

@function FD3202_W04:onCheckBoxClick(comp, info)
{
	//TODO:edit here
	
	if(this.CheckBox1.getCheck() && this.CheckBox2.getCheck()){
		this.btnConfirm.enable(true);
	}else{
		this.btnConfirm.enable(false);
	}

};

@function FD3202_W04:onbtnConfirmClick(comp, info)
{

	//TODO:edit here
	this.close(1);
};
