
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5007()
{
	@super();

	// 탭뷰 관련, 페이지 뷰 컨트롤러 관련
	this.tabView = null;
	this.tvManager = null;
	this.lastTabId = null;
	
	// 계좌 타입
	this.accTypeCd = 5;
}
@extends BasePage;


@function FD5007:onReady()
{
	@super.onReady();

	// 계좌
	this.accView = this.findCompById('AccView').loadView;
	this.accView.setDelegator(this);
	
	// 스크롤툴바뷰
	this.scrToolView = this.findCompById('ScrollToolView1');
	this.scrToolView.setDelegator(this);

	// 툴바	
	this.toolBar = this.findCompById("ToolBar1");
	
	// 탭뷰
	this.tabView = this.findCompById('TabView1');
	
	// 탭메니저
	this.tvManager = this.makeTabViewManager(this.tabView, this);

	// 탭메뉴
	this.tvMenuMap = [
		['계좌조회<br>및 변경',	'FD5007_T01'], 
		//['계좌<br>수익률',		 'FD5007_T02'], // 18.11.15 주석처리
		['연금수령<br>개시신청',	'FD5007_T06']
	];
	this.lastTabId = 'FD5007_T01';	
		
	// 탭추가
	for(var i=0; i < this.tvMenuMap.length; i++)
	{	
		this.tvManager.addTab({
			tabId	: this.tvMenuMap[i][1], 
			url		: 'FD/view/' + this.tvMenuMap[i][1] + '.lay',
			name	: this.tvMenuMap[i][0], 
			data	: false
		}); // data 는 탭이 선택될때 조건을 초기화 할지 여부
	}
	
	// 탭 버튼 셋팅
	this.tabBtnSetting();
};


// 뷰 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5007:onWillActive(reload)
{	
	@super.onWillActive(reload);
	
	// 계좌 초기화
	this.initAccView();
	
	// 페이지 데이터 초기화
	this.initByPageData();
};


// 뷰 활성화가 시작되면 매번 호출된다
@function FD5007:onActive(reload)
{
	@super.onActive(reload);		
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5007:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
};


// 페이지 데이터 초기화
@function FD5007:initByPageData()
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
	
	this.tvManager.changeTab(this.pageData.tabId, false);
};


// 탭버튼 설정
@function FD5007:tabBtnSetting()
{
	var selBtn = this.tvManager.rbManager.getSelectButton();
	var tabName, tabId, selBtnId, btn, btnW = 0;
	
	if(selBtn) selBtnId = selBtn.getComponentId();
	
	this.scrToolView.toolBar.removeChildren();
	this.tvManager.rbManager.reset();

	for(var i = 0; i < this.tvMenuMap.length; i++)
	{
		tabName = this.tvMenuMap[i][0];
		tabId = this.tvMenuMap[i][1];
		btn = this.scrToolView.addBtn(tabId, tabName);
		btnW += btn.getWidth() + 20;
	}
	btnW += 20;
	this.toolBar.setPos({left: ($(document).width() / 2) - (btnW / 2), top: 30});
	
	if(selBtnId)
	{
		this.tvManager.rbManager.selectButton(selBtnId);
		var btn = this.tvManager.rbManager.getSelectButton();
		this.scrToolView.toolBar.scrollTo(btn.getPos().left);
	}
};


// 툴바 버튼 클릭
@function FD5007:onTabBtnClick(comp, info){

	//선택한 탭뷰로 변경
	this.tvManager.changeTab(comp.getComponentId(), true);
	
	// 선택 탭뷰 기억
	this.lastTabId = comp.getComponentId();
};


// 뒤로가기
@function FD5007:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


// 계좌 초기화
@function FD5007:initAccView()
{	
	// 계좌 컨트롤 
	this.onAccViewControl(true);
	
	// 계좌
	this.accView.doInitAccInfo(this.accTypeCd);
};


// 계좌 컨트롤 
@function FD5007:onAccViewControl(isEnable)
{
	this.accView.setWidth('100%');
	this.accView.accDbx.setWidth('98%');
	this.accView.secureTxf.show(AComponent.GONE);
	
	if(isEnable)
	{
		this.accView.accDbx.setWidth('calc(98% - 150px)');
		this.accView.secureTxf.show(AComponent.VISIBLE);
	}
};


// 계좌번호 변경 시 이벤트
@function FD5007:fnDoSendDataManage()
{
	if(this.tvManager.getActiveView() && this.tvManager.getActiveView().fnDoSendDataManage)
	{
		this.tvManager.getActiveView().fnDoSendDataManage();
	}
};


