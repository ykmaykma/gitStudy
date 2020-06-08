
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_V09()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD3202_V09:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	
	this.lblFundBuyWord = this.findCompById('lblFundBuyWord');

};


@function FD3202_V09:onActiveDone(reload)
{
	@super.onActiveDone(reload);			
	
	var thisObj = this;
	var cont = thisObj.getContainer();
	
	// 완료 문구 수정
	var lblStepText =[];
	
	if(this.viewData.finishGubun == "1"){
//		this.lblFundBuyWord.setText('펀드매수가 완료되었습니다.');
		lblStepText.push("<span class='font30_3'>펀드매수</span><span class='font30'>가 완료되었습니다.</span>");	
	}else if(this.viewData.finishGubun == "2"){	
//		this.lblFundBuyWord.setText('적립식 매수약정이 완료되었습니다.');
		lblStepText.push("<span class='font30_3'>적립식 매수약정</span><span class='font30'>이 완료되었습니다.</span>");
	}							
				
	thisObj.lblFundBuyWord.$ele.children().eq(0).html(lblStepText);
	
};

@function FD3202_V09:onbtnNextClick(comp, info)
{

	//TODO:edit here		
	
	// 2018.06.11 펀드매수 완료 후 임의식은 오늘의 주문내역으로, 적립식은 적립식 매수현황으로 이동
//	theApp.goPageCheck('FD0002');
	
	if(this.viewData.finishGubun == "1"){
		// 임의식 펀드매수 완료인 경우
		theApp.goPageCheck('FD1201', false, {tabId:'FD1201_T01'});
	
	}else if(this.viewData.finishGubun == "2"){	
		// 적립식 펀드매수 완료인 경우
		theApp.goPageCheck('FD1201', false, {tabId:'FD1201_T02'});
	}
};
