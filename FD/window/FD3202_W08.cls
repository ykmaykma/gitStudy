
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W08(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W08.lay';

}
@extends BaseWindow;

@function FD3202_W08:onReady()
{
	@super.onReady();
	
	var thisObj = this;

};

@function FD3202_W08:onButton1Click(comp, info)
{

	this.close(0);

};

@function FD3202_W08:onButton2Click(comp, info)
{

	this.close(1);

};
