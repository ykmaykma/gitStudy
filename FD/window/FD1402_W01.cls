
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1402_W01(containerId)
{
	@super(containerId);
	//TODO:edit here

}
@extends BaseWindow;


@function FD1402_W01:onReady()
{
	@super.onReady();			
};

@function FD1402_W01:onWillActive(reload)
{
	@super.onWillActive(reload);
			
};



@function FD1402_W01:onActiveDone(reload){
	
	@super.onActiveDone(reload);
			
};


@function FD1402_W01:onbtnCloseClick(comp, info)
{

	//TODO:edit here
	this.close(0);
};
