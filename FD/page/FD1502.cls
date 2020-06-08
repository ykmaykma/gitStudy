
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1502()
{
	@super();

	//TODO:edit here
	this.accDbx = null;
	this.secureTxf = null;
	this.accView = null;
	this.pickDate = null;
	this.toDay = null;
	this.eYYYYMMDD = null;
	this.sYYYYMMDD = null;
	this.qryDate3 = null;
	this.qryDate12 = null;
	this.picker = null;
	this.lblDate = null;
	this.lblInvDate = null;
	this.lblTrdDate = null;
	this.lblInfoDate = null;
	
	this.invGridBase = null;
	this.invGrid = null;
	this.nodata1 = null;

	this.trdGridBase = null;
	this.trdGrid = null;
	this.nodata2 = null;

	this.infoGridBase = null;
	this.infoGrid = null;
	this.nodata3 = null;

	this.contiKey1 = null;
	this.contiKey2 = null;
	this.contiKey3 = null;
	
}
@extends BasePage;


@function FD1502:onReady()
{
	@super.onReady();

	var thisObj =this;
	//TODO:edit here
			
	//계좌번호 비밀번호 로드뷰	
	thisObj.accView = thisObj.findCompById('AccView');
	thisObj.accView.viewLoad('FD/view/FD0000_V00.lay');

	//계좌드롭박스
	thisObj.accDbx = thisObj.accView.getLoadView().accDbx;
	thisObj.secureTxf = thisObj.accView.getLoadView().secureTxf;
	thisObj.picker = thisObj.findCompById('DatePicker1');	
	thisObj.lblDate = thisObj.findCompById('lblDate');	
	
	thisObj.ContentView = this.findCompById('View2');
	
	//잔고평가
	thisObj.evalGrid = thisObj.findCompById('evalGrid');	
	
	//예수금현황
	thisObj.dpsGrid = thisObj.findCompById('dpsGrid');	
	
	//투자중인펀드
	thisObj.lblInvDate = thisObj.findCompById('lblInvDate');	
	thisObj.invGridBase = thisObj.findCompById('invGridBase');	
	thisObj.invGrid = thisObj.findCompById('invGrid');	
	thisObj.invGridBase.setMaskInfo([Utils.makeSubAcc]);
	/*thisObj.invGrid.setMaskInfo([ 	0, 				
									afc.addComma, afc.addComma, afc.addComma, afc.plusfloorPercent,
							  		0,		afc.intComma, 	afc.intComma,	afc.intComma,
									afc.floor2, afc.floor2, afc.floor2, afc.floor2] );*/  // 연말작업시 활용
	thisObj.invGrid.setMaskInfo([ 	0, 				
									afc.addComma, 0, 0, 0,
							  		0,		afc.intComma, 	0,	0,
									afc.floor2, 0, 0, 0] );  // 연말작업시 삭제
	thisObj.nodata1 = this.findCompById('Nodata1');
	thisObj.nodata1.show(AComponent.VISIBLE);
							  
	//투자중인거래내역
	thisObj.lblTrdDate = thisObj.findCompById('lblTrdDate');	
	thisObj.trdGridBase = thisObj.findCompById('trdGridBase');	
	thisObj.trdGrid = thisObj.findCompById('trdGrid');	
	
	thisObj.trdGridBase.setMaskInfo([afc.formatDate,	0]);
	thisObj.trdGrid.setMaskInfo([	0,				afc.addComma, 	afc.addComma,
							  		afc.floor2, 	afc.intComma, 	afc.addComma, 	afc.addComma] );
	thisObj.nodata2 = this.findCompById('Nodata2');
	thisObj.nodata2.show(AComponent.VISIBLE);
							  
	//펀드정보
	thisObj.lblInfoDate = thisObj.findCompById('lblInfoDate');	
	thisObj.infoGridBase = thisObj.findCompById('infoGridBase');	
	thisObj.infoGrid = thisObj.findCompById('infoGrid');	
	thisObj.infoGridBase.setMaskInfo([Utils.makeSubAcc]);
	thisObj.infoGrid.setMaskInfo([	0,				0,
							  		afc.addComma, 	afc.addComma] );
	thisObj.nodata3 = this.findCompById('Nodata3');
	thisObj.nodata3.show(AComponent.VISIBLE);
	
//	thisObj.bodyRightGrd.setWidth(910);
//	thisObj.bodyRightGrd.setColorInfo(['2|D1기준가',7,6,0,0,0,1]);
//	thisObj.bodyRightGrd.setMaskInfo([1,5,16,1,MetaInfo.oneMillion,MetaInfo.oneTenMillion,1]);
/*
AComponent.MASK = [afc.returnAsIt, afc.addComma, afc.addPercent, afc.commaPercent, afc.absPercent,
				   afc.absComma, afc.absCommaPercent, afc.abs, afc.formatDate, afc.formatTime,
				   afc.formatMonth, afc.formatDateTime, afc.formatTic, afc.floor2, afc.floor2Per,
				   afc.intComma, afc.plusfloorPercent, afc.absFloor2, afc.absFloor2Per, afc.formatHMS,
				   afc.sigaTotalAmount, afc.capitalAmount, afc.intComma, afc.addCommaIfFixed, afc.absCommaIfFixed,
				   afc.absFloor1, afc.formatDate2, afc.oneHundredMillionAmount ];
*/
	thisObj.toDay = MetaInfo.fnGetToday('NUMDATE'); // 현재 일자 조회

	thisObj.eYYYYMMDD = thisObj.makeBaseDate(thisObj.toDay,true);
	thisObj.sYYYYMMDD = thisObj.eYYYYMMDD.substring(0,4)+ thisObj.eYYYYMMDD.substring(4,6)+ '01';
	//alert(thisObj.eYYYYMMDD);
	var newDate = thisObj.eYYYYMMDD.substring(0,4) + '년  ' + thisObj.eYYYYMMDD.substring(4,6)+ '월';
	thisObj.picker.setValue(thisObj.eYYYYMMDD);
	thisObj.lblDate.setText(thisObj.eYYYYMMDD.substring(0,4) + '년  ' + thisObj.eYYYYMMDD.substring(4,6)+ '월');
	
	thisObj.qryDate12 = thisObj.eYYYYMMDD;
	thisObj.qryDate3 = thisObj.eYYYYMMDD.substring(0,6) + '00';
	
	thisObj.findCompById('RadioGroup1').setSelectBtn(thisObj.findCompById('RadioButton1'));
};


//calculate and display previous month from picked yyyy/mm/lastday
@function FD1502:makeBaseDate(pickDate,bInit)
{
	if(!parseInt(pickDate,10)) return '';
	
	var year = parseInt(pickDate.substring(0,4),10);
	var month = parseInt(pickDate.substring(4,6),10);
	var day = parseInt(pickDate.substring(6,8),10);
	
	if(bInit)
		month--;
	
	if(month == 0)
	{
		year--;
		month = 12;
	}
	if(month == 1 || month == 3 || month == 5 || month == 7 || 
		month == 8 || month == 10 || month == 12)
	{
		day = 31;
	}
	else if (month == 2)
	{
		if(year % 4 == 0)
		{
			if(year % 100 != 0) day = 29;
			else{
				if(year % 400 == 0) day = 29;
				else day = 28;
			}
		}
		else day = 28;
	}
	else day = 30;
	
	return [year.toString(),MetaInfo.leadingZeros(month.toString(),2),MetaInfo.leadingZeros(day.toString(),2)].join('');
		
	
}
@function FD1502:reCalcScroll(position)
{
	var thisObj = this;
	thisObj.ContentView.scrollTo(position); 
};

@function FD1502:onWillDeactive()
{
	@super.onWillDeactive();
	
	var thisObj =this;
	
	thisObj.InitView();
	
	thisObj.secureTxf.clear();
};
@function FD1502:onActiveDone(reload)
{
	var thisObj = this;
	@super.onActiveDone(reload);
			
	// 계좌세팅(투신상품만 조회) -> 2019.06.19 연금계좌 조회추가
	if ('RadioButton2' == thisObj.findCompById('RadioGroup1').getSelectBtn().compId)
		thisObj.setDropBoxByRadioBtn('02');
	else
		thisObj.setDropBoxByRadioBtn('01');
	thisObj.reCalcScroll(0);

};
//공통 계좌필드 비밀번호 입력시
@function FD1502:fnDoSendDataManage()
{				
	var thisObj = this;

	thisObj.InitView();
	
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		return;
	}
	
	
	if(thisObj.secureTxf.getPwLength() == 0)
	{	
		AToast.show("계좌비밀번호를 입력해주세요.");
		thisObj.secureTxf.addClass('active');
		return;
	}
	thisObj.secureTxf.removeClass('active');
	
	thisObj.DoSendDataManage();
	

};
//InitView 테이블 초기화작업
@function FD1502:InitView()
{
	var thisObj = this;
	//초기화	
	
	thisObj.nodata1 = this.findCompById('Nodata1');
	thisObj.nodata2 = this.findCompById('Nodata2');
	thisObj.nodata3 = this.findCompById('Nodata3');

	thisObj.nodata1.show(AComponent.VISIBLE);
	thisObj.nodata2.show(AComponent.VISIBLE);
	thisObj.nodata3.show(AComponent.VISIBLE);
	
	thisObj.evalGrid.setCellText(0,1, '');   
	thisObj.dpsGrid.setCellText(0,1, '');   
	
	
	thisObj.invGridBase.removeAll();
	thisObj.invGrid.removeAll();
	
	thisObj.trdGridBase.removeAll();
	thisObj.trdGrid.removeAll();

	thisObj.infoGridBase.removeAll();
	thisObj.infoGrid.removeAll();
	
	thisObj.lblInvDate.setText(afc.formatDate(thisObj.qryDate12));
	thisObj.lblTrdDate.setText(afc.formatDate(thisObj.qryDate12));
	thisObj.lblInfoDate.setText(afc.formatDate(thisObj.qryDate12));
	
	thisObj.contiKey1 = null;	
	thisObj.contiKey2 = null;	
	thisObj.contiKey3 = null;	
};
@function FD1502:DoSendDataManage()
{	
	var thisObj = this;
	
	thisObj.sendSOFFQ586();
	
	thisObj.sendSDPBQ001();
	
	thisObj.sendSOFFQ595();
};

@function FD1502:sendSOFFQ586()
{
	var thisObj = this;
		
 	theApp.accNetManager.addSkipErrorCode('SOFFQ586', '2679');
	thisObj.sendData("SOFFQ586",
		function(queryData, groupName)
		{	
			queryData.setHeaderInfo({
				FUNC_KEY_LST: 'C'
			});

			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			InBlock1['D1계좌번호'] = thisObj.accDbx.getSelectedItemData()['D1계좌번호']
			InBlock1['D1비밀번호'] = thisObj.secureTxf.getCipherData();
			InBlock1['D1기준일'] = thisObj.qryDate12;
			InBlock1["D1매매구분"] = '1';
			InBlock1["D1펀드주문구분"] = '1';
			
			queryData.putPwInfo('InBlock1', 'D1비밀번호');
				
			if(thisObj.contiKey1){
				queryData.setContiKey(thisObj.contiKey1);				
			}
			queryData.printQueryData();
			
		},
		function(queryData, groupName) 
		{
			if(queryData)
			{
				queryData.printQueryData();

				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				
				if(!OutBlock1)
				{
					thisObj.evalGrid.setCellText(0,1,'');
					thisObj.dpsGrid.setCellText(0,1,'');
					thisObj.contiKey1 = null;
					return;
				}
				
				var Dps = parseInt(OutBlock1['D1예수금'],10);
				var EvalAmt = parseInt(OutBlock1['D1평가금액'],10);
				thisObj.evalGrid.setCellText(0,1, thisObj.addIntCommaWon(Dps + EvalAmt));
					
				thisObj.dpsGrid.setCellText(0,0, 'KRW');
				thisObj.dpsGrid.setCellText(0,1, thisObj.addIntCommaWon(Dps));

				var OutBlock2 = queryData.getBlockData('OutBlock2');
				if(!OutBlock2 || OutBlock2.length == 0) {
					thisObj.nodata1.show(AComponent.VISIBLE);
				} else {
					thisObj.nodata1.show(AComponent.GONE);
				}
				
				var blockData = null;
				var digits = Math.pow(10, 3);
				for(var i=0; i<OutBlock2.length; i++)
				{
					blockData = OutBlock2[i];
					blockData['D1총보수율'] = parseFloat(parseInt((blockData['D1총보수율']*0.1)*digits, 10)/digits).toFixed(3)+'%';
					blockData['tmpArea'] = "-";
				}
				thisObj.contiKey1 = queryData.getContiKey();
				
			}
			else{
				thisObj.contiKey1 = null;
			}
	    }
	);	
};
@function FD1502:sendSDPBQ001()
{
	var thisObj = this;
		
	thisObj.sendData("SDPBQ001",
		function(queryData, groupName)
		{	
			queryData.setHeaderInfo({
				FUNC_KEY_LST: 'C'
			});

			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			InBlock1['D1조회구분'] = '0';
			InBlock1['D1계좌번호'] = thisObj.accDbx.getSelectedItemData()['D1계좌번호']
			InBlock1['D1비밀번호'] = thisObj.secureTxf.getCipherData();
			InBlock1['D1조회시작일'] = thisObj.sYYYYMMDD;
			InBlock1['D1조회종료일'] = thisObj.qryDate12;
			InBlock1['D1상품유형코드'] = '04';//투자신탁
			InBlock1['D1정렬순서구분'] = '1';//거래순
			
			queryData.putPwInfo('InBlock1', 'D1비밀번호');	
			
			if(thisObj.contiKey2){
				queryData.setContiKey(thisObj.contiKey2);
			}
		},
		function(queryData, groupName) 
		{
			if(queryData)
			{
				queryData.printQueryData();

				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				
				
				if(!OutBlock1)
				{
					thisObj.contiKey2 = null;
					return;
				}
								
				var OutBlock2 = queryData.getBlockData('OutBlock2');
				
				if(!OutBlock2 || OutBlock2.length == 0) {
					thisObj.nodata2.show(AComponent.VISIBLE);
				} else {
					thisObj.nodata2.show(AComponent.GONE);
				}
				
				thisObj.contiKey2 = queryData.getContiKey();
			}
			else{
				thisObj.contiKey2 = null;
			}
	    }
	);	
};
@function FD1502:sendSOFFQ595()
{
	var thisObj = this;
		
	theApp.accNetManager.addSkipErrorCode('SOFFQ595', '2679'); // 조회내역이 없습니다. Skip 처리
	thisObj.sendData("SOFFQ595",
		function(queryData, groupName)
		{	
			queryData.setHeaderInfo({
				FUNC_KEY_LST: 'C'
			});

			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			InBlock1['D1계좌번호'] = thisObj.accDbx.getSelectedItemData()['D1계좌번호']
			InBlock1['D1기준일'] = thisObj.qryDate3;
			
			if(thisObj.contiKey3){
				queryData.setContiKey(thisObj.contiKey3);
			}
		},
		function(queryData, groupName) 
		{
			if(queryData)
			{
				queryData.printQueryData();

				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];
				
				if(!OutBlock1 || OutBlock1.length == 0) {
					thisObj.nodata3.show(AComponent.VISIBLE);
				} else {
					thisObj.nodata3.show(AComponent.GONE);
				}
				
				if(!OutBlock1)
				{
					thisObj.contiKey3 = null;
					return;
				}
				
				thisObj.contiKey3 = queryData.getContiKey();
			}
			else{
				thisObj.contiKey3 = null;
			}
	    }
	);	
};
@function FD1502:addIntCommaWon(val)
{
	return afc.addComma(parseInt(val)) + " 원";
};

@function FD1502:onBackBtnClick(comp, info)
{

	//TODO:edit here
	theApp.goPrevPageCheck(false);

};

@function FD1502:onDatePicker1Change(comp, info)
{
    var thisObj = this;
	
	var date = comp.getValue();
	thisObj.eYYYYMMDD = thisObj.makeBaseDate(date,false);
	thisObj.sYYYYMMDD = thisObj.eYYYYMMDD.substring(0,4)+ thisObj.eYYYYMMDD.substring(4,6)+ '01';
	var newDate = thisObj.eYYYYMMDD.substring(0,4) + '년  ' + thisObj.eYYYYMMDD.substring(4,6)+ '월';
	thisObj.lblDate.setText(newDate);
	comp.setValue(thisObj.eYYYYMMDD);

	//
	if(thisObj.toDay.substring(0,6) <= date.substring(0,6))
	{
		thisObj.qryDate12 = thisObj.qryDate3 = thisObj.toDay;
	}
	else
	{
		thisObj.qryDate12 = thisObj.eYYYYMMDD;
		thisObj.qryDate3 = thisObj.eYYYYMMDD.substring(0,6) + '00';
	}
	thisObj.fnDoSendDataManage();
};

@function FD1502:ontrdGridScrollBottom(comp, info)
{	
	//TODO:edit here
	if(this.contiKey2)
	{
		this.sendSDPBQ001();
	}
	else
	{	
		if(comp.getRowCount() > 0) AToast.show(Message.LastList);
	}
};

@function FD1502:oninfoGridScrollBottom(comp, info)
{
	//TODO:edit here
	if(this.contiKey3)
	{
		this.sendSOFFQ595();
	}
	else
	{	
		if(comp.getRowCount() > 0) AToast.show(Message.LastList);
	}

};

@function FD1502:oninvGridBaseScrollBottom(comp, info)
{

	//TODO:edit here
	if(this.contiKey1)
	{
		this.sendSOFFQ586();
	}
	else
	{	
		if(comp.getRowCount() > 0) AToast.show(Message.LastList);
	}

};

@function FD1502:onRadioButton1Click(comp, info)
{
	this.setDropBoxByRadioBtn('01'); 
};

@function FD1502:onRadioButton2Click(comp, info)
{
	this.setDropBoxByRadioBtn('02');
};

@function FD1502:setDropBoxByRadioBtn(type)
{
	if('02' == type)
		this.accView.getLoadView().doInitAccInfo(5);  // 연금계좌
	else
		this.accView.getLoadView().doInitAccInfo(4);  // 일반계좌
		
};

