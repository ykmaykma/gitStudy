
/**
Constructor
Do not call Function in Constructor.
** 고객정보조회 변경 **
*/
@class FD1302()
{
	@super();

	//TODO:edit here
}
@extends BasePage;

@function FD1302:onReady()
{
	@super.onReady();
	
	//계좌번호 비밀번호 로드뷰	
	this.accView = this.findCompById('AccView');
	this.accView.viewLoad('FD/view/FD0000_V00.lay');
	
	//계좌드롭박스
	this.accDbx = this.accView.getLoadView().accDbx;
	this.secureTxf = this.accView.getLoadView().secureTxf;
		
	this.newAddrYn = null;
	
	//수령지
	this.balanceDrpBx = this.findCompById('DropBox1');
	this.manageDrpBx = this.findCompById('DropBox2');
	this.etcDrpBx = this.findCompById('DropBox3');
	
	// this.balanceDrpBx.addItem('주소지','01');
	this.balanceDrpBx.addItem('E-MAIL','04');
	this.balanceDrpBx.addItem('SMS','10');
	this.balanceDrpBx.addItem('불원','06');
	
	this.manageDrpBx.addItem('주소지','01');
	this.manageDrpBx.addItem('E-MAIL','04');
	this.manageDrpBx.addItem('불원','06');
	
	this.etcDrpBx.addItem('주소지','01');
	this.etcDrpBx.addItem('E-MAIL','04');
	this.etcDrpBx.addItem('불원','06');
	
	this.zipCode = this.findCompById('TextField1');			//우편번호
	
	this.addr1 = this.findCompById('TextField2');			//자택주소1
	this.addr2 = this.findCompById('TextField3');			//자택주소2
	
	this.homeTelRgno = this.findCompById('DropBox4');		//자택전화번호1
	this.homeTelExno = this.findCompById('TextField4');		//자택전화번호2
	this.homeTelSeqno = this.findCompById('TextField5');	//자택전화번호3

	this.phoneRgno = this.findCompById('DropBox5');			//휴대폰번호1
	this.phoneExno = this.findCompById('TextField9');		//휴대폰번호2
	this.phoneSeqno = this.findCompById('TextField10');		//휴대폰번호3
	
	this.faxRgno = this.findCompById('TextField11');		//기타fax1
	this.faxExno = this.findCompById('TextField12');		//기타fax2
	this.faxSeqno = this.findCompById('TextField13');		//기타fax3
	
	this.email = this.findCompById('TextField14');			//기타Email주소1
	this.emailList = this.findCompById('TextField15');		//기타Email주소2
	
	this.homeTelRgno.addItem('선택','');
	this.homeTelRgno.addItem('02','02');
	this.homeTelRgno.addItem('031','031');
	this.homeTelRgno.addItem('032','032');
	this.homeTelRgno.addItem('033','033');
	this.homeTelRgno.addItem('041','041');
	this.homeTelRgno.addItem('042','042');
	this.homeTelRgno.addItem('043','043');
	this.homeTelRgno.addItem('051','051');
	this.homeTelRgno.addItem('052','052');
	this.homeTelRgno.addItem('053','053');
	this.homeTelRgno.addItem('054','054');
	this.homeTelRgno.addItem('055','055');
	this.homeTelRgno.addItem('061','061');
	this.homeTelRgno.addItem('062','062');
	this.homeTelRgno.addItem('063','063');
	this.homeTelRgno.addItem('064','064');
	this.homeTelRgno.addItem('070','070');
	this.homeTelRgno.addItem('010','010');
	this.homeTelRgno.addItem('011','011');
	this.homeTelRgno.addItem('016','016');
	this.homeTelRgno.addItem('017','017');
	this.homeTelRgno.addItem('018','018');
	this.homeTelRgno.addItem('019','019');
	
	this.phoneRgno.addItem('선택','');
	this.phoneRgno.addItem('010','010');
	this.phoneRgno.addItem('011','011');
	this.phoneRgno.addItem('016','016');
	this.phoneRgno.addItem('017','017');
	this.phoneRgno.addItem('018','018');
	this.phoneRgno.addItem('019','019');
	
	this.homeTelRgno.selectItemByData('');
	this.phoneRgno.selectItemByData('');
};

//공통 계좌필드 비밀번호 입력시
@function FD1302:fnDoSendDataManage()
{				
	if(this.secureTxf.getPwLength() == 0)
	{	
		AToast.show("계좌비밀번호를 입력해주세요.");
		this.secureTxf.addClass('active');
		return;
	}
	this.secureTxf.removeClass('active');

	this.sendSACMT901('C'); // 시작할때 조회	
};

@function FD1302:onWillDeactive()
{
	@super.onWillDeactive();
};

@function FD1302:onWillActive(reload)
{
	@super.onWillActive();

	this.accView.getLoadView().doInitAccInfo(0);
	
};

@function FD1302:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	if(afc.isSimulator) this.sendSACMT901('C');
	else this.fnDoSendDataManage();
};

@function FD1302:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};


//우편번호 검색
@function FD1302:onBtnAddrSearchClick(comp, info)
{
	var win = AWindow.createWindow('FD/window/FD0300_W01.lay','postalWindow');
	win.open(this,0,0,'100%','100%');
	
	win.setWindowOption({isFocusLostClose: true});
};

//편집 확인
@function FD1302:onBtnAddrEditClick(comp, info)
{
	var thisObj = this;
	
	if(thisObj.inputCheck()){
		var accNoIn = this.accDbx.getSelectedItemData()['D1계좌번호'];
		var telNo = this.phoneRgno.getSelectedItemData()+this.phoneExno.getText()+this.phoneSeqno.getText();
		
		theApp.smsCertManager.openSmsCertWindow(accNoIn,true,telNo,function(result,noAgent){
			if(result){
				thisObj.sendSACMT901('5');	//변경
			}
			else if (noAgent) //미성년자 대리인 정보가 없는 경우 
		   	{
				var accNoCplx = thisObj.getFndAccByCplxAcc(accNoIn);
				theApp.smsCertManager.openSmsCertWindow(accNoCplx, true,telNo,function(result2){
			 		if(result2){
			  			thisObj.sendSACMT901('5'); //변경
			 		}
				});
		   	}
		}, true);

	}
};
@function FD1302:getFndAccByCplxAcc(accNoIn)
{
	if(!accNoIn)
		return '';

	//종합계좌에 대해 번호가 같은 투신계좌가 반드시 존재(계좌)하고,
	//메리츠에서만 사용하므로 46으로 하드코딩
	return accNoIn.substring(0,3)+ '46' + accNoIn.substring(5,11);
	
}

//값 체크
@function FD1302:inputCheck()
{
	var thisObj = this;
	var Bns   	= thisObj.balanceDrpBx.getSelectedItemData();
	var Ledg  = thisObj.manageDrpBx.getSelectedItemData();
	var Etc		= thisObj.etcDrpBx.getSelectedItemData();


	if(!this.secureTxf.getText()){
		AToast.show("계좌비밀번호를 입력해주세요.");
		this.secureTxf.addClass('active');
		return;
	}
	if (!Bns)
	{
		AToast.show("잔고/거래내역이 입력되지 않았습니다.");
		return;
	}

	if (!Ledg)
	{
		AToast.show("운용보고서가 입력되지 않았습니다.");
		return;
	}

	if (!Etc)
	{
		AToast.show("기타우편물이 입력되지 않았습니다.");
		return;
	}

	//주소지 선택일때
	if((Bns == "01") || (Ledg == "01") || (Etc == "01"))
	{ 
		if(!thisObj.zipCode.getText() || !thisObj.addr1.getText() || !thisObj.addr2.getText())
		{
			AToast.show("주소지를 입력해주세요.");
			thisObj.zipCode.addClass('active');
			thisObj.addr1.addClass('active');
			thisObj.addr2.addClass('active');
			return;
		}
	}
	//EMail 선택일때
	if((Bns == "04") || (Ledg == "04" ) || (Etc == "04"))
	{ //Email
		if(!thisObj.email.getText() || !thisObj.emailList.getText())
		{
			AToast.show("E-Mail을 입력하세요.");
			thisObj.email.addClass('active');
			thisObj.emailList.addClass('active');
			return;
		}
		if(thisObj.emailList.getText().indexOf(".") == -1){
			AToast.show("E-Mail 형식이 올바르지 않습니다.");
			thisObj.email.addClass('active');
			thisObj.emailList.addClass('active');
			return;
		}
	}
	//SMS 선택일때
	if(Bns=="10")
	{
		if(!thisObj.phoneRgno.getSelectedItemData() || !thisObj.phoneExno.getText() || !thisObj.phoneSeqno.getText())
		{
			AToast.show("휴대폰 번호를 입력하세요.");
			thisObj.phoneExno.addClass('active');
			thisObj.phoneSeqno.addClass('active');
			return;  
		}
	}
	
	if(!thisObj.zipCode.getText() || !thisObj.addr1.getText() || !thisObj.addr2 .getText())
	{
		theApp.alert("긴급한 안내를 위해 주소지를 입력해주세요.");			
		thisObj.zipCode.addClass('active');
		thisObj.addr1.addClass('active');
		thisObj.addr2.addClass('active');
		return;
	}
	return true;	
}

//고객 정보 조회 및 변경 서비스
@function FD1302:sendSACMT901(gubun)
{
	var thisObj = this;	
	
	theApp.accNetManager.sendProcessByName('SACMT901', null, null,
		 function(queryData, groupName){	
				
				queryData.setHeaderInfo(
						{FUNC_KEY_LST: gubun}
				);	
				
				thisObj.accNo = thisObj.accDbx.getSelectedItemData()['D1계좌번호'];
				
				var InBlock1 = queryData.getBlockData('InBlock1');
				
				if(gubun=='C'){		//조회
					InBlock1[0] =
					{		
						'D1계좌번호' : thisObj.accNo,
						'D1비밀번호' :  afc.isSimulator ? '0423' : thisObj.secureTxf.getCipherData()
					};
				}
				else{				//변경
					var zipCode = thisObj.zipCode.getText();
					if(!thisObj.zipCode.getText()) zipCode = zipCode.split('-').join('');
					
					InBlock1[0] =
					{		
						'D1계좌번호' : thisObj.accNo,
						'D1비밀번호' :  afc.isSimulator ? '0423' : thisObj.secureTxf.getCipherData(),
						'D1원장통보주소유형코드' : '06',
						'D1매매통보주소유형코드' : '06',
						'D1기타우편물통보주소유형코드' : thisObj.etcDrpBx.getSelectedItemData(),
						'D1전화지역번호' : thisObj.homeTelRgno.getSelectedItemData(),
						'D1전화국번호' : thisObj.homeTelExno.getText(),
						'D1전화일련번호' :thisObj.homeTelSeqno.getText(),
						'D1자택우편번호' : zipCode ,
						'D1자택동이상주소' : thisObj.addr1.getText(),
						'D1자택주소' : thisObj.addr2 .getText(),
						'D1새주소적용여부' : thisObj.newAddrYn,
						'D1팩스지역번호' : thisObj.faxRgno.getText(),
						'D1팩스국번호' : thisObj.faxExno.getText(),
						'D1팩스일련번호' : thisObj.faxSeqno.getText(),
						'D1휴대폰지역번호' : thisObj.phoneRgno.getSelectedItemData(),
						'D1휴대폰국번호' : thisObj.phoneExno.getText(),
						'D1휴대폰일련번호' : thisObj.phoneSeqno.getText(),
						'D1이메일주소' : thisObj.email.getText() + "@" +thisObj.emailList.getText(),
						'D1반송해지사유코드' : '',
						'D1대표계좌여부' : '',
						'D1처리대상구분' : '',
						'D1투자신탁잔고통보지' : thisObj.balanceDrpBx.getSelectedItemData(),
						'D1자산운용보고서통보지' : thisObj.manageDrpBx.getSelectedItemData()
					};
				}
					queryData.putPwInfo('InBlock1', 'D1비밀번호');
					queryData.printQueryData();
			},
			function(queryData, groupName)
			{
		 		if(!queryData)
				{
					return;
				}
				else
				{
					// 성공
					var outBlock1 = queryData.getBlockData('OutBlock1')[0];
					var InBlock1 = queryData.getBlockData('InBlock1')[0];
					queryData.printQueryData();
					
					thisObj.setFormData(outBlock1, InBlock1);
					if(gubun=='5'){	
						AToast.show("고객정보변경이 완료되었습니다.");
					}
				}
			});	
};

//값 세팅
@function FD1302:setFormData(outBlock1, InBlock1){

	this.balanceDrpBx.selectItemByData(InBlock1['D1투자신탁잔고통보지']);	
	this.manageDrpBx.selectItemByData(InBlock1['D1자산운용보고서통보지']);
	this.etcDrpBx.selectItemByData(InBlock1['D1기타우편물통보주소유형코드']);
	
	this.zipCode.setText(InBlock1['D1자택우편번호']);
	this.addr1.setText(outBlock1['D1자택동이상주소']);
	this.addr2.setText(InBlock1['D1자택주소']);
	
	this.homeTelRgno.selectItemByData(InBlock1['D1전화지역번호']);
	this.homeTelExno.setText(InBlock1['D1전화국번호']);
	this.homeTelSeqno.setText(InBlock1['D1전화일련번호']);
	
	this.faxRgno.setText(InBlock1['D1팩스지역번호']);
	this.faxExno.setText(InBlock1['D1팩스국번호']);
	this.faxSeqno.setText(InBlock1['D1팩스일련번호']);
	
	this.phoneRgno.selectItemByData(InBlock1['D1휴대폰지역번호']);
	this.phoneExno.setText(InBlock1['D1휴대폰국번호']);
	this.phoneSeqno.setText(InBlock1['D1휴대폰일련번호']);
	
	this.newAddrYn=InBlock1['D1새주소적용여부'] ;
		
	if(InBlock1['D1이메일주소']){
		var temp = InBlock1['D1이메일주소'].split('@');
		this.email.setText(temp[0]);
		this.emailList.setText(temp[1]);
	}
};


@function FD1302:onWindowResult(result, awindow)
{
	var winId = awindow.getId();
	
	if(winId == 'postalWindow')
	{
		if(!result) return;	
		
		if(result[0] != null)
		{
			this.zipCode.setText(result[0]);
		}
		if(result[1] != null)
		{
			this.addr1.setText(result[1]);
		}
		if(result[2] != null)
		{
			this.addr2.setText(result[2]);
		}
	}
	
};

//도움말 버튼
@function FD1302:onHelpBtnClick(comp, info)
{
	Notice.openNoticeMiniWindow(this, 'FD1302' , 584, null,null,null,89);
};

@function FD1302:onHighLightTextField(comp, info)
{
	var srchTxt = comp.getText();
	if(srchTxt.length == 0)
	{
	}
	else 
	{
		comp.removeClass('active');
	}

};
