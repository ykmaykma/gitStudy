/**
Constructor
Do not call Function in Constructor.
** 펀드폐쇄 **
*/

@class FD1205()
{
	@super();
	
	this.tbvManager = null;
	this.tabIdMap = 
	[
		["매수/매도", "FD2201_T01"],
		["적립식<br>매수현황", "FD2201_T02"]		
	];

	this.tabBtnView = null;
	this.lastTabId = null;
}
@extends BasePage;

@function FD1205:onReady()
{
	@super.onReady();
	
	this.tabBtnView = this.findCompById("TabBtnView");
	this.toolBar = this.findCompById("ToolBar1");
	this.tabBtnView.setDelegator(this);
	
	this.tbvManager = this.makeTabViewManager(this.findCompById("SubTabView"), this);
	
	//탭 등록
	for(var i=0; i<this.tabIdMap.length; i++)
	{
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
	}
	
	this.tabBtnSetting();
	this.lastTabId = 'FD2201_T01';
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD1205:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1205:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	//탭값 초기화
	this.doInitTabs();
	
	this.initByPageData();
};

@function FD1205:doInitTabs()
{
	//탭 상태 초기화 (data값이 false면 서브뷰에서 조건 초기화후 데이터 로드)
	var tabs = this.tbvManager.tabView.getAllTabs();
	for(var tab in tabs)
	{
		tabs[tab].data = false;
	}	
};

@function FD1205:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1205:refreshData() ');
};

@function FD1205:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD1205:initByPageData()
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
@function FD1205:tabBtnSetting()
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

@function FD1205:onTabBtnClick(comp, info)
{
	var tabId = comp.getComponentId();
	
	this.lastTabId = tabId;
	this.tbvManager.changeTab(tabId, true);
};
@function FD1205:onButton8Click(comp, info)
{
	//ATYPE
	//theApp.smsCertManager.openSmsCertWindow("00146000019", true, "01044327472", function (result) // 전화번호를 넘기는 경우 
	theApp.smsCertManager.openSmsCertWindow(this.accDbx.getSelectedItemData()['D1계좌번호'], true, null, function (result)
	{
		if(result)
		{
			alert("(AType)SMS 본인확인 완료!");
		}
		else
		{
			alert("(AType)SMS 본인확인 취소!");
		}
	}); 
};

@function FD1205:onButton9Click(comp, info)
{
	//BTYPE
	theApp.smsCertManager.openSmsCertWindow(this.accDbx.getSelectedItemData()['D1계좌번호'], null,null, function (result)
	{
		if(result)
		{
			alert("(BYype)SMS 본인확인 완료!");
		}
		else
		{
			alert("(BYype)SMS 본인확인 취소!");
		}
	}); 
};
