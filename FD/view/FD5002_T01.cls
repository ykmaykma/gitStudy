
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_T01()
{
	@super();

	this.tbvManager = null;

}
@extends AView;


@function FD5002_T01:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.tabView = this.findCompById('CenterView');	
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView, new RadioBtnManager(this));		

	this.tbvManager.addTab({url:'FD/view/FD5002_V01.lay', tabId:'FD5002_V01', name:'가져오기'});
	this.tbvManager.addTab({url:'FD/view/FD5002_V02.lay', tabId:'FD5002_V02', name:'가져오기 완료'});
};

//화면이 활성화된 후 이벤트
@function FD5002_T01:onActiveDone(reload)
{	
	@super.onActiveDone(reload);
		
	this.tbvManager.changeTab('FD5002_V01');
};


