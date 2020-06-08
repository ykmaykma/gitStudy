
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1003()
{
	@super();

}
@extends BasePage;


@function MS1003:onReady()
{
	@super.onReady();

	this.mainView = this.findCompById('View7');
	this.midView = this.findCompById('MidView');
	this.midView.viewLoad('FD/view/MS1003_T02.lay');
	
	this.loadView = this.midView.getLoadView();
};

@function MS1003:onActive(reload)
{
	@super.onActive(reload);
	this.loadView.resetView();
	
	this.checkPageTabViewHeight();
};

@function MS1003:onDeactive()
{
	@super.onDeactive();
	
};


@function MS1003:onCancleBtnClick(comp, info)
{
	theApp.navigator.goPage('MS1002');
};


@function MS1003:onOkBtnClick(comp, info)
{
	var mView = this.midView.getLoadView();
	var thisObj = this;
	
	/*************************TEST용************************/
/*	theApp.navigator.goPage('MS1005', false, [ pageInx, theApp.getProductId()]); 
	return;*/
	/*******************************************************/
	
	if(mView.inputValidCheck() && mView.agreeValidCheck() )//if(mView.authNumberCheck() && mView.agreeValidCheck())
	{
		mView.confirmUser(function(success)
		{
			if(success)
			{
 				thisObj.check_sendSACMT469();
			}
			else 
			{
				AToast.show('휴대폰 본인 확인에 실패하였습니다');
			}
		});
	}
	
};


//고객 인증 정보 조회
@function MS1003:check_sendSACMT469(){
	var thisObj = this;
	var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");
	var pageInx = parseInt(theApp.userInfo.getUserData('D1처리상태코드'), 10);
	
	var mView = this.loadView;
	var carrier = mView.getTelDbx();
	
	
	QryRequest.request('SACMT469',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '0';
		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화'); //실명번호
		queryData.printQueryData();
		queryData.putPwInfo('InBlock1', 'D1고객번호', false, AQuery.RSA);
	},
					   function(queryData)
					   {
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			if(blockData['D1등록여부']=='1'){	//정보있는 회원일 경우
				if(pageInx=='7'||pageInx=='8'){
					thisObj.sendSACMQ241(pageInx);
				}
				else{
					theApp.ifContinued = true;	//이어하기여부 check > 계좌비밀번호 SEED/RSA 구분용
					theApp.navigator.goPage('MS1005', false, [ pageInx, theApp.getProductId()]);
				}
			}
			else if(blockData['D1등록여부']=='0'||blockData['D1등록여부']=='9'){	//정보없는 회원일 경우 0, 회원이 아닐경우 9
				if(pageInx=='2'){
					thisObj.sendSACMT469();
				}
			}
		}
	});	//SACMT469 전송시 펑션키 5 조회시 C
};

//실명확인번호 소유계좌현황
@function MS1003:sendSACMQ241(pageInx){
	var thisObj = this;
	
	QryRequest.request('SACMQ241',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1고객정보구분'] = '2';
		inBlock1['D1계좌상태코드'] = 'zz';
		inBlock1['D1지점번호'] = '000';
		inBlock1['D1고객확인번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');  //실명번호
		queryData.putPwInfo('InBlock1', 'D1고객확인번호', false, AQuery.RSA);
	},
	function(queryData)
	{
		if(queryData)
		{
			var blockData1 = queryData.getBlockData('OutBlock1')[0];
			var blockData2 = queryData.getBlockData('OutBlock2');
			var last = blockData2.length-1;
			theApp.userInfo.setUserData('D1종합계좌번호', blockData2[last]['D1계좌번호']);
			theApp.ifContinued = true;	//이어하기여부 check > 계좌비밀번호 SEED/RSA 구분용
			theApp.navigator.goPage('MS1005', false, [ pageInx, theApp.getProductId()]);
		}
	});	
};


//고객 인증 정보 등록
@function MS1003:sendSACMT469(){
	var thisObj = this;
	var mView = this.loadView;
	var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");
	
	var carrier = mView.getTelDbx();

	QryRequest.request('SACMT469',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '1';
		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');
		inBlock1['D1내외국인구분'] = '0'
		inBlock1['D1휴대폰번호'] = phoneNum;
		inBlock1['D1전화구분'] = carrier;
		queryData.printQueryData();
		queryData.putPwInfo('InBlock1', 'D1고객번호', false, AQuery.RSA);
	},
					   function(queryData)
					   {
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			if(blockData['D1등록여부']=='1'){
				var pageInx = parseInt(theApp.userInfo.getUserData('D1처리상태코드'), 10);
				theApp.ifContinued = true;	//이어하기여부 check > 계좌비밀번호 SEED/RSA 구분용
				theApp.navigator.goPage('MS1005', false, [ pageInx, theApp.getProductId()]);
			}
		}
	}, ''/*lazyfuntion*/, '5');	//SACMT469 전송시 펑션키 5 조회시 C
};

@function MS1003:checkPageTabViewHeight()
{
	this.mainView.setHeight(this.mainView.getHeight());
	this.mainView.updatePosition();
};
