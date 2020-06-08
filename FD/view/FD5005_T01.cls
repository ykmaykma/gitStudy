
/**
Constructor
Do not call Function in Constructor.
*/
//입금 tab
@class FD5005_T01()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD5005_T01:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	
	
	this.tabView1 = this.findCompById('TabView1');
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView1, new RadioBtnManager(this));	
	this.tbvManager.addTab({url:'FD/view/FD5005_V01.lay', tabId:'FD5005_V01', name:'입금1'});	
	this.tbvManager.addTab({url:'FD/view/FD5005_V02.lay', tabId:'FD5005_V02', name:'입금2'});	
	this.tbvManager.addTab({url:'FD/view/FD5005_V03.lay', tabId:'FD5005_V03', name:'입금3'});

	

};

@function FD5005_T01:onActiveDone(reload)
{	
	
	@super.onActiveDone(reload);
	this.tbvManager.changeTab('FD5005_V01');
};
