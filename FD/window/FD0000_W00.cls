
/**
Constructor
Do not call Function in Constructor.
*/

@class FD0000_W00(containerId)
{
	@super(containerId);

	this.isConfirm 			= false;
	this.contentView		= false;
	this.align				= 'center';
	this.text				= '';
	this.title				= '';
	this.btnTextArr			= ['확인', '취소'];
	
}
@extends BaseWindow;


@function FD0000_W00:onReady()
{
	@super.onReady();

	//TODO:edit here
	//컴포넌트 초기화 START ++++++++++++++++++++++++++++++
	
	var alertGrp = this.findCompByGroup('AlertGrp');
	
	this.titileLbl		= alertGrp[0];
	this.contentView	= alertGrp[1];
	this.contentView.$ele.css('text-align', this.align);
	this.contentView.$ele.css('max-height', '600px');
	this.contentView.$ele.css('overflow-y', 'auto');
	
	this.cancelBtn		= alertGrp[2];
	this.okBtn		= alertGrp[3];
	
	//this.frame.css('position', 'relative');
	this.frame.css('height', 'auto');
	
	//최초 실행 호출
	this.onInit();
};


//최초 실행
@function FD0000_W00:onInit()
{
	if(this.title) this.titileLbl.setText(this.title);
	this.contentView.$ele.html(this.text);
	if(this.btnTextArr) this.okBtn.setText(this.btnTextArr[0]);
	
	if(this.isConfirm)
	{
		this.cancelBtn.$ele.show();
		if(this.btnTextArr) this.cancelBtn.setText(this.btnTextArr[1]);
	}
	
	this.moveToCenter();
};

@function FD0000_W00:onCloseBtnClick(comp, info)
{
	this.close(0);
};

@function FD0000_W00:onCancelBtnClick(comp, info)
{
	this.close(0);
};

@function FD0000_W00:onOkBtnClick(comp, info)
{
	this.close(1);
};
