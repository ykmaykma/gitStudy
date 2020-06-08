
/**
Constructor
Do not call Function in Constructor.
*/
//출금 tab
@class FD5005_T02()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD5005_T02:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	
	this.tabView1 = this.findCompById('TabView1');
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView1, new RadioBtnManager(this));	
	this.tbvManager.addTab({url:'FD/view/FD5005_V04.lay', tabId:'FD5005_V04', name:'출금1'});	
	this.tbvManager.addTab({url:'FD/view/FD5005_V05.lay', tabId:'FD5005_V05', name:'출금2'});	
	this.tbvManager.addTab({url:'FD/view/FD5005_V06.lay', tabId:'FD5005_V06', name:'출금3'});

};


@function FD5005_T02:onActiveDone(reload)
{	
	
	@super.onActiveDone(reload);
	
	this.tbvManager.changeTab('FD5005_V04');
};
