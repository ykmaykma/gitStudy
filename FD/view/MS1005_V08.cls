
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_V08()
{
	@super();

}
@extends AView;


@function MS1005_V08:init(context, evtListener)
{
	@super.init(context, evtListener);
};


@function MS1005_V08:startShowRP()
{
	this.vrView = this.findCompById('View2');
	VRManager.showRP(this.vrView.$ele);
};

@function MS1005_V08:startEndRP()
{
	VRManager.endRP();
};

@function MS1005_V08:onPhotoBtnClick(comp, info)
{
	this.startEndRP();
	comp.parent.parent.parent.owner.parent.parent.startVR();
};
