
/**
비대면 계좌개설 main container: 황청유
*/
@class MS1005()
{
	@super();

	this.currentOffset = 0;
	this.pageArr =
	[
		{'name':'MS1005_T02','page':'FD/view/MS1005_T02.lay','step':1,'title':'STEP 1. 신분증확인'},
		{'name':'MS1005_T16','page':'FD/view/MS1005_T16.lay','step':2,'title':'STEP 2. 휴대폰 영상 촬영'},
		{'name':'MS1005_T05','page':'FD/view/MS1005_T05.lay','step':3,'title':'STEP 3. 휴대폰 본인확인'},	//saveStep2
		{'name':'MS1005_T06','page':'FD/view/MS1005_T06.lay','step':4,'title':'STEP 4. 고객정보1'},		//saveStep3
		{'name':'MS1005_T07','page':'FD/view/MS1005_T07.lay','step':4,'title':'STEP 4. 고객정보2'},
		{'name':'MS1005_T01','page':'FD/view/MS1005_T01.lay','step':5,'title':'STEP 5. 약관동의'},			//saveStep4
		{'name':'MS1005_T11','page':'FD/view/MS1005_T11.lay','step':5,'title':'STEP 5. 개인정보동의'},		
		{'name':'MS1005_T13','page':'FD/view/MS1005_T13.lay','step':6,'title':'STEP 6. 계좌개설신청'},		//saveStep6
		{'name':'MS1005_T08','page':'FD/view/MS1005_T08.lay','step':7,'title':'STEP 7. ID 등록'},			//saveStep8
		{'name':'MS1005_T09','page':'FD/view/MS1005_T09.lay','step':8,'title':'STEP 8. 신청완료'}			 //saveStep99
	];
}
@extends BasePage;


@function MS1005:onReady()
{
	@super.onReady();
	
	theApp.accFrmPage = this;
	
	this.titleLbl = this.findCompById('TitleLbl');
	this.mainView = this.findCompById('MainView');
	this.naviText = this.findCompById('NaviText');
	this.naviLbls = this.findCompByGroup('NaviLblgr');
	this.homeView = this.findCompById("HomeView");
	
	this.testLbl = this.findCompById("TestLbl");
	
	if(Define.RT) {
		this.testLbl.show(AComponent.VISIBLE);
		this.testLbl.setText("Real Test");
	} else if(!Define.RELEASE) {
		this.testLbl.show(AComponent.VISIBLE);
	} else {
		this.testLbl.show(AComponent.GONE);
	}
	
	//이어하기 시 이전에 작성한 페이지로 이동 못하게 하는 화면
	this.continuePage = 0;
};

@function MS1005:onActive(reload)
{
	@super.onActive(reload);
	if(reload) {
		AppManager.endOltp();
		AppManager.hidePatchView();
	}
	
	theApp.initNotice();
	 
	this.mainView.removeAllTab();
	this.tbvManager = this.makeTabViewManager(this.mainView, this);
	
	for(var i =0; i<this.pageArr.length; i++) {
		this.tbvManager.addTab({name:this.pageArr[i].name, url:this.pageArr[i].page, tabId:this.pageArr[i].name});
	}
	
	this.titleLbl.setText('계좌개설');
	
	//이어하기 시...
	if(this.pageData && this.pageData[0]) {
		this.goPrevActionPage(this.pageData[0]);
	} else {
		this.drawPage();
	}
	
	this.checkPageTabViewHeight();
};

//화면이 소멸된 후 이벤트
@function MS1005:onWillDeactive()
{
	@super.onWillDeactive();
	this.resetPage();
};

//페이지 리셋
@function MS1005:resetPage()
{
	this.currentOffset = 0;
	this.tbvManager.tabView.clearSelectTab();
};

//페이지 리셋
@function MS1005:goPrevActionPage(pageIdx)
{
	this.currentOffset = 0;
	
	//"이어서 진행인 경우+진행단계가 휴대폰본인인증인 경우" 본인 확인을 하고 진행하므로 자동으로 다음 단계 이동
	if(pageIdx==2) pageIdx++;

	switch(pageIdx) {
		case 3:
			this.currentOffset = pageIdx - 1;
			break;
		case 4:
		case 6:
		case 7:
		case 8:
			this.currentOffset = pageIdx;
			break;
		case 5:
			this.currentOffset = pageIdx - 2;
			break;
		default:
			this.currentOffset = 0;
			break;
	}
	
	this.continuePage = this.currentOffset + 1;
	this.nextView();
};

@function MS1005:drawPage(data)
{
	var curStep = this.pageArr[this.currentOffset].step;
	this.tbvManager.changeTab(this.pageArr[this.currentOffset].name, data);
	
	for(var i = 0; i<this.naviLbls.length; i++)
	{
		var naviLbl = this.naviLbls[i];
		naviLbl.show(AComponent.INVISIBLE);
		if(i+1 == curStep) {
			naviLbl.show(AComponent.VISIBLE);
		}
	}
	
	//최상단 문구 변경
	if(this.currentOffset == 8) {
		this.titleLbl.setText('ID 등록');
	} else if(this.currentOffset == 9) {
		this.titleLbl.setText('계좌개설 완료');
	}else {
		this.titleLbl.setText('계좌개설');
	}
	
	//홈버튼 가장 마지막 단계에서 숨기기
	if(this.currentOffset == 9) {
		this.homeView.show(AComponent.INVISIBLE);
	} else {
		this.homeView.show(AComponent.VISIBLE);
	}
	
	this.naviText.setText(this.pageArr[this.currentOffset].title);
};

@function MS1005:beforeView()
{
	if(this.currentOffset == 0) return;
	
	if( this.continuePage >= this.currentOffset) {
		AToast.show("이어하기 이전 단계로의 이동이 불가합니다.\n이전 단계 수정이 필요하신 경우 계좌개설을 재시작해주세요.");
		return;
	}
	
	//휴대폰본인확인에서 뒤로가기 시 영상촬영이 아닌 신분증촬영으로 이동
	if(this.currentOffset == 2) {
		this.currentOffset--;
	}
	this.currentOffset--;
	this.drawPage();
};

@function MS1005:nextView(data)
{
	if(this.currentOffset == 9) return;
	
	this.currentOffset++;
	this.drawPage(data);
};

@function MS1005:onHomeBtnClick(comp, info)
{
	
 	VRManager.endRP();
	if(this.currentOffset == 0 || this.currentOffset == 1)
	{
		theApp.isNFTFProgress = false;
		theApp.navigator.goPage('FrmPage');
		theApp.frmPage.goFirstPageProcess();
		return;
	}

	var win = AWindow.createWindow('FD/window/MS1005_W07.lay', 'MS1005_W07');
	win.infoMsg = '<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">"계좌개설"<br>초기 화면으로 이동합니다.<br>진행중인 계좌개설신청 내역을<br>삭제하시겠습니까?</span>';
	win.openAsDialog(this);
};

@function MS1005:onWindowResult(result, awindow)
{	
	if("MS1005_W07" == awindow.getContainerId())
	{
		//진행중인 계좌개설 내역 삭제
		if( 1 == result)
		{
			var thisobj = this;
			QryRequest.request('SACMT632',	function(queryData){	
				var inBlock1 = queryData.getBlockData('InBlock1')[0];
				inBlock1["D1처리구분"] = '5';		
				inBlock1["D1디바이스고유번호"] = theApp.uId;
			},
			function(queryData)
    		{
				var errCode = this.getLastError('errCode');
				if( errCode >= 1000)
				{	
					// 상황상 3582는 등록되지 않은 정보 삭제시 발생하는 오류번호
					// 오류라고 볼수 없으므로 메세지를 띄우지 않는다.
					if( errCode != 3582 )
						theApp.getErrMsg(thisobj,this);
				}
				else
				{
					
				}
			});
			
			thisobj.continuePage = 0;
			
			theApp.ifContinued = false;
			theApp.isNFTFProgress = false;
			theApp.navigator.goPage('FrmPage');
			theApp.goPageCheck('MS1005', false);
		}
	}
};

@function MS1005:checkPageTabViewHeight()
{
	this.mainView.setHeight(this.mainView.getHeight());
	this.mainView.updatePosition();
};

//테스트진행중
@function MS1005:onTestPrevBtnClick(comp, info)
{
	theNavi.getActivePage().beforeView();
};
//테스트진행중
@function MS1005:onTestNextBtnClick(comp, info)
{
	theNavi.getActivePage().nextView();
};
