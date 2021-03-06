
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0000_V01()
{
	@super();

	this.accDbx = null;
	this.secureTxf = null;
	this.delegator = null;
	this.accType = null;
	this.title1 = null;
	this.title2 = null;
}
@extends AView;


@function FD0000_V01:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.accDbx = this.findCompByGroup('AccGrp')[0];
	this.secureTxf = this.findCompByGroup('AccGrp')[1];
	this.title1 = this.findCompByGroup('LabelGrp')[0];
	this.title2 = this.findCompByGroup('LabelGrp')[1];
	this.delegator = this.getContainer();
};

@function FD0000_V01:setDelegator(delegator)
{
	this.delegator = delegator;
};

//계좌번호 설정
@function FD0000_V01:doInitAccInfo(gejoaInfo, isNoTrigger)
{

	var  accInfo = theApp.accInfo.filterAccList(gejoaInfo) // 전체계좌
		,accDbx = this.accDbx
		,text
		,acc
		,prevSelectedIdx = 0
		,selectedText = theApp.accInfo.getLastAcc(gejoaInfo);
	
	this.accType = gejoaInfo; //현재 선택 계좌 타입 저장
	
	accDbx.removeAll();
	
	//계좌가 없을 경우
	if(accInfo.length < 1)
	{
		this.secureTxf.enable(false);
		this.secureTxf.clear();
	}
	else
	{
	
		this.secureTxf.enable(true);
		
		//계좌등록
		for(var i=0; i<accInfo.length; i++)
		{
			acc = afc.makeAccText(accInfo[i]);
			text = [accInfo[i]['D1상품유형명'], ' ', acc, ' ', accInfo[i]['D1계좌명']].join('');
			accDbx.addItem(text, accInfo[i]);
		}
		
		if(selectedText)
		{
			var selectedIdx = accDbx.indexOfText(selectedText);
			if(selectedIdx > -1) prevSelectedIdx = selectedIdx;
		}
		
		//계좌선택
		accDbx.selectItem(prevSelectedIdx);
		
		//현재 계좌번호 선택 이벤트 발생
		this.isNoTrigger = isNoTrigger;
		this.onAccDbxSelect();
	}
	
};


@function FD0000_V01:onAccDbxSelect(comp, info)
{	
	var  accSelectText = this.accDbx.getSelectedItemText()
		,accSelectItem = this.accDbx.getSelectedItemData()
		,accNo = accSelectItem['D1계좌번호'] //계좌번호
		,secTxf = this.secureTxf	
		,appAccInfo = theApp.accInfo;
		
	
	//마지막 선택 계좌 저장
	appAccInfo.setLastAcc(this.accType, accSelectText);
	
	//비번삭제
	secTxf.clear();
	if(appAccInfo.getAccPw(accNo))
	{
		secTxf.setText(afc.makeDummyString(appAccInfo.getAccPwLength(accNo)));	//더미 텍스트 표시
		secTxf.setCipherData(appAccInfo.getAccPw(accNo));						//비번저장	
		secTxf.setPwLength(appAccInfo.getAccPwLength(accNo)); 					//비번길이 저장
		
	}
	
	//데이터 호출 sendDataManage
	if(!this.isNoTrigger && this.delegator.fnDoSendDataManage) this.delegator.fnDoSendDataManage();
	else this.isNoTrigger = false;
};

@function FD0000_V01:onSecureTxfChange(comp, info)
{
	var  thisObj = this		
		,accData = thisObj.accDbx.getSelectedItemData()	//계좌드롭
		,cipherData = thisObj.secureTxf.getCipherData()	//비번
		,pwLength = thisObj.secureTxf.getPwLength();	//비번길이

	var checkObj = 
	{ 
		svcId: 'SACMQ226',
		accNo: accData['D1계좌번호']
	};
	
	SecurePadManager.cipherToText(cipherData, checkObj, function(result)
	{
		thisObj.getContainer().sendData('SACMQ226',
		function(queryData, groupName)
		{
			var InBlock1 = queryData.getBlockData('InBlock1')[0];

			InBlock1['D1계좌번호'] = checkObj.accNo;
			InBlock1['D1계좌계층구분'] = accData['D1계좌계층구분'];
			InBlock1['D1입력비밀번호'] = afc.isSimulator ? '0423' : result;
			queryData.putPwInfo('InBlock1', 'D1입력비밀번호');
			
			queryData.printQueryData();
		},
		function(queryData, groupName)
		{
			if(!queryData)
			{
				AToast.show(this.getLastError('errMsg'));
				return;
			}
			
			queryData.printQueryData();
			
			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
			if(OutBlock1['D1유효여부'] == 'N')
			{
				thisObj.secureTxf.clear();
				var ableCount =  OutBlock1['D1적용횟수'] - OutBlock1['D1비밀번호연속오류횟수'];
				AToast.show(['비밀번호 오류입니다. (', OutBlock1['D1적용횟수'], '회중 ', ableCount, '회 남았습니다.'].join(''));
				return;
			}
			
			//환경설정에 비번저장일 경우 계좌비번 저장
			if(theApp.configInfo.get('PWSAVE_ONOFF') == 'ON'){
				theApp.accInfo.setAccPw(accData['D1계좌번호'], cipherData, pwLength);
			}
			
			//액티브뷰에 데이터 호출
			if(thisObj.delegator.fnDoSendDataManage) thisObj.delegator.fnDoSendDataManage();
			
		});
	
	});

};

@function FD0000_V01:doHideTitle()
{
	this.title1.show(AComponent.INVISIBLE);
	this.title2.show(AComponent.INVISIBLE);
	this.accDbx.setStyle('left', 0);
	this.secureTxf.setStyle('left', 0);
};
