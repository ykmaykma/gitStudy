
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_T02()
{
	@super();
	
	//TODO:edit here
	
	this.fundDataCode = null;	
	this.tbvManager = null;
}
@extends AView;


@function FD3202_T02:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	//TODO:edit here

	this.tabView = this.findCompById('CenterView');	
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView, new RadioBtnManager(this));

	this.tbvManager.addTab({url:'FD/view/FD3202_V01.lay', tabId:'FD3202_V01', name:'펀드더 보기'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V02.lay', tabId:'FD3202_V02', name:'고객투자성향 변동 확인'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V03.lay', tabId:'FD3202_V03', name:'부적합 금융투자상품 거래 확인'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V04.lay', tabId:'FD3202_V04', name:'펀드가입약관확인'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V05.lay', tabId:'FD3202_V05', name:'투자자 체크리스트'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V06.lay', tabId:'FD3202_V06', name:'펀드납입정보입력'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V07.lay', tabId:'FD3202_V07', name:'펀드매수정보완료'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V08.lay', tabId:'FD3202_V08', name:'자동이체약정등록'});
	this.tbvManager.addTab({url:'FD/view/FD3202_V09.lay', tabId:'FD3202_V09', name:'펀드매수완료'});
	
	this.tbvManager.addTab({url:'FD/view/FD3202_V10.lay', tabId:'FD3202_V10', name:'자동대체약정등록'});
			
	this.tbvManager.addTab({url:'FD/view/FD3202_V31.lay', tabId:'FD3202_V31', name:'펀드상세보기'});
				
};

//화면이 활성화된 후 이벤트
@function FD3202_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	// 상단 타이틀바 제목 세팅
	cont.titleLbl.setText('펀드 더보기');

	if(cont.pageData != undefined){
		if(cont.pageData.tabSubId){
			//투자자정보확인서를 작성 한 후 재조회함.
			thisObj.userGrdTrxTp = '3'; // 투자자등록확인서 조회
			
				if(cont.pageData.tabSubId == "FD3202_V06"){
					//스크롤 영역 변경
					cont.view5.$ele.css({
						'top': '0px'		
					});	
					cont.view5.setHeight(cont.view5.getHeight() + cont.scrToolView.getHeight());

					cont.fundNowBuyStep = 1; // 현재단계 입력
					cont.fundAllBuyStep = 2; // 총단계 입력				
					thisObj.tbvManager.changeTab(cont.pageData.tabSubId);

				}else if(cont.pageData.tabSubId == "FD3202_VCHECK"){

					//스크롤 영역 변경
					cont.view5.$ele.css({
						'top': '0px'		
					});	
					cont.view5.setHeight(cont.view5.getHeight() + cont.scrToolView.getHeight());

					cont.userGradeCheck(thisObj, function(oBlock){
						if(cont.g_UserInvstCnvsGubun == "0" || cont.g_UserInfoPrvdGubun == "0"){	
							cont.fundNowBuyStep = 3; // 현재단계 입력
							cont.fundAllBuyStep = 6; // 총단계 입력
							thisObj.tbvManager.changeTab("FD3202_V04");
						}else{			
							cont.fundNowBuyStep = 1; // 현재단계 입력
							cont.fundAllBuyStep = 6; // 총단계 입력
							thisObj.tbvManager.changeTab("FD3202_V02");
						}
					});
				}else{
					thisObj.tbvManager.changeTab('FD3202_V01');		
				}						
		}else{
			thisObj.tbvManager.changeTab('FD3202_V01');	
		}
	}else{
		thisObj.tbvManager.changeTab('FD3202_V01');
	}	
};


// 현재는 필요하지 않은 부분
/*
//AccDropView 로드뷰에서 호출하는 함수
@function FD3202_T01:fnDoSendDataManage()
{
	
	//탭값 초기화
	this.doTabViewSendData();
		
};

//탭 서브뷰 데이터 호출
@function FD3202_T01:doTabViewSendData()
{

	//선택 탭
	var actTab = this.tbvManager.getActiveTab();
	//선택 뷰
	var activeView = this.tbvManager.getActiveView();		
	
	if(activeView && activeView.sendDataManage)
	{		
		activeView.sendDataManage(activeView.data);
		if(!actTab.data) actTab.data = false;
	}	
};

*/
