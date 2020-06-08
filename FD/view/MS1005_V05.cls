
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_V05()
{
	@super();

}
@extends AView;


@function MS1005_V05:init(context, evtListener)
{
	@super.init(context, evtListener);
};

@function MS1005_V05:onPhotoBtnClick(comp, info)
{
	comp.parent.parent.parent.owner.parent.parent.OpenOCR();
};
