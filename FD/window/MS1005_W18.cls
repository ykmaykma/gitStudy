
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W18(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/MS1005_W18.lay';

	//TODO:edit here

}
@extends AWindow;


@function MS1005_W18:onReady()
{
	@super.onReady();

	//TODO:edit here

};

@function MS1005_W18:onButtonCancel(comp, info)
{
	//TODO:edit here
	this.close(1);
};

@function MS1005_W18:onButton2Click(comp, info)
{

	//TODO:edit here
	this.close(2);

};
