/* 연금펀드 공통 함수 */

var PensionCommon = {};
@class PensionCommon()
{
	this.pNumber = null; //실명확인번호
	this.limitPay = null;//한도잔여금액
	this.totalPay = null;//총가입금액
	this.name = null; //고객명
	this.context = null;//호출한 화면 정보
	this.contiKey = null;
	this.lastNo = '0000';//최종전문번호
}

/*
	< 팝업의 리턴타입 >
	"0" : 일반 경고창과 같다.
	"1" : 버튼을 눌렀을 때만 콜백함수를 실행한다...(버튼이 두개일 때는 '예'일 때만...)
	"2" : 무조건 콜백함수를 실행한다...
*/

// 연금펀드 메인화면으로 이동할지 물어보는 팝업...

//close : 0 , ok :1
PensionCommon.moveToPensionMainPopup = function(upperObj) {
	var param = {
		"title" : "메리츠연금펀드",
		"contents" : "[메리츠연금펀드]로<br />이동하시겠습니까?",
		"btnText" : "네",
		"returnType" : "1",
		"returnData" : ""
	};

	this.oneBtnPopup(upperObj, param);
}

// 버튼이 하나인 alert 윈도우...
PensionCommon.oneBtnPopup = function(upperObj, paramData) {
	var thisObj = this;
	
	theApp.alert(
		paramData.contents,
		function winResult(resultData) {
			this.close();
			thisObj.beforeCallback(upperObj, paramData, resultData);
		},
		paramData.title,
		[paramData.btnText]
	);
}

// 콜백 실행 전에 리턴 타입에 따라 분기...
PensionCommon.beforeCallback = function(upperObj, paramData, resultData) {
	var returnType = paramData.returnType;
	var returnData = paramData.returnData;
	
	if(returnType == "1") {	// 버튼을 눌렀을 때만 콜백함수 실행...
		if(resultData) {
			upperObj.callbackPensionPopup(returnData, resultData);
		}
	}
	else if(returnType == "2") {	// 버튼 또는 우측상단의 'X'를 누르면 무조건 콜백함수 실행...
		upperObj.callbackPensionPopup(returnData, resultData);
	}
}

/*
	var param = {
		"title" : "로그아웃",
		"contents" : "<span>로그아웃 하시겠습니까?</span>",
		"btnArray" : ['예', '아니오'], // 순서에 주의...
		"returnType" : "1",
		"returnData" : "two"
	};

	PensionCommon.twoBtnPopup(this, param);
*/

// 버튼이 두개인 alert 윈도우...
PensionCommon.twoBtnPopup = function(upperObj, paramData) {
	var thisObj = this;

	theApp.confirm(
		paramData.contents,
		function winResult(resultData) {
			this.close();
			thisObj.beforeCallback(upperObj, paramData, resultData);
		},
		paramData.title,
		paramData.btnArray
	);
}

// 전체 화면 팝업...
/*
	< 팝업의 버튼타입 >
	"0" : 버튼이 없는 팝업
	"1" : 버튼이 있는 팝업
*/
PensionCommon.fullSizePopup = function(obj, param) {
	var win;
	
	
	if(param.btnType == "0") {
		win = AWindow.createWindow('FD/window/FD5001_W05.lay', 'FD5001W05');
		win.cType = param.checkType;
		
	}
	else {
		win = AWindow.createWindow('FD/window/FD5002_W02.lay', 'FD5002W02');
	}

	win.loadViewUrlAddr = param.viewUrl;
	win.loadTitle = param.title;
	
	win.openAsDialog(obj, '100%', '100%');
}

/* 2020.04.16 추가
	기존에 웹뷰로 html 링크를 사용하던 로직을 pdf 링크로 변경
	대상 : 펀드의 집합투자규약, 투자설명서, 간이투자설명서
*/
PensionCommon.fullSizePdfPopup = function(obj, param) {		
	if(afc.isIos)
	{
		var win;
	
		if(param.btnType == "0")
		{
			win = AWindow.createWindow('FD/window/FD5001_W05.lay', 'FD5001W05');
			win.cType = param.checkType;
		}
		else
		{
			win = AWindow.createWindow('FD/window/FD5002_W02.lay', 'FD5002W02');
		}

		win.loadViewUrlAddr = param.viewPdfUrl;
		win.loadTitle = param.title;

		win.openAsDialog(obj, '100%', '100%');
	}
	else		// Android
	{
		AppManager.openPdfModule(param.viewPdfUrl, param.title);
	}
}


// 납입금액 초과한 경우 팝업을 띄우기 위해 실명확인번호를 먼저 조회함...
PensionCommon.checkLimitPaymentAmount = function(upperObj) {
	var thisObj = this;
	var svcId = 'SBPGQ193';
	var TrxTp = '3';
	var cont = upperObj.getContainer();
	var UserId = theApp.accNetManager.getHeaderInfo('USER_ID');

	// 먼저 실명확인번호 조회...
	cont.sendData(svcId,
	function(queryData, groupName)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		
		inBlock1['D1처리구분'] = TrxTp;
		inBlock1['D1사용자ID'] = UserId;
		
		// Function key 세팅.
		queryData.setHeaderInfo(
			{FUNC_KEY_LST: 'C'}	// 조회.
		);
	},
	function(queryData, groupName)
	{
		var errorData = this.getLastError();
		
		//afc.log("errorCode : " + errorData.errCode);
		//afc.log("errMsg : " + errorData.errMsg);
		
		if(queryData) {
			queryData.printQueryData();				
			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
			
			//afc.log("D1실명확인번호 : " + OutBlock1['D1실명확인번호']);
			
			thisObj.pNumber =  OutBlock1['D1실명확인번호'];
			thisObj.name =  OutBlock1['D1고객명'];
			
			var param = {
				"Rmnno" : thisObj.pNumber,
				"Nm" : thisObj.name
			};
			thisObj.checkLimitPaymentAmountPopup(upperObj, param);
		}
	});
}

// 납입금액 초과한 경우 팝업
PensionCommon.checkLimitPaymentAmountPopup = function(upperObj,paramData) { //SACMT194
	var thisObj = this;
	var svcId = 'SACMT194';
	var KfbPrdtCode = '36';
	var RmnCnfTp = '1'; // 내국인 : 1, 기업 : 2, 외국인 : 7
	var cont = upperObj.getContainer();
	
	theApp.accNetManager.addQueryListener(this);
	cont.sendData(svcId,
	function(queryData, groupName)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		
 		inBlock1['D1실명확인번호'] = paramData.Rmnno;
// 		inBlock1['D1실명확인번호'] = '8507301000007';
		inBlock1['D1실명확인구분'] = RmnCnfTp;
		inBlock1['D1은행연합회상품코드'] = KfbPrdtCode;
		
		// Function key 세팅.
		queryData.setHeaderInfo(
			{FUNC_KEY_LST: 'C'}	// 조회.
		);
	},
	function(queryData, groupName)
	{
		var errorData = this.getLastError();
		
		afc.log("errorCode : " + errorData.errCode);
		afc.log("errMsg : " + errorData.errMsg);
		
		if(queryData) {
			queryData.printQueryData();				
			
			
		}
	});
};

//개인 은행 정보 
PensionCommon.SendData_SACMT192 = function(upperObj) 
{
	var thisObj = this;
	var cont = upperObj.opener.getContainer();
	var svcId = 'SACMT192';
	this.context = upperObj;
	

	theApp.accNetManager.addQueryListener(this);
	cont.sendData(svcId,
	function(queryData, groupName)
	{
		
		queryData.setContiKey(thisObj.contiKey);	
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		
// 		inBlock1['D1실명확인번호'] = '8507301000007';
 		inBlock1['D1실명확인번호'] = thisObj.pNumber;
		inBlock1['D1최종전문번호'] = thisObj.lastNo;
		
		// Function key 세팅.
		queryData.setHeaderInfo(
			{FUNC_KEY_LST: 'C'}	// 조회.
		);	
	},
	function(queryData, groupName)
	{
		var errorData = this.getLastError();
		
		afc.log("errorCode : " + errorData.errCode);
		afc.log("errMsg : " + errorData.errMsg);
		
		if(queryData) {
		
			queryData.printQueryData();
			
			
		}
	});
};

//쿼리를 바로 실행하면 받아오지 못함 -> 은행연합회에서 받아오는 은행 정보 받아오는 쿼리
PensionCommon.afterOutBlockData  = function(queryData, groupName, trName, manager) 
{ 

	var packetType = manager.rcvBuf.getByte(OS_CH_TG_TP);
	var thisObj = this;
	//계정계 지연처리 TR응답
	if(packetType==PACKET_TYPE.E){
		if(trName=='SACMT192'){ 
			
			var errCode = manager.errorData.errCode;
			//비정상(오류)
			if(errCode>=1000){
				//AToast.show('오류발생('+errCode+') : '+manager.errorData.errMsg);
			} else if(queryData) {

				queryData.printQueryData();
				thisObj.contiKey = queryData.getContiKey();
				var InBlock1 = queryData.getBlockData('InBlock1')[0];				
				thisObj.lastNo = InBlock1['D1최종전문번호'];
				var OutBlock2 = queryData.getBlockData('OutBlock2');
				if(thisObj.contiKey){ 
					theApp.accNetManager.removeQueryListener(this);
				}
				
				// 연금저축계좌 한도조회 FD5005_W04
				this.context.callback192Data(OutBlock2);

			}
		}

		if(trName=='SACMT194'){
			var errCode = manager.errorData.errCode;
			//비정상(오류)
			if(errCode>=1000){
				//AToast.show('오류발생('+errCode+') : '+manager.errorData.errMsg);
			} 

			else if(queryData) {
				//queryData.printQueryData();
				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				thisObj.limitPay = OutBlock1['D1한도잔여금액'];
				thisObj.totalPay = OutBlock1['D1세금우대가입금액']
				theApp.accNetManager.removeQueryListener(this);

			}
		}
	}
};


PensionCommon.addAccBar  = function(account){ //계좌 '-' 넣기
	var resultAcc = account.substring(0, 3) + "-" + account.substring(3, 5) + "-" + account.substring(5, account.length);
	return resultAcc;
}

PensionCommon.removeAccBar  = function(account){ //계좌 '-' 없애기
	var resultAcc = account.replace(/-/gi,'');
	return resultAcc;
}

//입금 화면 납입 한도 금액 계산
PensionCommon.sendSDPAQ070 = function(upperObj,SDPAQ070ContiKey) 
{
	
	var thisObj = this,	
		qrName = "SDPAQ070",
		cont = upperObj;
		
	
	var checkObj = {
		svcId : qrName,
		accNo : theApp.fundAcc 
	};
	
	

	cont.sendData(qrName, 
		function(queryData, groupName)
		{
		
			queryData.setContiKey(SDPAQ070ContiKey);
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			InBlock1['D1계좌번호'] = checkObj.accNo
			InBlock1['D1비밀번호'] = '';
			
			queryData.printQueryData();

		},
		function(queryData, groupName)
		{				
			if(queryData)
			{	
				var now = new Date();
				var year = now.format('yyyy');
				SDPAQ070ContiKey = queryData.getContiKey();
				queryData.printQueryData();
				var outBlock1 = queryData.getBlockData('OutBlock1')[0];
				var outBlock2 = queryData.getBlockData('OutBlock4');

				if(outBlock2.length > 0 ){
					for(var i =0 ; i<outBlock2.length;i++){
						if(outBlock2[i]['D1납입년도'] == year){
							var money = outBlock1['D1납입한도금액']*1-outBlock2[i]['D1납입금액']*1 + outBlock2[i]['D1과세제외금액출금']*1;
							upperObj.callback070Data(money);
							return;
							
						}
					}
				}else{
					var money = outBlock1['D1납입한도금액'];
					upperObj.callback070Data(money);
					return;
				}

				if(SDPAQ070ContiKey != null){
					thisObj.sendSDPAQ070(upperObj,SDPAQ070ContiKey);
				} else{
					var money = outBlock1['D1납입한도금액'];
					upperObj.callback070Data(money);
					return;
				}
			}
		});
	
};



// 2차 개발예정인 메뉴에 대해 안내 팝업...
PensionCommon.comingSoonPopup = function(upperObj) {
	var contents = "이용에 불편을 드려 죄송합니다.<br />" +
	               "해당서비스는 추후 제공 예정으로,<br />" +
				   "고객센터(1588-5533)에서<br />" +
				   "업무지원이 가능하오니<br />" +
				   "문의해주시기 바랍니다.<br />" +
				   "감사합니다.";
	var param = {
		"title" : "안내",
		"contents" : contents,
		"btnText" : "확인",
		"returnType" : "0",
		"returnData" : ""
	};

	this.oneBtnPopup(upperObj, param);
}


// 계좌번호 저장
PensionCommon.setFundAcc = function(obj) {
	if(!obj.accDbx.getSelectedItemData() || !obj.accDbx.getSelectedItemData()['D1계좌번호'])
	{
		return;
	}
	
	theApp.fundAcc = obj.accDbx.getSelectedItemData()['D1계좌번호'];
}



