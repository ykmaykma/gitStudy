
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0001()
{
	@super();
	
	this.page = null;
	this.isAni = null;
	this.pageData = null;
	
	this.onlyCheck = false;
	
	//액션
	this.baseH			= null;	
	this.isTouchLeave	= true;	
	this.isTouch		= false;
	this.startY			= null;	
	this.touchX			= null;
	this.wmoveX			= null;
	this.touchY			= null;
	this.wmoveY			= null;	
}
@extends BasePage;


@function FD0001:onReady()
{
	@super.onReady();
	
	//저사양 버전 체크
	theApp.versionAlert();
	
	//버전정보 셋팅하기
	this.verLbl = this.findCompById('VerLbl');
	this.verLbl.setText(DEFINE_VERSION);
	
	this.closeBtn = this.findCompById('CloseBtn');
	
	//증권사별에 따라 윈도우 화면 다르게 띄우기
	this.makeWindowByFNO();
	
	/*
	var thisObj = this;
	this.baseH = this.thisHeight;
	this.frame.stopAnima(true).anima({y:-( this.baseH ), height:this.baseH}, 300,
	{
		complete:function()
		{
			thisObj.clearTransform(0, thisObj.openContainer.getHeight()-thisObj.baseH);
		}
	});
	*/
};

@function FD0001:onWillDeactive()
{
	@super.onWillDeactive();

	//this.mainView.onWillDeactive();
}


@function FD0001:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	
	var now = new Date();			
	var now2 = null;			

	now.setDate(now.getDate());

	now2 = now.format('yyyyMMdd');

	if(now2 >= 20181112 && now2 <= 20181231){

		// 오늘 하루 보지 않기 작업
		var popupEvtDate = theApp.prefInfo.get('EventDate2');


		if(popupEvtDate < now2){
			var win = AWindow.createWindow('FD/window/FD0000_W09.lay', 'FD0000W9');

			win.openAsDialog(this);

		}
	}
	if(now2 >= 20181217 && now2 <= 20181231){

		// 오늘 하루 보지 않기 작업
		var popupEvtDate = theApp.prefInfo.get('EventDate3');


		if(popupEvtDate < now2){
			var win = AWindow.createWindow('FD/window/FD0000_W10.lay', 'FD0000W10');

			win.openAsDialog(this);

		}
	}
}


//증권사별에 따라 윈도우 화면 다르게 띄우기
@function FD0001:makeWindowByFNO()
{
	var loadView = null;
	
	switch(theApp.systemInfo.fno)
	{
		case '951':
			loadView = this.findCompByGroup('loginView')[0].viewLoad('FD/view/FD0001_V00.lay');
		break;
	}
	
	this.loginIdTxf = loadView.findCompByGroup('LoginIdTxf')[0];
	this.loginPwTxf = loadView.findCompByGroup('LoginPwTxf')[0];
	this.headBtn = loadView.findCompByGroup('HeadBtn')[0];
	
	this.AccessOnOffChb = loadView.findCompByGroup('AccessOnOffChb')[0];
	
	this.AccessOnOffChb.addEventListener('click', this, 'onAccessOnOffChbClick');
	
	loadView.findCompByGroup('LoginBtn')[0].addEventListener('click', this, 'onLoginBtnClick');
	loadView.findCompByGroup('FirstVisitBtn')[0].addEventListener('click', this, 'onFirstVisitBtnClick');
	loadView.findCompByGroup('FindIdBtn')[0].addEventListener('click', this, 'onFindIdBtnClick');
	loadView.findCompByGroup('LostPwdBtn')[0].addEventListener('click', this, 'onLostPwdBtnClick');
};

@function FD0001:clearTransform(x, y)
{
	var thisObj = this;
	
	setTimeout(function()
	{
		thisObj.frame.css(
		{
			'-webkit-transform': '',
			'-webkit-transition-property': '',
			'-webkit-transition-duration': '',
			'-webkit-transition-timing-function': '',
			'-webkit-transition-delay': ''
		});

		thisObj.move(x, y);
	
	},100);
	
};


@function FD0001:onWillActive(reload)
{
	if(afc.isSimulator)
	{
		this.loginPwTxf.setText('1q2w3e4r');
	}
	
	this.checkIdHidden();
	this.checkLoginIdSave();
	this.checkAccess();
};


@function FD0001:doLoginProcess(loginPw)
{
	var thisObj = this;
	theApp.loginManager.requestUserInfo(loginPw, function(code, text)
	{
		if(code == Define.SUCCESS)
		{
			/*
			if(thisObj.loginTypeCbx.getCheck())
			{
				theApp.userInfo.setUserLoginState(1);
				if(thisObj.onlyCheck)
				{
					AToast.show('공인인증 로그인이 필요한 화면입니다.');		
					return;
				}
				else if(thisObj.page && theApp.isCertPage(thisObj.page))
				{
					AToast.show('공인인증 로그인이 필요한 화면입니다.');		
					return;
				}
				AToast.show('시세조회전용으로 로그인하였습니다.');
			}
			else
			{
				theApp.userInfo.setUserLoginState(2);
				AToast.show('공인인증서 로그인에 성공하였습니다.');
				theApp.certInfo.setCertPw(thisObj.loginCertPwTxf.getCipherData());
				
			}
			
			theApp.frmPage.checkCertLogoutTimer();
			*/
			theApp.userInfo.setUserLoginState(1);
			
			theApp.prefInfo.get('User')[0] = theApp.systemInfo.makeFirmUserId(thisObj.loginIdTxf.getText());
			theApp.prefInfo.get('User')[2] = thisObj.loginPwTxf.getCipherData();
			theApp.prefInfo.get('User')[3] = thisObj.loginPwTxf.getPwLength();
			theApp.prefInfo.saveInfo();
			/*
			if(!afc.isSimulator)
			{
				PushManager.pushLogin(theApp.systemInfo.makeFirmUserId(thisObj.loginIdTxf.getText()));
			}
			*/
			
			//thisObj.close(1);
			theApp.frmPage.settingBtmMenuByLoginState();
			
			theApp.subNavi.clearHistory();
			
			thisObj.loginPwTxf.setText('');

			theApp.frmPage.goFirstPageProcess();			
			
			
			
			// 이벤트 페이지 부르기 끝!!!
			
			if(thisObj.onlyCheck)
			{

			}
			else
			{
				if(thisObj.page)
				{
					theApp.goPageCheck(thisObj.page, thisObj.isAni, thisObj.pageData);
				}
				else
				{
					if(theApp.subNavi.getActivePage().onChangeLoginState) theApp.subNavi.getActivePage().onChangeLoginState();		
				}
			}
			
			//로그인 성공후 체크해야할 프로세스 실행
			theApp.loginManager.checkAfterLoginSuccess();
			
		}
		else
		{
			if(theApp.accNetManager) theApp.accNetManager.stopManager();
			theApp.alert(text);
		}
	});

};

@function FD0001:onLoginBtnClick(comp, info)
{
	var strId = theApp.systemInfo.makeFirmUserId(this.loginIdTxf.getText());
	var strPw = this.loginPwTxf.getText();
	var loginType = Define.LOGIN_ID;
	
	if(!strId)
	{
		AToast.show('아이디를 입력해주세요.');
		return false;
	}

	if(!strPw)
	{
		AToast.show('접속비밀번호를 입력해주세요.');
		return false;
	}
	
	
	/*
	if(!this.loginTypeCbx.getCheck())
	{
		loginType = Define.LOGIN_CERT;
	}
	*/
	
	this.onLoginIdSaveStorage();
	
	var loginPw;
	
	var thisObj = this;
	
	loginPw = this.loginPwTxf.getCipherData();
	
	//증권사별 대소문자 구분
	if(theApp.systemInfo.get('FirmIdType') == 'uppercase') strId = strId.toUpperCase();
	else if(theApp.systemInfo.get('FirmIdType') == 'lowercase') strId = strId.toLowerCase();

	
	theApp.connectManager.initConnection(strId, 'MT', function(result, text)
	{
		if(result == Define.SUCCESS)
			thisObj.doLoginProcess(loginPw);	
		else
			theApp.exitAppAlert(text);
	});
};

@function FD0001:onFirstVisitBtnClick(comp, info)
{

};

@function FD0001:onFindIdBtnClick(comp, info)
{

};
@function FD0001:onLostPwdBtnClick(comp, info)
{

};

//아이디 숨김체크
@function FD0001:checkIdHidden()
{
	/*
	if(theApp.configInfo.get('IDHIDE_ONOFF') == 'ON')
	{
		this.loginIdTxf.setAttr('type', 'password');
	}
	else this.loginIdTxf.setAttr('type', 'text');
	*/	
	
	this.loginIdTxf.enableTextMask( (theApp.configInfo.get('IDHIDE_ONOFF') == 'ON') );
	
};

//아이디 저장체크
@function FD0001:checkLoginIdSave()
{
	var idSaveOnOff = theApp.configInfo.get('IDSAVE_ONOFF');
	if(idSaveOnOff == 'ON')
	{
		var user = theApp.prefInfo.get('User');
		if(user && user[0])
		{
			this.loginIdTxf.setText(user[0]);
		}
	}
	else this.loginIdTxf.setText('');
}; 

//테마 접근성 체크
@function FD0001:checkAccess()
{
	var themeMode = theApp.configInfo.get('THEME_MODE');
	
	if(themeMode && (themeMode == 'MO'))
	{
		this.AccessOnOffChb.setCheck(true);
	}
	else
	{
		this.AccessOnOffChb.setCheck(false);
	}
}; 


//아이디 로컬스토리지에 저장
@function FD0001:onLoginIdSaveStorage()
{
	theApp.prefInfo.get('User')[0] = theApp.systemInfo.makeFirmUserId(this.loginIdTxf.getText());
	theApp.prefInfo.saveInfo();
}; 


@function FD0001:onAccessOnOffChbClick(comp, info)
{
	var themeMode = theApp.configInfo.get('THEME_MODE');
	if(themeMode && (themeMode == 'MO'))
	{
		theApp.configInfo.set('THEME_MODE', 'GE');
		//theApp.removeTheme('MO');
	}
	else
	{
		theApp.configInfo.set('THEME_MODE', 'MO');
		//theApp.removeTheme('GE');
	}
	
	theApp.configInfo.saveInfo();
	
	theApp.alert('모바일앱 접근성은 앱 종료 후<br/>재시작시 적용됩니다.');
	
	//theApp.checkTheme();
	this.checkAccess();
};

@function FD0001:onWindowResult(result, awindow)
{
	/*
	var winId = awindow.getId();
	alert(afc.log(awindow));
	*/
	var winId = awindow.getId();			
	
};

