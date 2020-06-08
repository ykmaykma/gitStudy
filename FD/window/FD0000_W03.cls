
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_W03()
{
	@super();
	
	//this.winType = 'full';
	this.listView = null;
	this.defaultTitleArr = null;
	this.defaultNoticeArr = null;
}
@extends BaseWindow;


@function FD0000_W03:onReady()
{
	@super.onReady();
	/*
	this.baseH = this.view.$ele.height();
	
	this.frame.hide();
	this.frame.anima({y:-this.baseH, height:0});
	this.frame.anima({y:0, height:this.baseH}, 300);
	this.frame.show();
	*/
	this.listView = this.findCompById('ListView1');
	this.listView.setDelegator(this);	
	
	this.listView.removeAllItems();
	this.listView.setDividerColor('black');
	this.listView.addItem('FD/view/FD0000_L01.lay', [0]);
};

@function FD0000_W03:onCloseBtnClick(comp, info)
{
	this.close();
};

@function FD0000_W03:bindData(item, data, alistview)
{
	// data: index값
	item.view.data = data;
	item.view.label.$ele.html(this.defaultNoticeArr[data]);
	item.view.$ele.css('height', item.view.label.getHeight() + 20);
};

@function FD0000_W03:setNotice(noticeArr)
{
	var	nameArr = [],
		itemArr = [];
		
	for(var key in noticeArr){
		nameArr.push(noticeArr[key][0]);
		itemArr.push(noticeArr[key][1]);
	}
	
	this.defaultTitleArr = nameArr;
	this.defaultNoticeArr = itemArr;
};



