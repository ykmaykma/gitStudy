
/**
Constructor
Do not call Function in Constructor.
*/

@class FD0000_W04(containerId)
{
	@super(containerId);

	this.contentView		= false;
	this.align				= 'left';
	this.text				= '';
}
@extends BaseWindow;


@function FD0000_W04:onReady()
{
	@super.onReady();

	//컴포넌트 초기화 START ++++++++++++++++++++++++++++++
	
	var alertGrp = this.findCompByGroup('AlertGrp');
	
	this.contentView	= alertGrp[0];
	this.contentView.$ele.css('text-align', this.align);
	this.contentView.$ele.css('max-height', '600px');
	this.contentView.$ele.css('overflow-y', 'auto');
	
	this.frame.css('height', 'auto');
	
	//최초 실행 호출
	this.onInit();
};


//최초 실행
@function FD0000_W04:onInit()
{
	this.contentView.$ele.html(this.text);
	
	this.moveToCenter();
};

@function FD0000_W04:onCloseBtnClick(comp, info)
{
	this.close(0);
};

@function FD0000_W04:setNotice(noticeArr)
{
	this.text = noticeArr;
};
