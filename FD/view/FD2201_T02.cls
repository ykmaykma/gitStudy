
/**
Constructor
Do not call Function in Constructor.
*/
@class FD2201_T02()
{
	@super();
	this.tvManager = null;
}
@extends AView;


//초기화
@function FD2201_T02:onArrInit()
{
};


@function FD2201_T02:init(context, evtListener)
{
	@super.init(context, evtListener);	
	
	// 약정계좌(계좌명, 은행코드, 은행계좌번호, 사용자명, 종합계좌번호)
	this.acntInfo = {
		"accNm": "",
		"bankNm": "",
		"bankAccNo": "",
		"userNm": "",
		"accNo": ""
	}
	
	this.tvManager = new TabViewManager();
	this.tvManager.initManager(this.findCompById('LoadView'), new RadioBtnManager(this));
	
	//탭뷰매니저 초기화
	this.tvManager.addTab({name:'Tab01', url:'FD/view/FD2201_V01.lay', tabId:'TabBtn1'});
	this.tvManager.addTab({name:'Tab02', url:'FD/view/FD2201_V02.lay', tabId:'TabBtn2'});
};


//화면이 활성화된 후 이벤트
@function FD2201_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	this.setAcntInfo();
	this.tvManager.changeTab('TabBtn1');
};

@function FD2201_T02:setAcntInfo(accNm, bankNm, bankAccNo, userNm, accNo) {
	this.acntInfo.accNm = accNm;
	this.acntInfo.bankNm = bankNm;
	this.acntInfo.bankAccNo = bankAccNo;
	this.acntInfo.userNm = userNm;
	this.acntInfo.accNo = accNo;
}

@function FD2201_T02:fnDoSendDataManage()
{
	if(this.tvManager.getActiveView() && this.tvManager.getActiveView().fnDoSendDataManage){
		this.tvManager.getActiveView().fnDoSendDataManage();
	}	
};