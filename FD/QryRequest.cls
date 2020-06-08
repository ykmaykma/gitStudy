
/**
Constructor
Do not call Function in Constructor.
*/
var QryRequest = 
{

};

QryRequest.lazyCallback = {};

QryRequest.request = function(queryName, inFunc, outFunc, lazyFunc, funcKey)
{
	var thisObj = this;
	AppManager.showNFTFProgress(30);
	
	//계정계 지연처리 callback 함수
	if(lazyFunc) QryRequest.lazyCallback[queryName] = lazyFunc;

	var connMgr = theApp.connectManager;
	
	connMgr.connectAccForOneTimeQuery(function(result)
	{
		if(result)
		{
			if(lazyFunc) connMgr.netManager.addQueryListener(thisObj);

			connMgr.netManager.sendProcessByName(queryName, 'nftf001', null, 

			function(queryData)
			{
 				queryData.enableFlag('encFlag');

				if(funcKey) this.setHeaderInfo({FUNC_KEY_LST: funcKey});
				else this.setHeaderInfo({FUNC_KEY_LST: 'C'});

				if(inFunc) {
					inFunc.call(this, queryData);
					if(queryData) queryData.printQueryData();
				}
			}, 

			function(queryData)
			{
				if(outFunc) outFunc.call(this, queryData);
				if(queryData) queryData.printQueryData();

				if(!lazyFunc)
				{
					setTimeout(function() 
					{
						AppManager.hideNFTFProgress();
						connMgr.stopAccForOneTimeQuery();

					}, 100);
				}

			});
		
		}
		
		//fail
		else
		{
			setTimeout(function() 
		   {
				AppManager.hideNFTFProgress();
				connMgr.stopAccForOneTimeQuery();

			}, 100);
		}
	});
	
};

//전송전 버퍼 헤더 변경 처리 
QryRequest.beforeSendBufferData = function(abuffer, packetSize, trName, manager)
{
	if(trName=='SACMT634')
	{
		abuffer.setNumString(OS_TH_TRX_BRN_NO, SZ_TH_TRX_BRN_NO, 501);
		abuffer.setNumString(OS_TH_BRN_NO, SZ_TH_BRN_NO, 501);
	}
	
};

//수신된 데이터를 AQueryData 에 채운 후 호출된다.
QryRequest.afterOutBlockData = function(queryData, groupName, trName, manager)
{
	var packetType = manager.rcvBuf.getByte(OS_CH_TG_TP);
	
	//계정계 지연처리 TR응답
	if(packetType==PACKET_TYPE.E)
	{
		var lazyFunc = QryRequest.lazyCallback[trName];

		if(lazyFunc) 
		{
			lazyFunc.call(manager, queryData);
			QryRequest.lazyCallback[trName] = null;

			setTimeout(function() 
			{
				AppManager.hideProgress();
				theApp.connectManager.stopAccForOneTimeQuery();

			}, 100);
		}
	}
};








