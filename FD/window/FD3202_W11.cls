
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W11(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W11.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W11:onReady()
{
	@super.onReady();

	//TODO:edit here

};

@function FD3202_W11:onButton1Click(comp, info)
{

	//TODO:edit here
	this.close(0);

};

@function FD3202_W11:onButton2Click(comp, info)
{
	//TODO:edit here
	this.close(1);
};
