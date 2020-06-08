
/**
Constructor
Do not call Function in Constructor.
** 펀드매도 **
*/
@class FD3203()
{
	@super();

	//TODO:edit here
	
	this.g_nowTime = null; 				// 현재시간 조회 체크	
	this.g_bizDateCheck = null;			// 영업일인지 아닌지 체크 0:영업일아님,1:영업일
	
	this.g_tradeState = null;			// 현재 매매가능상태 1:일반펀드매수매도, 2: 예약펀드매수매도, 3:펀드매수불가

}
@extends BasePage;

@function FD3203:onReady()
{
	@super.onReady();
	
	this.listView1 = this.findCompById('ListView1');
	
	this.listView1.setDelegator(this);
			
	//계좌번호 비밀번호 로드뷰	
	this.accView = this.findCompById('AccView');
	this.accView.viewLoad('FD/view/FD0000_V00.lay');

	//계좌드롭박스
	this.accDbx = this.accView.getLoadView().accDbx;
	this.secureTxf = this.accView.getLoadView().secureTxf;
	
	this.nodata = this.findCompById('Nodata');
	this.nodataLbl = this.findCompById("NodataLbl");
	this.view4 = this.findCompById('View4');	
			
	//잔고가 있는 펀드계좌 배열조회
	this.arrFundSellInfo = [];
	
	//선택되는 펀드정보
	this.fundSellInfo = null;
};

@function FD3203:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD3203:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	var thisObj = this;
	
	
	thisObj.contiKey = null; // 연속키 초기화
			
/*	thisObj.nowTradeStateCheck(thisObj, function(){
	
		// 일반펀드매수, 예약펀드매수 모두 불가상태
		if(thisObj.g_tradeState == 3){
			theApp.alert(
				[	 
					'펀드매매가능시간이 아닙니다.'					
					,' '
				].join('')
				,
				function()
				{			
					thisObj.fundTradePopoup();
				}
				,''
			);
		}else if(thisObj.g_tradeState == 1 || thisObj.g_tradeState == 2){ // 일반펀드매수 또는 예약펀드매수 가능*/
			thisObj.fundSellInfo = null;
			thisObj.listView1.removeAllItems();
			
			// 계좌세팅(투신상품만 조회)	
			thisObj.accView.getLoadView().doInitAccInfo(4);
/*		}
	});*/
};

@function FD3203:fundTradePopoup()
{
	theApp.goPrevPageCheck(false);
};

// 당일일자 정보 조회 새로
@function FD3203: bizNextDayCheck1(caller)
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
@function FD3203: nowTradeStateCheck(caller)
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

@function FD3203:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD3203:refreshData() ');
};

// 서버시간 조회
@function FD3203:nowTimeCheck(caller)
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


@function FD3203:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

@function FD3203:fnDoSendDataManage()
{
	
	// 다시 조회할 때 리스트 아이템 제거
	this.listView1.removeAllItems();
	
	// 하단 이미지 변경
	this.nodata.show(AComponent.VISIBLE);
	
	// 시뮬레이터가 아니면서 계좌비밀번호가 있어야만 아래의 함수를 실행
	if(!afc.isSimulator){
		if(this.secureTxf.getCipherData()){
			this.secureTxf.removeClass('active');
			this.sendDataFundCheck();
		}else{
			this.nodataLbl.setText("계좌비밀번호를 입력해주세요.");
			AToast.show("계좌비밀번호를 입력하세요");
			this.secureTxf.addClass('active');
		}
	}else{
		this.sendDataFundCheck();
	}
}

@function FD3203:sendDataFundCheck()
{
	var thisObj = this		
		,qrName = "SOFFQ365"
		,cipherData = thisObj.secureTxf.getCipherData();		
		
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		return;
	}
	
	if(!afc.isSimulator)
	{
		if(!cipherData)
		{
			AToast.show('계좌 비밀번호를 입력하세요.');
			return;
		}
	}
	
	if(!thisObj.contiKey)
	{
		// 연속키 없으면 ListView 조회전 클리어		
		thisObj.listView1.removeAllItems();
	}
		
	var checkObj = {
		svcId : qrName,
		accNo : thisObj.accDbx.getSelectedItemData()['D1계좌번호']
	};
	
	SecurePadManager.cipherToText(cipherData, checkObj, function(result){
		thisObj.sendData(qrName, 
			function(queryData, groupName)
			{
				var InBlock1 = queryData.getBlockData('InBlock1')[0];
										
				InBlock1['D1계좌번호'] = checkObj.accNo;
				InBlock1['D1비밀번호'] = afc.isSimulator ? '0423' : result;
				InBlock1['D1잔고유무여부'] = '1'; // 1:잔고가 있는것만 조회, 공백:가입된 펀드 모두 조회
				
				queryData.printQueryData();
				
				if(thisObj.contiKey){
					queryData.setContiKey(thisObj.contiKey);	
				}
				
			},
			function(queryData, groupName)
			{				
				var errMsg = this.getLastError('errMsg');
				var errCode = this.getLastError('errCode');
						
				if(queryData)
				{								
					var OutBlock2 = queryData.getBlockData('OutBlock2');

					queryData.printQueryData();					
					
					if(OutBlock2.length == 0){
						thisObj.nodataLbl.setText("조회 내역이 없습니다.");
						thisObj.nodata.show(AComponent.VISIBLE);
					}
					else{
						thisObj.nodata.show(AComponent.GONE);
						
						for(var i=0; i < OutBlock2.length; i++){
							thisObj.arrFundSellInfo[i] = OutBlock2[i];							
						}

						thisObj.listViewPrint();
					}
					
					thisObj.contiKey = queryData.getContiKey();					
				}else{
					thisObj.contiKey = null;
				}
			}
		);
	});
};

//당일일자정보조회
@function FD3203: bizNextDayCheck(caller)
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

@function FD3203:listViewPrint()
{
	for(var i=0; i<this.arrFundSellInfo.length; i++){		
		this.listView1.addItem('FD/view/FD3203_L01.lay', [{"a1":this.arrFundSellInfo[i]['D1계좌일련번호'], "a2":this.arrFundSellInfo[i]['D1납입방법명'], "a3":this.arrFundSellInfo[i]['D1펀드명'], "a4":this.arrFundSellInfo[i], "a5":this.secureTxf.getCipherData()}]);
	}	
};

// 펀드매도정보 데이터 출력
@function FD3203:bindData(item, data, listview){	
	if(item.view.setData){
		item.view.setData(data);
	}
};


