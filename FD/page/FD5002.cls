
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5002()
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


@function FD5002:onReady()
{
	@super.onReady();

	// 스크롤툴바뷰
	this.scrToolView = this.findCompById('ScrollToolView1');
	this.scrToolView.setDelegator(this);

	// 스크롤 관련 영역
	this.view2 = this.findCompById('View2'); 
	this.view5 = this.findCompById('View5'); 
	this.view6 = this.findCompById('View6'); 
		
	// 툴바	
	this.toolBar = this.findCompById("ToolBar1");
	
	// 탭뷰
	this.tabView = this.findCompById('TabView1');
	
	// 탭메니저
	this.tvManager = this.makeTabViewManager(this.tabView, this);

	// 탭메뉴
	this.tvMenuMap = [
		['가져<br>오기',	 'FD5002_T01'], 
		['내보<br>내기',	 'FD5002_T02'],
		['이체<br>진행상황',	'FD5002_T03']
	];
	this.lastTabId = 'FD5002_T01';	
		
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
@function FD5002:onWillActive(reload)
{	
	@super.onWillActive(reload);
	
	// 페이지 데이터 초기화
	this.initByPageData();
};


// 뷰 활성화가 시작되면 매번 호출된다
@function FD5002:onActive(reload)
{
	@super.onActive(reload);		
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5002:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
};


// 페이지 데이터 초기화
@function FD5002:initByPageData()
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
@function FD5002:tabBtnSetting()
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
@function FD5002:onTabBtnClick(comp, info){

	//선택한 탭뷰로 변경
	this.tvManager.changeTab(comp.getComponentId(), true);
	
	// 선택 탭뷰 기억
	this.lastTabId = comp.getComponentId();
};


// 뒤로가기
@function FD5002:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


// 계좌 컨트롤 
@function FD5002:onAccViewControl(accView)
{
	// 계좌컨트롤 사이즈 조절 및 라벨 숨기기
	accView.title1.show(AComponent.GONE);
	accView.accDbx.setWidth('100%');
	accView.accDbx.addClass('combo2');
};


// 연금저축계좌보유체크
@function FD5002:onCheckAccInfo(accTypeCd)
{
	// 연금저축계좌
	var accInfo = theApp.accInfo.filterAccList(accTypeCd);
	
	// 연금저축계좌 미보유 시
	if(accInfo.length < 1)	
	{
		/*var paramData = {
			"title" 	 : "안내",
			"contents" 	 : "계약이전(계좌이체)를 위해서는</br>" 
							+ "별도의 연금저축계좌를</br>"
							+ "개설하셔야 합니다",
			"btnText" 	 : "개설하기",
			"returnType" : "2",
			"returnData" : ""	
		};
		PensionCommon.oneBtnPopup(this, paramData);*/
		
		var win = AWindow.createWindow('FD/window/FD5002_W04.lay', 'FD5002W04');
		win.setWindowOption({ isAutoCenter: true });	
		win.open(this, 0, 0, 430, 347);
	}
};


/*// 연금저축계좌보유체크 팝업 콜백함수
@function FD5002:callbackPensionPopup(returnData, resultData)
{
	// 연금저축계좌개설[계약이전(계좌이체)] 페이지로 이동
	theApp.goPageCheck('FD5001', false, {tabId:'FD5001_T02'});
};*/


// 가입일 비교표 (전체 팝업)
@function FD5002:onInfoRegistDateBtnClick(obj)
{
	var win = AWindow.createWindow('FD/window/FD5002_W01.lay', 'FD5002W01');
	win.open(obj, 0, 0, '100%', '100%'); 
};


// 가입일 선택
@function FD5002:onRdoRegistBtnClick(selectBtnId, btn01, btn02)
{
	if(selectBtnId == 'RdoRegistBtn01')	// 기존가입일
	{
		btn01.rdoBtn.setSelect(true);
		btn02.rdoBtn.setSelect(false);
		
		return btn01.rdoVal;
	}
	else if(selectBtnId == 'RdoRegistBtn02') // 신규가입일
	{
		btn01.rdoBtn.setSelect(false);
		btn02.rdoBtn.setSelect(true);
		
		return btn02.rdoVal;
	}
};


// 서비스 조회 (고객 정보 조회)
@function FD5002:sendSACMT901(obj, upperObj)
{
	var thisObj = obj;
	var cont = upperObj;
	
	var accInfo = theApp.accInfo.filterAccList(0);
	var accNo = accInfo[0]['D1계좌번호'];
	
	// 조회
	theApp.accNetManager.sendProcessByName('SACMT901', null, null,
		function(queryData, groupName)
		{
			queryData.setHeaderInfo({
				FUNC_KEY_LST: 'C'
			});
			
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			InBlock1['D1계좌번호'] = accNo;
			InBlock1['D1비밀번호'] = '0000'; // 값 상관 없음
			
			if(afc.isSimulator) queryData.printQueryData();
		},
		function(queryData, groupName)
		{
			if(!queryData)
			{
				return;
			}
			else // 성공
			{
				if(afc.isSimulator) queryData.printQueryData();
				
				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				var InBlock1 = queryData.getBlockData('InBlock1')[0];
				
				// 고객정보 셋팅
				var param = cont.setUserInfo(OutBlock1, InBlock1);
				
				// 콜백함수실행
				thisObj.callbackSACMT901(param);
			}
		}
	);	
};


// 고객정보 셋팅
@function FD5002:setUserInfo(OutBlock1, InBlock1)
{
	// 사용자명
	var userNm = theApp.userInfo.userObj['D1사용자명'];
	
	// 휴대폰번호
	var cellPh = "";
	var cellPh1 = InBlock1['D1휴대폰지역번호'];
	var cellPh2 = InBlock1['D1휴대폰국번호'];
	var cellPh3 = InBlock1['D1휴대폰일련번호'];
	
	if( cellPh1 && cellPh2 && cellPh3 )
	{
		cellPh = cellPh1 + cellPh2 + cellPh3;
	}

	// 우편번호
	var zipCd = InBlock1['D1자택우편번호'];
	
	// 주소
	var addr = OutBlock1['D1자택동이상주소'] + ' ' + InBlock1['D1자택주소'];
	
	// 고객정보
	var param = {
		'userNm'	: userNm, 
		'cellPh'	: cellPh,
		'zipCd'		: zipCd,
		'addr'		: addr
	};
	
	return param;
};


