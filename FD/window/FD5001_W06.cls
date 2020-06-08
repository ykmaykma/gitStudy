
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001_W06(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5001_W06.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5001_W06:onReady()
{
	@super.onReady();

	//TODO:edit here

};


@function FD5001_W06:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.check = this.findCompById('CheckBox1');
	this.button = this.findCompById('Button1');
	this.button.enable(false);
	
};


@function FD5001_W06:onButton1Click(comp, info)
{

	//TODO:edit here
	this.close(0);
	
};

@function FD5001_W06:onCheckBox1Click(comp, info)
{

	//TODO:edit here
	
	if(this.check.getCheck() == true){
		this.button.enable(true);
	}else{
		this.button.enable(false);
	}

};
