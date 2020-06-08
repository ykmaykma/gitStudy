
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001_W03(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5001_W03.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5001_W03:onReady()
{
	@super.onReady();

};

@function FD5001_W03:onActiveDone(reload)
{	
	@super.onActiveDone(reload);

	this.View1 = this.findCompById('View1');
	
	
	var content = this.param.name + '님의 납입가능금액은<br>'
				+ '<b>' + afc.addComma(this.param.limitPay) + '원</b> 입니다.';
				
	this.View1.$ele.children().children().eq(0).html(content);
}

@function FD5001_W03:onButton1Click(comp, info)
{

	//TODO:edit here
	this.close(0);
};

@function FD5001_W03:onCloseBtnClick(comp, info)
{

	//TODO:edit here
	this.close(0);

};
