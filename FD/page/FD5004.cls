
/**
Constructor
Do not call Function in Constructor.
** 펀드매도 **
*/
@class FD5004()
{
	@super();

	//TODO:edit here
	
	

}
@extends BasePage;

@function FD5004:onReady()
{
	@super.onReady();
	
	this.tabView = this.findCompById('TabView1');
	this.tvManager = this.makeTabViewManager(this.tabView, this);
	// 탭메뉴
	this.tvMenuMap = [
		['매도',	 'FD5004_T01'], 
		['매도완료','FD5004_T02']
	];
	this.lastTabId = 'FD5004_T01';	

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

@function FD5004:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	this.initByPageData()
};

@function FD5004:initByPageData()
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


@function FD5004:onBackBtnClick(comp, info)
{

	//TODO:edit here
	theApp.goPrevPageCheck(false);

};



// 현재 매매가능상태 코드값 분류
@function FD5004: nowTradeStateCheck(caller)
{
	var thisObj = this;
		
	var thisObj2 = caller		
		,callback = arguments[1];

	thisObj.bizNextDayCheck1(thisObj, function(){ // 영업일인지 아닌지 체크
		thisObj.nowTimeCheck(thisObj, function(){ // 현재 시간 체크
		
			if(thisObj.g_bizDateCheck == 0){ // 영업일이 아닌 경우
				if(thisObj.g_nowTime >= 230000 || thisObj.g_nowTime <= 080000){
					thisObj.g_tradeState = 3; // 펀드매수매도불가
				}else{
					thisObj.g_tradeState = 2; // 예약펀드매수매도
				}
			}else if(thisObj.g_bizDateCheck == 1){ // 영업일인 경우
				if(thisObj.g_nowTime > 230000 || thisObj.g_nowTime < 080000){
					thisObj.g_tradeState = 3; // 펀드매수매도불가
				}else if(thisObj.g_nowTime >= 080000 && thisObj.g_nowTime <= 170000){
					thisObj.g_tradeState = 1; // 일반펀드매수매도
				}if(thisObj.g_nowTime > 170000 && thisObj.g_nowTime <= 230000){
					thisObj.g_tradeState = 2; // 예약펀드매수매도
				}
			}			
		});
	});
	
	callback(); // 현재펀드매수매도 가능상태 체크한 후 콜백
};


// 당일일자 정보 조회 새로
@function FD5004: bizNextDayCheck1(caller)
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

// 서버시간 조회
@function FD5004:nowTimeCheck(caller)
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
		
	this.g_nowTime = nowHour.toString() + nowMin.toString() + nowSecond.toString();
				
	callback();

};


//당일일자정보조회
@function FD5004: bizNextDayCheck(caller)
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
			
			queryData.printQueryData();
			
		},
		function(queryData, groupName) {
			
			if(!queryData) return;
			
			queryData.printQueryData();
			
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


@function FD5004:changeTab()
{
	this.tvManager.changeTab("FD5004_T02", false);
};

