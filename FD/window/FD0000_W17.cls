
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W17(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD0000_W17.lay';

	//TODO:edit here

}
@extends AWindow;


@function FD0000_W17:onReady()
{
	@super.onReady();

};

@function FD0000_W17:onButtonGoNext(comp, info)
{
	//TODO:edit here
	this.close(0);
};

@function FD0000_W17:onCheckBox1Click(comp, info)
{
	//TODO:edit here
	var now = new Date();
	var now2 = null;

	now.setDate(now.getDate());
	now2 = now.format('yyyyMMdd');
	
	theApp.prefInfo.set('MonthBuyStepDate', now2);

	this.close(0);

};
