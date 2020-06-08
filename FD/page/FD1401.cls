
/**
Constructor
Do not call Function in Constructor.
** 개인(신용)정보동의현황 **
*/
@class FD1401()
{
	@super();
	this.ItemInBlock 		= null;
	this.ItemVal			= null;
	
	this.BTN_AGREE_YES		= null;
	
	this.chkArr = [
		['chkBox00','전체'] 	
		,['chkBox20','SMS']	
		,['chkBox30','EMAIL']
	];
	
	this.RgArray = ['RG_E1','RG_E3','RG_F5','RG_G2','RG_G4','RG_G5','RG_G6','RG_GA','RG_F1','RG_F4','RG_F3'];
	
	//TODO:edit here
}
@extends BasePage;

@function FD1401:onReady()
{
	@super.onReady();
	
	this.BTN_AGREE_YES	= this.findCompById('BTN_AGREE_YES');
	this.ContentView = this.findCompById('CenterView');
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
	
	//this.BTN_AGREE_YES.enable(false);
};

@function FD1401:onWillDeactive()
{
	@super.onWillDeactive();
	var thisObj = this;
	thisObj.InitView();
	thisObj.secureTxf.clear();
};

@function FD1401:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	var thisObj = this;
	thisObj.reCalcScroll(0);
};

@function FD1401:reCalcScroll(position)
{
	var thisObj = this;
	thisObj.ContentView.scrollTo(position); 
};

@function FD1401:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1401:refreshData() ');
};

@function FD1401:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

//AccDropView 로드뷰에서 호출하는 함수
@function FD1401:fnDoSendDataManage()
{
	//탭값 초기화
	
	this.accDbx.removeClass('active');
	this.secureTxf.removeClass('active');
	
	this.InitView();
	this.ViewSendData();
		
};

//InitView 테이블 초기화작업
@function FD1401:InitView()
{
	var thisObj = this;
	//초기화	
		
	thisObj.ItemVal 		= '';
	thisObj.ItemInBlock 	= null;
	thisObj.InitRadioBtn();
	thisObj.InitCheckBox(false);	
};

@function FD1401:InitCheckBox(flag)
{
	var thisObj = this;
	// 마케팅 방식 초기화 
	for (var i=0; i<thisObj.chkArr.length; i++) {
		thisObj.findCompById(thisObj.chkArr[i][0]).setCheck(flag);			
	}
}

@function FD1401:SetCheckBoxEnable(flag)
{
	var thisObj = this;
	// 마케팅 방식 초기화 
	for (var i=0; i<thisObj.chkArr.length; i++) {
		thisObj.findCompById(thisObj.chkArr[i][0]).enable(flag);			
	}
}


@function FD1401:ViewSendData()
{	
	var thisObj = this;
	thisObj.SendData_SACMT289('select');
	thisObj.SendData_SACMQ289('select');
			
};

@function FD1401:SendData_SACMT289(Type,callback)
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
					InBlock1['D1개인정보제공동의여부1'] = thisObj.findCompById('RG_E1').getSelectBtn().compId.substring(6),					
					InBlock1['D1개인정보제공동의여부2'] = thisObj.ItemInBlock.D1개인정보제공동의여부2,
					InBlock1['D1개인정보제공동의여부3'] = thisObj.findCompById('RG_E3').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부4'] = thisObj.ItemInBlock.D1개인정보제공동의여부4,
					InBlock1['D1개인정보제공동의여부5'] = thisObj.findCompById('RG_F1').getSelectBtn().compId.substring(6),
					InBlock1['D1항목값'] = thisObj.ItemVal,
					InBlock1['D1개인정보제공동의여부6'] = thisObj.ItemInBlock.D1개인정보제공동의여부6,
					InBlock1['D2항목값'] = thisObj.ItemInBlock.D2항목값,
					InBlock1['D1개인정보제공동의여부7'] = thisObj.findCompById('RG_F3').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부8'] = thisObj.findCompById('RG_F4').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부9'] = thisObj.findCompById('RG_F5').getSelectBtn().compId.substring(6),					
					
					InBlock1['D1개인정보제공동의여부10'] = thisObj.ItemInBlock.D1개인정보제공동의여부10,
					InBlock1['D3항목값'] = thisObj.ItemInBlock.D3항목값,
					InBlock1['D1개인정보제공동의여부11'] = thisObj.findCompById('RG_G2').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부12'] = thisObj.ItemInBlock.D1개인정보제공동의여부12,
					InBlock1['D1개인정보제공동의여부13'] = thisObj.findCompById('RG_G4').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부14'] = thisObj.findCompById('RG_G5').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부15'] = thisObj.findCompById('RG_G6').getSelectBtn().compId.substring(6),
					InBlock1['D1개인정보제공동의여부16'] = thisObj.ItemInBlock.D1개인정보제공동의여부16,
					InBlock1['D1개인정보제공동의여부17'] = thisObj.ItemInBlock.D1개인정보제공동의여부17,
					InBlock1['D1개인정보제공동의여부18'] = thisObj.ItemInBlock.D1개인정보제공동의여부18,
					InBlock1['D1개인정보제공동의여부19'] = thisObj.findCompById('RG_GA').getSelectBtn().compId.substring(6), //GA
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
					thisObj.BTN_AGREE_YES.enable(true);
					if (Type != 'update') return;
					
					var errorData = this.getLastError();					
					callback(errorData);						

			}
		});
	});
};


@function FD1401:SendData_SACMQ289()
{
	var thisObj = this
		,cont = thisObj // 연결된 최상위 뷰
		,qrName = "SACMQ289"
		,cipherData = thisObj.secureTxf.getCipherData();
		
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		this.accDbx.addClass('active');
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
								
			}
	});	
};

@function FD1401:setFromData()
{
	var thisObj = this,
		rg_selectId = '';
	//F1_SUB 전체, 전화, EMAIL, SMS, 휴대폰, 전화, DM
	var ItemVal1 = thisObj.ItemInBlock['D1항목값'];			
		
	if(ItemVal1 != null){
		thisObj.SetCheckBoxEnable(true);
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
		thisObj.SetCheckBoxEnable(false);
	}	
	
	
	//E1. 개인(신용)정보 수집·이용에 관한 사항 [D1개인정보제공동의여부1]
	rg_selectId = 'RG_E1_'+thisObj.ItemInBlock['D1개인정보제공동의여부1'];	
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_E1').setSelectBtn(thisObj.findCompById(rg_selectId));

	//E3. 고유식별정보의 처리에 관한 사항 [D1개인정보제공동의여부3]
	rg_selectId = 'RG_E3_'+thisObj.ItemInBlock['D1개인정보제공동의여부3'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_E3').setSelectBtn(thisObj.findCompById(rg_selectId));

	//F5. (법정)대리인 정보 수집/이용  개인정보제공동의여부9
	rg_selectId = 'RG_F5_'+thisObj.ItemInBlock['D1개인정보제공동의여부9'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_F5').setSelectBtn(thisObj.findCompById(rg_selectId));

	//G8. 개인(신용)정보 수집·이용에 관한 사항 : 비과세 종합저축 [D1개인정보제공동의여부17]
	//thisObj.quest3Grade = thisObj.ItemInBlock['D1개인정보제공동의여부17'];
	//Utils.selectRadio(thisObj, 'RG_G8',	thisObj.quest3Grade);

	//GA. 개인연금(연금저축) [D1개인정보제공동의여부19]
	//thisObj.quest13Grade = thisObj.ItemInBlock['D1개인정보제공동의여부19'];
	//Utils.selectRadio(thisObj, 'RG_GA',	thisObj.quest13Grade);

	//G2. 개인(신용)정보 조회에 관한 사항 [D1개인정보제공동의여부11]
	rg_selectId = 'RG_G2_'+thisObj.ItemInBlock['D1개인정보제공동의여부11'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_G2').setSelectBtn(thisObj.findCompById(rg_selectId));
	
	//G4. 개인(신용)정보 제공에 관한 사항 : 신용정보집중기관 [D1개인정보제공동의여부13]
	rg_selectId = 'RG_G4_'+thisObj.ItemInBlock['D1개인정보제공동의여부13'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_G4').setSelectBtn(thisObj.findCompById(rg_selectId));

	//G5. 고유식별정보의 처리에 관한 사항 [D1개인정보제공동의여부14]
	rg_selectId = 'RG_G5_'+thisObj.ItemInBlock['D1개인정보제공동의여부14'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_G5').setSelectBtn(thisObj.findCompById(rg_selectId));

	//G6. 민감정보의 처리에 관한 사항 [D1개인정보제공동의여부15]
	rg_selectId = 'RG_G6_'+thisObj.ItemInBlock['D1개인정보제공동의여부15'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_G6').setSelectBtn(thisObj.findCompById(rg_selectId));
	
	
	//GA. 개인연금(저축연금) [D1개인정보제공동의여부19]
	rg_selectId = 'RG_GA_'+thisObj.ItemInBlock['D1개인정보제공동의여부19'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_GA').setSelectBtn(thisObj.findCompById(rg_selectId));

	//F1. 개인(신용)정보 수집·이용에 관한 사항 [D1개인정보제공동의여부5]
	rg_selectId = 'RG_F1_'+thisObj.ItemInBlock['D1개인정보제공동의여부5'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_F1').setSelectBtn(thisObj.findCompById(rg_selectId));

	//F3. 개인(신용)정보 제공에 관한 사항 : 해당없음
	rg_selectId = 'RG_F3_'+thisObj.ItemInBlock['D1개인정보제공동의여부7'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_F3').setSelectBtn(thisObj.findCompById(rg_selectId));

	//F4. 고유식별정보의 처리에 관한 사항 : 해당없음
	rg_selectId = 'RG_F4_'+thisObj.ItemInBlock['D1개인정보제공동의여부8'];
	if(thisObj.findCompById(rg_selectId) != null) thisObj.findCompById('RG_F4').setSelectBtn(thisObj.findCompById(rg_selectId));
	
	thisObj.onRG_ChangeCheck();
}

// 개인신용정보 변경
@function FD1401:onBTN_AGREE_YESClick(comp, info)
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
	
	if(!thisObj.validForm()) return false;
	
	thisObj.SendData_SACMT289("update",function(errorData){
		if(errorData.errCode == '0199'){				
			//var toDay = Utils.fnGetToday('DATENUM');
			// 개인(신용)정보동의현황 완료
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
		}	
	});

};

@function FD1401:onchkClick(comp, info)
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


@function FD1401:selectRadio(thisObj, radioButtonGroupId, val){
	
	var rg =  thisObj.findCompByGroup(radioButtonGroupId);

	// 라디오버튼에 값 셋팅
	for(var i=0 ; i<rg.length; i++){
		var radioVal = rg[i].$ele.val();
		
		if(radioVal == val){
			rg[i].setSelect(true);			
			return true;
		}
	}
};

@function FD1401:setRadioVal(thisObj, radioButtonGroupId, arr, checkFirst){
	
	var rg =  thisObj.findCompByGroup(radioButtonGroupId);
	
	var rgLen = rg.length;
	var valLen = arr.length;
	
	if(rgLen != valLen){
		theApp.alert(['값이 일치하지않습니다.',' '].join(''),function(){},'');
		return false;
	}

	// 첫번째 라디오 선택
	if(checkFirst){
		rg[0].setSelect(true);		
	}

	// 라디오버튼에 값 셋팅
	for(var i=0 ; i<rg.length; i++){
		rg[i].$ele.val(arr[i]);
	}
};

// 라디오버튼 초기 세팅
@function FD1401:InitRadioBtn()
{
	var thisObj = this;
	
	/*for(var i = 1; i < 10; i++){	
		if(i != 3){
			var QGname = 'Quest' + i + 'Group';
			var btngp = thisObj.findCompById(QGname).getRadioBtns();
			thisObj.findCompById(QGname).clearAll();						
		} else {
			for (var n = 1; n <= 5; n++){
				var chk = 'Group3Chk' + n;
				thisObj.findCompById(chk).setCheck(false);
			}
		}
	}*/
	
	for (var i = 0; i < thisObj.RgArray.length; i++){
		if(thisObj.findCompById(thisObj.RgArray[i]).getSelectBtn()){
			thisObj.findCompById(thisObj.RgArray[i]).clearAll();
		}		
		
	}
	
	thisObj.findCompById('AllCheckBox').setCheck(false);
	
};

@function FD1401:onRG_Change(comp, info)
{
	var thisObj = this;
	if (thisObj.findCompById(comp.compId).getSelectBtn().compId == 'RG_F1_0'){
		thisObj.InitCheckBox(false);
		thisObj.SetCheckBoxEnable(false);
	} else if (thisObj.findCompById(comp.compId).getSelectBtn().compId == 'RG_F1_1'){
		thisObj.SetCheckBoxEnable(true);
	}
	
	thisObj.onRG_ChangeCheck();
	
};


@function FD1401:onRG_ChangeCheck()
{
	var thisObj = this;
	var AllCheckFlag = true;
	for (var i = 0; i < thisObj.RgArray.length; i++){
		if (thisObj.findCompById(thisObj.RgArray[i]).getSelectBtn())
		{
			if (thisObj.findCompById(thisObj.RgArray[i]).getSelectBtn().compId.substring(6) == "0")	AllCheckFlag = false;
		}
	}
	
	thisObj.findCompById('AllCheckBox').setCheck(AllCheckFlag);
	
};

@function FD1401:onInfoClick(comp, info)
{
	
};

@function FD1401:validForm()
{	
	var thisObj = this;
	
	for (var i = 0; i < thisObj.RgArray.length; i++){
		if (thisObj.findCompById(thisObj.RgArray[i]).getSelectBtn() == null)
		{
			theApp.alert([thisObj.RgArray[i].substring(3,5)+'-  항목을 체크해주시기 바랍니다.',' '].join(''),function(){},'');
			return false;
		}
	}
	
	if(thisObj.findCompById('RG_F1').getSelectBtn().compId.substring(6) == "1" ){
		if(thisObj.ItemVal == ''){
			theApp.alert(['F1-동의시 마케팅 활용 수단을 입력하세요',' '].join(''),function(){},'');
	   		return false; 
		}	
	}else{
		thisObj.ItemVal = '9';
	}
	
	
	
	
	return true;
}

@function FD1401:onAllCheckBox(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	if (thisObj.findCompById('AllCheckBox').getCheck()){
		for (var i = 0; i < thisObj.RgArray.length; i++){
			var SelectId = thisObj.RgArray[i] +'_1';
			thisObj.findCompById(thisObj.RgArray[i]).setSelectBtn(thisObj.findCompById(SelectId));
		}
	} 
};

@function FD1401:onButton3Click(comp, info)
{

	//TODO:edit here
	
	var thisObj = this;

	var chkName = comp.compId;
	var chkNo = comp.compId.replace('Button','');
	var loadviewUrlAddr = '';
	var loadTitle = '';
	var win = '';		
	
	//var cont = thisObj.getContainer();

	
	win = AWindow.createWindow('FD/window/FD1401_W01.lay','FD1401W1');
	
	if(chkNo == '3'){
				
		loadviewUrlAddr = 'http://www.meritzam.com/marketings/terms18.html';
		loadTitle		= '개인(신용)정보 수집·이용·제공 동의서';
	} else {
		loadviewUrlAddr = 'http://www.meritzam.com/marketings/terms06.html';
		loadTitle		= '개인(신용)정보 수집·이용·제공에 관한 고객 권리 안내문';
	}
	
	win.setWindowOption({
		isAutoCenter: true,
		isFocusLostClose: false, 
		modalBgOption:'dark'
	});
	
	win.loadviewUrlAddr = loadviewUrlAddr;
	win.loadTitle = loadTitle;
	
	win.open(thisObj, 0, 0, '100%', '100%');
};


@function FD1401:onBtnInfoClick(comp, info)
{
	Notice.openNoticeMiniWindow(this,"FD1401W02" , 584, null,"&middot;&nbsp;&nbsp;동의하신 내용을 변경 하고자 하는 경우에는 해당 항목의 '동의안함'란에 체크하시고 확인버튼을 클릭하시기 바랍니다. <br><br>&middot;&nbsp;&nbsp;메리츠자산운용은 현재 고객님의 개인정보를 마케팅 목적으로 다른회사(제3자)에 제공하지 않습니다.",null,89);
};
