
/**
Constructor
Do not call Function in Constructor.
*/
@class FD0002()
{
	@super();

	//TODO:edit here

}
@extends BasePage;


@function FD0002:onReady()
{
	@super.onReady();

	//TODO:edit here

};

@function FD0002:onMPageGoPageBtnClick(comp, info)
{

	//TODO:edit here
	var thisObj = this;
	var objData = null;
	if (comp.compId.substring(14) == "01" ){
		objData = {tabId:'FD3202_T01', tabSubId:'FD3202_V11', fundCode:'1'};
	} else if(comp.compId.substring(14) == "02" ){
		objData = {tabId:'FD3202_T01', tabSubId:'FD3202_V11', fundCode:'2'};
	} else if(comp.compId.substring(14) == "03" ){	
		objData = {tabId:'FD3202_T01', tabSubId:'FD3202_V11', fundCode:'3'};
	} else {
		objData = {tabId:'FD3202_T02'};
	}
	theApp.goPageCheck('FD3202', false, objData);
	
};

// 연금펀드 진입 팝업 호출...
@function FD0002:onMPageGoPageBtn05Click(comp, info)
{
	//TODO:edit here
	PensionCommon.moveToPensionMainPopup(this);
};

// 연금펀드 진입 팝업 callback...
@function FD0002:callbackPensionPopup(returnData, resultData)
{
	//TODO:edit here
	theApp.navigator.goPage('FrmPage2');
};
