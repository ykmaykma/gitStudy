
/**
관심종목 관련 정보
*/
@class InterestInfo()
{
	//회원사별 디폴트 관심종목
	this.defData = [];
	
	//사용자 관심종목
	this.data = [];
	
	this.MTSdata = [];
	this.HTSdata = [];
	
	/*
	//임시 사용(나중에 삭제됨)
	this.colText = [
		//'종목명', //고정
		'현재가','대비','등락률','거래량','전일거래량','거래대금','시가','고가','저가','52주신고','52주신저','VI발동','매도호가','매수호가','매도잔량','매수잔량','총매도잔량','총매수잔량'
		,'(외)지분율','PG순매수'
		,'2피봇값','1차저항','피봇값','1차지지','2차지지','체결강도','5MA','20MA','60MA','200MA'
		,'PER','PBR','EPS','시총(10억)','자본(백만)'
		,'LP비중(%)','전환비율','최종거래일','잔존일수'
		,'미결제약정','이론가','괴리율','이론Basis','시장Basis'
		,'메모','업종구분'
	];
	*/
	
	//필드 초기화
	this.interestInit = [0,1,2,3,5,24,26];
	
	//시세, 투자자,기술적분석,재무정보,ELW,선물옵션,계좌정보,기타 배열키정보가 있어야 함..
	//없으면 빈배열키로 해야 함.
	this.colText = [];
	this.colText['시세'] = ['현재가','대비','등락률','거래량','전일거래량','거래대금(백만)','시가','고가','저가','52주신고','52주신저','매도호가','매수호가','매도잔량','매수잔량','총매도잔량','총매수잔량'];
	this.colText['투자자'] = ['(외)지분율','PG순매수'];
	this.colText['기술적 분석'] = ['2차저항','1차저항','피봇값','1차지지','2차지지','체결강도','5MA','20MA','60MA'];
	this.colText['재무정보'] = ['PER','PBR','EPS','시총(10억)','자본(백만)'];
	this.colText['ELW'] = [];
	this.colText['선물옵션'] = [];
	this.colText['계좌정보'] = [];
	this.colText['기타'] = [];
	
	
	this.checkMap = {};
	this.interHistory = [];

	this.grpMaxCount = 50;
	this.itemMaxCount = 50;
};

@function InterestInfo:setData(data)
{
	this.data = data;
};

@function InterestInfo:setMTSData(data)
{
	var tempList = this.data.filter(function(value) {
		return value[2] == 'HTS';
	});
	
	this.checkAndChange(data, tempList);
	this.data = tempList.concat(data).slice(0, 50);
};

@function InterestInfo:setHTSData(data)
{
	var tempList = this.data.filter(function(value) {
		return value[2] != 'HTS';
	});
	
	this.checkAndChange(data, tempList);
	this.data = tempList.concat(data).slice(0, 50);
};

@function InterestInfo:checkAndChange(changeList, oriList)
{
	var thisObj = this;
	changeList.map(function(value) {
		var result = false;
		for(var i=0; i<oriList.length; i++) {
			if(oriList[i][0] == value[0]) {
				result = true;
				break;
			}
		}
		if(result) {
			var j = 1;
			while(thisObj.isNameInList(oriList, value[0] + '_' + j) || thisObj.isNameInList(changeList, value[0] + '_' + j)) {
				afc.log(value[0] + '_' + j + ' pass');
				j++;
			}
			value[0] = value[0] + '_' + j;
		}
	});
};

@function InterestInfo:isNameInList(List, name)
{
	for(var i =0; i< List.length; i++) {
		if(List[i][0] == name) {
			return true;
		}
	}
	return false;
};

// woo
@function InterestInfo:changeGroupName(idx, newName)
{
	if( !this.data[idx])
		return false;

	if(theApp.prefInfo.get("MainInterestGrp") == this.data[idx][0]) {
		theApp.prefInfo.set("MainInterestGrp", newName);
	}
	
	this.data[idx][0] = newName;
		
	return true;
};

// woo 
@function InterestInfo:setInitialization()
{
	var templength = this.data.length;
	this.data.splice(0, templength );
	
	var defDataLength = this.defData.length;
	for( var i = 0; i < defDataLength; i++ )
	{
		var groupName = this.defData[i][0];
		var tempArr = new Array();
		
		var innerArr = this.defData[i][1];
		var innerArrLength = innerArr.length;
		
		for( var j = 0; j < innerArrLength; j++)
		{
			tempArr.push( innerArr[j]);
		}
		
		this.data.push([groupName, tempArr]);
	}
};



// woo
@function InterestInfo:getItemByGroupIdxDef(groupIdx)
{
	if(this.defData[groupIdx][1]) return this.defData[groupIdx][1];
	else return null;
};



// woo
@function InterestInfo:findGroupByName(gName)
{
	var length = this.data.length;
	for( var i = 0; i < length; i++)
	{
		if( gName === this.data[i][0])
			return true;		
	}
	return false;
};


// woo
@function InterestInfo:findGroupByNameExcept(idx, gName)
{
	var length = this.data.length;
	for( var i = 0; i < length; i++)
	{
		if(i === idx) continue;
		if( gName === this.data[i][0])
			return true;		
	}
	return false;
};


//순서변경 - 관심그룹
@function InterestInfo:changeGroupIdxGroup(refArr)
{
	var dataGroup = [];
	refArr.reverse();
	
	for( var i=0; i<refArr.length; i++)	dataGroup.unshift( this.data[ refArr[i] ] );
	
	this.data = [];
	this.data = dataGroup.concat([]);
};



//맨위로 이동 - 관심그룹
@function InterestInfo:moveTopGroup(idxArr)
{
	var dataGroup = [];
	for( var i = idxArr.length-1; i>=0; i--)	
	{
		dataGroup.unshift(this.data.splice(idxArr[i],1)[0]);		
	}
	
	this.data = dataGroup.concat(this.data);
};



//맨아래로 이동 - 관심그룹
@function InterestInfo:moveBottomGroup(idxArr)
{	
	var dataGroup = [];
	
	for( var i = idxArr.length-1; i >= 0; i-- ){
		dataGroup.unshift( this.data.splice(idxArr[i],1)[0]);
	}

	this.data = this.data.concat(dataGroup);
}


//위로 이동 - 관심그룹
@function InterestInfo:moveUpGroup(idxArr)
{
	var idxLen = idxArr.length;
	
	var nextIdx = -1;
	
	for(var i = 0; i<idxLen; i++)
	{
		var index = idxArr[i]-1;
		if(index > -1)
		{
			if(index == nextIdx) continue;
			else this.data.splice(index, 0, (this.data.splice(idxArr[i], 1)[0]));
			
			nextIdx = index;
		}
		else nextIdx = index+1;
	}
	
};


//아래 이동 - 관심그룹
@function InterestInfo:moveDownGroup(idxArr)
{
	var groupLen = this.data.length;
	
	var idxLen = idxArr.length;
	var preIdx = -1;
	
	for(var i = idxLen-1; i>=0; i--)
	{
		index = idxArr[i]+1;
		if(groupLen > index)
		{
			if(index == preIdx) continue;
			else this.data.splice(index, 0, (this.data.splice(idxArr[i], 1)[0]));
			
			preIdx = index;
		}
		else preIdx = index-1;
	}
	
};


@function InterestInfo:getGroupName(groupIdx)
{
	if(this.data[groupIdx])	return this.data[groupIdx][0];
	else return '';
};

@function InterestInfo:getGroupNames()
{
	var resultArr = new Array();
	for(var i = 0; i<this.data.length; i++)
	{
		resultArr.push(this.data[i][0]);
	}
	return resultArr;
};

@function InterestInfo:getGroupType(groupIdx)
{
	if(this.data[groupIdx])	return this.data[groupIdx][0];
	else return '';
};

@function InterestInfo:getGroupTypes()
{
	var resultArr = new Array();
	for(var i = 0; i<this.data.length; i++)
	{
		resultArr.push(this.data[i][2]);
	}
	return resultArr;
};

@function InterestInfo:findIndexByGroupName(groupName)
{
	var groupRow = null;
	for(var i = 0; i<this.data.length; i++)
	{
		groupRow = this.data[i];
		if(groupRow[0] == groupName)
		{
			return i;
		}
	}
	return -1;
};

@function InterestInfo:getItemByGroupName(groupName)
{
	var groupRow = null;
	for(var i = 0; i<this.data.length; i++)
	{
		groupRow = this.data[i];
		if(groupRow[0] == groupName)
			return groupRow[1];
	}
	return null;
};

@function InterestInfo:getItemByGroupIdx(groupIdx)
{
	if(this.data[groupIdx] && this.data[groupIdx][1]) return this.data[groupIdx][1];
	else return null;
};

// woo
// 그룹추가 시점에 addtype을 추가함
// 최상위/최하위 등록
@function InterestInfo:addGroup(groupName, addType)
{
	//등록된 관심종목수가 최대 개수인 경우 리턴
	if(this.data.length == this.grpMaxCount)
	{
		AToast.show('관심그룹은 최대 ' + this.grpMaxCount + '개까지 등록 가능합니다.');
		return -1;
	}

	if(this.findGroupByName(groupName))
	{
		//AToast.show('그룹명이 이미 존재합니다.');
		return 0;
	}
	else
	{		
		// woo 
		// item을 찾을수 없어서 임의로 수정합니다.
		// 그룹이름을 포함함 배열객체를 push해주었습니다.
		//if(!item) data = new Object();
		//var data = new Object();
		var groupArray = [groupName,[] , 'MTS'];
		if( 1 === addType )
		{
			this.data.push(groupArray);
		}
		else
		{
			this.data.unshift(groupArray);
		}
		
		return 1;
	}
};

@function InterestInfo:deleteGroupByName(groupName)
{
	var findGroupIdx = this.findIndexByGroupName(groupName);
	if(findGroupIdx > -1) this.deleteGroupByIdx(findGroupIdx);
};

@function InterestInfo:deleteGroupByIdx(groupIdx)
{
	if(this.data.length > groupIdx) this.data.splice(groupIdx, 1);
};

@function InterestInfo:setItemInfo(groupIdx, itemIdx, itemObj)
{
	for(var key in itemObj)
	{
		this.data[groupIdx][1][itemIdx][key] = itemObj[key];
	}
};

@function InterestInfo:getGroupItems(groupIdx)
{
	return this.data[groupIdx][1];
};

@function InterestInfo:checkExistItemInGroup(groupIdx, itemObj)
{
	var itemOne = null;
	var groupItem = this.data[groupIdx][1];
	for(var i = 0; i<groupItem.length; i++)
	{
		itemOne = groupItem[i];
		if((itemOne[0] == itemObj[0]) && (itemOne[1] == itemObj[1])) return i;
	}

	return -1;
};

//itemObj : [ code, mid ]
@function InterestInfo:addItem(groupIdx, itemObj, isPrepend)
{
	//등록된 관심종목수가 최대 개수인 경우 리턴
	if(this.data[groupIdx][1].length >= this.itemMaxCount) return -1;

	if (Define.PRJ_TYPE == Define.MS && itemObj[0] == theApp.masterInfo.r_cFutData[0])
	{
		AToast.show('연결선물 종목은 등록할 수 없습니다.');
		return;
	};
	
	var idx = this.checkExistItemInGroup(groupIdx, itemObj);
	if(idx > -1)
	{
		return 0;
	}
	else
	{
		if(isPrepend) this.data[groupIdx][1].unshift(itemObj);
		else this.data[groupIdx][1].push(itemObj);
		this.addCheckMap(itemObj);
		
		//itemObj[2] 항목 사용 안함
		/*var thisObj = this;
		var sql = 'SELECT jcode FROM search WHERE market="'+itemObj[1]+'" AND scode="'+itemObj[0]+'"';
		theApp.masterInfo.select(sql, [], function(rs)
		{
			var item = rs.rows.item(0);
			//item이 조회되지 않는 경우, jcode에 공란 처리
			if(item) itemObj[2] = item['jcode']?item['jcode']:'';
			else itemObj[2] = '';
			//관심종목은 수정할때마다 저장
			thisObj.saveInfo();
		});*/
		
		//관심종목은 수정할때마다 저장
		this.saveInfo();
		
		return 1;
	}
};

//itemObj : [ code, mid ]
@function InterestInfo:addItemToForce(groupIdx, itemObj, isPrepend)
{
	//등록된 관심종목수가 최대 개수인 경우 리턴
	if(this.data[groupIdx][1].length >= this.itemMaxCount) return -1;
	
	if (Define.PRJ_TYPE == Define.MS && itemObj[0] == theApp.masterInfo.r_cFutData[0])
	{
		AToast.show('연결선물 종목은 등록할 수 없습니다.');
		return;
	};
	
	var idx = this.checkExistItemInGroup(groupIdx, itemObj);
	if(idx > -1) this.data[groupIdx][1].splice(idx, 1);
	
	if(isPrepend) this.data[groupIdx][1].unshift(itemObj);
	else this.data[groupIdx][1].push(itemObj);
	this.addCheckMap(itemObj);

	//itemObj[2] 항목 사용 안함
/*	var thisObj = this;
	var sql = 'SELECT jcode FROM search WHERE market="'+itemObj[1]+'" AND scode="'+itemObj[0]+'"';
	theApp.masterInfo.select(sql, [], function(rs)
	{
		var item = rs.rows.item(0);
		//item이 조회되지 않는 경우, jcode에 공란 처리
		if(item) itemObj[2] = item['jcode']?item['jcode']:'';
		else itemObj[2] = '';
		//관심종목은 수정할때마다 저장
		thisObj.saveInfo();
	});*/
	
	//관심종목은 수정할때마다 저장
	this.saveInfo();
};
//가져오기
@function InterestInfo:getTempItem(groupIdx, subIdx)
{
	return this.data[groupIdx][1][subIdx][1];
};
//추가
@function InterestInfo:addTempItem(groupIdx, memoStr)
{
	//등록된 관심종목수가 최대 개수인 경우 리턴
	if(this.data[groupIdx][1].length >= this.itemMaxCount) {
		AToast.show('관심종목은 최대 ' + theApp.interestInfo.itemMaxCount + '개까지 등록 가능합니다.');
		return -1;
	}
	
	this.data[groupIdx][1].push(['', memoStr]);
};
//변경
@function InterestInfo:editTempItem(groupIdx, subIdx, menoStr)
{
	this.data[groupIdx][1][subIdx][1] = menoStr;
};

//삭제
@function InterestInfo:deleteItem(groupIdx, itemIdx)
{
	if(this.data[groupIdx][1].length > itemIdx)
	{
		var item = this.data[groupIdx][1][itemIdx];
		this.data[groupIdx][1].splice(itemIdx, 1);
		this.deleteCheckMap(item);
	}
};



//순서변경 - 관심종목
@function InterestInfo:changeItemIdxGroup(groupIdx, refArr)
{
	var dataGroup = [];
	refArr.reverse();
	
	for( var i=0; i<refArr.length; i++)	dataGroup.unshift( this.data[groupIdx][1][ refArr[i] ] );
	
	this.data[groupIdx][1] = [];
	this.data[groupIdx][1] = dataGroup.concat([]);
};



//맨위로 이동 - 관심종목
@function InterestInfo:moveTopItems(groupIdx, idxArr)
{
	var itemArr = this.data[groupIdx][1];
	var preItemArr = new Array();
	for(var i = idxArr.length-1; i>=0; i--)
	{
		preItemArr.unshift(itemArr.splice(idxArr[i], 1)[0]);
	}
	
	this.data[groupIdx][1] = preItemArr.concat(itemArr);
};

//맨아래로 이동 - 관심종목
@function InterestInfo:moveBottomItems(groupIdx, idxArr)
{
	var itemArr = this.data[groupIdx][1];
	var nextItemArr = new Array();
	for(var i = idxArr.length-1; i>=0; i--)
	{
		nextItemArr.unshift(itemArr.splice(idxArr[i], 1)[0]);
	}
	
	this.data[groupIdx][1] = itemArr.concat(nextItemArr);
};


//위로 이동 - 관심종목
@function InterestInfo:moveUpItems(groupIdx, idxArr)
{
	var idxLen = idxArr.length;
	var itemArr = this.data[groupIdx][1];
	
	var nextIdx = -1;
	
	for(var i = 0; i<idxLen; i++)
	{
		var index = idxArr[i]-1;
		if(index > -1)
		{
			if(index == nextIdx) continue;
			else itemArr.splice(index, 0, (itemArr.splice(idxArr[i], 1)[0]));
			
			nextIdx = index;
		}
		else nextIdx = index+1;
	}
};


//아래 이동 - 관심종목
@function InterestInfo:moveDownItems(groupIdx, idxArr)
{
	var itemArr = this.data[groupIdx][1];
	var itemsLen = itemArr.length;
	
	var idxLen = idxArr.length;
	var preIdx = -1;
	
	for(var i = idxLen-1; i>=0; i--)
	{
		index = idxArr[i]+1;
		if(itemsLen > index)
		{
			if(index == preIdx) continue;
			else itemArr.splice(index, 0, (itemArr.splice(idxArr[i], 1)[0]));
			
			preIdx = index;
		}
		else preIdx = index-1;
	}

};

//종목을 다른 관심그룹 이동
@function InterestInfo:cutPasteItem(preGroupIdx, idxArr, nextGroupIdx)
{
	var cutItems = new Array();
	for(var i = idxArr.length-1; i>-1; i--)
	{
		cutItems.push(this.data[preGroupIdx][1].splice(idxArr[i], 1)[0]);
	}
	
	for(var i = cutItems.length-1; i>-1; i--)
	{
		this.addItem(nextGroupIdx, cutItems[i]);
	}
	
};

//종목을 다른 관심그룹 복사
@function InterestInfo:copyPasteItem(preGroupIdx, idxArr, nextGroupIdx)
{
	for(var i = 0; i<idxArr.length; i++)
	{
		this.addItem(nextGroupIdx, this.data[preGroupIdx][1][idxArr[i]]);
	}
};

//item : [ code, mid ] 
@function InterestInfo:addCheckMap(item)
{
	var code = item[0], mid = item[1];
	if(!this.checkMap[mid]) this.checkMap[mid] = {};
	if(this.checkMap[mid][code]) this.checkMap[mid][code]++;
	else this.checkMap[mid][code] = 1;
};

//item : [ code, mid ] 
@function InterestInfo:isExistInterest(item)
{
	var code = item[0], mid = item[1];
	if(!this.checkMap[mid]) return false;
	return this.checkMap[mid][code];
};

//item : [ code, mid ] 
@function InterestInfo:deleteCheckMap(item)
{
	var code = item[0], mid = item[1];
	if(this.checkMap[mid] && this.checkMap[mid][code])
	{
		this.checkMap[mid][code]--;
		if(this.checkMap[mid][code] == 0) delete this.checkMap[mid][code];
	}
};

@function InterestInfo:saveInfo()
{
	var thisObj = this;
	AppManager.setPref('Interest', JSON.stringify(this.data));
};

@function InterestInfo:makeCheckMap()
{
	var groupOne = null, mid = null, code = null;
	for(var i = 0; i<this.data.length; i++)
	{
		groupOne = this.data[i][1];
		for(var j = 0; j<groupOne.length; j++)
		{
			mid = groupOne[j][1];
			code = groupOne[j][0];
			if(!this.checkMap[mid]) this.checkMap[mid] = {};
			if(this.checkMap[mid][code]) this.checkMap[mid][code]++;
			else this.checkMap[mid][code] = 1;
		}
	}
};

@function InterestInfo:loadInfo()//(callback)
{
	var thisObj = this;
	if(!afc.isSimulator)
	{
		CallbackDone.begin();
		AppManager.getPref('Interest', function(result)
		{
			if(result) thisObj.data = JSON.parse(result);
			else thisObj.data = thisObj.defData;
			thisObj.makeCheckMap();
			CallbackDone.end();
		});
	}
	else
	{
		this.defData = theApp.systemInfo.get('FirmInterest');
		this.data = this.defData;
		this.makeCheckMap();
	}
	
};

//CHECK용 관심종목 내려받기
@function InterestInfo:downloadFavoriteData_CHK(cont)
{
	afc.log("######### 관심종목 내려받기 #########");

	var dataObj = {}
		, head = {}
		, body = []
		, thisObj = this
		, UserId = theApp.accNetManager.getHeaderInfo('USER_ID'); 
	
	//헤더형식 데이터 포멧 생성
	head.selGubun = "R";
	head.selID = UserId;
	head.ERR_CODE = "000";
	
	dataObj.header = [head];
	dataObj.Interest = [{}];
	
//afc.log(JSON.stringify(dataObj, null, 2));
	$.ajax({
		url:Define.CINTEREST_URL,
		type:"POST",
		dataType:"json",
		data:JSON.stringify(dataObj),
		async: true
	}).done(function(data){
//afc.log(JSON.stringify(data, null, 2));
		try
		{
			JSON.stringify(data);
		}
		catch(e)
		{
			afc.log("FAIL INTEREST CATCH");
			var tmp = {"header":[{"ERR_CODE": "-001" }]};
			thisObj.receiveIntMsg(tmp);
			return;
		}		
		afc.log("DONE GET INTEREST LIST");
		thisObj.setInterest(data);
		
	}).fail(function(data){
		afc.log("FAIL INTEREST DOWNLOAD");
		var tmp = {"header":[{"ERR_CODE": "-001" }]};
		thisObj.setInterest(tmp);
	});
};

//CHECK용 관심종목 내려받기 > 관심종목 세팅
@function InterestInfo:setInterest(cb)
{
	//afc.log(JSON.stringify(cb, null, 2));
//샘플
//var cb = {"header":[{"selGubun":"W","selID":"KS72000039","ERR_CODE": "000" }],"Interest" :[{"Id":"KS72000039", "GroupIdx":"0", "NEXT":"", "GroupName":"관심종목 1", "Code":"s,067730,108380,037230,102110", "MID":"s,003,003,003,001", "FILLER":""},{"Id":"KS72000039", "GroupIdx":"1", "NEXT":"", "GroupName":"Test 2", "Code":"s,152870,123320,140580,109860", "MID":"s,001,001,001,003", "FILLER":""}, {"Id":"KS72000039", "GroupIdx":"2", "NEXT":"", "GroupName":"abcde", "Code":"s,083660,08537M,068400", "MID":"s,003,003,001", "FILLER":""}, {"Id":"KS72000039", "GroupIdx":"3", "NEXT":"", "GroupName":"1234567890", "Code":"", "MID":"", "FILLER":""}, {"Id":"KS72000039", "GroupIdx":"4", "NEXT":"", "GroupName":"1234567890", "Code":"s,", "MID":"s,", "FILLER":""}, {"Id":"KS72000039", "GroupIdx":"5", "NEXT":"E", "GroupName":"ㄱㅅㅈㅁ", "Code":"s,152870,123320,140580,109860,037230,001750,005930,069500,005490,005380,055550,015760,,1,1,,DJI@DJI,NAS@IXIC", "MID":"s,001,001,001,003,003,001,001,001,001,001,001,001,국내지수,002,004,해외지수,084,084", "FILLER":""}]};

	AIndicator.hide();
	
	if(cb.header[0].ERR_CODE == "000") {
		//사용자 관심종목 초기화
		this.data = [];
		this.checkMap = {};

		var downedData = cb["Interest"];
		if(downedData) {
			//관심종목 데이터 구조체 생성
			for(var i = 0, length = downedData.length; i < length; i++) {
				var dataObj = [];
				var codeDataObj = [];

				var codeList = downedData[i].Code.split(",");
				var MIDList = downedData[i].MID.split(",");

				dataObj.push(downedData[i].GroupName);

				//시작 구분자 s 스킵
				for(var j = 1, length2 = codeList.length; j<length2; j++) {
					var codeData = [];
					codeData.push(codeList[j]);
					codeData.push(MIDList[j]);

					codeDataObj.push(codeData);
				}

				dataObj.push(codeDataObj);
				dataObj.push("MTS");

				this.data.push(dataObj);
			}

			this.makeCheckMap();
			this.saveInfo();

			if(theApp.subNavi.getActivePage().setInterestInfo) theApp.subNavi.getActivePage().setInterestInfo();
			var errMsg = "관심종목 내려받기에 성공하였습니다.";
 			AToast.show(errMsg);
			
		} else {
			var errMsg = "관심종목 내려받기에 실패하였습니다. 다시한번 시도해 주시기 바랍니다.";
 			AToast.show(errMsg);		
		}	
		
	}else if(cb.header[0].ERR_CODE == "001") {
		var errMsg = "서버에 저장된 관심종목이 없습니다.";
 		AToast.show(errMsg);
		
	}else if(cb.header[0].ERR_CODE == "-001") {
		var errMsg = "관심종목 내려받기에 실패하였습니다. 다시한번 시도해 주시기 바랍니다.";
 		AToast.show(errMsg);
		
	}else {
		var errMsg = "[" + cb.header[0].ERR_CODE + "]";
		AToast.show(errMsg);	
	}
};

//CHECK용 관심종목 올리기
@function InterestInfo:uploadFavoriteData_CHK(cont)
{
	var dataObj = {}
		, head = {}
		, body = []
		, thisObj = this
		, UserId = theApp.accNetManager.getHeaderInfo('USER_ID');
	
	//헤더형식 데이터 포멧 생성
	head.selGubun = "W";
	head.selID = UserId;
	head.ERR_CODE = "000";
	
	//헤더 세팅
	dataObj.header = [head];
	
	//관심종목 JSON 포멧 및 body 생성
	dataObj.Interest = [];
	for(var i = 0, length = this.data.length; i < length; i++) {
		var data = {};
		data.Id = UserId;
		data.GroupIdx = i;
		if(i === length-1) {
			data.NEXT = "E";
		} else {
			data.NEXT = "";
		}
		data.GroupName = this.data[i][0];
		
		var Code = "";
		var MID = "";
		
		for(var j = 0, MIDLength = this.data[i][1].length; j < MIDLength; j++) {
			Code = Code + this.data[i][1][j][0] + ",";
			MID = MID + this.data[i][1][j][1] + ",";
		}
		if(MID.indexOf(",") > -1) {
			Code = "s,"+Code;
			MID = "s,"+MID;
		}
		data.Code = Code.substr(0, Code.length-1);
		data.MID = MID.substr(0, MID.length-1);
		data.FILLER = "";
		dataObj.Interest.push(data);
	}
	
	afc.log("######### 관심종목 전송 시작 #########");
	
//afc.log(JSON.stringify(dataObj, null, 2));
	$.ajax({
		url:Define.CINTEREST_URL,
		type:"POST",
		dataType:"json",
		data:JSON.stringify(dataObj),
		async: true
	}).done(function(ret)
	{
		try
		{
			JSON.stringify(ret);
		}
		catch(e)
		{
			afc.log("FAIL INTEREST CATCH");
			var tmp = {"header":[{"ERR_CODE": "-001" }]};
			thisObj.receiveIntMsg(tmp);
			return;
		}
		afc.log("DONE UPDATE INTEREST LIST");
		thisObj.receiveIntMsg(ret);

	}).fail(function(ret){
		afc.log("FAIL INTEREST UPLOAD");
		var tmp = {"header":[{"ERR_CODE": "-001" }]};
		thisObj.receiveIntMsg(tmp);
	});
};

//CHECK용 관심종목 > 서버 결과 전달받기
@function InterestInfo:receiveIntMsg(cb)
{
	AIndicator.hide();
	
	if(cb.header[0].ERR_CODE == "000") {
	
		var errMsg = "관심종목 올리기에 성공하였습니다.";
 		AToast.show(errMsg);
	}else if(cb.header[0].ERR_CODE == "-001") {
	
		var errMsg = "관심종목 올리기에 실패하였습니다. 다시한번 시도해 주시기 바랍니다.";
 		AToast.show(errMsg);
	}else {
	
		var errMsg = "[" + cb.header[0].ERR_CODE + "]";
		AToast.show(errMsg);	
	}
};

//관심종목이 서버에 존재하는지 체크
@function InterestInfo:checkExistFavoriteData(cont)
{
	var thisObj = this;
	cont.sendData('SBPGQ361', null,
	function(queryData, groupName)
	{
		if(queryData)
		{
			var tempOutBlock = new Array();
			var outBlock1 = queryData.getBlockData('OutBlock1');
			
			var engName = '';
			for(var i = 0; i<outBlock1.length; i++)
			{
				engName = outBlock1[i]['D1관심그룹영문명'];
				if(engName == 'New MTS Group')
				{
					tempOutBlock.push(outBlock1[i]);
				}
			}
			outBlock1 = tempOutBlock;
			
			if(outBlock1.length > 0)
			{
				theApp.confirm('<span>서버에 구MTS 관심종목이 있습니다.<br/>신 MTS로 내려받기 하시겠습니까?</span>', function(result){
					if(result)
					{
						theApp.interestInfo.downloadFavoriteData(cont);
					}
					localStorage.setItem('CHECKDATE', afc.dateToString(new Date()));
				});		
			}
		}	
	});
	
};

//관심종목 서버에서 내려받기
@function InterestInfo:downloadFavoriteData(cont)
{
	var thisObj = this;
	this.cont = cont;
	this.grpLen = 0;
	this.curLen = 0;
	this.favoriteArr = null;
	
	AppManager.beginOltp();
	
	this.cont.sendData('SBPGQ361', null,
	function(queryData, groupName)
	{	
		if(queryData)			
		{
			var tempOutBlock = new Array();
			thisObj.outBlock1 = queryData.getBlockData('OutBlock1');
			thisObj.grpLen = thisObj.outBlock1.length;

			
			if(thisObj.grpLen > 0)
			{
				thisObj.favoriteArr = new Array();
				
				var engName = '';
				for(var i = 0; i<thisObj.grpLen; i++)
				{
					engName = thisObj.outBlock1[i]['D1관심그룹영문명'];
					//if(engName == 'New MTS Group')
					if((theApp.systemInfo.fno == '072') || (engName == 'New MTS Group'))
					{
						tempOutBlock.push(thisObj.outBlock1[i]);
					}
				}
				thisObj.outBlock1 = tempOutBlock;
						
				if(thisObj.outBlock1.length > thisObj.grpMaxCount) thisObj.outBlock1.length = thisObj.grpMaxCount;
				
				thisObj.grpLen = thisObj.outBlock1.length;
				
				for(var i = 0; i<thisObj.grpLen; i++)
				{
					thisObj.favoriteArr.push([thisObj.outBlock1[i]['D1관심그룹한글명'], [], 'MTS']);
				}
				
				if(thisObj.favoriteArr.length == 0)
				{
					AppManager.endOltp();
					AToast.show('서버에 저장된 관심종목이 없습니다.');
					return;
				}
				thisObj.getRequestDetailData();
			}
			else
			{
				AppManager.endOltp();
				AToast.show('서버에 저장된 관심종목이 없습니다.');
			}
			
		}
	});

};

@function InterestInfo:downloadHTSFavoriteData(cont)
{
	var thisObj = this;
	this.cont = cont;
	this.grpLen = 0;
	this.curLen = 0;
	this.favoriteArr = null;
	
	AppManager.beginOltp();
	
	this.cont.sendData('SBPGQ361', null,
	function(queryData, groupName)
	{	
		if(queryData)			
		{
			var tempOutBlock = new Array();
			thisObj.outBlock1 = queryData.getBlockData('OutBlock1');
			thisObj.grpLen = thisObj.outBlock1.length;

			
			if(thisObj.grpLen > 0)
			{
				thisObj.favoriteArr = new Array();
				
				var engName = '';
				for(var i = 0; i<thisObj.grpLen; i++)
				{
					engName = thisObj.outBlock1[i]['D1관심그룹영문명'];
					//if(engName == 'New MTS Group')
					if(engName != 'New MTS Group')
					{
						tempOutBlock.push(thisObj.outBlock1[i]);
					}
				}
				thisObj.outBlock1 = tempOutBlock;
						
				if(thisObj.outBlock1.length > thisObj.grpMaxCount) thisObj.outBlock1.length = thisObj.grpMaxCount;
				
				thisObj.grpLen = thisObj.outBlock1.length;
				
				for(var i = 0; i<thisObj.grpLen; i++)
				{
					thisObj.favoriteArr.push([thisObj.outBlock1[i]['D1관심그룹한글명'], [], 'HTS']);
				}
				
				if(thisObj.favoriteArr.length == 0)
				{
					AppManager.endOltp();
					AToast.show('서버에 저장된 관심종목이 없습니다.');
					return;
				}
				thisObj.getRequestDetailData();
			}
			else
			{
				AppManager.endOltp();
				AToast.show('서버에 저장된 관심종목이 없습니다.');
			}
			
		}
	});

};

//관심그룹 하나에 대한 상세 종목 정보 요청
@function InterestInfo:getRequestDetailData()
{
	var thisObj = this;

	//오류메시지 스킵
	theApp.accNetManager.addSkipErrorCode('SBPGQ365', '2679');
	
	this.cont.sendData('SBPGQ365', 
		function(queryData, groupName)
		{
			var InBlock1 = queryData.getBlockData('InBlock1');
			InBlock1[0] = {'D1관심그룹순서' : thisObj.outBlock1[thisObj.curLen]['D1관심그룹순서']};
		},
		function(queryData, groupName)
		{			
			if(queryData)
			{
				var outBlock1 = queryData.getBlockData('OutBlock1');
				
				var detailArr = null;
				var dataOne = null;
				var noMidArr = new Array();
				var noMidCnt = 0;
				if(outBlock1 && (outBlock1.length > 0))
				{
				
					if(outBlock1.length > thisObj.itemMaxCount) outBlock1.length = thisObj.itemMaxCount;
					
					for(var i = 0; i<outBlock1.length; i++)
					{
						dataOne = outBlock1[i];
						if((dataOne['D1관심그룹구분'] == '9') || !dataOne['D1선물옵션종목번호'] || (dataOne['D1선물옵션종목번호'] == 'EMPTY')) thisObj.favoriteArr[thisObj.curLen][1].push(['',dataOne['D1구분명1']]);
						else if(!dataOne['D1시장정보코드'] || dataOne['D1시장정보코드'] == '000')
						{
							thisObj.favoriteArr[thisObj.curLen][1].push([dataOne['D1선물옵션종목번호'], '']);
							noMidArr.push([dataOne['D1선물옵션종목번호'], i]);
						}
						else
						{
							thisObj.favoriteArr[thisObj.curLen][1].push([dataOne['D1선물옵션종목번호'],dataOne['D1시장정보코드']]);
						}
					}
				}
				
				if(noMidArr.length > 0)
				{
					for(var i = 0; i<noMidArr.length; i++)
					{
						(function(curLen, m)
						 {
							theApp.masterInfo.getCodeData(null, noMidArr[m][0], null, function(rs)
							{
								noMidCnt++;
								var item = rs.rows.item(0);
								if(item) thisObj.favoriteArr[curLen][1][noMidArr[m][1]][1] = item["market"];
								
								if(noMidArr.length == noMidCnt)
									thisObj.checkDoneDownload();	
									
							});	
						})(thisObj.curLen, i);
					}
				}
				else thisObj.checkDoneDownload();
			}
		}
	);
};

//관심그룹안에 속한 관심종목을 다 다운 받았는지 체크
@function InterestInfo:checkDoneDownload()
{
	this.curLen++;
	
	if(this.curLen >= this.grpLen)
	{
		if(this.favoriteArr[0][2] == 'MTS') {
			theApp.interestInfo.setMTSData(this.favoriteArr);
		} else {
			theApp.interestInfo.setHTSData(this.favoriteArr);
		}
// 		theApp.interestInfo.setData(this.favoriteArr);
		theApp.interestInfo.saveInfo();
		
		AppManager.endOltp();

		if(theApp.subNavi.getActivePage().setInterestInfo) theApp.subNavi.getActivePage().setInterestInfo();
		localStorage.setItem('ISDOWN', 1);
		
		AToast.show('서버에서 모바일로 관심종목 내려받기가 완료되었습니다.');
	}
	else
	{
		this.getRequestDetailData();
	}
	
};

//관심종목 서버에 업로드
@function InterestInfo:uploadFavoriteData(cont)
{
	var thisObj = this;
	this.cont = cont;
	this.grpSeq = 0;
	this.grpLen = 0;
	this.curLen = 0;
	this.favoriteObj = {};
	this.mtsObj = {};
	var grpIdx = 0, outBlockOne = null;
	
	this.cont.sendData('SBPGQ361', null,
		function(queryData, groupName)
		{
			if(queryData)
			{
				thisObj.outBlock1 = queryData.getBlockData('OutBlock1');
				thisObj.grpLen = thisObj.outBlock1.length;
				
				if(thisObj.grpLen > 0)
				{
					for(var i = 0; i<thisObj.grpLen; i++)
					{
						outBlockOne = thisObj.outBlock1[i];
						grpIdx = outBlockOne['D1관심그룹순서'];
						thisObj.favoriteObj[grpIdx] = (i+1);
						
						//if(outBlockOne['D1관심그룹영문명'] == 'New MTS Group') thisObj.mtsObj[grpIdx] = (i+1);
						if((theApp.systemInfo.fno == '072') || (outBlockOne['D1관심그룹영문명'] == 'New MTS Group')) thisObj.mtsObj[grpIdx] = (i+1);
					}
				}
				thisObj.uploadDetailData();
			}
		}
	);
};

@function InterestInfo:uploadDetailData()
{
	
	var mobileData = theApp.interestInfo.data[this.curLen];
	var detailArr = mobileData[1];
	var detailData = null;
	
	var kbn = '1', mid = '', code = '', text = '';
	
	while(true)
	{
		this.grpSeq++;
		if(!this.favoriteObj[this.grpSeq]) break;
		else if(this.mtsObj[this.grpSeq]) break;
	}
	
	var thisObj = this;
	this.cont.sendData('SBPGT311', 
		function(queryData, groupName)
		{
			
			var InBlock1 = queryData.getBlockData('InBlock1');
			
			InBlock1[0] = {
				'D1처리구분' : (thisObj.favoriteObj[thisObj.grpSeq]) ? '2' : '1',
				'D1관심그룹순서': thisObj.grpSeq,
				'D1관심그룹한글명': mobileData[0],
				'D1관심그룹영문명': 'New MTS Group'
			};
			
			/*
			//BNK용추가
			if(theApp.systemInfo.fno == '086')
			{
				InBlock1[0] = {
					'D1처리구분' : (thisObj.favoriteObj[thisObj.grpSeq]) ? '2' : '1',
					'D1관심그룹순서': thisObj.grpSeq,
					'D1관심그룹한글명': mobileData[0],
					'D1관심그룹영문명': 'New MTS Group'
				};
			}
			else
			{
				InBlock1[0] = {
					'D1처리구분' : (thisObj.favoriteObj[(thisObj.curLen+1)]) ? '2' : '1',
					'D1관심그룹순서': (thisObj.curLen+1),
					'D1관심그룹한글명': mobileData[0],
					'D1관심그룹영문명': ''
				};
			}
			*/
			
			var InBlock2 = queryData.getBlockData('InBlock2');
			InBlock2.length = detailArr.length;

			for(var i = 0; i<detailArr.length; i++)
			{
				detailData = detailArr[i];
				code = detailData[0];
				if(!code)
				{
					kbn = '9';
					text = detailData[1];
				}
				else
				{
					kbn = '1';
					mid = parseInt(detailData[1], 10);
				}

				InBlock2[i] = {
					"D1종목순서": (i+1),
					"D1관심그룹구분": kbn,
					"D1종목대분류코드": "",
					"D1시장정보코드": mid,
					"D1선물옵션종목번호": code,
					"D1매매수량": 0,
					"D1매매단가": 0,
					"D1관심종목수수료": 0,
					"D1매매구분": '',
					"D1구분명1": text,
					"D1글자색": '00000000',
					"D1배경색": 'ffffffff',
					"D1굵은글씨사용여부": 'N'
				};
			}
			
		},
		function(queryData, groupName)
		{
			if(queryData)
			{
				mobileData[2] = 'MTS';
				
				delete thisObj.favoriteObj[thisObj.grpSeq];
				delete thisObj.mtsObj[thisObj.grpSeq];
				
				/*
				if(theApp.systemInfo.fno == '086')
				{
					delete thisObj.favoriteObj[thisObj.grpSeq];
					delete thisObj.mtsObj[thisObj.grpSeq];
				}
				else delete thisObj.favoriteObj[(thisObj.curLen+1)];
				*/
				
				thisObj.curLen++;

				if(thisObj.curLen >= theApp.interestInfo.data.length)
				{
					thisObj.deleteOverData();
				}
				else
				{
					thisObj.uploadDetailData();
				}	
			}
		}
	);
};

@function InterestInfo:deleteOverData()
{
	var thisObj = this;
	
	//var overDataArr = Object.keys((theApp.systemInfo.fno == '086') ? this.mtsObj : this.favoriteObj);
	var overDataArr = Object.keys(this.mtsObj);
	if(overDataArr.length == 0)
	{
		AToast.show('모바일에서 서버로 관심종목을 업로드하였습니다.');
		return;
	}
	else
	{
		var key = overDataArr[0];
		this.cont.sendData('SBPGT311', 
			function(queryData, groupName)
			{
				var InBlock1 = queryData.getBlockData('InBlock1');
				InBlock1[0] = {
					'D1처리구분' : '3',
					'D1관심그룹순서': key,
					'D1관심그룹한글명': '',
					'D1관심그룹영문명': ''
				};
				var InBlock2 = queryData.getBlockData('InBlock2');
			
				InBlock2[0] = {
					"D1종목순서": '1',
					"D1관심그룹구분": '',
					"D1종목대분류코드": "",
					"D1시장정보코드": '',
					"D1선물옵션종목번호": '',
					"D1매매수량": 0,
					"D1매매단가": 0,
					"D1관심종목수수료": 0,
					"D1매매구분": '',
					"D1구분명1": '',
					"D1글자색": '00000000',
					"D1배경색": 'ffffffff',
					"D1굵은글씨사용여부": 'N'
				};
			},
			function(queryData, groupName)
			{
				if(queryData)
				{
					delete thisObj.mtsObj[key];
					/*
					if(theApp.systemInfo.fno == '086') delete thisObj.mtsObj[key];
					else delete thisObj.favoriteObj[key];
					*/
					thisObj.deleteOverData();
				}
			}
		);	
	}
};
