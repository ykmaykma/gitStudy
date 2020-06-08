
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5005()
{
	@super();

	//TODO:edit here

}
@extends BasePage;


@function FD5005:onReady()
{
	@super.onReady();

	//TODO:edit here
	this.view1 = this.findCompById("View1");
	this.tabBtnView = this.findCompById("TabBtnView");
	this.tabBtnView.setDelegator(this);
	this.tbvManager = this.makeTabViewManager(this.findCompById("TabView1"), this);
	
	this.toolBar = this.findCompById("ToolBar1");
	
	this.tabIdMap = 
	[
		["입금", "FD5005_T01"],
		["출금", "FD5005_T02"]		
	];
	
	
	this.lastTabId = 'FD5005_T01';

	for(var i=0; i<this.tabIdMap.length; i++)
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
			
	this.tabBtnSetting();
};

@function FD5005:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	this.initByPageData();
}

@function FD5005:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD5005:initByPageData()
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


@function FD5005:tabBtnSetting(isKonnex)
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
	this.toolBar.setPos({left: ($(document).width() / 2) - (btnW / 2), top: 10});
	
	if(selBtnId)
	{
		this.tbvManager.rbManager.selectButton(selBtnId);
		var btn = this.tbvManager.rbManager.getSelectButton();
		this.tabBtnView.toolBar.scrollTo(btn.getPos().left);
	}
};


@function FD5005:onTabBtnClick(comp, info)
{
	
	var tabId = comp.getComponentId();
	
	/*// 2차 가동 서비스 팝업
	if(comp.getComponentId() != 'FD5005_T01')
	{
		PensionCommon.comingSoonPopup(this);
		return;
	}*/
	
	this.tbvManager.changeTab(tabId, true);	
	
	
};

@function FD5005:fnDoSendDataManage()
{	
	if(this.tbvManager.getActiveView().tbvManager.getActiveView().className == 'FD5005_V01'){
		this.tbvManager.getActiveView().tbvManager.getActiveView().changeAccManager(); //투신계좌
	}else{
		this.tbvManager.getActiveView().tbvManager.getActiveView().fnDoSendDataManage();
	}
};


//입금 - 납입 한도 계산 callback
@function FD5005:callback070Data(money)
{
	
	if(money*1 <= 0){
		var contents = "고객님의 <span style='color :rgb(226, 26, 34)'>연간 납입한도</span>를<br>" + 
						'초과하였습니다.'
		var param = {
			"title" : "",
			"contents" : contents,
			"btnText" : "확인",
			"returnType" : "0",
			"returnData" : ""
		};
		PensionCommon.oneBtnPopup(this,param);		
	}			
}
