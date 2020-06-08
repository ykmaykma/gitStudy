
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_L02()
{
	@super();

}
@extends AView;


@function FD3202_L02:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.label = this.findCompByGroup('Gp')[0];
};

@function FD3202_L02:setData(data)
{
	this.data = data;
	this.label.setText(data[1]);
};


@function FD3202_L02:onBankRowClick(comp, info)
{
	this.getContainer().close(this.data);
};
