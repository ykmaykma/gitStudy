
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W08(containerId)
{
	@super(containerId);

	this.data = null;
}
@extends BaseWindow;

@function MS1005_W08:onReady()
{
	@super.onReady();
	
	this.listView = this.findCompById("ListView1");
	this.listView.setDelegator(this);	//bindData 실행위해
	this.listView.addItem('FD/view/MS1005_L01.lay',this.data);
};

@function MS1005_W08:setData(data) {
	
	this.data = data;
	//this.data.push(['', "신규 ID 생성"]);
};

@function MS1005_W08:bindData(item, data, alistview)
{
	if( item.view.setData) {
		item.view.setData(data);
	}
};