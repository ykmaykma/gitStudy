
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5003_V03()
{
	@super();		
}
@extends AView;


@function FD5003_V03:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	// Object
	this.cont = this.getContainer();
	this.contTab = this.cont.tvManager.getActiveView();
	
	// 스크롤 관련 영역
	this.view3 = this.findCompById('View3');
	
	// 펀드약관확인
	this.lblStep = this.findCompById('lblStep'); // 단계
	this.btnNext4 = this.findCompById("btnNext4"); // 다음 버튼
	this.label6 = this.findCompById('Label6'); 		// 집합투자규약
	this.cbContent1 = this.findCompById('cbContent1'); // 집합투자규약 내용확인 체크박스
	this.cbContent2 = this.findCompById('cbContent2'); // 간이투자설명서 내용확인 체크박스
};


// 뷰의 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5003_V03:onWillActive(reload)
{
	@super.onWillActive(reload);
	
	// 컴포넌트 초기화
	this.onInitComponents();
	
	// 매수단계 셋팅
	this.setFundStepInfo();
	
	// 매매가능상태 조회
	this.checkTradeState();
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5003_V03:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};
	

// 뷰 비활성화가 시작되기 바로 전에 매번 호출된다
@function FD5003_V03:onWillDeactive(reload)
{		
	@super.onWillDeactive(reload);
	
	//스크롤 영역 변경	
	this.view3.scrollTo(0);
};


// 컴포넌트 초기화
@function FD5003_V03:onInitComponents()
{
	// 다음 버튼 비활성화
	this.btnNext4.enable(false);
	
	// 체크박스 체크 해제
	this.cbContent1.setCheck(false);
	this.cbContent2.setCheck(false);
	
	// 집합투자규약 버튼명 셋팅
	this.fundCd = this.cont.selectFundInfo["D1투신펀드코드"];
	var fundUrl = this.cont.fundCdURL(this.fundCd);
	this.label6.setText('집합투자규약');
	
	if(fundUrl['판매사코드'] == '0200') // 메리츠더우먼
	{
		this.label6.setText('정관');
	}
};


// 매수단계 셋팅
@function FD5003_V03:setFundStepInfo()
{
	// 펀드매수단계 셋팅
	var txtStep = "<span class='fc_red3'>" + this.cont.fundStepNow + "</span>"
					+ "<span class='step'>/" + this.cont.fundStepAll + "단계</span>";
	this.lblStep.$ele.children().eq(0).html(txtStep);
};


// 매매가능상태 조회
@function FD5003_V03:checkTradeState()
{
	this.contTab.checkTradeState(this, this.contTab);
};


// checkTradeState 콜백함수
@function FD5003_V03:callbackCheckTradeState(param)
{
	var trdSt = param['매매가능상태']; // 1: 일반펀드매수매도, 2: 예약펀드매수매도, 3: 펀드매수매도불가, 4:당일예약펀드매수매도
	
	if(trdSt == 3)
	{
		// 펀드매수매도불가안내팝업
		this.contTab.tradeDisablePopup();	
	}
	else if(trdSt == 1 || trdSt == 2 || trdSt == 4)
	{
	
	}
};


// 집합투자규약 버튼 클릭
@function FD5003_V03:oncbContent1Click(comp, info)
{
	var fundCd = this.cont.selectFundInfo["D1투신펀드코드"];
	var fundUrl = this.cont.fundCdURL(fundCd);
	var title = '집합투자규약';
	
	if(fundUrl['판매사코드'] == '0200') // 메리츠더우먼
		title = '정관';
	
	// 팝업 오픈
	var param = {
		viewUrl : fundUrl['집합투자규약'],
		viewPdfUrl : fundUrl['집합투자규약_pdf'],
		title 	: title,
		btnType : "0"
	}
	PensionCommon.fullSizePdfPopup(this, param);

	// 한번이라도 클릭하면 체크가 해제되지 않도록 변경
	if(!this.cbContent1.getCheck()) 
	{
		// 체크박스 값이 true 에서 false 로 변경되는 순간 true 로 강제 세팅
		this.cbContent1.setCheck(true);
	}
	
	// 다음 버튼 활성화 체크
	this.oncbContentClick();
};


// 간이투자설명서 버튼 클릭
@function FD5003_V03:oncbContent2Click(comp, info)
{
	var fundCd = this.cont.selectFundInfo["D1투신펀드코드"];
	var fundUrl = this.cont.fundCdURL(fundCd);
	
	// 팝업 오픈
	var param = {
		viewUrl : fundUrl['간이투자설명서'],
		viewPdfUrl : fundUrl['간이투자설명서_pdf'],
		title 	: "간이투자설명서",
		btnType : "0"
	}
	PensionCommon.fullSizePdfPopup(this, param);

	// 한번이라도 클릭하면 체크가 해제되지 않도록 변경
	if(!this.cbContent2.getCheck()) 
	{
		// 체크박스 값이 true 에서 false 로 변경되는 순간 true 로 강제 세팅
		this.cbContent2.setCheck(true);
	}
	
	// 다음 버튼 활성화 체크
	this.oncbContentClick();
};


// 다음단계 버튼 활성화 체크
@function FD5003_V03:oncbContentClick(comp, info)
{	
	if(this.cbContent1.getCheck() && this.cbContent2.getCheck())
	{
		this.btnNext4.enable(true); // 활성화
	}
	else
	{
		this.btnNext4.enable(false); // 비활성화
	}
};


// 다음단계 클릭
@function FD5003_V03:onbtnNext4Click(comp, info)
{
	// 펀드매수단계 셋팅
	this.cont.fundStepNow = this.cont.fundStepNow + 1; // 4단계
	
	// 펀드등급조회로 이동
	this.contTab.tbvManager.changeTab('FD5003_V04');
};


