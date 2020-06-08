/**
Constructor
Do not call Function in Constructor.
** 계좌이체 **
*/

@class FD2101()
{
	@super();

	this.tabBtnView = null;
	this.contTabView = null;
	this.tbvManager = null;
	this.lastTabId = null;
	
	//출금계좌
	this.drawAmt1 = ""; 		//출금금액
	this.drawAccNum1 = "";      //출금계좌번호
	this.drawAccPwdNum1 = "";   
	
	//출금지정계좌
	this.depositAccNm1 = "";       //입금계좌명(입금주) or 상대통장표시내용
	this.depositBankNm1 = "";   //입금계좌은행명
	this.depositAccNum1 = ""; //입금계좌번호
	this.depositSignName1 = "";   //상대통장표시내용
	this.depositBankCd1 = "";
	
	//출금잔금세팅
	this.depositAccAmt1 = "";
}

@extends BasePage;

@function FD2101:onReady()
{
	@super.onReady();
	
	//스크롤툴바뷰
	this.tabBtnView = this.findCompById('TabBtnView');
	this.tabBtnView.setDelegator(this);
	
	this.toolBar = this.findCompById("ToolBar1");
	
	//탭뷰
	this.contTabView = this.findCompById('SubTabView');
	
	//탭메니저
	this.tbvManager = this.makeTabViewManager(this.contTabView, this);
	
	this.tabIdMap = 
	[
		["종합계좌->은행계좌(출금)", "FD2101_T01"],
		["종합계좌->종합계좌", "FD2101_T02"]		
	];
	
	//탭 등록
	for(var i=0; i<this.tabIdMap.length; i++)
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
	
	this.tabBtnSetting();
	
	this.lastTabId = 'FD2101_T01';
};

@function FD2101:onWillActive(reload)
{
	@super.onWillActive(reload);
	this.initByPageData();
};

@function FD2101:onActiveDone(reload)
{
	@super.onActiveDone(reload);
		
};

@function FD2101:onWillDeactive()
{
	@super.onWillDeactive();
	
};

@function FD2101:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD2101:initByPageData()
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
@function FD2101:tabBtnSetting(isKonnex)
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

@function FD2101:onTabBtnClick(comp, info)
{
	var tabId = comp.getComponentId();
	
	this.lastTabId = tabId;
	this.tbvManager.changeTab(tabId, true);
};

@function FD2101:fnDoSendDataManage()
{
	if(this.tbvManager.getActiveView().tvManager.getActiveView().fnDoSendDataManage()){
		this.tbvManager.getActiveView().tvManager.getActiveView().fnDoSendDataManage();
	}	
};
