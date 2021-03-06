
/**
Constructor
Do not call Function in Constructor.
*/
@class BaseWindow(containerId)
{
	@super(containerId);

	
	this.tabViewManager = null;
	
	this.queryMap = {};
	
	this.tabViewArr = new Array();
	this.lifeCycleListener = new Array();
	this.chartViewList = new Array();
	this.webViewList = new Array();
	
	this.useNative = false;
	this.state = null;
	this.winType = 'nor';	//윈도우타입(nor:일반, full:풀윈도우, real:리얼받은 윈도우)
	
}
@extends AWindow;


@function BaseWindow:onReady()
{
	@super.onReady();
	
	
	//네이티브 차트 뒤로 보내기
	if((theApp.subNavi && theApp.subNavi.getActivePage() && theApp.subNavi.getActivePage().useNative) || (this.openContainer && this.openContainer.useNative))
	{
	
		NativeWebView.bringToFront(true);
		/*
		if(!afc.isSimulator)
		{
			ChartManager.bringToFront(true);
			//AppManager.bringToFront(true);
		}
		*/
	}
	
	this.state = 0;	
	
	var thisObj = this;
	//로드뷰가 있으면 lifeCycleListener에 등록
	this.lifeCycleListener = new Array();
	this.view.$ele.find("[data-load-url]").each(function(index){
		thisObj.lifeCycleListener.push(this.acomp.loadView);
	});
	//탭뷰가 있으면 lifeCycleListener에 등록
	this.tabViewArr = new Array();
	this.view.$ele.find("[data-base='ATabView']").each(function(index){
		
		thisObj.tabViewArr.push(this.acomp);
	});
	
	this.onWillActive();
	this.onActive();
	this.onActiveDone();
	
	//이전 페이지나 윈도우 리얼해제
	this.checkUnregReal();
	
};
@function BaseWindow:open(opener, left, top, width, height)
{
	//강제종료 팝업이 있을시 팝업을 띄우지 않음
	if(theApp.isOpenExitAlert()) return;
	@super.open(opener, left, top, width, height);
};

@function BaseWindow:close(result)
{
	this.onWillDeactive();
	this.onDeactive();
	this.onDeactiveDone();
	
	//이전 페이지나 윈도우의 조회를 날리면서 리얼까지 다시 등록 시킴
	//if(this.openContainer && this.openContainer.refreshData) this.openContainer.refreshData();
	
	//이전 페이지나 윈도우 재조회
	this.checkRefreshData();
	
	@super.close(result);
	
	//윈도우를 띄운 이전 화면에 차트가 있거나 현재 윈도우에 차트가 있을경우 차트를 앞으로 이동
	var topWin = AWindow.getTopWindow();
	if(topWin)
	{
		if(topWin.useNative)
		{
			if(topWin.webViewList.length > 0) NativeWebView.bringToFront(false);
			/*
			else ChartManager.bringToFront(false);
			*/
		}
	}
	else
	{
		if((theApp.subNavi && theApp.subNavi.getActivePage() && theApp.subNavi.getActivePage().useNative) || (this.openContainer && this.openContainer.useNative))
		{
			NativeWebView.bringToFront(false);
			/*
			ChartManager.bringToFront(false);
			//AppManager.bringToFront(false);
			*/
		}
	}
};

@function BaseWindow:show(delay)
{

	if((theApp.subNavi && theApp.subNavi.getActivePage() && theApp.subNavi.getActivePage().useNative) || (this.openContainer && this.openContainer.useNative))
	{
		NativeWebView.bringToFront(true);
		/*
		ChartManager.bringToFront(true);
		//AppManager.bringToFront(true);
		*/
	}
	
	@super.show(delay);
	
	//이전 페이지나 윈도우 리얼해제
	this.checkUnregReal();
};

@function BaseWindow:hide()
{
	//이전 페이지나 윈도우의 조회를 날리면서 리얼까지 다시 등록 시킴
	this.checkRefreshData();
	
	@super.hide();
	
	var topWin = AWindow.getTopWindow();
	if(topWin)
	{
		if(topWin.useNative)
		{
			if(topWin.webViewList.length > 0) NativeWebView.bringToFront(false);
			/*
			else ChartManager.bringToFront(false);
			*/
		}
	}
	else
	{
		if((theApp.subNavi && theApp.subNavi.getActivePage() && theApp.subNavi.getActivePage().useNative) || (this.openContainer && this.openContainer.useNative))
		{
			NativeWebView.bringToFront(false);
			/*
			ChartManager.bringToFront(false);
			//AppManager.bringToFront(false);
			*/
		}
	}
};

//이전 페이지나 윈도우 리얼해제
@function BaseWindow:checkUnregReal()
{
	if(this.openContainer instanceof BaseWindow)
	{
		if(this.winType == 'real')
		{
			if(this.openContainer.winType == 'real')
			{
				//AToast.show('window 리얼 해제함');
				if(this.openContainer.unregisterRealAll) this.openContainer.unregisterRealAll();
			}
			else
			{
				//AToast.show('page 리얼 해제함');
				var activePage = theApp.subNavi.getActivePage();
				if(activePage && activePage.unregisterRealAll) activePage.unregisterRealAll();	
			}
		}
	}
	else
	{
		if(this.winType == 'real')
		{
			//AToast.show('page 리얼 해제함');
			var activePage = theApp.subNavi.getActivePage();
			if(activePage && activePage.unregisterRealAll) activePage.unregisterRealAll();
		}
		else if(this.winType == 'full') theApp.frmPage.pageTabView.show(AComponent.INVISIBLE);
	}
};

//이전 페이지나 윈도우 재조회
@function BaseWindow:checkRefreshData()
{
	if(this.openContainer instanceof BaseWindow)
	{
		if(this.winType == 'real')
		{
			if(this.openContainer.winType == 'real')
			{
				//AToast.show('재조회 window');
				if(this.openContainer.refreshData) this.openContainer.refreshData();
			}
			else
			{
				//AToast.show('재조회 page');
				var activePage = theApp.subNavi.getActivePage();
				if(activePage && activePage.refreshData) activePage.refreshData();
			}
		}
	}
	else
	{
		if(this.winType == 'real')
		{
			//AToast.show('재조회 page');
			var activePage = theApp.subNavi.getActivePage();
			if(activePage && activePage.refreshData) activePage.refreshData();
		}
		else if(this.winType == 'full') theApp.frmPage.pageTabView.show(AComponent.VISIBLE);
	}
};

@function BaseWindow:onWillActive(reload)
{
	this.state++;
	this.triggerLifeCycle('onWillActive', reload);
};

@function BaseWindow:onActive(reload)
{
	this.state++;
	this.triggerLifeCycle('onActive', reload);
};

@function BaseWindow:onActiveDone(reload)
{
	this.state++;
	this.sendDataAuto();
	this.triggerLifeCycle('onActiveDone', reload);
};

@function BaseWindow:onWillDeactive()
{
	for(var i = 0; i<this.chartViewList.length; i++)
	{
		this.chartViewList[i].destroyChart();
	};
	
	for(var i = 0; i<this.webViewList.length; i++)
	{
		this.webViewList[i].destroyWebView();
	};
	
	this.triggerLifeCycle('onWillDeactive');
	this.state--;	
	
	if(theApp.screenMode == AppManager.SCREEN_ORIENTATION_LANDSCAPE)
	{
		theApp.screenMode = AppManager.SCREEN_ORIENTATION_PORTRAIT;
		AppManager.setPortrait(AppManager.SCREEN_ORIENTATION_PORTRAIT);
	}
};

@function BaseWindow:onDeactive()
{
	this.triggerLifeCycle('onDeactive');
	this.state--;
};

@function BaseWindow:onDeactiveDone()
{
	this.triggerLifeCycle('onDeactiveDone');
	this.state--;
};


@function BaseWindow:triggerLifeCycle(funcName, reload)
{
	var funcRow = null;
	var funcThis = null;
	for(var i = 0; i<this.lifeCycleListener.length; i++)
	{
		funcThis = this.lifeCycleListener[i];
		funcRow = funcThis[funcName];
		if(funcRow) funcRow.call(funcThis, reload);
	}

	var tabViewLen = this.tabViewArr.length;
	if(tabViewLen > 0)
	{
		var tabView = null, active = null;
		for(var i = 0; i<tabViewLen; i++)
		{
			tabView = this.tabViewArr[i];
			var active = tabView.getSelectedView();
			if(active && active[funcName])
			{
				active[funcName].call(active, reload);
			}
		}
	}
};

@function BaseWindow:makeTabViewManager(tabview, container)
{
	var tabViewManager = new TabViewManager();
	tabViewManager.initManager(tabview, new RadioBtnManager(container));
	//this.tabViewArr.push(tabview);
	return tabViewManager;
};

@function BaseWindow:addLifeCycleListener(listener)
{
	this.lifeCycleListener.push(listener);
};

@function BaseWindow:isInfoQuery(queryName)
{
	var prefix = queryName.substring(0,2);
	return ( prefix == 'QR' || prefix == 'DB' || prefix == 'CP' || prefix == 'MC' );
};

@function BaseWindow:sendData(queryName, inFunc, outFunc, accNoIn, groupId)
{
	var rowQuery = this.queryMap[queryName];
	if(rowQuery)
	{
		if(!inFunc && rowQuery.inFunc) inFunc = rowQuery.inFunc;
		if(!outFunc && rowQuery.outFunc) outFunc = rowQuery.outFunc;
		if(!groupId && rowQuery.groupId) groupId = rowQuery.groupId;
	}
	
	if(this.isInfoQuery(queryName))
	{
		theApp.infoNetManager.sendProcessByName(queryName, this.getContainerId(), groupId, inFunc, outFunc);
	}
	else
	{
		//계정계 전송
		var thisObj = this;
		
		if (accNoIn)
		{
			// SMS 인증요청
			theApp.smsCertManager.openSmsCertWindow(accNoIn, false, null, function(result)
			{
				if(result)
				{
					theApp.accNetManager.sendProcessByName(queryName, thisObj.getContainerId(), groupId, inFunc, outFunc);
				}
				return result;
			});
			return;
		}
		
		theApp.accNetManager.sendProcessByName(queryName, thisObj.getContainerId(), groupId, inFunc, outFunc);
	}
};

//특정 컴포넌트의 setQueryData를 재정의하는 공통함수
@function BaseWindow:initSetQuery()
{
	
};

//윈도우가 실행될때 자동으로 쿼리를 날리는 공통함수 
@function BaseWindow:sendDataAuto()
{
};

/*
//윈도우에서 쿼리를 날리는 공통함수
@function BaseWindow:sendDataManage()
{
};
*/

//윈도우에서 리얼을 전체 해제하는 공통함수
@function BaseWindow:unregisterRealAll()
{
	afc.log(this.getId()+' -> BaseWindow:unregisterRealAll() 함수가 구현되어 있지 않습니다.');	
};

//데이터 갱신
@function BaseWindow:refreshData()
{
	afc.log(this.getId()+' -> BaseWindow:refreshData() 함수가 구현되어 있지 않습니다.');
};

