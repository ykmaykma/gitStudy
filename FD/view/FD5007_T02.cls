/**
Constructor
Do not call Function in Constructor.
*/
@class FD5007_T02()
{
	@super();	
}
@extends AView;


@function FD5007_T02:init(context, evtListener)
{
	@super.init(context, evtListener);

	// Object
	this.cont = this.getContainer();
	
	// 계좌
	this.accView = this.cont.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx; 			// 계좌드롭박스
	this.secureTxf = this.accView.secureTxf;	// 계좌비밀번호
	
	// 서브탭
	this.button1 = this.findCompById('Button1');	// 계좌현황
	this.button2 = this.findCompById('Button2');	// 예상연금액
	this.button3 = this.findCompById('Button3');	// 예상세금액
	this.subTabBtns = [
		{ btnComp : this.button1, btnVal : '0', tabId : 'FD5007_T03' },
		{ btnComp : this.button2, btnVal : '1', tabId : 'FD5007_T04' },
		{ btnComp : this.button3, btnVal : '2', tabId : 'FD5007_T05' }
	];
	
	// 서브탭 뷰
	this.tabView = this.findCompById('TabView1');	
	
	this.tbvManager = new TabViewManager();	
	this.tbvManager.initManager(this.tabView, new RadioBtnManager(this));		

	this.tbvManager.addTab({url:'FD/view/FD5007_T03.lay', tabId:'FD5007_T03', name:'계좌현황'});
	this.tbvManager.addTab({url:'FD/view/FD5007_T04.lay', tabId:'FD5007_T04', name:'예상연금액'});
	this.tbvManager.addTab({url:'FD/view/FD5007_T05.lay', tabId:'FD5007_T05', name:'예상세금액'});
};


// 뷰의 활성화가 시작되기 바로 전에 매번 호출된다
@function FD5007_T02:onWillActive(reload)
{
	@super.onWillActive(reload);
	
	// 서브탭 초기화
	this.onInitSubTabData();
	
	this.fnDoSendDataManage();
};


// 뷰 활성화 과정이 모두 종료되면 매번 호출된다
@function FD5007_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};
	

// 뷰 비활성화가 시작되기 바로 전에 매번 호출된다
@function FD5007_T02:onWillDeactive(reload)
{		
	@super.onWillDeactive(reload);
};


// 서브탭 초기화
@function FD5007_T02:onInitSubTabData()
{
	// 서브탭 셋팅
	this.selectTabId = 'FD5007_T03'; 
	
	// 서브탭 활성화
	this.onSubTabEnable(0);
};


// 컴포넌트 초기화
@function FD5007_T02:onInitComponents()
{	
	
};


// 계좌번호 변경 시 이벤트
@function FD5007_T02:fnDoSendDataManage()
{
	// 계좌번호 저장
	PensionCommon.setFundAcc(this);
	
	// 컴포넌트 초기화
	this.onInitComponents();
	
	// 서브탭 이동
	this.onSubTabChange();	
};


// 서브탭 클릭
@function FD5007_T02:onButtonClick(comp, info)
{
	// 서브탭 활성화
	if(comp == this.button1) // 계좌현황
	{
		this.onSubTabEnable(0);
	}
	else if(comp == this.button2) // 예상연금액
	{
		this.onSubTabEnable(1);
	}
	else if(comp == this.button3) // 예상세금액
	{
		this.onSubTabEnable(2);
	}
	
	// 서브탭 이동
	this.onSubTabChange();
};


// 서브탭 활성화
@function FD5007_T02:onSubTabEnable(selectVal)
{
	var tabs = this.subTabBtns;

	// 탭 활성화
	for(var i = 0; i < tabs.length; i++)
	{
		tabs[i].btnComp.enable(true);
		
		if(selectVal == tabs[i].btnVal)
		{
			// 서브탭 활성화
			tabs[i].btnComp.enable(false);
			
			// 선택된 서브탭 셋팅
			this.selectTabId = tabs[i].tabId ;	
		}
	}
};


// 서브탭 이동
@function FD5007_T02:onSubTabChange()
{
	this.tbvManager.changeTab(this.selectTabId, false);
};


