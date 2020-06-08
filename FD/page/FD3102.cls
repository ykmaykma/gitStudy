
/**
Constructor
Do not call Function in Constructor.
** 기준가/수익률/결산정보 **
*/

@class FD3102()
{
	@super();

	this.tbvManager = null;
	this.tabIdMap = 
	[
		["전체 펀드 기준가", "FD3102_T01"],
		["펀드 기준가 추이", "FD3102_T02"],
		["수익률", "FD3102_T03"],
		["결산정보", "FD3102_T04"]
	];
	
	this.tabBtnView = null;
	this.lastTabId = null;
}
@extends BasePage;


@function FD3102:onReady()
{
	@super.onReady();
	
	this.tabBtnView = this.findCompById("TabBtnView");
	this.tbvManager = this.makeTabViewManager(this.findCompById("SubTabView"), this);

	this.toolBar = this.findCompById("ToolBar1");
	
	this.lastTabId = 'FD3102_T01';
	//탭 등록
	for(var i=0; i<this.tabIdMap.length; i++)
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
	
	this.tabBtnSetting();
};

@function FD3102:onWillActive(reload)
{
	@super.onWillActive(reload);
	this.initByPageData();
};

@function FD3102:onActiveDone(reload)
{
	@super.onActiveDone(reload);
		
};

@function FD3102:onWillDeactive()
{
	@super.onWillDeactive();
	
};


@function FD3102:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD3102:initByPageData()
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
@function FD3102:tabBtnSetting(isKonnex)
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

@function FD3102:onTabBtnClick(comp, info)
{
	var tabId = comp.getComponentId();
	
	this.lastTabId = tabId;
	this.tbvManager.changeTab(tabId, true);
};