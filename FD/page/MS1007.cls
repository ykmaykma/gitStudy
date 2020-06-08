
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1007()
{
	@super();

	this.selectedView = null;
	this.task = [];
	this.outBlock = null;
}
@extends APage;


@function MS1007:onReady()
{
	@super.onReady();
	
	this.task = ['계좌개설','ID등록'];
	//if(!Define.RELEASE) this.findCompById('UID').setText(DEFINE_VERSION);
};

@function MS1007:onActive(reload)
{
	@super.onActive(reload);
	
	if(reload) {
		AppManager.endOltp();
		AppManager.hidePatchView();
	}
};

@function MS1007:onView19ActionUp(comp, info)
{
//	theApp.navigator.goPage('MS1006');
	this.checkPageAccount();
};

@function MS1007:onView20ActionUp(comp, info)
{
	this.navigator.goPage('MS2002',false);
};

@function MS1007:checkPageAccount()
{
	var thisObj = this;
	AppManager.beginOltp();
	QryRequest.request('SACMT635',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1');
		inBlock1[0] =
		{
			"D1처리구분" : 2,
			"D1실명확인번호" : '',
			"D1디바이스고유번호" : theApp.uId
		};
	},
	function(queryData)
	{	
		var errCode = this.getLastError('errCode');
		AppManager.endOltp();
		
		if( errCode >= 1000 )
		{
			theApp.navigator.goPage('MS1002');
		}
		else if(queryData)
		{	
			queryData.printQueryData();
			var outBlock = queryData.getBlockData('OutBlock1')[0];
			thisObj.outBlock = outBlock;
			if(outBlock['D1처리상태코드'] == '99' || outBlock['D1처리상태코드'] == '0A' || outBlock['D1처리상태코드'] == '0B') {
				if(outBlock['D1비대면업무구분'] == 'A') {
					theApp.navigator.goPage('MS1001', false, [ outBlock['D1등록일'] ]);	
				} else {
					thisObj.showErrorMsg(0);
				}
			} else if(outBlock['D1처리상태코드'] == '0Z') {
				//theApp.navigator.goPage('MS1006');
				theApp.navigator.goPage('MS1005',false);	
			} else {
				if(outBlock['D1비대면업무구분'] == 'A') {
					theApp.navigator.goPage('MS1002');
				} else {
					//theApp.navigator.goPage('MS1006');
					theApp.navigator.goPage('MS1005',false);	
				}
			}
		}
	});
};

@function MS1007:showErrorMsg(selectedTp)
{
	var afirTp = null;
	var cStatus = null;
	switch(this.outBlock['D1비대면업무구분'])
	{
		case 'A':
			afirTp = '계좌개설';
			break;
		case 'B':
			afirTp = '카드발급';
			break;
		case 'C':
			afirTp = '계좌비밀번호 초기화';
			break;
		default :
			break;			
	}
	switch(this.outBlock['D1처리상태코드'])
	{
		case '99':
			cStatus = '신분증 진위확인';
			break;
		case '0A':
			cStatus = '소액이체';
			break;
		case '0B':
			cStatus = '본인인증 완료';
			break;
		default :
			break;			
	}
	
	var win = AWindow.createWindow('FD/window/MS1005_W05.lay', 'MS1005_W05');
	win.infoMsg = '<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">' + afirTp + ' 업무의 ' + cStatus + ' 단계에 있습니다.<br>' + this.task[selectedTp] + ' 업무 진행이 불가합니다.</span>';
	win.openAsDialog(this);
};