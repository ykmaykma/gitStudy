
/**
Constructor
Do not call Function in Constructor.
** 투자자정보확인서 작성/변경 **
*/
@class FD1304()
{
	@super();

	//TODO:edit here
	this.Quest1Group = null;
	this.Quest2Group = null;	
	this.Quest4Group = null;
	this.Quest5Group = null;
	this.Quest6Group = null;
	this.Quest7Group = null;
	this.Quest8Group = null;
	this.Quest9Group = null;
	this.Group10Chk = null;
	this.Group11Chk = null;	
	
	this.Group1Radio1 = null;
	this.Group1Radio2 = null;
	this.Group1Radio3 = null;
	this.Group1Radio4 = null;
	this.Group1Radio5 = null;
	
	this.Group6Radio1 = null;
	this.Group6Radio2 = null;
	this.Group6Radio3 = null;
	
	this.BirthDay1 = null;
	this.BirthDay2 = null;
	this.BirthDay3 = null;
	
	this.Derivative = null;
	this.Quest10Group = null;
	
	this.InvestorType = null;
	this.InvestorType2 = null;
	
	this.QuestLabel1 = null;
	this.QuestLabel6 = null;
	this.Quest1 = null;
	this.Quest2 = null;
	this.Quest3 = null;
	this.Quest4 = null;
	this.Quest5 = null;
	this.Quest6 = null;
	this.Quest7 = null;
	this.Quest8 = null;
	this.Quest9 = null;
	
	
	this.UserGrade = null;
	this.UserGradeType = null;
	
	this.TrxTp = null;
	
	this.totScore = null;
	
	this.ContentView = null;
	this.ReqPageData = null;
	
}
@extends BasePage;

@function FD1304:onReady()
{
	@super.onReady();
	var thisObj = this;
	
	//계좌번호 비밀번호 로드뷰	
	this.accView = this.findCompById('AccView').viewLoad('FD/view/FD0000_V03.lay');
	this.accDbx = this.accView.accDbx;
	
	thisObj.ContentView = this.findCompById('CenterView');
	
	thisObj.Quest1Group = this.findCompById('Quest1Group');
	thisObj.Quest2Group = this.findCompById('Quest2Group');
	thisObj.Quest4Group = this.findCompById('Quest4Group');
	thisObj.Quest5Group = this.findCompById('Quest5Group');
	thisObj.Quest6Group = this.findCompById('Quest6Group');
	thisObj.Quest7Group = this.findCompById('Quest7Group');
	thisObj.Quest8Group = this.findCompById('Quest8Group');
	thisObj.Quest9Group = this.findCompById('Quest9Group');
	thisObj.Group10Chk = this.findCompById('Group10Chk');
	thisObj.Group11Chk = this.findCompById('Group11Chk');
	
	thisObj.Group1Radio1 = this.findCompById('Group1Radio1');
	thisObj.Group1Radio2 = this.findCompById('Group1Radio2');
	thisObj.Group1Radio3 = this.findCompById('Group1Radio3');
	thisObj.Group1Radio4 = this.findCompById('Group1Radio4');
	thisObj.Group1Radio5 = this.findCompById('Group1Radio5');
	
	thisObj.Group6Radio1 = this.findCompById('Group6Radio1');
	thisObj.Group6Radio2 = this.findCompById('Group6Radio2');
	thisObj.Group6Radio3 = this.findCompById('Group6Radio3');
	
	thisObj.BirthDay1 = this.findCompById('BirthDay1');
	thisObj.BirthDay2 = this.findCompById('BirthDay2');
	thisObj.BirthDay3 = this.findCompById('BirthDay3');
	
	thisObj.Quest10Group = this.findCompById('Quest10Group');
	
	thisObj.Derivative = this.findCompById('Derivative');
	thisObj.InvestorType = this.findCompById('InvestorType');
	thisObj.InvestorType2 = this.findCompById('InvestorType2');
	
	thisObj.QuestLabel1 = this.findCompById('Quest1');
	thisObj.QuestLabel6 = this.findCompById('Quest6');
	
	this.UserGrade = theApp.userInfo.get('UserGrade');
	
};

// 고객등급, 성향조회
@function FD1304:SendData_SACMT110(Type)
{
	// 현재 페이지에 대한 데이터
	var thisObj = this;
	
	//var accList = theApp.accInfo.filterAccList(0); // 계좌번호 리스트 가져오기	
	//var accNo = accList[0]["D1계좌번호"]; // 첫번째 계좌 사용
	
	var accNo = this.accDbx.getSelectedItemData()['D1계좌번호'];
	
	var thisObj = this
		,cont = thisObj // 연결된 최상위 뷰
		,qrName = "SACMT110";			
	
	var certAcc = null;
	var needBirtyDay = false;
	
	if (Type == 'insert') certAcc = accNo;
	
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
				
				if(thisObj.Group11Chk.getCheck() && thisObj.Group10Chk.getCheck()){
					needBirtyDay = true;
				}
				
				var month = thisObj.Derivative.getText() == '' ? '0' : thisObj.Derivative.getText();
				
				InBlock1['D1처리구분'] = thisObj.TrxTp;
				InBlock1['D1고객번호'] = theApp.connectManager.userId,	
				InBlock1['D1개인법인구분'] = thisObj.UserGradeType,
				InBlock1['D1투자권유구분'] = thisObj.Group10Chk.getCheck() ? '1' : '0',
				InBlock1['D1정보제공구분'] = thisObj.Group11Chk.getCheck() ? '1' : '0',
				InBlock1['D1본인대리인구분'] = '0',							
				InBlock1['D1질문1'] = thisObj.Quest1 != '0' ? thisObj.Quest1 : '',
				InBlock1['D1질문2'] = thisObj.Quest2 != '0' ? thisObj.Quest2 : '',
				InBlock1['D1질문3'] = thisObj.Quest3 != '0' ? thisObj.Quest3 : '',
				InBlock1['D1질문4'] = thisObj.Quest4 != '0' ? thisObj.Quest4 : '',
				InBlock1['D1질문5'] = thisObj.Quest5 != '0' ? thisObj.Quest5 : '',
				InBlock1['D1질문6'] = thisObj.Quest6 != '0' ? thisObj.Quest6 : '',
				InBlock1['D1질문7'] = thisObj.Quest7 != '0' ? thisObj.Quest7 : '',
				InBlock1['D1질문8'] = thisObj.Quest9 != '0' ? thisObj.Quest9 : '',
				InBlock1['D1산출등급명'] = thisObj.InvestorType.getText(),
				InBlock1['D1파생상품투자기간'] = month,
				InBlock1['D1정보확인사원번호'] = 'MTS',
				InBlock1['D1생년월일'] = needBirtyDay == true ? thisObj.BirthDay1.getText()+thisObj.BirthDay2.getText()+thisObj.BirthDay3.getText() : '',
				InBlock1['D1조회여부1'] = thisObj.Quest8 != '0' ? thisObj.Quest8 : '',
				InBlock1['D1조회여부2'] = '2',
				InBlock1['D1조회여부3'] = '3',
				InBlock1['D1수량1'] = thisObj.totScore;
				
			}
					
			InBlock1['D1고객구분'] = '1';
			InBlock1['D1실명확인번호'] = accNo;	
		 },
		function(queryData, groupName)
		{					
		
			var errorData = this.getLastError();
			if(errorData.errCode == "0136"){//조회가 완료되었습니다. 정정
				thisObj.TrxTp = '2';
			}else if (errorData.errCode == "3956"){//등록된내역이 없습니다. 최초등록
				thisObj.TrxTp = '1';
			}else if (errorData.errCode == "0131"){//정정 완료
				// 투자자정보확인서 작성/변경 정정완료
				AToast.show('정정이 완료되었습니다.');
				//thisObj.reCalcScroll(0);
				if(thisObj.ReqPageData != null) {
					if(thisObj.ReqPageData.tabId.substring(0, 3) == "FD5") {
						theApp.goPageCheck(thisObj.ReqPageData.returnPageId, false, thisObj.ReqPageData);
					}
					else {
						theApp.goPageCheck('FD3202', false, thisObj.ReqPageData);
					}
				}
			}else if (errorData.errCode == "0198"){//등록 완료
				// 투자자정보확인서 작성/변경 정정완료
				AToast.show('등록이 완료되었습니다.');
				//thisObj.reCalcScroll(0);
				if(thisObj.ReqPageData != null) {
					if(thisObj.ReqPageData.tabId.substring(0, 3) == "FD5") {
						theApp.goPageCheck(thisObj.ReqPageData.returnPageId, false, thisObj.ReqPageData);
					}
					else {
						theApp.goPageCheck('FD3202', false, thisObj.ReqPageData);
					}
				}
			}
			if(queryData)
			{
				queryData.printQueryData();				
				var InBlock1 = queryData.getBlockData('InBlock1')[0];	
				
				theApp.userInfo.set('UserGrade',InBlock1);
				
				thisObj.setFromData(InBlock1);
			}								
			else{
	            if(thisObj.TrxTp == '1'){
			        thisObj.Group10Chk.setCheck(true);
			        thisObj.Group11Chk.setCheck(true);
			    }
			}
		});
		
};

// 조회 화면 세팅
@function FD1304:setFromData(obj)
{
	var thisObj = this;
	var objData = obj;
	var rg_selectId = '';
	
	var BirthDay = objData['D1생년월일'];
	
	if (BirthDay.length == 8){
		thisObj.BirthDay1.setText(BirthDay.substring(0,4));			
		thisObj.BirthDay2.setText(BirthDay.substring(4,6));		
		thisObj.BirthDay3.setText(BirthDay.substring(6,8));		
	}
	
	thisObj.Derivative.setText(objData['D1파생상품투자기간']);	
	thisObj.InvestorType.setText(objData['D1산출등급명']);
	thisObj.InvestorType2.setText(objData['D1산출등급명']);
	
	//투자권유구분
	if(objData['D1투자권유구분'] != '') {
		if (objData['D1투자권유구분'] == '1'|| objData['TrxTp'] == '1') {//최초 등록인경우 디폴트 희망
			thisObj.Group10Chk.setCheck(true);
		} else {
			thisObj.Group10Chk.setCheck(false);
		}
	}

	//정보제공구분
	if(objData['D1정보제공구분'] != '') {
		if (objData['D1정보제공구분'] == '1'|| objData['TrxTp'] == '1') {//최초 등록인경우 디폴트 제공
			thisObj.Group11Chk.setCheck(true);
		} else {
			thisObj.Group11Chk.setCheck(false);
		}
	}
	
	//질문 1번 설정
	if(objData['D1질문1'] != '') {
		rg_selectId = 'Group1Radio' + objData['D1질문1'];
		thisObj.Quest1Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 2번 설정
	if(objData['D1질문2'] != '') {
		rg_selectId = 'Group2Radio' + objData['D1질문2'];
		thisObj.Quest2Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 3번 설정
	if(objData['D1질문3'] != '') {
		rg_selectId = 'Group3Chk' + objData['D1질문3'];
		thisObj.findCompById(rg_selectId).setCheck(true);
	}
	
	//질문 4번 설정
	if(objData['D1질문4'] != '') {
		rg_selectId = 'Group4Radio' + objData['D1질문4'];
		thisObj.Quest4Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 5번 설정
	if(objData['D1질문5'] != '') {
		rg_selectId = 'Group5Radio' + objData['D1질문5'];
		thisObj.Quest5Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 6번 설정
	if(objData['D1질문6'] != '') {
		rg_selectId = 'Group6Radio' + objData['D1질문6'];
		thisObj.Quest6Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 7번 설정
	if(objData['D1질문7'] != '') {
		rg_selectId = 'Group7Radio' + objData['D1질문7'];
		thisObj.Quest7Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 8번 설정
	if(objData['D1조회여부1'] != '') {
		rg_selectId = 'Group8Radio' + objData['D1조회여부1'];
		thisObj.Quest8Group.setSelectBtn(thisObj.findCompById(rg_selectId));
	}
	
	//질문 9번 설정
	if(objData['D1질문8'] != '') {
		rg_selectId = 'Group9Radio' + objData['D1질문8'];
		thisObj.Quest9Group.setSelectBtn(thisObj.findCompById(rg_selectId));		
	}
	
	
	if(objData['D1파생상품투자기간'] == 0 || objData['D1파생상품투자기간'] ==''){
		thisObj.Quest10Group.setSelectBtn(thisObj.findCompById('Group10Radio1'));
		thisObj.Derivative.enable(false);
	}
	else{
		thisObj.Quest10Group.setSelectBtn(thisObj.findCompById('Group10Radio2'));
		thisObj.Derivative.enable(true);
	}
	
	// 2019.11.26. D1산출등급명 이 최종고객성향임.
	// 조회해서 점수로 나온 성향과 위험선호도로 선택한 성향 중 더 낮은 단계 선택이므로 화면 처음 조회할 경우에는 체크 안함.
	//thisObj.Tot_Scoring();
	
};


// 라디오버튼 초기 세팅
@function FD1304:InitRadioBtn()
{
	var thisObj = this;
	
	for(var i = 1; i <= 10; i++){	
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
	}
	
	thisObj.BirthDay1.setText('');
	thisObj.BirthDay2.setText('');
	thisObj.BirthDay3.setText('');
		
};

// 개인 법인 관련 문구 수정
@function FD1304:GrandType()
{
	var thisObj = this;
	
	thisObj.UserGrade = theApp.userInfo.get('UserGrade');
	thisObj.UserGradeType = null;
	
	if (thisObj.UserGrade == undefined){
		thisObj.UserGradeType = '1';
	} else {
		if (thisObj.UserGrade['D1개인법인구분'] == 2) { 	// 법인
			thisObj.UserGradeType = '2';
		} else {
			thisObj.UserGradeType = '1';
		}
	}
	
	if (thisObj.UserGradeType == '2') { 	// 법인		

		thisObj.QuestLabel1.setText('법인 고객님의 자본금 규모는 어떻게 되십니까?(총자본기준)');
		thisObj.Group1Radio1.setText('200억이상');
		thisObj.Group1Radio2.setText('100억이상 ~ 200억미만');
		thisObj.Group1Radio3.setText('50억이상 ~ 100억미만');
		thisObj.Group1Radio4.setText('10억이상 ~ 50억미만');
		thisObj.Group1Radio5.setText('10억미만');
				
		thisObj.QuestLabel6.setText('법인고객님께서는 최근5년간 몇번 당기 순 손실을 기록하셔습니까?(손익계산서기준)');
		thisObj.Group6Radio1.setText('1회이하');
		thisObj.Group6Radio2.setText('2회 ~ 3회');
		thisObj.Group6Radio3.setText('3회초과');		
		
	} else {								// 개인
	
		thisObj.QuestLabel1.setText('고객님의 연령대는 어떻게 되십니까?');
		thisObj.Group1Radio1.setText('19세 이하');
		thisObj.Group1Radio2.setText('20세 ~ 40세');
		thisObj.Group1Radio3.setText('41세 ~ 50세');
		thisObj.Group1Radio4.setText('51세 ~ 60세');
		thisObj.Group1Radio5.setText('60세 이상');
				
		thisObj.QuestLabel6.setText('다음중 고객님의 수입원을 가장 잘 나타내는 것은 어느 것입니까?');
		thisObj.Group6Radio1.setText('현재 일정한 수입이 발생하고 있으며, 향후 현재수준을 유지 또는 증가할 것으로 예상');
		thisObj.Group6Radio2.setText('현재 일정한 수입이 발생하고 있으나, 향후 감소하거나 불안정할 것으로 예상');
		thisObj.Group6Radio3.setText('현재 일정한 수입이 없으며, 연금이 주수입원임');
	}	
};

@function FD1304:Tot_Scoring()
{
	var thisObj = this;
	
	var GSe1 = thisObj.findCompById('Quest1Group').getSelectBtn(),
		GSe2 = thisObj.findCompById('Quest2Group').getSelectBtn(),
		GSe4 = thisObj.findCompById('Quest4Group').getSelectBtn(),
		GSe5 = thisObj.findCompById('Quest5Group').getSelectBtn(),
		GSe6 = thisObj.findCompById('Quest6Group').getSelectBtn(),
		GSe7 = thisObj.findCompById('Quest7Group').getSelectBtn(),
		GSe8 = thisObj.findCompById('Quest8Group').getSelectBtn(),
		GSe9 = thisObj.findCompById('Quest9Group').getSelectBtn();
	
	var check1 = thisObj.findCompById('Group3Chk1').getCheck(),
		check2 = thisObj.findCompById('Group3Chk2').getCheck(),
		check3 = thisObj.findCompById('Group3Chk3').getCheck(),
		check4 = thisObj.findCompById('Group3Chk4').getCheck(),
		check5 = thisObj.findCompById('Group3Chk5').getCheck(),
		nFstIdx = 0, nLastIdx = 0, nLastGrd = '',
		nScore1 = 0, nScore2 = 0, nScore3 = 0, nScore4 = 0, nScore5 = 0, nScore6 = 0, nScore7 = 0, nScore8 = 0, nScore9 = 0;		
		
	thisObj.Quest1 = GSe1 != null ? GSe1.compId.substring(11) : '0';
	thisObj.Quest2 = GSe2 != null ? GSe2.compId.substring(11) : '0';
	thisObj.Quest4 = GSe4 != null ? GSe4.compId.substring(11) : '0';
	thisObj.Quest5 = GSe5 != null ? GSe5.compId.substring(11) : '0';
	thisObj.Quest6 = GSe6 != null ? GSe6.compId.substring(11) : '0';
	thisObj.Quest7 = GSe7 != null ? GSe7.compId.substring(11) : '0';
	thisObj.Quest8 = GSe8 != null ? GSe8.compId.substring(11) : '0';
	thisObj.Quest9 = GSe9 != null ? GSe9.compId.substring(11) : '0';
	
	thisObj.totScore = 0;		
		
	// 1번 질문 	
	if (thisObj.Quest1 == '1' || thisObj.Quest1 == '2') {
		nScore1 = 4;
	} else if (thisObj.Quest1 == '3') {
		nScore1 = 3;
	} else if (thisObj.Quest1 == '4') {
		nScore1 = 2;
	} else if (thisObj.Quest1 == '5') {
		nScore1 = 1;
	} else {
		nScore1 = 0;
	}
	
	// 2번 질문 	
	if (thisObj.Quest2 == '1') {
		nScore2 = 1;
	} else if (thisObj.Quest2 == '2') {
		nScore2 = 2;
	} else if (thisObj.Quest2 == '3') {
		nScore2 = 3;
	} else if (thisObj.Quest2 == '4') {
		nScore2 = 4;
	} else if (thisObj.Quest2 == '5') {
		nScore2 = 5;
	} else {
		nScore2 = 0;
	}
	
	for (var i = 1; i <= 5; i++){
		var chk = 'Group3Chk' + i;
		if(thisObj.findCompById(chk).getCheck()) nScore3 = i;
	}
	
	thisObj.Quest3 = nScore3;
	
	// 4번 질문 	
	if (thisObj.Quest4 == '1') {
		nScore4 = 1;
	} else if (thisObj.Quest4 == '2') {
		nScore4 = 2;
	} else if (thisObj.Quest4 == '3') {
		nScore4 = 3;
	} else if (thisObj.Quest4 == '4') {
		nScore4 = 4;
	} else {
		nScore4 = 0;
	}
	
	// 5번 질문 	
	if (thisObj.Quest5 == '1') {
		nScore5 = 5;
	} else if (thisObj.Quest5 == '2') {
		nScore5 = 4;
	} else if (thisObj.Quest5 == '3') {
		nScore5 = 3;
	} else if (thisObj.Quest5 == '4') {
		nScore5 = 2;
	} else if (thisObj.Quest5 == '5') {
		nScore5 = 1;
	} else {
		nScore5 = 0;
	}
	
	// 6번 질문 	
	if (thisObj.Quest6 == '1') {
		nScore6 = 3;
	} else if (thisObj.Quest6 == '2') {
		nScore6 = 2;
	} else if (thisObj.Quest6 == '3') {
		nScore6 = 1;
	} else {
		nScore6 = 0;
	}
	
	// 7번 질문 	
	if (thisObj.Quest7 == '1') {
		nScore7 = -2;
	} else if (thisObj.Quest7 == '2') {
		nScore7 = 2;
	} else if (thisObj.Quest7 == '3') {
		nScore7 = 4;
	} else if (thisObj.Quest7 == '3') {
		nScore7 = 6;
	} else {
		nScore7 = 0;
	}	
	
	thisObj.totScore = Math.floor((nScore1 + nScore2 + nScore3 + nScore4 + nScore5 + nScore6 + nScore7) * 100 / 32);
	
	if (thisObj.totScore == 0) {
		nFstIdx = -1;
	} else if(thisObj.totScore > 0 && thisObj.totScore <= 20) {
		nFstIdx = 0;
	} else if(thisObj.totScore <= 40) {
		nFstIdx = 1;
	} else if(thisObj.totScore <= 60) {
		nFstIdx = 2;
	} else if(thisObj.totScore <= 80) {
		nFstIdx = 3;
	//} else if(thisObj.totScore > 0 && thisObj.totScore <= 20) {
	} else {
		// 2019.11.26. 총점수로 공격투자형을 세팅하는 부분이 없어서 80점 초과일 경우 공격투자형으로 세팅
		nFstIdx = 4;
	}		
	
	// 법인
	if (thisObj.UserGradeType == '2' 
		&& thisObj.Group10Chk.getCheck()
		&& thisObj.Group11Chk.getCheck()) {
		
		// 2019.11.26. 최종고객성향을 체크할 때 'Group9Radio1~Group9Radio5' 에서 마지막자리(11)를 사용하는데
		// 하단에 값을 체크할때는 0~4까지만 체크하도록 되어있으므로 -1씩을 제거
		// nLastIdx:0, Group9Radio1 : 안정형
		// nLastIdx:1, Group9Radio2 : 안정추구형
		// nLastIdx:2, Group9Radio3 : 위험중립형
		// nLastIdx:3, Group9Radio4 : 적극투자형
		// nLastIdx:4, Group9Radio5 : 공격투자형
		
		nLastIdx = parseInt(thisObj.Quest9-1);
	} else {
		// 개인
		nLastIdx = parseInt(Math.min(nFstIdx, thisObj.Quest9-1));
	}
	
	if (nLastIdx == -1) {
		nLastGrd = '';
	} else if (nLastIdx == 0) {
		nLastGrd = '안정형';
	} else if (nLastIdx == 1) {
		nLastGrd = '안정추구형';
	} else if (nLastIdx == 2) {
		nLastGrd = '위험중립형';
	} else if (nLastIdx == 3) {
		nLastGrd = '적극투자형';
	} else {
		nLastGrd = '공격투자형';
	}
	
	thisObj.InvestorType.setText(nLastGrd);
	thisObj.InvestorType2.setText(nLastGrd);
	thisObj.RadioBtnEnable();
	
};

//계좌번호 변경 시 이벤트
@function FD1304:fnDoSendDataManage()
{
	var thisObj = this;
	
	thisObj.reCalcScroll(0);
	
	thisObj.UserGradeType = null;	
	thisObj.InitRadioBtn(); // 라디오버튼 초기 세팅
	thisObj.GrandType();
	
	thisObj.SendData_SACMT110('select');
	if (this.pageData) thisObj.ReqPageData = this.pageData;
};

@function FD1304:onWillDeactive()
{
	@super.onWillDeactive();
	console.log('onWillDeactive');
	
	var thisObj = this;
	
	thisObj.UserGradeType = null;	
	thisObj.InitRadioBtn(); // 라디오버튼 초기 세팅
	thisObj.GrandType();
	
	thisObj.BirthDay1.setText('');
	thisObj.BirthDay2.setText('');
	thisObj.BirthDay3.setText('');
	
	thisObj.Derivative.setText('');
	thisObj.InvestorType.setText('');
	thisObj.InvestorType2.setText('');
	
	this.accView.doInitAccInfo(4);
	
};

@function FD1304:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	console.log('onActiveDone');
	
	var thisObj = this;
	thisObj.accView.doInitAccInfo(4);
	
	thisObj.reCalcScroll(0);
	
	thisObj.UserGradeType = null;	
	thisObj.InitRadioBtn(); // 라디오버튼 초기 세팅
	thisObj.GrandType();
	
	thisObj.SendData_SACMT110('select');
	if (this.pageData) thisObj.ReqPageData = this.pageData;

	setTimeout(function(){ $("#FD1304--CenterView").forceRedraw();}, 700);
};

@function FD1304:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1304:refreshData() ');
};

@function FD1304:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


@function FD1304:onBTN_AGREE_YESClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	
	//라디오버튼 체크 로직
	if (!thisObj.checkConfirm()) return;
	
	if(!thisObj.Group10Chk.getCheck()){//불원
		thisObj.newWindowInfo(thisObj,function(callRej){																	
			if(callRej == '1'){
				thisObj.SendData_SACMT110('insert');
			}
		});			

	}else if(!thisObj.Group11Chk.getCheck()){//미제공
		thisObj.newWindowInfo(thisObj,function(callRej){	
			if(callRej == '1'){
				thisObj.SendData_SACMT110('insert');	
			}
		});				

	}else{
		thisObj.SendData_SACMT110('insert');
	}
	
};

//투자정보확인서 등록/변경
@function FD1304:newWindowInfo(callObj, callback)
{
	var thisObj = this;
	this.afterCallback = callback;
	
	var win = AWindow.createWindow('FD/window/FD1304_W01.lay', 'FD1304W01');
		
	win.data = {"investType": thisObj.Group10Chk.getCheck(), "infoType":thisObj.Group11Chk.getCheck()}
	win.openCenter(this);	
	
}

@function FD1304:checkConfirm()
{
	var thisObj = this;
	if (thisObj.Group11Chk.getCheck()){
		if (thisObj.Quest1 == '0' ){
			theApp.alert(['1번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(400);
			return false;
		} else if (thisObj.Quest2 == '0' ){
			theApp.alert(['2번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(870);
			return false;
		} else if (thisObj.Quest3 == '0' ){
			theApp.alert(['3번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(1270);
			return false;
		} else if (thisObj.Quest4 == '0' ){
			theApp.alert(['4번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(1850);
			return false;
		} else if (thisObj.Quest5 == '0' ){
			theApp.alert(['5번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(2400);
			return false;
		} else if (thisObj.Quest6 == '0' ){
			theApp.alert(['6번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(2900);
			return false;
		} else if (thisObj.Quest7 == '0' ){
			theApp.alert(['7번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(3300);
			return false;
		} else if (thisObj.Quest8 == '0' ){
			theApp.alert(['8번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(3700);
			return false;
		} else if (thisObj.Quest9 == '0' ){
			theApp.alert(['9번 항목에 대해서 입력하십시오.',' '].join(''),function(){},'');
			thisObj.reCalcScroll(4200);
			return false;
		}
	} 
	
	//불원이거나 미제공인경우 생년월일 입력안받는다
	if(thisObj.Group11Chk.getCheck() && thisObj.Group10Chk.getCheck())
	{
		if(thisObj.BirthDay1.getText().length > 4 
		   || thisObj.BirthDay2.getText() > 12
		   || thisObj.BirthDay3.getText() > 31 
		   || thisObj.BirthDay1.getText().length < 1 
		   || thisObj.BirthDay2.getText() < 1
		   || thisObj.BirthDay3.getText() < 1
		   ){
		   theApp.alert(['생년월일을 정확히 입력하십시오.',' '].join(''),function(){},'');
		   thisObj.reCalcScroll(0);
		   return false;
		}
	}
	
	return true;
}


@function FD1304:onQuestChange(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	thisObj.Tot_Scoring();

};

@function FD1304:onGroup10ChkClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	//if (!thisObj.Group10Chk.getCheck()) thisObj.reCalcScroll(5000);
	if (!thisObj.Group10Chk.getCheck()) thisObj.ContentView.scrollToBottom(); 
	thisObj.Tot_Scoring();
};


@function FD1304:onGroup11ChkClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;	
	
	//if (!thisObj.Group11Chk.getCheck()) thisObj.reCalcScroll(5000);
	if (!thisObj.Group11Chk.getCheck()) thisObj.ContentView.scrollToBottom();
	thisObj.Tot_Scoring();	
};

@function FD1304:RadioBtnEnable()
{

	//TODO:edit here
	var thisObj = this;
	var flag = true;
	if(!thisObj.Group10Chk.getCheck() 
		|| !thisObj.Group11Chk.getCheck()){				
		thisObj.InitRadioBtn();	
		thisObj.Group11Chk.setCheck(false);
	}
	
	thisObj.Group11Chk.enable(thisObj.Group10Chk.getCheck());	
	
	if (!thisObj.Group10Chk.getCheck() 
		|| !thisObj.Group11Chk.getCheck()) {
			flag = false;
	}	
	
	for(var i = 1; i <= 10; i++){	
		if(i != 3){
			var QGname = 'Quest' + i + 'Group';
			thisObj.findCompById(QGname).enable(flag);
			
			var radio = thisObj.findCompById(QGname).getChildren();
			var radioDis = true;
			if (!thisObj.Group10Chk.getCheck() || !thisObj.Group11Chk.getCheck()) radioDis = false;
			
			for (var k = 0; k < radio.length; k++) {
				if (radioDis) {
					radio[k].removeClass('dis');
				} else {
					radio[k].addClass('dis');
				}				
			} //2018.7.25 Line 763~773 최세열 추가
			
			if(i == 10){
				if(flag == false){
					thisObj.Derivative.enable(flag);
				}
				else{
					if(thisObj.Derivative.getText() == '' || thisObj.Derivative.getText()=='0'){
						thisObj.Derivative.enable(false);
					}
					else
						thisObj.Derivative.enable(true);
				}
					
				
				if(flag == true){
					if(thisObj.Derivative.getText() == '' || thisObj.Derivative.getText()=='0'){
						thisObj.Quest10Group.setSelectBtn(thisObj.findCompById('Group10Radio1'));
					}else{
						thisObj.Quest10Group.setSelectBtn(thisObj.findCompById('Group10Radio2'));					
					}
				}

			}
		} else{
			for (var j = 1; j <= 5; j++){
				var chk = 'Group3Chk' + j;
				thisObj.findCompById(chk).enable(flag);
			}
		}
	}		
	
};
@function FD1304:onGroup3Chk(comp, info)
{

	//TODO:edit here
	
	var thisObj = this;
	var CheckId = comp.getComponentId().replace('T','');
	thisObj.findCompById(CheckId).setCheck(!thisObj.findCompById(CheckId).getCheck());
	
	thisObj.onQuestChange(comp, info);
};

@function FD1304:reCalcScroll(position)
{
	var thisObj = this;
	thisObj.ContentView.scrollTo(position); 
	
};
@function FD1304:onBtnInfoClick(comp, info)
{
	//TODO:edit here
	var win = AWindow.createWindow('FD/window/FD1304_W02.lay','FD1304W02');
	win.open(this,0,0,'100%','100%');
	
};

//아니오
@function FD1304:onRadioButton47Click(comp, info)
{

	//TODO:edit here
	this.Derivative.setText('0');
	this.Derivative.enable(false);
	

};

//예
@function FD1304:onRadioButton48Click(comp, info)
{

	//TODO:edit here
	this.Derivative.setText('0');
	this.Derivative.enable(true);

};
