
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_L03()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function MS1005_L03:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.zipCode=this.findCompByGroup('zipCode')[0];
	this.roadAddr=this.findCompByGroup('roadAddr')[0];
	this.jibunAddr=this.findCompByGroup('jibunAddr')[0];

};

@function MS1005_L03:setData(data){
	this.zipCode.setText(data.zipNo);
	this.roadAddr.setText(data.roadAddr);
	this.jibunAddr.setText(data.jibunAddr);
};

@function MS1005_L03:getData(){
	var addrData = [{
	"zipNo":this.zipCode.getText()
	,"roadAddr":this.roadAddr.getText()
	,"jibunAddr":this.jibunAddr.getText()
	}];
	return addrData;
};