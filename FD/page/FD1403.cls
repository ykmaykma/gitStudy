
/**
Constructor
Do not call Function in Constructor.
** 마케팅이용제공현황 **
*/
@class FD1403()
{
	@super();
	this.LB_Result 			= null; 
	this.LB_Date 			= null;
	
	this.ItemInBlock 		= null;
	this.ItemVal			= null;
	
	this.BTN_AGREE_YES		= null;
	//this.BTN_AGREE_NO		= null;
	
	this.ClntInfoTp5		= null;
	
	this.chkArr = [
		['chkBox00','전체'] 	
		,['chkBox20','SMS']	
		,['chkBox30','EMAIL']
	];
	//TODO:edit here
}
@extends BasePage;

@function FD1403:onReady()
{
	@super.onReady();
	
	this.LB_Result 		= this.findCompById('LB_Result'); 
	this.LB_Date 		= this.findCompById('LB_Date');
	
	this.BTN_AGREE_YES	= this.findCompById('BTN_AGREE_YES');
	this.ContentView = this.findCompById('CenterView');
	
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
	
	this.BTN_AGREE_YES.enable(false);	
};

@function FD1403:onWillDeactive()
{
	@super.onWillDeactive();
	var thisObj =this;
	thisObj.InitView();
	thisObj.secureTxf.clear();
};

@function FD1403:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	var thisObj = this;
	thisObj.reCalcScroll(0); 
};

@function FD1403:reCalcScroll(position)
{
	var thisObj = this;
	thisObj.ContentView.scrollTo(position); 
};

@function FD1403:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1403:refreshData() ');
};

@function FD1403:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

//AccDropView 로드뷰에서 호출하는 함수
@function FD1403:fnDoSendDataManage()
{
	//탭값 초기화
	
	this.accDbx.removeClass('active');
	this.secureTxf.removeClass('active');
	
	this.InitView();
	this.ViewSendData();
		
};

//InitView 테이블 초기화작업
@function FD1403:InitView()
{
	var thisObj = this;
	//초기화	
	
	thisObj.ItemVal 		= '';
	thisObj.ItemInBlock 	= null;
	thisObj.LB_Result.setText('');
	thisObj.LB_Date.setText('');
	
	thisObj.ClntInfoTp5		= null;
	
	thisObj.InitCheckBox(false);
	
};

@function FD1403:InitCheckBox(flag)
{
	var thisObj = this;
	// 마케팅 방식 초기화 
	for (var i=0; i<thisObj.chkArr.length; i++) {
		thisObj.findCompById(thisObj.chkArr[i][0]).setCheck(flag);
	}
}

@function FD1403:ViewSendData()
{	
	var thisObj = this;
	thisObj.SendData_SACMT289('select');			
};

@function FD1403:SendData_SACMT289(Type,callback)
{
	var thisObj = this
		,cont = thisObj // 연결된 최상위 뷰
		,qrName = "SACMT289"
		,cipherData = thisObj.secureTxf.getCipherData();
		
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		this.accDbx.addClass('active');
		return;
	}
	
	if(!afc.isSimulator)
	{
		if(!cipherData)
		{
			AToast.show('계좌 비밀번호를 입력하세요.');
			this.secureTxf.addClass('active');
			return;
		}
	}
	
	var checkObj = {
		svcId : qrName,
		accNo : thisObj.accDbx.getSelectedItemData()['D1계좌번호']
	};
	SecurePadManager.cipherToText(cipherData, checkObj, function(result){
	
		cont.sendData(qrName,
			function(queryData, groupName)
			{	
				var InBlock1 = queryData.getBlockData('InBlock1')[0];				
				
				if (Type == 'select'){
				
					queryData.setHeaderInfo({
						FUNC_KEY_LST: 'C'
					});
				
					InBlock1['D1처리구분'] = '3';
				} else {
				
					queryData.setHeaderInfo({
						FUNC_KEY_LST: '5'
					});
					
					InBlock1['D1처리구분'] = '2',	// 정정 
					InBlock1['D1개인정보제공동의여부1'] = thisObj.ItemInBlock.D1개인정보제공동의여부1,
					InBlock1['D1개인정보제공동의여부2'] = thisObj.ItemInBlock.D1개인정보제공동의여부2,
					InBlock1['D1개인정보제공동의여부3'] = thisObj.ItemInBlock.D1개인정보제공동의여부3,
					InBlock1['D1개인정보제공동의여부4'] = thisObj.ItemInBlock.D1개인정보제공동의여부4,
					InBlock1['D1개인정보제공동의여부5'] = thisObj.ClntInfoTp5,
					InBlock1['D1항목값'] = thisObj.ItemVal,
					InBlock1['D1개인정보제공동의여부6'] = thisObj.ItemInBlock.D1개인정보제공동의여부6,
					InBlock1['D2항목값'] = thisObj.ItemInBlock.D2항목값,
					InBlock1['D1개인정보제공동의여부7'] = thisObj.ItemInBlock.D1개인정보제공동의여부7,
					InBlock1['D1개인정보제공동의여부8'] = thisObj.ItemInBlock.D1개인정보제공동의여부8,
					InBlock1['D1개인정보제공동의여부9'] = thisObj.ItemInBlock.D1개인정보제공동의여부9,
					InBlock1['D1개인정보제공동의여부10'] = thisObj.ItemInBlock.D1개인정보제공동의여부10,
					InBlock1['D3항목값'] = thisObj.ItemInBlock.D3항목값,
					InBlock1['D1개인정보제공동의여부11'] = thisObj.ItemInBlock.D1개인정보제공동의여부11,
					InBlock1['D1개인정보제공동의여부12'] = thisObj.ItemInBlock.D1개인정보제공동의여부12,
					InBlock1['D1개인정보제공동의여부13'] = thisObj.ItemInBlock.D1개인정보제공동의여부13,
					InBlock1['D1개인정보제공동의여부14'] = thisObj.ItemInBlock.D1개인정보제공동의여부14,
					InBlock1['D1개인정보제공동의여부15'] = thisObj.ItemInBlock.D1개인정보제공동의여부15,
					InBlock1['D1개인정보제공동의여부16'] = thisObj.ItemInBlock.D1개인정보제공동의여부16,
					InBlock1['D1개인정보제공동의여부17'] = thisObj.ItemInBlock.D1개인정보제공동의여부17,
					InBlock1['D1개인정보제공동의여부18'] = thisObj.ItemInBlock.D1개인정보제공동의여부18,
					InBlock1['D1개인정보제공동의여부19'] = thisObj.ItemInBlock.D1개인정보제공동의여부19,
					InBlock1['D1개인정보제공동의여부20'] = thisObj.ItemInBlock.D1개인정보제공동의여부20,
					InBlock1['D1개인정보제공동의여부21'] = thisObj.ItemInBlock.D1개인정보제공동의여부21,
					InBlock1['D1개인정보제공동의여부22'] = thisObj.ItemInBlock.D1개인정보제공동의여부22,
					InBlock1['D1개인정보제공동의여부23'] = thisObj.ItemInBlock.D1개인정보제공동의여부23,
					InBlock1['D1개인정보제공동의여부24'] = thisObj.ItemInBlock.D1개인정보제공동의여부24,
					InBlock1['D1개인정보제공동의여부25'] = thisObj.ItemInBlock.D1개인정보제공동의여부25,
					InBlock1['D1개인정보제공동의여부26'] = thisObj.ItemInBlock.D1개인정보제공동의여부26,
					InBlock1['D1개인정보제공동의여부27'] = thisObj.ItemInBlock.D1개인정보제공동의여부27,
					InBlock1['D1개인정보제공동의여부28'] = thisObj.ItemInBlock.D1개인정보제공동의여부28,
					InBlock1['D1개인정보제공동의여부29'] = thisObj.ItemInBlock.D1개인정보제공동의여부29,
					InBlock1['D1개인정보제공동의여부30'] = thisObj.ItemInBlock.D1개인정보제공동의여부30,
					InBlock1['D1개인정보제공동의여부31'] = thisObj.ItemInBlock.D1개인정보제공동의여부31,
					InBlock1['D1개인정보제공동의여부32'] = thisObj.ItemInBlock.D1개인정보제공동의여부32,
					InBlock1['D1개인정보제공동의여부33'] = thisObj.ItemInBlock.D1개인정보제공동의여부33,
					InBlock1['D1개인정보제공동의여부34'] = thisObj.ItemInBlock.D1개인정보제공동의여부34,
					InBlock1['D1개인정보제공동의여부35'] = thisObj.ItemInBlock.D1개인정보제공동의여부35,
					InBlock1['D1개인정보제공동의여부36'] = thisObj.ItemInBlock.D1개인정보제공동의여부36,
					InBlock1['D1개인정보제공동의여부37'] = thisObj.ItemInBlock.D1개인정보제공동의여부37,
					InBlock1['D1개인정보제공동의여부38'] = thisObj.ItemInBlock.D1개인정보제공동의여부38,
					InBlock1['D1개인정보제공동의여부39'] = thisObj.ItemInBlock.D1개인정보제공동의여부39,
					InBlock1['D1개인정보제공동의여부40'] = thisObj.ItemInBlock.D1개인정보제공동의여부40,
					InBlock1['D1개인정보제공동의여부41'] = thisObj.ItemInBlock.D1개인정보제공동의여부41,
					InBlock1['D1개인정보제공동의여부42'] = thisObj.ItemInBlock.D1개인정보제공동의여부42,
					InBlock1['D1개인정보제공동의여부43'] = thisObj.ItemInBlock.D1개인정보제공동의여부43,
					InBlock1['D1개인정보제공동의여부44'] = thisObj.ItemInBlock.D1개인정보제공동의여부44,
					InBlock1['D1개인정보제공동의여부45'] = thisObj.ItemInBlock.D1개인정보제공동의여부45,
					InBlock1['D1개인정보제공동의여부46'] = thisObj.ItemInBlock.D1개인정보제공동의여부46,
					InBlock1['D1개인정보제공동의여부47'] = thisObj.ItemInBlock.D1개인정보제공동의여부47,
					InBlock1['D1개인정보제공동의여부48'] = thisObj.ItemInBlock.D1개인정보제공동의여부48,
					InBlock1['D1개인정보제공동의여부49'] = thisObj.ItemInBlock.D1개인정보제공동의여부49,
					InBlock1['D1개인정보제공동의여부50'] = thisObj.ItemInBlock.D1개인정보제공동의여부50
					
				}
				InBlock1['D1계좌번호'] = checkObj.accNo;
				InBlock1['D1비밀번호'] = afc.isSimulator ? '0423' : result;
				
				queryData.putPwInfo('InBlock1','D1비밀번호');		
				queryData.printQueryData();
			},
			function(queryData, groupName) {

				if(queryData != null){

					queryData.printQueryData();
					
					var inBlock1 = queryData.getBlockData('InBlock1')[0];
					thisObj.ItemInBlock = inBlock1;	
					thisObj.setFromData();		
					thisObj.SendData_SACMQ289('select');
					if (Type != 'update') return;
					
					var errorData = this.getLastError();					
					callback(errorData);						

			}
		});
	});
};


@function FD1403:SendData_SACMQ289()
{
	var thisObj = this
		,cont = thisObj // 연결된 최상위 뷰
		,qrName = "SACMQ289"
		,cipherData = thisObj.secureTxf.getCipherData();
		
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		return;
	}
	
	var checkObj = {
		svcId : qrName,
		accNo : thisObj.accDbx.getSelectedItemData()['D1계좌번호']
	};
	
	cont.sendData(qrName,
		function(queryData, groupName)
		{	
			queryData.setHeaderInfo({
				FUNC_KEY_LST: 'C'
			});

			var InBlock1 = queryData.getBlockData('InBlock1')[0];				
			InBlock1['D1처리구분'] = '3';
			InBlock1['D1계좌번호'] = checkObj.accNo;
			InBlock1['D1구분문자1'] = '0';
			InBlock1['D1구분문자2'] = '0';
			InBlock1['D1구분문자3'] = '0';
			InBlock1['D1개인정보제공동의여부5'] = '0';
			
			queryData.printQueryData();
		},
		function(queryData, groupName) {

			if(queryData != null){

				queryData.printQueryData();

				var OutBlock1 = queryData.getBlockData('OutBlock1')[0];

				if(!OutBlock1) return;
				
				//thisObj.setLB_Date(DateUtils.toFormatDay(OutBlock1['D1승인일5']));
				var LbDate = '';
				if (OutBlock1['D1승인일5'].length == 8){
					LbDate = OutBlock1['D1승인일5'].substring(0,4) + '-' + OutBlock1['D1승인일5'].substring(4,6) + '-' + OutBlock1['D1승인일5'].substring(6,8);
				} else {
					LbDate = OutBlock1['D1승인일5'];
				}
				thisObj.setLB_Date(LbDate); // 날짜형식 공통 함수 추가해야함

			}
	});	
};

@function FD1403:setFromData()
{
	var thisObj = this;
	//F1_SUB 전체, 전화, EMAIL, SMS, 휴대폰, 전화, DM
	var ItemVal1 = thisObj.ItemInBlock['D1항목값'];			
	if ("1" == thisObj.ItemInBlock['D1개인정보제공동의여부5'])
	{	 
		thisObj.LB_Result.setText("고객님은 현재 메리츠자산운용의 마케팅 영업대상입니다."); 		
		//thisObj.LB_Result.setTextColor('navy');
		thisObj.LB_Result.addClass("fc_red1");
	}   
	else 
	{
	    thisObj.LB_Result.setText("고객님은 현재 메리츠자산운용의 마케팅 영업대상이 아닙니다."); 		
		thisObj.LB_Result.setTextColor('black'); 		
		//thisObj.BTN_AGREE_NO.enable(false);		
	}	
	
	if(ItemVal1 != null){				
		var j = 0;
		var k = 2;
		var chklen = ItemVal1.length/2;
		for(var i=1; i<=chklen; i++){				
			var vQuest10 = 'chkBox' +  ItemVal1.substring(j,k);
			
			if(ItemVal1.substring(j,k) == '00'){
				thisObj.InitCheckBox(true);
			}else{
				if(thisObj.findCompById(vQuest10)) thisObj.findCompById(vQuest10).setCheck(true);
			}				
			j = j+2;
			k = k+2;				
		}
	}else{
		thisObj.InitCheckBox(false);
	}
}

@function FD1403:setLB_Date(date)
{
	var thisObj = this;
	
	thisObj.LB_Date.setText(date); // 연금저축 가입여부				
	thisObj.BTN_AGREE_YES.enable(true);
}

// 마케팅 이용동의 변경
@function FD1403:onBTN_AGREE_YESClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	
	if(!afc.isSimulator)
	{
		if(!thisObj.secureTxf.getCipherData())
		{
			AToast.show('계좌 비밀번호를 입력하세요.');
			this.secureTxf.addClass('active');
			return;
		}
	}
	
	thisObj.ItemVal = '';
	
	var reAgreement = [];
	if (thisObj.findCompById(thisObj.chkArr[0][0]).getCheck()) {
		thisObj.ItemVal = '00';
		reAgreement.push(thisObj.chkArr[0][1]);
	} else {
		for (var i=1; i<thisObj.chkArr.length; i++) {
			if (thisObj.findCompById(thisObj.chkArr[i][0]).getCheck()){
				thisObj.ItemVal += thisObj.chkArr[i][0].replace('chkBox','');
				reAgreement.push(thisObj.chkArr[i][1]);
			}
		}
	}
	
	thisObj.ClntInfoTp5 = '1';
	
	thisObj.SendData_SACMT289("update",function(errorData){
		if(errorData.errCode == '0199'){				
			//var toDay = Utils.fnGetToday('DATENUM');
			//alert('메리츠자산운용\n'+DateUtils.toFormatDay1(toDay)+'\n동의사항이 변경되었습니다.\n'+'('+thisObj.reAgreement+' 수신동의)');
			
			// 마케팅이용제공현황 완료
			theApp.alert(
				[	 
					'메리츠자산운용 동의사항이<br>'
					,'변경되었습니다.<br>'
					,'('+reAgreement+' 수신동의)'
					,' '
				].join('')
				,
				function()
				{			
					//
				}
				,''
			);
			
			
			theApp.goPageCheck('FD1401', false);
			
		}	
	});

};

// 마케팅 이용동의 해지
@function FD1403:onBTN_AGREE_NOClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	var win = AWindow.createWindow('FD/window/FD1403_W02.lay','FD1403W02');
	win.open(thisObj, 20, '20%', 600, 600);
	win.setWindowOption({isFocusLostClose: true});
};


@function FD1403:onWindowResult(result, windowObj)
{
	//TODO:edit here
	var thisObj = this;
	if(windowObj.containerId == 'FD1403W02'){
	
		if(result == 1)
    	{	
			thisObj.ClntInfoTp5 = '0';
			thisObj.ItemVal = '9';
			
			thisObj.SendData_SACMT289("update",function(errorData){
				if(errorData.errCode == '0199'){				
					//var toDay = Utils.fnGetToday('DATENUM');
					//var toDay = Utils.fnGetToday('DATENUM');
					//alert('메리츠자산운용\n'+DateUtils.toFormatDay1(toDay)+'\n마케팅 이용 동의 철회되었습니다.');
					alert('메리츠자산운용\n마케팅 이용 동의 철회되었습니다.');
					thisObj.fnDoSendDataManage();
				}	
			});
			
		}  
	}
};

@function FD1403:onchkClick(comp, info)
{
	//TODO:edit here
	var thisObj = this;
	var chkName = comp.compId;
	var chkNo = comp.compId.replace('chkBox','');
	
	if (chkNo == '00') {
		thisObj.InitCheckBox(thisObj.findCompById(chkName).getCheck());
	} else {
		var allChkFlag = true;
		for (var i = 1; i < thisObj.chkArr.length; i++){
			if (!thisObj.findCompById(thisObj.chkArr[i][0]).getCheck()) allChkFlag = false;
		}
		
		thisObj.findCompById('chkBox00').setCheck(allChkFlag);		
	}
	
};
