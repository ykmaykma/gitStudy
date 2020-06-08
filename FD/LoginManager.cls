
/**
Constructor
Do not call Function in Constructor.
*/
@class LoginManager()
{
	this.container = null;
	
	this.loginKbn = '0';
	this.loginTrName = 'SBPLT301';
	
	this.loginCallback = null;
	this.certCallback = null;
	this.endCallback = null;
	
	this.checkAcc = null;
}

@function LoginManager:setContainer(container)
{
	this.container = container;
};

@function LoginManager:setLoginType(loginKbn)
{
	this.loginKbn = loginKbn;
};


@function LoginManager:endCallbackManage(code, text)
{
	//-------------------------
		AppManager.endOltp();
	//-------------------------
					
	if(this.endCallback)
	{
		this.endCallback(code, text);
		this.endCallback = null;
	}
};


//1. 사용자 정보 요청, SBPLT301(로그인)
@function LoginManager:requestUserInfo(userPw, callback, isAutoLogin)
{
	//----------------------------------------
		AppManager.beginOltp();
	//----------------------------------------

	var thisObj = this;
	
	thisObj.endCallback = callback;
	
	if(!userPw)
	{
		thisObj.idLoginResult(Define.FAIL, '비밀번호가 존재하지 않습니다.');
		return;
	}
	
	theApp.accNetManager.sendProcessByName(this.loginTrName, null, null,
	//beforeInBlockBuffer
	function(queryData, groupName)
	{

		var blockData = queryData.getBlockData('InBlock1')[0];
		blockData['D1로그인구분'] = thisObj.loginKbn;
		blockData['D1로그인비밀번호구분'] = '2';
		blockData['D1로그인비밀번호'] = userPw;

		queryData.putPwInfo('InBlock1', 'D1로그인비밀번호', true);
		//queryData.enableFlag('encFlag');
		
		this.addSkipErrorCode(thisObj.loginTrName, 4256); //ID패스워드 틀림
		this.addSkipErrorCode(thisObj.loginTrName, 4262); //ID패스워드 회수 초과
		this.addSkipErrorCode(thisObj.loginTrName, 4362); //사용자ID를 정확하게 입력
		this.addSkipErrorCode(thisObj.loginTrName, 3192); //중복로그인
		this.addSkipErrorCode(thisObj.loginTrName, 3295); //삭제된아이디
		//9509 or 9507 or 9504 오류코드 발생 시 정규장 > CME > 해외선물 순서로 재접속 시도 함(SBPLT301 > CBPLT301 > FBPLT301)
		this.addSkipErrorCode(thisObj.loginTrName, 9509);
		this.addSkipErrorCode(thisObj.loginTrName, 9507);
		this.addSkipErrorCode(thisObj.loginTrName, 9504);
		
	},

	//afterOutBlockData
	function(queryData, groupName)
	{
		var errorData = this.getLastError();
		//------------------------------------------------------------------------
		//	로그인 성공[SBPLT301]
		//------------------------------------------------------------------------
		if(errorData.errCode == 0)
		{
			var userData = queryData.getBlockData('OutBlock1')[0];
			if(userData)
			{
				
				thisObj.setLoginType('0');
				thisObj.loginTrName = 'SBPLT301';

				//asoocool, 로그인 과정에 추가
				var headerInfo = 
					{
						CONN_CHN_NO		: this.rcvBuf.getParseInt(OS_TH_CONN_CHN_NO, SZ_TH_CONN_CHN_NO),	//접속채널번호
						CONN_CLNT_NO	: this.rcvBuf.getParseInt(OS_TH_CONN_CLNT_NO, SZ_TH_CONN_CLNT_NO),	//접속클라이언트번호
						HOST_CLNT_NO	: this.rcvBuf.getParseInt(OS_TH_HOST_CLNT_NO, SZ_TH_HOST_CLNT_NO),	//호스트클라이언트번호
						PUB_IP			: this.rcvBuf.getOriString(OS_TH_PUB_IP, SZ_TH_PUB_IP)				//공인IP
					};

				//theApp.infoNetManager.setHeaderInfo(headerInfo);
				theApp.accNetManager.setHeaderInfo(headerInfo);
				
				if(userData['D1고객구분'] == '1'){
					thisObj.idLoginResult(Define.FAIL, '법인고객의 경우 WTS(온라인)를 이용해주시거나, 본점 방문 또는 대표번호로 연락주시기 바랍니다.<br> 대표번호 : 1588-5533');
				}else {
					theApp.userInfo.setUserData(userData);
					// 영업일 저장
					//공휴일에는 D1영업일이 당일이 넘어오므로 사용해서는 안된다
					//하지만 방어코드로 넣어놓자
					theApp.userInfo.set('BizDt',userData['D1영업일']);
					
					thisObj.sendSCMAQ048();
					
					thisObj.idLoginResult(Define.SUCCESS, '', isAutoLogin);
				}
				
			}
			else thisObj.idLoginResult(Define.FAIL, (this.errorData.errMsg) ? this.errorData.errMsg : '로그인에 실패하였습니다.');
		}
		
		//중복로그인
		else if(errorData.errCode == 3192)
		{
			theApp.confirm('<span>중복 로그인 되었습니다.<br/>기존 로그인을 강제 종료하고<br/>새로 로그인 하시겠습니까?</span>', 						function(result){
					if(result == 1)
					{  
						thisObj.setLoginType('2');
						thisObj.requestUserInfo(userPw, callback);
					}
					else
					{
						theApp.exitApp();
					}
				}, '중복로그인', ['강제로그인', '종료']
			);
		}
		
		//정규장 -> CME -> 해외로 변경해 줘야함
		else if(errorData.errCode == 9509 || errorData.errCode == 9507 || errorData.errCode == 9504)
		{
		
			if(thisObj.loginTrName == 'SBPLT301')
			{
				//정규장 실패시 CME로 로그인 변경				
				thisObj.loginTrName = 'CBPLT301';
				thisObj.requestUserInfo(userPw, callback);
			}
			else if(thisObj.loginTrName == 'CBPLT301')
			{
				//CME 실패시 해외시세로 로그인 변경
				thisObj.loginTrName = 'FBPLT301';
				thisObj.requestUserInfo(userPw, callback);
			}
			//해외
			else //if(thisObj.loginTrName == 'FBPLT301')
			{
				thisObj.loginTrName = 'SBPLT301';
				thisObj.idLoginResult(Define.FAIL, '정규시장 시스템 준비 작업 중입니다.');
			}
			
		}
		
		//4262 비밀번호 회수초과
		else if(errorData.errCode == 4262)
		{
			thisObj.idLoginResult(Define.FAIL, errorData.errMsg.replace('콜센터', '고객지원센터') + '<br/><br/>고객지원센터 : '+theApp.systemInfo.data.FirmCall[theApp.systemInfo.fno]+'</span>');
		}
		//4256는 비밀번호 틀림 / 4362는 ID틀림 / 3295는 삭제된 id
		else if(errorData.errCode == 4256 || errorData.errCode == 4362 || errorData.errCode == 3295)
		{
			thisObj.idLoginResult(Define.FAIL, errorData.errMsg);
		}
		
		else 
		{
			//자동로그인일때는 실패결과값을 전달
			if(isAutoLogin)
			{
				thisObj.idLoginResult(Define.FAIL, errorData.errMsg);
			}
			else
			{
				theApp.prefInfo.get('User')[2] = '';
				theApp.prefInfo.get('User')[3] = 0;

				//-------------------------
					AppManager.endOltp();
				//-------------------------
			}
		}
	});	
};

@function LoginManager:idLoginResult(code, text, isAutoLogin)
{
	var thisObj = this;
	if(code == Define.SUCCESS)
	{	
		thisObj.requestIdentification();
	}
	else
	{
		theApp.prefInfo.get('User')[2] = '';
		theApp.prefInfo.get('User')[3] = 0;
		
		thisObj.endCallbackManage(Define.FAIL, text);
	}
};

//2.전자서명 및 본인확인 대상서비스 목록 요청
@function LoginManager:requestIdentification()
{
	var thisObj = this;

	theApp.accNetManager.sendProcessByName('SBPGQ780', null, null, 
	
	//beforeInBlockBuffer
	function(queryData, groupName)
	{
		
	},
	
	//afterOutBlockData
	function(queryData, groupName)
	{
		if (afc.isSimulator) queryData.printQueryData();	
		
		this.setSBPGQ780(queryData);
		
		thisObj.requestAccountInfo();
		//thisObj.certCallback(Define.SUCCESS);
	});
};

/*
//6.메뉴파일 요청
@function LoginManager:requestMenuInfo()
{
	
	this.requestAccountInfo();
};
*/

//3.계좌정보 가져오기
@function LoginManager:requestAccountInfo()
{
	var thisObj = this;
	theApp.accNetManager.sendProcessByName('SACEQ306', null, null, 
	
	//beforeInBlockBuffer
	function(queryData, groupName)
	{
		var inblockData = queryData.getBlockData('InBlock1');
		inblockData[0]['D1전자금융사용자ID'] = this.headerInfo.USER_ID;
	},
	
	//afterOutBlockData
	function(queryData, groupName)
	{
		if (afc.isSimulator) queryData.printQueryData();
		//계좌정보 클리어
		theApp.accInfo.clearInfo();
		
		if(!queryData){
			thisObj.checkOpenAccount();	
			return;
		} 
		
		var OutBlock1 = queryData.getBlockData('OutBlock1');
		if(OutBlock1 && OutBlock1.length > 0)
		{
			theApp.accInfo.setAccData(OutBlock1);

			//자주쓰는계좌불러오기
			//theApp.accInfo.doLoadJaJuBankNums(); 
			
			thisObj.userGradeCheck();
			
			//thisObj.endCallbackManage(1);
		}	
		else{
			thisObj.checkOpenAccount();
		}
		
	});
};

//4.비대면 계좌개설 현황 체크(계좌내용 없을 시)
@function LoginManager:checkOpenAccount()
{
	var thisObj = this;
	
	theApp.accNetManager.sendProcessByName('SACMT635', null, null, 
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1');
		inBlock1[0] =
			{
			"D1처리구분" : 2,
			"D1실명확인번호" : '',
			"D1디바이스고유번호" : theApp.uId
		};
	},
	function(queryData)
	{
		var errCode = this.getLastError('errCode');
		if(queryData)
		{
			var outBlock = queryData.getBlockData('OutBlock1')[0];
			//계좌개설 완료 > 진위확인 이전단계
			if(outBlock['D1처리상태코드'] == '99' || outBlock['D1처리상태코드'] == '0A' || outBlock['D1처리상태코드'] == '0B') {
				if(outBlock['D1비대면업무구분'] == 'A') {
					thisObj.endCallbackManage(Define.FAIL, '계좌개설완료 문자 수신 후 로그인이 가능합니다.');	
					return;
				}
			}
			else thisObj.endCallbackManage(Define.FAIL, '계좌정보 수신 중 오류가 발생하였습니다. 재로그인 해주십시요.');	
		}
		else
			thisObj.endCallbackManage(Define.FAIL, '계좌정보 수신 중 오류가 발생하였습니다. 재로그인 해주십시요.');	
	});
};

// 고객등급, 성향조회
@function LoginManager:userGradeCheck()
{
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	var accList = theApp.accInfo.filterAccList(0); // 계좌번호 리스트 가져오기	
	var accNo = accList[0]["D1계좌번호"]; // 첫번째 계좌 사용
	
	theApp.accNetManager.addSkipErrorCode('SACMT110', '3956'); // 등록된 내용이 없습니다. Skip 처리
	theApp.accNetManager.sendProcessByName('SACMT110', null, null,
		function(queryData, groupName)
		{
		
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
										
			InBlock1['D1처리구분'] = '3';
			InBlock1['D1고객구분'] = '1';
			InBlock1['D1실명확인번호'] = accNo;																			
		 },
		//afterOutBlockData
		function(queryData, groupName)
		{			
			if(queryData)
			{
				//queryData.printQueryData();
				
				var InBlock1 = queryData.getBlockData('InBlock1')[0];
				
				theApp.userInfo.set('UserGrade',InBlock1);
			}		
			thisObj.endCallbackManage(1);	
		});
		
};


//로그인 성공 후 체크해야할 프로세스
@function LoginManager:checkAfterLoginSuccess()
{
	
//	var userId = theApp.accNetManager.getHeaderInfo('USER_ID');
//	var userList = ['fourier2'];
//	if($.inArray(userId, userList) >= 0) {

	var now = new Date();			
	var now2 = null;			

	now2 = now.format('yyyyMMdd');
	
	// 20190308 부터 시작되는 메리츠 3월 메리츠더우먼펀드 가입이벤트 팝업
	if(now2 >=20190307 && now2 <= 20190331)
	{
		var popupEvtDate = theApp.prefInfo.get('EventDate3');
						
		if(popupEvtDate < now2){
			this.checkEvent2();
		}		
	}
	
	// 20190502부터 시작되는 부자가 되는 습관을 위한 메리츠의 콜라보 이벤트
	if(now2 >= 20190502 && now2 <= 20190531){
		var popupEvtDate = theApp.prefInfo.get('EventDate3');
						
		if(popupEvtDate < now2){
			this.checkEvent2();
		}
	}
	
	
	
	// 20190926 시작(매일적립식 이벤트) -> 20200102 이벤트 종료로 팝업 제거
	/*
	var popupEvtDate = theApp.prefInfo.get('EventDate2');
	var userId = theApp.accNetManager.getHeaderInfo('USER_ID');
	var thisObj = this;
	
	
	var SMSSendFlag = theApp.prefInfo.get('SMSSendFlag');
	var SMSDays = [1, 20, 40, 60, 80, 100];
	
	theApp.accNetManager.addSkipErrorCode('SDPBQ019', '2679');
	theApp.accNetManager.sendProcessByName('SDPBQ019', null, null,
		function(queryData, groupName)
		{
		
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
										
			InBlock1['D1계좌구분'] = '2'; // 연금계좌  (0:전체, 1:46계좌, 2:47계좌)
			InBlock1['D1조회사용자ID'] = userId;
			InBlock1['D1조회시작일'] = '20180101';
			InBlock1['D1조회종료일'] = '99999999';
			InBlock1['D1가입금액'] = '10000'; // 2019.09.20. 가입금액 셋팅 10000 원 이상
			
		 },
		function(queryData, groupName)
		{	
			
			if(queryData)
			{
				if(afc.isSimulator) queryData.printQueryData();
				
				var outBlock = queryData.getBlockData('OutBlock1')[0];
				
				if (outBlock) {
	  				var dayCnt = outBlock['D1납입일수'];
					var clntNo = outBlock['D1입금계좌번호'];
					

					if(0 < outBlock['D1납입일수'] && 10000 <= outBlock['D1가입금액'] && outBlock['D1입금계좌번호']) {
						if(popupEvtDate < now2){
						
							if (0 < dayCnt && 100 > dayCnt) thisObj.checkEvent3(dayCnt);
							for (var i in SMSDays) {
								if (SMSDays[i] == dayCnt) {
									if (SMSSendFlag != dayCnt)
										thisObj.getPhoneTxt(clntNo, dayCnt);
										
								}
							}
						
						}
					}
				
				}
				
			}		
		});
	*/
	
	

	return;
	
	//임시비밀번호 체크
	if(this.checkTempPassWordChange()) return;
	
	//3개월 패스워드 체크
	this.checkPassWordValid();
};

@function LoginManager:checkEvent(userId)
{
	var thisObj = this;
	theApp.accNetManager.addSkipErrorCode('SBPGT135', '0200');
	theApp.accNetManager.sendProcessByName('SBPGT135', null, null,
	function(queryData, groupName)
	{
		var InBlock1 = queryData.getBlockData('InBlock1')[0];
		
		InBlock1['D1처리구분'] = '1';
		InBlock1['D1약관동의처리대상ID'] = this.getHeaderInfo('USER_ID');
		InBlock1['D1약관종류코드'] = 'Z1';
		InBlock1['D1약관동의여부'] = 'Y';
		InBlock1['D1약관동의처리대상코드'] = '01';
	},
	function(queryData, groupName)
	{				
		var errMsg = this.getLastError('errMsg');
		var errCode = this.getLastError('errCode');

		if(errCode == '0200') {
			var win = AWindow.createWindow('FD/window/FD0000_W07.lay', 'FD0000W07');
			win.openAsDialog(this);
		}
	});
}

@function LoginManager:checkEvent2(userId)
{
	var win = AWindow.createWindow('FD/window/FD0000_W12.lay', 'FD000W12');
	win.openAsDialog(this);
}

@function LoginManager:checkEvent3(cnt)
{
	var win = AWindow.createWindow('FD/window/FD0000_W15.lay', 'FD000W15');
	win.eventCnt = cnt;
	win.open(this, 0, 0, '100%', '100%');
// 	win.openAsDialog(this);
}

@function LoginManager:getPhoneTxt(clntNo, dayCnt)
{	
	var thisObj = this;
	
	theApp.accNetManager.addSkipErrorCode('SACMQ108', '1166');
	theApp.accNetManager.sendProcessByName('SACMQ108', null, null,
		function(queryData, groupName)
		{
			var inBlock1 = queryData.getBlockData('InBlock1')[0];		
			inBlock1['D1고객번호'] = clntNo;
			
		 },
		function(queryData, groupName)
		{			
			if(queryData)
			{
				queryData.printQueryData();
				
				var outBlock2 = queryData.getBlockData('OutBlock2')[2];	//email
				
				//전화번호
				if( outBlock2['D1전화지역번호'])
					var clntPhone = Utils.makePhoneForm(outBlock2['D1전화지역번호']+outBlock2['D1전화국번호']+outBlock2['D1전화일련번호']);
					thisObj.sendSMSEvent3(dayCnt, clntPhone);
				
			}		
		});
	
};


@function LoginManager:sendSMSEvent3(cnt, clntPhone)
{
	if (!clntPhone) {
		return false;
	}

 	theApp.accNetManager.addSkipErrorCode('SCMAM113', '9604');
	theApp.accNetManager.sendProcessByName('SCMAM113', null, null,
		function(queryData, groupName)
		{
		
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			
			var txt1 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
       				   "\n" + 
			           "연금펀드 매일적립식 투자 1회차입니다.\n" +	
					   "매일마다 투자될 수 있도록 미리 고객님의 연금계좌로 입금해주세요.\n" +
					   "\n" +
					   "[연금펀드 매일적립식 납입방법 안내]\n" +
					   "Step1. 우리은행 가상계좌 입금\n" +
					   "Step2. [메리츠자산운용 펀드투자] 어플 로그인\n" +
					   "Step3. 메인 화면 [연금저축펀드 계좌로 가기] 클릭\n" +
					   "Step4. 하단 메뉴 [연금계좌입금] 통해 입금\n" +
					   "*매수신청일 기준으로 실제 펀드매수까지 수일 소요될 수 있습니다.\n" +
					   "\n" +
					   "매일 만원으로 하는 노후준비, 여러분의 여정을 메리츠자산운용이 함께 하겠습니다.";   
					   
			var txt20 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
					    "연금펀드 매일적립식 투자 20회차입니다.\n" +	
					    "\n" +
					    "하루하루 조금씩 아낀 돈으로 투자한 회사의 주주가 될 수 있다는 사실이 " +
					    "흥미롭지 않나요? 펀드투자는 좋은 기업에 동업자의 마음으로 꾸준하게 " +
					    "투자하여 성장의 열매를 나눠 갖는 것입니다.\n " +
					    "\n" +
					    "오랜 기간 꾸준히 투자하여 장기투자의 결실을 얻으시길 바랍니다.\n" +   
					    "(고객센터) 1588-5533 감사합니다.";
					   
			var txt40 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
					    "연금펀드 매일적립식 투자 40회차입니다.\n" +	
					    "\n" +
					    "오늘도 커피값 대신 노후에 투자한 여러분, 여유자금은 목돈일 필요가 없습니다. " +
					    "단지 오늘 꼭 쓰지 않아도 될 돈을 아끼면 언제든지 여유자금이 되는 것입니다.\n" +
					    "\n" +
					    "매일 만원으로 하는 노후준비, 여유자금으로 풍요로운 미래를 만들어가세요!\n" +   
					    "(고객센터) 1588-5533 감사합니다.";
					   
			var txt60 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
					    "연금펀드 매일적립식 투자 60회차입니다.\n" +	
					    "\n" +
					    "메리츠자산운용과 함께하는 매일적립식 투자습관,\n" +
					    "매일매일 부자가 되는 습관, 누구나 노후준비를 할 수 있습니다.\n" +
					    "투자에 성공하려면 눈이 오나 비가 오나 항상 투자가 되어 있어야 합니다.\n" +
					    "\n " +
					    "매일 만원으로 하는 노후준비, 메리츠자산운용이 함께합니다.\n" +   
					    "(고객센터) 1588-5533 감사합니다.";

			var txt80 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
					    "연금펀드 매일적립식 투자 80회차입니다.\n" +	
					    "\n" +
					    "자본주의 사회에서 자본가가 되려면 노동과 자본이 함께 일해야 합니다. " +
					    "수입의 10~20%를 여러분의 노후를 위해 투자해두어야 하는 이유입니다.\n" +
					    "\n" +
					    "매일 만원으로 하는 노후준비, 메리츠자산운용이 함께합니다.\n" + 
					    "(고객센터) 1588-5533 감사합니다.";

			var txt100 = "고객님 안녕하세요, 메리츠자산운용입니다.\n" +
                         "\n" +
					     "연금펀드 매일적립식 투자 100회 달성을 축하드립니다.\n" +	
					     "메리츠자산운용 직원이 고객님께 이벤트 관련하여 유선 안내드릴 예정입니다.\n" +
					     "\n" +
					     "노후준비는 마라톤과 같습니다. 길게, 멀리 보는 안목을 가지고 꾸준한\n" +
					     "페이스로 투자하는 것이 중요합니다.\n" +
					     "\n" +
					     "앞으로도 메리츠자산운용과 함께 노후준비의 길을 걸어가시길 바랍니다.\n" +   
					     "(고객센터) 1588-5533 감사합니다.";
			
			if (20 == cnt) txt = txt20;		 
			else if (40 == cnt) txt = txt40;		 
			else if (60 == cnt) txt = txt60;		 
			else if (80 == cnt) txt = txt80;		 
			else if (100 == cnt) txt = txt100;
			else txt = txt1;
					 
// 			alert(txt);
										
			InBlock1['D1이용사번호'] = '951'; 
			InBlock1['D1SMS메시지코드'] = '100'; 
			InBlock1['D1휴대폰수신번호'] = clntPhone;
			InBlock1['D1휴대폰발신번호'] = '1588-5533';
			InBlock1['D1처리메시지'] = txt;
			InBlock1['D1종목명'] = '메리츠자산운용';
		 },
		function(queryData, groupName)
		{			
			theApp.prefInfo.set('SMSSendFlag', cnt);
			if(queryData)
			{
				queryData.printQueryData();
				
				var outBlock = queryData.getBlockData('OutBlock1')[0];
				
/*				if (outBlock) {
					console.log("### 이용사번호 : " + outBlock['D1이용사번호']);
					console.log("### 업무영역코드 : " + outBlock['D1업무영역코드']);
					console.log("### 메시지코드 : " + outBlock['D1SMS메시지코드']);
					console.log("### 메시지내용 : " + outBlock['D1SMS메시지내용']);
					console.log("### 비고 : " + outBlock['D1비고']);

				}
*/			
			}		
		});
}


//10.임시비밀번호 변경 체크
@function LoginManager:checkTempPassWordChange()
{
	//로그인은 성공했으나 임시비밀번호사용 등과 같은 팝업메시지여부가 있을때는 다시 로그아웃 시키고 팝업메시지를 보여줌
	if(theApp.userInfo.get('D1팝업메시지여부') == 'Y')
	{
		var win = AWindow.createWindow('MS/window/MS0101_W03.lay', 'MS010103');
		win.text = theApp.userInfo.get('D1팝업메시지');
		win.title = '임시비밀번호 변경';
		win.type = 'temppw';	//임시비밀번호 변경
		win.btnText = ['닫기', '비밀번호 변경'];
		win.openAsDialog(this);
		return true;
	}
	return false;
};

//11.비밀번호 3개월 연장 체크
@function LoginManager:checkPassWordValid()
{
	if(theApp.userInfo.get('D1로그인비밀번호만료구분') == '1')
	{
		var win = AWindow.createWindow('MS/window/MS0101_W03.lay', 'MS010103');
		win.title = '접속비밀번호 변경';
		win.type = 'connpw';	//접속 비밀번호 변경
		win.openAsDialog(this);
	}
};

//자동 로그인
@function LoginManager:autoLogin(loginState, callback)
{
	var thisObj = this;
	
	this.endCallback = callback;
	
	if(!theApp.prefInfo.get('User')[2])
	{
		this.endCallbackManage(Define.FAIL, '');
		//callback(Define.FAIL, '비밀번호가 존재하지 않습니다.');
		return;
	}
	
	this.requestUserInfo(theApp.prefInfo.get('User')[2], callback, true);
};

//로그아웃TR만 따로 날릴때 쓰는 함수
@function LoginManager:requestOnlyLogout(callback)
{
	theApp.accNetManager.sendProcessByName('SBPLT304', null, null, function(queryData, groupName)
	{
		var inBlock1 = queryData.getBlockData('InBlock1');
		inBlock1[0]['D1처리구분'] = 'O';
	},

	function(queryData, groupName)
	{
		if(callback) callback();
	});	
};

//로그아웃 요청
@function LoginManager:requestLogout(callback)
{
	
	if(!AppManager.isHidePatchView || !theApp.accNetManager || !theApp.accNetManager.isStart())
	{
		if(callback) callback();
		return;
	}
	else
	{
		/*
		if(!afc.isSimulator) PushManager.pushLogout();
		*/
		theApp.accInfo.clearInfo();
		//eApp.certInfo.setCertPw('');
		
		if(theApp.userInfo.isLogin())
		{
			theApp.accNetManager.sendProcessByName('SBPLT304', null, null, function(queryData, groupName)
			{
				var inBlock1 = queryData.getBlockData('InBlock1');
				inBlock1[0]['D1처리구분'] = 'O';
			},

			function(queryData, groupName)
			{
				//alert(111111);
				//if(callback) callback();
			});	
		}
		
		setTimeout(function()
		{
			if(callback) callback();
			
		}, 700);
		
	}
	
};

@function LoginManager:onWindowResult(result, awindow)
{
	var winId = awindow.getId();
	var thisObj = this;
	
	if(winId == 'MS071701')
	{
		if(result == 1) theApp.goPageCheck('MS0717');
	} else if(winId == 'MS071702')
	{
		this.sendSACAT750(awindow.outBlock1, awindow.outBlock2);
		/*if(result == 1) {
			theApp.accNetManager.sendProcessByName('SACAT750', null, null, 

												   function(queryData)
												   {
				var date = new Date();								   
				
				var temp = date.getFullYear();
				
				if(date.getMonth().length == 1) {
					temp += '0' + date.getMonth();
				} else {
					temp += date.getMonth();
				}
				
				if(date.getDate().length == 1) {
					temp += '0' + date.getDate();
				} else {
					temp += date.getDate();
				}
				
				var inBlockData = queryData.getBlockData('InBlock1')[0];
				inBlockData['D1계좌번호'] = thisObj.checkAcc;
				inBlockData['D1확인일'] = temp;
				inBlockData['D1확인시각'] = date.toTimeString().split('')[0].replace(/:/gi,'');
				inBlockData['D1상품명'] = awindow.data['D1상품명'];
// 				inBlockData['D1연락처'] = awindow.data['D1상품명'];
				inBlockData['D1거래자우편번호'] = awindow.data['D1현재담보비율'];
				inBlockData['D1직장우편번호'] = awindow.data['D1기준담보비율'];
// 				inBlockData['D1요청일'] = awindow.data['D1상품명'];
				inBlockData['D1요청시각'] = awindow.data['D1입금시간'];

				//queryData.printQueryData();
			},

												   //afterOutBlockData
												   function(queryData, groupName)
												   {
				if(queryData)
				{
					//queryData.printQueryData();

					var outBlockData = queryData.getBlockData('OutBlock1')[0];

					if(outBlockData['D1처리여부'] == '1') {
						
					} else {
					
					}
				}
				else 
				{
				}
			});
		}*/
	} else if(winId == 'MS000015')
	{
		if(result == 1) {
			var win = AWindow.createWindow('MS/window/MS0000_W16.lay', 'MS000016');
			win.open(this, 0, 0, '100%', '100%');
		} else {
			/*var win = AWindow.createWindow('MS/window/MS0000_W15.lay', 'MS000017');
			win.openAsDialog(this);*/

			theApp.confirm('이벤트 응모를 취소하셨습니다. "예"를 선택한 경우 추후 이벤트 응모가 불가능합니다.<br />("아니오" 선택시 추후 이벤트 응모 가능)', function(result) {
				if(result == 1) {
					localStorage.setItem('BNKEVENT', 'cancel');
					theApp.alert('이벤트에 참가되지 않았습니다.');
				} else {
					
				}
			}, '이벤트 알림', ['예','아니오']);
		}
	} else if(winId == 'MS000016')
	{
		if(result == 1) {
			localStorage.setItem('BNKEVENT', 'complete');
			theApp.alert('이벤트에 정상적으로 응모되었습니다.');
			
		} else if(result == 2) {
		
		} else {
			theApp.confirm('이벤트 응모를 취소하셨습니다. "예"를 선택한 경우 추후 이벤트 응모가 불가능합니다.<br />("아니오" 선택시 추후 이벤트 응모 가능)', function(result) {
				if(result == 1) {
					localStorage.setItem('BNKEVENT', 'cancel');
					theApp.alert('이벤트에 참가되지 않았습니다.');
				} else {
					
				}
			}, '이벤트 알림', ['예','아니오'])
		}
	} else if(winId == 'FD0000W08')
	{
		//펀드매수
		if(result == 1)
		{

			//TODO:edit here
			var thisObj = this;
			var objData = null;
			objData = {tabId:'FD3202_T02', tabSubId:'FD3202_V01', fundCode:'2000'};

			theApp.goPageCheck('FD3202', false, objData);
		}
		else if(result == 0)
		{
		
		}
	}
	
};

@function LoginManager:checkCDD()
{
	var thisObj=this;
	var win=null;
/*	win = AWindow.createWindow('MS/window/MS0604_W06.lay', 'MS060406');
	win.open(this, 0, 0, '100%', '100%');
*/	
	theApp.accNetManager.sendProcessByName('SAMFQ012', null, null, 

										   function(queryData)
										   {
										   this.addSkipErrorCode('SAMFQ012','9999');
										   
	},
										   //afterOutBlockData
										   function(queryData, groupName)
										   {
		if(queryData)
		{
//			queryData.printQueryData();
			var outBlockData = queryData.getBlockData('OutBlock1')[0];
			if(outBlockData['D1기본수행화면명'] == 'AM100101.dlp') {
				win = AWindow.createWindow('MS/window/MS0604_W06.lay', 'MS060406');
				win.open(this, 0, 0, '100%', '100%');
				AToast.show(outBlockData['D1팝업메시지']);
			} else {
			}
		}
		else 
		{
		}
	});
}

//HTS MTS 계좌 다를시 MTS 등록 윈도우 팝업
@function LoginManager:compareAcnt(accList){
	var accInfo = theApp.accInfo.filterAccList(0);
	var thisObj=this;
	if(accList.length < accInfo.length){
		var win = AWindow.createWindow('MS/window/MS0725_W01.lay', 'MS072501');
		win.openAsDialog(thisObj);
	}
}

@function LoginManager:sendSCMAQ048()
{
	var thisObj = this;
	
	theApp.accNetManager.sendProcessByName('SCMAQ048', null, null, 

										   function(queryData)
										   {
		var inBlockData = queryData.getBlockData('InBlock1')[0];
		inBlockData['D1일자공통그룹코드'] = '010';

	},

										   //afterOutBlockData
										   function(queryData, groupName)
										   {
		var errCode = this.getLastError('errCode');
		if(errCode > 1000) {
		
		} else	if(queryData) {

			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
			
			if(OutBlock1)
			{
				theApp.userInfo.set('BizDt',OutBlock1['D1주문일']);
			}
		}
	});
};

@function LoginManager:sendSACAT750(outBlock1, outBlock2)
{
	var thisObj = this;
	
	theApp.accNetManager.sendProcessByName('SACAT750', null, null, 

										   function(queryData)
										   {
		var date = new Date();								   

		var mm = date.getMonth() + 1; // getMonth() is zero-based
		var dd = date.getDate();

		var temp = [date.getFullYear(),
					(mm>9 ? '' : '0') + mm,
					(dd>9 ? '' : '0') + dd
				   ].join('');

		var hh = date.getHours();
		var mm = date.getMinutes();
		var ss = date.getSeconds();

		var temp2 = [(hh>9 ? '' : '0') + hh,
					(mm>9 ? '' : '0') + mm,
					(ss>9 ? '' : '0') + ss
				   ].join('');
				   
		var inBlockData = queryData.getBlockData('InBlock1')[0];
		inBlockData['D1계좌번호'] = thisObj.checkAcc;
		inBlockData['D1확인일'] = temp;
		inBlockData['D1확인시각'] = temp2;
		inBlockData['D1상품명'] = outBlock1['D1상품명'];
		inBlockData['D1연락처'] = outBlock1['D1문의연락처'];
		inBlockData['D1거래자우편번호'] = outBlock1['D1현재담보비율'];
		inBlockData['D1직장우편번호'] = outBlock1['D1기준담보비율'];
		
		if(outBlock1['D1임금영업일값'] == '+0') {
			inBlockData['D1요청일'] = outBlock2['D1출납일기준영업일'];
		} else if(outBlock1['D1임금영업일값'] == '+1') {
			inBlockData['D1요청일'] = outBlock2['D1출납일기준영업익일'];
		} else if(outBlock1['D1임금영업일값'] == '+2') {
			inBlockData['D1요청일'] = outBlock2['D1출납일기준영업익익일'];
		}
		inBlockData['D1요청시각'] = outBlock1['D1입금시간'];

		queryData.printQueryData();
	},

										   //afterOutBlockData
										   function(queryData, groupName)
										   {
		if(queryData)
		{
			queryData.printQueryData();

			var outBlockData = queryData.getBlockData('OutBlock1')[0];

			if(outBlockData['D1처리여부'] == '1') {

			} else {

			}
		}
		else 
		{
		}
	});
};