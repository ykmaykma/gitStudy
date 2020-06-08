
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_V07()
{
	@super();

}
@extends AView;


@function MS1005_V07:init(context, evtListener)
{
	@super.init(context, evtListener);
};

@function MS1005_V07:onPhotoBtnClick(comp, info)
{
	comp.parent.parent.parent.owner.parent.parent.startVR();
};
