
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002_T02()
{
	@super();

	this.tbvManager = null;

}
@extends AView;


@function FD5002_T02:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.tabView = this.findCompById('CenterView');	
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView, new RadioBtnManager(this));		

	this.tbvManager.addTab({url:'FD/view/FD5002_V03.lay', tabId:'FD5002_V03', name:'내보내기'});
	this.tbvManager.addTab({url:'FD/view/FD5002_V04.lay', tabId:'FD5002_V04', name:'내보내기 완료'});	
};

//화면이 활성화된 후 이벤트
@function FD5002_T02:onActiveDone(reload)
{	
	@super.onActiveDone(reload);
		
	this.tbvManager.changeTab('FD5002_V03');
};


