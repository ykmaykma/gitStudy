
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_L01()
{
	@super();

	this.label = null;
	this.contentView = false;
}
@extends AView;


@function FD0000_L01:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.label = this.findCompByGroup('NoticeGrp')[0];
	//this.contentView = this.findCompByGroup('NoticeGrp')[0];
};
