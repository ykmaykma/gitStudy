
/**
Constructor
Do not call Function in Constructor.
*/
@class StockLabel()
{
	@super();

	this.color = stk.getColorCfState;
	this.colorArg = 'D1등락구분';
	this.colorData = null;
	this.setFunc = this.setTextColor;
}
@extends ALabel;

/*
A : 매핑된 값
B : setColorInfo에서 넣은 key에 맞는 값
					0: A,0 비교색		 1: A,B 비교색			2: A 상태값 색			3: B,0 비교색		밝은 배경에서 쓰이는 색상
					4: A,0 비교색		 5: A,B 비교색			6: A 상태값 색			7: B,0 비교색		어두운 배경에서 쓰이는 색상
					8: A,0 비교 배경색상 9: A,B 비교 배경색상  10: A 상태값 배경색상	 11: B,0 비교색	*/
StockLabel.COLOR = [stk.getColorCfZero, stk.getColorCfValue, stk.getColorCfState, stk.getColorValueCfZero,
					stk.getColorCfZero_D, stk.getColorCfValue_D, stk.getColorCfState_D, stk.getColorValueCfZero_D,
					stk.getBgColorCfZero, stk.getBgColorCfValue, stk.getBgColorCfState, stk.getBgColorValueCfZero];

@function StockLabel:init(context, evtListener)
{
	@super.init(context, evtListener);

	//this.loadColorInfo();
};

@function StockLabel:loadColorInfo()
{
	var colorInfo = this.getAttr(afc.ATTR_COLOR);
	if(colorInfo) this.setColorInfo([colorInfo]);
};

// [ "0|D1기준가" ], isBgColor
@function StockLabel:setColorInfo(arr, isBgColor)
{
	if(isBgColor) this.setFunc = this.setBgColor;
	else this.setFunc = this.setTextColor;
	
	if(typeof(arr[0]) == 'function') this.color = arr[0];
	else
	{
		arr = arr[0].toString().split('|');
		if(arr[0]!='')
		{
			if(StockLabel.COLOR[arr[0]]) this.color = StockLabel.COLOR[arr[0]];
			else this.color = eval(arr[0]);
		}
		else this.color = stk.getAsMaskedIt;
		
		this.colorArg = arr[1];
	}
};

@function StockLabel:resetColorInfo()
{
	this.color = null;
};

@function StockLabel:setBgColor(color)
{
	this.setStyle('background', color);
};

@function StockLabel:setQueryData(dataArr, keyArr)
{
	if(!keyArr) return;
	if(dataArr.length==0) return;
	
	//리얼컴포넌트로 등록되면 
	//리얼데이터 수신 시 매핑되지 않은 데이터도 들어온다.	
	var value = dataArr[0][keyArr[0]];
	if(value != undefined) this.setText(value);
	if(dataArr[0][this.colorArg] != undefined) this.colorData = dataArr[0][this.colorArg];
	this.setFunc(this.color(this.data, this.colorData));
};
