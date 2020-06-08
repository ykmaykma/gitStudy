/**
Constructor
Do not call Function in Constructor.
** 잔고증명서발급 신청/조회 **
*/

@class FD1202()
{
	@super();

	this.tbvManager = null;
	this.tabIdMap = 
	[
		["신청", "FD1202_T01"],
		["조회/취소", "FD1202_T02"]		
	];
	
	this.tabBtnView = null;
	this.lastTabId = null;
}
@extends BasePage;


@function FD1202:onReady()
{
	@super.onReady();
	
	this.tabBtnView = this.findCompById("TabBtnView");
	this.tbvManager = this.makeTabViewManager(this.findCompById("SubTabView"), this);
	
	this.lastTabId = 'FD1202_T01';
	
	this.toolBar = this.findCompById("ToolBar1");
	
	//탭 등록
	for(var i=0; i<this.tabIdMap.length; i++)
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
	
	this.tabBtnSetting();
};

@function FD1202:onWillActive(reload)
{
	@super.onWillActive(reload);
	this.initByPageData();
};

@function FD1202:onActiveDone(reload)
{
	@super.onActiveDone(reload);
		
};

@function FD1202:onWillDeactive()
{
	@super.onWillDeactive();
	
};


@function FD1202:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD1202:initByPageData()
{
	var tabId = this.lastTabId;
	var unshift = false;
	
	if(!this.pageData)
	{
		this.pageData = {tabId:tabId, item:[]};
	}
	else
	{
		if(!this.pageData.tabId) this.pageData.tabId = tabId;
		else this.lastTabId = this.pageData.tabId;
		if(!this.pageData.item) this.pageData.item = [];
		if(this.pageData.data) unshift = this.pageData.data.unshift; 
	}
	
	this.tbvManager.changeTab(this.pageData.tabId, false);
};

//설정값에 정의된 현재가 탭바 셋팅
@function FD1202:tabBtnSetting(isKonnex)
{
	var selBtn = this.tbvManager.rbManager.getSelectButton();
	var tabName, tabId, selBtnId, btn, btnW = 0;

	if(selBtn) selBtnId = selBtn.getComponentId();

	this.tabBtnView.toolBar.removeChildren();
	this.tbvManager.rbManager.reset();

	for(var i = 0; i < 2; i++)
	{
		tabName = this.tabIdMap[i][0];
		tabId = this.tabIdMap[i][1];
		btn = this.tabBtnView.addBtn(tabId, tabName);
		btnW += btn.getWidth() + 20;
	}
	btnW += 20;
	this.toolBar.setPos({left: ($(document).width() / 2) - (btnW / 2), top: 30});
	
	if(selBtnId)
	{
		this.tbvManager.rbManager.selectButton(selBtnId);
		var btn = this.tbvManager.rbManager.getSelectButton();
		this.tabBtnView.toolBar.scrollTo(btn.getPos().left);
	}
};

@function FD1202:onTabBtnClick(comp, info)
{
	var tabId = comp.getComponentId();
	
	this.lastTabId = tabId;
	this.tbvManager.changeTab(tabId, true);
};