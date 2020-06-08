
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5003()
{
	@super();

	// 탭뷰 관련, 페이지 뷰 컨트롤러 관련
	this.tabView = null;
	this.tvManager = null;
	this.lastTabId = null;
	
	// 계좌 타입
	this.accTypeCd = 5;
	
	// 선택한 펀드 정보
	this.selectFundInfo = null;
	
	// 펀드매수단계
	this.fundStepNow = null; 	// 현재 단계
	this.fundStepAll = null;	// 전체 단계
	
	// 2019.01.30 연금펀드 메리츠주니어증권자 추가
	this.juniorSelAccNo = null; // 주니어펀드계좌 세팅
	
}
@extends BasePage;


@function FD5003:onReady()
{
	@super.onReady();

	// 탭뷰
	this.tabView = this.findCompById('TabView1');
	
	// 탭메니저
	this.tvManager = this.makeTabViewManager(this.tabView, this);

	// 탭메뉴
	this.tvMenuMap = [
		['연금펀드목록',	'FD5003_T01'], 
		['상세보기',	 'FD5003_T02'],
		['연금펀드매수',	'FD5003_T03']
	];
	this.lastTabId = 'FD5003_T01';	
		
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
};


// 뷰 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5003:onWillActive(reload)
{	
	@super.onWillActive(reload);
	
	// 선택한 펀드 정보 초기화
	this.selectFundInfo = null;
	
	// 펀드매수단계 초기화
	this.fundStepNow = null;
	this.fundStepAll = null;
	
	// 페이지 데이터 초기화
	this.initByPageData();
};


// 뷰 활성화가 시작되면 매번 호출된다
@function FD5003:onActive(reload)
{
	@super.onActive(reload);		
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5003:onActiveDone(reload)
{
	@super.onActiveDone(reload);	
};


// 페이지 데이터 초기화
@function FD5003:initByPageData()
{
	this.lastTabId = 'FD5003_T01';

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

	this.initChangeTab();
	//this.tvManager.changeTab(this.pageData.tabId, false);
};


// 화면이동
@function FD5003:initChangeTab()
{
	if(this.pageData.tabId)
	{
		// 1) 투자자정보확인서 작성/변경(FD1304)에서 진입
		// 2) 자산현황에서 추가매수 클릭 시(FD5006_W01) 진입
		if(this.pageData.fundCd && this.pageData.fundJoinYN) 
		{
			// 서비스 조회 (선택된 펀드 정보 조회)
			this.sendSOFFQ421(this.pageData.fundCd, this.pageData.fundJoinYN);
		}
		else
		{
			this.tvManager.changeTab(this.pageData.tabId);
		}
	}
	else
	{
		this.tvManager.changeTab(this.pageData.tabId);
	}
};


// 서비스 조회
@function FD5003:sendSOFFQ421(fundCd, fundJoinYN)
{
	var thisObj = this;
	
	// 조회
	thisObj.sendData('SOFFQ421',
		function(queryData, groupName)
		{
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			InBlock1['D1투신펀드코드'] = fundCd;
			InBlock1['D1운용사코드'] = '000';
			InBlock1['D1기준일'] = MetaInfo.fnGetToday('NUMDATE');
			InBlock1['D1투신펀드유형구분'] = '';
			InBlock1['D1간접투자코드'] = '';
			InBlock1['D1가입자격구분'] = '';
			InBlock1['D1투자기간코드'] = '';
			InBlock1['D1한글투신펀드명'] = '';
			InBlock1['D1투신상세코드'] = '77'; // 신연금저축
			InBlock1['D1투자방식코드'] = '';
			InBlock1['D1구분'] = '0';
			InBlock1['D1투자등급코드'] = '00';
			
			if(afc.isSimulator) queryData.printQueryData();
		},
		function(queryData, groupName)
		{
			var fundInfo = null;
			
			if(!queryData)
			{

			}
			else // 성공
			{
				if(afc.isSimulator) queryData.printQueryData();
				
				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				
				if(OutBlock1) fundInfo = OutBlock1;	
			}
			
			// 선택한 펀드의 정보 셋팅
			thisObj.selectFundInfo = fundInfo;
			
			// 페이지 이동
			var param = {
				'펀드가입유무' : fundJoinYN
			};
			thisObj.fundChangeTab(thisObj, thisObj, param);
		}
	);
};


// 뒤로가기
@function FD5003:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


// 계좌 컨트롤 
@function FD5003:onAccViewControl(accView)
{
	// 계좌컨트롤 사이즈 조절 및 라벨 숨기기
	accView.title1.show(AComponent.GONE);
	accView.accDbx.setWidth('100%');
	accView.accDbx.addClass('combo2');
};


// 계좌번호 변경 시 이벤트
@function FD5003:fnDoSendDataManage()
{
	// 계좌 비밀번호 입력 시 이벤트 
	var activeView = this.tvManager.getActiveView(); // 선택 뷰
	if(activeView)
	{
		var activeSubView = activeView.tbvManager.getActiveView(); // 선택 서브 뷰
		if(activeSubView && activeSubView.sendDataManage)
		{
			activeSubView.sendDataManage();
		}
	}
};





//----------------------------------------------------//
//----------------- START 매수하기 ---------------------//
//----------------------------------------------------//
// 서비스 조회 (펀드 가입 조회) 
@function FD5003:sendSOFFQ365(obj, upperObj, param)
{
	var thisObj = obj;
	var cont = upperObj;
	
	
	// 계좌번호가 없으면
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호'])
	{
		AToast.show('계좌번호를 선택하세요.');
		return;
	}
	
	// 조회
	cont.sendData('SOFFQ365',
		function(queryData, groupName)
		{	
			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			InBlock1['D1계좌번호'] = thisObj.accDbx.getSelectedItemData()['D1계좌번호'];
			InBlock1['D1비밀번호'] = param['D1비밀번호']; 
			InBlock1['D1잔고유무여부'] = param['D1잔고유무여부'];
			
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

				var InBlock1 = queryData.getBlockData('InBlock1')[0];
				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				var OutBlock2 = queryData.getBlockData('OutBlock2');

				// 콜백함수실행
				thisObj.callbackSOFFQ365(InBlock1, OutBlock1, OutBlock2);
			}
		}
	);
};


// 서비스 조회 (고객 성향 및 등급)
@function FD5003:sendSACMT110(obj, upperObj, param)
{
	var thisObj = obj;
	var cont = upperObj;
	
	// 계좌번호
	var accList = theApp.accInfo.filterAccList(0); // 계좌번호 리스트
	var accNo = accList[0]["D1계좌번호"]; // 첫번째 계좌 사용
	
	// 등록된 내용이 없습니다. Skip 처리
	theApp.accNetManager.addSkipErrorCode('SACMT110', '3956');
	
	// 조회
	cont.sendData('SACMT110',
		function(queryData, groupName)
		{	
			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			
			// D1처리구분 (1: 등록, 2: 정정, 3: 조회)
			if(param['D1처리구분'] == '1')
			{
				InBlock1['D1처리구분'] = param['D1처리구분'];
				InBlock1['D1고객구분'] = '1';
				InBlock1['D1실명확인번호'] = accNo;
				InBlock1['D1개인법인구분'] = '1';
				InBlock1['D1정보확인사원번호'] = 'MTS';
				InBlock1['D1투자권유구분'] = '0';
				InBlock1['D1정보제공구분'] = '0';
			}
			else if(param['D1처리구분'] == '2')
			{
				
			}
			else if(param['D1처리구분'] == '3')
			{
				InBlock1['D1처리구분'] = param['D1처리구분'];
				InBlock1['D1고객구분'] = '1';
				InBlock1['D1실명확인번호'] = accNo;
			}
			
			if(afc.isSimulator) queryData.printQueryData();
		},
		function(queryData, groupName)
		{	
			if(!queryData)
			{

			}
			else // 성공
			{
				if(afc.isSimulator) queryData.printQueryData();

				var InBlock1 = queryData.getBlockData('InBlock1')[0];
				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				
				theApp.userInfo.set('UserGrade', InBlock1);
			}
			
			// 콜백함수실행
			if(param['D1처리구분'] == '1') thisObj.callbackSACMT110_001();
			else if(param['D1처리구분'] == '2') thisObj.callbackSACMT110_002();
			else if(param['D1처리구분'] == '3') thisObj.callbackSACMT110_003();
		}
	);		
};


// 투자자정보확인서 체크
@function FD5003:checkUserGrd(obj, upperObj, param)
{
	var thisObj = obj;
	var cont = upperObj;
	
	// 투자자정보확인서
	var userGrd = theApp.userInfo.get('UserGrade');
	if(userGrd == undefined) // 작성되지않음
	{
		if(param['팝업'] == 'T')
		{
			// 현재 팝업 닫기
			thisObj.close(0);
		}
		
		// 팝업
		theApp.confirm(
			'선택하신 펀드가 본인의 투자성향과<br/>적합한지 확인을 위해 투자자정보<br/>'
				+ '확인서를 작성하셔야 합니다.<br/>진행하시겠습니까?', 
			function(result)
			{
				if(result == 1) // 예 클릭 => 투자자정보확인서 작성/변경
				{
					if(param['펀드가입유무'] == "Y") // 가입됨 => 펀드납입정보입력
					{
						theApp.goPageCheck('FD1304', false, { returnPageId: 'FD5003', tabId: 'FD5003_T03', 
							fundCd: cont.selectFundInfo["D1투신펀드코드"], fundJoinYN: 'Y' });
					}
					else // 가입되어있지않음 => 투자자정보 체크
					{
						theApp.goPageCheck('FD1304', false, { returnPageId: 'FD5003', tabId: 'FD5003_T03',
							fundCd: cont.selectFundInfo["D1투신펀드코드"], fundJoinYN: 'N' });
					}					
				} 
				else // 아니오 클릭 => 투자권유 불원 팝업
				{	
					// 콜백함수실행
					thisObj.callbackCheckUserGrd();
				}
			}, '', ['예','아니오']
		);
	}
	else // 작성됨
	{	
		if(param['팝업'] == 'T')
		{
			// 현재 팝업 닫기
			thisObj.close(0);
		}
		
		// 페이지 이동
		var param = {
			'펀드가입유무' : param['펀드가입유무']
		};
		cont.fundChangeTab(cont, cont, param);
	}
};


// 매수 페이지 이동
@function FD5003:fundChangeTab(obj, upperObj, param)
{
	var thisObj = obj;
	var cont = upperObj;
	
	var subTab = '';
	
	// 펀드가입유무 체크
	if(param['펀드가입유무'] == "Y")
	{
		// 펀드 가입: O, 투자자정보 등록: O
		cont.fundStepNow = 1;
		cont.fundStepAll = 2;
		subTab = 'FD5003_V05';
	}
	else
	{
		var userGrd = theApp.userInfo.get('UserGrade');
		if(userGrd['D1투자권유구분'] == "0" || userGrd['D1정보제공구분'] == "0")
		{
			// 펀드 가입: X, 투자자정보 등록: O =>(투자권유구분: 불원 or 정보제공구분: 미제공)
			cont.fundStepNow = 3;
			cont.fundStepAll = 6;
			subTab = 'FD5003_V03';
		}
		else
		{
			// 펀드 가입: X, 투자자정보 등록: O =>(투자권유구분: 희망 and 정보제공구분: 제공)
			cont.fundStepNow = 1;
			cont.fundStepAll = 6;
			subTab = 'FD5003_V01';
		}	
	}
	
	// 탭이동
	cont.tvManager.changeTab('FD5003_T03', {subTabId : subTab});
};
//----------------------------------------------------//
//------------------- END 매수하기 ---------------------//
//----------------------------------------------------//





//----------------------------------------------------//
//------------ START 입금하기 페이지 이동 ----------------//
//----------------------------------------------------//
// sendSDPAQ070 콜백함수 (납입한도 확인)
@function FD5003:callback070Data(money)
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
	
	// 입금하기 이동 
	this.openFD5005();
};


// 입금하기로 이동 
@function FD5003:openFD5005()
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



// 펀드코드별 URL
@function FD5003:fundCdURL(selectCd)
{
	var httpFundProURL		= 'http://www.meritzam.com/fund_pro/'; 
	var httpStipulURL 		= 'http://www.meritzam.com/marketings/stipul_';
	var httpInvestURL		= 'http://www.meritzam.com/marketings/invest_';
	var httpProspectusURL 	= 'http://www.meritzam.com/marketings/prospectus_';
	
	var httpsFundProURL		= 'https://www.meritzam.com/fund_pro/'; 
	var httpsStipulURL 		= 'https://www.meritzam.com/marketings/stipul_';
	var httpsInvestURL		= 'https://www.meritzam.com/marketings/invest_';
	var httpsProspectusURL 	= 'https://www.meritzam.com/marketings/prospectus_';
	
	// 운용사코드(TEST), 판매사코드(REAL)
	var mappingCd = {
		'2231' : '0100',
		'4077' : '0150',
		'0200' : '0200',
		'2126' : '0250',
		'2198' : '0300',
		'2148' : '0350',
		'2169' : '0400',
		'0450' : '0450',
		'4070' : '0500',
		'0550' : '0550',
		'0600' : '0600',
		'0650' : '0650',
		'0160' : '0190'
	};
	
	if( mappingCd[selectCd] != undefined ) selectCd = mappingCd[selectCd];
	

	// 판매사코드별 펀드명
	var fundInfo ={
		'0050' : {fundCd: '2190', fundNm : ''},
		'0100' : {fundCd: '2228', fundNm : 'fund2231'},
		'0150' : {fundCd: '4074', fundNm : '메리츠시니어증권자투자신탁채권혼합-재간접형-2'},
		'0200' : {fundCd: '7003', fundNm : 'fund7011'},
		'0250' : {fundCd: '2066', fundNm : '메리츠코리아증권1호주식종류a'},
		'0300' : {fundCd: '2105', fundNm : '메리츠코리아스몰캡증권투자신탁주식'},
		'0350' : {fundCd: '2133', fundNm : '메리츠글로벌헬스케어증권투자신탁주식'},
		'0400' : {fundCd: '2154', fundNm : '메리츠차이나증권투자신탁주식'},
		'0450' : {fundCd: '2210', fundNm : '메리츠글로벌인프라증권자투자신탁주식'},
		'0500' : {fundCd: '4053', fundNm : '메리츠코리아증권채권혼합'},
		'0550' : {fundCd: '3023', fundNm : 'fund3023'},
		'0600' : {fundCd: '2082', fundNm : 'fund2082'},
		'0650' : {fundCd: '1332', fundNm : 'fund1332'},
		'0190' : {fundCd: '7052', fundNm : 'fund7060'}
	};
	
	// 펀드코드 및 펀드명
	var fundInfoCd = '';
	var fundInfoNm = '';
	
	if( fundInfo[selectCd] != undefined )
	{
		fundInfoCd = fundInfo[selectCd].fundCd;
		fundInfoNm = fundInfo[selectCd].fundNm;
	}
	
	// URL
	var returnVal = {
		'판매사코드' : selectCd,
		'기준가수익률' : httpFundProURL + fundInfoNm + '/#phide_top',
		'보유종목TOP10' : httpFundProURL + fundInfoNm + '/#top10',
		'집합투자규약' : httpStipulURL + fundInfoCd + '.html',
		'집합투자규약_pdf' : httpsStipulURL + fundInfoCd + '.pdf',
		'투자설명서' : httpInvestURL  + fundInfoCd + '.html',
		'투자설명서_pdf' : httpsInvestURL  + fundInfoCd + '.pdf',
		'간이투자설명서' : httpProspectusURL + fundInfoCd + '.html',
		'간이투자설명서_pdf' : httpsProspectusURL + fundInfoCd + '.pdf'
	};
	
	return returnVal;
};

// 2019.01.30 연금펀드 메리츠주니어증권자 추가
// 미성년자 판별 함수
@function FD5003:userAgeCheck(caller)
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
