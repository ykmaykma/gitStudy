
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0005()
{
	@super();

	//TODO:edit here

}
@extends BasePage;


@function FD0005:onReady()
{
	@super.onReady();

	//TODO:edit here
	this.btnPensionFund = this.findCompById('btnBuyPensionFund');
	
	this.accView = this.findCompById('AccView').loadView;
	this.accView.setDelegator(this);
	this.onAccViewControl(this.accView);
	
	
};

@function FD0005:onActiveDone() {
	this.accView.doInitAccInfo(5);
	this.accDbx = this.accView.accDbx;
	var accLen = this.accDbx.items.length;
	theApp.pensionAccLen = accLen;
	theApp.pensionTotalAccLen = theApp.accInfo.filterAccList(0).length;
	PensionCommon.setFundAcc(this);
	
	if(accLen == 0) {
		this.fnNoDataSelectBox();
	}
	this.findCompById('lblDrawAccNm').setText(theApp.userInfo.userObj['D1사용자명']);
}

// 계좌 컨트롤 
@function FD0005:onAccViewControl(accView)
{
	// 계좌컨트롤 사이즈 조절 및 라벨 숨기기
	accView.title1.show(AComponent.GONE);
	accView.accDbx.setWidth('100%');
	accView.accDbx.addClass('combo2');
};

@function FD0005:fnNoDataSelectBox() {
	this.btnPensionFund.enable(false);
	this.goOpenAccount();
}

@function FD0005:fnDoSendDataManage() {
	this.accDbx = this.accView.accDbx;
	PensionCommon.setFundAcc(this);
	this.btnPensionFund.enable(true);
	this.sendSDPAQ070();
}

@function FD0005:goOpenAccount() {
	var param = {
		"title" : "연금저축계좌 개설",
		"contents" : "연금펀드 가입을 위해서는<br />별도의 연금저축계좌를<br />개설하셔야 합니다.",
		"btnText" : "개설하기",
		"returnType" : "1",
		"returnData" : ""
	};

	PensionCommon.oneBtnPopup(this, param);
}

@function FD0005:callbackPensionPopup(returnData, resultData) {
	theApp.goPageCheck('FD5001', false, {tabId:'FD5001_T01'});
}

@function FD0005:sendSDPAQ070() {
	var thisObj = this;
	var accNo = this.accDbx.getSelectedItemData()['D1계좌번호'];
	this.grid = this.findCompById("Grid1");
	
	if(!this.accDbx.getSelectedItemData() || !this.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		return;
	}

	this.sendData('SDPAQ070',
		function(queryData, groupName) {
			var InBlock1 = queryData.getBlockData('InBlock1')[0];
			InBlock1['D1계좌번호'] = accNo;
			InBlock1['D1금액'] = '0';
			InBlock1['D1세금징수구분'] = '';
			InBlock1['D1출금유형코드'] = '30';
			InBlock1['D1해지구분'] = '0';
		},
		function(queryData, groupName) {
			var errorData = this.getLastError();	

			if(!queryData) {
				return;
			}

			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
			var OutBlock2 = queryData.getBlockData('OutBlock2')[0];
			var OutBlock3 = queryData.getBlockData('OutBlock3')[0];
			var OutBlock4 = queryData.getBlockData('OutBlock4');

			if(afc.isSimulator)
			{
				queryData.printQueryData();
			}

			var data1 = OutBlock1['D1납입한도금액'];
			var data2 = thisObj.getData(OutBlock4);
			var data3 = OutBlock1['D1예수금'];
			var data4 = data1 - data2;
			
			thisObj.grid.setCellText(0, 1, afc.addComma(thisObj.chkData(data1)) + "원");	// 연간 납입한도
			thisObj.grid.setCellText(1, 1, afc.addComma(thisObj.chkData(data2)) + "원"); // 당해년도 기납입액
			thisObj.grid.setCellText(2, 1, afc.addComma(thisObj.chkData(data3)) + "원"); // 연금저축계좌 예수금
			thisObj.grid.setCellText(3, 1, afc.addComma(thisObj.chkData(data4)) + "원"); // 납입가능금액
		}
	);	
};

@function FD0005:chkData(amount) {
	if(amount == 1) {
		return 0;
	}
	else {
		return amount;
	}
}

@function FD0005:getData(OutBlock4) {
	if(OutBlock4 == null || OutBlock4.length < 1) {
		return 0;
	}

	var cYear = MetaInfo.fnGetToday().substring(0, 4);

	for(var i=0; i<OutBlock4.length; i++) {
		var pYear = OutBlock4[i]['D1납입년도'];
		
		if(cYear == pYear) {
			return OutBlock4[i]['D1납입금액'] -  OutBlock4[i]['D1과세제외금액출금'];
		}
	}
	
	return 0;
}
@function FD0005:onbtnBuyPensionFundClick(comp, info)
{
	//TODO:edit here
	
	var accList = theApp.accInfo.filterAccList(5)
	
	if(accList.length == 0){
		this.goOpenAccount()
		return;
	}
	theApp.goPageCheck('FD5003');
};



