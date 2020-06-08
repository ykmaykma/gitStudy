
/**
메뉴 세트 화면
*/
@class MenuInfo()
{
	this.data = null;
	
	this.menuSet =
	{
		selIdx : 0,	//0:메뉴세트1, 1:메뉴세트2, 2:메뉴세트3
		menuArr:
		[
			{
				name: '메뉴세트1',
				item:
				[
				]
			},
			{
				name: '메뉴세트2',
				item:
				[
				]
			},
			{
				name: '메뉴세트3',
				item:
				[
				]
			}
		]
		
	};
	
	//open이후 메뉴 설정 변경 시, setFNOList() 함수를 통해 회원사 별 초기값 설정 가능 
	// > 변경 이후 고객이 초기화 버튼을 눌러야 적용됨. 아니면 clear 함수 사용 필요
	this.basicSet ={
		selIdx : 0,
		menuArr:[
		{
			name: '메뉴세트1',
			//관심종목/주식현재/TOP종목/주식차트/주식주문/예약주문/특화주문/주식잔고/업종정보/해외지수/환율정보/종합화면/오늘의증시/매매동향/프로그램매매/투자캘린더/금감원공시/종합뉴스/이체서비스
			item:
			[
				'FD1101',
				'FD1201',
				'FD1301',
				'FD1401',
				'FD1501'
			]
		},
		{
			name: '메뉴세트2',
			item:
			[
				'FD2101',
				'FD2201',
				'FD3101',
				'FD3201',
				'FD4101'
			]
		},
		{
			name: '메뉴세트3',
			item:
			[
			]
		}
	]};
	
	this.menuIdMap = {};
	this.menuNameMap = {};
	this.menuAliasMap = {};
	
	this.loginCheckMap = {
		'FrmPage' : 1,
		'FrmPage2' : 1,
		'FD0001': 1
	};
}

/* MARKET별 해당 시장명
0 - 001: 코스피 003: 코스닥 118: 코넥스
1 - ETF
2 - ETN
3 - 068: ELW
4 - 009: 신주인수권
5 - 010: KOTC
6 - 005: 선물 006: 옵션 012: 주식옵션 014: USD 옵션 067: 스타선물(KOSDQ선물)
7 - 091: 주식선물
8 - 016: KTB10년 선물 017: KTB3년 선물 018: JPY 선물 019: EUR 선물 062: KTB5년 선물 103: 미니 선물 104: 미니 옵션 105: CNH 선물 114: GOLD 선물
9 - 099: VKOSPI 선물 100: 섹터선물
10- 002: KOSPI 업종 004: KOSDQ 업종 121: KONEX 업종 167: 섹터 업종
11- 079: 일본지수 080: 홍콩지수 081: 대만지수 082: 상하이 선전 지수 084: 미국지수 086:기타 세계지수
12- 023: 외국환중개(원달러) 047: 해외환율(SPOT&FWD)
13- 161: 장내국채
14- 088 기타 */
MenuInfo.pageRowIdxArr =
[
	['001', '003', '118'],	//0
	['EF'],
	['EN'],
	['068'],
	['009'],
	['010'],	//5
	['005', '006', '012', '014', '067', '103', '104'],//6
	['091'],
	['013', '016', '017', '018', '019', '062', '089', '105', '114', '171'],
	['099', '100'],
	['002', '004', '121', '167'],
	['078','079', '080', '081', '082', '084', '086', '120', '122'],//해외
	['047'],		//환율 '023'은 해당 화면에서 취급?을 하지 않으므로 제거
	['097'],		//금리
	['088']			//기타 14
];


MenuInfo.pageArr = 
[	//0:현재가		  1:기업정보		2:매수		3:매도		4:예약주문		  5:특화주문		6:차트	 7:시간별	8:일별	9:전체뉴스		10:종목뉴스		11:멀티차트		  12:비교차트
	['MS0202_T01', 'MS0202_T17', 'MS0211_T01',	'MS0211_T02',	'MS0213_T01',	'MS0214_T01',	'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0203_T01', '',			 'MS0211_T01',	'MS0211_T02',	'MS0213_T01',	'MS0214_T01',	'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0204_T01', '',			 'MS0211_T01',	'MS0211_T02',	'MS0213_T01',	'MS0214_T01',	'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0205_T01', '',			 'MS0212_T01',	'MS0212_T02',	'MS0213_T01',	'MS0214_T01',	'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	''],
	['MS0206_T01', '',			 'MS0211_T01',	'MS0211_T02', 	'MS0213_T01',	'MS0214_T01',	'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	''],
	
	['MS0207_T01', '',			 '',			'',			 	'',				'',				'MS0218_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0301_T01', '',			 'MS0308_T01',	'MS0308_T02',	'MS0309_T01',	'MS0310_T01',	'MS0305_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0302_T01', '',			 'MS0308_T01',	'MS0308_T02',	'MS0309_T01',	'MS0310_T01',	'MS0305_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0303_T01', '',			 'MS0308_T01',	'MS0308_T02',	'MS0309_T01',	'MS0310_T01',	'MS0305_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0304_T01', '',			 'MS0308_T01',	'MS0308_T02',	'MS0309_T01',	'MS0310_T01',	'MS0305_T01',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	
	['MS0421_T01', 'MS0401_T01', '',			'',				'',				'',				'MS0421_T02',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0422_T01', 'MS0402_T01', '',			'',				'',				'',				'MS0422_T02',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0220_T01',	'MS0219_T01'],
	['MS0423_T01', 'MS0403_T01', '',			'',				'',				'',				'MS0423_T02',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0423_T02',	'MS0423_T02'],
	['MS0424_T01', 'MS0404_T01', '',			'',				'',				'',				'MS0424_T02',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0423_T02',	'MS0423_T02'],
	['MS0425_T01', 'MS0405_T01', '',			'',				'',				'',				'MS0425_T02',	'',		'',	'MS0414_T01',	'MS0414_T01',	'MS0424_T02',	'MS0424_T02']
];

//회원사별 default 메뉴세트 세팅 > systemInfo의 LoadInfo 종료 후 실행
@function MenuInfo:setFNOList()
{
	// 메리츠 자산운용 메뉴세트1 설정
	if(theApp.systemInfo.fno == "951") {
		// 메뉴가 결정되는데로 추가예정. 2017.12.26
		this.basicSet['menuArr'][0]['item'] = 
		[
			'FD1101',
			'FD1201',
			'FD1301',
			'FD1401',
			'FD1501'
		];
	}
	
	//menuset 호출
	this.loadMenuSet();
};

@function MenuInfo:goPageByItem(itemInfo, idx, data, isPage)
{
	theApp.masterInfo.getCodeData(null, itemInfo[0], itemInfo[2], function(rs)
	{
		var item = rs.rows.item(0), mid, rowIdx;
		if(item) itemInfo = [item["scode"], item["fname"], item["market"], item["nftype"]?item["nftype"]:"" ];
		else
		{
			AToast.show("해당 종목은 존재하지 않습니다.");
			return;
		}
		
		mid = itemInfo[2];
 		if(itemInfo[3] == 'EF' || itemInfo[3] == 'EN') mid = itemInfo[3];
		if(idx == 'undefined') idx = 0;

		//회원사에서 제공하는 화면인지 체크  >> 잔고 페이지에서 보유 잔고를 통한 이동(goPageCheck)은 막지 않음
		var firmNoStr	= sprintf('%03d',Number(theApp.systemInfo.fno));
		if($.inArray(mid, theApp.systemInfo.data['Non_Provide_MID'][firmNoStr]) > -1) {
			//해당 mid를 회원사에서 제공하지 않는 경우
			AToast.show("해당종목은 상세정보를 제공하지 않습니다.");
			return;
		}
	
		for(var i=0; i<MenuInfo.pageRowIdxArr.length; i++)
		{
			if($.inArray(mid, MenuInfo.pageRowIdxArr[i]) > -1)
			{
				rowIdx = i;
				break;
			}
		}
		
		if(rowIdx == undefined) return;
		var tabId = MenuInfo.pageArr[rowIdx][idx];
		if(!tabId) tabId = MenuInfo.pageArr[rowIdx][0];
		if(isPage) theApp.goPageCheck(tabId.substr(0,6), false, {item:itemInfo, data:data});
		else theApp.goPageCheck(tabId.substr(0,6), false, {tabId:tabId, item:itemInfo, data:data});
	});
};

@function MenuInfo:loadInfo()
{
	CallbackDone.begin();
	var thisObj = this;
    $.ajax(
    {
    	async:true, url: 'Assets/menu.ini', dataType: 'text',
        success: function(result)
        {
			thisObj.data = JSON.parse(result);
			if(afc.isSimulator) thisObj.setFNOList();	//시뮬레이터가 아니면 SystemInfo에서 수행
			CallbackDone.end();
        },
        
        error: function()
        {
			alert('menu load fail!');
			
			CallbackDone.end();
        }
    });
	
};

@function MenuInfo:loadMenuSet()
{
	var localData = localStorage.getItem("MENUSET");
	if(localData)
	{
		this.menuSet = JSON.parse(localData);
	} 	
	else
	{
		//초기값으로 설정한다.
		this.menuSet = JSON.parse(JSON.stringify(this.basicSet));
	}
};

@function MenuInfo:saveInfo()
{
	localStorage.setItem("MENUSET", JSON.stringify(this.menuSet));	
};

@function MenuInfo:findItemIdx(menuSetIdx, menuId)
{
	var itemArr = this.menuSet.menuArr[menuSetIdx].item;
	for(var i = 0; i<itemArr.length; i++)
	{
		if(itemArr[i] == menuId)
		{
			return i;
		}
	}
	return -1;
};

@function MenuInfo:checkMenuSetItem(menuSetIdx, menuId)
{
	var itemArr = this.menuSet.menuArr[menuSetIdx].item;
	for(var i = 0; i<itemArr.length; i++)
	{
		if(itemArr[i] == menuId)
		{
			return true;
		}
	}
	return false;
};

@function MenuInfo:isLoginCheckPage(pageId)
{
	return this.loginCheckMap[pageId];
};

@function MenuInfo:getPageState(pageId)
{
	if(this.menuIdMap[pageId]) return this.menuIdMap[pageId][1];
	else return -1;
};

@function MenuInfo:isRegPage(pageId)
{
	return (this.menuIdMap[pageId]);
};

@function MenuInfo:getPageId(pageName)
{
	if(this.menuNameMap[pageName]) return this.menuNameMap[pageName][0];
	else return '';
};

@function MenuInfo:getMenuInfo()
{
	return this.data.menuInfo;
};

@function MenuInfo:getSubMenuInfo(idx)
{
	return this.data.menuInfo[idx].children;
};

@function MenuInfo:registerCommonPage(navi)
{
	var subMenuArr = this.getSubMenuInfo(5);
	var lowMenuArr = null;
	var lowMenuOne = null;
	
	for(var j = 0; j <subMenuArr.length; j++ )
	{
		lowMenuArr = subMenuArr[j].children;
		for(var k = 0; k<lowMenuArr.length; k++)
		{
			lowMenuOne = lowMenuArr[k];
			if(lowMenuOne.info[0])
			{
				navi.registerPage('FD/page/'+lowMenuOne.info[1]+'.lay', lowMenuOne.info[1]);
				this.menuIdMap[lowMenuOne.info[1]] = [lowMenuOne.name, lowMenuOne.info[2]];
				this.menuNameMap[lowMenuOne.name] = [lowMenuOne.info[1], ''];
				
				if(this.menuAliasMap[lowMenuOne.name]) {
					this.menuAliasMap[lowMenuOne.name].push('');
				} else {
					this.menuAliasMap[lowMenuOne.name] = [0,''];
				}
			}
		}
	}
	
};

@function MenuInfo:registerSubPage(navi)
{
 	var bigMenuInfoLen = this.data.menuInfo.length-1;
	var bigMenuName = '';
	var subMenuArr = null;
	var lowMenuArr = null;
	var lowMenuOne = null;
	
	for(var i = 0; i < bigMenuInfoLen; i++)
	{
		bigMenuName = this.data.menuInfo[i].name;
		subMenuArr = this.data.menuInfo[i].children;
		for(var j = 0; j <subMenuArr.length; j++ )
		{
			lowMenuArr = subMenuArr[j].children;
			for(var k = 0; k<lowMenuArr.length; k++)
			{
				lowMenuOne = lowMenuArr[k];
				if(lowMenuOne.info[0])
				{
					navi.registerPage('FD/page/'+lowMenuOne.info[1]+'.lay', lowMenuOne.info[1]);
					this.menuIdMap[lowMenuOne.info[1]] = [lowMenuOne.name, lowMenuOne.info[2]];
					this.menuNameMap[lowMenuOne.name] = [lowMenuOne.info[1], bigMenuName];
					
					if(this.menuAliasMap[lowMenuOne.name]) {
						this.menuAliasMap[lowMenuOne.name].push(bigMenuName);
					} else {
						this.menuAliasMap[lowMenuOne.name] = [0,bigMenuName];
					}
				}
			}
		}
	}
};
