
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_L01()
{
	@super();

}
@extends AView;


@function MS1005_L01:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.label = this.findCompByGroup('Gp')[0];
};

@function MS1005_L01:setData(data)
{
	this.data = data;
	this.label.setText(data[1]);
};


@function MS1005_L01:onBankRowClick(comp, info)
{
	this.getContainer().close(this.data);
};
