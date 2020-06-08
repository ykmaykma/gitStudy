
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1503()
{
	@super();

	//TODO:edit here	
	
}
@extends BasePage;


@function FD1503:onReady()
{
	var thisObj = this;
	
	//계좌번호 비밀번호 로드뷰	
	thisObj.accView = thisObj.findCompById('AccView');
	thisObj.accView.viewLoad('FD/view/FD0000_V00.lay');
	
	// 테스트해야 하므로 일단 일반계좌만 올림
	thisObj.accView.getLoadView().doInitAccInfo(4);  // 일반계좌
	
	//계좌드롭박스
	thisObj.accDbx = thisObj.accView.getLoadView().accDbx;
	thisObj.secureTxf = thisObj.accView.getLoadView().secureTxf;
	
	// 선택일자
	thisObj.picker = thisObj.findCompById('DatePicker1');	
	thisObj.lblDate = thisObj.findCompById('lblDate');
	thisObj.selectDate = null; // 선택일자
	
	thisObj.toDay = thisObj.toDay = MetaInfo.fnGetToday('NUMDATE'); // 현재 일자 조회
	
	// 당일의 전월로만 세팅함.
	//var calcDate = new Date(thisObj.toDay.substring(0,4), Number(thisObj.toDay.substring(4,6)-2), thisObj.toDay.substring(6,8)).format('yyyyMMdd');
	
	//thisObj.selectDate = calcDate;
			
	// 당일의 전월 마지막 일로 선택일자 입력 - 나중에 필요하면 사용
	//thisObj.selectDate = thisObj.calcInitDate(thisObj.toDay);
	thisObj.selectDate = thisObj.makeBaseDate(thisObj.toDay,true);
				
	//thisObj.selectDate = "20191015"; // 선택일자 입력(가입력-결합테스트에서는 2019.10. 만 데이터가 있음)
		
	thisObj.picker.setValue(thisObj.selectDate); // 달력 컴포넌트 입력	
	
	// RadioButton - 일반계좌, 연금계좌
	thisObj.radioButton1 = thisObj.findCompById('RadioButton1');	
	thisObj.radioButton2 = thisObj.findCompById('RadioButton2');	
	
	// 주요 데이터 뷰 화면
	thisObj.ContentView = thisObj.findCompById('View2');
	
	// 1.기본정보 그리드
	thisObj.evalGrid = thisObj.findCompById('evalGrid');
	
	// 2. 주요정보
	thisObj.fixedGrid1 = thisObj.findCompById('FixedGrid1');
	
	thisObj.doSetFilterToGrid();	
	
	thisObj.label50 = thisObj.findCompById('Label50'); // 주요정보 세팅 Label
		
	// 화면 초기 로드시 일반 계좌 선택
	thisObj.findCompById('RadioGroup1').setSelectBtn(thisObj.findCompById('RadioButton1'));	
	
};

// 당일의 지난 달로 변경하고 마지막 일자로 변경하는 함수 생성
@function FD1503:calcInitDate(calcDate)
{
	// Date 함수에서는 0이 1월, 11이 12월임.
	var calDateYear = calcDate.substring(0,4);
	var calDateMonth = calcDate.substring(4,6);
	var calDateDay = calcDate.substring(6,8);
			
	//              01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12
	var lastDate = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	
	if(calDateYear % 4 === 0 && calDateYear % 100 !== 0 || calDateYear % 400 === 0){
		lastDate[1] = 29;
	}
			
	// 1차 계산완료
	var calDate1 = new Date(calDateYear, Number(calDateMonth-2), calDateDay).format('yyyyMMdd');		
	var calDate1Year = calDate1.substring(0,4);
	var calDate1Month = calDate1.substring(4,6);
	var calDate1Day = calDate1.substring(6,8);
	
	// 해당 월에 따른 마지막 일자 계산
	var calDate2 = new Date(calDate1Year, Number(calDate1Month-1), Number(lastDate[calDate1Month-1])).format('yyyyMMdd');	
	
	var resultDate = calDate2;
	
	return resultDate;
	
};

//calculate and display previous month from picked yyyy/mm/lastday
@function FD1503:makeBaseDate(pickDate,bInit)
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
};


// 그리드 필터 
@function FD1503:doSetFilterToGrid()
{				
	function ufnAddDay(value)
	{
		value = value + " 일";
		return value;		
	}
	
	function ufnSubAccExp(value)
	{
		value = value.substring(0,3) + "-" + value.substring(3,5) + "-" + value.substring(5,11) + "-" + value.substring(11,14);
		return value;		
	}
	
	// 0 - 제목
	// 0, 	상품명, 	0, 	최초투자일자
	// 0, 	계좌번호, 	0, 	투자기간
	// 0, 	잔고좌수, 	0, 	정보제공기준시점
	this.evalGrid.setMaskInfo([ 0, 0, 0, Utils.formatDotDate,
								0, ufnSubAccExp, 0, ufnAddDay,
								0, 15, 0, Utils.formatDotDate]);									
	
	// 0 - 제목
	// 0, 투자원금,
	// 0, 0, 중간환매대금 - 비용차감전
	// 0, 0, 중간환매대금 - 비용차감후
	// 0, 수수료.보수 - 
	// 0, 수수료.보수 - 판매수수료율 + 총보수율
	// 0, 평가금액
	// 0, 0, 환매예상금액 - 차감 예상액(환매수수료, 세금 등)
	// 0, 0, 환매예상금액 - 환매예상금액
	// 0, 0, 누적수익률 - 비용차감전
	// 0, 0, 누적수익률 - 비용차감후
	// 0, 0, 연환산수익률 - 비용차감전
	// 0, 0, 연환산수익률 - 비용차감후
	// this.fixedGrid1; // 데이터 형식 직접 세팅해야 함.
		
};

@function FD1503:onActiveDone(reload)
{
	@super.onActiveDone(reload);
			
	// 계좌세팅(투신상품만 조회) -> 2019.06.19 연금계좌 조회추가
	if(this.findCompById('RadioGroup1').getSelectBtn().compId == 'RadioButton1'){
		this.setDropBoxByRadioBtn('04');
	}
	else if(this.findCompById('RadioGroup1').getSelectBtn().compId == 'RadioButton2'){
		this.setDropBoxByRadioBtn('05');
	}
			
	this.lblDate.setText(this.selectDate.substring(0,4) + "년 " + this.selectDate.substring(4,6) + "월");
	
	this.reCalcScroll(0);
	
	this.initDataClear();

};

// 데이터 클리어
@function FD1503:initDataClear(position)
{
		
	// 상단 그리드 초기화
	this.evalGrid.setCellText(0,1,"");
	this.evalGrid.setCellText(0,3,"");
	this.evalGrid.setCellText(1,1,"");
	this.evalGrid.setCellText(1,3,"");
	this.evalGrid.setCellText(2,1,"");
	this.evalGrid.setCellText(2,3,"");
	
	var lblMainContentText =[]; // 주요 정보	
	
	lblMainContentText.push("<span class='fc_s_gray'>\"정보제공 시점인(" + " " + ")기준으로 고객님께서 투자하신 " + " " + "</span><span class='Color_333'>의 평가금액은 (" + " " + "), 누적 수익률은 (" + " " + ")</span><span class='fc_s_gray'>입니다.</span>\"");
	
	this.label50.$ele.children().eq(0).html(lblMainContentText);			
	
	// 하단 그리드 내용 초기화
	this.fixedGrid1.setCellText(0,2,"");
	this.fixedGrid1.setCellText(1,2,"");
	this.fixedGrid1.setCellText(2,2,"");
	this.fixedGrid1.setCellText(3,2,"");
	this.fixedGrid1.setCellText(4,2,"(판매수수료율: " + ",<br/>" +  "총보수율: " + ")");
	
	this.fixedGrid1.setCellText(5,0,"총 투자원금(" + " " + ")에서 중간환매대금(" + " " + ") 및 수수료·보수(" + " " + ")를 차감하고 자산운용사가 운용한 결과가 평가금액(" + " " + ")입니다.(보다 자세한 운용내용은 자산운용보고서 참조)");

	this.fixedGrid1.setCellText(6,2,"");
	this.fixedGrid1.setCellText(7,2,"");
	this.fixedGrid1.setCellText(8,2,"");
	this.fixedGrid1.setCellText(9,2,"");
	this.fixedGrid1.setCellText(10,2,"");
	this.fixedGrid1.setCellText(11,2,"");
	this.fixedGrid1.setCellText(12,2,"");
	
};

// 주요 데이터 출력 뷰 세로 스크롤 위치 작업
@function FD1503:reCalcScroll(position)
{
	var thisObj = this;
	thisObj.ContentView.scrollTo(position); 
};

// 일반계좌 RadioButton Click
@function FD1503:onRadioButton1Click(comp, info)
{
	//TODO:edit here
	this.setDropBoxByRadioBtn('04'); 
};

// 연금계좌 RadioButton Click
@function FD1503:onRadioButton2Click(comp, info)
{

	//TODO:edit here
	this.setDropBoxByRadioBtn('05'); 
};

// RadioButton 선택에 따른 계좌 로드
@function FD1503:setDropBoxByRadioBtn(type)
{
	if(type == '04'){
		this.accView.getLoadView().doInitAccInfo(4);  // 일반계좌
	}else if(type == '05'){
		this.accView.getLoadView().doInitAccInfo(5);  // 연금계좌
	}		
};

@function FD1503:onBtnSelFundClick(comp, info)
{

	
	//TODO:edit here
	var thisObj = this;
	var cipherData = thisObj.secureTxf.getCipherData();
	
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호'])
	{
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
	
	var win = AWindow.createWindow('FD/window/FD1503_W00.lay','FD150300');
	
	win.setWindowOption({isFocusLostClose: false, overflow: 'scroll'});
	
	win.accDbx = thisObj.accDbx.getSelectedItemData()['D1계좌번호']; // 계좌번호
	win.selDateMM = thisObj.selectDate.substring(0,6);
	
	win.openAsDialog(this);
		
};

//윈도우 결과 수신
@function FD1503:onWindowResult(resultData, awindow)
{
	var thisObj = this,
		winId = awindow.getId();			
	
	if(!resultData) return;
	
	// 자동펀드매수 팝업 선택
	if(winId =='FD150300'){
		if(resultData){		
			thisObj.fnFundInfoDataManage(resultData);
		}
	}
};

@function FD1503:fnFundInfoDataManage(resultData)
{		
	//TODO:edit here
			
	var thisObj = this;
	var selAccInfo = thisObj.accDbx.getSelectedItemData()['D1계좌번호'];
	var cipherData = thisObj.secureTxf.getCipherData();
	var qrName = 'SOFFQ603';		
	
	thisObj.sendData(qrName, function(queryData, groupName)
	{
		var InBlock1 = queryData.getBlockData('InBlock1')[0];
		
		InBlock1['D1계좌번호'] = resultData["D1서브계좌번호"];						
		InBlock1['D1기준월'] = thisObj.selectDate.substring(0,6); // 선택한 년월(ex:201910)

		if(afc.isSimulator) queryData.printQueryData();

	},
	function(queryData, groupName)
	{
		var errCode = this.getLastError('errCode');
		var errMsg = this.getLastError('errMsg');

		if(!queryData)
		{
			AToast.show(this.getLastError('errMsg'));
			thisObj.contiKey = null;
			return;
		}else{
			if(afc.isSimulator) queryData.printQueryData();

			var OutBlock1 = queryData.getBlockData('OutBlock1')[0];						
			
			var lblMainContentText =[]; // 주요 정보
						
			lblMainContentText.push("<span class='fc_s_gray'>\"정보제공 시점인(" + Utils.formatDotDate(OutBlock1["D1기준일"]) + ")기준으로 고객님께서 투자하신 " + OutBlock1["D1한글투신펀드명"] + "</span><span class='Color_333'>의 평가금액은 (" + afc.addComma(OutBlock1["D1평가금액"]) + "원), 누적 수익률은 (" + afc.floor2Per(OutBlock1["D1세후수익률"]) + ")</span><span class='fc_s_gray'>입니다.\" </span>");
			
			thisObj.label50.$ele.children().eq(0).html(lblMainContentText);
			
			// PB7979 화면에서는 수익률 기준 소수점 2째자리 버림 처리(확인일:2019.12.06)
			thisObj.fixedGrid1.setCellText(0,2,afc.addComma(OutBlock1["D1투자원금"]) + " 원");
			thisObj.fixedGrid1.setCellText(1,2,afc.addComma(OutBlock1["D1펀드환매금액"]) + " 원");
			thisObj.fixedGrid1.setCellText(2,2,afc.addComma(OutBlock1["D1펀드환매금액2"]) + " 원");
			thisObj.fixedGrid1.setCellText(3,2,afc.addComma(OutBlock1["D1보수금액"]) + " 원");
			thisObj.fixedGrid1.setCellText(4,2,"(판매수수료율: " + afc.floor2Per(OutBlock1["D1판매수수료율"]) + ",<br/>" +  "총보수율: " + afc.floor2Per(OutBlock1["D1보수율"]) + ")"); // 나중에 올림, 반올림, 버림 확인 필요
			
			thisObj.fixedGrid1.setCellText(5,0,"총 투자원금(" + afc.addComma(OutBlock1["D1투자원금"]) + ")에서 중간환매대금(" + afc.addComma(OutBlock1["D1펀드환매금액2"]) + ") 및 수수료·보수(" + afc.addComma(OutBlock1["D1보수금액"]) + ")를 차감하고 자산운용사가 운용한 결과가 평가금액(" + afc.addComma(OutBlock1["D1평가금액"]) + ")입니다.(보다 자세한 운용내용은 자산운용보고서 참조)");
			
			thisObj.fixedGrid1.setCellText(6,2,afc.addComma(OutBlock1["D1평가금액"]) + " 원");
			thisObj.fixedGrid1.setCellText(7,2,afc.addComma(OutBlock1["D1환매수수료합계금액"]) + " 원");
			thisObj.fixedGrid1.setCellText(8,2,afc.addComma(OutBlock1["D1예상금액"]) + " 원");			
			thisObj.fixedGrid1.setCellText(9,2,afc.floor2Per(OutBlock1["D1세전수익률"]));			
			thisObj.fixedGrid1.setCellText(10,2,afc.floor2Per(OutBlock1["D1세후수익률"]));			
			thisObj.fixedGrid1.setCellText(11,2,afc.floor2Per(OutBlock1["D1년수익률"]));			
			thisObj.fixedGrid1.setCellText(12,2,afc.floor2Per(OutBlock1["D1연환산수익률"]));
		}
	});		
};

// 달력 변경한 뒤 입력값 저장
@function FD1503:onDatePicker1Change(comp, info)
{

	//TODO:edit here
	this.selectDate = this.picker.getValue();
	
	this.lblDate.setText(this.selectDate.substring(0,4) + "년 " + this.selectDate.substring(4,6) + "월");
	
};

// Back Button
@function FD1503:onBackBtnClick(comp, info)
{

	//TODO:edit here
	theApp.goPrevPageCheck(false);
};


