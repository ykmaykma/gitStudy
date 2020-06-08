
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1403_W02(containerId)
{
	@super(containerId);
	
}
@extends BaseWindow;


@function FD1403_W02:onReady()
{
	@super.onReady();
};

@function FD1403_W02:onWillActive(reload)
{
	@super.onWillActive(reload);		
	
};


@function FD1403_W02:onbtnCloseClick(comp, info)
{	
	this.close(0);
};


@function FD1403_W02:onBTN_CONFIRMClick(comp, info)
{

	//TODO:edit here
	this.close(1);
};

@function FD1403_W02:onBTN_CANCELClick(comp, info)
{

	//TODO:edit here
	this.close(0);
};
