
/**
Constructor
Do not call Function in Constructor.
*/
@class InfoNetManager(name)
{
	@super(name);

	//TODO:edit here
	
	//this.name = name;
	this.connectCallback = null;
	this.keyCallback = null;
	
	this.pollingTimer = null;
	this.skipCheckTimer = null;
	
	this.newsList = new Object();
	this.tmpArray = new Array();
	
	this.newsList2 = new Object();
	this.tmpArray2 = new Array();
	
	this.newsCnt = 0;
	
	//2017.08 syl 수정 : 계정계 서버 우선 접속으로 변경, 정보계 조회 재시도 여부 확인 추가 
 	this.infoNetReceiveFail = false;  // Receive Fail Case (1)
	this.infoNetSendFail = false; 	  // Send Fail Case (2)
	this.isConnClosed = false;		  // Connection 재시도 및 정보계 조회 스킵 용
}
@extends QueryManager;

InfoNetManager.infoErrMsg = 
{
	'9000': '조회 실패',
	'9001': 'Invalid Join Count',
	'9002': '정의되지 않은 KFID 를 사용',
	'9003': '정의되지 않은 FID 를 사용',
	'9004': 'Invalid Gid Count',
	'9005': '파일을 찾을 수 없습니다.',
	'9006': '해당 데이터가 없습니다.',
	'9010': 'Input Data Invalid',
	
	//tmax
	'9501': 'TPMINNO',
	'9502': 'Invalid descriptor of asynchronous or interactive mode has been returned',
	'9503': 'Network error',
	'9504': 'Invalid descriptors has been returned',
	'9505': 'Too many handles have been used for anynchronous or interactive mode',
	'9506': 'Service has not been provided',
	'9507': 'Connection has not been made due to insufficient memory',
	'9509': 'Protocol errors',
	'9510': 'Buffer pointer errors have been generated due to failure of application programs',
	
	'9511': 'Service errors at the level of application programs',
	'9512': 'Tmax internal errors(This is logged)',
	'9513': 'Transaction time-out',
	'9514': 'Transaction has been cancelled due to failure of transaction',
	'9515': 'Signal has been generated',
	'9517': 'Unregistered structure type of field key has been used',
	'9518': 'Errors of buffer use of type',
	
	'9522': 'Event has been generated due to invalid descriptor of interactive mode',
	'9523': 'Service has not been provided by tpdeq() or RQ',
	'9524': 'Server process has not been ready',
	'9525': 'Security errors',
	'9526': 'Time-out of server process queue',
	'9527': 'Queues have been deleted at the current state due to queue purge',
	'9528': 'Connection with server has been terminated',
	'9529': 'Server process has been downed due to application program errors',
	
	'9530': 'Errors have been generated while the previous service was being processed',
	'9531': 'The number of concurrent users has reached its limit',
	
	//체크 DS 에러
	'10000': 'Trans pattern error',
	'10010': 'No data error',
	'10020': 'Key fid error',
	'10030': 'Data id error',
	'10040': 'Code error',
	'10050': 'Data fid error',
	'10060': 'File transfer error',
	'10070': 'AL serer login error',
	'10080': 'Server system error',
	'10090': 'Screen error',
	'10100': 'authority error',
	'10090': '종목검색창 No data error(잔존)',
	'10091': '종목검색창 No data error(이름)',
	'10092': '종목검색창 No data error(조건)',
	'13001': '미등록 CLIENT',
	'20150': 'TR code register error',
	'19000': '종목코드 최대갯수 초과'
};

/*********************************************************
 * 뉴스 자동 갱신을 위한 FID 정보
 * 다음의 Fid들은 뉴스 자동 갱신시 수신되는 Data Fid목록이다. 
 * 키론은 모든 Fid 정보를 메모리에 관리하지 않고 ( 성능상)
 * 조회된 Fid만 메모리에 관리하고 있음.
 * 
 * 여기에 Fid 정보를 static으로 관리하여
 * 자동 갱신시 Fid 데이타를 Parsing하는데 이용한다.
 *
 * 만일의 경우에 대비해 뉴스 시장의 모든 FID를 정의함 - 2017.07.05
 *********************************************************/
 
 /* Fid : [타입, 사이즈, exponent] */
InfoNetManager.newsFids = 
{
	11502: ["SHORT",2,0],
	11527: ["INT",12,0],
	11528: ["SHORT",12,0],
	11530: ["STRING",1,0],
	
	16013: ["STRING",12,0],
	15502: ["SHORT",2,0],
	15503: ["STRING",264,0],
	15504: ["STRING",132,0],
	15505: ["STRING",1,0],
	15506: ["STRING",1,0],
	15507: ["STRING",1,0],
	15511: ["SHORT",2,0],
	15510: ["STRING",1,0],
	15514: ["SHORT",2,0],
	
	15531: ["INT",4,0],
	15532: ["INT",4,0],
	15508: ["STRING",1,0],
	15509: ["STRING",1,0],
	15512: ["SHORT",2,0],
	15513: ["SHORT",2,0],
	15524: ["SHORT",2,0],
	15525: ["SHORT",2,0],
	15526: ["STRING",1,0],
	15527: ["STRING",6,0],
	15528: ["STRING",6,0],
	15529: ["STRING",6,0],
	15530: ["STRING",1,0],
	15533: ["STRING",600,0],
	15534: ["STRING",6,0],
	15535: ["STRING",6,0],
	15536: ["STRING",6,0],
	15537: ["STRING",6,0],
	15538: ["STRING",6,0],
	15539: ["STRING",6,0],
	15540: ["STRING",6,0],
	15541: ["STRING",6,0],
	15542: ["STRING",6,0],
	15543: ["STRING",50,0],
	15544: ["STRING",1000,0],
	15545: ["STRING",10,0],
	15546: ["STRING",10,0],
	15547: ["STRING",10,0],
	15548: ["STRING",10,0],
	15549: ["STRING",10,0],
	00070: ["INT",4,0],
	00071: ["INT",4,0],
	00072: ["INT",4,0],
	00073: ["INT",4,0],
	00074: ["INT",4,0],
	12544: ["INT",4,0],
	12545: ["INT",4,0],
	12546: ["STRING",1,0],
	12547: ["INT",4,0],
	16001: ["STRING",12,0]
};

InfoNetManager.getErrMsg = function(errCode)
{
	var errMsg = InfoNetManager.infoErrMsg[errCode];
	
	if(!errMsg) errMsg = '정의되지 않은 에러코드입니다.';
	
	return errMsg;
};


@function InfoNetManager:setConnectCallback(connectCallback)
{
	this.connectCallback = connectCallback;
};

@function InfoNetManager:onRetryConnected(success)
{
	if(this.connectCallback)
	{
		this.connectCallback(success);
		this.connectCallback = null;
	}
	
	if(success) 
	{
	
		this.isConnClosed = false;
		this.addQueryListener(this);
		
		this.sendSvcStat();
		
		var thisObj = this;

		//----------------------------------------------
		// 폴링 시작
		if(this.pollingTimer) 
		{
			clearInterval(this.pollingTimer);
			this.pollingTimer = null;
		}
		
		this.pollingTimer = setInterval(function()
		{
			thisObj.sendPolling();
			
		}, Define.POLLING_TIME);
		
		
		//------------------------------------------------
		//	스킵 체크 타이머 가동
		
		if(this.skipCheckTimer)
		{
			clearInterval(this.skipCheckTimer);
			this.skipCheckTimer = null;
		}

		this.skipCheckTimer = setInterval(function()
		{
			thisObj.updateAllSkippedComp();
			
		}, 500);

	}
};

/*
@function InfoNetManager:onConnected(success)
{
	if(this.connectCallback)
	{
		this.connectCallback(success);
		this.connectCallback = null;
	}
	
	if(success) this.addQueryListener(this);
};
*/

@function InfoNetManager:onClosed()
{
	@super.onClosed();

	if(this.pollingTimer) 
	{
		clearInterval(this.pollingTimer);
		this.pollingTimer = null;
	}
	
	if(this.skipCheckTimer)
	{
		clearInterval(this.skipCheckTimer);
		this.skipCheckTimer = null;
	}

	//AToast.show('InfoNetManager closed.');
	afc.log('InfoNetManager closed.');
	this.removeQueryListener(this);
	
	//alert('InfoNetManager closed. ' + this.selfClose);
	//theApp.closeSocket(this.selfClose);
};

//수신버퍼에 데이터를 수신한 후 바로 호출된다.
@function InfoNetManager:afterRecvBufferData(abuffer, packetSize, trName)
{	
	var packetType = PACKET_TYPE.I;
	
	if(abuffer) packetType = abuffer.getByte(OS_CH_TG_TP);
		
	if(packetType==PACKET_TYPE.I)
	{
		var errorData = this.getLastError();
		
		//에러 발생
		if(errorData.errCode>=9000)
		{
			AppManager.endOltp();
			
			//통신상태가 원활하지 않은 경우 바로 재접속 로직을 태운다.(query timeout)
			if(errorData.errCode==10001)
			{
				//2017.08 syl 수정 : 계정계 서버 우선 접속으로 변경, 정보계 조회 재시도 여부 확인 추가 
				this.infoNetReceiveFail= true; 
				theApp.autoLoginProcess(errorData.errMsg, true);
				return;
			}
			
			errorData.errMsg = InfoNetManager.getErrMsg(errorData.errCode);			

			//9006 인 경우만 토스트로 띄움.
			if(errorData.errCode==9006) AToast.show(errorData.errMsg);
			else 
			{
				var msg = errorData.errMsg.replace('콜센터', '고객지원센터') + '(' + errorData.trName + ', ' + errorData.errCode + ')';
				
				theApp.alert(msg, null, '메시지');
			}
		}
	}
};

/*
//수신된 데이터를 AQueryData 에 채운 후 호출된다.
@function InfoNetManager:afterOutBlockData(queryData, groupName, trName)
{

};

//전송버퍼에 데이터를 채우기 전에 호출된다.
@function InfoNetManager:beforeInBlockBuffer(queryData, groupName)
{

};

//전송버퍼의 데이터를 전송하기 바로 전에 호출된다.
@function InfoNetManager:beforeSendBufferData(abuffer, packetSize, trName)
{

};
*/

@function InfoNetManager:sendSvcStat()
{
	var abuf = this.sndBuf;
	
	abuf.setOffset(SZ_COMMON_HEADER+SZ_BLOCK_HEADER);

	//uchar userid[16];
   	//uchar connclass[2];
   	//uchar privaddr[12];
   	//uchar branch[3];
   	//uchar termno[3];

	abuf.addOriString(16, this.getHeaderInfo('USER_ID'));
	abuf.addOriString(2, this.getHeaderInfo('CONN_CLSS_CODE'));
	abuf.addOriString(12, this.getHeaderInfo('PRVT_IP'));
	abuf.addOriString(3, '');
	abuf.addOriString(3, this.getHeaderInfo('TERM_CLSS_CODE'));

	var sendLen = abuf.getOffset();
	var queryData = new AQueryData(null);
	//header setting
	this.makeInfoHeader(queryData, abuf, sendLen, { 'isRealSetHeader': true });	//isRealSetHeader 는 BH 까지만 셋팅하기 용
	
	this.sendBufferData(abuf, sendLen);
};

@function InfoNetManager:sendPolling()
{
	var sendLen = SZ_COMMON_HEADER + SZ_BLOCK_HEADER;
	var queryData = new AQueryData(null);
	//header setting
	this.makeInfoHeader(queryData, this.sndBuf, sendLen, { 'menuNo': '12345678', 'isRealSetHeader': true });	//isRealSetHeader 는 BH 까지만 셋팅하기 용
	
	
	this.sendBufferData(this.sndBuf, sendLen);
	
	//afc.log('InfoNetManager:sendPolling');
};

@function InfoNetManager:checkMsg(queryData, blockName)
{
	if(!blockName) blockName = 'OutBlock1';
	var outBlock = queryData.getBlockData(blockName);/*
	if(outBlock && outBlock.length > 0)
	{
		if(!queryData.getNextKey()) AToast.show('조회가 완료되었습니다.');
	}
	else AToast.show('조회내역이 없습니다.');*/
	if(!outBlock || outBlock.length == 0) AToast.show(Message.NoneList);
	
};

@function InfoNetManager:updateAllSkippedComp()
{
	var acomp, compArray, dataKey, i;

	//afc.log('**** enter updateAllSkippedComp ***************');

	for(dataKey in this.realComps)
	{
		compArray = this.realComps[dataKey];

		for(i=0; i<compArray.length; i++)
		{
			acomp = compArray[i];

			if(acomp.isPacketSkip) 
			{
				//afc.log('**** call updateSkippedComp *************** ' + acomp.getComponentId());
				
				this.updateSkippedComp(acomp);
			}
		}
	}

};

/*****************************************************
 * [자동 갱신 헤더 + 데이타] 패킷 수신
 * I/O Spec에 따라 파싱 처리.
 * 파싱해야 할 데이타는 15503(뉴스타이틀)
 *****************************************************/
@function InfoNetManager:rcvNews(rcvBuf, dataSize)
{

	afc.log("rcvNews 진입=======================================");
	
	if(theApp.systemInfo.fno == "699") {

		// 환경설정에 채권속보 알림팝업 ON/OFF 상태 체크
		var newsAL = theApp.configInfo.get("NEWSAL_ONOFF");
		if(newsAL == 'ON'){
			afc.log('News Data Received!!');

			var mid = rcvBuf.getShort(OS_IRH_MID_CODE),			//시장구분
				tgtp = rcvBuf.getByte(OS_IRH_FILLER),				//자동갱신타입
				patTp = rcvBuf.getShort(OS_IRH_PAT_TP),				//패턴구분
				dataTpCnt = rcvBuf.getShort(OS_IRH_DATA_TP_CNT),	//데이터 구분 개수
				dataOffset = OS_IRH_DATA_TP + dataTpCnt*2; 			//데이터 구분은 사용안함, skip

			rcvBuf.setOffset(dataOffset);

			var mkf, mkfv = '', skf, skfv = '', sktp, dfc, dfArr, sizeInfo, i;

			afc.log("자동갱신타입: " + tgtp + "  패턴구분: " + patTp);

			// 체크 파이낸셜 뉴스 자동 갱신 타입은 'F'로 내려옴.
			if(tgtp != 0x46 /* F */)
				return null;

			// 체크 파이낸셜 뉴스 패턴 타입은 1 로 내려옴
			if(patTp != 1)
				return null;

			// 뉴스 자동 갱신 메인키 FID
			mkf = rcvBuf.nextWord();		// MainKey FID

			afc.log("NEWS==> MainKeyFid:" + mkf);

			dfc = rcvBuf.nextWord();		//data Fid Count

			afc.log("NEWS==> DataFidCount:" + dfc);

			dfArr = new Array(dfc);

			for(i=0; i<dfc; i++)
			{
				dfArr[i] = rcvBuf.nextWord();
				//afc.log("NEWS==> Data Fid:" + dfArr[i]);
			}

			//-----------------------------------------------------------------------------------------
			//	values
			//  필요한 데이타는 뉴스제목 : 15503 
			//-----------------------------------------------------------------------------------------

			var type;
			var newsFidInfo;
			newsFidInfo = InfoNetManager.newsFids[mkf];

			if(newsFidInfo)
			{
				if(newsFidInfo[0] == "STRING")
				{
					mkfv = rcvBuf.nextString(newsFidInfo[1]);
				}
				else
				{
					if(newsFidInfo[0].charCodeAt(0) == 0x55 /*U*/)
						type = AQuery.UNSIGNED;
					else
						type = AQuery.SIGNED;

					mkfv = rcvBuf.nextType(newsFidInfo[1], type);
				}
			}

			var newsTitle, newsDate, newsTime, newsInfo, newsGisa, newsDcCode;

			for(i=0; i<dfc; i++)
			{
				newsFidInfo = InfoNetManager.newsFids[dfArr[i]];

				if(!newsFidInfo)
				{
					afc.log("NEWS==> FID:" + dfArr[i] + " Not Defined!! SKIP..")
					continue;
				}

				if(newsFidInfo[0]=="STRING")
					value = rcvBuf.nextString(newsFidInfo[1]);
				else 
				{
					if(newsFidInfo[0].charCodeAt(0) == 0x55 /*U*/)
						type = AQuery.UNSIGNED;
					else
						type = AQuery.SIGNED;

					exp = newsFidInfo[2];
					value = rcvBuf.nextType(newsFidInfo[1], type);

					if(exp>0) value = value*Math.pow(10, exp);
					else if(exp<0) value = ( value*Math.pow(10, exp) ).toFixed(exp*-1);
				}

				/**********************************************/
				tmp = new Object();

				if(dfArr[i] == 15503 /* 뉴스 타이틀 */)
				{
					newsTitle = value;
					afc.log("NEWS==> Title" + value);
				}

				if(dfArr[i] == 15531 /* 뉴스 날짜 */)
				{
					/*var yy = value.substring(0, 4);
						var mm = value.substring(4, 6);
						var dd = value.substring(6, 8);
						newsDate = yy + "/" + mm + "/" + dd;*/

					newsDate = value;
					afc.log("NEWS==> Date" + value);
				}

				if(dfArr[i] == 15532 /* 뉴스 시간 */)
				{
					/*var h = value.substring(0, 2);
						var m = value.substring(2, 4);
						newsTime = h + ":" + m;*/

					newsTime = value;
					afc.log("NEWS==> Time" + value);
				}

				if(dfArr[i] == 15511 /* 정보원구분 */)
				{
					newsInfo = value;
					afc.log("NEWS==> 정보원구분" + value);
				}

				if(dfArr[i] == 16013 /* 단축코드 */)
				{
					newsDcCode = value;
					afc.log("NEWS==> 단축코드" + value);
				}

				if(dfArr[i] == 15513 /* 기사분류코드 */)
				{
					newsGisa = value;
					afc.log("NEWS==> 기사분류코드" + value);
				}

				afc.log("NEWS==> Fid" + dfArr[i] + "  VALUE = " + value);

				tmp.key = "27_000000000000_";
				tmp.mid = 27;
				tmp.D1타이틀 = newsTitle;
				tmp.D1입력일자 = newsDate;
				tmp.D1입력시간 = newsTime;
				tmp.D1정보원구분 = newsInfo;
				tmp.D1단축코드 = newsDcCode;
				tmp.D1기사분류코드1 = newsGisa;
			}

			if(this.tmpArray.length < 3){
				if(this.tmpArray.length == 0){
					this.tmpArray.push(tmp);
				}else{
					this.tmpArray.unshift(tmp);
				}
			}
		
			this.newsList.list = this.tmpArray;

			// 	팝업 open상태 체크여부
			var curWin = AWindow.getTopWindow();
			if(curWin){
				this.isOpenerWindow = AWindow.wndList;
				for(var i=0; i < this.isOpenerWindow.length; i++)
				{		
					this.openWin = this.isOpenerWindow[i];
					if(this.openWin.getContainerId() == 'MS0000W7')
					{
						this.openWin.close();
					}
				}
			}

			// 채권속보 팝업
			var win = AWindow.createWindow('MS/window/MS0000_W17.lay', 'MS0000W7');	//공통모달

			win.setWindowOption({
				isAutoCenter: true, 
				isFocusLostClose: false, 
				modalBgOption:'dark'
			});	

			win.title = '채권 속보';
			win.param = this.newsList.list; 
			win.isConfirm = true;
			win.open(this, 0, 0, 500, 0);
		
		}
	}
}

//2017.08 syl 수정 : 계정계 서버 우선 접속으로 변경, 정보계 조회 재시도 여부 확인 추가 
@function InfoNetManager:onSendFail()
{
	this.infoNetSendFail = true; 	
	@super.onSendFail();

}


//2017.08 syl 수정 : 계정계 서버 우선 접속으로 변경, 정보계 조회 재시도 여부 확인 추가 
@function InfoNetManager:sendProcess (aquery, menuNo, groupName, beforeInBlockBuffer, afterOutBlockData)
{	
	if ( this.isConnClosed)
	{
		//afc.log("***syl:  InfoNetManager:sendProcess Connection closed");
		return null; 
	}
	else
	{		
		return @super.sendProcess(aquery, menuNo, groupName, beforeInBlockBuffer, afterOutBlockData);
	}

}