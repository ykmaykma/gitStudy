
/**
Constructor
Do not call Function in Constructor.
*/
@class SystemInfo()
{
	this.fno = '951';			//증권사별 코드 "951":"메리츠자산운용"
	this.appId = '';			//네이티브 앱 ID ex) com.koscom.testapp
	this.appName = '';			//바탕화면 앱명칭
	this.appVer = '0.0';		//
	this.osType = '';			//네이티브 OS TYPE
	this.modelName = '';		//네이티브 모델명
	this.osVer = '';			//네이티브 OS버전
	this.verNo = 0;				//패치버전
	this.osGubun = 0;			//패치에 쓰일 OS구분(0:안드로이드,1:IOS,2:안드로이드태블릿, 3:IPAD)
	this.masterNo = 0;			//마스터 버전 정보
	
	this.data = 
	{
		//고객사+언론사 정보
		FirmName: { 
			"951":"메리츠자산운용"
		},
		//아이디 입력한값/소문자/대분자 구분여부('':입력한값그대로, 'lowercase':소문자, 'uppercase':대문자)
		FirmIdType: { 
			"951":'' // "951":'lowercase'
		},
		/*
		FirmIdMaxLength: {
			'072':8
		},
		*/
		//첫화면(TOT:종합화면, INT:관심종목, CUR)
		FirmFirstPage: { 
			"951": "TOT"
		},
		
		//공인인증 디폴트 타임아웃
		FirmCertTimeOut: { 
			"009":30, "013":30, "029":30, "072":180, "086":30
		},
		//차트 기타지표 셋팅
		FirmChartIndicator: { 
			"009":'', "013":'', "029":'', "072":'', "086":"주가이동평균;거래량;거래량이동평균"
		},
		
		//영업점 안내에 쓰이는 증권사별 로고 스타일
		FirmLogo: { 
			 "009": "LB_045_1"
			,"013": "LB_045_2"
			,"029": "LB_045_3"
			,"072": "LB_045_4"
			,"086": "LB_045_5"
		},
		
		//회원사 고객센터
		FirmCall: { 
			 "951": "1588-5533"
		},
		//회원사 홈페이지
		FirmUrl: { 
			 "009": "http://www.hygood.co.kr"
			,"013": "http://www.bookook.co.kr"
			,"029": "http://www.bridgefn.com"			
			,"072": "http://www.capefn.com"
			,"086": "http://www.bnkfn.co.kr"
		},		
		MediaName: {
			200: "서울경제", 210: "매일경제", 220: "한국경제", 230: "머니투데이", 240: "이데일리", 270: "아시아경제", 280: "전자신문",283: "한경TV", 284: "이투데이", 
			285: "연합뉴스", 290: "뉴스핌", 291: "조선경제", 295: "파이낸셜", 298: "인포스탁", 299: "이데일리FX", 300: "거래소공시", 320: "코스닥공시", 360: "K-OTC공시"
		},
		FirmMediaConfig: {
			//한양증권
			"009": {
				230: "머니투데이",
				283: "한경TV"
			},
			//부국증권
			"013": {
				230: "머니투데이",
				240: "이데일리",
				285: "연합뉴스",
				290: "뉴스핌",
				298: "인포스탁"
			},
			//CAPE투자증권   >> CAPE는 제공하는 뉴스가 없음  2017.04.18 황청유, 김혜영
			"072": {
				/*230: "머니투데이",
				240: "이데일리",
				285: "연합뉴스",
				210: "매일경제",
				298: "인포스탁",
				290: "뉴스핌"*/
			},
			//골든브릿지
			"029": {
				230: "머니투데이",
				240: "이데일리",
				295: "파이낸셜",
				290: "이투데이"
			},
			//BNK증권
			"086": {
				230: "머니투데이",
				240: "이데일리",
				295: "파이낸셜"
			}			
		},
		//증권사별 주식주문 신용유형(예약주문 포함) 2016.07.18. > 매수
		LenderClsInfo1: {
			"009": [
				["003", "자기융자"],
				["001", "유통융자"]
			],
			"013": [
				["001", "유통융자신규"],
				["105", "유통대주상환"]
			],
			"029": [
				["001", "유통융자"],
				["105", "유통대주상환"]
			],
			"072": [
				["001", "유통융자"]			//2017.05.22 자기융자 > 유통융자  CAPE 요청사항   황청유, 김용훈
			],
			"086": [
				["003", "자기융자"],
				["001", "유통융자"]
			]
		},
		//증권사별 주식주문 신용유형(예약주문 포함) 2016.07.18. > 매도
		LenderClsInfo2: {
			"009": [ 
				["101", "유통융자상환"],
				["103", "자기융자상환"],
				["180", "담보대출상환"]
			],
			"013": [
				["101", "유통융자상환"],
				["005", "유통대주신규"],
				["180", "예탁담보대출상환"]
			],
			"029": [
				["101", "유통융자상환"],
				["005", "유통대주"],
				["180", "담보대출상환"]
			],
			"072": [
				["101", "유통융자상환"],		//2017.05.22 유통융자 상환 추가 및 default 설정  CAPE 요청사항   황청유, 김용훈
				["103", "자기융자상환"],
				["180", "담보대출상환"]
			],
			"086": [
				["101", "유통융자상환"],
				["103", "자기융자상환"],
				["180", "담보대출상환"]
			]
		},
		//증권사별 예약주문 가능 시간 - 주식  2016.08.10. PB TR1299참조(본가동) 
		RegTime: {
			"009" : "13:00 ~ 다음영업일 07:10",
			"013" : "15:00 ~ 다음영업일 07:00",
			"029" : "13:00 ~ 다음영업일 07:10",
			"072" : "16:00 ~ 다음영업일 07:00",
			"086" : "13:00 ~ 다음영업일 07:10"
		},
		
		//증권사별 예약주문 가능 시간 - 선옵  2016.08.03. > 시간변경 2016.10.12. 황청유 (업무부 김진희과장 확인)
		RegTime_SO: {
			"009" : "15:45 ~ 다음영업일 07:50",
			"013" : "15:45 ~ 다음영업일 07:50",
			"029" : "15:45 ~ 다음영업일 07:50",
			"072" : "15:45 ~ 다음영업일 07:50",
			"086" : "17:00 ~ 다음영업일 07:50"
		}, 
		
		RegTime_Title: "※ 예약가능주문시간 : " ,
		
		//증권사별 제공안하는 종목 market list
		Non_Provide_MID: {
			"009" : []
			,"013" : []
			,"029" : []
			,"072" : ["EN", "118"]					//CAPE: ETN, 코넥스
			,"086" : []
		}
	};
}

@function SystemInfo:isTest()
{
  if (this.appId.slice(-2) == 'RT') 
  {
	  return 'RT';
  } else
  if (this.appId.slice(-1) == 'T') 
  {
  	return 'T';
  } else
  return '';

};

@function SystemInfo:loadInfo()//(callback)
{
	if(afc.isAndroid)
	{
		this.osType = 'Android';
		this.osVer = afc.strAndVer;
		
		if(Define.PRJ_TYPE == Define.MT) this.osGubun = 2;
		else this.osGubun = 0;
	}
	else if(afc.isIos)
	{
		this.osType = 'IOS';
		this.osVer = afc.strIosVer;
		if(Define.PRJ_TYPE == Define.MT) this.osGubun = 3;
		else this.osGubun = 1;
	}
	
	CallbackDone.begin();
	
	var thisObj = this;
	AppManager.getSystemInfo(function(result)
	{
		thisObj.fno = result[0];
		thisObj.appId = result[1];
		thisObj.modelName = result[2];
		thisObj.appVer = result[3];
		thisObj.appName = result[4];
		thisObj.verNo = result[5];
		thisObj.masterNo = result[6];
		
		//theApp.interestInfo.defData = thisObj.get('FirmInterest');
		
		theApp.menuInfo.setFNOList();	//회원사 별 메뉴세트 설정
		CallbackDone.end();
	});
	
};

@function SystemInfo:get(key)
{
	return this.data[key][this.fno];
};


//회원사 별 계좌번호 '-' 처리 함수 > afc.makeAccText로 사용
@function SystemInfo:makeAccNumber(accNumStr)
{
	accNumStr = accNumStr.replace(/-/gi,'');
	if(this.fno == '029')
	{
		if(accNumStr.length > 8) {
			return accNumStr.substring(0, 8) + "-" + accNumStr.substring(8, accNumStr.length);
		} else {
			return accNumStr;
		}
	}
	else
	{
		if(accNumStr.length > 3) {
			if(accNumStr.length > 5) {
				return accNumStr.substring(0, 3) + "-" + accNumStr.substring(3, 5) + "-" + accNumStr.substring(5, accNumStr.length);	
			} else {
				return accNumStr.substring(0, 3) + "-" + accNumStr.substring(3);
			}
		} else {
			return accNumStr;
		}
		
	}

};

@function SystemInfo:makeFirmUserId(strId)
{
	strId = strId.trim();
	var firmIdType = this.data['FirmIdType'][this.fno];
	if(firmIdType == 'uppercase') strId = strId.toUpperCase();
	else if(firmIdType == 'lowercase') strId = strId.toLowerCase();
	return strId;

};