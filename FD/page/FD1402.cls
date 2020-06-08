
/**
Constructor
Do not call Function in Constructor.
** 개인정보 열람청구 **
*/
@class FD1402()
{
	@super();
	this.InfoGrd = null;
	//TODO:edit here
}
@extends BasePage;

@function FD1402:onReady()
{
	@super.onReady();
	
	this.InfoGrd = this.findCompById('InfoGrd');
	
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
	
	this.accView.doInitAccInfo(0);	
};

@function FD1402:onWillDeactive()
{
	@super.onWillDeactive();
	var thisObj = this;
	thisObj.InitView();
	thisObj.secureTxf.clear();
};

@function FD1402:onActiveDone(reload)
{
	@super.onActiveDone(reload);
};

@function FD1402:refreshData()
{
	// 기존 MTS 방식대로 함수만 만들어 둠.
	afc.log(this.getId()+' -> FD1402:refreshData() ');
};

@function FD1402:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

//AccDropView 로드뷰에서 호출하는 함수
@function FD1402:fnDoSendDataManage()
{
	//탭값 초기화
	
	this.accDbx.removeClass('active');
	this.secureTxf.removeClass('active');
	
	this.InitView();
	this.ViewSendData();
		
};

//InitView 테이블 초기화작업
@function FD1402:InitView()
{
	var thisObj = this;
	//초기화	
	
	thisObj.InfoGrd.setCellText(0,1, '');   //성명
	thisObj.InfoGrd.setCellText(1,1, '');   //실명확인번호
	thisObj.InfoGrd.setCellText(2,1, '');   //자택주소
	thisObj.InfoGrd.setCellText(3,1, '');   //자택연락처
	thisObj.InfoGrd.setCellText(4,1, '');   //직업
	thisObj.InfoGrd.setCellText(5,1, '');   //국적
	thisObj.InfoGrd.setCellText(6,1, '');  //이메일
	thisObj.InfoGrd.setCellText(7,1, '');  //이동전화번호1
	thisObj.InfoGrd.setCellText(8,1, '');  //이동전화번호2
};

@function FD1402:ViewSendData()
{
	var thisObj = this
		,cont = thisObj // 연결된 최상위 뷰
		,qrName = "SACMQ509"
		,cipherData = thisObj.secureTxf.getCipherData();
		
	if(!thisObj.accDbx.getSelectedItemData() || !thisObj.accDbx.getSelectedItemData()['D1계좌번호']){
		AToast.show('계좌번호를 선택하세요.');
		this.accDbx.addClass('active');
		return;
	}
	
	if(!afc.isSimulator)
	{
		if(!cipherData)
		{
			AToast.show('계좌 비밀번호를 입력하세요.');
			this.secureTxf.addClass('active');
			return;
		}
	}
	
	var checkObj = {
		svcId : qrName,
		accNo : thisObj.accDbx.getSelectedItemData()['D1계좌번호']
	};
		
	SecurePadManager.cipherToText(cipherData, checkObj, function(result){
	
		cont.sendData(qrName,
			function(queryData, groupName)
			{	
				queryData.setHeaderInfo({
					FUNC_KEY_LST: 'C'
				});

				var InBlock1 = queryData.getBlockData('InBlock1')[0];				

				InBlock1['D1조회구분'] = '2';
				InBlock1['D1계좌번호'] = checkObj.accNo;
				InBlock1['D1비밀번호'] = afc.isSimulator ? '0423' : result;

				queryData.putPwInfo('InBlock1','D1비밀번호');		
				queryData.printQueryData();
			},
			function(queryData, groupName) {

				if(queryData != null){

					queryData.printQueryData();

					var OutBlock1 = queryData.getBlockData('OutBlock1')[0];

					if(!OutBlock1) return;
					thisObj.InfoGrd.setCellText(0,1, OutBlock1['D1구분문자1'] == '1' ? 'O' : 'X');   //성명
					thisObj.InfoGrd.setCellText(1,1, OutBlock1['D1구분문자2'] == '1' ? 'O' : 'X');   //실명확인번호
					thisObj.InfoGrd.setCellText(2,1, OutBlock1['D1구분문자3'] == '1' ? 'O' : 'X');   //자택주소
					thisObj.InfoGrd.setCellText(3,1, OutBlock1['D1구분문자4'] == '1' ? 'O' : 'X');   //자택연락처
					thisObj.InfoGrd.setCellText(4,1, OutBlock1['D1구분문자8'] == '1' ? 'O' : 'X');   //직업
					thisObj.InfoGrd.setCellText(5,1, OutBlock1['D1구분문자9'] == '1' ? 'O' : 'X');   //국적
					thisObj.InfoGrd.setCellText(6,1, OutBlock1['D1구분문자12'] == '1' ? 'O' : 'X');  //이메일
					thisObj.InfoGrd.setCellText(7,1, OutBlock1['D1구분문자10'] == '1' ? 'O' : 'X');  //이동전화번호1
					thisObj.InfoGrd.setCellText(8,1, OutBlock1['D1구분문자11'] == '1' ? 'O' : 'X');  //이동전화번호2					

			}
		});
	});
};

@function FD1402:onBtnInfoClick(comp, info)
{
	Notice.openNoticeMiniWindow(this,"FD1402W01" , 584, null,"메리츠자산운용이 보유중인 고객님의 개인정보 항목을 조회할 수 있는 화면이며, 정보유출 위험이 존재하므로 개인정보 세부내용이 아닌 ‘개인정보 보유항목명’만 조회되도록 구성되어 있습니다.",null,89);
};
