
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1002()
{
	@super();

}
@extends APage;


@function MS1002:onReady()
{
	@super.onReady();

	this.firstView = this.findCompById('FirstView');
};

@function MS1002:onActive(reload)
{
	@super.onActive(reload);
	
	if(reload) {
		AppManager.endOltp();
		AppManager.hidePatchView();
	}
	
	 theApp.initNotice();
	
};

//처음부터진행버튼
//고객 삭제....
@function MS1002:onNewBtnClick(comp, info)
{
	var thisObj = this;
	theApp.checkCreateDatetime( function(){
		thisObj.process_onNewBtnClick();
	});
};

//이어서진행버튼
@function MS1002:onOldBtnClick(comp, info)
{
	theApp.checkCreateDatetime( function(){
		theApp.navigator.goPage('MS1003');
	});
};


@function MS1002:process_onNewBtnClick()
{
	var thisObj = this;
	
	QryRequest.request('SACMT632',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1["D1처리구분"] = '5';
		inBlock1["D1디바이스고유번호"] = theApp.uId;
	},
	function(queryData)
    {
		var errCode = this.getLastError('errCode');
		if(errCode >= 1000)
		{
			theApp.getErrMsg(thisObj,this);
		}
		//theNavi.goPage('MS1006');
		theApp.navigator.goPage('MS1005',false);	
	});
}
