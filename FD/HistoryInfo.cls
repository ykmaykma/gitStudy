
/**
Constructor
Do not call Function in Constructor.
*/
@class HistoryInfo()
{
	this.data = 
	[/*
		['1CHL6000', 'CJ E&M 선물 1606', '091'],
		['301L6295', 'KOSPI 200 풋옵션 1606 295.0', '006'],
		['005930', '삼성전자', '001', '', '전기전자'],
		['036630', '세종텔레콤', '003', '', '통신서비스'],
		['049470', 'SGA', '003', '', '소프트웨어'],
		['003520', '영진약품', '001', '', '의 약 품'],
		['015540', '핫텍', '001', '', '서비스업'],
		['232290', 'SGA시스템즈', '118', '', '코넥스']*/
	];
	
	this.defData =
	[
		['005930',	'001'],		//주식
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.STK] +' WHERE nftype = "EF" LIMIT 1'],		//ETF
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.STK] +' WHERE nftype = "EN" LIMIT 1'],		//ETN
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.ELW] +' LIMIT 1'],													//ELW
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.STK] +' WHERE market="009" LIMIT 1'],							//신주인수권
		
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.KOTC] +' LIMIT 1'],												//K-OTC
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.FUT] +' WHERE market="005" ORDER BY expdate, scode limit 1'],	//선물옵션
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.FUT] +' WHERE market="091" ORDER BY expdate, scode limit 1'],	//주식선물
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.FUT] +' WHERE market="114" ORDER BY expdate, scode limit 1'],	//상품선물
		['SELECT * FROM '+ theApp.masterInfo.tbls[MasterInfo.FUT] +' WHERE market="099" ORDER BY expdate, scode limit 1'],	//섹터선물
		
		['0001', '002'],		//업종	코스피
		['EDJI@DJI',	'084'],		//해외	다우존스 산업
		['19USDSP',	'023'],		//환율	달러/원
		['KFIA103006',	'097'],	//금리	국고1년
		['NYM@CL',	'088']		//기타	WTI
	];
	
	this.checkHistory = false;	//히스토리 정보 마스터에서 데이터 사라졌는지 확인여부
}

HistoryInfo.pageMidArr =
[	//현재가	   주문		예약	    특화			차트		종합뉴스
	['MS0202', 'MS0211', 'MS0213',	'MS0214',	'MS0218', 'MS0414', 'MS0220', 'MS0219'],
 	['MS0203', 'MS0211', 'MS0213',	'MS0214',	'MS0218', 'MS0414', 'MS0220', 'MS0219'],
 	['MS0204', 'MS0211', 'MS0213',	'MS0214',	'MS0218', 'MS0414', 'MS0220', 'MS0219'],
	['MS0205', 'MS0212', '',		'',			'MS0218', 'MS0414', 'MS0220', 'MS0219'],
	['MS0206', 'MS0211', '', 		'',			'MS0218', 'MS0414', 'MS0220', 'MS0219'],
	
	['MS0207', 'MS0211', '', 		'',			'MS0218', 'MS0414', 'MS0220', 'MS0219'],
	['MS0301', 'MS0308', 'MS0309',	'MS0310',	'MS0305', 'MS0414', 'MS0220', 'MS0219'],
	['MS0302', 'MS0308', 'MS0309',	'MS0310',	'MS0305', 'MS0414', 'MS0220', 'MS0219'],
	['MS0303', 'MS0308', 'MS0309',	'MS0310',	'MS0305', 'MS0414', 'MS0220', 'MS0219'],
	['MS0304', 'MS0308', 'MS0309',	'MS0310',	'MS0305', 'MS0414', 'MS0220', 'MS0219'],
	
	['MS0421', 'MS0414'											  , 'MS0220', 'MS0219'],
	['MS0422', 'MS0414'],
	['MS0423', 'MS0414'],
	['MS0424', 'MS0414'],
	['MS0425', 'MS0414']
];


//preference 정보 읽어오기
@function HistoryInfo:loadInfo()
{
	//파일 로드함수(우선 로컬스토리지에서 불러옴)
	/*
	var localData = localStorage.getItem("HISTORY");
	var tmp;
	if(localData) this.data = JSON.parse(localData);
	*/
	
	var thisObj = this;
	
	CallbackDone.begin();
	AppManager.getPref('HISTORY', function(result)
	{
		if(result) thisObj.data = JSON.parse(result);
		CallbackDone.end();
	});
	
};

//preference 정보 저장하기
@function HistoryInfo:saveInfo()
{
	//파일세이브 저장함수(우선 로컬 스토리지 저장)
	//localStorage.setItem("HISTORY", JSON.stringify(this.data));
	
	AppManager.setPref("HISTORY", JSON.stringify(this.data));
};

//정보 가져오기
@function HistoryInfo:get()
{
	return this.data;
};

//해당 키로 정보 셋하기
@function HistoryInfo:set(data, unshift)
{
	if(unshift) this.data.unshift(this.data.pop());
	else
	{
		for(var i=this.data.length-1; i>=0; i--)
		{
			if(this.data[i][0] == data[0] && this.data[i][2] == data[2])
			{
				this.data.splice(i, 1);
				break;
			}
		}
		this.data.push(data);
	}
};

//최근에 조회한 종목을 찾는 함수(cntId에 해당하는 종목)
@function HistoryInfo:getRecent(cntId)
{
	//cntId가 없는 경우 market의 구분이 없기 때문에 제일 마지막 종목 리턴
	if(!cntId)
	{
		if(this.data.length > 0) return this.data[this.data.length-1];
		else return null;
	}
	

	var idx = [], arr = null, i, mids, dataIdx;
	
	//test_jk
	if(cntId=='MS0322'){
		cntId='MS0308';
	}
	//container Id 에 해당하는 market 배열의 index를 찾는다.
	for(i=0; i<HistoryInfo.pageMidArr.length; i++)
	{
		arr = HistoryInfo.pageMidArr[i];
		if($.inArray(cntId, arr) > -1)
		{
			idx.push(i);
		}
	}
	
	//alert(afc.log(idx));

	//찾은 index가 여러개일 가능성이 있으므로 여러 market 배열을 하나로 만든다.
	for(i=0; i<idx.length; i++)
	{
		if(!mids) mids = MenuInfo.pageRowIdxArr[idx[i]];
		else mids = mids.concat(MenuInfo.pageRowIdxArr[idx[i]]);
	}
	
	//alert(afc.log(mids));
	//하나로 만든 market 배열에 해당하는 종목의 index를 찾는다.
	for(i=this.data.length-1; i>-1; i--)
	{
		if($.inArray(this.data[i][2], mids) > -1)
		{
			//주식현재가에서 ETN과 ETF인 경우 제외
			if(cntId == 'MS0202' && ($.inArray(this.data[i][3], ['EF', 'EN']) > -1)) continue;
			
			dataIdx = i;
			break;
		}
		//ETF, ETN인 경우
		else if($.inArray(this.data[i][3], mids) > -1)
		{
			dataIdx = i;
			break;
		}
	}
	//alert(afc.log(this.data[dataIdx]));
	
	//찾은 종목을 리턴한다. 
	if(dataIdx != undefined) return this.data[dataIdx];
	else return null;
};

@function HistoryInfo:getDefaultItem(cntId, callback)
{
	var idx, arr = null;
	
	//test_jk
	if(cntId=='MS0322'){
		cntId='MS0308';
	}
	for(var i=0; i<HistoryInfo.pageMidArr.length; i++)
	{
		arr = HistoryInfo.pageMidArr[i];
		if($.inArray(cntId, arr) > -1)
		{
			idx = i;
			break;
		}
	}
	
	if(this.defData[idx].length > 1)
	{
		theApp.masterInfo.getCodeData(null, this.defData[idx][0], this.defData[idx][1], function(rs)
									  {
			var item = rs.rows.item(0);
			var itemInfo = [item["scode"], item["fname"], item["market"], item["nftype"]?item["nftype"]:"" ];

			callback(itemInfo);
		});
	}
	else
	{
		theApp.masterInfo.select(this.defData[idx][0], [], function(rs)
								 {
			var item = rs.rows.item(0);
			var itemInfo = [item["scode"], item["fname"], item["market"], item["nftype"]?item["nftype"]:"" ];

			callback(itemInfo);
		});
	}
};

//히스토리 모든 정보 삭제
@function HistoryInfo:remove(data)
{
	for(var i=this.data.length-1; i>=0; i--)
	{
		if(this.data[i][0] == data[0] && this.data[i][2] == data[2])
		{
			this.data.splice(i, 1);
			break;
		}
	}
	this.saveInfo();
};

//히스토리 모든 정보 삭제
@function HistoryInfo:removeAll()
{
	this.data = [];
	this.saveInfo();
};

//히스토리 정보 중 마스터에서 사라진 데이터 확인 후 삭제
@function HistoryInfo:checkHistoryInfo()
{
	if(this.checkHistory) return;	//이미 확인했으면 리턴
	
	for(var i=this.data.length-1; i>-1; i--)
	{
		if(!theApp.masterInfo.getItemName(this.data[i][0], this.data[i][2]))
		{
			if (this.data[i] != theApp.masterInfo.r_cFutData)
			{
				this.data.splice(i, 1);
			}
		}
	}
};