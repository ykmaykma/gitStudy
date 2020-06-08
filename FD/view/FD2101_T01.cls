
/**
Constructor
Do not call Function in Constructor.
*/
@class FD2101_T01()
{
	@super();	

	this.tvManager = null;
}

@extends AView;

//초기화
@function FD2101_T01:onArrInit()
{	

};

@function FD2101_T01:init(context, evtListener)
{
	@super.init(context, evtListener);	
	//tabView
	this.tvManager = new TabViewManager();
	this.tvManager.initManager(this.findCompById('CenterView'), new RadioBtnManager(this));
	
	//탭뷰매니저 초기화
	this.tvManager.addTab({name:'Tab01', url:'FD/view/FD2101_V11.lay', tabId:'TabBtn1'});
	this.tvManager.addTab({name:'Tab02', url:'FD/view/FD2101_V12.lay', tabId:'TabBtn2'});
	this.tvManager.addTab({name:'Tab03', url:'FD/view/FD2101_V13.lay', tabId:'TabBtn3'});
};

//화면이 활성화된 후 이벤트
@function FD2101_T01:onActiveDone(reload)
{	@super.onActiveDone(reload);		
	this.tvManager.changeTab('TabBtn1');
};

//화면이 소멸되기 전 이벤트
@function FD2101_T01:onWillDeactive(reload)
{	
	this.onArrInit();
};
