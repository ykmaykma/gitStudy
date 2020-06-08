
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0100_W03()
{
	@super();
	
	this.winType = 'full';
}
@extends BaseWindow;


@function FD0100_W03:onReady()
{
	this.baseW = this.view.$ele.width();
	
	this.view4 = this.findCompById('View4');
	
	this.titleLbl = this.findCompById('TitleLbl');
	this.closeBtn = this.findCompById('CloseBtn');
	
	this.titleLbl.setPos({left: (this.baseW / 2) - (this.titleLbl.getWidth() / 2), top:0});
	this.closeBtn.setPos({left: this.baseW - this.closeBtn.getWidth(), top:0});
	
	this.view4.viewLoad('FD/view/FD0100_T01.lay');
	
	@super.onReady();
	/*
	this.frame.anima({x:this.baseW, width:0});
	this.frame.anima({x:0, width:this.baseW}, 500);
	*/
};

@function FD0100_W03:onCloseBtnClick(comp, info)
{
	this.close();
};

