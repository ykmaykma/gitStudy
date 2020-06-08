
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5006()
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


@function FD5006:onReady()
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
		['보유<br>리스트',	'FD5006_T01'], 
		['자산<br>현황',	 'FD5006_T02'],
		['거래<br>내역',	 'FD5006_T03']
	];
	this.lastTabId = 'FD5006_T01';	
		
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
@function FD5006:onWillActive(reload)
{	
	@super.onWillActive(reload);
	
	// 계좌 초기화
	this.initAccView();
	
	// 페이지 데이터 초기화
	this.initByPageData();
};


// 뷰 활성화가 시작되면 매번 호출된다
@function FD5006:onActive(reload)
{
	@super.onActive(reload);		
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5006:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
};


// 페이지 데이터 초기화
@function FD5006:initByPageData()
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
@function FD5006:tabBtnSetting()
{
	var selBtn = this.tvManager.rbManager.getSelectButton();
	var tabName, tabId, selBtnId, btn, btnW = 0;
	
	if(selBtn) selBtnId = selBtn.getComponentId();
	
	this.scrToolView.toolBar.removeChildren();
	this.tvManager.rbManager.reset();

	for(var i = 0; i < 3; i++)
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
@function FD5006:onTabBtnClick(comp, info){

	/*// 2차 가동 서비스 팝업
	if(comp.getComponentId() != 'FD5006_T01')
	{
		PensionCommon.comingSoonPopup(this);
		return;
	}*/
	
	//선택한 탭뷰로 변경
	this.tvManager.changeTab(comp.getComponentId(), true);
	
	// 선택 탭뷰 기억
	this.lastTabId = comp.getComponentId();
};


// 뒤로가기
@function FD5006:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


// 계좌 초기화
@function FD5006:initAccView()
{	
	// 계좌 컨트롤 
	this.onAccViewControl();
	
	// 계좌
	this.accView.doInitAccInfo(this.accTypeCd);
};


// 계좌 컨트롤 
@function FD5006:onAccViewControl(isEnable)
{
	// 계좌컨트롤 사이즈 조절 및 비밀번호 숨기기
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
@function FD5006:fnDoSendDataManage()
{
	if(this.tvManager.getActiveView() && this.tvManager.getActiveView().fnDoSendDataManage)
	{
		this.tvManager.getActiveView().fnDoSendDataManage();
	}
};





//----------------------------------------------------//
//------------ START 입금하기 페이지 이동 ----------------//
//----------------------------------------------------//
// sendSDPAQ070 콜백함수 (납입한도 확인)
@function FD5006:callback070Data(money)
{
	if(money*1 <= 0)
	{
		var contents = "고객님의<span style='color:rgb(226, 26, 34)'>"
						+ "연간 납입한도</span>를<br>초과하였습니다."
		var param = {
			"title" 		: "",
			"contents" 		: contents,
			"btnText" 		: "확인",
			"returnType" 	: "0",
			"returnData" 	: ""
		};
		PensionCommon.oneBtnPopup(this,param);
		
		this.isSDPAQ070 = false;
	}
	else
	{
		this.isSDPAQ070 = true;
	}
	
	//입금하기 이동
	this.openFD5005();	
};




// 입금하기로 이동 
@function FD5006:openFD5005()
{
	if(this.isSDPAQ070 == true)
	{
		theApp.goPageCheck('FD5005');
	}
	
	this.isSDPAQ070 = false;
};
//----------------------------------------------------//
//-------------- END 입금하기 페이지 이동 ----------------//
//----------------------------------------------------//




