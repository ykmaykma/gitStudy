
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5001_T02()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD5001_T02:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	
	
	this.tabView1 = this.findCompById('TabView1');
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView1, new RadioBtnManager(this));	
	this.tbvManager.addTab({url:'FD/view/FD5001_V05.lay', tabId:'FD5001_V05', name:'약관 및 주요사항 확인'});
	this.tbvManager.addTab({url:'FD/view/FD5001_V06.lay', tabId:'FD5001_V06', name:'개설'});
	
};


@function FD5001_T02:onActiveDone(reload)
{	
	
	@super.onActiveDone(reload);
	
	this.tbvManager.changeTab('FD5001_V05');
};
