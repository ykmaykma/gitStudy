
/**
Constructor
Do not call Function in Constructor.
*/
@class FD4102_V03()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD4102_V03:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.color = this.findCompByGroup('B')[0];
	this.name = this.findCompByGroup('B')[1];
	this.amount = this.findCompByGroup('B')[2];
	//TODO:edit here

};

@function FD4102_V03:setData(data)
{
	this.data = data;
	
	this.color.setStyle('background-color', data['color']);
	this.name.setText(data['name']);
	
	if(data['data'] == 0) {
		this.amount.setText('0%');
	} else if(data['data'] == 100) {
		this.amount.setText('100%');
	} else {
		this.amount.setText(afc.floor2Per(data['data']));
	}
	this.$ele.height(this.name.$ele.height());
	this.$ele.css('margin-bottom', '26px');
};
