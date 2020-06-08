/**
Constructor
Do not call Function in Constructor.
** 매매내역 및 자동이체내역 조회/취소 **
*/

@class FD1201()
{
	@super();

	this.tbvManager = null;
	
	// kyh 2018.03.10 Tab Name 변경
	this.tabIdMap = 
	[
		["오늘의<br>주문내역", "FD1201_T01"],
		["적립식<br>매수현황", "FD1201_T02"]		
	];
	
	// 04 코드는 자유적립식이지만 메리츠에서는 일정액적립식으로 사용
	this.tabBtnView = null;
	this.lastTabId = null;
	this.tradingValue = {
		"01": "임의식"
		,"02": "거치식"
		,"03": "정액적립식"
		,"04": "일정액적립식"
	};
}
@extends BasePage;


@function FD1201:onReady()
{
	@super.onReady();
	
	this.tabBtnView = this.findCompById("TabBtnView");
	this.tabBtnView.setDelegator(this);
	
	this.tbvManager = this.makeTabViewManager(this.findCompById("SubTabView"), this);

	this.accView = this.findCompById('AccView').viewLoad('FD/view/FD0000_V00.lay');
	this.accView.doInitAccInfo(4);	//0: 종합계좌번호, 4: 투신상품계좌번호
	
	//계좌드롭박스
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.toolBar = this.findCompById("ToolBar1");
	
	//탭 등록
	for(var i=0; i<this.tabIdMap.length; i++)
		this.tbvManager.addTab({name:this.tabIdMap[i][0], url:"FD/view/"+this.tabIdMap[i][1]+".lay", tabId:this.tabIdMap[i][1]});
	
	this.tabBtnSetting();
	this.lastTabId = 'FD1201_T01';
	
	var d = new Date();
	this.today = d.format('yyyyMMdd');
};

@function FD1201:onWillActive(reload)
{
	@super.onWillActive(reload);
	this.initByPageData();
};

@function FD1201:onWillDeactive()
{
	@super.onWillDeactive();
	
};

@function FD1201:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD1201:initByPageData()
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
@function FD1201:tabBtnSetting(isKonnex)
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

@function FD1201:onTabBtnClick(comp, info)
{
	var tabId = comp.getComponentId();
	
	this.lastTabId = tabId;
	this.tbvManager.changeTab(tabId, true);
};

//계좌번호 변경 시 이벤트
@function FD1201:fnDoSendDataManage()
{
	if(this.tbvManager.getActiveView() && this.tbvManager.getActiveView().fnDoSendDataManage){
		this.tbvManager.getActiveView().fnDoSendDataManage();
	}	
};