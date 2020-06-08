
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0001_V00()
{
	@super();

}
@extends AView;


@function FD0001_V00:init(context, evtListener)
{
	@super.init(context, evtListener);
	
    /*
    var certPwdSecurePad = this.findCompById('LoginCertPwTxf');

	if (Define.ENC_PREFIX == 'PAD.V02')
	{
		certPwdSecurePad.padOption.encryptMethod='seed';
	}
	*/
};

@function FD0001_V00:onFindIdBtnClick(comp, info)
{
	var win = AWindow.createWindow('FD/window/FD0001_W02.lay', 'FD000102');
	win.setWindowOption({
		isAutoCenter: true,
		isFocusLostClose: false, 
		modalBgOption:'dark'
	});	
	win.open(this, 0, 0, '100%', '100%');
};

@function FD0001_V00:onLostPwdBtnClick(comp, info)
{
	var win = AWindow.createWindow('FD/window/FD0001_W03.lay', 'FD000103');
	win.setWindowOption({
		isAutoCenter: true,
		isFocusLostClose: false, 
		modalBgOption:'dark'
	});	
	win.open(this, 0, 0, '100%', '100%');
};

@function FD0001_V00:onFirstVisitBtnClick(comp, info)
{
	theApp.isNFTFProgress = true;
	theApp.checkPageAccount();
};

@function FD0001_V00:onLoginPwTxfChange(comp, info)
{
	if (comp.getText())
	{
		var cont = this.getContainer();
		cont.onLoginBtnClick();
	}
};

@function FD0001_V00:onWindowResult(result, awindow)
{
	
	var winId = awindow.getId();
	
	if(winId == 'FD000101')
	{
		AppManager.setPortrait(AppManager.SCREEN_ORIENTATION_PORTRAIT);
	}
	
}

