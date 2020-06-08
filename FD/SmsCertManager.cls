/**
Constructor
Do not call Function in Constructor.
*/
@class SmsCertManager()
{
	this.CERT_TYPE_ENUM ={
		TYPE_A : 1,
		TYPE_B : 2,
		TYPE_C : 3
	};
	
	this.CERT_TYPE_NAME_ENUM ={
		TYPE_A : "SMSCERTA",
		TYPE_B : "SMSCERTB",
		TYPE_C : "SMSCERTC"
	};


	this.smsCertType = this.CERT_TYPE_ENUM.TYPE_B ; // Default 는 유형 B, 휴대폰 정보가 넘어오면 유형 A로 자동 변경
	
	this.smsCertManagercallback = null;  // 팝업이 종료되고 실행 될 callback 
	
	this.qryTp = '2';    // 조회 구분 0.실명확인번호 1.고객번호 2.계좌번호 <- 2020.03.12 정정: 0.고객번호 1.실명번호
	this.accNo = null; 
	this.phoneNo = null; 	// 전화번호
	this.phoneNoCode = null;  //통신사
	
	this.birthdayTxt= null; 
	
};

//20180830 sooylee - 미성년자 종합 계좌 번호 조회인 경우 처리 - 대리인 정보는 개별 계좌에만 존재 (callback, noAgntAlert)
/*
input 
	accNoIn  : 계좌번호 (STRING)
	isFullSMScert : 동의서가 필요한 A Type 을 호출 하는 경우 ture ( BOOL )
	phoneNoIn : 사용자 전화 번호, null이 아닌 유효한 값을 넘기는 경우 A Type 이 호출 됨
	callback (return, noAgnt) :  휴대폰 인증이 완료 된 후 호출 될 함수, 인자로 성공 여부가 BOOL 값으로 넘어옴 
								  미성년자이고, 대리인 정보가 없는 경우 noAgntAlert = true								  
	noAgntAlert : true - 미성년자이고, 대리인 정보가 없는 경우 Alert 을 띄우지 않고 Callback 으로 noAgnt(true) Flag 를 넘겨줌
				  (accNoIn 에 종합 계좌 번호가 들어오는 경우 - 대리인 정보는 개별 계좌에만 존재 ) 
*/

@function SmsCertManager: openSmsCertWindow(accNoIn, isFullSMScert, phoneNoIn, callback, noAgntAlert, qryTpIn)
{
	 
	var phoneNo, noCode , accNo; 
	
	if (qryTpIn) this.qryTp = qryTpIn; // 조회구분: 0.고객번호 1.실명번호 2.계좌번호
	
	if (accNoIn != null ) this.accNo = accNoIn ;	
	else 	
	{
		///TODO : 계좌 번호 공통 Component에서 채워 넣기 	
		afc.log("ERROR::SmsCertManager openSmsCertWindow : 계좌번호 전달 필요!!"); 
		callback(false);
		return;
	}
	
	
	//callback 세팅 
	if ( callback != null )
	{
		// 이전 callback 이 처리되지 않고 남아 있는 경우 
		if ( this.smsCertManagercallback != null)
		{	
			//this.smsCertManagercallback  ( false); 
			afc.log("ERROR:: SmsCertManager.openSmsCertWindow :이전 smsCertManagercallback이 남아있습니다.");
			
		}
		this.smsCertManagercallback = callback; 
	}
	

	
	
	// 강제로 유형 A 를 사용하는 경우 
	if ( isFullSMScert)
	{
		this.smsCertType = this.CERT_TYPE_ENUM.TYPE_A; 
	}

	// 휴대폰 번호를 전달하면 항상 유형 A Type 을 사용함 		
	if ( phoneNoIn != null && phoneNoIn.length >0 ) 
	{
		this.phoneNo =	phoneNoIn; 
		this.smsCertType = this.CERT_TYPE_ENUM.TYPE_A; 
	}
	
	//20180830 sooylee - 미성년자 종합 계좌 번호 조회인 경우 처리 - 대리인 정보는 개별 계좌에만 존재
	this.decideTypeAndOpenWindow(noAgntAlert);
	
	


};


@function SmsCertManager:CreateTypeAWindow ()
{

	var win = AWindow.createWindow('FD/window/FD0200_W01.lay',this.CERT_TYPE_NAME_ENUM.TYPE_A);
	
	
	win.setWindowOption({
							isAutoCenter: true,
							isFocusLostClose: false, 
							modalBgOption:'dark'
						});							
	
	return win; 
}


@function SmsCertManager:CreateTypeBWindow ()
{

	var win = AWindow.createWindow('FD/window/FD0200_W03.lay',this.CERT_TYPE_NAME_ENUM.TYPE_B);
	
	
	win.setWindowOption({
							isAutoCenter: true,
							isFocusLostClose: false, 
							modalBgOption:'dark'
						});	
		
	return win; 	
}

@function SmsCertManager:CreateTypeCWindow ()
{

	var win = AWindow.createWindow('FD/window/FD0200_W04.lay',this.CERT_TYPE_NAME_ENUM.TYPE_C);
	
	
	win.setWindowOption({
							isAutoCenter: true,
							isFocusLostClose: false, 
							modalBgOption:'dark'
						});							
	
	return win; 
}


@function SmsCertManager:decideTypeAndOpenWindow (noAgntAlert)
{


	var thisObj = this; 
	
		this.check_sendSACMT469( 
		function(blockData){ //등록이 되어 있는 경우 
			var win = null; 
			var savedPhoneNo =  blockData['D1휴대폰번호']; //blockData['D1이동전화식별번호'] + blockData['D1이동전화국번호']+ blockData['D1이동전화일련번호'];
			var savedNoCode = blockData['D1전화구분'];
			thisObj.birthdayTxt =  blockData ['D1생년월일'];
						
			
			// 본인 직접 인증 하는 케이스 (Type A, Type B)

				if ( thisObj.smsCertType == thisObj.CERT_TYPE_ENUM.TYPE_B) 
				{
					thisObj.phoneNo = savedPhoneNo;
					thisObj.phoneNoCode = savedNoCode; 
					win = thisObj.CreateTypeBWindow();
				}


				else if ( thisObj.smsCertType == thisObj.CERT_TYPE_ENUM.TYPE_A) 
				{
					// 화면에서 강제로 유형 A를 띄운 경우에는 휴대폰 정보는 사용자에게 입력 받음
					win = thisObj.CreateTypeAWindow();
				}					
						
			win.accNo = thisObj.accNo; 		
			win.phoneNo = thisObj.phoneNo; 
			win.phoneNoCode = thisObj.phoneNoCode; 
			win.birthdayTxt = thisObj.birthdayTxt ;
			
			// Window Open 
			if ( thisObj.smsCertType == thisObj.CERT_TYPE_ENUM.TYPE_B)
			{
				win.open(thisObj, 0, 0);	
			}
			else
				win.open(thisObj, 0, 0, '100%', theApp.appFullHeight);			

		},
		function(blockData) // 등록이 안 되어 있는 경우 
		{
		
						
			var nAgeAcntYn =   blockData ['D1미성년계좌여부'];
			var agntYn =   blockData ['D1대리인여부'];	
			
			if ( nAgeAcntYn == "1") //미성년자인 경우
			{
			
				if (agntYn == "1" ) //미성년자의 대리인으로 인증 하는 경우, C type 
				{									
					thisObj.smsCertType = thisObj.CERT_TYPE_ENUM.TYPE_C;
					
					
					thisObj.phoneNo = blockData['D1대리인핸드폰국번']+blockData['D1대리인핸드폰지역']+blockData['D1대리인핸드폰일련번호'];
					thisObj.phoneNoCode = null; 
					
					win = thisObj.CreateTypeCWindow();
					win.agntNm = blockData ['D1대리인명'];	
					win.phoneNo = thisObj.phoneNo; 		
					
				}
				else	// 미성년자 대리인이 없는경우 더이상 진행 불가
					{
					
						//20180830 sooylee - 미성년자 종합 계좌 번호 조회인 경우 처리 - 대리인 정보는 개별 계좌에만 존재
						if ( noAgntAlert ){
						
							thisObj.callSmsCertManagercallback(false, true);				
						}
						else
						{		
					
							theApp.alert("고객님은 대리인을 통해 계좌개설 하셨으나, 현재 대리인정보를 불러 올 수 없습니다 <b><ins><font color=red>1588-5533</font></ins></b> 으로 연락주시기 바랍니다", 
							function(result){
								thisObj.callSmsCertManagercallback(false);						
							}, 
							'알림');
						}
						return; 
					}
				
			}		
			else
			{
				// 본인 직접 인증 하는 케이스 (Type A)
				var win = thisObj.CreateTypeAWindow();
			}
			
			win.accNo = thisObj.accNo; 		
			win.phoneNo = thisObj.phoneNo; 			
			win.open(thisObj, 0, 0, '100%', theApp.appFullHeight);			
		});
}




//고객 인증 정보 조회
@function SmsCertManager:check_sendSACMT469(registeredCallback, unreigsteredCallback){

	var thisObj = this;
	//var mView = this.loadView;
	//var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");

	//var carrier = mView.getTelDbx();

	theApp.accNetManager.sendProcessByName('SACMT469',null, null,
					   function(queryData)
					   {
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '0'; //조회
		inBlock1['D1조회구분'] = thisObj.qryTp;  //계좌번호 기준 조회
		inBlock1['D1고객번호'] =  thisObj.accNo; //계좌번호 		
		
		//if(thisObj.qryTp == '1') queryData.putPwInfo('InBlock1', 'D1고객번호');
		
		queryData.printQueryData();
		
	},
	function(queryData)
	{
		AppManager.endOltp();
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
	if(blockData['D1등록여부']=='0'||blockData['D1등록여부']=='9'){	//고객이고 정보없을경우 0, 고객아닌경우 9
				//thisObj.sendSACMT469();				
				unreigsteredCallback(blockData); 
				
			}
			else{//고객이고 정보있을경우 1					
				registeredCallback(blockData);
				//thisObj.correct_sendSACMT469();
			}
		}
		else
		{
				afc.log("ERR::SmsCertManager check_sendSACMT469 : 고객 인증 정보 조회 오류"); 
				thisObj.callSmsCertManagercallback(0);
		}
	});	//SACMT469 전송시 펑션키 5 조회시 C
};

//고객 인증 정보 등록
@function SmsCertManager:sendSACMT469(phoneNo,phoneNoCode ){
	var thisObj = this;

	
	theApp.accNetManager.sendProcessByName('SACMT469',null, null,	
	function(queryData)
	{
		queryData.setHeaderInfo({FUNC_KEY_LST: '5'}); //SACMT469 전송시 펑션키 5 조회시 C
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '1';
/*		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');*/
		
		inBlock1['D1조회구분'] = thisObj.qryTp;  //계좌번호 기준 조회
		inBlock1['D1고객번호'] =  thisObj.accNo; //계좌번호 
		
		inBlock1['D1내외국인구분'] = '0'
		inBlock1['D1휴대폰번호'] = phoneNo;
		inBlock1['D1전화구분'] = phoneNoCode;
		
		queryData.printQueryData();		
	},
	function(queryData)
	{
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			if(blockData['D1등록여부']=='1'){
				thisObj.callSmsCertManagercallback(1);		
			}
			else
			{
				afc.log("ERR::SmsCertManager sendSACMT469 : 고객 인증 정보 등록 - 등록여부 == 0 "); 
				thisObj.callSmsCertManagercallback(0);	
			}
		}
		else
		{
			afc.log("ERR::SmsCertManager sendSACMT469 : 고객 인증 정보 등록 오류"); 
			thisObj.callSmsCertManagercallback(0);	
		}
	});	
};

//고객 인증 정보 정정
@function SmsCertManager:correct_sendSACMT469(phoneNo,phoneNoCode ){
	var thisObj = this;
	var mView = this.loadView;


	
	theApp.accNetManager.sendProcessByName('SACMT469',null, null,
	function(queryData)
	{
		queryData.setHeaderInfo({FUNC_KEY_LST: '5'}); //SACMT469 전송시 펑션키 5 조회시 C
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '2';
			
		inBlock1['D1조회구분'] = thisObj.qryTp;  //계좌번호 기준 조회
		inBlock1['D1고객번호'] =  thisObj.accNo; //계좌번호로 대체 //theApp.userInfo.getUserData('D1실명확인번호암호화');
		inBlock1['D1내외국인구분'] = '0'
		inBlock1['D1휴대폰번호'] = phoneNo;
		inBlock1['D1전화구분'] =  phoneNoCode;
		queryData.printQueryData();
		
	},
		function(queryData)
		{
		if(queryData)
		{			
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			thisObj.callSmsCertManagercallback(1);		
		}
		else
		{
			afc.log("ERR::SmsCertManager correct_sendSACMT469 : 고객 인증 정보 정정 오류"); 
			thisObj.callSmsCertManagercallback(0);		
		}
	});	//SACMT469 전송시 펑션키 5 조회시 C
};





@function SmsCertManager: onWindowResult(result, windowObj)
{

	var thisObj = this; 
	var winId = windowObj.getId();
	

	if(winId == this.CERT_TYPE_NAME_ENUM.TYPE_A) // 유형 A 
	{
	
				
		if(result) {
			
			//	등록 여부 확인
				thisObj.check_sendSACMT469(
				
				function (blockData) {		// 이미 등록 된 경우 		
				
				
				//정정 - ( 유형 A 로 호출한 경우에만 정정)											
				thisObj.correct_sendSACMT469(windowObj.phoneNo,windowObj.phoneNoCode );	
				
				},
				function(blockData) { 		// 처음 등록 
				//등록 
					thisObj.sendSACMT469(windowObj.phoneNo,windowObj.phoneNoCode);
				});
			}
			else
			{
				thisObj.callSmsCertManagercallback(result);	
			}
	}
	else if (winId == this.CERT_TYPE_NAME_ENUM.TYPE_B||winId == this.CERT_TYPE_NAME_ENUM.TYPE_C) // 유형 B 또는 C 
	{
	
		thisObj.callSmsCertManagercallback(result);		
	}

};

//20180830 sooylee - 미성년자 종합 계좌 번호 조회인 경우 처리 - 대리인 정보는 개별 계좌에만 존재
//	callback (return, noAgnt) :  휴대폰 인증이 완료 된 후 호출 될 함수, 인자로 성공 여부가 BOOL 값으로 넘어옴 
//								  미성년자이고, 대리인 정보가 없는 경우 noAgntAlert = true	
@function SmsCertManager:callSmsCertManagercallback(result, noAgnt)
{


	if ( this.smsCertManagercallback != null)
		{
			this.smsCertManagercallback(result, noAgnt);
			this.smsCertManagercallback = null; 
			
			this.smsCertType = this.CERT_TYPE_ENUM.TYPE_B ; // Default 는 유형 B, 휴대폰 정보가 넘어오면 유형 A로 자동 변경

		}
	
	this.accNo = null; 
	this.phoneNo = null; 	// 전화번호
	this.phoneNoCode = null;  //통신사	
	this.birthdayTxt= null; 
}

