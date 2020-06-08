
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202()
{
	@super();

	//TODO:edit here
	
	//탭뷰 관련, 페이지 뷰 컨트롤러 관련
	this.contTabView = null;
	this.tvManager = null;
//	this.scrToolView = null;
	this.titleLbl = null;
	this.lastTabId = null;	
	
	// 펀드 정보
	this.selectFundInfo = null;
	
	// 펀드매수단계
	this.fundAllBuyStep = null;
	this.fundNowBuyStep = null;
		
	// 고객정보
	this.g_UserGrade = null;			// 최종고객성향등급
	this.g_UserInvstCnvsGubun = null;	// 투자권유구분
	this.g_UserInfoPrvdGubun = null;	// 정보제공구분
	this.g_UserGradeName = null;		// 고객등급명
	this.g_UserDrvtInvstTerm = null;	// 파생상품투자기간
	this.g_UserBirth = null;			// 생년월일
	
	this.userGrade = null; 				// 고객성향, 투자등급 조회 전체
	
	this.g_nowTime = null; 				// 현재시간 조회 체크
	
	this.g_bizDateCheck = null;			// 영업일인지 아닌지 체크 0:영업일아님,1:영업일
	
	this.g_tradeState = null;			// 현재 매매가능상태 1:일반펀드매수매도, 2: 예약펀드매수매도, 3:펀드매수불가
	
	this.juniorSelAccNo = null; // 주니어펀드계좌 세팅
	
	//SimpleFund 코드 세팅
	this.simpleFundCode = [
		"2190"
		,"2228"
		,"4074"
	];
}
@extends BasePage;


@function FD3202:onReady()
{
	@super.onReady();
	
	//TODO:edit here
	
	//타이틀
	this.titleLbl = this.findCompById('TitleLbl');

	//스크롤툴바뷰
	this.scrToolView = this.findCompById('ScrollToolView');
	this.scrToolView.setDelegator(this);

//	this.btnMenuArea = this.findCompById('btnMenuArea');

	this.view2 = this.findCompById('View2'); // 스크롤 영역 조정
	
	this.view5 = this.findCompById('View5'); // 스크롤 관련 영역
	
	
	this.view3 = this.findCompById('View3');
	this.bottomView = this.findCompById('bottomView');
	
	this.view1 = this.findCompById('View1');
	
	this.view4 = this.findCompById('View4');
	
	
	this.toolBar = this.findCompById("ToolBar1");		
	
	//탭뷰
	this.contTabView = this.findCompById('ContTabView');	
	//탭메니저
	this.tvManager = this.makeTabViewManager(this.contTabView, this);
	
	this.tvMenuMap = [
		['Simple<br>Choice',  'FD3202_T01'], 
		['펀드<br>더보기',  	'FD3202_T02'],
		['연금<br>펀드',  	'FD3202_T03']
	];
		
	for(var i=0; i < this.tvMenuMap.length; i++)
	{
		//탭추가
		this.tvManager.addTab({tabId:this.tvMenuMap[i][1], url:['FD/view/', this.tvMenuMap[i][1], '.lay'].join(''), name:this.tvMenuMap[i][0], data:false}); //data 는 탭이 선택될때 조건을 초기화 할지 여부
	}
	
	this.tabBtnSetting();
				
};

@function FD3202:onWillActive(reload)
{	
	@super.onWillActive(reload);
			
	var thisObj = this;
		
};

@function FD3202:onActive(reload)
{
	@super.onActive(reload);

	var thisObj = this;
			
	// 화면 리로드로 하자!!
	thisObj.contTabView.option.contentReload = true;
	
	
	// 스크롤 관련하여 처리
	var fundContScrollHegiht = theApp.userInfo.get('FundBuyContentScroll');
		
	if(fundContScrollHegiht == undefined){		
		theApp.userInfo.set('FundBuyContentScroll',thisObj.view5.getHeight());
	}else{
		var contentScrollHeight = theApp.userInfo.get('FundBuyContentScroll');				

		thisObj.view5.setHeight(contentScrollHeight);
	}
	
	// 상단 버튼영역이 안보이는 부분이 있을 수 있어서 체크
	thisObj.view5.$ele.css({			
			'top': '170px'
	});	
	
	thisObj.view5.scrollTo(0); // 스크롤 관련 영역 변경
	thisObj.view2.scrollTo(0); // 스크롤 하단 이동 후 다른 화면 이동 후 재진입시 스크롤 최상단으로 변경
	
	thisObj.selectFundInfo = null;
		
	thisObj.scrToolView.show(AComponent.VISIBLE); // 상단 Simple Choice, 펀드 더보기 보임처리
		
	thisObj.initUserGradeCheck(thisObj, function(){					
		if(thisObj.pageData !== undefined){
			if(thisObj.pageData.tabId){
				if(thisObj.pageData.fundCode){
					if(thisObj.pageData.tabId == 'FD3202_T01' && thisObj.pageData.fundCode == "1"){
						thisObj.fundDataCode = "2190"; // 첫번째 SimpleFund
					}else if(thisObj.pageData.tabId == 'FD3202_T01' && thisObj.pageData.fundCode == "2"){
						thisObj.fundDataCode = "2228"; // 두번째 SimpleFund
					}else if(thisObj.pageData.tabId == 'FD3202_T01' && thisObj.pageData.fundCode == "3"){
						thisObj.fundDataCode = "4074"; // 세번째 SimpleFund
					}else{	// 그 외의 FundCode 로 들어오면 코드자체로 조회						
						thisObj.fundDataCode = thisObj.pageData.fundCode;
					}
					thisObj.sendDataFundCheck(thisObj, function(oBlock){
						if(oBlock)
						{
							thisObj.selectFundInfo = oBlock; // 펀드정보 세팅
							thisObj.tvManager.changeTab(thisObj.pageData.tabId); // 선택한 탭 화면으로 넘겨줌
						}
						else
						{
							theApp.alert(
								[	 
									'선택한 펀드에 대한 ', '<br/>',
									'정보가 없습니다.'					
									,' '
								].join('')
								,
								function()
								{			

								}
								,''
							);
						}
					});
				}else{						
					thisObj.tvManager.changeTab(thisObj.pageData.tabId); // 선택한 탭 화면으로 넘겨줌
				}

			}else{
				thisObj.tvManager.changeTab('FD3202_T01');
			}
		}else{
			thisObj.tvManager.changeTab('FD3202_T01');
		}		
	});
};

@function FD3202:fundTradePopoup()
{
	theApp.goPrevPageCheck(false);
};

// 단말 로컬타임 시간 조회
@function FD3202:nowTimeCheck(caller)
{
	////////////////// local 시간 조회 ////////
	// 호출한 데이터
	var thisObj = this
		,thisObj2 = caller		
		,callback = arguments[1];		

	thisObj.sendData('SSSSQ903',
	    function(queryData, groupName){								
		},
		function(queryData, groupName) {									
						
			var OutBlock1 = queryData.getBlockData('OutBlock1');
			var serverTime = OutBlock1[0].D1서버시간;			
			
			thisObj.g_nowTime = serverTime.substring(8,14);			
			theApp.setTimeInfo(thisObj.g_nowTime);					
			callback();	
			
		}
	);	


/*
// 단말기 localTime 구하기
	var now = new Date();
	
	var nowHour = now.getHours();
	var nowMin = now.getMinutes();
	var nowSecond = now.getSeconds();
		
	// 시,분,초 1자리 숫자일때 계산
	if(nowHour < 10){
		nowHour = '0' + nowHour;
	}	
	if(nowMin < 10){
		nowMin = '0' + nowMin;
	}	
	if(nowSecond < 10){
		nowSecond = '0' + nowSecond;
	}
		
	thisObj.g_nowTime = nowHour.toString() + nowMin.toString() + nowSecond.toString();
	
	callback();		
*/	
	

};

// 당일일자 정보 조회 새로
@function FD3202: bizNextDayCheck1(caller)
{
	var thisObj = this;
		
	var thisObj2 = caller		
		,callback = arguments[1];
		
	var bizDate = theApp.userInfo.get('BizDt'); // 영업일조회
	
	var localNowDay = MetaInfo.fnGetToday('NUMDATE'); // 현재 일자 조회
	
	if(bizDate == localNowDay){
		thisObj.g_bizDateCheck = 1; // 오늘이 영업일일 경우 1 세팅
	}else{
		thisObj.g_bizDateCheck = 0; // 오늘이 영업일이 아닐 경우 0 세팅
	}
	
	callback();
};

// 현재 매매가능상태 코드값 분류
@function FD3202: nowTradeStateCheck(caller)
{
	var thisObj = this;
		
	var thisObj2 = caller		
		,callback = arguments[1];

	thisObj.bizNextDayCheck1(thisObj, function(){ // 영업일인지 아닌지 체크
		thisObj.nowTimeCheck(thisObj, function(){ // 현재 시간 체크
		
			if(thisObj.g_bizDateCheck == 0){ // 영업일이 아닌 경우
				if(thisObj.g_nowTime >= 230000 || thisObj.g_nowTime <= 070000){
					thisObj.g_tradeState = 3; // 펀드매수매도불가
				}else{
					thisObj.g_tradeState = 2; // 예약펀드매수매도
				}
			}else if(thisObj.g_bizDateCheck == 1){ // 영업일인 경우
				if(thisObj.g_nowTime > 230000 || thisObj.g_nowTime < 070000){
					thisObj.g_tradeState = 3; // 펀드매수매도불가
				}else if(thisObj.g_nowTime >= 070000 && thisObj.g_nowTime < 090000){
					// 2018.10.24 영업일 오전7시~오전9시 당일예약매수 추가
					thisObj.g_tradeState = 4; // 영업일 오전7시~오전9시 당일예약매수
				}else if(thisObj.g_nowTime >= 090000 && thisObj.g_nowTime <= 170000){
					thisObj.g_tradeState = 1; // 일반펀드매수매도
				}else if(thisObj.g_nowTime > 170000 && thisObj.g_nowTime <= 230000){
					thisObj.g_tradeState = 2; // 예약펀드매수매도
				}
			}
			
			callback(); // 현재펀드매수매도 가능상태 체크한 후 콜백
		});
	});
};

@function FD3202:initByPageData()
{

	var contentScrollHeight = theApp.userInfo.get('FundBuyContentScroll');
		
	this.view5.$ele.css({			
		'top': '170px'
	});	

	this.view5.setHeight(contentScrollHeight);
	
	// 컨텐츠 뷰 영역 리로드
	this.contTabView.option.contentReload = true;

	if(this.pageData) 
	{
		if(this.pageData.tabId) 
		{
			this.lastTabId = this.pageData.tabId;	
		}
	}
	this.tvManager.changeTab(this.lastTabId);
};


@function FD3202:doInitTabs()
{
	//탭 상태 초기화 (data값이 false면 서브뷰에서 조건 초기화후 데이터 로드)
	var tabs = this.tvManager.tabView.getAllTabs();
	for(var tab in tabs)
	{
		tabs[tab].data = false;
	}	
};


//AccDropView 로드뷰에서 호출하는 함수
@function FD3202:fnDoSendDataManage()
{
	
	//탭값 초기화
//	this.doInitTabs();
	
	this.doTabViewSendData();
		
};


//탭 서브뷰 데이터 호출
@function FD3202:doTabViewSendData()
{
	//선택 탭
	var actTab = this.tvManager.getActiveTab();	
	
	//선택 뷰
	var activeView = this.tvManager.getActiveView();	
	
	//선택 서브 뷰
	var activeSubView = activeView.tbvManager.getActiveView();
			
	// 선택한 서브 뷰에 대해 sendDataManage 함수를 실행
	if(activeSubView && activeSubView.sendDataManage)
	{		
		activeSubView.sendDataManage();		
	}
};

// 선택된 펀드 정보 조회(투신펀드코드가 유니크하므로 1개의 펀드만 조회)
@function FD3202:sendDataFundCheck(caller)
{
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1];	
	
	var thisObj = this;
							
	this.sendData('SOFFQ421',
		function(queryData, groupName)
		{	
			queryData.setHeaderInfo({
						FUNC_KEY_LST: 'C'
			});
			
		var InBlock1 = queryData.getBlockData('InBlock1')[0];				
		
		InBlock1['D1투신펀드코드'] = thisObj2.fundDataCode;
		InBlock1['D1운용사코드'] = '000';
		InBlock1['D1기준일'] = MetaInfo.fnGetToday('NUMDATE');
		InBlock1['D1투신펀드유형구분'] = ''; // default:0
		InBlock1['D1간접투자코드'] = ''; // default:00
		InBlock1['D1가입자격구분'] = ''; // default:0
		InBlock1['D1투자기간코드'] = ''; // default:00
		InBlock1['D1한글투신펀드명'] = ''; // default:
		InBlock1['D1투신상세코드'] = ''; // default:00, 
		InBlock1['D1투자방식코드'] = ''; // default:00
		InBlock1['D1구분'] = '0'; // 클래스구분 - Default:0
		InBlock1['D1투자등급코드'] = '00'; // 모든투자등급이 나오는 코드
								
	},
	 function(queryData, groupName) {

		if(queryData != null){
							
			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
						
			if(OutBlock1)
			{												    					
				callback(OutBlock1);				
			}else{
				callback(null);
			}
		}else{
			callback(null);
		}
	});	
};


// 페이지 진입시 자동으로 고객등급, 성향조회
@function FD3202:initUserGradeCheck(caller)
{
	var thisObj = this,
		thisObj2 = caller,
		callback = arguments[1];
	
	thisObj.userGrade = theApp.userInfo.get('UserGrade');
			
	// 최종고객성향등급	
	if(thisObj.userGrade !== undefined){
		if(thisObj.userGrade["D1산출등급명"] == "안정형"){
			thisObj.g_UserGrade = 1;
		}else if(thisObj.userGrade["D1산출등급명"] == "안정추구형"){
			thisObj.g_UserGrade = 2;
		}else if(thisObj.userGrade["D1산출등급명"] == "위험중립형"){
			thisObj.g_UserGrade = 3;
		}else if(thisObj.userGrade["D1산출등급명"] == "적극투자형"){
			thisObj.g_UserGrade = 4;
		}else if(thisObj.userGrade["D1산출등급명"] == "공격투자형"){
			thisObj.g_UserGrade = 5;
		}

		thisObj.g_UserInvstCnvsGubun = thisObj.userGrade["D1투자권유구분"]; 	// 투자권유구분				
		thisObj.g_UserInfoPrvdGubun = thisObj.userGrade["D1정보제공구분"];		// 정보제공구분
		thisObj.g_UserGradeName = thisObj.userGrade["D1산출등급명"];			// 고객등급명
		thisObj.g_UserDrvtInvstTerm = thisObj.userGrade["D1파생상품투자기간"];	// 파생상품투자기간
		thisObj.g_UserBirth = thisObj.userGrade["D1생년월일"];				// 생년월일	
	}
	
	callback();	
};


// 로그인할 당시에 SACMT110 서비스를 호출해서 저장한 값을 사용(이 함수는 페이지마다 호출할 경우)
// 혹시 변경될 가능성이 있으므로 남겨놓음
// 고객등급, 성향조회
@function FD3202:userGradeCheck(caller)
{
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1];		
	
	var accList = theApp.accInfo.filterAccList(0); // 계좌번호 리스트 가져오기	
	var accNo = accList[0]["D1계좌번호"]; // 첫번째 계좌 사용	
	
	theApp.accNetManager.addSkipErrorCode('SACMT110', '3956'); // 등록된 내용이 없습니다. Skip 처리
	this.sendData('SACMT110',
		function(queryData, groupName)
		{
		
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			
			// 투자자정보확인서 조회
			if(thisObj2.userGrdTrxTp == '3'){
				InBlock1['D1처리구분'] = '3';
				InBlock1['D1고객구분'] = '1';
				InBlock1['D1실명확인번호'] = accNo;
			}else if(thisObj2.userGrdTrxTp == '1'){
				// 투자자정보확인서 등록, 기본적으로 팝업창을 띄워서 투자권유구분, 정보제공구분을 안함으로 등록할 경우
				InBlock1['D1처리구분'] = '1';
				InBlock1['D1고객구분'] = '1';
				InBlock1['D1실명확인번호'] = accNo;
				InBlock1['D1개인법인구분'] = '1'; // 0:전문투자자,1:일반개인,2:일반법인
				InBlock1['D1정보확인사원번호'] = 'MTS';
				
				InBlock1['D1투자권유구분'] = '0';
				InBlock1['D1정보제공구분'] = '0';
			}
																
		 },
		//afterOutBlockData
		function(queryData, groupName)
		{			
			if(queryData)
			{
								
				var InBlock1 = queryData.getBlockData('InBlock1')[0];
								
				// 최종고객성향등급
				if(InBlock1["D1산출등급명"] == "안정형"){
					thisObj.g_UserGrade = 1;
				}else if(InBlock1["D1산출등급명"] == "안정추구형"){
					thisObj.g_UserGrade = 2;
				}else if(InBlock1["D1산출등급명"] == "위험중립형"){
					thisObj.g_UserGrade = 3;
				}else if(InBlock1["D1산출등급명"] == "적극투자형"){
					thisObj.g_UserGrade = 4;
				}else if(InBlock1["D1산출등급명"] == "공격투자형"){
					thisObj.g_UserGrade = 5;
				}
				
				thisObj.g_UserInvstCnvsGubun = InBlock1["D1투자권유구분"]; // 투자권유구분				
				thisObj.g_UserInfoPrvdGubun = InBlock1["D1정보제공구분"];	// 정보제공구분
				thisObj.g_UserGradeName = InBlock1["D1산출등급명"];		// 고객등급명
				thisObj.g_UserDrvtInvstTerm = InBlock1["D1파생상품투자기간"];	// 파생상품투자기간
				thisObj.g_UserBirth = InBlock1["D1생년월일"];			// 생년월일
								
				theApp.userInfo.set('UserGrade',InBlock1);
												
				callback(InBlock1);
			}else{				
				callback(null);
			}									
		});		
};


// 투자자확인서 필요조회/등록/정정
@function FD3202:nonReportRegChk(caller)
{

	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1];		
		
	var accNo = thisObj2.accNo; // 페이지로부터 넘겨받은 계좌	
	var TrxTp = thisObj2.TrxTp; // 조회할지 등록할지 구분 값
	var fundCode= thisObj2.fundCode; // 선택한 투신펀드코드

	// 조회일시 투자자확인서 등록내역이 없다는 에러메시지 스킵처리
	if(TrxTp == "3"){		
		theApp.accNetManager.addSkipErrorCode('SACMT111', '3956');
	}
	
	this.sendData('SACMT111',
		function(queryData, groupName)
		{
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
						
			if(TrxTp == "1"){
				queryData.setHeaderInfo( // 투자자확인서 등록
					{FUNC_KEY_LST: '5'}
				);
								
				InBlock1['D1처리일'] = MetaInfo.fnGetToday('NUMDATE');
			}else if(TrxTp == "3"){ //투자자확인서 필요한지 조회
				//헤더셋
				queryData.setHeaderInfo(
					{FUNC_KEY_LST: 'C'}
				);
								
				InBlock1['D1처리일'] = '';
			}
			
			InBlock1['D1처리구분'] = TrxTp; // 1:등록, 3:조회						 
			
			InBlock1['D1확인구분'] = '';
			InBlock1['D1실명확인번호'] = '';
			InBlock1['D1계좌번호'] = accNo;
			InBlock1['D1비밀번호'] = '';
			InBlock1['D1종목번호'] = fundCode;
			
			InBlock1['D1처리일련번호'] = '0';
							
		},
		function(queryData, groupName)
		{			
			var errCode = this.getLastError('errCode'); 		
			var errMsg = this.getLastError('errMsg');
									
			if(TrxTp == "3"){
				callback(errCode);
			}else{
				if(queryData != null){
					var OutBlock1 = queryData.getBlockData('OutBlock1');			
					
					if(!OutBlock1){
						callback(null);
					}else{
						callback(OutBlock1);
					}
				}else{
					callback(null);
				}
			}			
		});
};

// 로드하여 당일일자정보조회
@function FD3202: bizNextDayCheck(caller)
{
	var thisObj = this;
	
	var thisObj2 = caller		
		,callback = arguments[1];	
						
	this.sendData('SCMAQ048',
	    function(queryData, groupName){
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			
			queryData.setHeaderInfo({
				FUNC_KEY_LST:  'C' 
			});			
						
			InBlock1['D1일자공통그룹코드'] = '010';
			InBlock1['D1출납일기준영업전전일'] = '';
			InBlock1['D1출납일기준영업전일'] = '';
			InBlock1['D1출납일기준영업일'] = '';
			InBlock1['D1출납일기준영업익일'] = '';
			InBlock1['D1출납일기준영업익익일'] = '';
			InBlock1['D1주문일기준결제전일'] = '';
			InBlock1['D1주문일기준주문전일'] = '';
			InBlock1['D1주문일'] = '';
			InBlock1['D1결제일'] = '';
			InBlock1['D1주문일기준주문익일'] = '';
			InBlock1['D1주문일기준결제익일'] = '';
			InBlock1['D130만기일'] = '';
			InBlock1['D160만기일'] = '';
			InBlock1['D190만기일'] = '';
			InBlock1['D1120만기일'] = '';
			InBlock1['D1150만기일'] = '';
			InBlock1['D1180만기일'] = '';
			InBlock1['D1210만기일'] = '';
			InBlock1['D1270만기일'] = '';
			InBlock1['D1365만기일'] = '';
			InBlock1['D1주문가능일여부'] = '';
			InBlock1['D1요일구분'] = '';			
			
		},
		function(queryData, groupName) {
			
			if(!queryData) return;			
			
			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
			if(!OutBlock1) return;			
			
			if(!OutBlock1){
				callback(null);
			}else{				
				callback(OutBlock1);
			}						
		}
	);
};


@function FD3202:onBackBtnClick(comp, info)
{
	//TODO:edit here
	theApp.goPrevPageCheck(false);
};

@function FD3202:onbtnMenu1Click(comp, info)
{
	//TODO:edit here
	this.tvManager.changeTab('FD3202_T01');

};

@function FD3202:onbtnMenu2Click(comp, info)
{
	//TODO:edit here
	this.tvManager.changeTab('FD3202_T02');
};


//탭버튼 설정
@function FD3202:tabBtnSetting()
{
	var selBtn = this.tvManager.rbManager.getSelectButton();
	var tabName, tabId, selBtnId, btn, btnW = 0;
	
	if(selBtn) selBtnId = selBtn.getComponentId();
	
	this.scrToolView.toolBar.removeChildren();
	this.tvManager.rbManager.reset();

	for(var i=0; i<this.tvMenuMap.length; i++)
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

//툴바 버튼 클릭
@function FD3202:onTabBtnClick(comp, info){
	if(comp.getComponentId() == "FD3202_T03") {
		// 연금펀드 선택 시 팝업 띄움...
		var selBtn = this.tvManager.rbManager.getSelectButton();

		PensionCommon.moveToPensionMainPopup(this);
	}
	else {
		//선택한 탭뷰로 변경
		this.tvManager.changeTab(comp.getComponentId(), true);

		//제목 변경 -> 20160921 제목이 탭에 따라 변경되지 않도록 수정
		// this.titleLbl.setText(comp.getText());
		// 선택 탭뷰 기억
		this.lastTabId = comp.getComponentId();

		this.doTabViewSendData();
	}
};

// 연금펀드 메인화면으로 이동...
@function FD3202:callbackPensionPopup(returnData, resultData)
{
	//TODO:edit here
	//theApp.navigator.registerPage('FD/FrmPage2.lay', 'FrmPage2');
	theApp.navigator.goPage('FrmPage2');
	//theApp.goPageCheck('FD0005', false, '');
};

// 미성년자 판별 함수
@function FD3202:userAgeCheck(caller)
{
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1];		
				
	this.sendData('SACMT469',
		function(queryData, groupName)
		{
		
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
									
			InBlock1['D1처리구분'] = '9';
			InBlock1['D1조회구분'] = '2';
			InBlock1['D1고객번호'] = thisObj.juniorSelAccNo;
			InBlock1['D1내외국인구분'] = '0';
			InBlock1['D1휴대폰번호'] = '';
			InBlock1['D1전화구분'] = '';
			
			queryData.printQueryData();
													
		 },
		function(queryData, groupName)
		{			
			if(queryData)
			{
				var errCode = this.getLastError('errCode');		
				if(errCode >= 1000){
					if(errCode == 2216){
						theApp.alert(
							[	 
								//'펀드매매가능시간이 아닙니다.'
								'펀드매매 이용시간은 ', '<br/>',
								'오전 7시~오후23시까지', '<br/>',
								'(한국시간 기준)입니다.', '<br/>',
								,' '
							].join('')
							,
							null
							,''
						);
					}
					callback(null);
				}
				else{
					var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
								
					// 미성년여부 판별값 전송				
					callback(OutBlock1);
				}												
			}else{				
				callback(null);
			}									
		});		
};


// 시니어펀드 월지급 약정 신청
@function FD3202:monthRequestJoin(caller)
{
						
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1]	
		,qrName = "SACAT562"
		,cipherData = thisObj2.txtAccPw; // 전 페이지에서 이미 getCipherData()를 사용해서 넘오옴
								
	
	var checkObj = {
		svcId : qrName,
		accNo : thisObj2.subAccNo
	};
	
/*	var now = new Date();
	
	now.setDate(now.getDate());*/
	
	
	var nowDate = MetaInfo.fnGetToday('NUMDATE'); // 오늘 날짜
	
	var nowDateYear = nowDate.substring(0,4); // 현재 년	
	var nowDateMonth = Number(nowDate.substring(4,6)) + 1; // 현재 월
	var nowDateDay = nowDate.substring(6,8); // 현재 일
		
	if(Number(nowDateMonth) == 13){ // 현재 월이 12월인지 체크				
		nowDateYear = Number(nowDateYear) + 1; // 년도증가
		nowDateMonth = 1; // 1월로 변경
	}						
	
	if(nowDateMonth < 10){
		nowDateMonth = '0' + nowDateMonth;
	}
	
	afc.log("yjhan1 SACAT562 Ser cipherData ->[" + cipherData + "]");
		
	thisObj.ctrctSrtDt = nowDateYear + nowDateMonth;		
			
	SecurePadManager.cipherToText(cipherData, checkObj, function(result){				
		thisObj.sendData(qrName, 
			function(queryData, groupName)
			{												
				queryData.setHeaderInfo({
					FUNC_KEY_LST: "5"
				});
		
				var InBlock1 = queryData.getBlockData('InBlock1')[0];

				InBlock1['D1처리구분'] = '1'; // 1.등록 2.해지 3.정정
				InBlock1['D1서비스종류코드'] = '3084';
				InBlock1['D1계좌번호'] = checkObj.accNo;
				InBlock1['D1비밀번호'] = afc.isSimulator ? '0423' : result;
				InBlock1['D1투신펀드코드'] = thisObj2.fundCode;
				InBlock1['D1대체계좌번호'] = '';
				InBlock1['D1은행코드'] = '';
				InBlock1['D1은행계좌번호'] = '';
				InBlock1['D1은행계좌명'] = '';
				InBlock1['D1일괄대체코드'] = '02';
				InBlock1['D1자동이체대체금액'] = thisObj2.txtReqMoney;
				InBlock1['D1타사대체구분'] = '1';
				InBlock1['D1약정시작일'] = thisObj.ctrctSrtDt;
				InBlock1['D1자동대체일'] = '20';
				InBlock1['D1대출만기일'] = '9999';
				InBlock1['D1월지급펀드여부'] = '1';

				queryData.putPwInfo('InBlock1', 'D1비밀번호');
				queryData.printQueryData();	
				
			},
			function(queryData, groupName)
			{				
			
				var errMsg = this.getLastError('errMsg');
				var errCode = this.getLastError('errCode');
							
				if(queryData != null){
								
					var OutBlock1 = queryData.getBlockData('OutBlock1');
					if(!OutBlock1) return;

					queryData.printQueryData();

					var errorData = this.getLastError();								

					callback(errorData.errCode);										
				}
			
			}, checkObj.accNo.substring(0,11)
		);
	});
		
};


// 시니어펀드 월지급 약정 조회
@function FD3202:monthRequestCheck(caller)
{
						
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	// 호출한 데이터
	var thisObj2 = caller		
		,callback = arguments[1]	
		,qrName = "SACAT562"
		,cipherData = thisObj2.txtAccPw; // 전 페이지에서 이미 getCipherData()를 사용해서 넘오옴
								
	
	var checkObj = {
		svcId : qrName,
		accNo : thisObj2.subAccNo
	};
		
	var nowDate = MetaInfo.fnGetToday('NUMDATE'); // 오늘 날짜
	
	var nowDateYear = nowDate.substring(0,4); // 현재 년	
	var nowDateMonth = Number(nowDate.substring(4,6)) + 1; // 현재 월
	var nowDateDay = nowDate.substring(6,8); // 현재 일
		
	if(Number(nowDateMonth) == 13){ // 현재 월이 12월인지 체크				
		nowDateYear = Number(nowDateYear) + 1; // 년도증가
		nowDateMonth = 1; // 1월로 변경
	}						
	
	if(nowDateMonth < 10){
		nowDateMonth = '0' + nowDateMonth;
	}
	
		
	thisObj.ctrctSrtDt = nowDateYear + nowDateMonth;		
	
	theApp.accNetManager.addSkipErrorCode('SACAT562', '2678'); // 조회 완료, 내용 확인 후 등록
	theApp.accNetManager.addSkipErrorCode('SACAT562', '3459'); // 해당 계좌 약정 완료, 약정등록 불가
	
	SecurePadManager.cipherToText(cipherData, checkObj, function(result){				
		thisObj.sendData(qrName, 
			function(queryData, groupName)
			{												
				queryData.setHeaderInfo({
					FUNC_KEY_LST: "C"
				});
		
				var InBlock1 = queryData.getBlockData('InBlock1')[0];

				InBlock1['D1처리구분'] = '1'; // 1.등록 2.해지 3.정정
				InBlock1['D1서비스종류코드'] = '3084';
				InBlock1['D1계좌번호'] = checkObj.accNo;
				InBlock1['D1비밀번호'] = afc.isSimulator ? '0423' : result;
				InBlock1['D1투신펀드코드'] = thisObj2.fundCode;
				InBlock1['D1대체계좌번호'] = '';
				InBlock1['D1은행코드'] = '';
				InBlock1['D1은행계좌번호'] = '';
				InBlock1['D1은행계좌명'] = '';
				InBlock1['D1일괄대체코드'] = '02';
				InBlock1['D1자동이체대체금액'] = thisObj2.txtReqMoney;
				InBlock1['D1타사대체구분'] = '1';
				InBlock1['D1약정시작일'] = thisObj.ctrctSrtDt;
				InBlock1['D1자동대체일'] = '20';
				InBlock1['D1대출만기일'] = '9999';
				InBlock1['D1월지급펀드여부'] = '1';

				queryData.putPwInfo('InBlock1', 'D1비밀번호');
				//queryData.printQueryData();	
				
			},
			function(queryData, groupName)
			{				
			
				var errMsg = this.getLastError('errMsg');
				var errCode = this.getLastError('errCode');
				
				// 에러스킵코드 해제
				theApp.accNetManager.removeSkipErrorCode('SACAT562', '2678'); // 조회 완료, 내용 확인 후 등록
				theApp.accNetManager.removeSkipErrorCode('SACAT562', '3459'); // 해당 계좌 약정 완료, 약정등록 불가
				
				var errorData = this.getLastError();								

				callback(errorData.errCode);															
			}
		);
	});
		
};

