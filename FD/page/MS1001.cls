
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1001()
{
	@super();

}
@extends BasePage;


@function MS1001:onReady()
{
	@super.onReady();
	
	this.dateLbl1 = this.findCompById('Label21');
	this.delBtn  = this.findCompById("DelBtn");
	if(Define.RT || !Define.RELEASE) {
		this.delBtn.show(AComponent.VISIBLE);
	} else {
		this.delBtn.show(AComponent.GONE);
	}
};

@function MS1001:onActive(reload)
{
	@super.onActive(reload);
	
	if(reload) {
		AppManager.endOltp();
		AppManager.hidePatchView();
	}
	
	 theApp.initNotice();
					
};

@function MS1001:onWillActive(reload)
{
	@super.onWillActive(reload);

	if(this.pageData[0]) {
		var start = this.pageData[0].toString();
		var startDate = start.substring(4,6)+'월 '+start.substring(6,8) + '일'

		this.dateLbl1.setText(startDate);
	} else {
		this.dateLbl1.show(AComponent.INVISIBLE);
	}
};

@function MS1001:onButton1Click(comp, info)
{
	//테스트진행중
	afc.phoneCall('1588-5533');
};


//초기화 테스트진행중 > 오픈 시 삭제해야 할 버튼
@function MS1001:onButton2Click(comp, info)
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

	//theApp.navigator.goPage('MS1006');
	theApp.navigator.goPage('MS1005',false);	
};

@function MS1001:onHomeBtnClick(comp, info)
{
	theApp.isNFTFProgress = false;
	theApp.navigator.goPage('FrmPage');
	theApp.frmPage.goFirstPageProcess();
	return;
};

@function MS1001:onDelBtnClick(comp, info)
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
	
	this.onHomeBtnClick();
};
